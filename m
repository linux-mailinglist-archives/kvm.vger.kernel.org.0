Return-Path: <kvm+bounces-65102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF614C9B2FF
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 11:37:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B39333A706F
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 10:35:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B8230C371;
	Tue,  2 Dec 2025 10:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iJekQqn4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAE4303A08
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 10:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764671733; cv=none; b=QrXwnfPPmVt+EuPr2yayECkJB52E9us35eiMLGixeS4X1ZNX1IIc363zoKwDMtceeB8SWWLb1ix/SUZYrxhi0r2+jVDsnqvcOeDhSQM7xdHpcqkNZU4FOEGqZ4ByNXamHkHkjFoXYIq8MCDkzFQ5zSUOPebuto4AEFXDMWCbRW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764671733; c=relaxed/simple;
	bh=8ehwieRgME29YittKX3I6p8D8uoKGas4AaSH/vNw+ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZW9P6G0IhkBZuLB/8go0M/dqCKYGK+M1ZvENIfdNN8IFTZKn2e86FS2QdBTKYi7RqtIDCQNnKhOu7JlGfuSKQa4RoMCNx9As5Ken1+oF/kIRnZDoCo1LiJLPLQEsIczw4nIXnD9arziS5C4BLR3XhIwSvBRQi+ixchO3jX11F0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=fail smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iJekQqn4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764671731;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nVckf801EzlHLt3eBGX4mHh0JO99LKIAjAwFPbJ7PrM=;
	b=iJekQqn4Q34Np/7PbLsUMb2Pzp8Tmu2ccaJKCeop9tmM9xnITGq6dA32M0C4VvLE2LEyQ7
	YqCesUU7Bd7Wdz8FhkD/+3D5rsc6SK7Oh8opHdKgpDRnfX07qiX7HQemoZB/EZX+kGoOQn
	kwcU/ve3wBSts0lfTf0SyqgzFAocyXI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-b8pORS3PNcqloVmjClprxQ-1; Tue, 02 Dec 2025 05:35:29 -0500
X-MC-Unique: b8pORS3PNcqloVmjClprxQ-1
X-Mimecast-MFC-AGG-ID: b8pORS3PNcqloVmjClprxQ_1764671729
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-88237204cc8so141640076d6.2
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 02:35:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764671729; x=1765276529;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nVckf801EzlHLt3eBGX4mHh0JO99LKIAjAwFPbJ7PrM=;
        b=pr3Khl0q/DmzeEC7wP+s8dfiulkDoThx9xswUUgoJx5N08Ur3QK847TgjdON+hCBVH
         FK3R+Ud81wAIk2rfJ7yWKYnmi1OLlwk2755RoEkUpI9VhTonKGaYoj/aNwv+mxD2HzDJ
         fbzCisyMpZM+cpphk0q4wiSK0PXZ9LbnD6FlOYrSaq8JLQeCPvI/ZOAXZQNn9tJAbdAq
         iSwHYaSR34E70ItwLxIhQBh1M+vii0vs4swgEEiDowQAG3kWxxL8PGeCRW3iAols/gSs
         LydChqviWIhQm9ANWsf53BojVJKgNos+pl3bMAF2y8HXgfRPtUQlqtzOnaNL2IdsmrDN
         azEA==
X-Forwarded-Encrypted: i=1; AJvYcCVrs77JYsw2d7/Iseu7m7T1uFwGItlCmqj15mNCcGyX3NcHrKgGqGv3ihcmET1amNWpAIw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy93a5lbHdvrm7xsof+Oi8q95EqZqKjQtkxrl0g2OxWWr3zklY2
	H4Er1GohVQ1BW/WK93jXBTBB5PQxeyD56LwBLiMEHhebvsRXsPKCmHYjyX+WnhINLkkEZIeyPxC
	6jhdi03jR15AlTcOJM/aq5MrpabAsZg6WNXWPzmEXgCuHc6xAph8YTA==
X-Gm-Gg: ASbGncvB/j2DwgWNSm6NQheyRB3oSK//QlfdyYAiaKSNEm3DrSihV2T3/KHveIuBBJy
	6UOlT5uuhtjU1m2IInCFsgFYcDMvZhXyJO0+pFQpT1ifznf9GQlAqc/gtsr36PXHqIepTeY7KpN
	GuHDkjCF7adGStFiC1zTB3AvcZ78a346+tXiBHT6m3w8OxDMwp7Z8JsaVb5tt0xdMVxNoCivefs
	rvEeO2AujCCDb9KOsB4RYOjROmgfIfqy7qdzGu27Ks6fAbRC7g8NZso4yZYAHwxP7j6mGL4Rddp
	AokwQjBGaj2viWOTnadhMZmLrbqhBYCYumDFqf+roeNrpC6JE3KGdCsDAYp4LkoocYJqzJ9GhU2
	OT6nqyliU0cbu6p7M1z34HWhZKpkGN+GKO7GjmfRwzyPCS/1ZfhKQyZBuDg==
