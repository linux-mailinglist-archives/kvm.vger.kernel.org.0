Return-Path: <kvm+bounces-47091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97630ABD325
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 11:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9ECED188CAD3
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 09:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B5F264602;
	Tue, 20 May 2025 09:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LJ8ZTSh9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B7B2135D1
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 09:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747732722; cv=none; b=fCNLRq+/rwXWzgz/dgWJuap+zjwFILh9Nt/h5ciMYzMmN4tgucyj7qRBv2hUXnYaR3zWUeYrXoTMteGSWERcIbfgtERMMCmqN5YV4E1D0Bj4SPiOjPBAl2rIj46Nu2IMFeLIocvtbAKEp5zQX9HMcu1TX6I+VNc2iB08IhwRqoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747732722; c=relaxed/simple;
	bh=r+bSdwhoOWSmo9kbZmhnlJ4J6ZQoCdv43wtKV2LA770=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AH2j1+TERyOeTWpZPynYh9UsQl66KwJQ0AxHDLQY1t+QGvxKniwQb5hhfVzVZRR/s6c+oqbmlxhlCjN99RiMS1zyr8ZzDOtJ1XFIofo1n/2yt2lOvoz+m+Irj06MbhbXDBGB3+Qf+sh2rFDjXXDjf7qB+Ih8dfPbAm/yKxEOKhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LJ8ZTSh9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747732719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=97jEMPgZaTswyxP83cUjw4RDQ8Eatm5vDggHnQqNMvs=;
	b=LJ8ZTSh9wzm7NGhZz6uNZsCLjD5Ps13NO/i0kW6yM89u7ViyUv93SzxTR8CigR8LF0q+eZ
	QY4J6i3a6GzpcMw8Zx6RHeWOMmh1cuUzDmx+iZXVPZwGdSTkQlvjtP9B557XzqY2L1/Cpz
	j6upwCSRphKj0LeOlNlaIq0zqbytl2A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-mWSWzEvxNjSHzH_F5x3Nnw-1; Tue, 20 May 2025 05:18:38 -0400
X-MC-Unique: mWSWzEvxNjSHzH_F5x3Nnw-1
X-Mimecast-MFC-AGG-ID: mWSWzEvxNjSHzH_F5x3Nnw_1747732717
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43d209dc2d3so33855695e9.3
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 02:18:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747732717; x=1748337517;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=97jEMPgZaTswyxP83cUjw4RDQ8Eatm5vDggHnQqNMvs=;
        b=xFK3lrQ3qSXnQqGxRc/EcfBCv7N1RDol1lunzZH1tu5L6e32peqX24zZPMvAQ2RA6P
         p64K8BS7ACOy16a/POvz1W/7syt/xjB9DcASKg4+nmDDzmoaZg3Fj9anEHr9whhID1Dc
         m6Ilfk7v9v+f0XCjH3ezu2R1OcRlK9ouBy6SioE74Qd8ZQMjxyVa49t06FWfxQa0ftfN
         dX4lESXquZPcX8ECYrkT1VnVq2oefeN8msb8ksRBATe0/36UOQb4CaEDvoRR8oXL9S9m
         AwJF2hFOkoR60wmlOjEZeRQwvCb2y7jkz6LUDt9VXCAOgydWq672KNQ6+ynhR49ObJKg
         SzIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcu8iPjJ4nifQqRXmN6rb7Js6fo6ml807k6yRWlo+Hqdi/QwaLdk3jdbDtnlvlE2RaJ7c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh1r5aSfEXxKhBtVipG4nAWgKQ7XHviBfGlF0vqK0KuyTKbrx8
	mhOjcVKu7vYjTPV6xaTHsU9KuUjnCCa68l1B3RKCkbMj5XncH/QKABDtZH9fRMBkQnMx64tb5as
	DeuUTwHlkjQQLaDhRLdQKlW93RkMgouC6TzY06fWHItmHHhmOcqPn0w==
