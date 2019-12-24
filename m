Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D52712A13F
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 13:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfLXMPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 07:15:46 -0500
Received: from foss.arm.com ([217.140.110.172]:51694 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfLXMPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 07:15:45 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22D471FB;
        Tue, 24 Dec 2019 04:15:45 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DB2D3F534;
        Tue, 24 Dec 2019 04:15:44 -0800 (PST)
Date:   Tue, 24 Dec 2019 12:15:42 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 09/18] arm64: KVM: enable conditional save/restore
 full SPE profiling buffer controls
Message-ID: <20191224121542.GI42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-10-andrew.murray@arm.com>
 <20191220180657.GD25258@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220180657.GD25258@lakrids.cambridge.arm.com>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 20, 2019 at 06:06:58PM +0000, Mark Rutland wrote:
> On Fri, Dec 20, 2019 at 02:30:16PM +0000, Andrew Murray wrote:
> > From: Sudeep Holla <sudeep.holla@arm.com>
> > 
> > Now that we can save/restore the full SPE controls, we can enable it
> > if SPE is setup and ready to use in KVM. It's supported in KVM only if
> > all the CPUs in the system supports SPE.
> > 
> > However to support heterogenous systems, we need to move the check if
> > host supports SPE and do a partial save/restore.
> 
> I don't think that it makes sense to support this for heterogeneous
> systems, given their SPE capabilities and IMP DEF details will differ.
> 
> Is there some way we can limit this to homogeneous systems?

No problem, I'll see how to limit this.

Thanks,

Andrew Murray

> 
> Thanks,
> Mark.
> 
> > 
> > Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  arch/arm64/kvm/hyp/debug-sr.c | 33 ++++++++++++++++-----------------
> >  include/kvm/arm_spe.h         |  6 ++++++
> >  2 files changed, 22 insertions(+), 17 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> > index 12429b212a3a..d8d857067e6d 100644
> > --- a/arch/arm64/kvm/hyp/debug-sr.c
> > +++ b/arch/arm64/kvm/hyp/debug-sr.c
> > @@ -86,18 +86,13 @@
> >  	}
> >  
> >  static void __hyp_text
> > -__debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> > +__debug_save_spe_context(struct kvm_cpu_context *ctxt, bool full_ctxt)
> >  {
> >  	u64 reg;
> >  
> >  	/* Clear pmscr in case of early return */
> >  	ctxt->sys_regs[PMSCR_EL1] = 0;
> >  
> > -	/* SPE present on this CPU? */
> > -	if (!cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
> > -						  ID_AA64DFR0_PMSVER_SHIFT))
> > -		return;
> > -
> >  	/* Yes; is it owned by higher EL? */
> >  	reg = read_sysreg_s(SYS_PMBIDR_EL1);
> >  	if (reg & BIT(SYS_PMBIDR_EL1_P_SHIFT))
> > @@ -142,7 +137,7 @@ __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> >  }
> >  
> >  static void __hyp_text
> > -__debug_restore_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)
> > +__debug_restore_spe_context(struct kvm_cpu_context *ctxt, bool full_ctxt)
> >  {
> >  	if (!ctxt->sys_regs[PMSCR_EL1])
> >  		return;
> > @@ -210,11 +205,14 @@ void __hyp_text __debug_restore_guest_context(struct kvm_vcpu *vcpu)
> >  	struct kvm_guest_debug_arch *host_dbg;
> >  	struct kvm_guest_debug_arch *guest_dbg;
> >  
> > +	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > +	guest_ctxt = &vcpu->arch.ctxt;
> > +
> > +	__debug_restore_spe_context(guest_ctxt, kvm_arm_spe_v1_ready(vcpu));
> > +
> >  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
> >  		return;
> >  
> > -	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > -	guest_ctxt = &vcpu->arch.ctxt;
> >  	host_dbg = &vcpu->arch.host_debug_state.regs;
> >  	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
> >  
> > @@ -232,8 +230,7 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
> >  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> >  	guest_ctxt = &vcpu->arch.ctxt;
> >  
> > -	if (!has_vhe())
> > -		__debug_restore_spe_nvhe(host_ctxt, false);
> > +	__debug_restore_spe_context(host_ctxt, kvm_arm_spe_v1_ready(vcpu));
> >  
> >  	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
> >  		return;
> > @@ -249,19 +246,21 @@ void __hyp_text __debug_restore_host_context(struct kvm_vcpu *vcpu)
> >  
> >  void __hyp_text __debug_save_host_context(struct kvm_vcpu *vcpu)
> >  {
> > -	/*
> > -	 * Non-VHE: Disable and flush SPE data generation
> > -	 * VHE: The vcpu can run, but it can't hide.
> > -	 */
> >  	struct kvm_cpu_context *host_ctxt;
> >  
> >  	host_ctxt = kern_hyp_va(vcpu->arch.host_cpu_context);
> > -	if (!has_vhe())
> > -		__debug_save_spe_nvhe(host_ctxt, false);
> > +	if (cpuid_feature_extract_unsigned_field(read_sysreg(id_aa64dfr0_el1),
> > +						 ID_AA64DFR0_PMSVER_SHIFT))
> > +		__debug_save_spe_context(host_ctxt, kvm_arm_spe_v1_ready(vcpu));
> >  }
> >  
> >  void __hyp_text __debug_save_guest_context(struct kvm_vcpu *vcpu)
> >  {
> > +	bool kvm_spe_ready = kvm_arm_spe_v1_ready(vcpu);
> > +
> > +	/* SPE present on this vCPU? */
> > +	if (kvm_spe_ready)
> > +		__debug_save_spe_context(&vcpu->arch.ctxt, kvm_spe_ready);
> >  }
> >  
> >  u32 __hyp_text __kvm_get_mdcr_el2(void)
> > diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> > index 48d118fdb174..30c40b1bc385 100644
> > --- a/include/kvm/arm_spe.h
> > +++ b/include/kvm/arm_spe.h
> > @@ -16,4 +16,10 @@ struct kvm_spe {
> >  	bool irq_level;
> >  };
> >  
> > +#ifdef CONFIG_KVM_ARM_SPE
> > +#define kvm_arm_spe_v1_ready(v)		((v)->arch.spe.ready)
> > +#else
> > +#define kvm_arm_spe_v1_ready(v)		(false)
> > +#endif /* CONFIG_KVM_ARM_SPE */
> > +
> >  #endif /* __ASM_ARM_KVM_SPE_H */
> > -- 
> > 2.21.0
> > 
