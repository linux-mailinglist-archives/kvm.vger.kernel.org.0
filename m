Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044DE2034DD
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 12:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbgFVKbj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 06:31:39 -0400
Received: from foss.arm.com ([217.140.110.172]:39198 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbgFVKbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 06:31:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95BC61FB;
        Mon, 22 Jun 2020 03:31:38 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.15.132])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C1963F71E;
        Mon, 22 Jun 2020 03:31:36 -0700 (PDT)
Date:   Mon, 22 Jun 2020 11:31:33 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull <ascull@google.com>,
        Dave Martin <Dave.Martin@arm.com>, kernel-team@android.com
Subject: Re: [PATCH v2 5/5] KVM: arm64: Simplify PtrAuth alternative patching
Message-ID: <20200622103133.GD88608@C02TD0UTHF1T.local>
References: <20200622080643.171651-1-maz@kernel.org>
 <20200622080643.171651-6-maz@kernel.org>
 <20200622091508.GB88608@C02TD0UTHF1T.local>
 <422da5e4a8cfb9f9d7870d0a50985e55@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <422da5e4a8cfb9f9d7870d0a50985e55@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 22, 2020 at 11:25:41AM +0100, Marc Zyngier wrote:
> On 2020-06-22 10:15, Mark Rutland wrote:
> > On Mon, Jun 22, 2020 at 09:06:43AM +0100, Marc Zyngier wrote:
> I have folded in the following patch:
> 
> diff --git a/arch/arm64/include/asm/kvm_ptrauth.h
> b/arch/arm64/include/asm/kvm_ptrauth.h
> index 7a72508a841b..0ddf98c3ba9f 100644
> --- a/arch/arm64/include/asm/kvm_ptrauth.h
> +++ b/arch/arm64/include/asm/kvm_ptrauth.h
> @@ -68,29 +68,29 @@
>   */
>  .macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
>  alternative_if_not ARM64_HAS_ADDRESS_AUTH
> -	b	1000f
> +	b	.L__skip_switch\@
>  alternative_else_nop_endif
>  	mrs	\reg1, hcr_el2
>  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> -	cbz	\reg1, 1000f
> +	cbz	\reg1, .L__skip_switch\@
>  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
>  	ptrauth_restore_state	\reg1, \reg2, \reg3
> -1000:
> +.L__skip_switch\@:
>  .endm
> 
>  .macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
>  alternative_if_not ARM64_HAS_ADDRESS_AUTH
> -	b	2000f
> +	b	.L__skip_switch\@
>  alternative_else_nop_endif
>  	mrs	\reg1, hcr_el2
>  	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> -	cbz	\reg1, 2000f
> +	cbz	\reg1, .L__skip_switch\@
>  	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
>  	ptrauth_save_state	\reg1, \reg2, \reg3
>  	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
>  	ptrauth_restore_state	\reg1, \reg2, \reg3
>  	isb
> -2000:
> +.L__skip_switch\@:
>  .endm

Looks good to me; thanks!

Mark.
