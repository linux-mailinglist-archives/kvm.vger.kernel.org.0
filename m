Return-Path: <kvm+bounces-14597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE7548A3C5F
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 12:59:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A0181C21698
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 10:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCCCE3E470;
	Sat, 13 Apr 2024 10:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSPsWUzP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B820225CB;
	Sat, 13 Apr 2024 10:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713005967; cv=none; b=V5rjQnOHe/vFlOmbw9cdW/HFrh7qytt0Nifd11u4eruAuaBtkCQu+P7hIkq4+vUmg7qrMVFrCZ2gNUaqm32OnpnyVZYq0/t2JJJr3t5a7p4Z4hX0rsnqGqTnZGdZeFW12oUFBRpZ2pCuHLR/LMlfY20aGyrgx2czKt02LS25y8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713005967; c=relaxed/simple;
	bh=uOjaUGqPKVq3+j2VJs/TEKafBEYOo8VXLsRCY3RPo/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c+0roipmVakyGdTwPFtIUAWO/0H6G+XLzOd+2nkcTxsrlPGay/7OdVk8eW9Ejjo0uNk0cW8IsD5c7Tbami058fyXUFg1PYXnufqHB2fuab9KjX8TFj02Nemv+YfKYWFq6Gu3AgUp2qI5pSFNVCmTjpjW9ATw2LXjXMdhNfTdBtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GSPsWUzP; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-22a96054726so1262831fac.0;
        Sat, 13 Apr 2024 03:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713005965; x=1713610765; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9hUP/8ZgJ+b6bN2VxVCxAiZaitZzpbRs5WnErLxeF08=;
        b=GSPsWUzPyq8HZNpCoLmbSZEhoSKcrjTzUqRzLf7zaSLcY0vbyib1Y1JatLjclqEes7
         Of70rBX1Wh0an6+GOJx//CiuFL9UtXobYQYLCSiW1eo66kJxzQSLjurhV0BNL3tzT0/4
         6QzZ8HwwEp9oPNxkoREonwuNphzPyD4iiSTyEPNXTgRbFlYCM+KT7HCSK6Ns3+1at61r
         lOyOKWe4l6qiWT0/vBZMkZQeaOpy0Y+j58KuCrLOC1d4gnXiWrEenF762psK7Uwt25CW
         j3wtcqalOQs8fTrWJD7IIjc34K6RKkbG/DmBAlaTJpKMywoZmmGau9NBrdevLT0kRPU7
         /zPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713005965; x=1713610765;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hUP/8ZgJ+b6bN2VxVCxAiZaitZzpbRs5WnErLxeF08=;
        b=Y9P/CYc/9dmYaANaRFsZZ4D8Wmg9/hX10z9dlCSdS/btGFeANvtF0hd5OzJMKG2Zk6
         YYqIx12HTWXMCSDeQcpEpGP0DIULn+j29dqpAxnDjhZyIAX34zTymIu/pMBhorYa28W4
         H8Gl4CvsD46/Imh5VaE1druUBYM8u4CVduPNlQPmToUvOmlAkBehhnKCNTih0g9t0JCt
         ydpdpSd5zQYROZiIR3lp4eX8awuqhpnLaV8TPdLjR6sCMKeSAoVZ6bttOUc9zI482Ppj
         IW4ccD/dIhL/SGH0yEanOkcyTmgiJGQqB99htoWdcHfC37Nncnvj00unfxS5sOPRg//r
         jBhg==
X-Forwarded-Encrypted: i=1; AJvYcCWJAGD/hsjVAcW9u0AP/RAYflP9ygOxeQtyABpDm/8JAHtzxRNz3XwB4szNS+WL00hTK7xZY095NQFHbtq8BUCrd9MX
X-Gm-Message-State: AOJu0YzaKgPosvv4tMWvWUJJGg0F5c9dnCZcHIajuUGWXL3EjPzLCcde
	SXZTJQ0WxKhy2m3lESrgH15awkGnlHxCmKR42dafzMAG24yD8nFx
X-Google-Smtp-Source: AGHT+IGyBscLxvzKjs9tfnJDbxZslNl53miRQHsAAQdFdgIgfp+w8iJsvtPKqDglEFKZeub/xcSWOw==
X-Received: by 2002:a05:6870:d0c3:b0:22e:e416:a5ea with SMTP id k3-20020a056870d0c300b0022ee416a5eamr5443820oaa.51.1713005964673;
        Sat, 13 Apr 2024 03:59:24 -0700 (PDT)
