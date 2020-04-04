Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCAA19E5DD
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgDDOjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:39:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57563 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726696AbgDDOjc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 4 Apr 2020 10:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k16DDTfET10bTMMk5weG30wRX2QfIuhsQJXS1PMhmJc=;
        b=L0+QUMI3x9j0VQPM4nxijAYXChcHxm88sG+N3nZ5mKEU12ujag2E7rvLdQDIolSorsXX/H
        zYFLNrBXpDicV8ewBoCsULEUXgcQ9JoOcY2Sj6uQMGJFppwmQAqmBinX2BEh9pZ7sgaV95
        OGJtAgIPFIa7PKmU/0gkmTE4cdIFv/E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-VexSv7oCPt-RjoBU67Sk2Q-1; Sat, 04 Apr 2020 10:39:27 -0400
X-MC-Unique: VexSv7oCPt-RjoBU67Sk2Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DAA718AB2C4;
        Sat,  4 Apr 2020 14:39:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A93FE9B912;
        Sat,  4 Apr 2020 14:39:24 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Eric Auger <eric.auger@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PULL kvm-unit-tests 36/39] arm/arm64: ITS: INT functional tests
Date:   Sat,  4 Apr 2020 16:37:28 +0200
Message-Id: <20200404143731.208138-37-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

Triggers LPIs through the INT command.

the test checks the LPI hits the right CPU and triggers
the right LPI intid, ie. the translation is correct.

Updates to the config table also are tested, along with inv
and invall commands.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c         | 217 +++++++++++++++++++++++++++++++++++++++++++---
 arm/unittests.cfg |   7 ++
 2 files changed, 213 insertions(+), 11 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 649ed81d33e1..54ae83d26eb9 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -159,6 +159,87 @@ static void ipi_handler(struct pt_regs *regs __unuse=
d)
 	}
 }
=20
+static void setup_irq(irq_handler_fn handler)
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
+	int i;
+
+	for (i =3D 0; i < 50; i++) {
+		mdelay(100);
+		smp_rmb(); /* pairs with wmb in lpi_handler */
+		if (lpi_stats.observed.cpu_id =3D=3D lpi_stats.expected.cpu_id &&
+		    lpi_stats.observed.lpi_id =3D=3D lpi_stats.expected.lpi_id) {
+			report(true, "%s", msg);
+			return;
+		}
+	}
+
+	if (lpi_stats.observed.cpu_id =3D=3D -1 && lpi_stats.observed.lpi_id =3D=
=3D -1) {
+		report_info("No LPI received whereas (cpuid=3D%d, intid=3D%d) "
+			    "was expected", lpi_stats.expected.cpu_id,
+			    lpi_stats.expected.lpi_id);
+	} else {
+		report_info("Unexpected LPI (cpuid=3D%d, intid=3D%d)",
+			    lpi_stats.observed.cpu_id,
+			    lpi_stats.observed.lpi_id);
+	}
+	report(false, "%s", msg);
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
@@ -216,17 +297,6 @@ static void ipi_test_smp(void)
 	report_prefix_pop();
 }
=20
-static void setup_irq(irq_handler_fn handler)
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
@@ -521,6 +591,7 @@ static void gic_test_mmio(void)
 #if defined(__arm__)
=20
 static void test_its_introspection(void) {}
+static void test_its_trigger(void) {}
=20
 #else /* __aarch64__ */
=20
@@ -559,6 +630,126 @@ static void test_its_introspection(void)
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
+	its_send_invall(col2);
+	its_send_invall(col3);
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
+}
 #endif
=20
 int main(int argc, char **argv)
@@ -592,6 +783,10 @@ int main(int argc, char **argv)
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
index fff37f9fb5e6..47f9446adcc3 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -184,6 +184,13 @@ extra_params =3D -machine gic-version=3D3 -append 'i=
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
--=20
2.25.1