X-Received: by 2002:a05:6214:212b:b0:7f7:777e:39c5 with SMTP id 6a1803df08f44-8863af15e51mr447369506d6.25.1764671728783;
        Tue, 02 Dec 2025 02:35:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHGEbGb2r6oAFr49aUac0U3SAzN0PPLJROZTPCjIXcuNk6VSBXpQXplvBnfUNVbCdUK5fRCMw==
X-Received: by 2002:a05:6214:212b:b0:7f7:777e:39c5 with SMTP id 6a1803df08f44-8863af15e51mr447369246d6.25.1764671728422;
        Tue, 02 Dec 2025 02:35:28 -0800 (PST)
Received: from ?IPV6:2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e? ([2a01:e0a:fa3:e4b0:95dc:ab11:92db:6f9e])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b6851dsm100885856d6.42.2025.12.02.02.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 02:35:27 -0800 (PST)
Message-ID: <0ceb3518-6eb2-4d0d-95c5-f926cce313ca@redhat.com>
Date: Tue, 2 Dec 2025 11:35:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 09/10] arm64: run at EL2 if supported
Content-Language: en-US
To: Joey Gouly <joey.gouly@arm.com>, kvm@vger.kernel.org
Cc: alexandru.elisei@arm.com, andrew.jones@linux.dev, kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20250925141958.468311-10-joey.gouly@arm.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250925141958.468311-10-joey.gouly@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/25/25 4:19 PM, Joey Gouly wrote:
> If VHE is supported, continue booting at EL2, otherwise continue booting at
> EL1.
>
> Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  arm/cstart64.S         | 17 +++++++++++++----
>  lib/arm64/asm/sysreg.h |  5 +++++
>  2 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 79b93dd4..af7c81c1 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -18,7 +18,7 @@
>  .macro init_el, tmp
>  	mrs	\tmp, CurrentEL
>  	cmp	\tmp, CurrentEL_EL2
> -	b.ne	1f
> +	b.ne	2f
>  	/* EL2 setup */
>  	mrs	\tmp, mpidr_el1
>  	msr	vmpidr_el2, \tmp
> @@ -41,17 +41,26 @@
>  	msr_s	SYS_HFGWTR2_EL2, \tmp
>  	msr_s	SYS_HFGITR2_EL2, \tmp
>  .Lskip_fgt_\@:
> +	/* check VHE is supported */
> +	mrs	\tmp, ID_AA64MMFR1_EL1
> +	ubfx	\tmp, \tmp, ID_AA64MMFR1_EL1_VH_SHIFT, #4
> +	cbz	\tmp, 1f
> +	ldr	\tmp, =(INIT_HCR_EL2)
> +	msr	hcr_el2, \tmp
> +	isb
> +	b	2f
> +1:
>  	mov	\tmp, #0
>  	msr	cptr_el2, \tmp
>  	ldr	\tmp, =(INIT_HCR_EL2_EL1_ONLY)
>  	msr	hcr_el2, \tmp
>  	mov	\tmp, PSR_MODE_EL1t
>  	msr	spsr_el2, \tmp
> -	adrp	\tmp, 1f
> -	add	\tmp, \tmp, :lo12:1f
> +	adrp	\tmp, 2f
> +	add	\tmp, \tmp, :lo12:2f
>  	msr	elr_el2, \tmp
>  	eret
> -1:
> +2:
>  .endm
>  
>  
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index ed776716..f2d05018 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -80,6 +80,8 @@ asm(
>  #define ID_AA64MMFR0_EL1_FGT_SHIFT	56
>  #define ID_AA64MMFR0_EL1_FGT_FGT2	0x2
>  
> +#define ID_AA64MMFR1_EL1_VH_SHIFT	8
> +
>  #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
>  #define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
>  #define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
> @@ -116,9 +118,12 @@ asm(
>  #define SCTLR_EL1_TCF0_SHIFT	38
>  #define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
>  
> +#define HCR_EL2_TGE		_BITULL(27)
>  #define HCR_EL2_RW		_BITULL(31)
> +#define HCR_EL2_E2H		_BITULL(34)
>  
>  #define INIT_HCR_EL2_EL1_ONLY	(HCR_EL2_RW)
> +#define INIT_HCR_EL2		(HCR_EL2_TGE | HCR_EL2_E2H | HCR_EL2_RW)
>  
>  #define SYS_HFGRTR_EL2		sys_reg(3, 4, 1, 1, 4)
>  #define SYS_HFGWTR_EL2		sys_reg(3, 4, 1, 1, 5)


