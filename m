Return-Path: <kvm+bounces-32535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2800A9D9C21
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 18:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6751164BBB
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 17:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF45E1DB344;
	Tue, 26 Nov 2024 17:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZruYUkxI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B29B1DA0E3
	for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732641055; cv=none; b=qUybi5T4zMJAAOzJ3ZmhToq4mQXldKB9ugL1/aoLtzQwIMNQz8kt5nHSUrdCF294kGIPjxDY76KnrBLmn6KB0qM1Yoxd+Qe4H2FYLE+qz9NW1iNCvwK1MG0rSwuZb07/rDBSy0AWiM+CT8c+iAlHXVYEsrxufd7jIKk7afIFiVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732641055; c=relaxed/simple;
	bh=ZyGBNBNeIbh195o6EdpIawljBTKhqraCODqJVGMKWF8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=an3EhYvMEovSDz1AR1gtj8ZWVveZ9thzLSjoVSxbObEw14201lOvs8MofiFMKWeUKXi7oCnycTcvjWkkvyR8jasbr6JiKCCz7fs+kB8ITf1DrhpeoEDxaQ65RXqTf8y9RIgaEY0s5sH5sE6Dh8GgnfZbH34Y3EOqNz47RxfmIHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZruYUkxI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732641052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pg1WH4/I0jZVgF7EzjYgTyBHdR/uKOZ3f0DDPVvbwns=;
	b=ZruYUkxItInIhU72F4QuXHCNarhlOncN+34MI+Z9QZsfhYoEWVDJcyQh9rswedpzY/0bxe
	kWbvqOqu9Wt4ZbZzpci5FBoQDHk6iQPgVqNoPdi2cxrW4QsCTQ5JLU6WOYW3QPO3uamBP5
	U87BNBwWyiDzMVBrP5LCTGscTFtsXls=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-7pF8BOSMNuqBL-cR_gZYxw-1; Tue, 26 Nov 2024 12:10:51 -0500
X-MC-Unique: 7pF8BOSMNuqBL-cR_gZYxw-1
X-Mimecast-MFC-AGG-ID: 7pF8BOSMNuqBL-cR_gZYxw
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-84386a9b7e2so159742739f.1
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 09:10:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732641047; x=1733245847;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pg1WH4/I0jZVgF7EzjYgTyBHdR/uKOZ3f0DDPVvbwns=;
        b=HKt2TvUYyTjZm2yenOE4YWFd5z068Jd7wRDdRCYaMsKyP5JXaNjRTlXFiLyBYZ4PCO
         GDrSWjqfU93sFEOuthz8skf4V07o2HQo8msM1PBWyji//6NBSJ5hKhf2B0IZ/elzO8fV
         Nkg5HoFBaVZjHx1c9e3bYMXSO7/3vJLpHvetPmMMLEZNj7jEyq8EfYiRGdIVZxpY0EY+
         1cDIgMSWOyVicoBL2AJ0X/IJzXN1wfulY6kIyasGvt3vL44az3wmRX8ngDjV3hWYMtv5
         MoWzSkK4qvLPaLhanW4gtzyV6Bxxa1vfgxeqDOK2CfgeYzx6s9k3eXY3CCD27BdVPuPy
         UrLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXKSS+y5GCAzfkebr8UhS5JbAo2XJARX6f9H8ehZXUp9AkOP3ISTRC8wNR/zc8qKlCDAvE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcGaU37cvBNcia0deLRydOArMswXbnQOeZ0qnExty5bWkZ+GwE
	2aI3xG9X7aicbO2PvoqfNds2GcX2JWTpvZ2Z6hbpblO5dlbD2sfU35KMhkFHN1Hmc+bCfcMf6zj
	MfDXzMt5+inDXlOLLHIitp2y5XLzyMvO/V+UIreBMQnlQtfr+lg==
X-Gm-Gg: ASbGncuX7VJvpiWQmCFBLnmM5R/wWxGAcRdLZ2RKcQ5aZzKID5SMB2vMSW54G1ZbYu5
	Q/n+gZmtAiwRCQmaTTMPfX3ir1wGRo7A/65wMt3NvMrduKuWe69yGO6sLFIfGd0rzR7UUzssBd3
	aBZdtIdiEJevbl5G+eY0507lVRzk/FFnSf27OwYHuq3GjiGOIg9TvyHjr5ksvefmDa3nPEvsbNh
	Bw4VHMFwNjVki6L3kxEPoeQ36yfGMaaxDOVzlqIla/ckX+VGdA=
X-Received: by 2002:a05:6e02:16ce:b0:3a7:8a39:269e with SMTP id e9e14a558f8ab-3a79aeea927mr188257165ab.18.1732641047447;
        Tue, 26 Nov 2024 09:10:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG6K6UNamiK6O/nxV7SHYbjCV/fiYY963jqY0jKdci5faeUGnSMsVF/gMvDkGoJTCkuUhR9iw==
