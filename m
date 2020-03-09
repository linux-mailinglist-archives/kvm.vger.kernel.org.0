Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 624CB17DD6B
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 11:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgCIKZU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 06:25:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26929 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726670AbgCIKZU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Mar 2020 06:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583749519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kYqmocdUd9h9gh7x34Ta4fTH/Ron3Nvydtu829W8YNo=;
        b=YNoprpjvi9qTn9UhKyn0lBooKBME/qZE57H1RJRL0x2tA//fnoQ8TrKP+qMZd6jt3W6BxI
        U+0+iRzfkZx2bYIPyclmmIClDy4Yl8wsQPBHimEiNzymNIcsMIHg8WhFrDgzosPGPvVhbJ
        51PQCGPUzJ0pE1alEotVv4BRc18PwLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-7NxN6xBzPkOsURJlary33g-1; Mon, 09 Mar 2020 06:25:18 -0400
X-MC-Unique: 7NxN6xBzPkOsURJlary33g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BCF8800D53;
        Mon,  9 Mar 2020 10:25:16 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86D5A87B08;
        Mon,  9 Mar 2020 10:25:13 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 10/13] arm/arm64: ITS: INT functional tests
Date:   Mon,  9 Mar 2020 11:24:17 +0100
Message-Id: <20200309102420.24498-11-eric.auger@redhat.com>
In-Reply-To: <20200309102420.24498-1-eric.auger@redhat.com>
References: <20200309102420.24498-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Triggers LPIs through the INT command.

the test checks the LPI hits the right CPU and triggers
the right LPI intid, ie. the translation is correct.

Updates to the config table also are tested, along with inv
and invall commands.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v3 -> v4:
- assert in lpi_handler if the interrupt is not an LPI
- remove check_lpi_stats from its_prerequisites()

v2 -> v3:
- add comments
- keep the report_skip in case there aren't 4 vcpus to be able to
  run other tests in the its category.
- fix the prefix pop
- move its_event and its_stats to arm/gic.c
---
 arm/gic.c                | 221 +++++++++++++++++++++++++++++++++++++--
 arm/unittests.cfg        |   7 ++
 lib/arm/asm/gic-v3-its.h |   9 +-
 3 files changed, 223 insertions(+), 14 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 67989f6..3ac90be 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -160,6 +160,84 @@ static void ipi_handler(struct pt_regs *regs __unuse=
d)
 	}
 }
=20
+static void setup_irq(handler_t handler)
+{
+	gic_enable_defaults();
+#ifdef __arm__
+	install_exception_handler(EXCPTN_IRQ, handler);
+#else
+	install_irq_handler(EL1H_IRQ, handler);
+#endif
+	local_irq_enable();
+}
+
+#if defined(__aarch64__)
+struct its_event {
+	int cpu_id;
+	int lpi_id;
+};
+
+struct its_stats {
+	struct its_event expected;
+	struct its_event observed;
+};
+
+static struct its_stats lpi_stats;
+
+static void lpi_handler(struct pt_regs *regs __unused)
+{
+	u32 irqstat =3D gic_read_iar();
+	int irqnr =3D gic_iar_irqnr(irqstat);
+
+	gic_write_eoir(irqstat);
+	assert(irqnr >=3D 8192);
+	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
+	lpi_stats.observed.cpu_id =3D smp_processor_id();
+	lpi_stats.observed.lpi_id =3D irqnr;
+	smp_wmb(); /* pairs with rmb in check_lpi_stats */
+}
+
+static void lpi_stats_expect(int exp_cpu_id, int exp_lpi_id)
+{
+	lpi_stats.expected.cpu_id =3D exp_cpu_id;
+	lpi_stats.expected.lpi_id =3D exp_lpi_id;
+	lpi_stats.observed.cpu_id =3D -1;
+	lpi_stats.observed.lpi_id =3D -1;
+	smp_wmb(); /* pairs with rmb in handler */
+}
+
+static void check_lpi_stats(const char *msg)
+{
+	bool pass =3D false;
+	mdelay(100);
+	smp_rmb(); /* pairs with wmb in lpi_handler */
+	if (lpi_stats.observed.cpu_id !=3D lpi_stats.expected.cpu_id ||
+	    lpi_stats.observed.lpi_id !=3D lpi_stats.expected.lpi_id) {
+		if (lpi_stats.observed.cpu_id =3D=3D -1 &&
+		    lpi_stats.observed.lpi_id =3D=3D -1) {
+			report_info("No LPI received whereas (cpuid=3D%d, intid=3D%d) "
+				    "was expected", lpi_stats.expected.cpu_id,
+				    lpi_stats.expected.lpi_id);
+		} else {
+			report_info("Unexpected LPI (cpuid=3D%d, intid=3D%d)",
+				    lpi_stats.observed.cpu_id,
+				    lpi_stats.observed.lpi_id);
+		}
+	} else {
+		pass =3D true;
+	}
+	report(pass, "%s", msg);
+}
+
+static void secondary_lpi_test(void)
+{
+	setup_irq(lpi_handler);
+	cpumask_set_cpu(smp_processor_id(), &ready);
+	while (1)
+		wfi();
+}
+#endif
+
 static void gicv2_ipi_send_self(void)
 {
 	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
@@ -217,17 +295,6 @@ static void ipi_test_smp(void)
 	report_prefix_pop();
 }
