Return-Path: <kvm+bounces-53777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A38CBB16D2E
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 10:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDC1A3AE897
	for <lists+kvm@lfdr.de>; Thu, 31 Jul 2025 08:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D42528D8CF;
	Thu, 31 Jul 2025 08:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CSsTAQaf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02801E1DFE
	for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 08:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753949218; cv=none; b=Hq/FKY4+Sg/kTGJ72JDewifrmCey3oYo5vhjuo/mUjHr09lp/FOtbR06HjECEnr7ialg0y8wqyH2Jp5aPqQXtzH0De58USNMXvrEuVpAeVQJuMR+vsZhu+5bgoq6ht4p7xCN052pBQvwCi6BsYzS39R2/dpLrys4XthvJM5lOLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753949218; c=relaxed/simple;
	bh=CFMDkMvUsQvR57EG+SSxOQx2PNQckr7GXyE2N/DP0Ag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C5VQFzoyTGQR7eFloIu/CbyoMh+wCRY4wc/SfNq5tlApARGTjOL6hW1u8ZOWJz30+JqQKQl7G9FRtwwuk1fY4+kAG+ZZlLFy9YnXwGZi+5cc2+oIU30xh0cgD+AgOu36OOJ0RRWUlsyTay62EAly2VOeLCMq0Khg6dNQZdpwJaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CSsTAQaf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753949216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gdDuaWOe4RuxMS+wAr8ek8x+QM6/+KK3Sdkf13YTdto=;
	b=CSsTAQafEILmVWMADRgYrakJFtBAM+ax6l8RpzlpRd0ChFhCIAU8t7Wzk4dBfPkMeqAtoV
	YCnz3EbREqbgRbbocImdZO58iV/Nx3QP+/1oop6kcjUcM+HWftVRRlFr3O9knZoMxM0uiE
	KqyDcnSQPxjW3Z8d/YL+ZeVUZ1y7f3c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-V0-H81OPNRaMqFPCrhPKCg-1; Thu, 31 Jul 2025 04:06:53 -0400
X-MC-Unique: V0-H81OPNRaMqFPCrhPKCg-1
X-Mimecast-MFC-AGG-ID: V0-H81OPNRaMqFPCrhPKCg_1753949213
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45600d19a2aso4395845e9.1
        for <kvm@vger.kernel.org>; Thu, 31 Jul 2025 01:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753949213; x=1754554013;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gdDuaWOe4RuxMS+wAr8ek8x+QM6/+KK3Sdkf13YTdto=;
        b=IoeR9XM3EBAfi20xaCc28g25dC2muBgB+wtQ/G5gu77xEiCvzX06/i+LqAANTM8YRX
         IEUctcE3d46XoAv20EErA/yS2Ptf2nC1uKx1DO/sLnkHDE+SAqQuB+JSersJ79ogivur
         /s6EfMpZSfHQr/lgI+VgbzvZImgrGiCZxrx1MdvOlDyv6eDLEs6hELF/iNgircUsCgKJ
         0IZnW4WCl6KGJ/ZgQe49tV1oOfUFiJxImXS+Qi4Grf8gWJ0h0MmkJjH/mXE2hX1LMLiy
         tCLUvOxXRV1EDlqd+M+68nVwbay1mxY2T2Lw4IKyMhVaBOuav2r2vau5FqKAyaqGClot
         57yA==
X-Gm-Message-State: AOJu0YwowD5K8bCtx41K4maU5sNX0STgI30XtMTTM9QfXPDg4X0Y22xH
	52asPXcrHCdVlWu2xh/yYeYgMStTSk5WAAmQtXGpCNy8T0npzrVZAQ3ibpc+JrfHlayMb5Xrdb7
	Ug/J0qpCq/82J4kQcyO6MGKkJO1lfohdh9wbrJfg4ngQmZV/kKm2gxw==
X-Gm-Gg: ASbGncvbz/P/e0xqPvqdH6iTG86dKkV6ATPmzsGneF3MLi3EI3MUcJIYqvIPuqtX8qU
	b1X/0QGps+WSCtoBxBwVePK8ittm/V8NHzY2M3dZKMZJFJ/9WW5W+NAjJgXESD+4MXni9ECNYMg
	Bz8oOE+f9OoVN2cdHLIHJBIjsEfN/xQpx56IVWtTfkMs+1eE9jnUgvVELtL/cS8VNCF5V/aVGc/
	fCYYr/7QDGEJvSlu08w1Bz1Nt8jsiB9swL098wgutx8eDh4R+jS0iLh2IUCH7CeDOPsHyXRTKHW
	F14AbvcGB6YrbaWffjtYnkp4uJ2s8W6lpjXeg9fV8NvmHf+t2UskQ46kMpVvL8Jt+OlUYQ2v8Km
	RKKfoMAN/8TF60PG7tdQz/0u6yJvhguZhmiQqyOhm7dcaZFkMBYeTXAI1AP6W4jQwcEM=
