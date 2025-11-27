Return-Path: <kvm+bounces-64904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15BD8C8F99B
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 18:09:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C937A3AAD09
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 17:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15CC72DECB9;
	Thu, 27 Nov 2025 17:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QOYw7Tmd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F24D2DEA87
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 17:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764263347; cv=none; b=rtQTqrfbeORSQRYYnnLOIhD342TJZSwu8xRE/R0fTi3eXNOoeHNPziLnPeXJcNJUu743slCAMDImfAInLCghTHVyH2+1ke7W6Uns02AsQ3Io6ydyk5CUIeiEcTXG7qctgcIxUtPO5HlnVGbcFrsdY+5tZsv8ndoBO/EDjMin/jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764263347; c=relaxed/simple;
	bh=vBvIKRWfPaQXkjoG7SlBmbYLMxL8M3S+eVL65Atr1dM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hoQBqPTf6kR5rQoUx0LrfwIuloM0OB+gSEjnBvEcAJTahXz0hBgGCBxDT8EFhHevl/TTIsOAE+ixvFip3or7uo77tdXmhQ0J1xGgUMgu1eUiNl67XWlESWqRrXjqeekscTAF0jKMB89EvoD8pDpWeApM5NYcBF9WeWwR6ukMVqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QOYw7Tmd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764263344;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OAb16FdwyMSYNIxUJ299HViLFfqQavTjzCEBKiggKc8=;
	b=QOYw7TmdCAniMlUqjpshWtwGI2nb+vbp6hXILqJriq9vJe/tB0uqW9iixLuMgtgfXiSxoR
	raTE4vmLLXsbnfxHGnbdwce8rKIVAT09+hi+FNRNm9L13fuVCd6rBkCMW6RF1LgRP7RiUz
	qpbo9VU4rfpR1+/K3EMwxLsJDPLCDqI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-QqmSd-B6PoiliJElTm9wcA-1; Thu, 27 Nov 2025 12:09:02 -0500
X-MC-Unique: QqmSd-B6PoiliJElTm9wcA-1
X-Mimecast-MFC-AGG-ID: QqmSd-B6PoiliJElTm9wcA_1764263342
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4ed82af96faso17916931cf.1
        for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 09:09:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764263342; x=1764868142;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OAb16FdwyMSYNIxUJ299HViLFfqQavTjzCEBKiggKc8=;
        b=B6m4/wpCRokRDDn8P/qtntlWVGAWQ1Yc/3uKB2lpZDPMVI6MeExYRFPsGhqpU4RhkZ
         N84d2ZdMlxUuKv2zDedG180aKiVmlXObrVyCLbpw2F3cO3rSZn5KOwsPsjxTHqlddmgh
         Xrs4LSS1FzwmolkcFc/c0eRwV5PitQwhVMajk+sNjX/Hx+NMEVpX28apIW1mrjPJfTt3
         Kue16vCvlZPRITDdLcOjFelUKzFj4tEk7aLjqR79W9sQqMQihpSmJrX0fMT/5v/ThQdj
         N3KFVtvSJaT9ejDcrQ75TjCD20/NnWxMoco+ewkA5/U7N35lk1xtonUDVjTMTrkJoDZw
         msVw==
X-Forwarded-Encrypted: i=1; AJvYcCVx73JBoIzPjrZlf1CJrSOFoSMqhpHvctiZ8gDoIDBUZZeWSWyaSuNbKXMWWEIj5ulM3TQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywey3kWXsXgXHuUBXkCuTH3fUucMrXxk675gFi3/zEIxp5aWBtm
	jixdH6z2U1nDnQGVwarsedAiVOkALSDROIMUSMs3uCmMd/BFuUpn5OmZXcxGHYhMqo9nDC8P/OL
	FCzWPLx/nuH2VJct4RsnQ89jqqESbGn6et3m8unnwxM0HutrinraxuQ==
X-Gm-Gg: ASbGnctTjjYmN0gOKlvWbeW/utnOgU5aTDrTsJwfWGa/CZJWhBsuv/PQF+3U69xE7jS
	vL93Gy688Y6rbQOMNOJoDsmJ5zAw3Ma3g3Jh2uyKBCaDQywq57rnwhV41IY/Hc+6JcUzyXZQLtl
	p94Qv9kMiP5FeQ2Wqq82VklCFe6P368dwVgUfB5WkwECuoQ0nUizxOaPsbJ8+DN0PzacGpVVfGk
	HMDTbT9bjr7wPCNoqTGaOz/GCxCUFGZl8JzpQ666Dnlub0oj0HrdsMzHEzb1Ex7cgkMJ5m+qvA5
	l3og9qREqkYa4n89FCoSvbeQlantlx8Fo+V++iFcow3gH2rVL0tj8NdI3sziVAViuQ4MHw9o/Bl
	yMw/7XqQADTIQTT4JEYATW1SLwrIAq8T1Vg9CLG9Lbb6FpQA26yvCjQij9A==
X-Received: by 2002:a05:622a:294:b0:4ee:19f2:9f1b with SMTP id d75a77b69052e-4ee58a79321mr379318161cf.37.1764263342279;
        Thu, 27 Nov 2025 09:09:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE7SDD1pz2kq89q4lSRs0L5SYetYPSbwxZB+UZXIRwmEKamSd3OD+efib0aN3YltOkmWfBspw==
X-Received: by 2002:a05:622a:294:b0:4ee:19f2:9f1b with SMTP id d75a77b69052e-4ee58a79321mr379317591cf.37.1764263341908;
        Thu, 27 Nov 2025 09:09:01 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-886524e5cfcsm13407616d6.19.2025.11.27.09.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 09:09:00 -0800 (PST)
Message-ID: <042f890a-cee4-4a87-a13e-f9fcca4381c9@redhat.com>
Date: Thu, 27 Nov 2025 18:08:58 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 03/10] arm64: efi: initialise the EL
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-4-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-4-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> Initialise the exception level, which may include dropping to EL1 from EL2, if
> VHE is not supported.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/efi/crt0-efi-aarch64.S | 5 +++++
>  lib/arm/asm/setup.h        | 2 ++
>  lib/arm/setup.c            | 1 +
>  3 files changed, 8 insertions(+)
>
> diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
> index 71ce2794..5632fee0 100644
> --- a/arm/efi/crt0-efi-aarch64.S
> +++ b/arm/efi/crt0-efi-aarch64.S
> @@ -147,6 +147,11 @@ _start:
>  0:	ldp		x29, x30, [sp], #32
>  	ret
>  
> +.globl do_init_el
> +do_init_el:
> +	init_el x16
> +	ret
> +
>  	.section	.data
>  
>  .balign 65536
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index 4e60d552..bf05ffbb 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -29,8 +29,10 @@ void setup(const void *fdt, phys_addr_t freemem_start);
>  #include <efi.h>
>  
>  #ifdef __aarch64__
> +void do_init_el(void);
>  void setup_efi_sctlr(void);
>  #else
> +static inline void do_init_el(void) {}
>  static inline void setup_efi_sctlr(void) {}
>  #endif
>  
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 0aaa1d3a..5ff40b54 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -349,6 +349,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
>  {
>  	efi_status_t status;
>  
> +	do_init_el();
>  
>  	setup_efi_sctlr();
>  


