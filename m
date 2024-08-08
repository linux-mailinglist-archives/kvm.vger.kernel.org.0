Return-Path: <kvm+bounces-23658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE2F94C683
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 23:55:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A76792832B8
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 21:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA31E15CD7F;
	Thu,  8 Aug 2024 21:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YfCU6iah"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59898158853
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 21:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723154123; cv=none; b=L/QYblRbsjmS0ywSvuqlpCSEgrfgqNl5Bbm6Qhd8D+x2tUeBC1GmB9aylZl1t1MBUtuUA8PaxzqmKXBwM6eWsmFFtc9fwMuzKhsWbBLIxhlc+CajUMwJUI23qcol/GYu0DVsB0Mmtl4WMaS5qRcxSAVQ1p1l1QScna92eJJrgyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723154123; c=relaxed/simple;
	bh=BMV8MGIwoNq7eg6c5quIkLMm6LIlrHrK3hmh7Z2JRoI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j7P8Zd6zBN4Xs6IYGyVMijVSmPt6ynmOz/xpRHon2oVTO6oMxeDDzUjMiG88z5oHDnlbwxcWlNjWaOKDgD6YcFzHHD6BFndpwzhIwCSB/U8HUZCNMWX5BHcgjcFbYVXvkzAACCu+/PdAFJOp2oSTimCeO8gxNNgwF/I0REQ2LGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YfCU6iah; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723154121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k3wrIksGrEilBm2A+K8GdCmrycdMLC/icwH1wgjwvN4=;
	b=YfCU6iahUfhBhLESAD7+jYOC9cgYyC9MBBdJ6ab6MEjQjjV5oULRI0N/xXVM7Y6SNVMaTm
	YINZbte/mjZVwihtcue+mZiqqROJGaxaCAa6KgSf7/DT3tjsoWNZcQxEI5vIUL3eMLH+If
	hdQJm2Cz+Ri8QaWso4km0v4xLaUZlxQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-gXgKvkcsMp2LIUhzyhcong-1; Thu, 08 Aug 2024 17:55:19 -0400
X-MC-Unique: gXgKvkcsMp2LIUhzyhcong-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42820c29a76so10372165e9.2
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 14:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723154117; x=1723758917;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k3wrIksGrEilBm2A+K8GdCmrycdMLC/icwH1wgjwvN4=;
        b=W+DK3OgRgRBRvGHL9LjMv4eGBI2qEzOgfXYGguV6ODBByocpzII8YVmU75eVNmEQ3L
         CPzphVHWNMObg1WuXdO5u44gywi33p5YOc/J2Rh8fbKGrUMjH0l/TmcC1H3MTkMkD/R4
         pl+AG2Dqn2y0d+PzqnuhVAtnwLDQHPv3r/s3ebsYAtTye/Urkb51/JeUeEpYMfC2NFR9
         W6SEbqDeFC2ndWVtYkzNt58WOt/ieOTDym0u4LN+GfEeNSjLxpExo7rRyV5+yTQNUuEl
         ncIrYgkWkk8/aAdBED8zrHzVtGpwfVpqKIKBsHQ6UyFz1Ga2ZOXdcwRroDz4vcoUTRvq
         +HFA==
X-Forwarded-Encrypted: i=1; AJvYcCWH8jBKbXZV7MX50/Z14cBWGFPJKU2qaHbX1D3xaSPV3N63I1OixQBJxtYjPZaeS9nmA+xhwFmzrERZebj4qrzWt62S
X-Gm-Message-State: AOJu0YxRwhYc8ULGwLL+boP93XNP6DsJeTHlKx3dXVMiFUQ/X2BkvEBY
	YHVlA1a2YuuFsV1f1xVtfPx4G532Q87JoS0DawSFuiw3sUsbyh1UrX3XRsWazqU0kMv2f+5apXm
	RBXN+ZlPGht4gM6ADvP0hqiVULZ9ejFcbEGqT6dv2TkibfmBc9w==
X-Received: by 2002:a05:600c:45d0:b0:426:60d7:d299 with SMTP id 5b1f17b1804b1-4290ae99ac6mr27131805e9.7.1723154117399;
        Thu, 08 Aug 2024 14:55:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1X2P2ifl7KjEfzzVADvx2Yez3V8VQTV9J7YgJ62njZVhPj0eKKGqXaxHHLuT355LQdF5TmA==
X-Received: by 2002:a05:600c:45d0:b0:426:60d7:d299 with SMTP id 5b1f17b1804b1-4290ae99ac6mr27131595e9.7.1723154116839;
        Thu, 08 Aug 2024 14:55:16 -0700 (PDT)
