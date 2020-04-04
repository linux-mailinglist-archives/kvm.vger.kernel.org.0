Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D024019E5B8
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgDDOi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:38:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29091 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726477AbgDDOi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 10:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+rMYicE8IRsGNdwnkciZxtp1jiaYqa5jnjZhjK0amnI=;
        b=LaclZAmJQ+XpRCTj61PPQkM1VoRkG77qF5MMqiJ3gl+vh+3M2FO0rgkH8GKevrov+pXsAw
        M+u5DFZk5llttaMBJk7VrKI1keKahKWVPls+2yFmjODGZtgA0am2dsXht9vzRlceqXNqM1
        z4jyoONfdmI5zVAoUal/jhmUCFhEhhM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-mdlH_xDpPsam40XFQQCtGg-1; Sat, 04 Apr 2020 10:38:24 -0400
X-MC-Unique: mdlH_xDpPsam40XFQQCtGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0957800D4E;
        Sat,  4 Apr 2020 14:38:22 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62D2A9B912;
        Sat,  4 Apr 2020 14:38:21 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>
Subject: [PULL kvm-unit-tests 18/39] arm: pmu: Add a pmu struct
Date:   Sat,  4 Apr 2020 16:37:10 +0200
Message-Id: <20200404143731.208138-19-drjones@redhat.com>
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

This struct aims at storing information potentially used by
all tests such as the pmu version, the read-only part of the
PMCR, the number of implemented event counters, ...

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/pmu.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 44f3543cfa49..d827e8221c54 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -33,7 +33,14 @@
=20
 #define NR_SAMPLES 10
=20
-static unsigned int pmu_version;
+struct pmu {
+	unsigned int version;
+	unsigned int nb_implemented_counters;
+	uint32_t pmcr_ro;
+};
+
+static struct pmu pmu;
+
 #if defined(__arm__)
 #define ID_DFR0_PERFMON_SHIFT 24
 #define ID_DFR0_PERFMON_MASK  0xf
@@ -242,7 +249,7 @@ static bool check_cpi(int cpi)
 static void pmccntr64_test(void)
 {
 #ifdef __arm__
-	if (pmu_version =3D=3D 0x3) {
+	if (pmu.version =3D=3D 0x3) {
 		if (ERRATA(9e3f7a296940)) {
 			write_sysreg(0xdead, PMCCNTR64);
 			report(read_sysreg(PMCCNTR64) =3D=3D 0xdead, "pmccntr64");
@@ -257,18 +264,24 @@ static bool pmu_probe(void)
 {
 	uint32_t pmcr;
=20
-	pmu_version =3D get_pmu_version();
-	if (pmu_version =3D=3D 0 || pmu_version =3D=3D 0xf)
+	pmu.version =3D get_pmu_version();
+	if (pmu.version =3D=3D 0 || pmu.version =3D=3D 0xf)
 		return false;
=20
-	report_info("PMU version: %d", pmu_version);
+	report_info("PMU version: %d", pmu.version);
=20
 	pmcr =3D get_pmcr();
-	report_info("PMU implementer/ID code/counters: %#x(\"%c\")/%#x/%d",
+	report_info("PMU implementer/ID code: %#x(\"%c\")/%#x",
 		    (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
 		    ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) ? : ' ',
-		    (pmcr >> PMU_PMCR_ID_SHIFT) & PMU_PMCR_ID_MASK,
-		    (pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK);
+		    (pmcr >> PMU_PMCR_ID_SHIFT) & PMU_PMCR_ID_MASK);
+
+	/* store read-only and RES0 fields of the PMCR bottom-half*/
+	pmu.pmcr_ro =3D pmcr & 0xFFFFFF00;
+	pmu.nb_implemented_counters =3D
+		(pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK;
+	report_info("Implements %d event counters",
+		    pmu.nb_implemented_counters);
=20
 	return true;
 }
--=20
2.25.1

