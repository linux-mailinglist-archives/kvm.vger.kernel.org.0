Return-Path: <kvm+bounces-47256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 507B4ABF189
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 12:27:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 774143A371A
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 10:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887DF25CC5D;
	Wed, 21 May 2025 10:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S/6LNPbo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392C223E336
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 10:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747823191; cv=none; b=N76kI9FgQwvWnbKvSVoHt9OEHcoAcSag312ok7vUfUZw9XmFJORzO85Fuz3CMS9/73SdEdWhPF+z49zJ3EMUu4uYUgun6vNonU1o16Vg0Rvirw6X4Vdi2+yFdW0Bfn1U7XvtBg6CPHIuIWiFwTISK2NlzUcXlGrvU6LSkyS6Mok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747823191; c=relaxed/simple;
	bh=rlu2OxcRyWoJ3ih3vUMEht2pwj2HKYrQRi3qMa0g9Bo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fHqZ0Y/bbpiD1hB81dyAjrVrEfO/kQntciZb2QjR0st7OFmeM5KmUeaYPzEo9kssBIvob7I1C+iBw0Xp+2QoHPwOpGSrY/oYBb7mnxP85EuUoEq1UOepNGvV0RXVPvjCrqvZRX+hTg3WmIn9EK1vU8h6W83+lihS04oMeR03yKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S/6LNPbo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747823189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZBn1Jj42GjyO3A11cDA5KPDrKJjE7wDMc6pPv0bx1Jo=;
	b=S/6LNPbop9fRlF3+R0af61meCfdfpsbL8i1B4izIKfB6LLE1WgInBVjXtbdZ9bWwnTjDbr
	hGFVoCpKfFT4QgFh7VCt6M323swK56wvyNhz8v8hlazXQLiee2CaWmPW9bXoVrZhQeEhk7
	H/qwvyd5I12aHOg0ncch93thO8orm8Y=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173--8fUBRM_Om-hKjAZOAaV_A-1; Wed, 21 May 2025 06:26:28 -0400
X-MC-Unique: -8fUBRM_Om-hKjAZOAaV_A-1
X-Mimecast-MFC-AGG-ID: -8fUBRM_Om-hKjAZOAaV_A_1747823187
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a35989e5b2so4089477f8f.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 03:26:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747823187; x=1748427987;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZBn1Jj42GjyO3A11cDA5KPDrKJjE7wDMc6pPv0bx1Jo=;
        b=DszcBXCKt3GBLp+Y+T/Yma+/db2kPvpGxlSHX50JlUxPLR4x9qbbXcVHSKaRObz9uk
         8Jp2XbTC6zmZ9mXvwoN3DsQtT2YXF9yMdM82vPUMiCv5JHVVfTTK1KuJ4V2BCAcNXRds
         5jVb+cPig4L5X4tPbjUfVZYKapcXvDEHtFOcTMOhkil44pWAUWwHzW3h9JRPEKSrOt1Y
         3KXWUEaRoW7bfiHtZm1vd4oIJ6bN939tKrJmfXreHIqnut2c/uHjWHH2IsQzp/Moqqii
         HUCeA7WzsNyrEyPxpeSkH3w8w1MrKZohT2TbR+OSpi3VHSAEag9nCj9epB2O/pW3H1XT
         MAKg==
X-Gm-Message-State: AOJu0YyyGhcOsuZrqCusx6obwIhoYCNuUOJ//Jy1RmEQtJIJMNcp0Bf0
	zn4UalT/BnV6WHDWNN2+dEZcAOg9TzrdnDwIubDffv8nfGVDereymsEvJ9nUFlCk4petTElggiL
	lfVxqkAO80F94nXlnLez3qmwA6wlsVQjo+kJiHkPzBMlW/aVkJpAmLw==
X-Gm-Gg: ASbGnctIB66oysqBZ31cP1BQ/nplEPOb2EutX6a/DALhzDdMuTzAPHgc96et6xS+vEF
	J0As3MZDlFmeBXFHTQanNv1ukt4T0ysfF2xQxZwBGvHez6uaVggPUa0SOWkNSPYjxh/XRlpLMLI
	l6wwvMb9mhRlEyOlhR/0h5j4dgPUKEcSG/v+ulU7beqlb/EitDFCuDOLZvdQVDdNjlbu5KUGBxY
	x5DZq5NCfXf1MCGglkwhPYXpaf/iYXd6V7tHanEAnoUdI05dcUw7HRzOLw5AfaQfAm649tJ9wlt
	GEWmK6R6o+n1/Q1ZDBxekPpP5dW5svJp9oDM1SbHXANBim7qar8sceBMj2BlJoBTmYjlp11FM5Q
	NOo3bihOvSmZpPyXPSWrw3j/QBMuC+9IgImfQVZ0=
