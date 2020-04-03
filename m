Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A3419D0EA
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 09:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389116AbgDCHOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 03:14:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41814 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389448AbgDCHOC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 03:14:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585898041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fDpHgRY2PBeuAglXruVQh+Gy7es0EWulYw4xwBVDuzY=;
        b=MF6AOJ22ve0RkH7xBCjl12qyKDuH2Yr5HaqrIycRC9Qey8I5Iy8GgU5j8gav3nFSpe8RY1
        ULKzMvi/FGtXzNQlTedtGwD0Re1VFtWi5PmP3rSZLWFhKsSHTTPDga0o72ma1TPs/Fb7NW
        MmYydjaAqvc308oI6AChr+qexM0ac9k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-InROAzoLPN28gxEW3IZW_w-1; Fri, 03 Apr 2020 03:13:57 -0400
X-MC-Unique: InROAzoLPN28gxEW3IZW_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAF59100550D;
        Fri,  3 Apr 2020 07:13:55 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A529B5C1C6;
        Fri,  3 Apr 2020 07:13:50 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v4 05/12] arm: pmu: Introduce defines for PMU versions
Date:   Fri,  3 Apr 2020 09:13:19 +0200
Message-Id: <20200403071326.29932-6-eric.auger@redhat.com>
In-Reply-To: <20200403071326.29932-1-eric.auger@redhat.com>
References: <20200403071326.29932-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce some defines encoding the different PMU versions.
v3 is encoded differently in 32 and 64 bits.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index d827e82..a04588a 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -45,6 +45,15 @@ static struct pmu pmu;
 #define ID_DFR0_PERFMON_SHIFT 24
 #define ID_DFR0_PERFMON_MASK  0xf
=20
+#define ID_DFR0_PMU_NOTIMPL	0b0000
+#define ID_DFR0_PMU_V1		0b0001
+#define ID_DFR0_PMU_V2		0b0010
+#define ID_DFR0_PMU_V3		0b0011
+#define ID_DFR0_PMU_V3_8_1	0b0100
+#define ID_DFR0_PMU_V3_8_4	0b0101
+#define ID_DFR0_PMU_V3_8_5	0b0110
+#define ID_DFR0_PMU_IMPDEF	0b1111
+
 #define PMCR         __ACCESS_CP15(c9, 0, c12, 0)
 #define ID_DFR0      __ACCESS_CP15(c0, 0, c1, 2)
 #define PMSELR       __ACCESS_CP15(c9, 0, c12, 5)
@@ -105,6 +114,13 @@ static inline void precise_instrs_loop(int loop, uin=
t32_t pmcr)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
 #define ID_AA64DFR0_PERFMON_MASK  0xf
=20
+#define ID_DFR0_PMU_NOTIMPL	0b0000
+#define ID_DFR0_PMU_V3		0b0001
+#define ID_DFR0_PMU_V3_8_1	0b0100
+#define ID_DFR0_PMU_V3_8_4	0b0101
+#define ID_DFR0_PMU_V3_8_5	0b0110
+#define ID_DFR0_PMU_IMPDEF	0b1111
+
 static inline uint32_t get_id_aa64dfr0(void) { return read_sysreg(id_aa6=
4dfr0_el1); }
 static inline uint32_t get_pmcr(void) { return read_sysreg(pmcr_el0); }
 static inline void set_pmcr(uint32_t v) { write_sysreg(v, pmcr_el0); }
@@ -116,7 +132,7 @@ static inline void set_pmccfiltr(uint32_t v) { write_=
sysreg(v, pmccfiltr_el0); }
 static inline uint8_t get_pmu_version(void)
 {
 	uint8_t ver =3D (get_id_aa64dfr0() >> ID_AA64DFR0_PERFMON_SHIFT) & ID_A=
A64DFR0_PERFMON_MASK;
-	return ver =3D=3D 1 ? 3 : ver;
+	return ver;
 }
=20
 /*
@@ -249,7 +265,7 @@ static bool check_cpi(int cpi)
 static void pmccntr64_test(void)
 {
 #ifdef __arm__
-	if (pmu.version =3D=3D 0x3) {
+	if (pmu.version =3D=3D ID_DFR0_PMU_V3) {
 		if (ERRATA(9e3f7a296940)) {
 			write_sysreg(0xdead, PMCCNTR64);
 			report(read_sysreg(PMCCNTR64) =3D=3D 0xdead, "pmccntr64");
@@ -262,13 +278,13 @@ static void pmccntr64_test(void)
 /* Return FALSE if no PMU found, otherwise return TRUE */
 static bool pmu_probe(void)
 {
-	uint32_t pmcr;
+	uint32_t pmcr =3D get_pmcr();
=20
 	pmu.version =3D get_pmu_version();
-	if (pmu.version =3D=3D 0 || pmu.version =3D=3D 0xf)
+	if (pmu.version =3D=3D ID_DFR0_PMU_NOTIMPL || pmu.version =3D=3D ID_DFR=
0_PMU_IMPDEF)
 		return false;
=20
-	report_info("PMU version: %d", pmu.version);
+	report_info("PMU version: 0x%x", pmu.version);
=20
 	pmcr =3D get_pmcr();
 	report_info("PMU implementer/ID code: %#x(\"%c\")/%#x",
--=20
2.20.1

