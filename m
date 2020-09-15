Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7013926B0CE
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 00:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgIOWTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 18:19:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:63987 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727699AbgIOQ3p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 12:29:45 -0400
IronPort-SDR: 8mF6ouKV9hUzyp1Iq1vmJaJsDYQj7WAdYm+BzRur/4557EAx8CKAHa7apmX+spCOnZeqSAKbBw
 1Ryw9GJtIfRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="160233022"
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="160233022"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 09:28:39 -0700
IronPort-SDR: jhEI87l6+toBT3WeaitOl5cWTBPVuhw+9DaJ9DgksUoPIT6mJKLJLifxToZk5mICDJackTEutA
 TwoGKt2H8hxA==
X-IronPort-AV: E=Sophos;i="5.76,430,1592895600"; 
   d="scan'208";a="482889995"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 09:28:38 -0700
Date:   Tue, 15 Sep 2020 09:28:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC PATCH 05/35] KVM: SVM: Add initial support for SEV-ES GHCB
 access to KVM
Message-ID: <20200915162836.GA8420@sjchrist-ice>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <9e52807342691ff0d4b116af6e147021c61a2d71.1600114548.git.thomas.lendacky@amd.com>
 <20200914205801.GA7084@sjchrist-ice>
 <ba417215-530d-98df-5ceb-35b10ee09243@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba417215-530d-98df-5ceb-35b10ee09243@amd.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15, 2020 at 08:24:22AM -0500, Tom Lendacky wrote:
> On 9/14/20 3:58 PM, Sean Christopherson wrote:
> >> @@ -79,6 +88,9 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu, int reg,
> >>  	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
> >>  		return;
> >>  
> >> +	if (kvm_x86_ops.reg_write_override)
> >> +		kvm_x86_ops.reg_write_override(vcpu, reg, val);
> > 
> > 
> > There has to be a more optimal approach for propagating registers between
> > vcpu->arch.regs and the VMSA than adding a per-GPR hook.  Why not simply
> > copy the entire set of registers to/from the VMSA on every exit and entry?
> > AFAICT, valid_bits is only used in the read path, and KVM doesn't do anything
> > sophistated when it hits a !valid_bits reads.
> 
> That would probably be ok. And actually, the code might be able to just
> check the GHCB valid bitmap for valid regs on exit, copy them and then
> clear the bitmap. The write code could check if vmsa_encrypted is set and
> then set a "valid" bit for the reg that could be used to set regs on entry.
> 
> I'm not sure if turning kvm_vcpu_arch.regs into a struct and adding a
> valid bit would be overkill or not.

KVM already has space in regs_avail and regs_dirty for GPRs, they're just not
used by the get/set helpers because they're always loaded/stored for both SVM
and VMX.

I assume nothing will break if KVM "writes" random GPRs in the VMSA?  I can't
see how the guest would achieve any level of security if it wantonly consumes
GPRs, i.e. it's the guest's responsibility to consume only the relevant GPRs.

If that holds true, than avoiding the copying isn't functionally necessary, and
is really just a performance optimization.  One potentially crazy idea would be
to change vcpu->arch.regs to be a pointer (defaults a __regs array), and then
have SEV-ES switch it to point directly at the VMSA array (I think the layout
is identical for x86-64?).

