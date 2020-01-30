Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA1514D9AC
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 12:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgA3LZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 06:25:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30154 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726902AbgA3LZv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 06:25:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580383550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tZ8t/jvrMH9gmFlHWP1z+sDKBsuOrEE26InOIEyQnuA=;
        b=Vrk5yF2JhghvBuVNi1SL9AyL6jAyRLXVTPD/gbo8PwedGrJAD5fRzlHRsUROUoZnU331LW
        nlGXEz6BFz4nlbj3FCst5ERKMjfbzkVTcB/xgez79cZQoNpOn1+TdFTVQGsKyB8NW43PI0
        nQw1a5+AWBuScIp8mBM/QiWjAHp7goY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-5jvxqSYYPiuftcR82U1fbQ-1; Thu, 30 Jan 2020 06:25:48 -0500
X-MC-Unique: 5jvxqSYYPiuftcR82U1fbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACC221800D41;
        Thu, 30 Jan 2020 11:25:46 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E28AF1001B05;
        Thu, 30 Jan 2020 11:25:41 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 4/9] arm: pmu: Check Required Event Support
Date:   Thu, 30 Jan 2020 12:25:05 +0100
Message-Id: <20200130112510.15154-5-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-1-eric.auger@redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If event counters are implemented check the common events
required by the PMUv3 are implemented.

Some are unconditionally required (SW_INCR, CPU_CYCLES,
either INST_RETIRED or INST_SPEC). Some others only are
required if the implementation implements some other features.

Check those wich are unconditionally required.

This test currently fails on TCG as neither INST_RETIRED
or INST_SPEC are supported.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- fix is_event_supported()
- fix boolean condition for PMU v4
- fix PMCEID0 definition

RFC ->v1:
- add a comment to explain the PMCEID0/1 splits
---
 arm/pmu.c         | 62 +++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  6 +++++
 2 files changed, 68 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index d24857e..4a26a76 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -101,6 +101,10 @@ static inline void precise_instrs_loop(int loop, uin=
t32_t pmcr)
 	: [pmcr] "r" (pmcr), [z] "r" (0)
 	: "cc");
 }
+
+/* event counter tests only implemented for aarch64 */
+static void test_event_introspection(void) {}
+
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
 #define ID_AA64DFR0_PERFMON_MASK  0xf
@@ -139,6 +143,61 @@ static inline void precise_instrs_loop(int loop, uin=
t32_t pmcr)
 	: [pmcr] "r" (pmcr)
 	: "cc");
 }
+
+#define PMCEID1_EL0 sys_reg(3, 3, 9, 12, 7)
+
+static bool is_event_supported(uint32_t n, bool warn)
+{
+	uint64_t pmceid0 =3D read_sysreg(pmceid0_el0);
+	uint64_t pmceid1 =3D read_sysreg_s(PMCEID1_EL0);
+	bool supported;
+	uint64_t reg;
+
+	/*
+	 * The low 32-bits of PMCEID0/1 respectly describe
+	 * event support for events 0-31/32-63. Their High
+	 * 32-bits describe support for extended events
+	 * starting at 0x4000, using the same split.
+	 */
+	if (n >=3D 0x0  && n <=3D 0x3F)
+		reg =3D (pmceid0 & 0xFFFFFFFF) | ((pmceid1 & 0xFFFFFFFF) << 32);
+	else if  (n >=3D 0x4000 && n <=3D 0x403F)
+		reg =3D (pmceid0 >> 32) | ((pmceid1 >> 32) << 32);
+	else
+		abort();
+
+	supported =3D  reg & (1UL << (n & 0x3F));
+
+	if (!supported && warn)
+		report_info("event %d is not supported", n);
+	return supported;
+}
+
+static void test_event_introspection(void)
+{
+	bool required_events;
+
+	if (!pmu.nb_implemented_counters) {
+		report_skip("No event counter, skip ...");
+		return;
+	}
+
+	/* PMUv3 requires an implementation includes some common events */
+	required_events =3D is_event_supported(0x0, true) /* SW_INCR */ &&
+			  is_event_supported(0x11, true) /* CPU_CYCLES */ &&
+			  (is_event_supported(0x8, true) /* INST_RETIRED */ ||
+			   is_event_supported(0x1B, true) /* INST_PREC */);
+
+	if (pmu.version =3D=3D 0x4) {
+		/* ARMv8.1 PMU: STALL_FRONTEND and STALL_BACKEND are required */
+		required_events =3D required_events &&
+				  is_event_supported(0x23, true) &&
+				  is_event_supported(0x24, true);
+	}
+
+	report(required_events, "Check required events are implemented");
+}
+
 #endif
=20
 /*
@@ -326,6 +385,9 @@ int main(int argc, char *argv[])
 		       "Monotonically increasing cycle count");
 		report(check_cpi(cpi), "Cycle/instruction ratio");
 		pmccntr64_test();
+	} else if (strcmp(argv[1], "event-introspection") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_event_introspection();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 79f0d7a..4433ef3 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -66,6 +66,12 @@ file =3D pmu.flat
 groups =3D pmu
 extra_params =3D -append 'cycle-counter 0'
=20
+[pmu-event-introspection]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'event-introspection'
+
 # Test PMU support (TCG) with -icount IPC=3D1
 #[pmu-tcg-icount-1]
 #file =3D pmu.flat
--=20
2.20.1

