Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1286C41125C
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 11:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbhITJ63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 05:58:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhITJ62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 05:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CBF860F6C;
        Mon, 20 Sep 2021 09:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632131822;
        bh=RihsqFvE+nm2Ia1YemLKUdMCZ09Lq/k0Ywkq9qemluo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dzpqT7/GqR29+vFxzLt5/l/9PXMbYih7x/zJ+hKfBEvnKMWVa9u1JcwQtZ/zSL885
         hdj0PB6z2ImPmVxPSc7c6qBLgAaw+DOAif8wDqpPhvATCZVC4W9u44X48OMkPXw2bO
         BYrnhx4GlJbiOSmNf6vVQT0NTjbEoxh3S/pBw5cqAHUHqp1YGfh4twx4sL/nV7aMTf
         r5XcxK6oolnSvRC6or4TNmI19cPq0yPZqeyfteba9jG7gqFidkK3s7Vtsj3Pni0Gml
         2kGfu/bm9cp89kHK0PgaNeuHI+iRbBBBUw1cSJM1UIo0rXcC4I0UgW2iDqCXvRXP2c
         tw+ozyUVPGFCw==
Date:   Mon, 20 Sep 2021 10:56:57 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: REGRESSION: Upgrading host kernel from 5.11 to 5.13 breaks QEMU
 guests - perf/fw_devlink/kvm
Message-ID: <20210920095656.GA11961@willie-the-truck>
References: <YUYRKVflRtUytzy5@shell.armlinux.org.uk>
 <877dfcwutt.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dfcwutt.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:36:46PM +0100, Marc Zyngier wrote:
