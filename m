Return-Path: <kvm+bounces-20225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC8191202E
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 11:10:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F49E1C21DCC
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 09:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73FAC16DED6;
	Fri, 21 Jun 2024 09:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b0qIaDK5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3237D16D32E
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 09:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718961020; cv=none; b=Tw562KNhZ62yOzEmOqwda77qTunYDCH6jxdm6e9VtCEiV/3f6a1bn/Rr6kAyBGpp32nv7x8k05+1WbiRZ1JVS9HKmOPW6jPAZkobYin1qQ9e1LEyb7sseRBX8NE9ihl/vBgiyHAR4aZdiNFD2RpO1xcpwpXq/uOkna799eM5r8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718961020; c=relaxed/simple;
	bh=dG8ontMkTSewrc/LNzIbCPSnZVnWuN0xsvIe9bkTG7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y6tGleZdX2N+J9LkiQ1R5oVM36jnAr+oWcPRtAikoGm3lG5drPEqPzPMRgojtN8Mpai3NS7U2eUylrGPKuKNxt61LMGZ/+WMnSnXHS8RZyB1J4PTYJ/ZKj/iBwSfXQxt+6SbAz36oYHaTalWsZ6gUAlp4BF6pvopskkdvBjtCUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b0qIaDK5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718961017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gYejcBX91Zhx9zBhD+bnNzE1FrYHOgpUiQ+y0qItqUU=;
	b=b0qIaDK5qkn14rmCiJIk+9GJRyGnxL9Eju95bhBmMZO7DvgnwlkApmx6j/HCO8l/wAW8ry
	uujWNl6XVlohN3cikh7MBrT/hZPO+a6M/30QP0NxLFYFAZa86sHE36cC3sFlGJRaFYueW5
	9AgVeo/zBGeR5YQWCWnvqUx/vR2yaXY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-438-WbDZV8phP9G_jFQSbpsw6A-1; Fri, 21 Jun 2024 05:10:15 -0400
X-MC-Unique: WbDZV8phP9G_jFQSbpsw6A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4210d151c5bso14596965e9.3
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 02:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718961014; x=1719565814;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gYejcBX91Zhx9zBhD+bnNzE1FrYHOgpUiQ+y0qItqUU=;
        b=d0v5WYZv0NsEToWlvWQuiF/6eh/+2m8gHX49jx/nBU+mYEnsK4U35DBVZXRdijkXGs
         pDmtvgR4wdfEUjfImJFXm5LBNge12k4+0ce/MrbJaprJa3xKa3ekwUzCts+Hvt8MpXbD
         fkeV4JJYsvwkfQ77uguvYJ1JYFAlxquLl8+mn8HY7Bf64Y+k4HauQQjcFUT08L03bJzD
         raq2lq1pMCniQ6SdTcnSI9Ys4RCDoJd8EGKf91igOiTXBCe/mHhvyJs81v3mv2mv4H/g
         ZAqcw/DdBAoTa66SB6w2eyl7yaF4wUAvi23r6+DAyMrqn/3un9v4F62JnjS/hblVRsRc
         9NjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJ5vG9hIYVoCdsKDPaOZ3itbo4ub9h5k7ZxmJVUxBeGqMy3OymXumRWTTx+8nz+cswnsS3UxH6UzZqFHd959S9PlqY
X-Gm-Message-State: AOJu0YwbOcjZk5YZJ9uObo3gevAngk/t9pfWqHIU/x2ynmerAzUH0z3s
	8ZlXBNNilthA31S9dIlZDUzoE0KiF4RQJmyuWNCXTR3tS1ZCTSvvbWJi3mEDCXGPd9VhrDyTXb+
	w5rZWu87B8VeIDBvGbTLbYohf260H+a4xzMswFoGVX9zKG8Yy/w==
X-Received: by 2002:a05:600c:1d05:b0:424:7780:ffc3 with SMTP id 5b1f17b1804b1-424778101b9mr48375255e9.5.1718961014327;
        Fri, 21 Jun 2024 02:10:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGU90oPuoG7ZEQHn11qd8u510OI3LfnmEaaKKjLepvgJT1/MBU6PiG7DAfnb5yOTq9erHiYHw==
X-Received: by 2002:a05:600c:1d05:b0:424:7780:ffc3 with SMTP id 5b1f17b1804b1-424778101b9mr48375035e9.5.1718961013836;
        Fri, 21 Jun 2024 02:10:13 -0700 (PDT)
