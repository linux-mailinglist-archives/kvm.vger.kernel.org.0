Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD5E17922A
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 15:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgCDOUW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 09:20:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42421 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726378AbgCDOUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 09:20:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583331618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O9cK3xOpdu++hW3Y/B8M7MnCCGdgIWU1gpzRxbc+Hjc=;
        b=KP9y8WYHL9sHe08YGbjfKrIbBpKHd9jzkxMAF4W1aOCl5IJ0m3O97MKTxMIBhQy5t6hFkY
        YqoyMoALx8JJEJk/NWeNvGdDOHlYS9q+gDqyWuvLMv4dm6eRyGrHs8u94Udv4nM8UAYUpZ
        bTL2jBMIfcSp+cbgV7DQGccPCLR6Ges=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-367-gfG6CgjmOzOE8QDuZiK4og-1; Wed, 04 Mar 2020 09:20:15 -0500
X-MC-Unique: gfG6CgjmOzOE8QDuZiK4og-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDF81800D50;
        Wed,  4 Mar 2020 14:20:12 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C5975D9C9;
        Wed,  4 Mar 2020 14:20:08 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 05/14] arm/arm64: ITS: Introspection
 tests
To:     Andrew Jones <drjones@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-6-eric.auger@redhat.com>
 <20200207101943.fuakoieafbroe7rw@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0ba4b3ec-dde3-8af9-6bb8-6aa88c208b03@redhat.com>
