Return-Path: <kvm+bounces-13567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F238988F1
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 15:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F30828656D
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 13:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC5C128833;
	Thu,  4 Apr 2024 13:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iSEuKMMH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6390112880A;
	Thu,  4 Apr 2024 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712237927; cv=none; b=dJVkwOD0WVgh2/bvoVy29mcWiDUS4zfhSOMo18wYG4Tdn5vLUYncftFtBbKf5lArRM7CKCbDR9EZyc1XCUhWemPOd2Njp6rvTU2Lpb92AkmOpYBD+BV0VDGyC5WFWYJxJnPl1wmZ5DQ3vf6z/8ymvk709Kl7mcXXyAjRAazXrNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712237927; c=relaxed/simple;
	bh=x8Lyghgp6/F9G9gkl5wcYiiVhCfyHgsqvEtMNlGYbZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uBn6edHR25IaZBVgb3tG9a5oON8uNYnnujWaA68C9+LIlgT1p14tHwz7AOKBVpc8eDKMnsCQDJh7P1CEtACQUZb1PvxHG7mYCLqu/Hje0zE4gajjbsJMTVT7ybWZ1gMPBurshZc9r4LfsG9c/X7608lqvCXMcSldHQeNt+doLY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iSEuKMMH; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6eaf7c97738so774139b3a.2;
        Thu, 04 Apr 2024 06:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712237926; x=1712842726; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tft6OeeDgSbfAOUrN5Xx5Zopkyg1jcKnp2CiC8iZD30=;
        b=iSEuKMMHN4Tn15z6X60Hk3AEesaN7Cc89/1IjnZopj0CS1xryd2BQtuQoISpMvkFNb
         gvFigbbx15zRTTqhVO2KI++4ERKESvfm/cS6i+nfsJc5wzE2y6D033DQ2Regg1l/vD0v
         H+OQ8rB+mHAtOFCU2d10kBwVK8AL6DkaB69tZdqr5T20HHxl7faDPQzSjQkTMgAzwK+K
         NIFqEbhzGzsDT8C3MZhSGIGCuDIdiPF61G02EmVhCTZU5fm5Y5/M0zD8C7SQ92HbpO2L
         ROWLYRoVGFk34esSUXUgaJj4SsU3B+extu76dK+G0AMJMrQHpEMeLy8KMVpa3Cyxp8as
         ptWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712237926; x=1712842726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tft6OeeDgSbfAOUrN5Xx5Zopkyg1jcKnp2CiC8iZD30=;
        b=nwdtfJMEvSSTWPjyHSax4evkZ3lMLrge4lTycG5PycrdFZdcOgsQARTNwjsVntJGgM
         dwLXib7j8kffOmlL1rKNXwHUA5iBRFXpq/g8ab4F1Jzwg5THQz4nq+yY8VBjxsAPQcZC
         XdHxMvKyv/nO3TTDm4VPwfovEqPx8DYlWnYMP6mlBCTdD2Sh5YGMIpzBTOfiqony2PIc
         JC341wMUKcRw1MH2Cy53VBIQx/zW6HHt1AOYYRLSH8fJAabcZTpUmLSPJHUv2kwcLA8m
         aR+iwNf8Ro3BHgWIB8q68nk0nep4zIPwKo6Q0Or1Ie32txRe0PuP+piMipw6SXEq6Dlj
         U8yQ==
X-Forwarded-Encrypted: i=1; AJvYcCVslseMqt2Gz+NBvLFvVLIRr/w4+mkwY0MLwtmgusan5zLlPFpfiglTaaBfGudE+u1OM/nD0CT7CvaD9dDi0m5pZZlQ4jfvseCLfNU1GKAgXoPomIVnZ7PVXqOj6pjROhTa
X-Gm-Message-State: AOJu0YxvrzUTrg7JSqC0n7COcHn9H1e4X1HT5s93K7wDFw4ciF0Mcdbx
	o0X0ns7ym6p4yp8xzaaeK+zepf5jJdKuAGWO0v0nY1mnyRA6AWtY997mTZtl11PfNA==
X-Google-Smtp-Source: AGHT+IGwYVCu7BN5Om9yXuxMS4L968QGnax7Rwa27cBqDVDI8qtrAZwX1+ZMyVsGVLwlnJVcobYbTw==
X-Received: by 2002:a05:6a20:3254:b0:1a3:bd8a:141f with SMTP id hm20-20020a056a20325400b001a3bd8a141fmr2516552pzc.54.1712237925633;
        Thu, 04 Apr 2024 06:38:45 -0700 (PDT)
Received: from [172.27.237.1] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id g21-20020a631115000000b005df58c83e89sm13472352pgl.84.2024.04.04.06.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 06:38:45 -0700 (PDT)
Message-ID: <9734e080-96e4-4119-8ae6-28abb7877a3c@gmail.com>
Date: Thu, 4 Apr 2024 21:38:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/15] x86/irq: Reserve a per CPU IDT vector for posted
 MSIs
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
 <20240126234237.547278-6-jacob.jun.pan@linux.intel.com>
From: Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <20240126234237.547278-6-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/27/2024 7:42 AM, Jacob Pan wrote:
> When posted MSI is enabled, all device MSIs are multiplexed into a single
> notification vector. MSI handlers will be de-multiplexed at run-time by
> system software without IDT delivery.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>   arch/x86/include/asm/irq_vectors.h | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
> index 3a19904c2db6..08329bef5b1d 100644
> --- a/arch/x86/include/asm/irq_vectors.h
> +++ b/arch/x86/include/asm/irq_vectors.h
> @@ -99,9 +99,16 @@
>   
>   #define LOCAL_TIMER_VECTOR		0xec
>   
> +/*
> + * Posted interrupt notification vector for all device MSIs delivered to
> + * the host kernel.
> + */
> +#define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
>   #define NR_VECTORS			 256
>   
> -#ifdef CONFIG_X86_LOCAL_APIC
> +#ifdef X86_POSTED_MSI

X86_POSTED_MSI --> CONFIG_X86_POSTED_MSI?

> +#define FIRST_SYSTEM_VECTOR		POSTED_MSI_NOTIFICATION_VECTOR
> +#elif defined(CONFIG_X86_LOCAL_APIC)
>   #define FIRST_SYSTEM_VECTOR		LOCAL_TIMER_VECTOR
>   #else
>   #define FIRST_SYSTEM_VECTOR		NR_VECTORS


