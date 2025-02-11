Return-Path: <kvm+bounces-37861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB4CA30BA9
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 13:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 557B91657D8
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 12:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EB391FCFE3;
	Tue, 11 Feb 2025 12:23:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3BD31FCD06
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 12:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739276594; cv=none; b=rxiF/ZkbrTMAArLllNHLmN3Kf9Dx7HgrWQcIW+qpG+3lU0RIWz8as7cvDEKCplwV2uPlr7RYPLi+vfAiG1sbfnSe4JGrM7pv+VG39IfZogXQMK6BcHDEZKwIiFg2TuCftiHkRED4trqxFMWf9Rcai5w/h68bcXPYhxLzIBQHQz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739276594; c=relaxed/simple;
	bh=WYbPqzeflxnkGcTvDdUhO/YJKcv6y3fF1K7+EzKaJgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WoeOWIwOasNL80M3yHdt2iGHMQjFQVQD3bvtbhJlkHVZhsRNRDWrewmo2uBiV7dbZTQqQqWbcqFNyb8za5usAGjmGWXH49Ah1glLLkyPwhnLFfmCGZ6q4pGCb/XwI6vvc6GglGoujjU+N9uFkMlk0X3PFqFdnH87ypNI6/TsL78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 729301424;
	Tue, 11 Feb 2025 04:23:33 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8026A3F6A8;
	Tue, 11 Feb 2025 04:23:10 -0800 (PST)
Date: Tue, 11 Feb 2025 12:23:08 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 02/18] arm64: Add syndrome information for trapped
 LD64B/ST64B{,V,V0}
Message-ID: <Z6tBLIsEejdCRQKP@J2N7QTR9R3>
References: <20250210184150.2145093-1-maz@kernel.org>
 <20250210184150.2145093-3-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210184150.2145093-3-maz@kernel.org>

On Mon, Feb 10, 2025 at 06:41:33PM +0000, Marc Zyngier wrote:
> Provide the architected EC and ISS values for all the FEAT_LS64*
> instructions.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/esr.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index d1b1a33f9a8b0..d5c2fac21a16c 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -20,7 +20,8 @@
>  #define ESR_ELx_EC_FP_ASIMD	UL(0x07)
>  #define ESR_ELx_EC_CP10_ID	UL(0x08)	/* EL2 only */
>  #define ESR_ELx_EC_PAC		UL(0x09)	/* EL2 and above */
> -/* Unallocated EC: 0x0A - 0x0B */
> +#define ESR_ELx_EC_LS64B	UL(0x0A)

This EC code has been generalised recently. In the latest ARM ARM (ARM
DDI 0487 L.a), which can be found at:

  https://developer.arm.com/documentation/ddi0487/la/?lang=en

... the table on page D24-7333 refers to it as:

| Trapped execution of any instruction not covered by other EC values.

... and the corresponding ISS description is named:

| ISS encoding for an exception from any other instruction

... so maybe it makes sense to call it 'ESR_ELx_EC_OTHER_INSN',
'ESR_ELx_EC_INSN_MISC', or something of that rough shape?

With that, the PSB CSYNC oddity in patch 15 makes a bit more sense,
though the L.a release of the ARM ARM is still missing the description
of that.

Mark.

> +/* Unallocated EC: 0x0B */
>  #define ESR_ELx_EC_CP14_64	UL(0x0C)
>  #define ESR_ELx_EC_BTI		UL(0x0D)
>  #define ESR_ELx_EC_ILL		UL(0x0E)
> @@ -174,6 +175,11 @@
>  #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
>  #define ESR_ELx_xVC_IMM_MASK	((UL(1) << 16) - 1)
>  
> +/* ISS definitions for LD64B/ST64B instructions */
> +#define ESR_ELx_ISS_ST64BV	(0)
> +#define ESR_ELx_ISS_ST64BV0	(1)
> +#define ESR_ELx_ISS_LDST64B	(2)
> +
>  #define DISR_EL1_IDS		(UL(1) << 24)
>  /*
>   * DISR_EL1 and ESR_ELx share the bottom 13 bits, but the RES0 bits may mean
> -- 
> 2.39.2
> 

