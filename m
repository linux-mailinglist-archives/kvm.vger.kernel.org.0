Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2E414D9A6
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 12:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgA3LZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 06:25:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38631 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726902AbgA3LZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 06:25:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580383536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UXlYDyzqTLtrcUrTm0BlWqi6aN682MJ2N066VEjbccE=;
        b=Y6NpkPLh44VghM81afI3jXtGZHWbdtA1/2hIgFidB1eJn+Ka2dCGBH9rXSCJ0zaBncwG1b
        rP6mZpZR3OKNs9sePy/UxKCvWKqluStkBXvxmpQvcsDGUWjG4ZpfgG57bar1vYQewLWgDN
        uJ4zxTjqi/uywGCxEQtSujJhU16auAQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-xymuaHqZNVaOnRaHgqujGg-1; Thu, 30 Jan 2020 06:25:34 -0500
X-MC-Unique: xymuaHqZNVaOnRaHgqujGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D6CF1005510;
        Thu, 30 Jan 2020 11:25:33 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECB171001B05;
        Thu, 30 Jan 2020 11:25:27 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 2/9] arm: pmu: Let pmu tests take a sub-test parameter
Date:   Thu, 30 Jan 2020 12:25:03 +0100
Message-Id: <20200130112510.15154-3-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-1-eric.auger@redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we intend to introduce more PMU tests, let's add
a sub-test parameter that will allow to categorize
them. Existing tests are in the cycle-counter category.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c         | 24 +++++++++++++++---------
 arm/unittests.cfg |  7 ++++---
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index d5a03a6..e5e012d 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -287,22 +287,28 @@ int main(int argc, char *argv[])
 {
 	int cpi =3D 0;
=20
-	if (argc > 1)
-		cpi =3D atol(argv[1]);
-
 	if (!pmu_probe()) {
 		printf("No PMU found, test skipped...\n");
 		return report_summary();
 	}
=20
+	if (argc < 2)
+		report_abort("no test specified");
+
 	report_prefix_push("pmu");
=20
-	report(check_pmcr(), "Control register");
-	report(check_cycles_increase(),
-	       "Monotonically increasing cycle count");
-	report(check_cpi(cpi), "Cycle/instruction ratio");
-
-	pmccntr64_test();
+	if (strcmp(argv[1], "cycle-counter") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		if (argc > 2)
+			cpi =3D atol(argv[2]);
+		report(check_pmcr(), "Control register");
+		report(check_cycles_increase(),
+		       "Monotonically increasing cycle count");
+		report(check_cpi(cpi), "Cycle/instruction ratio");
+		pmccntr64_test();
+	} else {
+		report_abort("Unknown sub-test '%s'", argv[1]);
+	}
=20
 	return report_summary();
 }
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index daeb5a0..79f0d7a 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -61,21 +61,22 @@ file =3D pci-test.flat
 groups =3D pci
=20
 # Test PMU support
-[pmu]
+[pmu-cycle-counter]
 file =3D pmu.flat
 groups =3D pmu
+extra_params =3D -append 'cycle-counter 0'
=20
 # Test PMU support (TCG) with -icount IPC=3D1
 #[pmu-tcg-icount-1]
 #file =3D pmu.flat
-#extra_params =3D -icount 0 -append '1'
+#extra_params =3D -icount 0 -append 'cycle-counter 1'
 #groups =3D pmu
 #accel =3D tcg
=20
 # Test PMU support (TCG) with -icount IPC=3D256
 #[pmu-tcg-icount-256]
 #file =3D pmu.flat
-#extra_params =3D -icount 8 -append '256'
+#extra_params =3D -icount 8 -append 'cycle-counter 256'
 #groups =3D pmu
 #accel =3D tcg
=20
--=20
2.20.1

