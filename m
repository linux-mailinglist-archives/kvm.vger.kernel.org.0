Return-Path: <kvm+bounces-67526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC56D079B1
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 08:36:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4EF15300D43A
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 07:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A01D2ECD39;
	Fri,  9 Jan 2026 07:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="WeG9LUEu"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48538230D1E;
	Fri,  9 Jan 2026 07:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767944154; cv=none; b=dbZgUv2UGVs8m++OtaZB9lfNtaHo2as8EfaySYpHuxa1Fh+Mjrkulr6acBQ4EPNJWI6uaLo2dg6fkV8h9EEAzRYMagPX3glpvmODYG9EeCq+FsIntY6dVVEY+fx0Y69DIckioNQtTcHwfIaqEuCRNSnIF5lfwnweSFKXqeA3u0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767944154; c=relaxed/simple;
	bh=vQ1jlAXICdy5+XaVk5J4yY1+jcwsUmfQ1OsFcWSL/0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t/ckOxgial4vnlkVFoA9VcJ6PEuXqpcuu7a3wHUDlOLJMCGjNLMCO9XAhJQpNPgxmeVzisOwD0oGXft8HlDwnixI5YtLcY9GX56+kBgU6a/PTIryGkShFzXwoARmcbcFKLyu9AihPvX1t8HSb2KA0waeTa8hMIiNCtfMNP/Fc7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=WeG9LUEu; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [129.217.186.165] ([129.217.186.165])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.16/8.18.1.16) with ESMTPSA id 6097ZV8A018492
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Jan 2026 08:35:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1767944132;
	bh=vQ1jlAXICdy5+XaVk5J4yY1+jcwsUmfQ1OsFcWSL/0o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WeG9LUEuJqjH6CuY6V50oc7c7sVAK3iKzMFT0Budxt6rWloeEpBM9wV2doWGCAAov
	 wE6xh18KL02K3u76UExVaXAqJIQb56+B8MPmKQ0kqXRT1BtP7SumixPSQHNdjFWOAa
	 6tt57u5a+x5OpTSZTHGltPs7mSTPe8L0iy9J+RFM=
Message-ID: <a0d5d875-9a9c-4bfe-8943-c7b28185c083@tu-dortmund.de>
Date: Fri, 9 Jan 2026 08:35:31 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v7 2/9] ptr_ring: add helper to detect newly freed
 space on consume
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
        leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
        tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-3-simon.schippers@tu-dortmund.de>
 <20260109021023-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20260109021023-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/9/26 08:22, Michael S. Tsirkin wrote:
> On Wed, Jan 07, 2026 at 10:04:41PM +0100, Simon Schippers wrote:
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
>>  	return ret;
>>  }
>>  
>> +/* Returns true if the consume of the last n elements has created space
>> + * in the ring buffer (i.e., a new element can be produced).
>> + *
>> + * Note: Because of batching, a successful call to __ptr_ring_consume() /
>> + * __ptr_ring_consume_batched() does not guarantee that the next call to
>> + * __ptr_ring_produce() will succeed.
> 
> 
> I think the issue is it does not say what is the actual guarantee.
> 
> Another issue is that the "Note" really should be more prominent,
> it really is part of explaining what the functions does.
> 
> Hmm. Maybe we should tell it how many entries have been consumed and
> get back an indication of how much space this created?
> 
> fundamentally
> 	 n - (r->consumer_head - r->consumer_tail)?

No, that is wrong from my POV.

It always creates the same amount of space which is the batch size or
multiple batch sizes (or something less in the wrap-around case). That is
of course only if __ptr_ring_zero_tail() was executed at least once,
else it creates zero space.

> 
> 
> does the below sound good maybe?
> 
> /* Returns the amound of space (number of new elements that can be
>  * produced) that calls to ptr_ring_consume created.
>  *
>  * Getting n entries from calls to ptr_ring_consume() /
>  * ptr_ring_consume_batched() does *not* guarantee that the next n calls to
>  * ptr_ring_produce() will succeed.
>  *
>  * Use this function after consuming n entries to get a hint about
>  * how much space was actually created.
> 
> 
> 
> 
> 
>> + */
>> +static inline bool __ptr_ring_consume_created_space(struct ptr_ring *r,
>> +						    int n)
>> +{
>> +	return r->consumer_head - r->consumer_tail < n;
>> +}
>> +
>>  /* Cast to structure type and call a function without discarding from FIFO.
>>   * Function must return a value.
>>   * Callers must take consumer_lock.
>> -- 
>> 2.43.0
> 

