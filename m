Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A44B12A15B
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2019 13:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfLXMf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 07:35:58 -0500
Received: from foss.arm.com ([217.140.110.172]:51810 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726195AbfLXMf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 07:35:58 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C6A51FB;
        Tue, 24 Dec 2019 04:35:57 -0800 (PST)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7BE13F534;
        Tue, 24 Dec 2019 04:35:56 -0800 (PST)
Date:   Tue, 24 Dec 2019 12:35:55 +0000
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 13/18] perf: arm_spe: Add KVM structure for obtaining
 IRQ info
Message-ID: <20191224123554.GK42593@e119886-lin.cambridge.arm.com>
References: <20191220143025.33853-1-andrew.murray@arm.com>
 <20191220143025.33853-14-andrew.murray@arm.com>
 <868sn4iowy.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <868sn4iowy.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 22, 2019 at 11:24:13AM +0000, Marc Zyngier wrote:
> On Fri, 20 Dec 2019 14:30:20 +0000,
> Andrew Murray <andrew.murray@arm.com> wrote:
> > 
> > KVM requires knowledge of the physical SPE IRQ number such that it can
> > associate it with any virtual IRQ for guests that require SPE emulation.
> 
> This is at best extremely odd. The only reason for KVM to obtain this
> IRQ number is if it has exclusive access to the device.  This
> obviously isn't the case, as this device is shared between host and
> guest.

This was an attempt to set the interrupt as active such that host SPE driver
doesn't get spurious interrupts due to guest SPE activity. Though let's save
the discussion to patch 14.


> 
> > Let's create a structure to hold this information and an accessor that
> > KVM can use to retrieve this information.
> > 
> > We expect that each SPE device will have the same physical PPI number
> > and thus will warn when this is not the case.
> > 
> > Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> > ---
> >  drivers/perf/arm_spe_pmu.c | 23 +++++++++++++++++++++++
> >  include/kvm/arm_spe.h      |  6 ++++++
> >  2 files changed, 29 insertions(+)
> > 
> > diff --git a/drivers/perf/arm_spe_pmu.c b/drivers/perf/arm_spe_pmu.c
> > index 4e4984a55cd1..2d24af4cfcab 100644
> > --- a/drivers/perf/arm_spe_pmu.c
> > +++ b/drivers/perf/arm_spe_pmu.c
> > @@ -34,6 +34,9 @@
> >  #include <linux/smp.h>
> >  #include <linux/vmalloc.h>
> >  
> > +#include <linux/kvm_host.h>
> > +#include <kvm/arm_spe.h>
> > +
> >  #include <asm/barrier.h>
> >  #include <asm/cpufeature.h>
> >  #include <asm/mmu.h>
> > @@ -1127,6 +1130,24 @@ static void arm_spe_pmu_dev_teardown(struct arm_spe_pmu *spe_pmu)
> >  	free_percpu_irq(spe_pmu->irq, spe_pmu->handle);
> >  }
> >  
> > +#ifdef CONFIG_KVM_ARM_SPE
> > +static struct arm_spe_kvm_info arm_spe_kvm_info;
> > +
> > +struct arm_spe_kvm_info *arm_spe_get_kvm_info(void)
> > +{
> > +	return &arm_spe_kvm_info;
> > +}
> 
> How does this work when SPE is built as a module?
> 
> > +
> > +static void arm_spe_populate_kvm_info(struct arm_spe_pmu *spe_pmu)
> > +{
> > +	WARN_ON_ONCE(arm_spe_kvm_info.physical_irq != 0 &&
> > +		     arm_spe_kvm_info.physical_irq != spe_pmu->irq);
> > +	arm_spe_kvm_info.physical_irq = spe_pmu->irq;
> 
> What does 'physical' means here? It's an IRQ in the Linux sense, so
> it's already some random number that bears no relation to anything
> 'physical'.

It's some random number relating to the SPE device as opposed to the virtual
SPE device.

Thanks,

Andrew Murray

> 
> > +}
> > +#else
> > +static void arm_spe_populate_kvm_info(struct arm_spe_pmu *spe_pmu) {}
> > +#endif
> > +
> >  /* Driver and device probing */
> >  static int arm_spe_pmu_irq_probe(struct arm_spe_pmu *spe_pmu)
> >  {
> > @@ -1149,6 +1170,8 @@ static int arm_spe_pmu_irq_probe(struct arm_spe_pmu *spe_pmu)
> >  	}
> >  
> >  	spe_pmu->irq = irq;
> > +	arm_spe_populate_kvm_info(spe_pmu);
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/include/kvm/arm_spe.h b/include/kvm/arm_spe.h
> > index d1f3c564dfd0..9c65130d726d 100644
> > --- a/include/kvm/arm_spe.h
> > +++ b/include/kvm/arm_spe.h
> > @@ -17,6 +17,12 @@ struct kvm_spe {
> >  	bool irq_level;
> >  };
> >  
> > +struct arm_spe_kvm_info {
> > +	int physical_irq;
> > +};
> > +
> > +struct arm_spe_kvm_info *arm_spe_get_kvm_info(void);
> > +
> >  #ifdef CONFIG_KVM_ARM_SPE
> >  #define kvm_arm_spe_v1_ready(v)		((v)->arch.spe.ready)
> >  #define kvm_arm_spe_irq_initialized(v)		\
> 
> 	M.
> 
> -- 
> Jazz is not dead, it just smells funny.
