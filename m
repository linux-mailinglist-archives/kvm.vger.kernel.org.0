Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C684C54C97D
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 15:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348358AbiFONOF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 09:14:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240965AbiFONOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 09:14:03 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7FD62A260
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 06:14:02 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86FF5139F;
        Wed, 15 Jun 2022 06:14:02 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 52E343F66F;
        Wed, 15 Jun 2022 06:14:00 -0700 (PDT)
Date:   Wed, 15 Jun 2022 14:14:19 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Mark Brown <broonie@kernel.org>,
        Reiji Watanabe <reijiw@google.com>, kernel-team@android.com
Subject: Re: [PATCH v2 11/19] KVM: arm64: Move vcpu ON_UNSUPPORTED_CPU flag
 to the state flag set
Message-ID: <YqnbEJ0hgSKyXtxO@monolith.localdoman>
References: <20220610092838.1205755-1-maz@kernel.org>
 <20220610092838.1205755-12-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610092838.1205755-12-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Jun 10, 2022 at 10:28:30AM +0100, Marc Zyngier wrote:
> The ON_UNSUPPORTED_CPU flag is only there to track the sad fact
> that we have ended-up on a CPU where we cannot really run.
> 
> Since this is only for the host kernel's use, move it to the state
> set.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4f147bdc5ce9..0c22514cb7c7 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -519,6 +519,8 @@ struct kvm_vcpu_arch {
>  #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
>  /* SME enabled for EL0 */
>  #define HOST_SME_ENABLED	__vcpu_single_flag(sflags, BIT(1))
> +/* Physical CPU not in supported_cpus */
> +#define ON_UNSUPPORTED_CPU	__vcpu_single_flag(sflags, BIT(2))

I'm a bit confused here. The ON_UNSUPPORTED_CPU flag ends up in sflags. The
comment for sflags says:

+	/* State flags for kernel bookkeeping, unused by the hypervisor code */
+	u64 sflags;

The ON_UNSUPPORT_CPU flag is used exclusively by KVM (it's only used by the
file arch/arm64/kvm/arm.c), so why is it part of a set of flags which are
supposed to be unused by the hypervisor code?

Thanks,
Alex

>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
>  #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
> @@ -541,7 +543,6 @@ struct kvm_vcpu_arch {
>  })
>  
>  /* vcpu_arch flags field values: */
> -#define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
>  #define KVM_ARM64_WFIT			(1 << 17) /* WFIT instruction trapped */
>  #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
>  				 KVM_GUESTDBG_USE_SW_BP | \
> @@ -561,13 +562,13 @@ struct kvm_vcpu_arch {
>  #endif
>  
>  #define vcpu_on_unsupported_cpu(vcpu)					\
> -	((vcpu)->arch.flags & KVM_ARM64_ON_UNSUPPORTED_CPU)
> +	vcpu_get_flag(vcpu, ON_UNSUPPORTED_CPU)
>  
>  #define vcpu_set_on_unsupported_cpu(vcpu)				\
> -	((vcpu)->arch.flags |= KVM_ARM64_ON_UNSUPPORTED_CPU)
> +	vcpu_set_flag(vcpu, ON_UNSUPPORTED_CPU)
>  
>  #define vcpu_clear_on_unsupported_cpu(vcpu)				\
> -	((vcpu)->arch.flags &= ~KVM_ARM64_ON_UNSUPPORTED_CPU)
> +	vcpu_clear_flag(vcpu, ON_UNSUPPORTED_CPU)
>  
>  #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.regs)
>  
> -- 
> 2.34.1
> 
