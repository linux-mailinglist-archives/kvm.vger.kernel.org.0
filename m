Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBD13FFD46
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 11:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348870AbhICJiy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 05:38:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348802AbhICJix (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 05:38:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630661872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NHPlN1CMjF8oW7JA2HtyI/1Hb35tXEhAcNKlYoQQt7U=;
        b=S3fmwqdC42SfRp9Fv8Xd2G22+H0w3w/5263U3Aa7i77X0z4mWdBDaNWXu7sOcAMxK6/doA
        zbu13EeDgpN1OZtxZh8YYaLU9dzj8bHucUg7Phbywolrx14TrQ0RcfmGUYGnbVG2KUQvXZ
        SvD2dJbJ2pTXpdyv/7BxUPhoy194muc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399--pb-tyNhNcOFHiXKuFQBfw-1; Fri, 03 Sep 2021 05:37:51 -0400
X-MC-Unique: -pb-tyNhNcOFHiXKuFQBfw-1
Received: by mail-ej1-f71.google.com with SMTP id x21-20020a170906135500b005d8d4900c5eso2442000ejb.4
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 02:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NHPlN1CMjF8oW7JA2HtyI/1Hb35tXEhAcNKlYoQQt7U=;
        b=URuJrykJBmgcpttIZidVil/ZP0ezih0M6jRRRiHfNWdn30vyR/fL/YbP84bU6yotgb
         FyzNx/hrIDkuJnUueGVODSuAlkVJiuBivLH9A1n0IzR6dqWUClVBY+QQ02yL7/x5mzoU
         BjuxM7H62eMKLYQ6tu40xNYPx3khCHKJ+Wo5qP+Ejl0Td8VSHzWksz537Q7P5FgWno7x
         4JPE1TKhKJD6sg/T8Jh6+eU5U9esPtbByct+LgF9IBMmZpCVZEMfkQqCbiIcsZ2Aompu
         UQX0ZPTMS5of3K0FQAQ04DfxICPN/wElSIxwS/GhNUpTR/oKEIfhAg7yzBvB682EhLP6
         ASpg==
X-Gm-Message-State: AOAM53149X65bg1kl+BsdgLCtD4cKrG7hI6QtNXnMk9wPQX49+yIzHQ2
        9DuoEFt82sKXp74gKBtJk4ZW06qbw0z2Yh+6DAGCjiG3XB2A6/b8pzAfjjIZ+f50CNNBFkjxAsX
        QqNU6g/f2Xq6Q
X-Received: by 2002:a17:906:1f54:: with SMTP id d20mr3245872ejk.48.1630661870607;
        Fri, 03 Sep 2021 02:37:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFsIBgDJMz4qMT9V8O3mOUZHkMdemCxK+YhFlYbCNE35fGAmZa4taMQxBrf/WvZbPlZbSF3Q==
X-Received: by 2002:a17:906:1f54:: with SMTP id d20mr3245850ejk.48.1630661870331;
        Fri, 03 Sep 2021 02:37:50 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id g10sm2468318ejj.44.2021.09.03.02.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 02:37:50 -0700 (PDT)
Date:   Fri, 3 Sep 2021 11:37:48 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 09/12] KVM: arm64: selftests: Add basic GICv3 support
Message-ID: <20210903093748.a3cjstzk74vetxex@gator.home>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-10-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901211412.4171835-10-rananta@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:14:09PM +0000, Raghavendra Rao Ananta wrote:
> Add basic support for ARM Generic Interrupt Controller v3.
> The support provides guests to setup interrupts.
> 
> The work is inspired from kvm-unit-tests and the kernel's
> GIC driver (drivers/irqchip/irq-gic-v3.c).
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   2 +-
>  .../selftests/kvm/include/aarch64/gic.h       |  21 ++
>  tools/testing/selftests/kvm/lib/aarch64/gic.c |  93 +++++++
>  .../selftests/kvm/lib/aarch64/gic_private.h   |  21 ++
>  .../selftests/kvm/lib/aarch64/gic_v3.c        | 240 ++++++++++++++++++
>  .../selftests/kvm/lib/aarch64/gic_v3.h        |  70 +++++
>  6 files changed, 446 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/kvm/include/aarch64/gic.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_private.h
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
>  create mode 100644 tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
> 
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 61f0d376af99..5476a8ddef60 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -35,7 +35,7 @@ endif
>  
>  LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
>  LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
> -LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c
> +LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c
>  LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
>  
>  TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
> diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
> new file mode 100644
> index 000000000000..85dd1e53048e
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * ARM Generic Interrupt Controller (GIC) specific defines
> + */
> +
> +#ifndef SELFTEST_KVM_GIC_H
> +#define SELFTEST_KVM_GIC_H
> +
> +enum gic_type {
> +	GIC_V3,
> +	GIC_TYPE_MAX,
> +};
> +
> +void gic_init(enum gic_type type, unsigned int nr_cpus,
> +		void *dist_base, void *redist_base);
> +void gic_irq_enable(unsigned int intid);
> +void gic_irq_disable(unsigned int intid);
> +unsigned int gic_get_and_ack_irq(void);
> +void gic_set_eoi(unsigned int intid);
> +
> +#endif /* SELFTEST_KVM_GIC_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/aarch64/gic.c
> new file mode 100644
> index 000000000000..b0b67f5aeaa6
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ARM Generic Interrupt Controller (GIC) support
> + */
> +
> +#include <errno.h>
> +#include <linux/bits.h>
> +#include <linux/sizes.h>
> +
> +#include "kvm_util.h"
> +
> +#include <gic.h>

