Return-Path: <kvm+bounces-56693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19AE9B428AD
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 20:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31AFC3A32D6
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 18:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C5DC3629BA;
	Wed,  3 Sep 2025 18:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b="SNSuEtTk"
X-Original-To: kvm@vger.kernel.org
Received: from unimail.uni-dortmund.de (mx1.hrz.uni-dortmund.de [129.217.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2191F7080D;
	Wed,  3 Sep 2025 18:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.217.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756924187; cv=none; b=Mz7zPnaC3bzY7Wt67hQ4m1Qxr4NKDsMCWqCum5MGoeIGqJ+RR5e87g8oDs6YDt+h+r95lGgVH52DJClgQSOI57J6wz0Zt7ql0KY8ys3tiTHSKOgSAaTOKAJ5JMnPWg832djHCmopvemiZzWtcxG+3bJ+enBp5Hsyy+Se8TJ0UDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756924187; c=relaxed/simple;
	bh=cehNlJaxTRrcDcnzDZIS1lpCvx5tR7CWnbDqFtkqSrU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oyu3nAd3/NXiC2MAJrHDhamrcPSGPFwbMxZq6LF5qe+4VE/n1ZK6fuXl0XGeKEKAaOSrAC+1XInEHnCWSGzZqPH5sigtu5vFmxd0OLlLWOeG+GFMGi+dE87uRt92HgoRij9/g+Zki1zDG0uZvXNuww/UV8N75qdTr+bbofpviIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de; spf=pass smtp.mailfrom=tu-dortmund.de; dkim=pass (1024-bit key) header.d=tu-dortmund.de header.i=@tu-dortmund.de header.b=SNSuEtTk; arc=none smtp.client-ip=129.217.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=tu-dortmund.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tu-dortmund.de
Received: from [192.168.178.143] (pd9eaae6b.dip0.t-ipconnect.de [217.234.174.107])
	(authenticated bits=0)
	by unimail.uni-dortmund.de (8.18.1.10/8.18.1.10) with ESMTPSA id 583ITcPq005603
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 3 Sep 2025 20:29:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tu-dortmund.de;
	s=unimail; t=1756924179;
	bh=cehNlJaxTRrcDcnzDZIS1lpCvx5tR7CWnbDqFtkqSrU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SNSuEtTk4+I6vUrgUvK5S7O/t2TyUoE/a2UpLgjG13TXuEuUpI3xC6ajp+d+/n0cX
	 CHfvSPKZPCV7kKJTInT7H3F7AwFSn4MSz2YxHzQCI9FNTvZt7Bt+tRTglNEcwTxRRk
	 zMytn+QMN4TNWYf9RCvKBOchxBenm9/1cOZYtshc=
Message-ID: <e4355e3f-95fb-47b6-b46e-daf0d5e60417@tu-dortmund.de>
Date: Wed, 3 Sep 2025 20:29:38 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 1/4] ptr_ring_spare: Helper to check if spare capacity of size
 cnt is available
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com, eperezma@redhat.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, Tim Gebauer <tim.gebauer@tu-dortmund.de>
References: <20250902080957.47265-1-simon.schippers@tu-dortmund.de>
 <20250902080957.47265-2-simon.schippers@tu-dortmund.de>
 <20250903085610-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Simon Schippers <simon.schippers@tu-dortmund.de>
In-Reply-To: <20250903085610-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Michael S. Tsirkin wrote:
> On Tue, Sep 02, 2025 at 10:09:54AM +0200, Simon Schippers wrote:
>> The implementation is inspired by ptr_ring_empty.
>>
>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
>> ---
>>  include/linux/ptr_ring.h | 71 ++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 71 insertions(+)
>>
>> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
>> index 551329220e4f..6b8cfaecf478 100644
>> --- a/include/linux/ptr_ring.h
>> +++ b/include/linux/ptr_ring.h
>> @@ -243,6 +243,77 @@ static inline bool ptr_ring_empty_bh(struct ptr_ring *r)
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Check if a spare capacity of cnt is available without taking any locks.
> 
> Not sure what "spare" means here. I think you mean
> 
> Check if the ring has enough space to produce a given
> number of entries.
> 
>> + *
>> + * If cnt==0 or cnt > r->size it acts the same as __ptr_ring_empty.
> 
> Logically, cnt = 0 should always be true, cnt > size should always be
> false then?
> 
> Why do you want it to act as __ptr_ring_empty?
> 
> 
>> + *
>> + * The same requirements apply as described for __ptr_ring_empty.
> 
> 
> Which is:
> 
>  * However, if some other CPU consumes ring entries at the same time, the value
>  * returned is not guaranteed to be correct.
> 
> 
> but it's not right here yes? consuming entries will just add more
> space ...
> 
> Also:
>  * In this case - to avoid incorrectly detecting the ring
>  * as empty - the CPU consuming the ring entries is responsible
>  * for either consuming all ring entries until the ring is empty,
>  * or synchronizing with some other CPU and causing it to
>  * re-test __ptr_ring_empty and/or consume the ring enteries
>  * after the synchronization point.
> 
> how would you apply this here?
> 
> 
>> + */
>> +static inline bool __ptr_ring_spare(struct ptr_ring *r, int cnt)
>> +{
>> +	int size = r->size;
>> +	int to_check;
>> +
>> +	if (unlikely(!size || cnt < 0))
>> +		return true;
>> +
>> +	if (cnt > size)
>> +		cnt = 0;
>> +
>> +	to_check = READ_ONCE(r->consumer_head) - cnt;
>> +
>> +	if (to_check < 0)
>> +		to_check += size;
>> +
>> +	return !r->queue[to_check];
>> +}
>> +
> 
> I will have to look at how this is used to understand if it's
> correct. But I think we need better documentation.
> 
> 
>> +static inline bool ptr_ring_spare(struct ptr_ring *r, int cnt)
>> +{
>> +	bool ret;
>> +
>> +	spin_lock(&r->consumer_lock);
>> +	ret = __ptr_ring_spare(r, cnt);
>> +	spin_unlock(&r->consumer_lock);
>> +
>> +	return ret;
> 
> 
> I don't understand why you take the consumer lock here.
> If a producer is running it will make the value wrong,
> if consumer is running it will just create more space.
> 
>

I agree, I messed up the ptr_ring helper.
Your proposed approach is way superior and I will use that one instead.

The idea behind the cnt was to have an option if the producer may produce
multiple entries like tap_handle_frame with GSO. But of course this should
be in a different patch since I will not cover tap_handle_frame, which is
used by ipvtap and macvtap, in this patch series.

