Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5B31F948D
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 12:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgFOKZx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 06:25:53 -0400
Received: from foss.arm.com ([217.140.110.172]:44512 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbgFOKZk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 06:25:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 092D81F1;
        Mon, 15 Jun 2020 03:25:33 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.7.221])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15F323F71F;
        Mon, 15 Jun 2020 03:25:31 -0700 (PDT)
Date:   Mon, 15 Jun 2020 11:25:29 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
Subject: Re: [PATCH 4/4] KVM: arm64: Check HCR_EL2 instead of shadow copy to
 swap PtrAuth registers
Message-ID: <20200615102529.GD773@C02TD0UTHF1T.local>
References: <20200615081954.6233-1-maz@kernel.org>
 <20200615081954.6233-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-5-maz@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 09:19:54AM +0100, Marc Zyngier wrote:
> When save/restoring PtrAuth registers between host and guest, it is
> pretty useless to fetch the in-memory state, while we have the right
> state in the HCR_EL2 system register. Use that instead.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

It took me a while to spot that we switched the guest/host hcr_el2 value
in the __activate_traps() and __deactivate_traps() paths, but given that
this is only called in the __kvm_vcpu_run_*() paths called between
those, I agree this is sound. Given that:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/include/asm/kvm_ptrauth.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_ptrauth.h b/arch/arm64/include/asm/kvm_ptrauth.h
> index 6301813dcace..f1830173fa9e 100644
> --- a/arch/arm64/include/asm/kvm_ptrauth.h
> +++ b/arch/arm64/include/asm/kvm_ptrauth.h
> @@ -74,7 +74,7 @@ alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
>  	b	1001f
>  alternative_else_nop_endif
>  1000:
> -	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
> +	mrs	\reg1, hcr_el2
>  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
>  	cbz	\reg1, 1001f
>  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
> @@ -90,7 +90,7 @@ alternative_if_not ARM64_HAS_ADDRESS_AUTH_IMP_DEF
>  	b	2001f
>  alternative_else_nop_endif
>  2000:
> -	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
> +	mrs	\reg1, hcr_el2
>  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
>  	cbz	\reg1, 2001f
>  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
> -- 
> 2.27.0
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
