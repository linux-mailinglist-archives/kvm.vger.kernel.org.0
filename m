Return-Path: <kvm+bounces-64516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 20314C85E6C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:14:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5727E4EA367
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 16:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175FE267AF6;
	Tue, 25 Nov 2025 16:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="ebIH6JJ8"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A436223E25B;
	Tue, 25 Nov 2025 16:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764087173; cv=none; b=OA849cmkfX7NQHYGiXYTFY608kpF6hcjCViH3kIDgsM5VznCIeYYPkj4HAq5TqmYM6H/LRj4xPBTieVE+AC19WQbqLeueHNec8NRkfGabIsgulMCtqFm834G8U+UKJqmsdD0z8UsonqyAWozkVuUzpFZdPB+UQtqv0TuQQP7rGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764087173; c=relaxed/simple;
	bh=ZGjxfZY1T4WtOL0dofyXFExRpRAOlIYSMFqncdvu0is=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i/+/Y10rNfNUCtJVstyH+LP2JxyuYmGnGgJi95d36GvUSJ53cfMF0H1Ute+cqsItUX/Y7AThi5CYoSttO3D+OI/DuJDL2sazojmxQVWigdCVXA6gI10j4nm3Ejy70LsSaMEQoTKuizWBa99hsodS+nk9+ALesvuV0IzyiD4UfME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=ebIH6JJ8; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [129.217.186.248] ([129.217.186.248])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 5APGCZCE009708
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 25 Nov 2025 17:12:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1764087156;
	bh=ZGjxfZY1T4WtOL0dofyXFExRpRAOlIYSMFqncdvu0is=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ebIH6JJ8Kw29xdqIAjIYB7wz6imBtZ6DEcQ9GdgbKlhikr6uFCLzwIKoDaM5Hgccs
	 btqPaCkabwVfS5mCfG9dujRcPYNqIm8ytOQLC3lF6rphlsrLEqeMz9MA5OxaZxfHFj
	 GJ8ajOFDQxzk+qwAUrEMT2cx0ORfQ+wJKsjFj4/w=
Message-ID: <ce371d19-e69a-4d8e-a9a0-f3e20439a094@tu-dortmund.de>
Date: Tue, 25 Nov 2025 17:12:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH net-next v6 2/8] ptr_ring: add helper to check if consume
 created space
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
        jon@nutanix.com, tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux.dev
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <20251120152914.1127975-3-simon.schippers@tu-dortmund.de>
 <20251125095650-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20251125095650-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/25 16:01, Michael S. Tsirkin wrote:
> On Thu, Nov 20, 2025 at 04:29:07PM +0100, Simon Schippers wrote:
>> Add __ptr_ring_consume_created_space() to check whether the previous
>> __ptr_ring_consume() call successfully consumed an element and created
>> space in the ring buffer. This enables callers to conditionally notify
>> producers when space becomes available.
>>
>> The function is only valid immediately after a single consume operation
>> and should not be used after calling __ptr_ring_consume_batched().
>>
>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Co-developed by: Jon Kohler <jon@nutanix.com>
>> Signed-off-by: Jon Kohler <jon@nutanix.com>
>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>> ---
>>  include/linux/ptr_ring.h | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
>> index da141cc8b075..76d6840b45a3 100644
>> --- a/include/linux/ptr_ring.h
>> +++ b/include/linux/ptr_ring.h
>> @@ -453,6 +453,23 @@ static inline int ptr_ring_consume_batched_bh(struct ptr_ring *r,
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Check if the previous consume operation created space
> 
> space?
> 
> what does this mean?
> 
>> + *
>> + * Returns true if the last call to __ptr_ring_consume() has created
>> + * space in the ring buffer (i.e., an element was consumed).
>> + *
>> + * Note: This function is only valid immediately after a single call to
>> + * __ptr_ring_consume(). If multiple calls to ptr_ring_consume*() have
>> + * been made, this check must be performed after each call individually.
>> + * Likewise, do not use this function after calling
>> + * __ptr_ring_consume_batched().
> 
> API-wise, it is a really weird function.  So is 
> 
> {
> 	p = __ptr_ring_consume
> 
> 	return !!p
> }
> 
> guaranteed to be equivalent to 
> 
> {
> 	p = __ptr_ring_consume
> 
> 	return !!__ptr_ring_consume_created_space
> }

I am a bit confused. You were the one recommending this function to me,
see [1].

Maybe the comments need rework here, but the function should be fine.

Thanks

[1] Link: https://lore.kernel.org/netdev/20250922221553.47802-1-simon.schippers@tu-dortmund.de/T/#mb722e8ae4ceb5df24f74305c6145561883d4e987

> 
> 
> 
>> + */
>> +static inline bool __ptr_ring_consume_created_space(struct ptr_ring *r)
>> +{
>> +	return r->consumer_tail >= r->consumer_head;
>> +}
>> +
>>  /* Cast to structure type and call a function without discarding from FIFO.
>>   * Function must return a value.
>>   * Callers must take consumer_lock.
>> -- 
>> 2.43.0
> 

