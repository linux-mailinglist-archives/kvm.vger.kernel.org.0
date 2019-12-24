Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F0912A1CA
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 14:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfLXNgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 08:36:51 -0500
Received: from foss.arm.com ([217.140.110.172]:52188 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbfLXNgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 08:36:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 097AA1FB;
        Tue, 24 Dec 2019 05:36:50 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 700043F534;
        Tue, 24 Dec 2019 05:36:49 -0800 (PST)
Date:   Tue, 24 Dec 2019 13:36:47 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 14/18] KVM: arm64: spe: Provide guest virtual
 interrupts for SPE
Message-ID: <20191224133647.GO42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-15-andrew.murray@arm.com>
 <867e2oimw9.wl-maz@kernel.org>
 <20191224115031.GG42593@e119886-lin.cambridge.arm.com>
 <1f3fbff6c9db0f14c92a6e3fb800fa0f@www.loen.fr>
 <20191224130853.GN42593@e119886-lin.cambridge.arm.com>
 <a2b8846377b3f5884feeb9728b16f826@www.loen.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2b8846377b3f5884feeb9728b16f826@www.loen.fr>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 24, 2019 at 01:22:46PM +0000, Marc Zyngier wrote:
> On 2019-12-24 13:08, Andrew Murray wrote:
> > On Tue, Dec 24, 2019 at 12:42:02PM +0000, Marc Zyngier wrote:
> > > On 2019-12-24 11:50, Andrew Murray wrote:
> > > > On Sun, Dec 22, 2019 at 12:07:50PM +0000, Marc Zyngier wrote:
> > > > > On Fri, 20 Dec 2019 14:30:21 +0000,
> > > > > Andrew Murray <andrew.murray@arm.com> wrote:
> > > > > >
> > > > > > Upon the exit of a guest, let's determine if the SPE device
> > > has
> > > > > generated
> > > > > > an interrupt - if so we'll inject a virtual interrupt to the
> > > > > guest.
> > > > > >
> > > > > > Upon the entry and exit of a guest we'll also update the state
> > > of
> > > > > the
> > > > > > physical IRQ such that it is active when a guest interrupt is
> > > > > pending
> > > > > > and the guest is running.
> > > > > >
> > > > > > Finally we map the physical IRQ to the virtual IRQ such that
> > > the
> > > > > guest
> > > > > > can deactivate the interrupt when it handles the interrupt.
> > > > > >
> > > > > > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > > > > > ---
> > > > > >  include/kvm/arm_spe.h |  6 ++++
> > > > > >  virt/kvm/arm/arm.c    |  5 ++-
> > > > > >  virt/kvm/arm/spe.c    | 71
> > > > > +++++++++++++++++++++++++++++++++++++++++++
> > > > > >  3 files changed, 81 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> > > > > > index 9c65130d726d..91b2214f543a 100644
> > > > > > --- a/include/kvm/arm_spe.h
> > > > > > +++ b/include/kvm/arm_spe.h
> > > > > > @@ -37,6 +37,9 @@ static inline bool
> > > kvm_arm_support_spe_v1(void)
> > > > > >  						      ID_AA64DFR0_PMSVER_SHIFT);
> > > > > >  }
> > > > > >
> > > > > > +void kvm_spe_flush_hwstate(struct kvm_vcpu *vcpu);
> > > > > > +inline void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu);
> > > > > > +
> > > > > >  int kvm_arm_spe_v1_set_attr(struct kvm_vcpu *vcpu,
> > > > > >  			    struct kvm_device_attr *attr);
> > > > > >  int kvm_arm_spe_v1_get_attr(struct kvm_vcpu *vcpu,
> > > > > > @@ -49,6 +52,9 @@ int kvm_arm_spe_v1_enable(struct kvm_vcpu
> > > > > *vcpu);
> > > > > >  #define kvm_arm_support_spe_v1()	(false)
> > > > > >  #define kvm_arm_spe_irq_initialized(v)	(false)
> > > > > >
> > > > > > +static inline void kvm_spe_flush_hwstate(struct kvm_vcpu
> > > *vcpu)
> > > > > {}
> > > > > > +static inline void kvm_spe_sync_hwstate(struct kvm_vcpu
> > > *vcpu) {}
> > > > > > +
> > > > > >  static inline int kvm_arm_spe_v1_set_attr(struct kvm_vcpu
> > > *vcpu,
> > > > > >  					  struct kvm_device_attr *attr)
> > > > > >  {
> > > > > > diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> > > > > > index 340d2388ee2c..a66085c8e785 100644
> > > > > > --- a/virt/kvm/arm/arm.c
> > > > > > +++ b/virt/kvm/arm/arm.c
> > > > > > @@ -741,6 +741,7 @@ int kvm_arch_vcpu_ioctl_run(struct
> > > kvm_vcpu
> > > > > *vcpu, struct kvm_run *run)
> > > > > >  		preempt_disable();
> > > > > >
> > > > > >  		kvm_pmu_flush_hwstate(vcpu);
> > > > > > +		kvm_spe_flush_hwstate(vcpu);
> > > > > >
> > > > > >  		local_irq_disable();
> > > > > >
> > > > > > @@ -782,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct
> > > kvm_vcpu
> > > > > *vcpu, struct kvm_run *run)
> > > > > >  		    kvm_request_pending(vcpu)) {
> > > > > >  			vcpu->mode = OUTSIDE_GUEST_MODE;
> > > > > >  			isb(); /* Ensure work in x_flush_hwstate is committed */
> > > > > > +			kvm_spe_sync_hwstate(vcpu);
> > > > > >  			kvm_pmu_sync_hwstate(vcpu);
> > > > > >  			if (static_branch_unlikely(&userspace_irqchip_in_use))
> > > > > >  				kvm_timer_sync_hwstate(vcpu);
> > > > > > @@ -816,11 +818,12 @@ int kvm_arch_vcpu_ioctl_run(struct
> > > kvm_vcpu
> > > > > *vcpu, struct kvm_run *run)
> > > > > >  		kvm_arm_clear_debug(vcpu);
> > > > > >
> > > > > >  		/*
> > > > > > -		 * We must sync the PMU state before the vgic state so
> > > > > > +		 * We must sync the PMU and SPE state before the vgic state
> > > so
> > > > > >  		 * that the vgic can properly sample the updated state of
> > > the
> > > > > >  		 * interrupt line.
> > > > > >  		 */
> > > > > >  		kvm_pmu_sync_hwstate(vcpu);
> > > > > > +		kvm_spe_sync_hwstate(vcpu);
> > > > >
> > > > > The *HUGE* difference is that the PMU is purely a virtual
> > > interrupt,
> > > > > while you're trying to deal with a HW interrupt here.
> > > > >
> > > > > >
> > > > > >  		/*
> > > > > >  		 * Sync the vgic state before syncing the timer state
> > > because
> > > > > > diff --git a/virt/kvm/arm/spe.c b/virt/kvm/arm/spe.c
> > > > > > index 83ac2cce2cc3..097ed39014e4 100644
> > > > > > --- a/virt/kvm/arm/spe.c
> > > > > > +++ b/virt/kvm/arm/spe.c
> > > > > > @@ -35,6 +35,68 @@ int kvm_arm_spe_v1_enable(struct kvm_vcpu
> > > > > *vcpu)
> > > > > >  	return 0;
> > > > > >  }
> > > > > >
> > > > > > +static inline void set_spe_irq_phys_active(struct
> > > > > arm_spe_kvm_info *info,
> > > > > > +					   bool active)
> > > > > > +{
> > > > > > +	int r;
> > > > > > +	r = irq_set_irqchip_state(info->physical_irq,
> > > > > IRQCHIP_STATE_ACTIVE,
> > > > > > +				  active);
> > > > > > +	WARN_ON(r);
> > > > > > +}
> > > > > > +
> > > > > > +void kvm_spe_flush_hwstate(struct kvm_vcpu *vcpu)
> > > > > > +{
> > > > > > +	struct kvm_spe *spe = &vcpu->arch.spe;
> > > > > > +	bool phys_active = false;
> > > > > > +	struct arm_spe_kvm_info *info = arm_spe_get_kvm_info();
> > > > > > +
> > > > > > +	if (!kvm_arm_spe_v1_ready(vcpu))
> > > > > > +		return;
> > > > > > +
> > > > > > +	if (irqchip_in_kernel(vcpu->kvm))
> > > > > > +		phys_active = kvm_vgic_map_is_active(vcpu, spe->irq_num);
> > > > > > +
> > > > > > +	phys_active |= spe->irq_level;
> > > > > > +
> > > > > > +	set_spe_irq_phys_active(info, phys_active);
> > > > >
> > > > > So you're happy to mess with the HW interrupt state even when
> > > you
> > > > > don't have a HW irqchip? If you are going to copy paste the
> > > timer
> > > > > code
> > > > > here, you'd need to support it all the way (no, don't).
> > > > >
> > > > > > +}
> > > > > > +
> > > > > > +void kvm_spe_sync_hwstate(struct kvm_vcpu *vcpu)
> > > > > > +{
> > > > > > +	struct kvm_spe *spe = &vcpu->arch.spe;
> > > > > > +	u64 pmbsr;
> > > > > > +	int r;
> > > > > > +	bool service;
> > > > > > +	struct kvm_cpu_context *ctxt = &vcpu->arch.ctxt;
> > > > > > +	struct arm_spe_kvm_info *info = arm_spe_get_kvm_info();
> > > > > > +
> > > > > > +	if (!kvm_arm_spe_v1_ready(vcpu))
> > > > > > +		return;
> > > > > > +
> > > > > > +	set_spe_irq_phys_active(info, false);
> > > > > > +
> > > > > > +	pmbsr = ctxt->sys_regs[PMBSR_EL1];
> > > > > > +	service = !!(pmbsr & BIT(SYS_PMBSR_EL1_S_SHIFT));
> > > > > > +	if (spe->irq_level == service)
> > > > > > +		return;
> > > > > > +
> > > > > > +	spe->irq_level = service;
> > > > > > +
> > > > > > +	if (likely(irqchip_in_kernel(vcpu->kvm))) {
> > > > > > +		r = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
> > > > > > +					spe->irq_num, service, spe);
> > > > > > +		WARN_ON(r);
> > > > > > +	}
> > > > > > +}
> > > > > > +
> > > > > > +static inline bool kvm_arch_arm_spe_v1_get_input_level(int
> > > > > vintid)
> > > > > > +{
> > > > > > +	struct kvm_vcpu *vcpu = kvm_arm_get_running_vcpu();
> > > > > > +	struct kvm_spe *spe = &vcpu->arch.spe;
> > > > > > +
> > > > > > +	return spe->irq_level;
> > > > > > +}
> > > > >
> > > > > This isn't what such a callback is for. It is supposed to sample
> > > the
> > > > > HW, an nothing else.
> > > > >
> > > > > > +
> > > > > >  static int kvm_arm_spe_v1_init(struct kvm_vcpu *vcpu)
> > > > > >  {
> > > > > >  	if (!kvm_arm_support_spe_v1())
> > > > > > @@ -48,6 +110,7 @@ static int kvm_arm_spe_v1_init(struct
> > > kvm_vcpu
> > > > > *vcpu)
> > > > > >
> > > > > >  	if (irqchip_in_kernel(vcpu->kvm)) {
> > > > > >  		int ret;
> > > > > > +		struct arm_spe_kvm_info *info;
> > > > > >
> > > > > >  		/*
> > > > > >  		 * If using the SPE with an in-kernel virtual GIC
> > > > > > @@ -57,10 +120,18 @@ static int kvm_arm_spe_v1_init(struct
> > > > > kvm_vcpu *vcpu)
> > > > > >  		if (!vgic_initialized(vcpu->kvm))
> > > > > >  			return -ENODEV;
> > > > > >
> > > > > > +		info = arm_spe_get_kvm_info();
> > > > > > +		if (!info->physical_irq)
> > > > > > +			return -ENODEV;
> > > > > > +
> > > > > >  		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.spe.irq_num,
> > > > > >  					 &vcpu->arch.spe);
> > > > > >  		if (ret)
> > > > > >  			return ret;
> > > > > > +
> > > > > > +		ret = kvm_vgic_map_phys_irq(vcpu, info->physical_irq,
> > > > > > +					    vcpu->arch.spe.irq_num,
> > > > > > +					    kvm_arch_arm_spe_v1_get_input_level);
> > > > >
> > > > > You're mapping the interrupt int the guest, and yet you have
> > > never
> > > > > forwarded the interrupt the first place. All this flow is only
> > > going
> > > > > to wreck the host driver as soon as an interrupt occurs.
> > > > >
> > > > > I think you should rethink the interrupt handling altogether. It
> > > > > would
> > > > > make more sense if the interrupt was actually completely
> > > > > virtualized. If you can isolate the guest state and compute the
> > > > > interrupt state in SW (and from the above, it seems that you
> > > can),
> > > > > then you shouldn't mess with the whole forwarding *at all*, as
> > > it
> > > > > isn't designed for devices shared between host and guests.
> > > >
> > > > Yes it's possible to read SYS_PMBSR_EL1_S_SHIFT and determine if
> > > SPE
> > > > wants
> > > > service. If I understand correctly, you're suggesting on
> > > entry/exit to
> > > > the
> > > > guest we determine this and inject an interrupt to the guest. As
> > > well as
> > > > removing the kvm_vgic_map_phys_irq mapping to the physical
> > > interrupt?
> > > 
> > > The mapping only makes sense for devices that have their interrupt
> > > forwarded to a vcpu, where the expected flow is that the interrupt
> > > is taken on the host with a normal interrupt handler and then
> > > injected in the guest (you still have to manage the active state
> > > though). The basic assumption is that such a device is entirely
> > > owned by KVM.
> > 
> > Though the mapping does mean that if the guest handles the guest SPE
> > interrupt it doesn't have to wait for a guest exit before having the
> > SPE interrupt evaluated again (i.e. another SPE interrupt won't cause
> > a guest exit) - thus increasing the size of any black hole.
> 
> Sure. It still remains that your use case is outside of the scope of
> this internal API.
> 
> > > Here, you're abusing the mapping interface: you don't have an
> > > interrupt handler (the host SPE driver owns it), the interrupt
> > > isn't forwarded, and yet you're messing with the active state.
> > > None of that is expected, and you are in uncharted territory
> > > as far as KVM is concerned.
> > > 
> > > What bothers me the most is that this looks a lot like a previous
> > > implementation of the timers, and we had all the problems in the
> > > world to keep track of the interrupt state *and* have a reasonable
> > > level of performance (hitting the redistributor on the fast path
> > > is a performance killer).
> > > 
> > > > My understanding was that I needed knowledge of the physical SPE
> > > > interrupt
> > > > number so that I could prevent the host SPE driver from getting
> > > spurious
> > > > interrupts due to guest use of the SPE.
> > > 
> > > You can't completely rule out the host getting interrupted. Even if
> > > you set
> > > PMBSR_EL1.S to zero, there is no guarantee that the host will not
> > > observe
> > > the interrupt anyway (the GIC architecture doesn't tell you how
> > > quickly
> > > it will be retired, if ever). The host driver already checks for
> > > this
> > > anyway.
> > > 
> > > What you need to ensure is that PMBSR_EL1.S being set on guest entry
> > > doesn't immediately kick you out of the guest and prevent forward
> > > progress. This is why you need to manage the active state.
> > > 
> > > The real question is: how quickly do you want to react to a SPE
> > > interrupt firing while in a guest?
> > > 
> > > If you want to take it into account as soon as it fires, then you
> > > need
> > > to eagerly save/restore the active state together with the SPE state
> > > on
> > > each entry/exit, and performance will suffer. This is what you are
> > > currently doing.
> > > 
> > > If you're OK with evaluating the interrupt status on exit, but
> > > without
> > > the interrupt itself causing an exit, then you can simply manage it
> > > as a purely virtual interrupt, and just deal with the active state
> > > in load/put (set the interrupt as active on load, clear it on put).
> > 
> > This does feel like the pragmatic approach - a larger black hole in
> > exchange
> > for performance. I imagine the blackhole would be naturally reduced on
> > machines with high workloads.
> 
> Why? I don't see the relation between how busy the vcpu is and the size
> of the blackhole. It is strictly a function of the frequency of exits.

Indeed, my assumption being that the busier a system is the more
interrupts, thus leading to more exits and so an increased frequency of
SPE interrupt evaluation and thus smaller black hole.

Thanks,

Andrew Murray

> 
>         M.
> 
> > 
> > I'll refine the series to take this approach.
> > 
> > > 
> > > Given that SPE interrupts always indicate that profiling has
> > > stopped,
> > 
> > and faults :|
> > 
> > Thanks,
> > 
> > Andrew Murray
> > 
> > > this only affects the size of the black hole, and I'm inclined to do
> > > the latter.
> > > 
> > >         M.
> > > --
> > > Jazz is not dead. It just smells funny...
> 
> -- 
> Jazz is not dead. It just smells funny...