Received: from ?IPV6:2003:cb:c713:2a00:f151:50f1:7164:32e6? (p200300cbc7132a00f15150f1716432e6.dip0.t-ipconnect.de. [2003:cb:c713:2a00:f151:50f1:7164:32e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36d2716f333sm3226724f8f.43.2024.08.08.14.55.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 14:55:16 -0700 (PDT)
Message-ID: <6f3b5c38-fc33-43cd-8ab7-5b0f49169d5c@redhat.com>
Date: Thu, 8 Aug 2024 23:55:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 4/4] mm: guest_memfd: Add ability for mmap'ing pages
To: Elliot Berman <quic_eberman@quicinc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Fuad Tabba <tabba@google.com>,
 Patrick Roy <roypat@amazon.co.uk>, qperret@google.com,
 Ackerley Tng <ackerleytng@google.com>, linux-coco@lists.linux.dev,
 linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kvm@vger.kernel.org
References: <20240805-guest-memfd-lib-v1-0-e5a29a4ff5d7@quicinc.com>
 <20240805-guest-memfd-lib-v1-4-e5a29a4ff5d7@quicinc.com>
 <4cdd93ba-9019-4c12-a0e6-07b430980278@redhat.com>
 <20240806093625007-0700.eberman@hu-eberman-lv.qualcomm.com>
 <a7c5bfc0-1648-4ae1-ba08-e706596e014b@redhat.com>
 <20240808101944778-0700.eberman@hu-eberman-lv.qualcomm.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240808101944778-0700.eberman@hu-eberman-lv.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08.08.24 23:41, Elliot Berman wrote:
> On Wed, Aug 07, 2024 at 06:12:00PM +0200, David Hildenbrand wrote:
>> On 06.08.24 19:14, Elliot Berman wrote:
>>> On Tue, Aug 06, 2024 at 03:51:22PM +0200, David Hildenbrand wrote:
>>>>> -	if (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {
>>>>> +	if (!ops->accessible && (gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)) {
>>>>>     		r = guest_memfd_folio_private(folio);
>>>>>     		if (r)
>>>>>     			goto out_err;
>>>>> @@ -107,6 +109,82 @@ struct folio *guest_memfd_grab_folio(struct file *file, pgoff_t index, u32 flags
>>>>>     }
>>>>>     EXPORT_SYMBOL_GPL(guest_memfd_grab_folio);
>>>>> +int guest_memfd_make_inaccessible(struct file *file, struct folio *folio)
>>>>> +{
>>>>> +	unsigned long gmem_flags = (unsigned long)file->private_data;
>>>>> +	unsigned long i;
>>>>> +	int r;
>>>>> +
>>>>> +	unmap_mapping_folio(folio);
>>>>> +
>>>>> +	/**
>>>>> +	 * We can't use the refcount. It might be elevated due to
>>>>> +	 * guest/vcpu trying to access same folio as another vcpu
>>>>> +	 * or because userspace is trying to access folio for same reason
>>>>
>>>> As discussed, that's insufficient. We really have to drive the refcount to 1
>>>> -- the single reference we expect.
>>>>
>>>> What is the exact problem you are running into here? Who can just grab a
>>>> reference and maybe do nasty things with it?
>>>>
>>>
>>> Right, I remember we had discussed it. The problem I faced was if 2
>>> vcpus fault on same page, they would race to look up the folio in
>>> filemap, increment refcount, then try to lock the folio. One of the
>>> vcpus wins the lock, while the other waits. The vcpu that gets the
>>> lock vcpu will see the elevated refcount.
>>>
>>> I was in middle of writing an explanation why I think this is best
>>> approach and realized I think it should be possible to do
>>> shared->private conversion and actually have single reference. There
>>> would be some cost to walk through the allocated folios and convert them
>>> to private before any vcpu runs. The approach I had gone with was to
>>> do conversions as late as possible.
>>
>> We certainly have to support conversion while the VCPUs are running.
>>
>> The VCPUs might be able to avoid grabbing a folio reference for the
>> conversion and only do the folio_lock(): as long as we have a guarantee that
>> we will disallow freeing the folio in gmem, for example, by syncing against
>> FALLOC_FL_PUNCH_HOLE.
>>
>> So if we can rely on the "gmem" reference to the folio that cannot go away
>> while we do what we do, we should be fine.
>>
>> <random though>
>>
>> Meanwhile, I was thinking if we would want to track the references we
>> hand out to "safe" users differently.
>>
>> Safe references would only be references that would survive a
>> private<->shared conversion, like KVM MMU mappings maybe?
>>
>> KVM would then have to be thought to return these gmem references
>> differently.
>>
>> The idea would be to track these "safe" references differently
>> (page->private?) and only allow dropping *our* guest_memfd reference if all
>> these "safe" references are gone. That is, FALLOC_FL_PUNCH_HOLE would also
>> fail if there are any "safe" reference remaining.
>>
>> <\random though>
>>
> 
> I didn't find a path in filemap where we can grab folio without
> increasing its refcount. I liked the idea of keeping track of a "safe"
> refcount, but I believe there is a small window to race comparing the
> main folio refcount and the "safe" refcount.

There are various possible models. To detect unexpected references, we 
could either use

folio_ref_count(folio) == gmem_folio_safe_ref_count(folio) + 1

[we increment both ref counter]

or

folio_ref_count(folio) == 1

[we only increment the safe refcount and let other magic handle it as 
described]

A vcpu could have
> incremented the main folio refcount and on the way to increment the safe
> refcount. Before that happens, another thread does the comparison and
> sees a mismatch.

Likely there won't be a way around coming up with code that is able to 
deal with such temporary, "speculative" folio references.

In the simplest case, these references will be obtained from our gmem 
code only, and we'll have to detect that it happened and retry (a 
seqcount would be a naive solution).

In the complex case, these references are temporarily obtained from 
other core-mm code -- using folio_try_get(). We can minimize some of 
them (speculative references from GUP or the pagecache), and try 
optimizing others (PFN walkers like page migration).

But likely we'll need some retry magic, at least initially.

-- 
Cheers,

David / dhildenb