=20
-static void setup_irq(handler_t handler)
-{
-	gic_enable_defaults();
-#ifdef __arm__
-	install_exception_handler(EXCPTN_IRQ, handler);
-#else
-	install_irq_handler(EL1H_IRQ, handler);
-#endif
-	local_irq_enable();
-}
-
 static void ipi_send(void)
 {
 	setup_irq(ipi_handler);
@@ -556,6 +623,134 @@ static void test_its_introspection(void)
 	report_info("collection table entry_size =3D 0x%x", coll_baser->esz);
 }
=20
+static int its_prerequisites(int nb_cpus)
+{
+	int cpu;
+
+	if (!gicv3_its_base()) {
+		report_skip("No ITS, skip ...");
+		return -1;
+	}
+
+	if (nr_cpus < nb_cpus) {
+		report_skip("Test requires at least %d vcpus", nb_cpus);
+		return -1;
+	}
+
+	stats_reset();
+
+	setup_irq(lpi_handler);
+
+	for_each_present_cpu(cpu) {
+		if (cpu =3D=3D 0)
+			continue;
+		smp_boot_secondary(cpu, secondary_lpi_test);
+	}
+	wait_on_ready();
+
+	its_enable_defaults();
+
+	return 0;
+}
+
+static void test_its_trigger(void)
+{
+	struct its_collection *col3, *col2;
+	struct its_device *dev2, *dev7;
+
+	if (its_prerequisites(4))
+		return;
+
+	dev2 =3D its_create_device(2 /* dev id */, 8 /* nb_ites */);
+	dev7 =3D its_create_device(7 /* dev id */, 8 /* nb_ites */);
+
+	col3 =3D its_create_collection(3 /* col id */, 3/* target PE */);
+	col2 =3D its_create_collection(2 /* col id */, 2/* target PE */);
+
+	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
+	gicv3_lpi_set_config(8196, LPI_PROP_DEFAULT);
+
+	its_send_invall(col2);
+	its_send_invall(col3);
+
+	report_prefix_push("int");
+	/*
+	 * dev=3D2, eventid=3D20  -> lpi=3D 8195, col=3D3
+	 * dev=3D7, eventid=3D255 -> lpi=3D 8196, col=3D2
+	 * Trigger dev2, eventid=3D20 and dev7, eventid=3D255
+	 * Check both LPIs hit
+	 */
+
+	its_send_mapd(dev2, true);
+	its_send_mapd(dev7, true);
+
+	its_send_mapc(col3, true);
+	its_send_mapc(col2, true);
+
+	its_send_mapti(dev2, 8195 /* lpi id */, 20 /* event id */, col3);
+	its_send_mapti(dev7, 8196 /* lpi id */, 255 /* event id */, col2);
+
+	lpi_stats_expect(3, 8195);
+	its_send_int(dev2, 20);
+	check_lpi_stats("dev=3D2, eventid=3D20  -> lpi=3D 8195, col=3D3");
+
+	lpi_stats_expect(2, 8196);
+	its_send_int(dev7, 255);
+	check_lpi_stats("dev=3D7, eventid=3D255 -> lpi=3D 8196, col=3D2");
+
+	report_prefix_pop();
+
+	report_prefix_push("inv/invall");
+
+	/*
+	 * disable 8195, check dev2/eventid=3D20 does not trigger the
+	 * corresponding LPI
+	 */
+	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT & ~LPI_PROP_ENABLED);
+	its_send_inv(dev2, 20);
+
+	lpi_stats_expect(-1, -1);
+	its_send_int(dev2, 20);
+	check_lpi_stats("dev2/eventid=3D20 does not trigger any LPI");
+
+	/*
+	 * re-enable the LPI but willingly do not call invall
+	 * so the change in config is not taken into account.
+	 * The LPI should not hit
+	 */
+	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
+	lpi_stats_expect(-1, -1);
+	its_send_int(dev2, 20);
+	check_lpi_stats("dev2/eventid=3D20 still does not trigger any LPI");
+
+	/* Now call the invall and check the LPI hits */
+	its_send_invall(col3);
+	lpi_stats_expect(3, 8195);
+	its_send_int(dev2, 20);
+	check_lpi_stats("dev2/eventid=3D20 now triggers an LPI");
+
+	report_prefix_pop();
+
+	report_prefix_push("mapd valid=3Dfalse");
+	/*
+	 * Unmap device 2 and check the eventid 20 formerly
+	 * attached to it does not hit anymore
+	 */
+
+	its_send_mapd(dev2, false);
+	lpi_stats_expect(-1, -1);
+	its_send_int(dev2, 20);
+	check_lpi_stats("no LPI after device unmap");
+	report_prefix_pop();
+
+	/* Unmap the collection this time and check no LPI does hit */
+	report_prefix_push("mapc valid=3Dfalse");
+	its_send_mapc(col2, false);
+	lpi_stats_expect(-1, -1);
+	its_send_int(dev7, 255);
+	check_lpi_stats("no LPI after collection unmap");
+	report_prefix_pop();
+}
 #endif