X-Gm-Gg: ASbGncv0pqbVrQFkNSFoSSqlMmWza9pWGRGy4Up6y5e01ojO9qsIb2UkvtklfCOlk50
	Tb0TWZPQ+dBf1kN8uj3w/accBHlND3dPoI/RQCct2vgqe4OY8DHj5YKR2uXGeKXpsoA8ZowRUd+
	EnE6O+7f8WvP5ZMdXAM4Wm9OpVuGtBdGCncM0wnDgzq5yRl5f9Gb+4n1GDi6hFQp/f+6PnK2rmJ
	3jhJ9n8jdvhOoLz13qq0PK7eKSeenis8j2lXbSBAGVJJIOZsyvmWzPfADb6HgVrIOad2gOAIdYY
	4+DF+A4rch0Hj91V+e0OQ9BvM87u26RJ/GUS+MU63II=
X-Received: by 2002:a05:600c:3114:b0:442:d9f2:ded8 with SMTP id 5b1f17b1804b1-442fd6444c4mr171607705e9.15.1747732716861;
        Tue, 20 May 2025 02:18:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFD54AHFGMiVgX6dmnUfB8sujP1msuSAvq7Y1e4PaFfIwk3fydgaPVFeKDLBzgK/Yit0aTFpQ==
X-Received: by 2002:a05:600c:3114:b0:442:d9f2:ded8 with SMTP id 5b1f17b1804b1-442fd6444c4mr171607395e9.15.1747732716411;
        Tue, 20 May 2025 02:18:36 -0700 (PDT)
Received: from [192.168.0.7] (ip-109-42-49-201.web.vodafone.de. [109.42.49.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca5beccsm15885378f8f.36.2025.05.20.02.18.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 02:18:36 -0700 (PDT)
Message-ID: <e6174a02-cfb5-4025-9592-4632c5e8e8d1@redhat.com>
Date: Tue, 20 May 2025 11:18:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] KVM: s390: Always allocate esca_block
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>
References: <20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com>
 <20250519-rm-bsca-v2-2-e3ea53dd0394@linux.ibm.com>
 <e5f67090-07a4-4818-b83e-33386313b2af@redhat.com>
 <DA0UM5YL6IFH.1KE7UH4H6XBZM@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <DA0UM5YL6IFH.1KE7UH4H6XBZM@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20/05/2025 10.35, Christoph Schlameuss wrote:
> On Tue May 20, 2025 at 7:41 AM CEST, Thomas Huth wrote:
>> On 19/05/2025 13.36, Christoph Schlameuss wrote:
>>> Instead of allocating a BSCA and upgrading it for PV or when adding the
>>> 65th cpu we can always use the ESCA.
>>>
>>> The only downside of the change is that we will always allocate 4 pages
>>> for a 248 cpu ESCA instead of a single page for the BSCA per VM.
>>> In return we can delete a bunch of checks and special handling depending
>>> on the SCA type as well as the whole BSCA to ESCA conversion.
>>>
>>> As a fallback we can still run without SCA entries when the SIGP
>>> interpretation facility or ESCA are not available.
>>>
>>> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
>>> ---
>>>    arch/s390/include/asm/kvm_host.h |   1 -
>>>    arch/s390/kvm/interrupt.c        |  67 ++++-------------
>>>    arch/s390/kvm/kvm-s390.c         | 159 ++++++---------------------------------
>>>    arch/s390/kvm/kvm-s390.h         |   4 +-
>>>    4 files changed, 42 insertions(+), 189 deletions(-)
>>
>> Could you now also remove struct bsca_block from the kvm_host_types.h header?
>>
> 
> We still need these to support sigp with bsca in vsie. (Once I have that
> running properly.)

Ah, ok!

>> ...
>>> diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
>>> index 8d3bbb2dd8d27802bbde2a7bd1378033ad614b8e..2c8e177e4af8f2dab07fd42a904cefdea80f6855 100644
>>> --- a/arch/s390/kvm/kvm-s390.h
>>> +++ b/arch/s390/kvm/kvm-s390.h
>>> @@ -531,7 +531,7 @@ int kvm_s390_handle_per_event(struct kvm_vcpu *vcpu);
>>>    /* support for Basic/Extended SCA handling */
>>>    static inline union ipte_control *kvm_s390_get_ipte_control(struct kvm *kvm)
>>>    {
>>> -	struct bsca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
>>> +	struct esca_block *sca = kvm->arch.sca; /* SCA version doesn't matter */
>>
>> You might want to adjust/remove the comment here now.
>>
> 
> Yes. This does not make any sense anymore. But it is already completely removed
> along with that whole message in the next patch.

Right, so likely not worth to respin just because of this.
Thus feel free to add:

Reviewed-by: Thomas Huth <thuth@redhat.com>


