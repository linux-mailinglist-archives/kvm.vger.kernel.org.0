Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8369B20330D
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 11:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgFVJPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 05:15:14 -0400
Received: from foss.arm.com ([217.140.110.172]:60358 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbgFVJPO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 05:15:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A5D51FB;
        Mon, 22 Jun 2020 02:15:13 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.15.132])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C7A63F6CF;
        Mon, 22 Jun 2020 02:15:11 -0700 (PDT)
Date:   Mon, 22 Jun 2020 10:15:08 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Dave Martin <Dave.Martin@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
Message-ID: <20200622091508.GB88608@C02TD0UTHF1T.local>
References: <20200622080643.171651-1-maz@kernel.org>
 <20200622080643.171651-6-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200622080643.171651-6-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 09:06:43AM +0100, Marc Zyngier wrote:
> We currently decide to execute the PtrAuth save/restore code based
> on a set of branches that evaluate as (ARM64_HAS_ADDRESS_AUTH_ARCH ||
> ARM64_HAS_ADDRESS_AUTH_IMP_DEF). This can be easily replaced by
> a much simpler test as the ARM64_HAS_ADDRESS_AUTH capability is
> exactly this expression.
> 
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Looks good to me. One minor suggestion below, but either way:

Acked-by: Mark Rutland <mark.rutland@arm.com>

> ---
>  arch/arm64/include/asm/kvm_ptrauth.h | 26 +++++++++-----------------
>  1 file changed, 9 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
> index f1830173fa9e..7a72508a841b 100644
> --- a/arch/arm64/include/asm/kvm_ptrauth.h
> +++ b/arch/arm64/include/asm/kvm_ptrauth.h
> @@ -61,44 +61,36 @@
>  
>  /*
>   * Both ptrauth_switch_to_guest and ptrauth_switch_to_host macros will
> - * check for the presence of one of the cpufeature flag
> - * ARM64_HAS_ADDRESS_AUTH_ARCH or ARM64_HAS_ADDRESS_AUTH_IMP_DEF and
> + * check for the presence ARM64_HAS_ADDRESS_AUTH, which is defined as
> + * (ARM64_HAS_ADDRESS_AUTH_ARCH || ARM64_HAS_ADDRESS_AUTH_IMP_DEF) and
>   * then proceed ahead with the save/restore of Pointer Authentication
> - * key registers.
> + * key registers if enabled for the guest.
>   */
>  .macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
> -alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
> +alternative_if_not ARM64_HAS_ADDRESS_AUTH
>  	b	1000f
>  alternative_else_nop_endif
> -alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
> -	b	1001f
> -alternative_else_nop_endif
> -1000:
>  	mrs	\reg1, hcr_el2
>  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> -	cbz	\reg1, 1001f
> +	cbz	\reg1, 1000f
>  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
>  	ptrauth_restore_state	\reg1, \reg2, \reg3
> -1001:
> +1000:
>  .endm

Since these are in macros, we could use \@ to generate a macro-specific
lavel rather than a magic number, which would be less likely to conflict
with the surrounding environment and would be more descriptive. We do
that in a few places already, and here it could look something like:

| alternative_if_not ARM64_HAS_ADDRESS_AUTH
| 	b	.L__skip_pauth_switch\@
| alternative_else_nop_endif
| 	
| 	...
| 
| .L__skip_pauth_switch\@:

Per the gas documentation

| \@
|
|    as maintains a counter of how many macros it has executed in this
|    pseudo-variable; you can copy that number to your output with ‘\@’,
|    but only within a macro definition.

No worries if you don't want to change that now; the Acked-by stands
either way.

Mark.

>  
>  .macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
> -alternative_if ARM64_HAS_ADDRESS_AUTH_ARCH
> +alternative_if_not ARM64_HAS_ADDRESS_AUTH
>  	b	2000f
>  alternative_else_nop_endif
> -alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
> -	b	2001f
> -alternative_else_nop_endif
> -2000:
>  	mrs	\reg1, hcr_el2
>  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> -	cbz	\reg1, 2001f
> +	cbz	\reg1, 2000f
>  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
>  	ptrauth_save_state	\reg1, \reg2, \reg3
>  	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
>  	ptrauth_restore_state	\reg1, \reg2, \reg3
>  	isb
> -2001:
> +2000:
>  .endm
>  
>  #else /* !CONFIG_ARM64_PTR_AUTH */
> -- 
> 2.27.0
> 
