Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EACE13CA7B
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 18:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgAORLg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 12:11:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22741 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728913AbgAORLf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 12:11:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579108293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jdHqp0aNEawkoBWthx8A+WT/ugmIboVw7An31zp1yZY=;
        b=TZuwIInNf33boP49RuPo92u63++oSwIRwsyQQdEWd9Vc6dl02fbPHMOx1Fm1TvFZvNYb+V
        gWyRMeAxt/9b6EnUdvAjFS8Ai4hTjuU6khN6k65rRtd3QqnLea34TQ1QTd3Qwys2Dka0Hl
        N3nFAvDQn+3haxv+qQpvUVsxB7RhmiY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-wybwbYP0OEKbo5suXphtGw-1; Wed, 15 Jan 2020 12:11:30 -0500
X-MC-Unique: wybwbYP0OEKbo5suXphtGw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2103A183B55B;
        Wed, 15 Jan 2020 17:11:28 +0000 (UTC)
Received: from [10.36.117.108] (ovpn-117-108.ams2.redhat.com [10.36.117.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E6DD98886D;
        Wed, 15 Jan 2020 17:11:24 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 13/16] arm/arm64: ITS: INT functional
 tests
To:     Andrew Jones <drjones@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
References: <20200110145412.14937-1-eric.auger@redhat.com>
 <20200110145412.14937-14-eric.auger@redhat.com>
 <20200113181701.jit3ywxoifduipew@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <1c046216-b873-a4c1-4a7a-374f10947d59@redhat.com>
Date:   Wed, 15 Jan 2020 18:11:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200113181701.jit3ywxoifduipew@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 1/13/20 7:17 PM, Andrew Jones wrote:
> On Fri, Jan 10, 2020 at 03:54:09PM +0100, Eric Auger wrote:
>> Triggers LPIs through the INT command.
>>
>> the test checks the LPI hits the right CPU and triggers
>> the right LPI intid, ie. the translation is correct.
>>
>> Updates to the config table also are tested, along with inv
>> and invall commands.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arm/gic.c                | 174 +++++++++++++++++++++++++++++++++++++++
>>  arm/unittests.cfg        |   6 ++
>>  lib/arm/asm/gic-v3-its.h |  14 ++++
>>  3 files changed, 194 insertions(+)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index 3597ac3..7f701a1 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -34,6 +34,7 @@ static struct gic *gic;
>>  static int acked[NR_CPUS], spurious[NR_CPUS];
>>  static int bad_sender[NR_CPUS], bad_irq[NR_CPUS];
>>  static cpumask_t ready;
>> +static struct its_stats lpi_stats;
>>  
>>  static void nr_cpu_check(int nr)
>>  {
>> @@ -158,6 +159,54 @@ static void ipi_handler(struct pt_regs *regs __unused)
>>  	}
>>  }
>>  
>> +static void lpi_handler(struct pt_regs *regs __unused)
>> +{
>> +	u32 irqstat = gic_read_iar();
>> +	int irqnr = gic_iar_irqnr(irqstat);
>> +
>> +	gic_write_eoir(irqstat);
>> +	if (irqnr < 8192)
>> +		report(false, "Unexpected non LPI interrupt received");
>> +	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
>> +	lpi_stats.observed.cpu_id = smp_processor_id();
>> +	lpi_stats.observed.lpi_id = irqnr;
>> +	smp_wmb(); /* pairs with rmb in check_lpi_stats */
>> +}
>> +
>> +static void lpi_stats_expect(int exp_cpu_id, int exp_lpi_id)
>> +{
>> +	lpi_stats.expected.cpu_id = exp_cpu_id;
>> +	lpi_stats.expected.lpi_id = exp_lpi_id;
>> +	lpi_stats.observed.cpu_id = -1;
>> +	lpi_stats.observed.lpi_id = -1;
>> +	smp_wmb(); /* pairs with rmb in handler */
>> +}
>> +
>> +static void check_lpi_stats(void)
>> +{
>> +	mdelay(100);
>> +	smp_rmb(); /* pairs with wmb in lpi_handler */
>> +	if ((lpi_stats.observed.cpu_id != lpi_stats.expected.cpu_id) ||
>> +	    (lpi_stats.observed.lpi_id != lpi_stats.expected.lpi_id)) {
>> +		if (lpi_stats.observed.cpu_id == -1 &&
>> +		    lpi_stats.observed.lpi_id == -1) {
>> +			report(false,
>> +			       "No LPI received whereas (cpuid=%d, intid=%d) "
>> +			       "was expected", lpi_stats.expected.cpu_id,
>> +			       lpi_stats.expected.lpi_id);
>> +		} else {
>> +			report(false, "Unexpected LPI (cpuid=%d, intid=%d)",
>> +			       lpi_stats.observed.cpu_id,
>> +			       lpi_stats.observed.lpi_id);
>> +		}
>> +	} else if (lpi_stats.expected.lpi_id != -1) {
>> +		report(true, "LPI %d on CPU %d", lpi_stats.observed.lpi_id,
>> +		       lpi_stats.observed.cpu_id);
>> +	} else {
>> +		report(true, "no LPI received, as expected");
>> +	}
>> +}
>> +
>>  static void gicv2_ipi_send_self(void)
>>  {
>>  	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
>> @@ -241,6 +290,14 @@ static void ipi_test(void *data __unused)
>>  		ipi_recv();
>>  }
>>  
>> +static void secondary_lpi_test(void)
>> +{
>> +	setup_irq(lpi_handler);
>> +	cpumask_set_cpu(smp_processor_id(), &ready);
>> +	while (1)
>> +		wfi();
>> +}
>> +
>>  static struct gic gicv2 = {
>>  	.ipi = {
>>  		.send_self = gicv2_ipi_send_self,
>> @@ -551,6 +608,120 @@ static void test_its_baser(void)
>>  	report_info("collection baser entry_size = 0x%x", coll_baser->esz);
>>  }
>>  
>> +static int its_prerequisites(int nb_cpus)
>> +{
>> +	int cpu;
>> +
>> +	if (!gicv3_its_base()) {
>> +		report_skip("No ITS, skip ...");
>> +		return -1;
>> +	}
>> +
>> +	if (nr_cpus < 4) {
>> +		report_skip("Test requires at least %d vcpus", nb_cpus);
>> +		return -1;
> 
> We have nr_cpu_check() in arm/gic.c that does a report_abort for this
> case. Is there a reason to do report_skip instead of report_abort?
Why should we mandate 4 vcpus?
> 
> Also do you plan to return more than 0 - success, -1 - failure? If not,
> then this could be a bool function.
indeed.
> 
>> +	}
>> +
>> +	stats_reset();
>> +
>> +	setup_irq(lpi_handler);
>> +
>> +	for_each_present_cpu(cpu) {
>> +		if (cpu == 0)
>> +			continue;
>> +		smp_boot_secondary(cpu, secondary_lpi_test);
>> +	}
>> +	wait_on_ready();
>> +
>> +	its_enable_defaults();
>> +
>> +	lpi_stats_expect(-1, -1);
>> +	check_lpi_stats();
>> +
>> +	return 0;
>> +}
>> +
>> +static void test_its_trigger(void)
>> +{
>> +	struct its_collection *col3, *col2;
>> +	struct its_device *dev2, *dev7;
>> +
>> +	if (its_prerequisites(4))
>> +		return;
>> +
>> +	dev2 = its_create_device(2 /* dev id */, 8 /* nb_ites */);
>> +	dev7 = its_create_device(7 /* dev id */, 8 /* nb_ites */);
>> +
>> +	col3 = its_create_collection(3 /* col id */, 3/* target PE */);
>> +	col2 = its_create_collection(2 /* col id */, 2/* target PE */);
>> +
>> +	set_lpi_config(8195, LPI_PROP_DEFAULT);
>> +	set_lpi_config(8196, LPI_PROP_DEFAULT);
>> +
>> +	its_send_invall(col2);
>> +	its_send_invall(col3);
>> +
>> +	report_prefix_push("int");
>> +
>> +	its_send_mapd(dev2, true);
>> +	its_send_mapd(dev7, true);
>> +
>> +	its_send_mapc(col3, true);
>> +	its_send_mapc(col2, true);
>> +
>> +	its_send_mapti(dev2, 8195 /* lpi id */,
>> +		       20 /* event id */, col3);
>> +	its_send_mapti(dev7, 8196 /* lpi id */,
>> +		       255 /* event id */, col2);
>> +
>> +	lpi_stats_expect(3, 8195);
>> +	its_send_int(dev2, 20);
>> +	check_lpi_stats();
>> +
>> +	lpi_stats_expect(2, 8196);
>> +	its_send_int(dev7, 255);
>> +	check_lpi_stats();
>> +
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("inv/invall");
>> +
>> +	/* disable 8195 */
>> +	set_lpi_config(8195, LPI_PROP_DEFAULT & ~0x1);
>> +	its_send_inv(dev2, 20);
>> +
>> +	lpi_stats_expect(-1, -1);
>> +	its_send_int(dev2, 20);
>> +	check_lpi_stats();
>> +
>> +	set_lpi_config(8195, LPI_PROP_DEFAULT);
>> +	/* willingly forget the INVALL*/
>> +	lpi_stats_expect(-1, -1);
>> +	its_send_int(dev2, 20);
>> +	check_lpi_stats();
>> +
>> +	its_send_invall(col3);
>> +	lpi_stats_expect(3, 8195);
>> +	its_send_int(dev2, 20);
>> +	check_lpi_stats();
>> +
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("mapd valid=false");
>> +	its_send_mapd(dev2, false);
>> +	lpi_stats_expect(-1, -1);
>> +	its_send_int(dev2, 20);
>> +	check_lpi_stats();
>> +	report_prefix_pop();
>> +
>> +	report_prefix_push("mapc valid=false");
>> +	its_send_mapc(col2, false);
>> +	lpi_stats_expect(-1, -1);
>> +	its_send_int(dev7, 255);
>> +	check_lpi_stats();
> 
> Missing prefix pop here
OK
> 
>> +}
>> +
>> +
> 
> Extra blank line
> 
>>  int main(int argc, char **argv)
>>  {
>>  	if (!gic_init()) {
>> @@ -581,6 +752,9 @@ int main(int argc, char **argv)
>>  	} else if (strcmp(argv[1], "mmio") == 0) {
>>  		report_prefix_push(argv[1]);
>>  		gic_test_mmio();
>> +	} else if (!strcmp(argv[1], "its-trigger")) {
>> +		report_prefix_push(argv[1]);
>> +		test_its_trigger();
>>  		report_prefix_pop();
> 
> You stole the report_prefix_pop from the mmio tests above.
OK
> 
>>  	} else if (strcmp(argv[1], "its-introspection") == 0) {
>>  		report_prefix_push(argv[1]);
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index 2234a0f..80a1d27 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -134,6 +134,12 @@ smp = $MAX_SMP
>>  extra_params = -machine gic-version=3 -append 'its-baser'
>>  groups = its
>>  
>> +[its-trigger]
>> +file = gic.flat
>> +smp = $MAX_SMP
>> +extra_params = -machine gic-version=3 -append 'its-trigger'
>> +groups = its
>> +
>>  # Test PSCI emulation
>>  [psci]
>>  file = psci.flat
>> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
>> index 463174f..7d6f8fd 100644
>> --- a/lib/arm/asm/gic-v3-its.h
>> +++ b/lib/arm/asm/gic-v3-its.h
>> @@ -123,6 +123,16 @@ struct its_data {
>>  	u32 nr_collections;	/* Allocated Collections */
>>  };
>>  
>> +struct its_event {
>> +	int cpu_id;
>> +	int lpi_id;
>> +};
>> +
>> +struct its_stats {
>> +	struct its_event expected;
>> +	struct its_event observed;
>> +};
> 
> These structures belong in arm/gic.c as they are unit test structions and
> driver structures.
OK
> 
>> +
>>  extern struct its_data its_data;
>>  
>>  #define gicv3_its_base()		(its_data.base)
>> @@ -139,6 +149,10 @@ extern void gicv3_rdist_ctrl_lpi(u32 redist, bool set);
>>  extern void its_enable_defaults(void);
>>  extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
>>  extern struct its_collection *its_create_collection(u32 col_id, u32 target_pe);
>> +extern struct its_collection *its_create_collection(u32 col_id, u32 target);
> 
> Extra definition of its_create_collection?
> 
>> +
>> +extern void set_lpi_config(int n, u8 val);
> 
> Please rename: lpi_set_config
> 
>> +extern u8 get_lpi_config(int n);
> 
> get_lpi_config doesn't seem to exist.
> 
>>  
>>  extern void its_send_mapd(struct its_device *dev, int valid);
>>  extern void its_send_mapc(struct its_collection *col, int valid);
>> -- 
>> 2.20.1
>>
> 
> Thanks,
> drew 
> 
Thanks

Eric

