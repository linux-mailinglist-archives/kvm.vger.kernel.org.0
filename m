Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06391183548
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 16:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgCLPo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 11:44:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58061 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727841AbgCLPo5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Mar 2020 11:44:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584027895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JKpqkyg24HBYZMYaHdI/WtnrKZbcyivTfzakH3GMn20=;
        b=SS5zSKk4vgwgIKzbQ7y2OYrvl/ve5v5FOUaCln/BNtFTRlFVjbAzc5bhAX1jleX66sR6VV
        Z+F8p9p1hgcNch3woC0tRE97/lfCbbyvUWBgDChPIJ558EDOWC0/BfJn7/DBW6EGg5Ax9v
        Gf1WWIMNuSxs7HboqfIJ1X5Oyw5gPlw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-UFJlH_GWPHSbdtbRDWfAXg-1; Thu, 12 Mar 2020 11:44:53 -0400
X-MC-Unique: UFJlH_GWPHSbdtbRDWfAXg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E24618018CB;
        Thu, 12 Mar 2020 15:44:51 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C3C35C1B5;
        Thu, 12 Mar 2020 15:44:46 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v3 12/12] arm: pmu: Test overflow interrupts
Date:   Thu, 12 Mar 2020 16:43:01 +0100
Message-Id: <20200312154301.9130-13-eric.auger@redhat.com>
In-Reply-To: <20200312154301.9130-1-eric.auger@redhat.com>
References: <20200312154301.9130-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test overflows for MEM_ACCESS and SW_INCR events. Also tests
overflows with 64-bit events.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v2 -> v3:
- added prefix pop
- added pmu_stats.unexpected
- added pmu- prefix
- remove traces in irq_handler()

v1 -> v2:
- inline setup_irq() code
---
 arm/pmu.c         | 139 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |   6 ++
 2 files changed, 145 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 79c2a0f..628249c 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -59,12 +59,20 @@
 #define PRE_OVERFLOW		0xFFFFFFF0
 #define PRE_OVERFLOW2		0xFFFFFFDC
=20
+#define PMU_PPI			23
+
 struct pmu {
 	unsigned int version;
 	unsigned int nb_implemented_counters;
 	uint32_t pmcr_ro;
 };
=20
+struct pmu_stats {
+	unsigned long bitmap;
+	uint32_t interrupts[32];
+	bool unexpected;
+};
+
 static struct pmu pmu;
=20
 #if defined(__arm__)
@@ -146,6 +154,7 @@ static void test_sw_incr(void) {}
 static void test_chained_counters(void) {}
 static void test_chained_sw_incr(void) {}
 static void test_chain_promotion(void) {}
+static void test_overflow_interrupt(void) {}
=20
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -276,6 +285,43 @@ asm volatile(
 	: "x9", "x10", "cc");
 }
=20
+static struct pmu_stats pmu_stats;
+
+static void irq_handler(struct pt_regs *regs)
+{
+	uint32_t irqstat, irqnr;
+
+	irqstat =3D gic_read_iar();
+	irqnr =3D gic_iar_irqnr(irqstat);
+
+	if (irqnr =3D=3D PMU_PPI) {
+		unsigned long overflows =3D read_sysreg(pmovsclr_el0);
+		int i;
+
+		for (i =3D 0; i < 32; i++) {
+			if (test_and_clear_bit(i, &overflows)) {
+				pmu_stats.interrupts[i]++;
+				pmu_stats.bitmap |=3D 1 << i;
+			}
+		}
+		write_sysreg(ALL_SET, pmovsclr_el0);
+	} else {
+		pmu_stats.unexpected =3D true;
+	}
+	gic_write_eoir(irqstat);
+}
+
+static void pmu_reset_stats(void)
+{
+	int i;
+
+	for (i =3D 0; i < 32; i++)
+		pmu_stats.interrupts[i] =3D 0;
+
+	pmu_stats.bitmap =3D 0;
+	pmu_stats.unexpected =3D false;
+}
+
 static void pmu_reset(void)
 {
 	/* reset all counters, counting disabled at PMCR level*/
@@ -286,6 +332,7 @@ static void pmu_reset(void)
 	write_sysreg(ALL_SET, pmovsclr_el0);
 	/* disable overflow interrupts on all counters */
 	write_sysreg(ALL_SET, pmintenclr_el1);
+	pmu_reset_stats();
 	isb();
 }
=20
@@ -730,6 +777,94 @@ static void test_chain_promotion(void)
 			read_sysreg(pmovsclr_el0));
 }
=20
+static bool expect_interrupts(uint32_t bitmap)
+{
+	int i;
+
+	if (pmu_stats.bitmap ^ bitmap || pmu_stats.unexpected)
+		return false;
+
+	for (i =3D 0; i < 32; i++) {
+		if (test_and_clear_bit(i, &pmu_stats.bitmap))
+			if (pmu_stats.interrupts[i] !=3D 1)
+				return false;
+	}
+	return true;
+}
+
+static void test_overflow_interrupt(void)
+{
+	uint32_t events[] =3D {MEM_ACCESS, SW_INCR};
+	void *addr =3D malloc(PAGE_SIZE);
+	int i;
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	gic_enable_defaults();
+	install_irq_handler(EL1H_IRQ, irq_handler);
+	local_irq_enable();
+	gic_enable_irq(23);
+
+	pmu_reset();
+
+	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
+	isb();
+
+	/* interrupts are disabled */
+
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	report(expect_interrupts(0), "no overflow interrupt received");
+
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i =3D 0; i < 100; i++)
+		write_sysreg(0x2, pmswinc_el0);
+
+	set_pmcr(pmu.pmcr_ro);
+	report(expect_interrupts(0), "no overflow interrupt received");
+
+	/* enable interrupts */
+
+	pmu_reset_stats();
+
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
+	write_sysreg(ALL_SET, pmintenset_el1);
+	isb();
+
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	for (i =3D 0; i < 100; i++)
+		write_sysreg(0x3, pmswinc_el0);
+
+	mem_access_loop(addr, 200, pmu.pmcr_ro);
+	report_info("overflow=3D0x%lx", read_sysreg(pmovsclr_el0));
+	report(expect_interrupts(0x3),
+		"overflow interrupts expected on #0 and #1");
+
+	/* promote to 64-b */
+
+	pmu_reset_stats();
+
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	isb();
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	report(expect_interrupts(0),
+		"no overflow interrupt expected on 32b boundary");
+
+	/* overflow on odd counter */
+	pmu_reset_stats();
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, ALL_SET);
+	isb();
+	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
+	report(expect_interrupts(0x2),
+		"expect overflow interrupt on odd counter");
+}
 #endif
=20
 /*
@@ -932,6 +1067,10 @@ int main(int argc, char *argv[])
 		report_prefix_push(argv[1]);
 		test_chain_promotion();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "pmu-overflow-interrupt") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_overflow_interrupt();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 1b0c8c8..455fd10 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -114,6 +114,12 @@ groups =3D pmu
 arch =3D arm64
 extra_params =3D -append 'pmu-chain-promotion'
=20
+[pmu-overflow-interrupt]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'pmu-overflow-interrupt'
+
 # Test PMU support (TCG) with -icount IPC=3D1
 #[pmu-tcg-icount-1]
 #file =3D pmu.flat
--=20
2.20.1

