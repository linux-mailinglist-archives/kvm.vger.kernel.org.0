Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E25F1E1AE3
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 07:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgEZF7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 01:59:33 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:60013 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgEZF7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 01:59:32 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49WNZn04xgz9sSs; Tue, 26 May 2020 15:59:28 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1590472769; bh=4zTMjLxiP7At/YtrE7MFZ9lR12F6gL3vS4op93NKqcw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=khGxIciPhO0Sfk2SnU/0Ae673wU3qJd++HDVCdDXw0crK8Ypm2/n9l62eVF831yOi
         qSlxMK1kVwrGk5Ie4AuHOGiyMVvCJOwjYXSbzPDmsHvR8Rc6dTcCW4fUqTmnv2FFC3
         IC6DoGsAZ7Lz1lXXrlNfXZL/2bFCAo2dtE/thks2LK2v0to3aW5buJZfJX1GsIWfGN
         AgMpuG9PWO3XTyuFrjqeVqtJHgB3BOMn3n4bxBUe7RXQfa23LEupF1Ywt0g5DVnF/1
         IVVxPvpB947tg6+DMLQ0rMbIi1mYImwuRTcOzmoU9yY9DUZ2d3cWMG3nlOTWEdkC0S
         nbtLhygWbPVew==
Date:   Tue, 26 May 2020 15:59:24 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     pbonzini@redhat.com, tsbogend@alpha.franken.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
        chenhuacai@gmail.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/7] KVM: PPC: clean up redundant kvm_run parameters
 in assembly
Message-ID: <20200526055924.GD282305@thinks.paulus.ozlabs.org>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-6-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427043514.16144-6-tianjia.zhang@linux.alibaba.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 12:35:12PM +0800, Tianjia Zhang wrote:
> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
> structure. For historical reasons, many kvm-related function parameters
> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
> patch does a unified cleanup of these remaining redundant parameters.

Some of these changes don't look completely correct to me, see below.
If you're expecting these patches to go through my tree, I can fix up
the patch and commit it (with you as author), noting the changes I
made in the commit message.  Do you want me to do that?

> diff --git a/arch/powerpc/kvm/book3s_interrupts.S b/arch/powerpc/kvm/book3s_interrupts.S
> index f7ad99d972ce..0eff749d8027 100644
> --- a/arch/powerpc/kvm/book3s_interrupts.S
> +++ b/arch/powerpc/kvm/book3s_interrupts.S
> @@ -55,8 +55,7 @@
>   ****************************************************************************/
>  
>  /* Registers:
> - *  r3: kvm_run pointer
> - *  r4: vcpu pointer
> + *  r3: vcpu pointer
>   */
>  _GLOBAL(__kvmppc_vcpu_run)
>  
> @@ -68,8 +67,8 @@ kvm_start_entry:
>  	/* Save host state to the stack */
>  	PPC_STLU r1, -SWITCH_FRAME_SIZE(r1)
>  
> -	/* Save r3 (kvm_run) and r4 (vcpu) */
> -	SAVE_2GPRS(3, r1)
> +	/* Save r3 (vcpu) */
> +	SAVE_GPR(3, r1)
>  
>  	/* Save non-volatile registers (r14 - r31) */
>  	SAVE_NVGPRS(r1)
> @@ -82,11 +81,11 @@ kvm_start_entry:
>  	PPC_STL	r0, _LINK(r1)
>  
>  	/* Load non-volatile guest state from the vcpu */
> -	VCPU_LOAD_NVGPRS(r4)
> +	VCPU_LOAD_NVGPRS(r3)
>  
>  kvm_start_lightweight:
>  	/* Copy registers into shadow vcpu so we can access them in real mode */
> -	mr	r3, r4
> +	mr	r4, r3

This mr doesn't seem necessary.

>  	bl	FUNC(kvmppc_copy_to_svcpu)
>  	nop
>  	REST_GPR(4, r1)

This should be loading r4 from GPR3(r1), not GPR4(r1) - which is what
REST_GPR(4, r1) will do.

Then, in the file but not in the patch context, there is this line:

	PPC_LL	r3, GPR4(r1)		/* vcpu pointer */

where once again GPR4 needs to be GPR3.

> @@ -191,10 +190,10 @@ after_sprg3_load:
>  	PPC_STL	r31, VCPU_GPR(R31)(r7)
>  
>  	/* Pass the exit number as 3rd argument to kvmppc_handle_exit */

The comment should be modified to say "2nd" instead of "3rd",
otherwise it is confusing.

The rest of the patch looks OK.

Paul.
