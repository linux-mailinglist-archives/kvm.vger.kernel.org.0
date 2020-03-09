Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EDD217DE96
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 12:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgCILTo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 07:19:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26324 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725796AbgCILTo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 07:19:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583752781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WPKjGxI/CtV5UF01rT9bf4zv9EkxXcn090JrU41bD2w=;
        b=N77NGiYEuCNi4BBXUAxvsPOjUUOK+yAUdZ/wucVjaDfcnhGgQtLVx5i7aW5LcZy13gwLR/
        JzcbSpuv3wSD+yLRCpHE2hTnUMCcHiI1SVwb1Nfl9wQDeMwtkjDfW80ee5vcnCjcohEg2U
        968FwEaAtSvAhc70JgNPTHoAnhHnAiM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-m-BswTOyPOKtbJ01kwn-bQ-1; Mon, 09 Mar 2020 07:19:40 -0400
X-MC-Unique: m-BswTOyPOKtbJ01kwn-bQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45F30801E5C;
        Mon,  9 Mar 2020 11:19:38 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DDC1C1001925;
        Mon,  9 Mar 2020 11:19:32 +0000 (UTC)
Date:   Mon, 9 Mar 2020 12:19:30 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 06/13] arm/arm64: ITS: Introspection
 tests
Message-ID: <20200309111930.zj6e4yzpzehcdr7e@kamzik.brq.redhat.com>
References: <20200309102420.24498-1-eric.auger@redhat.com>
 <20200309102420.24498-7-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309102420.24498-7-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 11:24:13AM +0100, Eric Auger wrote:
