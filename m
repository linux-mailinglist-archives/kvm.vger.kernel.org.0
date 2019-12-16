Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9A3121B1C
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 21:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfLPUsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 15:48:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41054 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727539AbfLPUsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 15:48:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576529302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dznikfzn+n4WX4926tiKNygB6iX1YlaEs/0YdUiJxdA=;
        b=FzPSZZR3GUMf2K+z7Zw2QA5KFlhZJiyH/IcqTvVNehhY9SmFu61xIaVkaBlz9BGZi4VQOS
        RO6BNVdTvkn4RcVTPcTnsMb5IEjMGRVpD53OqjHJaV3023SCSb8qG4NgHASfusH6BOI+pR
        YfSGTATomzPNvOat6DcdIj4NRxJukRc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-ZsCK1exoNFqIWFgq7Whmzw-1; Mon, 16 Dec 2019 15:48:20 -0500
X-MC-Unique: ZsCK1exoNFqIWFgq7Whmzw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D5B28E10CF;
        Mon, 16 Dec 2019 20:48:18 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9BA65D9C9;
        Mon, 16 Dec 2019 20:48:15 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH 03/10] arm: pmu: Add a pmu struct
Date:   Mon, 16 Dec 2019 21:47:50 +0100
Message-Id: <20191216204757.4020-4-eric.auger@redhat.com>
In-Reply-To: <20191216204757.4020-1-eric.auger@redhat.com>
References: <20191216204757.4020-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This struct aims at storing information potentially used by
all tests such as the pmu version, the read-only part of the
PMCR, the number of implemented event counters, ...

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index e5e012d..d24857e 100644
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
@@ -265,7 +272,7 @@ static bool check_cpi(int cpi)
 static void pmccntr64_test(void)
 {
 #ifdef __arm__
-	if (pmu_version =3D=3D 0x3) {
+	if (pmu.version =3D=3D 0x3) {
 		if (ERRATA(9e3f7a296940)) {
 			write_sysreg(0xdead, PMCCNTR64);
 			report(read_sysreg(PMCCNTR64) =3D=3D 0xdead, "pmccntr64");
@@ -278,9 +285,22 @@ static void pmccntr64_test(void)
 /* Return FALSE if no PMU found, otherwise return TRUE */
 static bool pmu_probe(void)
 {
-	pmu_version =3D get_pmu_version();
-	report_info("PMU version: %d", pmu_version);
-	return pmu_version !=3D 0 && pmu_version !=3D 0xf;
+	uint32_t pmcr;
+
+	pmu.version =3D get_pmu_version();
+	report_info("PMU version: %d", pmu.version);
+
+	if (pmu.version =3D=3D 0 || pmu.version =3D=3D 0xF)
+		return false;
+
+	pmcr =3D get_pmcr();
+	pmu.pmcr_ro =3D pmcr & 0xFFFFFF80;
+	pmu.nb_implemented_counters =3D
+		(pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N_MASK;
+	report_info("Implements %d event counters",
+		    pmu.nb_implemented_counters);
+
+	return true;
 }
=20
 int main(int argc, char *argv[])
--=20
2.20.1

