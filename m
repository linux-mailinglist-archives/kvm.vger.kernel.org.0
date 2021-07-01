Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606443B9255
	for <lists+kvm@lfdr.de>; Thu,  1 Jul 2021 15:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhGANfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jul 2021 09:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhGANfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jul 2021 09:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A5ED61350;
        Thu,  1 Jul 2021 13:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625146397;
        bh=9y/G4GqiWjaEFA7gQ40Q2HAnn+v4g/6FNU/E5maYV1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BfWCaCuMFb4k0ib98jqf3ARUIK7OnmopG2F5ys2cQU5ory6Xby2eVxj8c56q2UMph
         m/EJmyBY/eHdefOOmKcOMTebFeunooosEsy0jshTRMfwCVedhGjR5Z6nCNsPrxemld
         p3eAuBQmIohTVdJgEruKlwVmGvrkXfNs/KjnZgaldIzOA9GRkbhIfkq3uHBV95+WNu
         bXvwxmnOBvZnw7fU6943sa0PhiqQpGn42YJ2WqWn1nDCUELnbeg51Jp0BO5Sl3BOUP
         IXZngrsKTKev/7DNJEUS1Ym6eP4DtDdTVOo5HF4pyujB40jQAWTMR5E+naUPPyAtvQ
         e5tT6YHvovt3w==
Date:   Thu, 1 Jul 2021 14:33:12 +0100
From:   Will Deacon <will@kernel.org>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com
Subject: Re: [PATCH v2 07/13] KVM: arm64: Add config register bit definitions
Message-ID: <20210701133311.GG9757@willie-the-truck>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-8-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615133950.693489-8-tabba@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 02:39:44PM +0100, Fuad Tabba wrote:
> Add hardware configuration register bit definitions for HCR_EL2
> and MDCR_EL2. Future patches toggle these hyp configuration
> register bits to trap on certain accesses.
> 
> No functional change intended.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index bee1ba6773fb..a78090071f1f 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -12,7 +12,11 @@
>  #include <asm/types.h>
>  
>  /* Hyp Configuration Register (HCR) bits */
> +#define HCR_TID5	(UL(1) << 58)
> +#define HCR_DCT		(UL(1) << 57)
>  #define HCR_ATA		(UL(1) << 56)
> +#define HCR_AMVOFFEN	(UL(1) << 51)
> +#define HCR_FIEN	(UL(1) << 47)
>  #define HCR_FWB		(UL(1) << 46)
>  #define HCR_API		(UL(1) << 41)
>  #define HCR_APK		(UL(1) << 40)
> @@ -55,6 +59,7 @@
>  #define HCR_PTW		(UL(1) << 2)
>  #define HCR_SWIO	(UL(1) << 1)
>  #define HCR_VM		(UL(1) << 0)
> +#define HCR_RES0	((UL(1) << 48) | (UL(1) << 39))
>  
>  /*
>   * The bits we set in HCR:
> @@ -276,11 +281,21 @@
>  #define CPTR_EL2_TZ	(1 << 8)
>  #define CPTR_NVHE_EL2_RES1	0x000032ff /* known RES1 bits in CPTR_EL2 (nVHE) */
>  #define CPTR_EL2_DEFAULT	CPTR_NVHE_EL2_RES1
> +#define CPTR_NVHE_EL2_RES0	(GENMASK_ULL(63, 32) |	\
> +				 GENMASK_ULL(29, 21) |	\
> +				 GENMASK_ULL(19, 14) |	\
> +				 (UL(1) << 11))
>  
>  /* Hyp Debug Configuration Register bits */
>  #define MDCR_EL2_E2TB_MASK	(UL(0x3))
>  #define MDCR_EL2_E2TB_SHIFT	(UL(24))
> +#define MDCR_EL2_HPMFZS		(UL(1) << 36)
> +#define MDCR_EL2_HPMFZO		(UL(1) << 29)
> +#define MDCR_EL2_MTPME		(UL(1) << 28)
> +#define MDCR_EL2_TDCC		(UL(1) << 27)
> +#define MDCR_EL2_HCCD		(UL(1) << 23)
>  #define MDCR_EL2_TTRF		(UL(1) << 19)
> +#define MDCR_EL2_HPMD		(UL(1) << 17)
>  #define MDCR_EL2_TPMS		(UL(1) << 14)
>  #define MDCR_EL2_E2PB_MASK	(UL(0x3))
>  #define MDCR_EL2_E2PB_SHIFT	(UL(12))
> @@ -292,6 +307,12 @@
>  #define MDCR_EL2_TPM		(UL(1) << 6)
>  #define MDCR_EL2_TPMCR		(UL(1) << 5)
>  #define MDCR_EL2_HPMN_MASK	(UL(0x1F))
> +#define MDCR_EL2_RES0		(GENMASK_ULL(63, 37) |	\
> +				 GENMASK_ULL(35, 30) |	\
> +				 GENMASK_ULL(25, 24) |	\
> +				 GENMASK_ULL(22, 20) |	\
> +				 (UL(1) << 18) |	\
> +				 GENMASK_ULL(16, 15))

There's an inconsistent mix of ULL and UL here. Given we're on arm64,
maybe just use GENMASK() and BIT() for these RES0 regions?

Anyway, the bit positions all look fine. You're missing HLP in bit 26,
but I guess that's not something you care about?

Will
