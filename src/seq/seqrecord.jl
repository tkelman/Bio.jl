# A sequence record is a named sequence with attached metadata.
"""
`SeqRecord{S, T}` is a type holding a named sequence of type `S`, along with
some arbitrary metadata of type `T`.
"""
type SeqRecord{S <: Sequence, T}
    name::StringField
    seq::S
    metadata::T
end

function Base.call{S,T}(::Type{SeqRecord{S,T}})
    return SeqRecord{S,T}(StringField(), S(), T())
end

function SeqRecord(name::AbstractString, seq::Sequence, metadata)
    return SeqRecord(convert(StringField, name), seq, metadata)
end

function seqtype{S, T}(::Type{SeqRecord{S, T}})
    return S
end


# Degelgate sequence operations
"Return a `SeqRecord` holding just the nucleotide at position `i`"
function Base.getindex(seqrec::SeqRecord, i::Integer)
    return SeqRecord(seqreq.name, seqrec.seq[i], seqreq.metadata)
end

"Return a `SeqRecord` holding the specified subsequence"
function Base.getindex(seqrec::SeqRecord, r::UnitRange)
    return SeqRecord(seqrec.name, seqrec.seq[r], seqrec.metadata)
end


function Base.(:(==)){T <: SeqRecord}(a::T, b::T)
    return a.name == b.name && a.seq == b.seq && a.metadata == b.metadata
end


function Base.copy{T <: SeqRecord}(seqrec::T)
    return T(copy(seqrec.name), copy(seqrec.seq), copy(seqrec.metadata))
end


typealias DNASeqRecord{T}       SeqRecord{DNASequence, T}
typealias RNASeqRecord{T}       SeqRecord{RNASequence, T}
typealias AminoAcidSeqRecord{T} SeqRecord{AminoAcidSequence, T}
