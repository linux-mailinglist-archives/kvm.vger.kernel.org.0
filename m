Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 914C0183535
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 16:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgCLPnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 11:43:39 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56817 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727749AbgCLPnj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Mar 2020 11:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584027819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L32ijn0JvgWid8cEaZUZkfWPFPXKJ067qGBdQUVReeI=;
        b=WAIxy4DS5B2Pb48kzwXe3m9eCl4LxYUucV5zfGPIrH7Q5fMprWX+oOg46BgBWQHcqVuhWg
        IzdSvrh4yqYckYRbOxnb1d0/8ZyOdh08c0PoaejTGvSvHfKDVuTalg9ed9IbWkuGNk3MWS
        upBUCKw92NFce6L35yx974gkPYPx0to=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-rwhGuAlZN5-oHk3xKccUCg-1; Thu, 12 Mar 2020 11:43:37 -0400
X-MC-Unique: rwhGuAlZN5-oHk3xKccUCg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC515108442C;
        Thu, 12 Mar 2020 15:43:35 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C7DB66836;
        Thu, 12 Mar 2020 15:43:26 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v3 03/12] arm: pmu: Don't check PMCR.IMP anymore
Date:   Thu, 12 Mar 2020 16:42:52 +0100
Message-Id: <20200312154301.9130-4-eric.auger@redhat.com>
In-Reply-To: <20200312154301.9130-1-eric.auger@redhat.com>
References: <20200312154301.9130-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

check_pmcr() checks the IMP field is different than 0.
However A zero IMP field is permitted by the architecture,
meaning the MIDR_EL1 should be looked at instead. This
causes TCG to fail this test on '-cpu max' because in
that case PMCR.IMP is set equal to MIDR_EL1.Implementer
which is 0.

So let's remove the check_pmcr() test and just print PMCR
info in the pmu_probe() function.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Peter Maydell <peter.maydell@linaro.org>
---
 arm/pmu.c | 39 ++++++++++++++-------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 0122f0a..44f3543 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -134,29 +134,6 @@ static inline void precise_instrs_loop(int loop, uin=
t32_t pmcr)
 }
 #endif
=20
-/*
- * As a simple sanity check on the PMCR_EL0, ensure the implementer fiel=
d isn't
- * null. Also print out a couple other interesting fields for diagnostic
- * purposes. For example, as of fall 2016, QEMU TCG mode doesn't impleme=
nt
- * event counters and therefore reports zero event counters, but hopeful=
ly
- * support for at least the instructions event will be added in the futu=
re and
- * the reported number of event counters will become nonzero.
- */
-static bool check_pmcr(void)
-{
-	uint32_t pmcr;
-
-	pmcr =3D get_pmcr();
-
-	report_info("PMU implementer/ID code/counters: %#x(\"%c\")/%#x/%d",
-		    (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
-		    ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) ? : ' ',
-		    (pmcr >> PMU_PMCR_ID_SHIFT) & PMU_PMCR_ID_MASK,
-		    (pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK);
-
-	return ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) !=3D 0;
-}
-
 /*
  * Ensure that the cycle counter progresses between back-to-back reads.
  */
@@ -278,9 +255,22 @@ static void pmccntr64_test(void)
 /* Return FALSE if no PMU found, otherwise return TRUE */
 static bool pmu_probe(void)
 {
+	uint32_t pmcr;
+
 	pmu_version =3D get_pmu_version();
+	if (pmu_version =3D=3D 0 || pmu_version =3D=3D 0xf)
+		return false;
+
 	report_info("PMU version: %d", pmu_version);
-	return pmu_version !=3D 0 && pmu_version !=3D 0xf;
+
+	pmcr =3D get_pmcr();
+	report_info("PMU implementer/ID code/counters: %#x(\"%c\")/%#x/%d",
+		    (pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK,
+		    ((pmcr >> PMU_PMCR_IMP_SHIFT) & PMU_PMCR_IMP_MASK) ? : ' ',
+		    (pmcr >> PMU_PMCR_ID_SHIFT) & PMU_PMCR_ID_MASK,
+		    (pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK);
+
+	return true;
 }
=20
 int main(int argc, char *argv[])
@@ -301,7 +291,6 @@ int main(int argc, char *argv[])
 		report_prefix_push(argv[1]);
 		if (argc > 2)
 			cpi =3D atol(argv[2]);
-		report(check_pmcr(), "Control register");
 		report(check_cycles_increase(),
 		       "Monotonically increasing cycle count");
 		report(check_cpi(cpi), "Cycle/instruction ratio");
--=20
2.20.1