Received: from [172.27.234.129] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id gb10-20020a056a00628a00b006e6ae26625asm4169308pfb.68.2024.04.13.03.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Apr 2024 03:59:24 -0700 (PDT)
Message-ID: <6153f44c-841a-4eea-a51b-5a68c84faf47@gmail.com>
Date: Sat, 13 Apr 2024 18:59:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/13] iommu/vt-d: Make posted MSI an opt-in cmdline
 option
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
 Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
 Paul Luse <paul.e.luse@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Jens Axboe <axboe@kernel.dk>, Raj Ashok <ashok.raj@intel.com>,
 "Tian, Kevin" <kevin.tian@intel.com>, maz@kernel.org, seanjc@google.com,
 Robin Murphy <robin.murphy@arm.com>, jim.harris@samsung.com,
 a.manzanares@samsung.com, Bjorn Helgaas <helgaas@kernel.org>,
 guang.zeng@intel.com
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-12-jacob.jun.pan@linux.intel.com>
 <8871e541-4991-44f3-aab7-d3a657fc59db@gmail.com>
 <20240408163312.7b7f3d18@jacob-builder>
Content-Language: en-US
From: Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20240408163312.7b7f3d18@jacob-builder>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/2024 7:33 AM, Jacob Pan wrote:
> Hi Robert,
> 
> On Sat, 6 Apr 2024 12:31:14 +0800, Robert Hoo <robert.hoo.linux@gmail.com>
> wrote:
> 
>> On 4/6/2024 6:31 AM, Jacob Pan wrote:
>>> Add a command line opt-in option for posted MSI if
>>> CONFIG_X86_POSTED_MSI=y.
>>>
>>> Also introduce a helper function for testing if posted MSI is supported
>>> on the platform.
>>>
>>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>> ---
>>>    Documentation/admin-guide/kernel-parameters.txt |  1 +
>>>    arch/x86/include/asm/irq_remapping.h            | 11 +++++++++++
>>>    drivers/iommu/irq_remapping.c                   | 13 ++++++++++++-
>>>    3 files changed, 24 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/admin-guide/kernel-parameters.txt
>>> b/Documentation/admin-guide/kernel-parameters.txt index
>>> bb884c14b2f6..e5fd02423c4c 100644 ---
>>> a/Documentation/admin-guide/kernel-parameters.txt +++
>>> b/Documentation/admin-guide/kernel-parameters.txt @@ -2251,6 +2251,7 @@
>>>    			no_x2apic_optout
>>>    				BIOS x2APIC opt-out request will be
>>> ignored nopost	disable Interrupt Posting
>>> +			posted_msi enable MSIs delivered as posted
>>> interrupts
>>>    	iomem=		Disable strict checking of access to
>>> MMIO memory strict	regions from userspace.
>>> diff --git a/arch/x86/include/asm/irq_remapping.h
>>> b/arch/x86/include/asm/irq_remapping.h index 7a2ed154a5e1..e46bde61029b
>>> 100644 --- a/arch/x86/include/asm/irq_remapping.h
>>> +++ b/arch/x86/include/asm/irq_remapping.h
>>> @@ -50,6 +50,17 @@ static inline struct irq_domain
>>> *arch_get_ir_parent_domain(void) return x86_vector_domain;
>>>    }
>>>    
>>> +#ifdef CONFIG_X86_POSTED_MSI
>>> +extern int enable_posted_msi;
>>> +
>>> +static inline bool posted_msi_supported(void)
>>> +{
>>> +	return enable_posted_msi && irq_remapping_cap(IRQ_POSTING_CAP);
>>> +}
>>
>> Out of this patch set's scope, but, dropping into irq_remappping_cap(),
>> I'd like to bring this change for discussion:
>>
>> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
>> index 4047ac396728..ef2de9034897 100644
>> --- a/drivers/iommu/irq_remapping.c
>> +++ b/drivers/iommu/irq_remapping.c
>> @@ -98,7 +98,7 @@ void set_irq_remapping_broken(void)
>>
>>    bool irq_remapping_cap(enum irq_remap_cap cap)
>>    {
>> -       if (!remap_ops || disable_irq_post)
>> +       if (!remap_ops || disable_irq_remap)
>>                   return false;
>>
>>           return (remap_ops->capability & (1 << cap));
>>
>>
>> 1. irq_remapping_cap() is to exam some cap, though at present it has only
>> 1 cap, i.e. IRQ_POSTING_CAP, simply return false just because of
>> disable_irq_post isn't good. Instead, IRQ_REMAP is the foundation of all
>> remapping caps. 2. disable_irq_post is used by Intel iommu code only,
>> here irq_remapping_cap() is common code. e.g. AMD iommu code doesn't use
>> it to judge set cap of irq_post or not.
> I agree, posting should be treated as a sub-capability of remapping.
> IRQ_POSTING_CAP is only set when remapping is on.
> 
> We need to delete this such that posting is always off when remapping is
> off.
> 
> --- a/drivers/iommu/intel/irq_remapping.c
> +++ b/drivers/iommu/intel/irq_remapping.c
> @@ -1038,11 +1038,7 @@ static void disable_irq_remapping(void)
>                  iommu_disable_irq_remapping(iommu);
>          }
>   
> -       /*
> -        * Clear Posted-Interrupts capability.
> -        */
> -       if (!disable_irq_post)
> -               intel_irq_remap_ops.capability &= ~(1 << IRQ_POSTING_CAP);
> +       intel_irq_remap_ops.capability &= ~(1 << IRQ_POSTING_CAP);
>   }
> 
Right.