> >> @@ -4012,6 +4052,99 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
> >>  		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
> >>  }
> >>  
> >> +/*
> >> + * These return values represent the offset in quad words within the VM save
> >> + * area. This allows them to be accessed by casting the save area to a u64
> >> + * array.
> >> + */
> >> +#define VMSA_REG_ENTRY(_field)	 (offsetof(struct vmcb_save_area, _field) / sizeof(u64))
> >> +#define VMSA_REG_UNDEF		 VMSA_REG_ENTRY(valid_bitmap)
> >> +static inline unsigned int vcpu_to_vmsa_entry(enum kvm_reg reg)
> >> +{
> >> +	switch (reg) {
> >> +	case VCPU_REGS_RAX:	return VMSA_REG_ENTRY(rax);
> >> +	case VCPU_REGS_RBX:	return VMSA_REG_ENTRY(rbx);
> >> +	case VCPU_REGS_RCX:	return VMSA_REG_ENTRY(rcx);
> >> +	case VCPU_REGS_RDX:	return VMSA_REG_ENTRY(rdx);
> >> +	case VCPU_REGS_RSP:	return VMSA_REG_ENTRY(rsp);
> >> +	case VCPU_REGS_RBP:	return VMSA_REG_ENTRY(rbp);
> >> +	case VCPU_REGS_RSI:	return VMSA_REG_ENTRY(rsi);
> >> +	case VCPU_REGS_RDI:	return VMSA_REG_ENTRY(rdi);
> >> +#ifdef CONFIG_X86_64

Is KVM SEV-ES going to support 32-bit builds?

> >> +	case VCPU_REGS_R8:	return VMSA_REG_ENTRY(r8);
> >> +	case VCPU_REGS_R9:	return VMSA_REG_ENTRY(r9);
> >> +	case VCPU_REGS_R10:	return VMSA_REG_ENTRY(r10);
> >> +	case VCPU_REGS_R11:	return VMSA_REG_ENTRY(r11);
> >> +	case VCPU_REGS_R12:	return VMSA_REG_ENTRY(r12);
> >> +	case VCPU_REGS_R13:	return VMSA_REG_ENTRY(r13);
> >> +	case VCPU_REGS_R14:	return VMSA_REG_ENTRY(r14);
> >> +	case VCPU_REGS_R15:	return VMSA_REG_ENTRY(r15);
> >> +#endif
> >> +	case VCPU_REGS_RIP:	return VMSA_REG_ENTRY(rip);
> >> +	default:
> >> +		WARN_ONCE(1, "unsupported VCPU to VMSA register conversion\n");
> >> +		return VMSA_REG_UNDEF;
> >> +	}
> >> +}
> >> +
> >> +/* For SEV-ES guests, populate the vCPU register from the appropriate VMSA/GHCB */
> >> +static void svm_reg_read_override(struct kvm_vcpu *vcpu, enum kvm_reg reg)
> >> +{
> >> +	struct vmcb_save_area *vmsa;
> >> +	struct vcpu_svm *svm;
> >> +	unsigned int entry;
> >> +	unsigned long val;
> >> +	u64 *vmsa_reg;
> >> +
> >> +	if (!sev_es_guest(vcpu->kvm))
> >> +		return;
> >> +
> >> +	entry = vcpu_to_vmsa_entry(reg);
> >> +	if (entry == VMSA_REG_UNDEF)
> >> +		return;
> >> +
> >> +	svm = to_svm(vcpu);
> >> +	vmsa = get_vmsa(svm);
> >> +	vmsa_reg = (u64 *)vmsa;
> >> +	val = (unsigned long)vmsa_reg[entry];
> >> +
> >> +	/* If a GHCB is mapped, check the bitmap of valid entries */
> >> +	if (svm->ghcb) {
> >> +		if (!test_bit(entry, (unsigned long *)vmsa->valid_bitmap))
> >> +			val = 0;
> > 
> > Is KVM relying on this being 0?  Would it make sense to stuff something like
> > 0xaaaa... or 0xdeadbeefdeadbeef so that consumption of bogus data is more
> > noticeable?
> 
> No, KVM isn't relying on this being 0. I thought about using something
> other than 0 here, but settled on just using 0. I'm open to changing that,
> though. I'm not sure if there's an easy way to short-circuit the intercept
> and respond back with an error at this point, that would be optimal.

Ya, responding with an error would be ideal.  At this point, we're taking the
same lazy approach for TDX and effectively consuming garbage if the guest
requests emulation but doesn't expose the necessary GPRs.  That being said,
TDX's guest/host ABI is quite rigid, so all the "is this register valid"
checks could be hardcoded into the higher level "emulation" flows.

Would that also be an option for SEV-ES?