X-Received: by 2002:a05:6000:18aa:b0:3b7:8b88:e3a2 with SMTP id ffacd0b85a97d-3b795024a1amr4771332f8f.58.1753949212638;
        Thu, 31 Jul 2025 01:06:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGumOQhXTySJjcOYt9Ti77EPoGWcFbQk5wd32tWIzZh2aJz46IsGG5RZTp29fmETKoqd8N9nA==
X-Received: by 2002:a05:6000:18aa:b0:3b7:8b88:e3a2 with SMTP id ffacd0b85a97d-3b795024a1amr4771292f8f.58.1753949212180;
        Thu, 31 Jul 2025 01:06:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3ac158sm1578088f8f.4.2025.07.31.01.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 01:06:50 -0700 (PDT)
Message-ID: <39081490-cb20-4ec2-8384-1f1ccfdb336b@redhat.com>
Date: Thu, 31 Jul 2025 10:06:49 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 14/24] KVM: x86/mmu: Enforce guest_memfd's max order
 when recovering hugepages
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Gavin Shan <gshan@redhat.com>,
 Shivank Garg <shivankg@amd.com>, Vlastimil Babka <vbabka@suse.cz>,
 Fuad Tabba <tabba@google.com>, Ackerley Tng <ackerleytng@google.com>,
 Tao Chan <chentao@kylinos.cn>, James Houghton <jthoughton@google.com>
References: <20250729225455.670324-1-seanjc@google.com>
 <20250729225455.670324-15-seanjc@google.com>
 <e67b0825-abcb-4bac-bc3c-2e8b513f1d57@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <e67b0825-abcb-4bac-bc3c-2e8b513f1d57@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 30.07.25 09:33, Xiaoyao Li wrote:
> On 7/30/2025 6:54 AM, Sean Christopherson wrote:
>> Rework kvm_mmu_max_mapping_level() to provide the plumbing to consult
>> guest_memfd (and relevant vendor code) when recovering hugepages, e.g.
>> after disabling live migration.  The flaw has existed since guest_memfd was
>> originally added, but has gone unnoticed due to lack of guest_memfd support
>> for hugepages or dirty logging.
>>
>> Don't actually call into guest_memfd at this time, as it's unclear as to
>> what the API should be.  Ideally, KVM would simply use kvm_gmem_get_pfn(),
>> but invoking kvm_gmem_get_pfn() would lead to sleeping in atomic context
>> if guest_memfd needed to allocate memory (mmu_lock is held).  Luckily,
>> the path isn't actually reachable, so just add a TODO and WARN to ensure
>> the functionality is added alongisde guest_memfd hugepage support, and
>> punt the guest_memfd API design question to the future.
>>
>> Note, calling kvm_mem_is_private() in the non-fault path is safe, so long
>> as mmu_lock is held, as hugepage recovery operates on shadow-present SPTEs,
>> i.e. calling kvm_mmu_max_mapping_level() with @fault=NULL is mutually
>> exclusive with kvm_vm_set_mem_attributes() changing the PRIVATE attribute
>> of the gfn.
>>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>    arch/x86/kvm/mmu/mmu.c          | 82 +++++++++++++++++++--------------
>>    arch/x86/kvm/mmu/mmu_internal.h |  2 +-
>>    arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>>    3 files changed, 49 insertions(+), 37 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 20dd9f64156e..61eb9f723675 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3302,31 +3302,54 @@ static u8 kvm_max_level_for_order(int order)
>>    	return PG_LEVEL_4K;
>>    }
>>    
>> -static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
>> -					u8 max_level, int gmem_order)
>> +static u8 kvm_max_private_mapping_level(struct kvm *kvm, struct kvm_page_fault *fault,
>> +					const struct kvm_memory_slot *slot, gfn_t gfn)
> 
> I don't see why slot and gfn are needed here. Just to keep consistent
> with host_pfn_mapping_level()?
> 

I assume as a preparation to implement the TODO.


Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


