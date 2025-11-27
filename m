Return-Path: <kvm+bounces-64892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E4FA9C8F8CA
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:50:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A444834D8BF
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 16:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4B63337B95;
	Thu, 27 Nov 2025 16:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CqFDgQoF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4992D9EDA
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 16:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764262193; cv=none; b=JH4v2SerYE6BdPdAb5wIgnAzlGJdHcqjadh1zX/7qRb5GEqskR+L2IFKZFVBme27jyGfRZQ6Xb6GHWJ7/lXzwGtjIvxTpPemkKIcUsqn+yViuEfBUb8RDxMxM5xtAMeMcAYrN55OR+SoiMg+9CVRL+jHnYPCE6kpGY9EIk68DDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764262193; c=relaxed/simple;
	bh=2GkoMiW1aOXux7Oy2sMmlIrHWqkBrcbNDpdWRYEyKO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IUzF3KtSiwquy9Vw5E7mvaxXW0Hs6cjBSaRhPOzhPjPhQzNhbLgH0pujGZ/e4FLXXasR2a+ama/xmo02CIBjIr+y7XKfO5whZHNDpFFli/xnUIO7fWwNa/+Iw/4CvYJifWgp3gFmGVwDNWJsaBAU4pHPvM17Fs+P3ymorUWtTMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CqFDgQoF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764262191;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k7Uz86MWYfQL+y6cfsCHemHYwZCFKIe5X+o1N7gMtLs=;
	b=CqFDgQoFUnQT3RyHuif1FoG/UeY+M+lsafaZooO5wZ33vStIHir+LyPyq8C/FwaWTzwBow
	Xy3P9jW9e/OwGV5D7Kp5ZaEO8MZrLVgE6RSeqB1pXZFZ3qhXatak9k/6Hyh1dU4irz9PRK
	XgG+lYDSyHwBfUcr+hzJVTjrNkkjAsE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-487-XKDJ7Mk4MoOF4Q1eHJPlUg-1; Thu, 27 Nov 2025 11:49:49 -0500
X-MC-Unique: XKDJ7Mk4MoOF4Q1eHJPlUg-1
X-Mimecast-MFC-AGG-ID: XKDJ7Mk4MoOF4Q1eHJPlUg_1764262189
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8a1c15daa69so267867985a.1
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 08:49:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764262189; x=1764866989;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k7Uz86MWYfQL+y6cfsCHemHYwZCFKIe5X+o1N7gMtLs=;
        b=NVBV1r1iAuDAw68gEtdwrT3TB7/b8lGnT4ZcP64DXWpyeSuULIVvX7BN38cYWCbsxf
         2Gx3nSiGdRo9WO5r/1d4G0bIEzfjOhuY6dyJMRj1uCwIBXghpeH35zh7ckneJIaLgVIx
         StTMfdMmmsYro2jesLlPxfMZfdcQycUfv6fHV1J9q58+5AtDxm9c6eBqecscIPvVpzDZ
         QM3V4qj7u4a7271XsmxHpKuqI41vaCa9rx8XvAYBo96C1oW9k4rtw/wS1OCa9i3595bj
         LI9riT79N3P4o23DqpjXvJKYkESv2drWwWRHgxcwSJ3Kjy2v0KpCl4Y1PRJ4Tqu7oECz
         xj9g==
X-Forwarded-Encrypted: i=1; AJvYcCX2wvHxXP0f3AUjbGdpoGFckPAgbkyMQX5T1waExbqOFhRxiNI3JsZKSz2yNIPHClDYt8w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPoLI7lrlKIDgwB8mmMd958qESYT3Kq8Naux+5VCwkU66lM7xQ
	bhufYBPfLztAfmGe0mJKEKb01ZZKZYWEEKKxY+t8/DBBIihhCp04cRdHIfHgx8tWm/HKp6OWkuE
	qEQz26jgdK50pLgN/N7tKKhX41R5wFGzG33dAmpeDCJxD6S4Pntb+Og==
