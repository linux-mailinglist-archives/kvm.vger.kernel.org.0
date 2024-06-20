Return-Path: <kvm+bounces-20081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 842FF9107C5
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 16:15:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B19CB1C21029
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 14:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476E51AD9FD;
	Thu, 20 Jun 2024 14:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FrwDPoFM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CE31AD9D1
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 14:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718892874; cv=none; b=pFrkRQbs4kmeER5HPLl/n5JcYSBTCvCKV9bSYfU0b3M1OEP7cSDkG3ojbmFnobnyRlqu5SWs3I3id0lNzbmMbiC8yuIX0qaIShLlFXjFOyAKbjFZS8n3O7sH3upCyk6HjANRLwf9IBs4kSzMpEzToRoRfGFmi7L9ARw4fbIefEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718892874; c=relaxed/simple;
	bh=+A5n0VgholTG/5KXvYQzlGgbOvrmJOn/c9i4a3yDERw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WIj/yhDuyy+9C7rR+jqHVYZE9Lssp/5Ts8y1bslnM5+oLTegkZ2VbMOUt5FBPtRSwG9cK2pBXl2GVRHbbrAw5CahVWefM/2NVI/sxLZuNQL6OfU11pgxlAJkKW6mKMiNaw6HbfiHC1Ni0jhEDGO5+bRv5jcW8DJMMydpF1iqFW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FrwDPoFM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718892870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8YHhV1KpFjJzx2FPMSuwc2xc9dElDmjLPcw5n3EHpx8=;
	b=FrwDPoFMNzMO3ZFgcRoJ5t6h9s2MI5qb7v24DYxwW1f1bS3rgFzB+PhiRjguvAoUKt8OVx
	OUCVCpttybtP80AiDkuXtiyTJi5f0vU1l+XwU9FH16fIFDNjbycs2b3sP+r0BO1EDOjROZ
	Vx9juC2gRH1vS7HeAUxflJk1YjmwCVg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-JAjH5rdQOx6mdwFGyCSXVQ-1; Thu, 20 Jun 2024 10:14:27 -0400
X-MC-Unique: JAjH5rdQOx6mdwFGyCSXVQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3653f54d94eso270743f8f.2
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 07:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718892866; x=1719497666;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8YHhV1KpFjJzx2FPMSuwc2xc9dElDmjLPcw5n3EHpx8=;
        b=LTgJVUibWJG+OQux7XqV4hAWL/cM4631ycXXezUB6v78j4s7pG9oXzsI1iv34czTyL
         4dTgsqhr2Qtao6S4vg/+bNXgeZNN+pOB3WdkHoSL/3w/YSJebn2JcmkC0NpF9zfdgQK9
         RXzTI6ZHBVuO4PwUmJjCodnMAApAQy3OJrurT3Jd9tslmXN17vkWQdiiMEX30gZgk6sP
         ZAvVAYDihfQOuwxY3D4Qc26eJNceo5u4kVSGy/SkRQU01xoi3OYyfo79eT8D0wHAOJMn
         h4xB5wYHcdcReOJ6Wgv8HZ9DgPEXU7p9d0Ifv67RmUfOgeWcwY91TxBZ1h1JBIbFuvLU
         oo8g==
X-Forwarded-Encrypted: i=1; AJvYcCWERRvxNNL/Q9sBUzGl8LEUgwkQWpHB75gON+gBZhs7BowxWXGBRl0T1GYfqxEOQZ+I/UHii3brv0gE5NSpvjQ+BZft
X-Gm-Message-State: AOJu0YxdBp5JGIKmSAEAndwwIqrzY9vROwSGF2dHsvIrO9jSeJoH7GbR
	feGAiL0kPaMR9ruyLgtaQDqUK/QZc0sX4TAiSQgemfvE+R+6OZNIUzlyF9HeBYCMyZYiAErjqZi
	SdUd0hkwIebDbBBeMXcs2uoM0p2vbnlj1RI7LxVo1DPpQJ0TW1A==
X-Received: by 2002:adf:fa49:0:b0:362:c971:d97c with SMTP id ffacd0b85a97d-36319a85fc4mr4043901f8f.63.1718892866388;
        Thu, 20 Jun 2024 07:14:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjBTFGDhSICBWeqaJ/g+1siYAs4hTMdRuzQ/UcpNoH8Mfb7Z30LbIVlGJzMcwVyzuH8D+uPg==
X-Received: by 2002:adf:fa49:0:b0:362:c971:d97c with SMTP id ffacd0b85a97d-36319a85fc4mr4043880f8f.63.1718892865896;
        Thu, 20 Jun 2024 07:14:25 -0700 (PDT)
