Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3120832C6A8
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451080AbhCDA3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:48 -0500
Received: from foss.arm.com ([217.140.110.172]:53216 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1574375AbhCCRdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 12:33:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CFCFF12FC;
        Wed,  3 Mar 2021 09:32:49 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A4EA3F7D7;
        Wed,  3 Mar 2021 09:32:48 -0800 (PST)
Date:   Wed, 3 Mar 2021 17:32:45 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH 5/6] arm64: Configure SCTLR_EL1 at boot
Message-ID: <20210303173245.2b765784@slackpad.fritz.box>
In-Reply-To: <20210227104201.14403-6-alexandru.elisei@arm.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
        <20210227104201.14403-6-alexandru.elisei@arm.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 27 Feb 2021 10:42:00 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> Some fields in SCTLR_EL1 are UNKNOWN at reset and the arm64 boot
> requirements, as stated by Linux in Documentation/arm64/booting.rst, do not
> specify a particular value for all the fields. Do not rely on the good will
> of the hypervisor and userspace to set SCTLR_EL1 to a sane value (by their
> definition of sane) and set SCTLR_EL1 explicitely before running setup().
> This will ensure that all tests are performed with the hardware set up
> identically, regardless of the KVM or VMM versions.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Can confirm that the RES1 bits match the ARM ARM, and that it's indeed
a good idea to start from a known good state:

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  lib/arm64/asm/sysreg.h | 7 +++++++
>  arm/cstart64.S         | 5 +++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index 9d6b4fc66936..18c4ed39557a 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -8,6 +8,8 @@
>  #ifndef _ASMARM64_SYSREG_H_
>  #define _ASMARM64_SYSREG_H_
>  
> +#include <linux/const.h>
> +
>  #define sys_reg(op0, op1, crn, crm, op2) \
>  	((((op0)&3)<<19)|((op1)<<16)|((crn)<<12)|((crm)<<8)|((op2)<<5))
>  
> @@ -87,4 +89,9 @@ asm(
>  #define SCTLR_EL1_A	(1 << 1)
>  #define SCTLR_EL1_M	(1 << 0)
>  
> +#define SCTLR_EL1_RES1	(_BITUL(7) | _BITUL(8) | _BITUL(11) | _BITUL(20) | \
> +			 _BITUL(22) | _BITUL(23) | _BITUL(28) | _BITUL(29))
> +#define INIT_SCTLR_EL1_MMU_OFF	\
> +			SCTLR_EL1_RES1
> +
>  #endif /* _ASMARM64_SYSREG_H_ */
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index f6c5d2ebccf3..42a838ff4c38 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -52,6 +52,11 @@ start:
>  	b	1b
>  
>  1:
> +	/* set SCTLR_EL1 to a known value */
> +	ldr	x4, =INIT_SCTLR_EL1_MMU_OFF
> +	msr	sctlr_el1, x4
> +	isb
> +
>  	/* set up stack */
>  	mov	x4, #1
>  	msr	spsel, x4

