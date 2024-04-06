Return-Path: <kvm+bounces-13786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF26D89A8DE
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 06:31:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A459EB22867
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 04:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 493E91BF58;
	Sat,  6 Apr 2024 04:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THnhIDQ5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0528E2901;
	Sat,  6 Apr 2024 04:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712377888; cv=none; b=iO0xiKR2CH6AldSrgEHkJJ7JwWEPnXVsZovQMePk/NQp2qzief0oahAobNDGXqFDlZvPYyE+DPKbInvPpPcJG4QtapssVXd6mVoi33cDdQp0nJrgzOdPdCR9KEABnprbCbyE5iRMQmlN4kHqwpX8jioGv52SjCyuq2vREpe64Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712377888; c=relaxed/simple;
	bh=Sd9whxFabxqaniLOwdOH3BPEIWVV3eaeOVYlENJ62EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YyNo1xGCILMDGCT7atCpvP5fg5MX1snSCDX69ujvbtRWoo+Ctgn8V+IaTjdQHBi+lcg/EQQiRz3oQDgCwtKLu/holTbvcmPRX5Na0pO0RVMZLdzKngijzpq6UmFUA4azyFsGbSR0tqMC/mj5Q89IrKymTmjW9w6y+se3uzahPMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THnhIDQ5; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-22e8676c670so1516097fac.1;
        Fri, 05 Apr 2024 21:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712377886; x=1712982686; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ANjvDaQnRfWIu1MTyzhHLGRn9JEs7sjvTWyOy3Vox/8=;
        b=THnhIDQ5xCxgs7Gm4wRqk+8eBnzxH2HOC0L+iV8m1zb9oUb0DFubkKDVU5F4Xe5rXS
         N5c1pErqIkn5DXpE2MpdENwcNCRoQT+OYJwUNYo7VIet7FA1pTabiChBEkerL3d68/fN
         ReB1UreiqTu9fdI6d1i4nBQXFpSqmbjMQeUpx4tZvfCmIKkNW8Oy16CIW9cGFEJlWz82
         q2ge4lATYJF8bDz0jHMhry/Sq+sv8cWMq05D0GbqWHWaVsMeApgAU7iAfqKsfZtvI1//
         7ZjN9bouC5laxnUkQhFluKmQlSVG5OJuRvtinByNVi6AysGLzp5ngQ0fhkw3km5K6cjo
         Nepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712377886; x=1712982686;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ANjvDaQnRfWIu1MTyzhHLGRn9JEs7sjvTWyOy3Vox/8=;
        b=bSYS5VgXdULl75aek9qcRz6ao8lLq9Zin/Vy9vMBPkRu9054mYH1AsGpK7/PYwDg62
         NAP1jOBRbKRkutePJ+8v/2FD+tcgcl7At5U4sqwhCe21Bz2bln9uz0tEh6rPGbxXHqRR
         uAwkuUPAJKWdgbIzctYn4VeilMNwmhjWNA5O0LMq7sCKHZSsKbWk9w2HPTaG8MKgrOjP
         BU8B7MNfwMnnINT940ObOLc63s+WLnz3Id0Byc4a58KHo3THmi95N03Ghprp8vNjrAlP
         xnJMvWjxKUwtAoQiepdq03baZbdLM3qyVL0Cmie6s/YhvFd7q01OI3DNHjJUvXIrlUdN
         k5Fw==
X-Forwarded-Encrypted: i=1; AJvYcCXymkA+WQSsYXiBLTZ8bRl4iu4zEZErSo2uLiw7XQn6sK6qdFWgjWtITsC4bfPORiNfqYiyo5VfoFd4jUWyIkyAd865AtwhOwWy412QpqqNQOY9vI/fUtwEjEFC0/D8LQCx
X-Gm-Message-State: AOJu0Yz/XyaxMQ2u6sjQXK3ovWDL/Gzp9pnBdSBn3eUMuc4sFBMAuMGE
	B134/5nUkzMELwf4/fvUkA+8tFfvWlWKNJCAozWfhIZHqTPd8d01
