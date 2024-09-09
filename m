Return-Path: <kvm+bounces-26135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11796971E16
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 17:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DEBE1C21A3F
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 15:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80A533B791;
	Mon,  9 Sep 2024 15:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F73yS21D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4B2200B5
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 15:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725896004; cv=none; b=poyAR1FSPsdsJTFLnLEhGUYIiRd9q/nePMJeOh022XzZDvQrC1D64v+BVp2qz7TwYaKKzmN2tja7I8GBf/71xxO63R6wxXPF2L2cLorTdLM4H1BZGCsjJrzE6+QxuKSWL5kTIS/k0sZpcr6Dj+BXkRa/f9Vi37KoKeYLmksZMD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725896004; c=relaxed/simple;
	bh=RQstpKYBysV0fJEEMraqxwfamzRl6MqPGS9YNkTUTmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ztlz16Z5rkKqhHFu/IcaIEd0xH/prDDCFLc5EBzNT0+a/5VG/KUzIOtF6Gr2XaBDhg0u9JRmqa/+arNMPTNGpuqVDF2TqAL2yym2kicQZC+Vjo4CuD2Mb/8jwG0kzNQuuLnIxQptZlgvyW1aw/wjvmJRtChMVVjFvtOrLVZbJRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F73yS21D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725896002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=W4pNeMR/cD4qSUUyt8Fkj7gag9Lbiv2YrjkcbcuIMIs=;
	b=F73yS21DwNM7aygGYe6cuKdCxfMVp6TNC5eas4TBDNSc8pZylvwM45s8BM31mBPZ+NTPRm
	LfBRiemgJGiYfgrOer8N5iN6vdgtaQk6ikkwxtPQoZiw4dKYZYJq5O0EHuByMwLPZiirgf
	jOCDQGodSlk7PJu000TMeo8XoNMeCa4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-4KTLJAJjM1KMdQjJxfTc7w-1; Mon, 09 Sep 2024 11:33:20 -0400
X-MC-Unique: 4KTLJAJjM1KMdQjJxfTc7w-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42ca8037d9aso23634595e9.3
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 08:33:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725896000; x=1726500800;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W4pNeMR/cD4qSUUyt8Fkj7gag9Lbiv2YrjkcbcuIMIs=;
        b=lSaEEU5DLDnaXqh6wxJBcOnadQetObje+/+UtksDWKftSX4lL8EfKJdHoNVIw2oQh5
         1OSx2dcedMl3c1td59BnFNdP5vlI2PEVM7/ikqVDkDrl2hRvhq8f+/7Gd5QrNlY4k4Cv
         powcdRHGnNFlLGSRQPHCI6arNDXAgbFvt9RRVcotMFnINq0D/6iVxfQ61nvGfDhw7Ia0
         8a1GddroxLpJMSSd/ZU8UlwHLj2vvQifYZ+H7gOjICh+irlvUVcTEazuYcYTk1U9gshM
         wc+p1LSTuc6EEihIiwByayfkKiKXHTQc3cL+ZowpFDihTiCKADhEs4ftLydtoK371/de
         wQcw==
X-Forwarded-Encrypted: i=1; AJvYcCWAc/q3V+BvZF/1H/yBPUrG9CuBvXKejVqnZcCjTxSHs6aiglnu7jW6f/h3e6uCeSdr/J8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcqMFX/R92DJlGdAQ029/ZbAFQkimBWDSDRf45b7lfRHe/BuxW
	BNCjnIWPNE7Ht9QThb1qyA21ouMTQUkshyRacI7M/yDYWvq8VU8yQIhUoV8NHh0i0cEiP0D5x8W
	LCJdhNQz+ghruIpP5YZYt+bNkZcS1MD7HPOVm8ihcCoK5EFV4iw==
X-Received: by 2002:a05:600c:1f8c:b0:42c:b6db:4270 with SMTP id 5b1f17b1804b1-42cb6db448cmr28843905e9.11.1725895999647;
        Mon, 09 Sep 2024 08:33:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaj3y8JQ3aF22TN52GILlj8S4cIebL43Sb8l1rA7fdsZWasSFPvXBy3m4SBuHYEF4OlFNLAg==
X-Received: by 2002:a05:600c:1f8c:b0:42c:b6db:4270 with SMTP id 5b1f17b1804b1-42cb6db448cmr28843645e9.11.1725895999136;
        Mon, 09 Sep 2024 08:33:19 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.101.29])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42caeb8afc9sm80727185e9.44.2024.09.09.08.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Sep 2024 08:33:18 -0700 (PDT)
Message-ID: <436b8525-e4be-4c1e-b2e4-2e4356379cc4@redhat.com>
Date: Mon, 9 Sep 2024 17:33:17 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/21] KVM: TDX: Set per-VM shadow_mmio_value to 0
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
 kvm@vger.kernel.org
Cc: kai.huang@intel.com, dmatlack@google.com, isaku.yamahata@gmail.com,
 yan.y.zhao@intel.com, nik.borisov@suse.com, linux-kernel@vger.kernel.org
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-13-rick.p.edgecombe@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240904030751.117579-13-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 05:07, Rick Edgecombe wrote:
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 46a26be0245b..4ab6d2a87032 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -94,8 +94,6 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
>   	u64 spte = generation_mmio_spte_mask(gen);
>   	u64 gpa = gfn << PAGE_SHIFT;
>   
> -	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
> -
>   	access &= shadow_mmio_access_mask;
>   	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
>   	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 0c08062ef99f..9da71782660f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -6,7 +6,7 @@
>   #include "mmu.h"
>   #include "tdx.h"
>   #include "tdx_ops.h"
> -
> +#include "mmu/spte.h"
>   
>   #undef pr_fmt
>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> @@ -344,6 +344,19 @@ int tdx_vm_init(struct kvm *kvm)
>   {
>   	kvm->arch.has_private_mem = true;
>   
> +	/*
> +	 * Because guest TD is protected, VMM can't parse the instruction in TD.
> +	 * Instead, guest uses MMIO hypercall.  For unmodified device driver,
> +	 * #VE needs to be injected for MMIO and #VE handler in TD converts MMIO
> +	 * instruction into MMIO hypercall.
> +	 *
> +	 * SPTE value for MMIO needs to be setup so that #VE is injected into
> +	 * TD instead of triggering EPT MISCONFIG.
> +	 * - RWX=0 so that EPT violation is triggered.
> +	 * - suppress #VE bit is cleared to inject #VE.
> +	 */
> +	kvm_mmu_set_mmio_spte_value(kvm, 0);
> +
>   	/*
>   	 * This function initializes only KVM software construct.  It doesn't
>   	 * initialize TDX stuff, e.g. TDCS, TDR, TDCX, HKID etc.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>


