Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF279CC2B
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2019 11:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbfHZJFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 05:05:47 -0400
Received: from foss.arm.com ([217.140.110.172]:54894 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbfHZJFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 05:05:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C096C28;
        Mon, 26 Aug 2019 02:05:46 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 537433F59C;
        Mon, 26 Aug 2019 02:05:46 -0700 (PDT)
Date:   Mon, 26 Aug 2019 11:05:45 +0200
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        kvmarm <kvmarm@lists.cs.columbia.edu>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH] kvm: arm: Promote KVM_ARM_TARGET_CORTEX_A7 to generic V7
 core
Message-ID: <20190826090545.GB12352@e113682-lin.lund.arm.com>
References: <b486cb75-4b8e-c847-a019-81e822223fb6@web.de>
 <ad19bda0-48df-1df0-7fb0-fc7d88ab1964@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad19bda0-48df-1df0-7fb0-fc7d88ab1964@siemens.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 31, 2019 at 10:17:53AM +0200, Jan Kiszka wrote:
> On 30.06.19 17:19, Jan Kiszka wrote:
> > From: Jan Kiszka <jan.kiszka@siemens.com>
> > 
> > The only difference between the currently supported A15 and A7 target
> > cores is the reset state of bit 11 in SCTLR. This bit is RES1 or RAO/WI
> > in other ARM cores, including ARMv8 ones. By promoting A7 to a generic
> > default target, this allows to use yet unsupported core types. E.g.,
> > this enables KVM on the A72 of the RPi4.
> > 
> > Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> > ---
> >  arch/arm/include/uapi/asm/kvm.h                |  1 +
> >  arch/arm/kvm/Makefile                          |  2 +-
> >  arch/arm/kvm/{coproc_a7.c => coproc_generic.c} | 18 +++++++++---------
> >  arch/arm/kvm/guest.c                           |  4 +---
> >  arch/arm/kvm/reset.c                           |  5 +----
> >  5 files changed, 13 insertions(+), 17 deletions(-)
> >  rename arch/arm/kvm/{coproc_a7.c => coproc_generic.c} (70%)
> > 
> > diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> > index 4602464ebdfb..e0c5bbec3d3d 100644
> > --- a/arch/arm/include/uapi/asm/kvm.h
> > +++ b/arch/arm/include/uapi/asm/kvm.h
> > @@ -70,6 +70,7 @@ struct kvm_regs {
> >  /* Supported Processor Types */
> >  #define KVM_ARM_TARGET_CORTEX_A15	0
> >  #define KVM_ARM_TARGET_CORTEX_A7	1
> > +#define KVM_ARM_TARGET_GENERIC_V7	KVM_ARM_TARGET_CORTEX_A7
> >  #define KVM_ARM_NUM_TARGETS		2
> > 
> >  /* KVM_ARM_SET_DEVICE_ADDR ioctl id encoding */
> > diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> > index 531e59f5be9c..d959f89135d6 100644
> > --- a/arch/arm/kvm/Makefile
> > +++ b/arch/arm/kvm/Makefile
> > @@ -21,7 +21,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += hyp/
> > 
> >  obj-y += kvm-arm.o init.o interrupts.o
> >  obj-y += handle_exit.o guest.o emulate.o reset.o
> > -obj-y += coproc.o coproc_a15.o coproc_a7.o   vgic-v3-coproc.o
> > +obj-y += coproc.o coproc_a15.o coproc_generic.o   vgic-v3-coproc.o
> >  obj-y += $(KVM)/arm/arm.o $(KVM)/arm/mmu.o $(KVM)/arm/mmio.o
> >  obj-y += $(KVM)/arm/psci.o $(KVM)/arm/perf.o
> >  obj-y += $(KVM)/arm/aarch32.o
> > diff --git a/arch/arm/kvm/coproc_a7.c b/arch/arm/kvm/coproc_generic.c
> > similarity index 70%
> > rename from arch/arm/kvm/coproc_a7.c
> > rename to arch/arm/kvm/coproc_generic.c
> > index 40f643e1e05c..b32a541ad7bf 100644
> > --- a/arch/arm/kvm/coproc_a7.c
> > +++ b/arch/arm/kvm/coproc_generic.c
> > @@ -15,28 +15,28 @@
> >  #include "coproc.h"
> > 
> >  /*
> > - * Cortex-A7 specific CP15 registers.
> > + * Generic CP15 registers.
> >   * CRn denotes the primary register number, but is copied to the CRm in the
> >   * user space API for 64-bit register access in line with the terminology used
> >   * in the ARM ARM.
> >   * Important: Must be sorted ascending by CRn, CRM, Op1, Op2 and with 64-bit
> >   *            registers preceding 32-bit ones.
> >   */
> > -static const struct coproc_reg a7_regs[] = {
> > +static const struct coproc_reg generic_regs[] = {
> >  	/* SCTLR: swapped by interrupt.S. */
> >  	{ CRn( 1), CRm( 0), Op1( 0), Op2( 0), is32,
> >  			access_vm_reg, reset_val, c1_SCTLR, 0x00C50878 },
> >  };
> > 
> > -static struct kvm_coproc_target_table a7_target_table = {
> > -	.target = KVM_ARM_TARGET_CORTEX_A7,
> > -	.table = a7_regs,
> > -	.num = ARRAY_SIZE(a7_regs),
> > +static struct kvm_coproc_target_table generic_target_table = {
> > +	.target = KVM_ARM_TARGET_GENERIC_V7,
> > +	.table = generic_regs,
> > +	.num = ARRAY_SIZE(generic_regs),
> >  };
> > 
> > -static int __init coproc_a7_init(void)
> > +static int __init coproc_generic_init(void)
> >  {
> > -	kvm_register_target_coproc_table(&a7_target_table);
> > +	kvm_register_target_coproc_table(&generic_target_table);
> >  	return 0;
> >  }
> > -late_initcall(coproc_a7_init);
> > +late_initcall(coproc_generic_init);
> > diff --git a/arch/arm/kvm/guest.c b/arch/arm/kvm/guest.c
> > index 684cf64b4033..d33a24e70f49 100644
> > --- a/arch/arm/kvm/guest.c
> > +++ b/arch/arm/kvm/guest.c
> > @@ -275,12 +275,10 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
> >  int __attribute_const__ kvm_target_cpu(void)
> >  {
> >  	switch (read_cpuid_part()) {
> > -	case ARM_CPU_PART_CORTEX_A7:
> > -		return KVM_ARM_TARGET_CORTEX_A7;
> >  	case ARM_CPU_PART_CORTEX_A15:
> >  		return KVM_ARM_TARGET_CORTEX_A15;
> >  	default:
> > -		return -EINVAL;
> > +		return KVM_ARM_TARGET_GENERIC_V7;
> >  	}
> >  }
> > 
> > diff --git a/arch/arm/kvm/reset.c b/arch/arm/kvm/reset.c
> > index eb4174f6ebbd..d6e07500bab4 100644
> > --- a/arch/arm/kvm/reset.c
> > +++ b/arch/arm/kvm/reset.c
> > @@ -43,13 +43,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >  	struct kvm_regs *reset_regs;
> > 
> >  	switch (vcpu->arch.target) {
> > -	case KVM_ARM_TARGET_CORTEX_A7:
> > -	case KVM_ARM_TARGET_CORTEX_A15:
> > +	default:
> >  		reset_regs = &cortexa_regs_reset;
> >  		vcpu->arch.midr = read_cpuid_id();
> >  		break;
> > -	default:
> > -		return -ENODEV;
> >  	}
> > 
> >  	/* Reset core registers */
> > --
> > 2.16.4
> > 
> 
> Any comments on this one now? Vladimir, you had some concerns in the other
> thread. I'm not sure if I got them correctly, if they apply here.
> 

The concern was, if we try to model a versatile express as a generic v7,
the guest may end up poking a register which doesn't exist or behave as
expected on the underlying CPU and generate some kind of exception.
However, I can't see this hurting existing configurations or the host,
so I think this patch looks fine, and we can fix issues as we progress.

Although, I second Marc in that we should be removing the 32-bit KVM
support to lighten maintenance, and have a way to run a 64-bit kernel on
the RPi4.  Of course, if we hear about *actual users* of the 32-bit KVM,
then we can reconsider.


Thanks,

    Christoffer
