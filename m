Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFBCE753832
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 12:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbjGNKbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 06:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbjGNKba (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 06:31:30 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EFEE2738
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 03:31:29 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 439F81570;
        Fri, 14 Jul 2023 03:32:11 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF5513F67D;
        Fri, 14 Jul 2023 03:31:27 -0700 (PDT)
Date:   Fri, 14 Jul 2023 11:31:25 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Nadav Amit <namit@vmware.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
Message-ID: <ZLEj_UnDnE4ZJtnD@monolith.localdoman>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230617013138.1823-2-namit@vmware.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Sat, Jun 17, 2023 at 01:31:37AM +0000, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Do not assume PAN is not supported or that sctlr_el1.SPAN is already set.

In arm/cstart64.S

.globl start
start:
        /* get our base address */
	[..]

1:
        /* zero BSS */
	[..]

        /* zero and set up stack */
	[..]

        /* set SCTLR_EL1 to a known value */
        ldr     x4, =INIT_SCTLR_EL1_MMU_OFF
	[..]

        /* set up exception handling */
        bl      exceptions_init
	[..]

Where in lib/arm64/asm/sysreg.h:

#define SCTLR_EL1_RES1  (_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
                         _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
#define INIT_SCTLR_EL1_MMU_OFF  \
                        SCTLR_EL1_RES1

Look like bit 23 (SPAN) should be set.

How are you seeing SCTLR_EL1.SPAN unset?

Thanks,
Alex

> 
> Without setting sctlr_el1.SPAN, tests crash when they access the memory
> after an exception.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  arm/cstart64.S         | 1 +
>  lib/arm64/asm/sysreg.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 61e27d3..d4cee6f 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -245,6 +245,7 @@ asm_mmu_enable:
>  	orr	x1, x1, SCTLR_EL1_C
>  	orr	x1, x1, SCTLR_EL1_I
>  	orr	x1, x1, SCTLR_EL1_M
> +	orr	x1, x1, SCTLR_EL1_SPAN
>  	msr	sctlr_el1, x1
>  	isb
>  
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index 18c4ed3..b9868ff 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -81,6 +81,7 @@ asm(
>  
>  /* System Control Register (SCTLR_EL1) bits */
>  #define SCTLR_EL1_EE	(1 << 25)
> +#define SCTLR_EL1_SPAN	(1 << 23)
>  #define SCTLR_EL1_WXN	(1 << 19)
>  #define SCTLR_EL1_I	(1 << 12)
>  #define SCTLR_EL1_SA0	(1 << 4)
> -- 
> 2.34.1
> 
> 
