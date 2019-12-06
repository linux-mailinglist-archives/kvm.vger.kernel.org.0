Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE60311566F
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 18:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfLFR1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 12:27:53 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26582 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726400AbfLFR1x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 12:27:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575653272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yqTunPkxwrcyQFOxDUNzfOp1hv1TJYsH7F1IJZPhTJo=;
        b=GUPCMfIKF/NWK5pNJR+nw4t8tI35nE0kVEHbQBwq3GIctmI2xGM1ydTOAYXVFGOXu7Lkan
        4F6NA3RqJTvSWP41bQqzaW5Jw2O2Ym/jyBsUmDCFPNaeJ4T4jiY9YQeFz5DzzjmgQLNsGY
        WHzQc/CIyfBYdiU/9dXuX33hG0tAtMw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-RwGInhliOwmo9mMSBC3FqA-1; Fri, 06 Dec 2019 12:27:48 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35E9A1005502;
        Fri,  6 Dec 2019 17:27:47 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 540D86CE40;
        Fri,  6 Dec 2019 17:27:42 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org
Subject: [kvm-unit-tests RFC 03/10] pmu: Add a pmu struct
Date:   Fri,  6 Dec 2019 18:27:17 +0100
Message-Id: <20191206172724.947-4-eric.auger@redhat.com>
In-Reply-To: <20191206172724.947-1-eric.auger@redhat.com>
References: <20191206172724.947-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: RwGInhliOwmo9mMSBC3FqA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
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
 arm/pmu.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 2ad6469..8e95251 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -33,7 +33,15 @@
=20
 #define NR_SAMPLES 10
=20
-static unsigned int pmu_version;
+struct pmu {
+=09unsigned int version;
+=09unsigned int nb_implemented_counters;
+=09uint32_t pmcr_ro;
+};
+
+static struct pmu pmu;
+
+
 #if defined(__arm__)
 #define ID_DFR0_PERFMON_SHIFT 24
 #define ID_DFR0_PERFMON_MASK  0xf
@@ -265,7 +273,7 @@ static bool check_cpi(int cpi)
 static void pmccntr64_test(void)
 {
 #ifdef __arm__
-=09if (pmu_version =3D=3D 0x3) {
+=09if (pmu.version =3D=3D 0x3) {
 =09=09if (ERRATA(9e3f7a296940)) {
 =09=09=09write_sysreg(0xdead, PMCCNTR64);
 =09=09=09report("pmccntr64", read_sysreg(PMCCNTR64) =3D=3D 0xdead);
@@ -278,9 +286,20 @@ static void pmccntr64_test(void)
 /* Return FALSE if no PMU found, otherwise return TRUE */
 static bool pmu_probe(void)
 {
-=09pmu_version =3D get_pmu_version();
-=09report_info("PMU version: %d", pmu_version);
-=09return pmu_version !=3D 0 && pmu_version !=3D 0xf;
+=09uint32_t pmcr;
+
+=09pmu.version =3D get_pmu_version();
+=09report_info("PMU version: %d", pmu.version);
+
+=09if (pmu.version =3D=3D 0 || pmu.version  =3D=3D 0xF)
+=09=09return false;
+
+=09pmcr =3D get_pmcr();
+=09pmu.pmcr_ro =3D pmcr & 0xFFFFFF80;
+=09pmu.nb_implemented_counters =3D (pmcr >> PMU_PMCR_N_SHIFT) & PMU_PMCR_N=
_MASK;
+=09report_info("Implements %d event counters", pmu.nb_implemented_counters=
);
+
+=09return true;
 }
=20
 int main(int argc, char *argv[])
--=20
2.20.1