X-Google-Smtp-Source: AGHT+IGVHOtE7u5B4TTMjGZWtWpzIDvTdtQMJcIi7qs5jUx2J8vwSZ2djbS/jzaSt5bJWLCBAajOqQ==
X-Received: by 2002:a05:6870:1609:b0:22e:9aec:e8fe with SMTP id b9-20020a056870160900b0022e9aece8femr3424231oae.47.1712377886107;
        Fri, 05 Apr 2024 21:31:26 -0700 (PDT)
Received: from [172.27.237.3] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id c10-20020a056a00008a00b006ecfa91a210sm2332154pfj.100.2024.04.05.21.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 21:31:25 -0700 (PDT)
Message-ID: <8871e541-4991-44f3-aab7-d3a657fc59db@gmail.com>
Date: Sat, 6 Apr 2024 12:31:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/13] iommu/vt-d: Make posted MSI an opt-in cmdline
 option
To: Jacob Pan <jacob.jun.pan@linux.intel.com>,
 LKML <linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, iommu@lists.linux.dev,
 Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
 kvm@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
 Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
Cc: Paul Luse <paul.e.luse@intel.com>, Dan Williams
 <dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>,
 Raj Ashok <ashok.raj@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>,
 jim.harris@samsung.com, a.manzanares@samsung.com,
 Bjorn Helgaas <helgaas@kernel.org>, guang.zeng@intel.com
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-12-jacob.jun.pan@linux.intel.com>
Content-Language: en-US
From: Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20240405223110.1609888-12-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/6/2024 6:31 AM, Jacob Pan wrote:
> Add a command line opt-in option for posted MSI if CONFIG_X86_POSTED_MSI=y.
> 
> Also introduce a helper function for testing if posted MSI is supported on
> the platform.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>   Documentation/admin-guide/kernel-parameters.txt |  1 +
>   arch/x86/include/asm/irq_remapping.h            | 11 +++++++++++
>   drivers/iommu/irq_remapping.c                   | 13 ++++++++++++-
>   3 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index bb884c14b2f6..e5fd02423c4c 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2251,6 +2251,7 @@
>   			no_x2apic_optout
>   				BIOS x2APIC opt-out request will be ignored
>   			nopost	disable Interrupt Posting
> +			posted_msi enable MSIs delivered as posted interrupts
>   
>   	iomem=		Disable strict checking of access to MMIO memory
>   		strict	regions from userspace.
> diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
> index 7a2ed154a5e1..e46bde61029b 100644
> --- a/arch/x86/include/asm/irq_remapping.h
> +++ b/arch/x86/include/asm/irq_remapping.h
> @@ -50,6 +50,17 @@ static inline struct irq_domain *arch_get_ir_parent_domain(void)
>   	return x86_vector_domain;
>   }
>   
> +#ifdef CONFIG_X86_POSTED_MSI
> +extern int enable_posted_msi;
> +
> +static inline bool posted_msi_supported(void)
> +{
> +	return enable_posted_msi && irq_remapping_cap(IRQ_POSTING_CAP);
> +}

Out of this patch set's scope, but, dropping into irq_remappping_cap(), I'd like 
to bring this change for discussion:

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 4047ac396728..ef2de9034897 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -98,7 +98,7 @@ void set_irq_remapping_broken(void)

  bool irq_remapping_cap(enum irq_remap_cap cap)
  {
-       if (!remap_ops || disable_irq_post)
+       if (!remap_ops || disable_irq_remap)
                 return false;

         return (remap_ops->capability & (1 << cap));


1. irq_remapping_cap() is to exam some cap, though at present it has only 1 cap, 
i.e. IRQ_POSTING_CAP, simply return false just because of disable_irq_post isn't 
good. Instead, IRQ_REMAP is the foundation of all remapping caps.
2. disable_irq_post is used by Intel iommu code only, here irq_remapping_cap() 
is common code. e.g. AMD iommu code doesn't use it to judge set cap of irq_post 
or not.

> +#else
> +static inline bool posted_msi_supported(void) { return false; };
> +#endif