Date:   Wed, 4 Mar 2020 15:20:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200207101943.fuakoieafbroe7rw@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,
On 2/7/20 11:19 AM, Andrew Jones wrote:
> On Tue, Jan 28, 2020 at 11:34:50AM +0100, Eric Auger wrote:
>> Detect the presence of an ITS as part of the GICv3 init
>> routine, initialize its base address and read few registers
>> the IIDR, the TYPER to store its dimensioning parameters.
>> Also parse the BASER registers.
>>
>> This is our first ITS test, belonging to a new "its" group.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v2 -> v3:
>> - updated dates and changed author
>> - squash "arm/arm64: ITS: Test BASER" into this patch but
>>   removes setup_baser which will be introduced later.
>> - only compile on aarch64
>> - restrict the new test to aarch64
>>
>> v1 -> v2:
>> - clean GITS_TYPER macros and unused fields in typer struct
>> - remove memory attribute related macros
>> - remove everything related to memory attributes
>> - s/dev_baser/coll_baser/ in report_info
>> - add extra line
>> - removed index filed in its_baser
>> ---
>>  arm/Makefile.arm64         |   1 +
>>  arm/gic.c                  |  49 ++++++++++++++++++
>>  arm/unittests.cfg          |   7 +++
>>  lib/arm/asm/gic-v3-its.h   | 103 +++++++++++++++++++++++++++++++++++++
>>  lib/arm/gic-v3-its.c       |  88 +++++++++++++++++++++++++++++++
>>  lib/arm/gic.c              |  30 +++++++++--
>>  lib/arm64/asm/gic-v3-its.h |   1 +
>>  7 files changed, 274 insertions(+), 5 deletions(-)
>>  create mode 100644 lib/arm/asm/gic-v3-its.h
>>  create mode 100644 lib/arm/gic-v3-its.c
>>  create mode 100644 lib/arm64/asm/gic-v3-its.h
>>
>> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
>> index 6d3dc2c..2571ffb 100644
>> --- a/arm/Makefile.arm64
>> +++ b/arm/Makefile.arm64
>> @@ -19,6 +19,7 @@ endef
>>  cstart.o = $(TEST_DIR)/cstart64.o
>>  cflatobjs += lib/arm64/processor.o
>>  cflatobjs += lib/arm64/spinlock.o
>> +cflatobjs += lib/arm/gic-v3-its.o
> 
> If gic-v3-its.c will never be compiled for arm, then it should
> probably go lib/arm64, not lib/arm. Same comment for all other
> new source and header files. The only problem with that is...>
>>  
>>  OBJDIRS += lib/arm64
>>  
>> diff --git a/arm/gic.c b/arm/gic.c
>> index abf08c7..4d7dd03 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -16,6 +16,7 @@
>>  #include <asm/processor.h>
>>  #include <asm/delay.h>
>>  #include <asm/gic.h>
>> +#include <asm/gic-v3-its.h>
> 
> ...here where we'd have to do
> 
>  #if defined(__aarch64__)
>  #include <asm/gic-v3-its.h>
>  #endif
> 
> which is ugly. However that can be avoided by adding an
> empty lib/arm/asm/gic-v3-its.h file.
OK made those changes with this latter containing stubs.
> 
> 
>>  #include <asm/smp.h>
>>  #include <asm/barrier.h>
>>  #include <asm/io.h>
>> @@ -518,6 +519,50 @@ static void gic_test_mmio(void)
>>  		test_targets(nr_irqs);
>>  }
>>  
>> +#if defined(__arm__)
>> +
>> +static void test_its_introspection(void) {}
> 
>  static void test_its_introspection(void)
>  {
>      report_abort(...);
>  }
OK
> 
>> +
>> +#else /* __arch64__ */
>> +
>> +static void test_its_introspection(void)
>> +{
>> +	struct its_baser *dev_baser, *coll_baser;
>> +	struct its_typer *typer = &its_data.typer;
>> +
>> +	if (!gicv3_its_base()) {
>> +		report_skip("No ITS, skip ...");
>> +		return;
>> +	}
>> +
>> +	/* IIDR */
>> +	report(test_readonly_32(gicv3_its_base() + GITS_IIDR, false),
>> +	       "GITS_IIDR is read-only"),
>> +
>> +	/* TYPER */
>> +	report(test_readonly_32(gicv3_its_base() + GITS_TYPER, false),
>> +	       "GITS_TYPER is read-only");
>> +
>> +	report(typer->phys_lpi, "ITS supports physical LPIs");
>> +	report_info("vLPI support: %s", typer->virt_lpi ? "yes" : "no");
>> +	report_info("ITT entry size = 0x%x", typer->ite_size);
>> +	report_info("Bit Count: EventID=%d DeviceId=%d CollId=%d",
>> +		    typer->eventid_bits, typer->deviceid_bits,
>> +		    typer->collid_bits);
>> +	report(typer->eventid_bits && typer->deviceid_bits &&
>> +	       typer->collid_bits, "ID spaces");
>> +	report_info("Target address format %s",
>> +			typer->pta ? "Redist basse address" : "PE #");
>> +
>> +	dev_baser = its_lookup_baser(GITS_BASER_TYPE_DEVICE);
>> +	coll_baser = its_lookup_baser(GITS_BASER_TYPE_COLLECTION);
>> +	report(dev_baser && coll_baser, "detect device and collection BASER");
>> +	report_info("device baser entry_size = 0x%x", dev_baser->esz);
>> +	report_info("collection baser entry_size = 0x%x", coll_baser->esz);
>> +}
>> +
>> +#endif
>> +
>>  int main(int argc, char **argv)
>>  {
>>  	if (!gic_init()) {
>> @@ -549,6 +594,10 @@ int main(int argc, char **argv)
>>  		report_prefix_push(argv[1]);
>>  		gic_test_mmio();
>>  		report_prefix_pop();
>> +	} else if (strcmp(argv[1], "its-introspection") == 0) {
>> +		report_prefix_push(argv[1]);
>> +		test_its_introspection();
>> +		report_prefix_pop();
>>  	} else {
>>  		report_abort("Unknown subtest '%s'", argv[1]);
>>  	}
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index daeb5a0..ba2b31b 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -122,6 +122,13 @@ smp = $MAX_SMP
>>  extra_params = -machine gic-version=3 -append 'active'
>>  groups = gic
>>  
>> +[its-introspection]
>> +file = gic.flat
>> +smp = $MAX_SMP
>> +extra_params = -machine gic-version=3 -append 'its-introspection'
>> +groups = its
>> +arch = arm64
>> +
>>  # Test PSCI emulation
>>  [psci]
>>  file = psci.flat
>> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
>> new file mode 100644
>> index 0000000..815c515
>> --- /dev/null
>> +++ b/lib/arm/asm/gic-v3-its.h
>> @@ -0,0 +1,103 @@
>> +/*
>> + * All ITS* defines are lifted from include/linux/irqchip/arm-gic-v3.h
>> + *
>> + * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
>> + *
>> + * This work is licensed under the terms of the GNU LGPL, version 2.
>> + */
>> +#ifndef _ASMARM_GIC_V3_ITS_H_
>> +#define _ASMARM_GIC_V3_ITS_H_
>> +
>> +#ifndef __ASSEMBLY__
> 
> Doesn't look like you use the #else /* __ASSEMBLY__ */ side of this.
> I'd leave out the #ifndef until we add defines we need to access
> from assembler.
OK
> 
>> +
>> +struct its_typer {
>> +	unsigned int ite_size;
>> +	unsigned int eventid_bits;
>> +	unsigned int deviceid_bits;
>> +	unsigned int collid_bits;
>> +	bool pta;
>> +	bool phys_lpi;
>> +	bool virt_lpi;
>> +};
>> +
>> +struct its_baser {
>> +	int type;
>> +	size_t psz;
>> +	int nr_pages;
>> +	bool indirect;
>> +	phys_addr_t table_addr;
>> +	bool valid;
>> +	int esz;
>> +};
>> +
>> +#define GITS_BASER_NR_REGS              8
>> +
>> +struct its_data {
>> +	void *base;
>> +	struct its_typer typer;
>> +	struct its_baser baser[GITS_BASER_NR_REGS];
>> +};
>> +
>> +extern struct its_data its_data;
>> +
>> +#define gicv3_its_base()		(its_data.base)
>> +
>> +#if defined(__aarch64__)
>> +
>> +#define GITS_CTLR			0x0000
>> +#define GITS_IIDR			0x0004
>> +#define GITS_TYPER			0x0008
>> +#define GITS_CBASER			0x0080
>> +#define GITS_CWRITER			0x0088
>> +#define GITS_CREADR			0x0090
>> +#define GITS_BASER			0x0100
>> +
>> +#define GITS_TYPER_PLPIS                BIT(0)
>> +#define GITS_TYPER_VLPIS		BIT(1)
>> +#define GITS_TYPER_ITT_ENTRY_SIZE	GENMASK_ULL(7, 4)
>> +#define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
>> +#define GITS_TYPER_IDBITS		GENMASK_ULL(8, 12)
>> +#define GITS_TYPER_IDBITS_SHIFT         8
>> +#define GITS_TYPER_DEVBITS		GENMASK_ULL(13, 17)
>> +#define GITS_TYPER_DEVBITS_SHIFT        13
>> +#define GITS_TYPER_PTA                  BIT(19)
>> +#define GITS_TYPER_CIDBITS		GENMASK_ULL(32, 35)
>> +#define GITS_TYPER_CIDBITS_SHIFT	32
>> +#define GITS_TYPER_CIL			BIT(36)
>> +
>> +#define GITS_CTLR_ENABLE		(1U << 0)
>> +
>> +#define GITS_CBASER_VALID		(1UL << 63)
>> +
>> +#define GITS_BASER_VALID		BIT(63)
>> +#define GITS_BASER_INDIRECT		BIT(62)
>> +#define GITS_BASER_TYPE_SHIFT		(56)
>> +#define GITS_BASER_TYPE(r)		(((r) >> GITS_BASER_TYPE_SHIFT) & 7)
>> +#define GITS_BASER_ENTRY_SIZE_SHIFT	(48)
>> +#define GITS_BASER_ENTRY_SIZE(r)	((((r) >> GITS_BASER_ENTRY_SIZE_SHIFT) & 0x1f) + 1)
>> +#define GITS_BASER_PAGE_SIZE_SHIFT	(8)
>> +#define GITS_BASER_PAGE_SIZE_4K		(0UL << GITS_BASER_PAGE_SIZE_SHIFT)
>> +#define GITS_BASER_PAGE_SIZE_16K	(1UL << GITS_BASER_PAGE_SIZE_SHIFT)
>> +#define GITS_BASER_PAGE_SIZE_64K	(2UL << GITS_BASER_PAGE_SIZE_SHIFT)
>> +#define GITS_BASER_PAGE_SIZE_MASK	(3UL << GITS_BASER_PAGE_SIZE_SHIFT)
>> +#define GITS_BASER_PAGES_MAX		256
>> +#define GITS_BASER_PAGES_SHIFT		(0)
>> +#define GITS_BASER_NR_PAGES(r)		(((r) & 0xff) + 1)
>> +#define GITS_BASER_PHYS_ADDR_MASK	0xFFFFFFFFF000
>> +#define GITS_BASER_TYPE_NONE		0
>> +#define GITS_BASER_TYPE_DEVICE		1
>> +#define GITS_BASER_TYPE_COLLECTION	4
>> +
>> +extern void its_parse_typer(void);
>> +extern void its_init(void);
>> +extern int its_parse_baser(int i, struct its_baser *baser);
>> +extern struct its_baser *its_lookup_baser(int type);
>> +
>> +#else /* __arm__ */
>> +
>> +static inline void its_init(void) {}
> 
> Looks like the empty gic-v3-its.h I suggested creating above will actually
> be useful. We can add stubs like this in it.
OK
> 
>> +
>> +#endif
>> +
>> +#endif /* !__ASSEMBLY__ */
>> +#endif /* _ASMARM_GIC_V3_ITS_H_ */
>> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
>> new file mode 100644
>> index 0000000..2c0ce13
>> --- /dev/null
>> +++ b/lib/arm/gic-v3-its.c
>> @@ -0,0 +1,88 @@
>> +/*
>> + * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
>> + *
>> + * This work is licensed under the terms of the GNU LGPL, version 2.
>> + */
>> +#include <asm/gic.h>
>> +#include <alloc_page.h>
>> +#include <asm/gic-v3-its.h>
>> +
>> +void its_parse_typer(void)
>> +{
>> +	u64 typer = readq(gicv3_its_base() + GITS_TYPER);
>> +
>> +	its_data.typer.ite_size = ((typer & GITS_TYPER_ITT_ENTRY_SIZE) >>
>> +					GITS_TYPER_ITT_ENTRY_SIZE_SHIFT) + 1;
>> +	its_data.typer.pta = typer & GITS_TYPER_PTA;
>> +	its_data.typer.eventid_bits = ((typer & GITS_TYPER_IDBITS) >>
>> +						GITS_TYPER_IDBITS_SHIFT) + 1;
>> +	its_data.typer.deviceid_bits = ((typer & GITS_TYPER_DEVBITS) >>
>> +						GITS_TYPER_DEVBITS_SHIFT) + 1;
>> +
>> +	if (typer & GITS_TYPER_CIL)
>> +		its_data.typer.collid_bits = ((typer & GITS_TYPER_CIDBITS) >>
>> +						GITS_TYPER_CIDBITS_SHIFT) + 1;
> 
> nit: please consider aligning like this
> 
>  ((typer & MASK) >>
>   SHIFT) + 1;
> 
> Or, maybe better to macro it
> 
>  #define TYPER_FIELD(typer, mask, shift) (((type) & (mask) >> (shift)) + 1)
> 
> And, rather than have a bunch of 'its_data.typer's we could use an alias,
> helping us stay within 120 chars.
> 
>  struct its_typer *t = &its_data.typer;
yes used that trick and relied on 120 char max.
> 
>  t->ite_size = TYPER_FIELD(typer, GITS_TYPER_ITT_ENTRY_SIZE,
>                            GITS_TYPER_ITT_ENTRY_SIZE_SHIFT);
> 
> 
>> +	else
>> +		its_data.typer.collid_bits = 16;
>> +
>> +	its_data.typer.virt_lpi = typer & GITS_TYPER_VLPIS;
>> +	its_data.typer.phys_lpi = typer & GITS_TYPER_PLPIS;
>> +}
>> +
>> +int its_parse_baser(int i, struct its_baser *baser)
>> +{
>> +	void *reg_addr = gicv3_its_base() + GITS_BASER + i * 8;
>> +	u64 val = readq(reg_addr);
>> +
>> +	if (!val) {
>> +		memset(baser, 0, sizeof(*baser));
>> +		return -1;
>> +	}
>> +
>> +	baser->valid = val & GITS_BASER_VALID;
>> +	baser->indirect = val & GITS_BASER_INDIRECT;
>> +	baser->type = GITS_BASER_TYPE(val);
>> +	baser->esz = GITS_BASER_ENTRY_SIZE(val);
>> +	baser->nr_pages = GITS_BASER_NR_PAGES(val);
>> +	baser->table_addr = val & GITS_BASER_PHYS_ADDR_MASK;
>> +	switch (val & GITS_BASER_PAGE_SIZE_MASK) {
>> +	case GITS_BASER_PAGE_SIZE_4K:
>> +		baser->psz = SZ_4K;
>> +		break;
>> +	case GITS_BASER_PAGE_SIZE_16K:
>> +		baser->psz = SZ_16K;
>> +		break;
>> +	case GITS_BASER_PAGE_SIZE_64K:
>> +		baser->psz = SZ_64K;
>> +		break;
>> +	default:
>> +		baser->psz = SZ_64K;
>> +	}
>> +	return 0;
>> +}
>> +
>> +struct its_baser *its_lookup_baser(int type)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
>> +		struct its_baser *baser = &its_data.baser[i];
>> +
>> +		if (baser->type == type)
>> +			return baser;
>> +	}
>> +	return NULL;
>> +}
>> +
>> +void its_init(void)
>> +{
>> +	int i;
>> +
>> +	if (!its_data.base)
>> +		return;
>> +
>> +	its_parse_typer();
>> +	for (i = 0; i < GITS_BASER_NR_REGS; i++)
>> +		its_parse_baser(i, &its_data.baser[i]);
>> +}
>> +
>> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
>> index aa9cb86..6b70b05 100644
>> --- a/lib/arm/gic.c
>> +++ b/lib/arm/gic.c
>> @@ -6,9 +6,11 @@
>>  #include <devicetree.h>
>>  #include <asm/gic.h>
>>  #include <asm/io.h>
>> +#include <asm/gic-v3-its.h>
>>  
>>  struct gicv2_data gicv2_data;
>>  struct gicv3_data gicv3_data;
>> +struct its_data its_data;
>>  
>>  struct gic_common_ops {
>>  	void (*enable_defaults)(void);
>> @@ -44,12 +46,13 @@ static const struct gic_common_ops gicv3_common_ops = {
>>   * Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.txt
>>   */
>>  static bool
>> -gic_get_dt_bases(const char *compatible, void **base1, void **base2)
>> +gic_get_dt_bases(const char *compatible, void **base1, void **base2, void **base3)
>>  {
>>  	struct dt_pbus_reg reg;
>> -	struct dt_device gic;
>> +	struct dt_device gic, its;
>>  	struct dt_bus bus;
>> -	int node, ret, i;
>> +	int node, subnode, ret, i, len;
>> +	const void *fdt = dt_fdt();
>>  
>>  	dt_bus_init_defaults(&bus);
>>  	dt_device_init(&gic, &bus, NULL);
>> @@ -74,19 +77,35 @@ gic_get_dt_bases(const char *compatible, void **base1, void **base2)
>>  		base2[i] = ioremap(reg.addr, reg.size);
>>  	}
>>  
>> +	if (base3 && !strcmp(compatible, "arm,gic-v3")) {
> 
> If base != NULL, then we could assert(strcmp(compatible, "arm,cortex-a15-gic") != 0)
OK

Thanks

Eric
> 
>> +		dt_for_each_subnode(node, subnode) {
>> +			const struct fdt_property *prop;
>> +
>> +			prop = fdt_get_property(fdt, subnode, "compatible", &len);
>> +			if (!strcmp((char *)prop->data, "arm,gic-v3-its")) {
>> +				dt_device_bind_node(&its, subnode);
>> +				ret = dt_pbus_translate(&its, 0, &reg);
>> +				assert(ret == 0);
>> +				*base3 = ioremap(reg.addr, reg.size);
>> +				break;
>> +			}
>> +		}
>> +
>> +	}
>> +
>>  	return true;
>>  }
>>  
>>  int gicv2_init(void)
>>  {
>>  	return gic_get_dt_bases("arm,cortex-a15-gic",
>> -			&gicv2_data.dist_base, &gicv2_data.cpu_base);
>> +			&gicv2_data.dist_base, &gicv2_data.cpu_base, NULL);
>>  }
>>  
>>  int gicv3_init(void)
>>  {
>>  	return gic_get_dt_bases("arm,gic-v3", &gicv3_data.dist_base,
>> -			&gicv3_data.redist_bases[0]);
>> +			&gicv3_data.redist_bases[0], &its_data.base);
>>  }
>>  
>>  int gic_version(void)
>> @@ -104,6 +123,7 @@ int gic_init(void)
>>  		gic_common_ops = &gicv2_common_ops;
>>  	else if (gicv3_init())
>>  		gic_common_ops = &gicv3_common_ops;
>> +	its_init();
>>  	return gic_version();
>>  }
>>  
>> diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
>> new file mode 100644
>> index 0000000..083cba4
>> --- /dev/null
>> +++ b/lib/arm64/asm/gic-v3-its.h
>> @@ -0,0 +1 @@
>> +#include "../../arm/asm/gic-v3-its.h"
>> -- 
>> 2.20.1
>>
> 
> Thanks,
> drew 
> 