=20
 int main(int argc, char **argv)
@@ -589,6 +784,10 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		gic_test_mmio();
 		report_prefix_pop();
+	} else if (!strcmp(argv[1], "its-trigger")) {
+		report_prefix_push(argv[1]);
+		test_its_trigger();
+		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") =3D=3D 0) {
 		report_prefix_push(argv[1]);
 		test_its_introspection();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 23d378e..b9a7a2c 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -129,6 +129,13 @@ extra_params =3D -machine gic-version=3D3 -append 'i=
ts-introspection'
 groups =3D its
 arch =3D arm64
=20
+[its-trigger]
+file =3D gic.flat
+smp =3D $MAX_SMP
+extra_params =3D -machine gic-version=3D3 -append 'its-trigger'
+groups =3D its
+arch =3D arm64
+
 # Test PSCI emulation
 [psci]
 file =3D psci.flat
diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 0096de6..956d7b8 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -5,9 +5,8 @@
  *
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
-
-#ifndef _ASMARM_GICv3_ITS
-#define _ASMARM_GICv3_ITS
+#ifndef _ASMARM_GIC_V3_ITS_H_
+#define _ASMARM_GIC_V3_ITS_H_
=20
 /* dummy its_data struct to allow gic_get_dt_bases() call */
 struct its_data {
@@ -19,5 +18,9 @@ static inline void test_its_introspection(void)
 {
 	report_abort("not supported on 32-bit");
 }
+static inline void test_its_trigger(void)
+{
+	report_abort("not supported on 32-bit");
+}
=20
 #endif /* _ASMARM_GICv3_ITS */
--=20
2.20.1