> Detect the presence of an ITS as part of the GICv3 init
> routine, initialize its base address and read few registers
> the IIDR, the TYPER to store its dimensioning parameters.
> Parse the BASER registers. As part of the init sequence we
> also init all the requested tables.
> 
> This is our first ITS test, belonging to a new "its" group.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v3 -> v4:
> - fixed some typos, refine trace msgs
> - move its files to lib/arm64 instead of lib/arm
> - create lib/arm/asm/gic-v3-its.h containing stubs
> - rework gic_get_dt_bases
> - rework baser parsing
> - move table allocation to init routine
> - use get_order()
> 
> v2 -> v3:
> - updated dates and changed author
> - squash "arm/arm64: ITS: Test BASER" into this patch but
>   removes setup_baser which will be introduced later.
> - only compile on aarch64
> - restrict the new test to aarch64
> 
> v1 -> v2:
> - clean GITS_TYPER macros and unused fields in typer struct
> - remove memory attribute related macros
> - remove everything related to memory attributes
> - s/dev_baser/coll_baser/ in report_info
> - add extra line
> - removed index filed in its_baser
> ---
>  arm/Makefile.arm64         |   1 +
>  arm/gic.c                  |  44 ++++++++++++++++
>  arm/unittests.cfg          |   7 +++
>  lib/arm/asm/gic-v3-its.h   |  23 +++++++++
>  lib/arm/gic.c              |  34 +++++++++++--
>  lib/arm64/asm/gic-v3-its.h |  92 +++++++++++++++++++++++++++++++++
>  lib/arm64/gic-v3-its.c     | 102 +++++++++++++++++++++++++++++++++++++
>  7 files changed, 298 insertions(+), 5 deletions(-)
>  create mode 100644 lib/arm/asm/gic-v3-its.h
>  create mode 100644 lib/arm64/asm/gic-v3-its.h
>  create mode 100644 lib/arm64/gic-v3-its.c
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 6d3dc2c..60182ae 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -19,6 +19,7 @@ endef
>  cstart.o = $(TEST_DIR)/cstart64.o
>  cflatobjs += lib/arm64/processor.o
>  cflatobjs += lib/arm64/spinlock.o
> +cflatobjs += lib/arm64/gic-v3-its.o
>  
>  OBJDIRS += lib/arm64
>  
> diff --git a/arm/gic.c b/arm/gic.c
> index abf08c7..67989f6 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -16,6 +16,7 @@
>  #include <asm/processor.h>
>  #include <asm/delay.h>
>  #include <asm/gic.h>
> +#include <asm/gic-v3-its.h>
>  #include <asm/smp.h>
>  #include <asm/barrier.h>
>  #include <asm/io.h>
> @@ -518,6 +519,45 @@ static void gic_test_mmio(void)
>  		test_targets(nr_irqs);
>  }
>  
> +#if defined(__aarch64__)
> +
> +static void test_its_introspection(void)
> +{
> +	struct its_baser *dev_baser = &its_data.device_baser;
> +	struct its_baser *coll_baser = &its_data.coll_baser;
> +	struct its_typer *typer = &its_data.typer;
> +
> +	if (!gicv3_its_base()) {
> +		report_skip("No ITS, skip ...");
> +		return;
> +	}
> +
> +	/* IIDR */
> +	report(test_readonly_32(gicv3_its_base() + GITS_IIDR, false),
> +	       "GITS_IIDR is read-only"),
> +
> +	/* TYPER */
> +	report(test_readonly_32(gicv3_its_base() + GITS_TYPER, false),
> +	       "GITS_TYPER is read-only");
> +
> +	report(typer->phys_lpi, "ITS supports physical LPIs");
> +	report_info("vLPI support: %s", typer->virt_lpi ? "yes" : "no");
> +	report_info("ITT entry size = 0x%x", typer->ite_size);
> +	report_info("Bit Count: EventID=%d DeviceId=%d CollId=%d",
> +		    typer->eventid_bits, typer->deviceid_bits,
> +		    typer->collid_bits);
> +	report(typer->eventid_bits && typer->deviceid_bits &&
> +	       typer->collid_bits, "ID spaces");
> +	report_info("Target address format %s",
> +			typer->pta ? "Redist base address" : "PE #");
> +
> +	report(dev_baser && coll_baser, "detect device and collection BASER");
> +	report_info("device table entry_size = 0x%x", dev_baser->esz);
> +	report_info("collection table entry_size = 0x%x", coll_baser->esz);
> +}
> +
> +#endif
> +
>  int main(int argc, char **argv)
>  {
>  	if (!gic_init()) {
> @@ -549,6 +589,10 @@ int main(int argc, char **argv)
>  		report_prefix_push(argv[1]);
>  		gic_test_mmio();
>  		report_prefix_pop();
> +	} else if (strcmp(argv[1], "its-introspection") == 0) {
> +		report_prefix_push(argv[1]);
> +		test_its_introspection();
> +		report_prefix_pop();
>  	} else {
>  		report_abort("Unknown subtest '%s'", argv[1]);
>  	}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 017958d..23d378e 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -122,6 +122,13 @@ smp = $MAX_SMP
>  extra_params = -machine gic-version=3 -append 'active'
>  groups = gic
>  
> +[its-introspection]
> +file = gic.flat
> +smp = $MAX_SMP
> +extra_params = -machine gic-version=3 -append 'its-introspection'
> +groups = its
> +arch = arm64
> +
>  # Test PSCI emulation
>  [psci]
>  file = psci.flat
> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
> new file mode 100644
> index 0000000..0096de6
> --- /dev/null
> +++ b/lib/arm/asm/gic-v3-its.h
> @@ -0,0 +1,23 @@
> +/*
> + * ITS 32-bit stubs
> + *
> + * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +
> +#ifndef _ASMARM_GICv3_ITS
> +#define _ASMARM_GICv3_ITS
> +
> +/* dummy its_data struct to allow gic_get_dt_bases() call */
> +struct its_data {
> +	void *base;
> +};
> +
> +static inline void its_init(void) {}
> +static inline void test_its_introspection(void)
> +{
> +	report_abort("not supported on 32-bit");

I suggested report_abort() in this function when it was in arm/gic.c,
but we don't want report_* functions in the library code, nor do we
want functions named test_*. This test_* stub should go back to
arm/gic.c, where it can be empty, because the 32-bit its_init() stub
here could get an assert_msg("not supported on 32-bit") instead.

> +}
> +
> +#endif /* _ASMARM_GICv3_ITS */
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index c3c5f6b..4f6f15b 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -6,9 +6,11 @@
>  #include <devicetree.h>
>  #include <asm/gic.h>
>  #include <asm/io.h>
> +#include <asm/gic-v3-its.h>
>  
>  struct gicv2_data gicv2_data;
>  struct gicv3_data gicv3_data;
> +struct its_data its_data;
>  
>  struct gic_common_ops {
>  	void (*enable_defaults)(void);
> @@ -44,12 +46,13 @@ static const struct gic_common_ops gicv3_common_ops = {
>   * Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.txt
>   */
>  static bool
> -gic_get_dt_bases(const char *compatible, void **base1, void **base2)
> +gic_get_dt_bases(const char *compatible, void **base1, void **base2, void **base3)
>  {
>  	struct dt_pbus_reg reg;
> -	struct dt_device gic;
> +	struct dt_device gic, its;
>  	struct dt_bus bus;
> -	int node, ret, i;
> +	int node, subnode, ret, i, len;
> +	const void *fdt = dt_fdt();
>  
>  	dt_bus_init_defaults(&bus);
>  	dt_device_init(&gic, &bus, NULL);
> @@ -74,19 +77,39 @@ gic_get_dt_bases(const char *compatible, void **base1, void **base2)
>  		base2[i] = ioremap(reg.addr, reg.size);
>  	}
>  
> +	if (!base3) {
> +		assert(!strcmp(compatible, "arm,cortex-a15-gic"));
> +		return true;
> +	}
> +
> +	assert(!strcmp(compatible, "arm,gic-v3"));
> +
> +	dt_for_each_subnode(node, subnode) {
> +		const struct fdt_property *prop;
> +
> +		prop = fdt_get_property(fdt, subnode, "compatible", &len);
> +		if (!strcmp((char *)prop->data, "arm,gic-v3-its")) {
> +			dt_device_bind_node(&its, subnode);
> +			ret = dt_pbus_translate(&its, 0, &reg);
> +			assert(ret == 0);
> +			*base3 = ioremap(reg.addr, reg.size);
> +			break;
> +		}
> +	}
> +
>  	return true;
>  }
>  
>  int gicv2_init(void)
>  {
>  	return gic_get_dt_bases("arm,cortex-a15-gic",
> -			&gicv2_data.dist_base, &gicv2_data.cpu_base);
> +			&gicv2_data.dist_base, &gicv2_data.cpu_base, NULL);
>  }
>  
>  int gicv3_init(void)
>  {
>  	return gic_get_dt_bases("arm,gic-v3", &gicv3_data.dist_base,
> -			&gicv3_data.redist_bases[0]);
> +			&gicv3_data.redist_bases[0], &its_data.base);
>  }
>  
>  int gic_version(void)
> @@ -104,6 +127,7 @@ int gic_init(void)
>  		gic_common_ops = &gicv2_common_ops;
>  	else if (gicv3_init())
>  		gic_common_ops = &gicv3_common_ops;
> +	its_init();
>  	return gic_version();
>  }
>  
> diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
> new file mode 100644
> index 0000000..331ba0e
> --- /dev/null
> +++ b/lib/arm64/asm/gic-v3-its.h
> @@ -0,0 +1,92 @@
> +/*
> + * All ITS* defines are lifted from include/linux/irqchip/arm-gic-v3.h
> + *
> + * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#ifndef _ASMARM64_GIC_V3_ITS_H_
> +#define _ASMARM64_GIC_V3_ITS_H_
> +
> +struct its_typer {
> +	unsigned int ite_size;
> +	unsigned int eventid_bits;
> +	unsigned int deviceid_bits;
> +	unsigned int collid_bits;
> +	bool pta;
> +	bool phys_lpi;
> +	bool virt_lpi;
> +};
> +
> +struct its_baser {
> +	int index;
> +	size_t psz;
> +	int esz;
> +	bool indirect;
> +	phys_addr_t table_addr;
> +};
> +
> +#define GITS_BASER_NR_REGS              8
> +
> +struct its_data {
> +	void *base;
> +	struct its_typer typer;
> +	struct its_baser device_baser;
> +	struct its_baser coll_baser;
> +	struct its_cmd_block *cmd_base;
> +	struct its_cmd_block *cmd_write;
> +};
> +
> +extern struct its_data its_data;
> +
> +#define gicv3_its_base()		(its_data.base)
> +
> +#define GITS_CTLR			0x0000
> +#define GITS_IIDR			0x0004
> +#define GITS_TYPER			0x0008
> +#define GITS_CBASER			0x0080
> +#define GITS_CWRITER			0x0088
> +#define GITS_CREADR			0x0090
> +#define GITS_BASER			0x0100
> +
> +#define GITS_TYPER_PLPIS                BIT(0)
> +#define GITS_TYPER_VLPIS		BIT(1)
> +#define GITS_TYPER_ITT_ENTRY_SIZE	GENMASK_ULL(7, 4)
> +#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
> +#define GITS_TYPER_IDBITS		GENMASK_ULL(8, 12)
> +#define GITS_TYPER_IDBITS_SHIFT         8
> +#define GITS_TYPER_DEVBITS		GENMASK_ULL(13, 17)
> +#define GITS_TYPER_DEVBITS_SHIFT        13
> +#define GITS_TYPER_PTA                  BIT(19)
> +#define GITS_TYPER_CIDBITS		GENMASK_ULL(32, 35)
> +#define GITS_TYPER_CIDBITS_SHIFT	32
> +#define GITS_TYPER_CIL			BIT(36)
> +
> +#define GITS_CTLR_ENABLE		(1U << 0)
> +
> +#define GITS_CBASER_VALID		(1UL << 63)
> +
> +#define GITS_BASER_VALID		BIT(63)
> +#define GITS_BASER_INDIRECT		BIT(62)
> +#define GITS_BASER_TYPE_SHIFT		(56)
> +#define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
> +#define GITS_BASER_ENTRY_SIZE_SHIFT	(48)
> +#define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0x1f) + 1)
> +#define GITS_BASER_PAGE_SIZE_SHIFT	(8)
> +#define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +#define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +#define GITS_BASER_PAGE_SIZE_64K	(2UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +#define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
> +#define GITS_BASER_PAGES_MAX		256
> +#define GITS_BASER_PAGES_SHIFT		(0)
> +#define GITS_BASER_NR_PAGES(r)		(((r) & 0xff) + 1)
> +#define GITS_BASER_PHYS_ADDR_MASK	0xFFFFFFFFF000
> +#define GITS_BASER_TYPE_NONE		0
> +#define GITS_BASER_TYPE_DEVICE		1
> +#define GITS_BASER_TYPE_COLLECTION	4
> +
> +extern void its_parse_typer(void);
> +extern void its_init(void);
> +extern int its_baser_lookup(int i, struct its_baser *baser);
> +
> +#endif /* _ASMARM64_GIC_V3_ITS_H_ */
> diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
> new file mode 100644
> index 0000000..23b0d06
> --- /dev/null
> +++ b/lib/arm64/gic-v3-its.c
> @@ -0,0 +1,102 @@
> +/*
> + * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include <asm/gic.h>
> +#include <alloc_page.h>
> +#include <asm/gic-v3-its.h>
> +
> +void its_parse_typer(void)
> +{
> +	u64 typer = readq(gicv3_its_base() + GITS_TYPER);
> +	struct its_typer *t = &its_data.typer;
> +
> +	t->ite_size = ((typer & GITS_TYPER_ITT_ENTRY_SIZE) >> GITS_TYPER_ITT_ENTRY_SIZE_SHIFT) + 1;
> +	t->pta = typer & GITS_TYPER_PTA;
> +	t->eventid_bits = ((typer & GITS_TYPER_IDBITS) >> GITS_TYPER_IDBITS_SHIFT) + 1;
> +	t->deviceid_bits = ((typer & GITS_TYPER_DEVBITS) >> GITS_TYPER_DEVBITS_SHIFT) + 1;
> +
> +	if (typer & GITS_TYPER_CIL)
> +		t->collid_bits = ((typer & GITS_TYPER_CIDBITS) >> GITS_TYPER_CIDBITS_SHIFT) + 1;
> +	else
> +		t->collid_bits = 16;
> +
> +	t->virt_lpi = typer & GITS_TYPER_VLPIS;
> +	t->phys_lpi = typer & GITS_TYPER_PLPIS;
> +}
> +
> +int its_baser_lookup(int type, struct its_baser *baser)
> +{
> +	int i;
> +
> +	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
> +		void *reg_addr = gicv3_its_base() + GITS_BASER + i * 8;
> +		u64 val = readq(reg_addr);
> +
> +		if (GITS_BASER_TYPE(val) == type) {
> +			assert((val & GITS_BASER_PAGE_SIZE_MASK) == GITS_BASER_PAGE_SIZE_64K);
> +			baser->esz = GITS_BASER_ENTRY_SIZE(val);
> +			baser->indirect = val & GITS_BASER_INDIRECT;
> +			baser->index = i;
> +			return 0;
> +		}
> +	}
> +	return -1;
> +}
> +
> +/*
> + * Allocate the BASER table (a single page of size @baser->psz)
> + * and set the BASER valid
> + */
> +static void its_baser_alloc_table(struct its_baser *baser, size_t size)
> +{
> +	unsigned long order = get_order(size >> PAGE_SHIFT);
> +	void *reg_addr = gicv3_its_base() + GITS_BASER + baser->index * 8;
> +	u64 val = readq(reg_addr);
> +
> +	baser->table_addr = (u64)virt_to_phys(alloc_pages(order));
> +
> +	val |= (u64)baser->table_addr | GITS_BASER_VALID;
> +
> +	writeq(val, reg_addr);
> +}
> +
> +/**

nit: this isn't a kernel-doc comment, one * is enough

> + * init_cmd_queue - Allocate the command queue and initialize
> + * CBASER, CWRITER
> + */
> +static void its_cmd_queue_init(void)
> +{
> +	unsigned long order = get_order(SZ_64K >> PAGE_SHIFT);
> +	u64 cbaser;
> +
> +	its_data.cmd_base = (void *)virt_to_phys(alloc_pages(order));
> +
> +	cbaser = ((u64)its_data.cmd_base | (SZ_64K / SZ_4K - 1)	| GITS_CBASER_VALID);
> +
> +	writeq(cbaser, its_data.base + GITS_CBASER);
> +
> +	its_data.cmd_write = its_data.cmd_base;
> +	writeq(0, its_data.base + GITS_CWRITER);
> +}
> +
> +void its_init(void)
> +{
> +	if (!its_data.base)
> +		return;
> +
> +	its_parse_typer();
> +
> +	assert(!its_baser_lookup(GITS_BASER_TYPE_DEVICE, &its_data.device_baser));
> +	assert(!its_baser_lookup(GITS_BASER_TYPE_COLLECTION, &its_data.coll_baser));
> +
> +	its_baser_alloc_table(&its_data.device_baser, SZ_64K);
> +	its_baser_alloc_table(&its_data.coll_baser, SZ_64K);
> +
> +	/* Allocate LPI config and pending tables */
> +	gicv3_lpi_alloc_tables();
> +
> +	its_cmd_queue_init();
> +}
> +
> -- 
> 2.20.1
>

Thanks,
drew 

