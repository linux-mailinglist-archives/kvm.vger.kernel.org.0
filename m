Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20B7D11566D
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 18:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfLFR1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 12:27:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50870 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726325AbfLFR1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 12:27:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575653265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lZIWyVz0mXJm3WKdFFZ/MDv4wbAF4ZdIGNT+t+b1NIM=;
        b=gDxL6DE/1IjAi8VzFP4328+FXyLjs1PkxQMtPLyTulAm4D5a+n6lJMX0vtji190ALhfULQ
        oSZuMVyfE1Yf56EiNOvH4hG2m65WGl9LnY6qshrPDnErh+jr4VSkd1CEWjNBzfUyob0cTh
        FNxtOcIx8HD2ULoU7GSAyPDr7MJAa7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-D71sZqEuNFWfvlreylC4FA-1; Fri, 06 Dec 2019 12:27:43 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0DC9107ACC9;
        Fri,  6 Dec 2019 17:27:41 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 73DC86CE40;
        Fri,  6 Dec 2019 17:27:39 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org
Subject: [kvm-unit-tests RFC 02/10] pmu: Let pmu tests take a sub-test parameter
Date:   Fri,  6 Dec 2019 18:27:16 +0100
Message-Id: <20191206172724.947-3-eric.auger@redhat.com>
In-Reply-To: <20191206172724.947-1-eric.auger@redhat.com>
References: <20191206172724.947-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: D71sZqEuNFWfvlreylC4FA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
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
 arm/pmu.c         | 22 ++++++++++++++--------
 arm/unittests.cfg |  7 ++++---
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 1de7d77..2ad6469 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -287,21 +287,27 @@ int main(int argc, char *argv[])
 {
 =09int cpi =3D 0;
=20
-=09if (argc > 1)
-=09=09cpi =3D atol(argv[1]);
-
 =09if (!pmu_probe()) {
 =09=09printf("No PMU found, test skipped...\n");
 =09=09return report_summary();
 =09}
=20
+=09if (argc < 2)
+=09=09report_abort("no test specified");
+
 =09report_prefix_push("pmu");
=20
-=09report("Control register", check_pmcr());
-=09report("Monotonically increasing cycle count", check_cycles_increase())=
;
-=09report("Cycle/instruction ratio", check_cpi(cpi));
-
-=09pmccntr64_test();
+=09if (strcmp(argv[1], "cycle-counter") =3D=3D 0) {
+=09=09report_prefix_push(argv[1]);
+=09=09if (argc > 2)
+=09=09=09cpi =3D atol(argv[2]);
+=09=09report("Control register", check_pmcr());
+=09=09report("Monotonically increasing cycle count", check_cycles_increase=
());
+=09=09report("Cycle/instruction ratio", check_cpi(cpi));
+=09=09pmccntr64_test();
+=09} else {
+=09=09report_abort("Unknown subtest '%s'", argv[1]);
+=09}
=20
 =09return report_summary();
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