Received: from ?IPV6:2003:cb:c725:e600:4063:2059:fd18:9d65? (p200300cbc725e60040632059fd189d65.dip0.t-ipconnect.de. [2003:cb:c725:e600:4063:2059:fd18:9d65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-366383f6d16sm1140229f8f.3.2024.06.21.02.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jun 2024 02:10:13 -0700 (PDT)
Message-ID: <8e9436f2-6ebb-4ce1-a44f-2a941d354e2a@redhat.com>
Date: Fri, 21 Jun 2024 11:10:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/5] mm/gup: Introduce exclusive GUP pinning
To: Fuad Tabba <tabba@google.com>, David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe
 <jgg@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
 Elliot Berman <quic_eberman@quicinc.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, maz@kernel.org, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 pbonzini@redhat.com
References: <20240618-exclusive-gup-v1-0-30472a19c5d1@quicinc.com>
 <7fb8cc2c-916a-43e1-9edf-23ed35e42f51@nvidia.com>
 <14bd145a-039f-4fb9-8598-384d6a051737@redhat.com>
 <CA+EHjTxWWEHfjZ9LJqZy+VCk43qd3SMKiPF7uvAwmDdPeVhrvQ@mail.gmail.com>
 <20240619115135.GE2494510@nvidia.com>
 <CA+EHjTz_=J+bDpqciaMnNja4uz1Njcpg5NVh_GW2tya-suA7kQ@mail.gmail.com>
 <ZnRMn1ObU8TFrms3@google.com>
 <CA+EHjTxvOyCqWRMTS3mXHznQtAJzDJLgqdS0Er2GA9FGdxd1vA@mail.gmail.com>
 <4c8b81a0-3a76-4802-875f-f26ff1844955@redhat.com>
 <CA+EHjTzvjsc4DKsNFA6LVT44YR_1C5A2JhpVSPG=R9ottfu70A@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTzvjsc4DKsNFA6LVT44YR_1C5A2JhpVSPG=R9ottfu70A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21.06.24 10:54, Fuad Tabba wrote:
> Hi David,
> 
> On Fri, Jun 21, 2024 at 9:44 AM David Hildenbrand <david@redhat.com> wrote:
>>
>>>> Again from that thread, one of most important aspects guest_memfd is that VMAs
>>>> are not required.  Stating the obvious, lack of VMAs makes it really hard to drive
>>>> swap, reclaim, migration, etc. from code that fundamentally operates on VMAs.
>>>>
>>>>    : More broadly, no VMAs are required.  The lack of stage-1 page tables are nice to
>>>>    : have; the lack of VMAs means that guest_memfd isn't playing second fiddle, e.g.
>>>>    : it's not subject to VMA protections, isn't restricted to host mapping size, etc.
>>>>
>>>> [1] https://lore.kernel.org/all/Zfmpby6i3PfBEcCV@google.com
>>>> [2] https://lore.kernel.org/all/Zg3xF7dTtx6hbmZj@google.com
>>>
>>> I wonder if it might be more productive to also discuss this in one of
>>> the PUCKs, ahead of LPC, in addition to trying to go over this in LPC.
>>
>> I don't know in  which context you usually discuss that, but I could
>> propose that as a topic in the bi-weekly MM meeting.
>>
>> This would, of course, be focused on the bigger MM picture: how to mmap,
>> how how to support huge pages, interaction with page pinning, ... So
>> obviously more MM focused once we are in agreement that we want to
>> support shared memory in guest_memfd and how to make that work with core-mm.
>>
>> Discussing if we want shared memory in guest_memfd might be betetr
>> suited for a different, more CC/KVM specific meeting (likely the "PUCKs"
>> mentioned here?).
> 
> Sorry, I should have given more context on what a PUCK* is :) It's a
> periodic (almost weekly) upstream call for KVM.
> 
> [*] https://lore.kernel.org/all/20230512231026.799267-1-seanjc@google.com/
> 
> But yes, having a discussion in one of the mm meetings ahead of LPC
> would also be great. When do these meetings usually take place, to try
> to coordinate across timezones.

It's Wednesday, 9:00 - 10:00am PDT (GMT-7) every second week.

If we're in agreement, we could (assuming there are no other planned 
topics) either use the slot next week (June 26) or the following one 
(July 10).

Selfish as I am, I would prefer July 10, because I'll be on vacation 
next week and there would be little time to prepare.

@David R., heads up that this might become a topic ("shared and private 
memory in guest_memfd: mmap, pinning and huge pages"), if people here 
agree that this is a direction worth heading.

-- 
Cheers,

David / dhildenb


