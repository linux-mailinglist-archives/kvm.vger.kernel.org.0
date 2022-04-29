Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5470051475F
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 12:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358242AbiD2KuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 06:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358085AbiD2KtS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 06:49:18 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 613ABCB009
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 03:44:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21BE01063;
        Fri, 29 Apr 2022 03:44:27 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 68F1B3F73B;
        Fri, 29 Apr 2022 03:44:25 -0700 (PDT)
Date:   Fri, 29 Apr 2022 11:44:27 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v2] KVM: arm64: Inject exception on out-of-IPA-range
 translation fault
Message-ID: <YmvBi/BF7rA43lqr@monolith.localdoman>
References: <20220427220434.3097449-1-maz@kernel.org>
 <YmpUXWRJc3Kq3wGE@monolith.localdoman>
 <87zgk5b5bh.wl-maz@kernel.org>
 <Ymq7qUU67DoXTmkP@monolith.localdoman>
 <87v8ut853n.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v8ut853n.wl-maz@kernel.org>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Apr 28, 2022 at 06:55:56PM +0100, Marc Zyngier wrote:
> On Thu, 28 Apr 2022 17:07:21 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi,
> > 
> > On Thu, Apr 28, 2022 at 04:22:58PM +0100, Marc Zyngier wrote:
> > > On Thu, 28 Apr 2022 09:46:21 +0100,
> > > Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > > > 
> > > > Hi,
> > > > 
> > > > On Wed, Apr 27, 2022 at 11:04:34PM +0100, Marc Zyngier wrote:
> > > > > When taking a translation fault for an IPA that is outside of
> > > > > the range defined by the hypervisor (between the HW PARange and
> > > > > the IPA range), we stupidly treat it as an IO and forward the access
> > > > > to userspace. Of course, userspace can't do much with it, and things
> > > > > end badly.
> > > > > 
> > > > > Arguably, the guest is braindead, but we should at least catch the
> > > > > case and inject an exception.
> > > > > 
> > > > > Check the faulting IPA against:
> > > > > - the sanitised PARange: inject an address size fault
> > > > > - the IPA size: inject an abort
> > > > > 
> > > > > Reported-by: Christoffer Dall <christoffer.dall@arm.com>
> > > > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > > > ---
> > > > >  arch/arm64/include/asm/kvm_emulate.h |  1 +
> > > > >  arch/arm64/kvm/inject_fault.c        | 28 ++++++++++++++++++++++++++++
> > > > >  arch/arm64/kvm/mmu.c                 | 19 +++++++++++++++++++
> > > > >  3 files changed, 48 insertions(+)
> > > > > 
> > > > > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > > > > index 7496deab025a..f71358271b71 100644
> > > > > --- a/arch/arm64/include/asm/kvm_emulate.h
> > > > > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > > > > @@ -40,6 +40,7 @@ void kvm_inject_undefined(struct kvm_vcpu *vcpu);
> > > > >  void kvm_inject_vabt(struct kvm_vcpu *vcpu);
> > > > >  void kvm_inject_dabt(struct kvm_vcpu *vcpu, unsigned long addr);
> > > > >  void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
> > > > > +void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
> > > > >  
> > > > >  void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
> > > > >  
> > > > > diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
> > > > > index b47df73e98d7..ba20405d2dc2 100644
> > > > > --- a/arch/arm64/kvm/inject_fault.c
> > > > > +++ b/arch/arm64/kvm/inject_fault.c
> > > > > @@ -145,6 +145,34 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr)
> > > > >  		inject_abt64(vcpu, true, addr);
> > > > >  }
> > > > >  
> > > > > +void kvm_inject_size_fault(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	unsigned long addr, esr;
> > > > > +
> > > > > +	addr  = kvm_vcpu_get_fault_ipa(vcpu);
> > > > > +	addr |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> > > > > +
> > > > > +	if (kvm_vcpu_trap_is_iabt(vcpu))
> > > > > +		kvm_inject_pabt(vcpu, addr);
> > > > > +	else
> > > > > +		kvm_inject_dabt(vcpu, addr);
> > > > > +
> > > > > +	/*
> > > > > +	 * If AArch64 or LPAE, set FSC to 0 to indicate an Address
> > > > > +	 * Size Fault at level 0, as if exceeding PARange.
> > > > > +	 *
> > > > > +	 * Non-LPAE guests will only get the external abort, as there
> > > > > +	 * is no way to to describe the ASF.
> > > > > +	 */
> > > > > +	if (vcpu_el1_is_32bit(vcpu) &&
> > > > > +	    !(vcpu_read_sys_reg(vcpu, TCR_EL1) & TTBCR_EAE))
> > > > > +		return;
> > > > > +
> > > > > +	esr = vcpu_read_sys_reg(vcpu, ESR_EL1);
> > > > > +	esr &= ~GENMASK_ULL(5, 0);
> > > > > +	vcpu_write_sys_reg(vcpu, esr, ESR_EL1);
> > > > > +}
> > > > > +
> > > > >  /**
> > > > >   * kvm_inject_undefined - inject an undefined instruction into the guest
> > > > >   * @vcpu: The vCPU in which to inject the exception
> > > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > > index 53ae2c0640bc..5400fc020164 100644
> > > > > --- a/arch/arm64/kvm/mmu.c
> > > > > +++ b/arch/arm64/kvm/mmu.c
> > > > > @@ -1337,6 +1337,25 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
> > > > >  	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
> > > > >  	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
> > > > >  
> > > > > +	if (fault_status == FSC_FAULT) {
> > > > > +		/* Beyond sanitised PARange (which is the IPA limit) */
> > > > > +		if (fault_ipa >= BIT_ULL(get_kvm_ipa_limit())) {
> > > > > +			kvm_inject_size_fault(vcpu);
> > > > > +			return 1;
> > > > > +		}
> > > > > +
> > > > > +		/* Falls between the IPA range and the PARange? */
> > > > > +		if (fault_ipa >= BIT_ULL(vcpu->arch.hw_mmu->pgt->ia_bits)) {
> > > > > +			fault_ipa |= kvm_vcpu_get_hfar(vcpu) & GENMASK(11, 0);
> > > > > +
> > > > > +			if (is_iabt)
> > > > > +				kvm_inject_pabt(vcpu, fault_ipa);
> > > > > +			else
> > > > > +				kvm_inject_dabt(vcpu, fault_ipa);
> > > > > +			return 1;
> > > > > +		}
> > > > 
> > > > Doesn't KVM treat faults outside a valid memslot (aka guest RAM) as MMIO
> > > > aborts? From the guest's point of view, the IPA is valid because it's
> > > > inside the HW PARange, so it's not entirely impossible that the VMM put a
> > > > device there.
> > > 
> > > Sure. But the generated IPA is outside of the range the VMM has asked
> > > to handle. The IPA space describes the whole of the guest address
> > > space, and there shouldn't be anything outside of it.
> > > 
> > > We actually state in the documentation that the IPA Size limit *is*
> > > the physical address size for the VM. If the VMM places something
> > > outside if the IPA space and still expect something to be reported to
> > > it, we have a problem (in some cases, we may want to actually put page
> > > tables in place even for MMIO that traps to userspace -- see my
> > > earlier work on MMIO guard).
> > 
> > If you mean this bit:
> > 
> > On arm64, the physical address size for a VM (IPA Size limit) is limited
> > to 40bits by default. The limit can be configured if the host supports the
> > extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
> > KVM_VM_TYPE_ARM_IPA_SIZE(IPA_Bits) to set the size in the machine type
> > identifier, where IPA_Bits is the maximum width of any physical
> > address used by the VM.
> >
> > And then below there is this paragraph:
> > 
> > Please note that configuring the IPA size does not affect the capability
> > exposed by the guest CPUs in ID_AA64MMFR0_EL1[PARange]. It only affects
> > **size of the address translated by the stage2 level (guest physical to
> > host physical address translations)**.
> 
> I don't see that as a contradiction. It just says that we don't
> repaint PARange.
> 
> > 
> > Emphasis added by me.
> > 
> > It looks to me like the two paragraph state different things, first says
> > the IPA size caps "the physical address size for a VM", the second that it
> > caps the RAM size - "size of the address translated by the stage 2 level.
> 
> That's not the way I understand it. It just gives a textbook
> definition of the IPA space. And to be clear, this is just an
> implementation detail. We should be able to populate all full IPA
> space with faulting entries and keep the behaviour the same.
> 
> > I have no problem with either, but it looks confusing.
> > 
> > So if a VMM that wants to put devices above RAM it must make sure that the
> > IPA size is extended to match, did I get that right?
> 
> Yes. Anything that is reacheable by a memory transaction has to fit in
> the IPA space.
> 
> > I'm also a bit confused about the rationale. Why is the PARange exposed to
> > the guest in effect the wrong value, because the true PARange is defined by
> > IPA size?
> 
> PARange and IPA range don't have the same granularity. You can't
> express a PARange of 37 bits, for example, while it is perfectly
> possible for the IPA range. And they do cover two different concepts:
> the IPA space means nothing to the guest.

I see, thank you for the detailed explanation!

Thanks,
Alex
