Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530BE19D0F3
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 09:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389849AbgDCHOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 03:14:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55479 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388227AbgDCHOV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 03:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585898060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0mA5O6VELrlosqTtWhHeA6dNwzSlKertDBwWhijb2Es=;
        b=BXp92zbiD+/5OUUF5/tsTw+VVGTapiPU0IAMw9XHpM9l+d/+PNuIVUwHOlImhNbrqTeUKS
        BulpIBpv6F2f9OVkkYKSimUVg27n2n6pT7wSMYqgy7ujFF825vs3iUNS5LP+oyFDwyGNf7
        QJwmwl2vXJPanUGTFK88wCbIijrm0Rg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-xJJkn6sgPsGNCaClIjbZRA-1; Fri, 03 Apr 2020 03:14:16 -0400
X-MC-Unique: xJJkn6sgPsGNCaClIjbZRA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4DB86477;
        Fri,  3 Apr 2020 07:14:14 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13FB65C1C6;
        Fri,  3 Apr 2020 07:14:08 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v4 10/12] arm: pmu: test 32-bit <-> 64-bit transitions
Date:   Fri,  3 Apr 2020 09:13:24 +0200
Message-Id: <20200403071326.29932-11-eric.auger@redhat.com>
In-Reply-To: <20200403071326.29932-1-eric.auger@redhat.com>
References: <20200403071326.29932-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test configurations where we transit from 32b to 64b
counters and conversely. Also tests configuration where
chain counters are configured but only one counter is
enabled.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v3 -> v4:
- allo report messages are different

v2 -> v3:
- added prefix pop
---
 arm/pmu.c         | 138 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |   6 ++
 2 files changed, 144 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index be249cc..f8d9a18 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -57,6 +57,7 @@
 #define ALL_SET			0xFFFFFFFF
 #define ALL_CLEAR		0x0
 #define PRE_OVERFLOW		0xFFFFFFF0
+#define PRE_OVERFLOW2		0xFFFFFFDC
=20
 struct pmu {
 	unsigned int version;
@@ -144,6 +145,7 @@ static void test_mem_access(void) {}
 static void test_sw_incr(void) {}
 static void test_chained_counters(void) {}
 static void test_chained_sw_incr(void) {}
+static void test_chain_promotion(void) {}
=20
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -595,6 +597,138 @@ static void test_chained_sw_incr(void)
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
=20
+static void test_chain_promotion(void)
+{
+	uint32_t events[] =3D {MEM_ACCESS, CHAIN};
+	void *addr =3D malloc(PAGE_SIZE);
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	/* Only enable CHAIN counter */
+	pmu_reset();
+	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x2, PMCNTENSET_EL0);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report(!read_regn_el0(pmevcntr, 0),
+		"chain counter not counting if even counter is disabled");
+
+	/* Only enable even counter */
+	pmu_reset();
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_sysreg_s(0x1, PMCNTENSET_EL0);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) =3D=3D=
 0x1),
+		"odd counter did not increment on overflow if disabled");
+	report_info("MEM_ACCESS counter #0 has value %ld",
+		    read_regn_el0(pmevcntr, 0));
+	report_info("CHAIN counter #1 has value %ld",
+		    read_regn_el0(pmevcntr, 1));
+	report_info("overflow counter %ld", read_sysreg(pmovsclr_el0));
+
+	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled=
 */
+	pmu_reset();
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+
+	/* disable the CHAIN event */
+	write_sysreg_s(0x2, PMCNTENCLR_EL0);
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+	report(read_sysreg(pmovsclr_el0) =3D=3D 0x1,
+		"should have triggered an overflow on #0");
+	report(!read_regn_el0(pmevcntr, 1),
+		"CHAIN counter #1 shouldn't have incremented");
+
+	/* start at 0xFFFFFFDC, +20 with CHAIN disabled, +20 with CHAIN enabled=
 */
+
+	pmu_reset();
+	write_sysreg_s(0x1, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
+	isb();
+	report_info("counter #0 =3D 0x%lx, counter #1 =3D 0x%lx overflow=3D0x%l=
x",
+		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
+		    read_sysreg(pmovsclr_el0));
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+
+	/* enable the CHAIN event */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	isb();
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+
+	report((read_regn_el0(pmevcntr, 1) =3D=3D 1) && !read_sysreg(pmovsclr_e=
l0),
+		"CHAIN counter enabled: CHAIN counter was incremented and no overflow"=
);
+
+	report_info("CHAIN counter #1 =3D 0x%lx, overflow=3D0x%lx",
+		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
+
+	/* start as MEM_ACCESS/CPU_CYCLES and move to CHAIN/MEM_ACCESS */
+	pmu_reset();
+	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+
+	/* 0 becomes CHAINED */
+	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 1, 0x0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn_el0(pmevcntr, 0));
+
+	report((read_regn_el0(pmevcntr, 1) =3D=3D 1) && !read_sysreg(pmovsclr_e=
l0),
+		"32b->64b: CHAIN counter incremented and no overflow");
+
+	report_info("CHAIN counter #1 =3D 0x%lx, overflow=3D0x%lx",
+		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
+
+	/* start as CHAIN/MEM_ACCESS and move to MEM_ACCESS/CPU_CYCLES */
+	pmu_reset();
+	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("counter #0=3D0x%lx, counter #1=3D0x%lx",
+			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
+
+	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report(read_sysreg(pmovsclr_el0) =3D=3D 1,
+		"overflow is expected on counter 0");
+	report_info("counter #0=3D0x%lx, counter #1=3D0x%lx overflow=3D0x%lx",
+			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
+			read_sysreg(pmovsclr_el0));
+}
+
 #endif
=20
 /*
@@ -793,6 +927,10 @@ int main(int argc, char *argv[])
 		report_prefix_push(argv[1]);
 		test_chained_sw_incr();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "pmu-chain-promotion") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_chain_promotion();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index d31dcbf..1b0c8c8 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -108,6 +108,12 @@ groups =3D pmu
 arch =3D arm64
 extra_params =3D -append 'pmu-chained-sw-incr'
=20
+[pmu-chain-promotion]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'pmu-chain-promotion'
+
 # Test PMU support (TCG) with -icount IPC=3D1
 #[pmu-tcg-icount-1]
 #file =3D pmu.flat
--=20
2.20.1