X-Received: by 2002:a05:6000:2285:b0:3a3:68c7:e473 with SMTP id ffacd0b85a97d-3a368c7e5ffmr12852964f8f.25.1747823186637;
        Wed, 21 May 2025 03:26:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQ3S//HNpHvBhM+nKG+RpOCioNba+IjmTNwU1ubcqKDGSvqpbY97v3H77ZO2B3ASh2DRs0jg==
X-Received: by 2002:a05:6000:2285:b0:3a3:68c7:e473 with SMTP id ffacd0b85a97d-3a368c7e5ffmr12852893f8f.25.1747823186114;
        Wed, 21 May 2025 03:26:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60? (p200300d82f259c00e2c76eb58a511c60.dip0.t-ipconnect.de. [2003:d8:2f25:9c00:e2c7:6eb5:8a51:1c60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca5a5b4sm18981429f8f.21.2025.05.21.03.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 May 2025 03:26:25 -0700 (PDT)
Message-ID: <d5983511-6de3-42cb-9c2f-4a0377ea5e2d@redhat.com>
Date: Wed, 21 May 2025 12:26:22 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/17] KVM: arm64: Enable mapping guest_memfd in arm64
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com,
 jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com,
 isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
 vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250513163438.3942405-1-tabba@google.com>
 <20250513163438.3942405-15-tabba@google.com>
 <2084504e-2a11-404a-bbe8-930384106f53@redhat.com>
 <CA+EHjTyz4M4wGCTBzFwHLB_0LUJHq6J135f=DVOhGKQE4thrtQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <CA+EHjTyz4M4wGCTBzFwHLB_0LUJHq6J135f=DVOhGKQE4thrtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21.05.25 12:12, Fuad Tabba wrote:
> Hi David,
> 
> On Wed, 21 May 2025 at 09:05, David Hildenbrand <david@redhat.com> wrote:
>>
>> On 13.05.25 18:34, Fuad Tabba wrote:
>>> Enable mapping guest_memfd in arm64. For now, it applies to all
>>> VMs in arm64 that use guest_memfd. In the future, new VM types
>>> can restrict this via kvm_arch_gmem_supports_shared_mem().
>>>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>>    arch/arm64/include/asm/kvm_host.h | 10 ++++++++++
>>>    arch/arm64/kvm/Kconfig            |  1 +
>>>    2 files changed, 11 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 08ba91e6fb03..2514779f5131 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -1593,4 +1593,14 @@ static inline bool kvm_arch_has_irq_bypass(void)
>>>        return true;
>>>    }
>>>
>>> +static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>>> +{
>>> +     return IS_ENABLED(CONFIG_KVM_GMEM);
>>> +}
>>> +
>>> +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)
>>> +{
>>> +     return IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM);
>>> +}
>>> +
>>>    #endif /* __ARM64_KVM_HOST_H__ */
>>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>>> index 096e45acadb2..8c1e1964b46a 100644
>>> --- a/arch/arm64/kvm/Kconfig
>>> +++ b/arch/arm64/kvm/Kconfig
>>> @@ -38,6 +38,7 @@ menuconfig KVM
>>>        select HAVE_KVM_VCPU_RUN_PID_CHANGE
>>>        select SCHED_INFO
>>>        select GUEST_PERF_EVENTS if PERF_EVENTS
>>> +     select KVM_GMEM_SHARED_MEM
>>>        help
>>>          Support hosting virtualized guest machines.
>>>
>>
>> Do we have to reject somewhere if we are given a guest_memfd that was
>> *not* created using the SHARED flag? Or will existing checks already
>> reject that?
> 
> We don't reject, but I don't think we need to. A user can create a
> guest_memfd that's private in arm64, it would just be useless.

But the arm64 fault routine would not be able to handle that properly, no?

-- 
Cheers,

David / dhildenb


