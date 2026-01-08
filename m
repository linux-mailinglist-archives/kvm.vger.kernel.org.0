Return-Path: <kvm+bounces-67353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DBC9BD01620
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 08:21:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0B37A3026F0D
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 07:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD2E733BBDF;
	Thu,  8 Jan 2026 07:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="E5IszURW"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E3632ABEC;
	Thu,  8 Jan 2026 07:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767856856; cv=none; b=Bdm1gItxLXm4dPF9v6BBPtE3/lVafojKCyenOSs88z5lDKfzVgBvFy2QJOngcNiIq/GMVTDbuEybDgJ/efdtbvS8JvvlbFfHqRnZ1cAtDRRnulF2ZqsZsRcbPihg68qLH4emdedWg3aKIN8YVwL8JdDBBKUXqzpNYy/IBqfH20A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767856856; c=relaxed/simple;
	bh=WgSXEC/bvAwqYjz3NQOqPT+hYzUhtjm2L0+DMjgjk7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0qPwIyJ3we1OWAR//Z5YnYPhC53sc7RKXn9Z5zoy6sQv6uELzaHSxJoQXJyGEfzIIF7VQ3TBDd3KKzWKjtif0Fu+vOdFFcsPHGbWiVodUkWs4QQinDn/Ii1PByEPiYs8+Af73JWvTEbSpYFvjI6FpI6Wibo8wexSqWJKU9eKFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=E5IszURW; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.121] (p5dc880d2.dip0.t-ipconnect.de [93.200.128.210])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 6087KTle001867
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 8 Jan 2026 08:20:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767856831;
	bh=WgSXEC/bvAwqYjz3NQOqPT+hYzUhtjm2L0+DMjgjk7U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E5IszURWUJy4pzcldz6ggvfCPSDap3Cde4qFGVBw1LFDUHyQywL3CIHQuCCnLcAxG
	 uDcD+4dzvHv4HgglrD6mQTQGM0odsZJeJajAzWEQpaznAUCcNuZSNofdNdEpq/lz4O
	 EEz+53zVkvlgXexoXGCQZ+qvjH2a9n5PUGiftAyU=
Message-ID: <ba3cffe3-b514-435d-88a8-f20c91be722a@tu-dortmund.de>
Date: Thu, 8 Jan 2026 08:20:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v7 2/9] ptr_ring: add helper to detect newly freed
 space on consume
To: Jason Wang <jasowang@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, eperezma@redhat.com,
        leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
        tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-3-simon.schippers@tu-dortmund.de>
 <CACGkMEsHxu_iyL+MjJG834hBGNy9tY9f3mAEeZfDn5MMwtuz8Q@mail.gmail.com>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <CACGkMEsHxu_iyL+MjJG834hBGNy9tY9f3mAEeZfDn5MMwtuz8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/8/26 04:23, Jason Wang wrote:
> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
>>
>> This proposed function checks whether __ptr_ring_zero_tail() was invoked
>> within the last n calls to __ptr_ring_consume(), which indicates that new
>> free space was created. Since __ptr_ring_zero_tail() moves the tail to
>> the head - and no other function modifies either the head or the tail,
>> aside from the wrap-around case described below - detecting such a
>> movement is sufficient to detect the invocation of
>> __ptr_ring_zero_tail().
>>
>> The implementation detects this movement by checking whether the tail is
>> at most n positions behind the head. If this condition holds, the shift
>> of the tail to its current position must have occurred within the last n
>> calls to __ptr_ring_consume(), indicating that __ptr_ring_zero_tail() was
>> invoked and that new free space was created.
>>
>> This logic also correctly handles the wrap-around case in which
>> __ptr_ring_zero_tail() is invoked and the head and the tail are reset
>> to 0. Since this reset likewise moves the tail to the head, the same
>> detection logic applies.
>>
>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>> ---
>>  include/linux/ptr_ring.h | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
>> index a5a3fa4916d3..7cdae6d1d400 100644
>> --- a/include/linux/ptr_ring.h
>> +++ b/include/linux/ptr_ring.h
>> @@ -438,6 +438,19 @@ static inline int ptr_ring_consume_batched_bh(struct ptr_ring *r,
>>         return ret;
>>  }
>>
>> +/* Returns true if the consume of the last n elements has created space
>> + * in the ring buffer (i.e., a new element can be produced).
>> + *
>> + * Note: Because of batching, a successful call to __ptr_ring_consume() /
>> + * __ptr_ring_consume_batched() does not guarantee that the next call to
>> + * __ptr_ring_produce() will succeed.
> 
> This sounds like a bug that needs to be fixed, as it requires the user
> to know the implementation details. For example, even if
> __ptr_ring_consume_created_space() returns true, __ptr_ring_produce()
> may still fail?

No, it should not fail in that case.
If you only call consume and after that try to produce, *then* it is
likely to fail because __ptr_ring_zero_tail() is only invoked once per
batch.

> 
> Maybe revert fb9de9704775d?

I disagree, as I consider this to be one of the key features of ptr_ring.

That said, there are several other implementation details that users need
to be aware of.

For example, __ptr_ring_empty() must only be called by the consumer. This
was for example the issue in dc82a33297fc ("veth: apply qdisc
backpressure on full ptr_ring to reduce TX drops") and the reason why
5442a9da6978 ("veth: more robust handing of race to avoid txq getting
stuck") exists.

> 
>> + */
>> +static inline bool __ptr_ring_consume_created_space(struct ptr_ring *r,
>> +                                                   int n)
>> +{
>> +       return r->consumer_head - r->consumer_tail < n;
>> +}
>> +
>>  /* Cast to structure type and call a function without discarding from FIFO.
>>   * Function must return a value.
>>   * Callers must take consumer_lock.
>> --
>> 2.43.0
>>
> 
> Thanks
> 