Received: from ?IPV6:2003:cb:c719:5b00:61af:900f:3aef:3af3? (p200300cbc7195b0061af900f3aef3af3.dip0.t-ipconnect.de. [2003:cb:c719:5b00:61af:900f:3aef:3af3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36387d9b812sm4468939f8f.26.2024.06.20.07.14.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 07:14:25 -0700 (PDT)
Message-ID: <1ab73f42-9397-4fc7-8e62-2627b945f729@redhat.com>
Date: Thu, 20 Jun 2024 16:14:23 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] mm/gup: Introduce exclusive GUP pinning
To: Mostafa Saleh <smostafa@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>,
 Elliot Berman <quic_eberman@quicinc.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, maz@kernel.org, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 pbonzini@redhat.com, Fuad Tabba <tabba@google.com>,
 Jason Gunthorpe <jgg@nvidia.com>
References: <20240618-exclusive-gup-v1-0-30472a19c5d1@quicinc.com>
 <7fb8cc2c-916a-43e1-9edf-23ed35e42f51@nvidia.com>
 <14bd145a-039f-4fb9-8598-384d6a051737@redhat.com>
 <ZnQpslcah7dcSS8z@google.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZnQpslcah7dcSS8z@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.06.24 15:08, Mostafa Saleh wrote:
> Hi David,
> 
> On Wed, Jun 19, 2024 at 09:37:58AM +0200, David Hildenbrand wrote:
>> Hi,
>>
>> On 19.06.24 04:44, John Hubbard wrote:
>>> On 6/18/24 5:05 PM, Elliot Berman wrote:
>>>> In arm64 pKVM and QuIC's Gunyah protected VM model, we want to support
>>>> grabbing shmem user pages instead of using KVM's guestmemfd. These
>>>> hypervisors provide a different isolation model than the CoCo
>>>> implementations from x86. KVM's guest_memfd is focused on providing
>>>> memory that is more isolated than AVF requires. Some specific examples
>>>> include ability to pre-load data onto guest-private pages, dynamically
>>>> sharing/isolating guest pages without copy, and (future) migrating
>>>> guest-private pages.  In sum of those differences after a discussion in
>>>> [1] and at PUCK, we want to try to stick with existing shmem and extend
>>>> GUP to support the isolation needs for arm64 pKVM and Gunyah.
>>
>> The main question really is, into which direction we want and can develop
>> guest_memfd. At this point (after talking to Jason at LSF/MM), I wonder if
>> guest_memfd should be our new target for guest memory, both shared and
>> private. There are a bunch of issues to be sorted out though ...
>>
>> As there is interest from Red Hat into supporting hugetlb-style huge pages
>> in confidential VMs for real-time workloads, and wasting memory is not
>> really desired, I'm going to think some more about some of the challenges
>> (shared+private in guest_memfd, mmap support, migration of !shared folios,
>> hugetlb-like support, in-place shared<->private conversion, interaction with
>> page pinning). Tricky.
>>
>> Ideally, we'd have one way to back guest memory for confidential VMs in the
>> future.
>>
>>
>> Can you comment on the bigger design goal here? In particular:
>>
>> 1) Who would get the exclusive PIN and for which reason? When would we
>>     pin, when would we unpin?
>>
>> 2) What would happen if there is already another PIN? Can we deal with
>>     speculative short-term PINs from GUP-fast that could introduce
>>     errors?
>>
>> 3) How can we be sure we don't need other long-term pins (IOMMUs?) in
>>     the future?
> 
> Can you please clarify more about the IOMMU case?
> 
> pKVM has no merged upstream IOMMU support at the moment, although
> there was an RFC a while a go [1], also there would be a v2 soon.
> 
> In the patches KVM (running in EL2) will manage the IOMMUs including
> the page tables and all pages used in that are allocated from the
> kernel.
> 
> These patches don't support IOMMUs for guests. However, I don't see
> why would that be different from the CPU? as once the page is pinned
> it can be owned by a guest and that would be reflected in the
> hypervisor tracking, the CPU stage-2 and IOMMU page tables as well.

So this is my thinking, it might be flawed:

In the "normal" world (e.g., vfio), we FOLL_PIN|FOLL_LONGTERM the pages 
to be accessible by a dedicated device. We look them up in the page 
tables to pin them, then we can map them into the IOMMU.

Devices that cannot speak "private memory" should only access shared 
memory. So we must not have "private memory" mapped into their IOMMU.

Devices that can speak "private memory" may either access shared or 
private memory. So we may have"private memory" mapped into their IOMMU.


What I see (again, I might be just wrong):

1) How would the device be able to grab/access "private memory", if not
    via the user page tables?

2) How would we be able to convert shared -> private, if there is a
    longterm pin from that IOMMU? We must dynamically unmap it from the
    IOMMU.

I assume when you're saying "In the patches KVM (running in EL2) will 
manage the IOMMUs  including the page tables", this is easily solved by 
not relying on pinning: KVM just knows what to update and where. (which 
is a very different model than what VFIO does)

Thanks!

-- 
Cheers,

David / dhildenb


