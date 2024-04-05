Return-Path: <kvm+bounces-13630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D623899325
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 04:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF28E1F21DB6
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 02:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464A014F6C;
	Fri,  5 Apr 2024 02:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pci9vjZw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A19107B3;
	Fri,  5 Apr 2024 02:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712284151; cv=none; b=nEQGrdyElx4kZA17/Yck+mgJ2Ys/P+7Ry99eGmgXiZzRBH+a42XH5pqutQLG+NKkQS1P1BxldCLqvHgn91hQGi5BuXtBlZJDJ8FePAcp9Lffb2YV4t+I2dW5cxibFnZKNBP0K1+Ex20bVC5YqNOYJNvH9OAysUiT4kTvRoi210k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712284151; c=relaxed/simple;
	bh=5iT0uqVet1JZZBeE+SsSnki7j0+tNPTR4KLa4UdOnew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uq8SsfQK0376VSpCppIw8qhiRtzt8QPeQ0mUaKzgUs/KAdKJPHPjg59BjCW0dGYVgmuUAC9rAXSWITVLJNCcBZNCEpg8BsXv/i4G7mJbT5+HlZmkQ2ZfPEaIXVmGmUOGPX2iodwhLBV7UMXU0AnA2CrgcLluEOXUpU6QvZ4CkJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pci9vjZw; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e0d82d441bso15366165ad.3;
        Thu, 04 Apr 2024 19:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712284149; x=1712888949; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wlRh9t6fwDbcB6l82RhAGGRXkd0+A6r2FWZKWmCGJk0=;
        b=Pci9vjZwD6S3W4yGJAKFXlLvJAxQhoeGYsgnQf9kfnNV0/2kxQj26arDlznGiVU65z
         w+U+i+MDkf5uHw7SqSNUVxxmI6Lpip56IySy8eD4rXDNw8k8Uhzre4HSMfUx9QRDfyuE
         4mPWm5tGd6gvMeEwzZLEbkR5AgDTvY7V2+dYoYUvA3fyPLGFJQtPwixhoOO4tNzaLmBl
         XMZp3gEi02kokRZ2ebpnEHaXAyIn/dxNCgBBMdRzpRa2IK2Ej7uKMw6pPrl7Ow4V+MQK
         WV2iENEq7AP/B7maVKb5/ptDoGAd0ti1jdmkl6BQ4ZSuz2oYH7ZFMOc6UqAjUSSryb5w
         80wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712284149; x=1712888949;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wlRh9t6fwDbcB6l82RhAGGRXkd0+A6r2FWZKWmCGJk0=;
        b=KkURdw4P1n1fD2N5bEvsoUlv61ZfiU0pQkzylWvKrOPlayYXMKsImOctCVmsP18eg+
         Mh0jF+pbObiWy/qxf5cK8nuSm2wx2O9Mam9+yWTpqdyG8l7ryqs+YL7fRpEGf2aYng37
         FlSxWXk+SqkwLLYNwjRCo3JYWBC/6c33bSrZ+17ZcyJH5TL/lTu71ILJVBw+FrQS+8Q2
         5GcEoKyb1KVt+6JCkh+afgqIdPQoBh4U+XI10xuMKalMItF0F9HHnDjI3knW1GYtRNUF
         rXgfJTtNl5x6IYYmG9Q9Ergcq4eqtBwsCV8ivSF793P6cg37LZAgdDFBxOjhOGeShwEC
         21ug==
X-Forwarded-Encrypted: i=1; AJvYcCXlmqxzyoqERjZAWFabpbynXBSkvEtIJAaM5hXJR+Bg1ho7tv1X9wQHqNQgKk5WdBdsSE0LWSsRFYwbtnnyNipCK6TTLVIh1KxlRSoHWcaSuJZVr88O3gVrpvL8OZE+B8Nq
X-Gm-Message-State: AOJu0YypwSVSyRUz5qkjw71URzd+t7pGOgYpDUlN/DTTQ5afdaVpqkJ7
	Ilq84Qn8KdxLt4qTRlCq7GAOcE45V29NY24/BxshpsGErmAJGzeJ3t9SE2EPhrw=
X-Google-Smtp-Source: AGHT+IE6K8Dogp7cIhU87tgYJHEdNXuzdYzmuYSOQRiZ/4ZaEUUr/jmu5B9zeknKbQ1DHiHJdxU7lw==
X-Received: by 2002:a17:902:f690:b0:1e2:887a:68a7 with SMTP id l16-20020a170902f69000b001e2887a68a7mr204162plg.33.1712284149371;
        Thu, 04 Apr 2024 19:29:09 -0700 (PDT)
Received: from [172.27.237.2] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id mo13-20020a1709030a8d00b001e2b36fd291sm351651plb.171.2024.04.04.19.29.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 19:29:08 -0700 (PDT)
Message-ID: <89927174-6ca9-4299-8157-a0404b30b156@gmail.com>
Date: Fri, 5 Apr 2024 10:28:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/15] x86/irq: Add a Kconfig option for posted MSI
Content-Language: en-US
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
 maz@kernel.org, seanjc@google.com, Robin Murphy <robin.murphy@arm.com>
References: <20240126234237.547278-1-jacob.jun.pan@linux.intel.com>
 <20240126234237.547278-5-jacob.jun.pan@linux.intel.com>
From: Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20240126234237.547278-5-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/27/2024 7:42 AM, Jacob Pan wrote:
> This option will be used to support delivering MSIs as posted
> interrupts. Interrupt remapping is required.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>   arch/x86/Kconfig | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 5edec175b9bf..79f04ee2b91c 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -463,6 +463,17 @@ config X86_X2APIC
>   
>   	  If you don't know what to do here, say N.
>   
> +config X86_POSTED_MSI
> +	bool "Enable MSI and MSI-x delivery by posted interrupts"
> +	depends on X86_X2APIC && X86_64 && IRQ_REMAP

Does posted_msi really depend on x2APIC? PID.NDST encoding supports both xAPIC 
and x2APIC.
If posted_msi posts more stringent requirement, I think it deserves an 
explanation in this patch's description.

And, X86_X2APIC already depends on IRQ_REMAP, can we just list one of them here?