> Hi Russell,
> 
> Thanks for the heads-up.
> 
> On Sat, 18 Sep 2021 17:17:45 +0100,
> "Russell King (Oracle)" <linux@armlinux.org.uk> wrote:
> > 
> > Hi,
> > 
> > This morning, I upgraded my VM host from Debian Buster to Debian
> > Bullseye. This host (Armada 8040) runs libvirt. I placed all the VMs
> > into managedsave, which basically means their state is saved out by
> > QEMU ready to be resumed once the upgrade is complete.
> > 
> > Initially, I was running 5.11 on the host, which didn't have POSIX
> > ACLs enabled on tmpfs. Sadly, upgrading to Bullseye now requires
> > this to be enabled, so I upgraded the kernel to 5.13 to avoid this
> > problem - without POSIX ACLs on tmpfs, qemu refuses to even start.
> > 
> > Under Bullseye with 5.13, I could start new VMs, but I could not
> > resume the saved VMs - it would spit out:
> > 
> > 2021-09-18T11:14:14.456227Z qemu-system-aarch64: Invalid value 236 expecting positive value <= 162
> > 2021-09-18T11:14:14.456269Z qemu-system-aarch64: Failed to load cpu:cpreg_vmstate_array_len
> > 2021-09-18T11:14:14.456279Z qemu-system-aarch64: error while loading state for instance 0x0 of device 'cpu'
> > 2021-09-18T11:14:14.456887Z qemu-system-aarch64: load of migration failed: Invalid argument
> > 
> > Essentially, what this is complaining about is that the register
> > list returned by the KVM_GET_REG_LIST ioctl has reduced in size,
> > meaning that the saved VM has more registers that need to be set
> > (236 of them, after QEMU's filtering) than those which are actually
> > available under 5.13 (162 after QEMU's filtering).
> > 
> > After much debugging, and writing a program to create a VM and CPU,
> > and retrieve the register list etc, I have finally tracked down
> > exactly what is going on...
> > 
> > Under 5.13, KVM believes there is no PMU, so it doesn't advertise the
> > PMU registers, despite the hardware having a PMU and the kernel
> > having support.
> > 
> > kvm_arm_support_pmu_v3() determines whether the PMU_V3 feature is
> > available or not.
> > 
> > Under 5.11, this was determined via:
> > 
> > 	perf_num_counters() > 0
> > 
> > which in turn was derived from (essentially):
> > 
> > 	__oprofile_cpu_pmu && __oprofile_cpu_pmu->num_events > 0
> > 
> > __oprofile_cpu_pmu can be set at any time when the PMU has been
> > initialised, and due to initialisation ordering, it appears to happen
> > much later in the kernel boot.
> > 
> > However, under 5.13, oprofile has been removed, and this test is no
> > longer present. Instead, kvm attempts to determine the availability
> > of PMUv3 when it initialises, and fails to because the PMU has not
> > yet been initialised. If there is no PMU at the point KVM initialises,
> > then KVM will never advertise a PMU.
> > 
> > This change of behaviour is what breaks KVM on Armada 8040, causing
> > a userspace regression.
> > 
> > What makes this more confusing is the PMU errors have gone:
> > 
> > 5.13:
> > [    0.170514] PCI: CLS 0 bytes, default 64
> > [    0.171085] kvm [1]: IPA Size Limit: 44 bits
> > [    0.172532] kvm [1]: vgic interrupt IRQ9
> > [    0.172650] kvm: pmu event creation failed -2
> > [    0.172688] kvm [1]: Hyp mode initialized successfully
> > ...
> > [    1.479833] hw perfevents: enabled with armv8_cortex_a72 PMU driver, 7 counters available
> >
> 
> [...]
> 
> Urgh. That's a bummer. T1he PMU driver only comes up once it has found
> its interrupt controller, which on the Armada 8040 is not the GIC, but
> some weird thing on the side that doesn't actually serve any real
> purpose. On HW where the PMU is directly wired into the GIC, it all
> works fine, though by luck rather than by design.
> 
> Anyway, rant over. This is a bug that needs addressing so that KVM can
> initialise correctly irrespective of the probing order. This probably
> means that the static key controlling KVM's behaviour wrt the PMU must
> be controlled by the PMU infrastructure itself, rather than KVM trying
> to probe for it.
> 
> Can you please give the following hack a go (on top of 5.15-rc1)? I've
> briefly tested it on my McBin, and it did the trick. I've also tested
> it on the M1 (which really doesn't have an architectural PMU) to
> verify that it was correctly failing.
> 
> Thanks,
> 
> 	M.
> 
> From 9c26e3e6bbcbc3a583b3974e7a9017029d31fe29 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Sun, 19 Sep 2021 14:09:49 +0100
> Subject: [PATCH] KVM: arm64: Fix PMU probe ordering
> 
> Russell reported that since 5.13, KVM's probing of the PMU has
> started to fail on his HW. As it turns out, there is an implicit
> ordering dependency between the architectural PMU probing code and
> and KVM's own probing. If, due to probe ordering reasons, KVM probes
> before the PMU driver, it will fail to detect the PMU and prevent it
> from being advertised to guests as well as the VMM.
> 
> Obviously, this is one probing too many, and we should be able to
> deal with any ordering.
> 
> Add a callback from the PMU code into KVM to advertise the registration
> of a host CPU PMU, allowing for any probing order.
> 
> Fixes: 5421db1be3b1 ("KVM: arm64: Divorce the perf code from oprofile helpers")
> Reported-by: "Russell King (Oracle)" <linux@armlinux.org.uk>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/YUYRKVflRtUytzy5@shell.armlinux.org.uk
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/perf.c        |  3 ---
>  arch/arm64/kvm/pmu-emul.c    | 12 +++++++++++-
>  drivers/perf/arm_pmu.c       |  2 ++
>  include/kvm/arm_pmu.h        |  3 ---
>  include/linux/perf/arm_pmu.h |  6 ++++++
>  5 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/perf.c b/arch/arm64/kvm/perf.c
> index f9bb3b14130e..c84fe24b2ea1 100644
> --- a/arch/arm64/kvm/perf.c
> +++ b/arch/arm64/kvm/perf.c
> @@ -50,9 +50,6 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
>  
>  int kvm_perf_init(void)
>  {
> -	if (kvm_pmu_probe_pmuver() != ID_AA64DFR0_PMUVER_IMP_DEF && !is_protected_kvm_enabled())
> -		static_branch_enable(&kvm_arm_pmu_available);
> -
>  	return perf_register_guest_info_callbacks(&kvm_guest_cbs);
>  }
>  
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index f5065f23b413..588100c52f34 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -740,7 +740,17 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  	kvm_pmu_create_perf_event(vcpu, select_idx);
>  }
>  
> -int kvm_pmu_probe_pmuver(void)
> +void kvm_host_pmu_init(struct arm_pmu *pmu)
> +{
> +	if (pmu->pmuver != 0 &&
> +	    pmu->pmuver != ID_AA64DFR0_PMUVER_IMP_DEF &&
> +	    !is_protected_kvm_enabled()) {
> +		static_branch_enable(&kvm_arm_pmu_available);
> +		kvm_info("PMU detected and enabled\n");
> +	}
> +}
> +
> +static int kvm_pmu_probe_pmuver(void)
>  {
>  	struct perf_event_attr attr = { };
>  	struct perf_event *event;
> diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
> index 3cbc3baf087f..295cc7952d0e 100644
> --- a/drivers/perf/arm_pmu.c
> +++ b/drivers/perf/arm_pmu.c
> @@ -952,6 +952,8 @@ int armpmu_register(struct arm_pmu *pmu)
>  		pmu->name, pmu->num_events,
>  		has_nmi ? ", using NMIs" : "");
>  
> +	kvm_host_pmu_init(pmu);

Just a nit, but I think this will get called for each PMU we probe on a
big.LITTLE system which is probably harmless, but possible not what you want?

Will