X-Gm-Gg: ASbGncvngsR821LQ6VY6eAc3nBuznSMIvh3vfnekIg2gulSjwPstIQfj5MQZiOayIH5
	7up5VG5O03AC6CPtBhCP1mRHtQLDX9755Zsd+exklt2S05i7dM5it2WOA2iomOy7y8L8/JR/QxJ
	QCBBQIF22b9NB1ZtUT9/Jk+ppPTKBI3O+uOsuVVDA719EZlHsTsGtOJVWPIf49/D2GvQr+0O+N9
	wol/yU2gvMconjU99HYBdzeO49ZCtriQdxLj+MdCMYehSMfai49hvcarMVLZZGDgrbll9NgVIA6
	+omow5p162Pt/MxFcwYyAgJaZLMvhlc/oAf8BPA9BelyWXU5dkB2Ph4CoSlP2yRk7LuqxNKHD2b
	Il2Tth19b2Xnw5n0WFmd58vteLN3uK6TM1w+3a72yTT1bQU86QQe9Z5pfQQ==
X-Received: by 2002:a05:620a:25c7:b0:89e:67a9:fcf1 with SMTP id af79cd13be357-8b4ebdaea90mr1500121385a.52.1764262189334;
        Thu, 27 Nov 2025 08:49:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFaTomno2Tlgqds4NSGAWNKA9Sj7QFcdWKkY4vTpNLJn+xX+6DRbAf650DtgDJ/AfspXBsVxA==
X-Received: by 2002:a05:620a:25c7:b0:89e:67a9:fcf1 with SMTP id af79cd13be357-8b4ebdaea90mr1500114285a.52.1764262188357;
        Thu, 27 Nov 2025 08:49:48 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b52a1b759esm137332485a.31.2025.11.27.08.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 08:49:47 -0800 (PST)
Message-ID: <92f27f98-e4c9-41d9-badc-635e5ba40552@redhat.com>
Date: Thu, 27 Nov 2025 17:49:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 02/10] arm64: efi: initialise SCTLR_ELx
 fully
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-3-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-3-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Joey,

On 9/25/25 4:19 PM, Joey Gouly wrote:
> Don't rely on the value of SCTLR_ELx when booting via EFI.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> ---
>  lib/arm/asm/setup.h   |  6 ++++++
>  lib/arm/setup.c       |  3 +++
>  lib/arm64/processor.c | 12 ++++++++++++
>  3 files changed, 21 insertions(+)
>
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index 9f8ef82e..4e60d552 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -28,6 +28,12 @@ void setup(const void *fdt, phys_addr_t freemem_start);
>  
>  #include <efi.h>
>  
> +#ifdef __aarch64__
> +void setup_efi_sctlr(void);
> +#else
> +static inline void setup_efi_sctlr(void) {}
> +#endif
> +
>  efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
>  
>  #endif
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 67b5db07..0aaa1d3a 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -349,6 +349,9 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  {
>  	efi_status_t status;
>  
> +
spurious line
> +	setup_efi_sctlr();
> +
>  	exceptions_init();
>  
>  	memregions_init(arm_mem_regions, NR_MEM_REGIONS);
> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
> index eb93fd7c..edc0ad87 100644
> --- a/lib/arm64/processor.c
> +++ b/lib/arm64/processor.c
> @@ -8,6 +8,7 @@
>  #include <libcflat.h>
>  #include <asm/ptrace.h>
>  #include <asm/processor.h>
> +#include <asm/setup.h>
>  #include <asm/thread_info.h>
>  
>  static const char *vector_names[] = {
> @@ -271,3 +272,14 @@ bool __mmu_enabled(void)
>  {
>  	return read_sysreg(sctlr_el1) & SCTLR_EL1_M;
>  }
> +
> +#ifdef CONFIG_EFI
> +
> +void setup_efi_sctlr(void)
> +{
> +	// EFI exits boot services with SCTLR_ELx.M=1, so keep
> +	// the MMU enabled.
I don't really understand the comment, if MMU was enabled why are we
mandated to set M bit again?

Eric
> +	write_sysreg(INIT_SCTLR_EL1_MMU_OFF | SCTLR_EL1_M, sctlr_el1);
> +}
> +
> +#endif