X-Received: by 2002:a05:6e02:16ce:b0:3a7:8a39:269e with SMTP id e9e14a558f8ab-3a79aeea927mr188256395ab.18.1732641046931;
        Tue, 26 Nov 2024 09:10:46 -0800 (PST)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e1efbcaa5bsm1792326173.78.2024.11.26.09.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2024 09:10:46 -0800 (PST)
Message-ID: <07252361-8886-4284-bdba-55c3fe728831@redhat.com>
Date: Tue, 26 Nov 2024 12:10:24 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/1] KVM: arm64: Map GPU memory with no struct pages
Content-Language: en-US
To: ankita@nvidia.com, jgg@nvidia.com, maz@kernel.org,
 oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
 ryan.roberts@arm.com, shahuang@redhat.com, lpieralisi@kernel.org
Cc: aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
 apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com,
 mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com,
 alex.williamson@redhat.com, sebastianene@google.com, coltonlewis@google.com,
 kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, gshan@redhat.com, linux-mm@kvack.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20241118131958.4609-1-ankita@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20241118131958.4609-1-ankita@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

My email client says this patch: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
   is part of a thread for this titled patchPATCH.  Is it?

The description has similarities to above description, but some adds, some drops.

So, could you clean these two up into (a) a series, or (b) single, separate PATCH's?

Thanks.

- Don

On 11/18/24 8:19 AM, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Grace based platforms such as Grace Hopper/Blackwell Superchips have
> CPU accessible cache coherent GPU memory. The current KVM code
> prevents such memory to be mapped Normal cacheable and the patch aims
> to solve this use case.
> 
> Today KVM forces the memory to either NORMAL or DEVICE_nGnRE
> based on pfn_is_map_memory() and ignores the per-VMA flags that
> indicates the memory attributes. This means there is no way for
> a VM to get cachable IO memory (like from a CXL or pre-CXL device).
> In both cases the memory will be forced to be DEVICE_nGnRE and the
> VM's memory attributes will be ignored.
> 
> The pfn_is_map_memory() is thus restrictive and allows only for
> the memory that is added to the kernel to be marked as cacheable.
> In most cases the code needs to know if there is a struct page, or
> if the memory is in the kernel map and pfn_valid() is an appropriate
> API for this. Extend the umbrella with pfn_valid() to include memory
> with no struct pages for consideration to be mapped cacheable in
> stage 2. A !pfn_valid() implies that the memory is unsafe to be mapped
> as cacheable.
> 
> Also take care of the following two cases that are unsafe to be mapped
> as cacheable:
> 1. The VMA pgprot may have VM_IO set alongwith MT_NORMAL or MT_NORMAL_TAGGED.
>     Although unexpected and wrong, presence of such configuration cannot
>     be ruled out.
> 2. Configurations where VM_MTE_ALLOWED is not set and KVM_CAP_ARM_MTE
>     is enabled. Otherwise a malicious guest can enable MTE at stage 1
>     without the hypervisor being able to tell. This could cause external
>     aborts.
> 
> The GPU memory such as on the Grace Hopper systems is interchangeable
> with DDR memory and retains its properties. Executable faults should thus
> be allowed on the memory determined as Normal cacheable.
> 
> Note when FWB is not enabled, the kernel expects to trivially do
> cache management by flushing the memory by linearly converting a
> kvm_pte to phys_addr to a KVA, see kvm_flush_dcache_to_poc(). This is
> only possibile for struct page backed memory. Do not allow non-struct
> page memory to be cachable without FWB.
> 
> The changes are heavily influenced by the insightful discussions between
> Catalin Marinas and Jason Gunthorpe [1] on v1. Many thanks for their
> valuable suggestions.
> 
> Applied over next-20241117 and tested on the Grace Hopper and
> Grace Blackwell platforms by booting up VM and running several CUDA
> workloads. This has not been tested on MTE enabled hardware. If
> someone can give it a try, it will be very helpful.
> 
> v1 -> v2
> 1. Removed kvm_is_device_pfn() as a determiner for device type memory
>     determination. Instead using pfn_valid()
> 2. Added handling for MTE.
> 3. Minor cleanup.
> 
> Link: https://lore.kernel.org/lkml/20230907181459.18145-2-ankita@nvidia.com [1]
> 
> Ankit Agrawal (1):
>    KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
> 
>   arch/arm64/include/asm/kvm_pgtable.h |   8 +++
>   arch/arm64/kvm/hyp/pgtable.c         |   2 +-
>   arch/arm64/kvm/mmu.c                 | 101 +++++++++++++++++++++------
>   3 files changed, 87 insertions(+), 24 deletions(-)
> 