"gic.h"

> +#include "gic_private.h"
> +#include "processor.h"
> +#include "spinlock.h"
> +
> +static const struct gic_common_ops *gic_common_ops;
> +static struct spinlock gic_lock;
> +
> +static void gic_cpu_init(unsigned int cpu, void *redist_base)
> +{
> +	gic_common_ops->gic_cpu_init(cpu, redist_base);
> +}
> +
> +static void
> +gic_dist_init(enum gic_type type, unsigned int nr_cpus, void *dist_base)
> +{
> +	const struct gic_common_ops *gic_ops;
> +
> +	spin_lock(&gic_lock);
> +
> +	/* Distributor initialization is needed only once per VM */
> +	if (gic_common_ops) {
> +		spin_unlock(&gic_lock);
> +		return;
> +	}
> +
> +	if (type == GIC_V3)
> +		gic_ops = &gicv3_ops;
> +
> +	gic_ops->gic_init(nr_cpus, dist_base);
> +	gic_common_ops = gic_ops;
> +
> +	/* Make sure that the initialized data is visible to all the vCPUs */
> +	dsb(sy);
> +
> +	spin_unlock(&gic_lock);
> +}
> +
> +void gic_init(enum gic_type type, unsigned int nr_cpus,
> +		void *dist_base, void *redist_base)
> +{
> +	uint32_t cpu = get_vcpuid();
> +
> +	GUEST_ASSERT(type < GIC_TYPE_MAX);
> +	GUEST_ASSERT(dist_base);
> +	GUEST_ASSERT(redist_base);
> +	GUEST_ASSERT(nr_cpus);
> +
> +	gic_dist_init(type, nr_cpus, dist_base);
> +	gic_cpu_init(cpu, redist_base);
> +}
> +
> +void gic_irq_enable(unsigned int intid)
> +{
> +	GUEST_ASSERT(gic_common_ops);
> +	gic_common_ops->gic_irq_enable(intid);
> +}
> +
> +void gic_irq_disable(unsigned int intid)
> +{
> +	GUEST_ASSERT(gic_common_ops);
> +	gic_common_ops->gic_irq_disable(intid);
> +}
> +
> +unsigned int gic_get_and_ack_irq(void)
> +{
> +	uint64_t irqstat;
> +	unsigned int intid;
> +
> +	GUEST_ASSERT(gic_common_ops);
> +
> +	irqstat = gic_common_ops->gic_read_iar();
> +	intid = irqstat & GENMASK(23, 0);
> +
> +	return intid;
> +}
> +
> +void gic_set_eoi(unsigned int intid)
> +{
> +	GUEST_ASSERT(gic_common_ops);
> +	gic_common_ops->gic_write_eoir(intid);
> +}
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_private.h b/tools/testing/selftests/kvm/lib/aarch64/gic_private.h
> new file mode 100644
> index 000000000000..d81d739433dc
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_private.h
> @@ -0,0 +1,21 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * ARM Generic Interrupt Controller (GIC) private defines that's only
> + * shared among the GIC library code.
> + */
> +
> +#ifndef SELFTEST_KVM_GIC_PRIVATE_H
> +#define SELFTEST_KVM_GIC_PRIVATE_H
> +
> +struct gic_common_ops {
> +	void (*gic_init)(unsigned int nr_cpus, void *dist_base);
> +	void (*gic_cpu_init)(unsigned int cpu, void *redist_base);
> +	void (*gic_irq_enable)(unsigned int intid);
> +	void (*gic_irq_disable)(unsigned int intid);
> +	uint64_t (*gic_read_iar)(void);
> +	void (*gic_write_eoir)(uint32_t irq);
> +};
> +
> +extern const struct gic_common_ops gicv3_ops;
> +
> +#endif /* SELFTEST_KVM_GIC_PRIVATE_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> new file mode 100644
> index 000000000000..4b635ca6a8cb
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.c
> @@ -0,0 +1,240 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ARM Generic Interrupt Controller (GIC) v3 support
> + */
> +
> +#include <linux/sizes.h>
> +
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "delay.h"
> +
> +#include "gic_v3.h"
> +#include "gic_private.h"
> +
> +struct gicv3_data {
> +	void *dist_base;
> +	void *redist_base[GICV3_MAX_CPUS];
> +	unsigned int nr_cpus;
> +	unsigned int nr_spis;
> +};
> +
> +#define sgi_base_from_redist(redist_base) (redist_base + SZ_64K)
> +
> +enum gicv3_intid_range {
> +	SGI_RANGE,
> +	PPI_RANGE,
> +	SPI_RANGE,
> +	INVALID_RANGE,
> +};
> +
> +static struct gicv3_data gicv3_data;
> +
> +static void gicv3_gicd_wait_for_rwp(void)
> +{
> +	unsigned int count = 100000; /* 1s */
> +
> +	while (readl(gicv3_data.dist_base + GICD_CTLR) & GICD_CTLR_RWP) {
> +		GUEST_ASSERT(count--);
> +		udelay(10);
> +	}
> +}
> +
> +static void gicv3_gicr_wait_for_rwp(void *redist_base)
> +{
> +	unsigned int count = 100000; /* 1s */
> +
> +	while (readl(redist_base + GICR_CTLR) & GICR_CTLR_RWP) {
> +		GUEST_ASSERT(count--);
> +		udelay(10);
> +	}
> +}
> +
> +static enum gicv3_intid_range get_intid_range(unsigned int intid)
> +{
> +	switch (intid) {
> +	case 0 ... 15:
> +		return SGI_RANGE;
> +	case 16 ... 31:
> +		return PPI_RANGE;
> +	case 32 ... 1019:
> +		return SPI_RANGE;
> +	}
> +
> +	/* We should not be reaching here */
> +	GUEST_ASSERT(0);
> +
> +	return INVALID_RANGE;
> +}
> +
> +static uint64_t gicv3_read_iar(void)
> +{
> +	uint64_t irqstat = read_sysreg_s(SYS_ICC_IAR1_EL1);
> +
> +	dsb(sy);
> +	return irqstat;
> +}
> +
> +static void gicv3_write_eoir(uint32_t irq)
> +{
> +	write_sysreg_s(SYS_ICC_EOIR1_EL1, irq);
> +	isb();
> +}
> +
> +static void
> +gicv3_config_irq(unsigned int intid, unsigned int offset)
> +{
> +	uint32_t cpu = get_vcpuid();
> +	uint32_t mask = 1 << (intid % 32);
> +	enum gicv3_intid_range intid_range = get_intid_range(intid);
> +	void *reg;
> +
> +	/* We care about 'cpu' only for SGIs or PPIs */
> +	if (intid_range == SGI_RANGE || intid_range == PPI_RANGE) {
> +		GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
> +
> +		reg = sgi_base_from_redist(gicv3_data.redist_base[cpu]) +
> +			offset;
> +		writel(mask, reg);
> +		gicv3_gicr_wait_for_rwp(gicv3_data.redist_base[cpu]);
> +	} else if (intid_range == SPI_RANGE) {
> +		reg = gicv3_data.dist_base + offset + (intid / 32) * 4;
> +		writel(mask, reg);
> +		gicv3_gicd_wait_for_rwp();
> +	} else {
> +		GUEST_ASSERT(0);
> +	}
> +}
> +
> +static void gicv3_irq_enable(unsigned int intid)
> +{
> +	gicv3_config_irq(intid, GICD_ISENABLER);
> +}
> +
> +static void gicv3_irq_disable(unsigned int intid)
> +{
> +	gicv3_config_irq(intid, GICD_ICENABLER);
> +}
> +
> +static void gicv3_enable_redist(void *redist_base)
> +{
> +	uint32_t val = readl(redist_base + GICR_WAKER);
> +	unsigned int count = 100000; /* 1s */
> +
> +	val &= ~GICR_WAKER_ProcessorSleep;
> +	writel(val, redist_base + GICR_WAKER);
> +
> +	/* Wait until the processor is 'active' */
> +	while (readl(redist_base + GICR_WAKER) & GICR_WAKER_ChildrenAsleep) {
> +		GUEST_ASSERT(count--);
> +		udelay(10);
> +	}
> +}
> +
> +static inline void *gicr_base_gpa_cpu(void *redist_base, uint32_t cpu)
> +{
> +	/* Align all the redistributors sequentially */
> +	return redist_base + cpu * SZ_64K * 2;
> +}
> +
> +static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
> +{
> +	void *sgi_base;
> +	unsigned int i;
> +	void *redist_base_cpu;
> +
> +	GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
> +
> +	redist_base_cpu = gicr_base_gpa_cpu(redist_base, cpu);
> +	sgi_base = sgi_base_from_redist(redist_base_cpu);
> +
> +	gicv3_enable_redist(redist_base_cpu);
> +
> +	/*
> +	 * Mark all the SGI and PPI interrupts as non-secure Group-1.
> +	 * Also, deactivate and disable them.
> +	 */
> +	writel(~0, sgi_base + GICR_IGROUPR0);
> +	writel(~0, sgi_base + GICR_ICACTIVER0);
> +	writel(~0, sgi_base + GICR_ICENABLER0);
> +
> +	/* Set a default priority for all the SGIs and PPIs */
> +	for (i = 0; i < 32; i += 4)
> +		writel(GICD_INT_DEF_PRI_X4,
> +				sgi_base + GICR_IPRIORITYR0 + i);
> +
> +	gicv3_gicr_wait_for_rwp(redist_base_cpu);
> +
> +	/* Enable the GIC system register (ICC_*) access */
> +	write_sysreg_s(SYS_ICC_SRE_EL1,
> +			read_sysreg_s(SYS_ICC_SRE_EL1) | ICC_SRE_EL1_SRE);
> +
> +	/* Set a default priority threshold */
> +	write_sysreg_s(SYS_ICC_PMR_EL1, ICC_PMR_DEF_PRIO);
> +
> +	/* Enable non-secure Group-1 interrupts */
> +	write_sysreg_s(SYS_ICC_GRPEN1_EL1, ICC_IGRPEN1_EL1_ENABLE);
> +
> +	gicv3_data.redist_base[cpu] = redist_base_cpu;
> +}
> +
> +static void gicv3_dist_init(void)
> +{
> +	void *dist_base = gicv3_data.dist_base;
> +	unsigned int i;
> +
> +	/* Disable the distributor until we set things up */
> +	writel(0, dist_base + GICD_CTLR);
> +	gicv3_gicd_wait_for_rwp();
> +
> +	/*
> +	 * Mark all the SPI interrupts as non-secure Group-1.
> +	 * Also, deactivate and disable them.
> +	 */
> +	for (i = 32; i < gicv3_data.nr_spis; i += 32) {
> +		writel(~0, dist_base + GICD_IGROUPR + i / 8);
> +		writel(~0, dist_base + GICD_ICACTIVER + i / 8);
> +		writel(~0, dist_base + GICD_ICENABLER + i / 8);
> +	}
> +
> +	/* Set a default priority for all the SPIs */
> +	for (i = 32; i < gicv3_data.nr_spis; i += 4)
> +		writel(GICD_INT_DEF_PRI_X4,
> +				dist_base + GICD_IPRIORITYR + i);
> +
> +	/* Wait for the settings to sync-in */
> +	gicv3_gicd_wait_for_rwp();
> +
> +	/* Finally, enable the distributor globally with ARE */
> +	writel(GICD_CTLR_ARE_NS | GICD_CTLR_ENABLE_G1A |
> +			GICD_CTLR_ENABLE_G1, dist_base + GICD_CTLR);
> +	gicv3_gicd_wait_for_rwp();
> +}
> +
> +static void gicv3_init(unsigned int nr_cpus, void *dist_base)
> +{
> +	GUEST_ASSERT(nr_cpus <= GICV3_MAX_CPUS);
> +
> +	gicv3_data.nr_cpus = nr_cpus;
> +	gicv3_data.dist_base = dist_base;
> +	gicv3_data.nr_spis = GICD_TYPER_SPIS(
> +				readl(gicv3_data.dist_base + GICD_TYPER));
> +	if (gicv3_data.nr_spis > 1020)
> +		gicv3_data.nr_spis = 1020;
> +
> +	/*
> +	 * Initialize only the distributor for now.
> +	 * The redistributor and CPU interfaces are initialized
> +	 * later for every PE.
> +	 */
> +	gicv3_dist_init();
> +}
> +
> +const struct gic_common_ops gicv3_ops = {
> +	.gic_init = gicv3_init,
> +	.gic_cpu_init = gicv3_cpu_init,
> +	.gic_irq_enable = gicv3_irq_enable,
> +	.gic_irq_disable = gicv3_irq_disable,
> +	.gic_read_iar = gicv3_read_iar,
> +	.gic_write_eoir = gicv3_write_eoir,
> +};
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic_v3.h b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
> new file mode 100644
> index 000000000000..d41195e347b3
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic_v3.h
> @@ -0,0 +1,70 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * ARM Generic Interrupt Controller (GIC) v3 specific defines
> + */
> +
> +#ifndef SELFTEST_KVM_GICV3_H
> +#define SELFTEST_KVM_GICV3_H
> +
> +#include "processor.h"
> +
> +/*
> + * Distributor registers
> + */
> +#define GICD_CTLR			0x0000
> +#define GICD_TYPER			0x0004
> +#define GICD_IGROUPR			0x0080
> +#define GICD_ISENABLER			0x0100
> +#define GICD_ICENABLER			0x0180
> +#define GICD_ICACTIVER			0x0380
> +#define GICD_IPRIORITYR			0x0400
> +
> +/*
> + * The assumption is that the guest runs in a non-secure mode.
> + * The following bits of GICD_CTLR are defined accordingly.
> + */
> +#define GICD_CTLR_RWP			(1U << 31)
> +#define GICD_CTLR_nASSGIreq		(1U << 8)
> +#define GICD_CTLR_ARE_NS		(1U << 4)
> +#define GICD_CTLR_ENABLE_G1A		(1U << 1)
> +#define GICD_CTLR_ENABLE_G1		(1U << 0)
> +
> +#define GICD_TYPER_SPIS(typer)		((((typer) & 0x1f) + 1) * 32)
> +#define GICD_INT_DEF_PRI_X4		0xa0a0a0a0
> +
> +/*
> + * Redistributor registers
> + */
> +#define GICR_CTLR			0x000
> +#define GICR_WAKER			0x014
> +
> +#define GICR_CTLR_RWP			(1U << 3)
> +
> +#define GICR_WAKER_ProcessorSleep	(1U << 1)
> +#define GICR_WAKER_ChildrenAsleep	(1U << 2)
> +
> +/*
> + * Redistributor registers, offsets from SGI base
> + */
> +#define GICR_IGROUPR0			GICD_IGROUPR
> +#define GICR_ISENABLER0			GICD_ISENABLER
> +#define GICR_ICENABLER0			GICD_ICENABLER
> +#define GICR_ICACTIVER0			GICD_ICACTIVER
> +#define GICR_IPRIORITYR0		GICD_IPRIORITYR
> +
> +/* CPU interface registers */
> +#define SYS_ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
> +#define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
> +#define SYS_ICC_EOIR1_EL1		sys_reg(3, 0, 12, 12, 1)
> +#define SYS_ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
> +#define SYS_ICC_GRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
> +
> +#define ICC_PMR_DEF_PRIO		0xf0
> +
> +#define ICC_SRE_EL1_SRE			(1U << 0)
> +
> +#define ICC_IGRPEN1_EL1_ENABLE		(1U << 0)
> +
> +#define GICV3_MAX_CPUS			512
> +
> +#endif /* SELFTEST_KVM_GICV3_H */
> -- 
> 2.33.0.153.gba50c8fa24-goog
>

Looks good to me. I also see some nice stuff to bring over to
kvm-unit-tests in order to make some improvements there.

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew

