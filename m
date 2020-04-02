Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4999B19C87A
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 20:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389466AbgDBSCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 14:02:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27514 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388641AbgDBSCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 14:02:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585850529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tjp557QoSwX1zXO0Qt6n7kWqUIk7/59D04dmkiPODOE=;
        b=WWptYjtfsc4b4n++5PccnuB3UXz5nvyRMfgXZXvsFR2WpD16vL/S2XlknIL9+jMp6VSfcK
        PamXNShxq/4Onz5kXo1qCVxzzMA+aD3WxQxVFoD4VKqtZz2FTm8Tmd8FUJCuLDqINQYgEM
        xxJLm3acbVtRnUZmhIVd7FVu+gaQb30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-PBDxcm1jN-qIMcFRkyICVA-1; Thu, 02 Apr 2020 14:02:05 -0400
X-MC-Unique: PBDxcm1jN-qIMcFRkyICVA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D257B13F6;
        Thu,  2 Apr 2020 18:01:57 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3CBD118F22;
        Thu,  2 Apr 2020 18:01:50 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     peter.maydell@linaro.org, andre.przywara@arm.com, thuth@redhat.com,
        yuzenghui@huawei.com, alexandru.elisei@arm.com
Subject: [PATCH kvm-unit-tests] fixup! arm/arm64: ITS: pending table migration test
Date:   Thu,  2 Apr 2020 20:01:48 +0200
Message-Id: <20200402180148.490026-1-drjones@redhat.com>
In-Reply-To: <20200402145227.20109-1-eric.auger@redhat.com>
References: <20200402145227.20109-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[ Without the fix this test would hang, as timeouts don't work with
  the migration scripts (yet). Use errata to skip instead of hang. ]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c  | 18 ++++++++++++++++--
 errata.txt |  1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index ddf0f9d09b14..c0781f8c2c80 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -12,6 +12,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <errata.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
 #include <asm/delay.h>
@@ -812,13 +813,23 @@ static void test_its_migration(void)
 	check_lpi_stats("dev7/eventid=3D255 triggers LPI 8196 on PE #2 after mi=
gration");
 }
=20
+#define ERRATA_UNMAPPED_COLLECTIONS "ERRATA_8c58be34494b"
+
 static void test_migrate_unmapped_collection(void)
 {
-	struct its_collection *col;
-	struct its_device *dev2, *dev7;
+	struct its_collection *col =3D NULL;
+	struct its_device *dev2 =3D NULL, *dev7 =3D NULL;
+	bool test_skipped =3D false;
 	int pe0 =3D 0;
 	u8 config;
=20
+	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
+		report_skip("Skipping test, as this test hangs without the fix. "
+			    "Set %s=3Dy to enable.", ERRATA_UNMAPPED_COLLECTIONS);
+		test_skipped =3D true;
+		goto do_migrate;
+	}
+
 	if (its_setup1())
 		return;
=20
@@ -830,9 +841,12 @@ static void test_migrate_unmapped_collection(void)
 	its_send_mapti(dev2, 8192, 0, col);
 	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
=20
+do_migrate:
 	puts("Now migrate the VM, then press a key to continue...\n");
 	(void)getchar();
 	report_info("Migration complete");
+	if (test_skipped)
+		return;
=20
 	/* on the destination, map the collection */
 	its_send_mapc(col, true);
diff --git a/errata.txt b/errata.txt
index 7d6abc2a7bf6..b66afaa9c079 100644
--- a/errata.txt
+++ b/errata.txt
@@ -5,4 +5,5 @@
 9e3f7a296940    : 4.9                           : arm64: KVM: pmu: Fix A=
Arch32 cycle counter access
 7b6b46311a85    : 4.11                          : KVM: arm/arm64: Emulat=
e the EL1 phys timer registers
 6c7a5dce22b3    : 4.12                          : KVM: arm/arm64: fix ra=
ces in kvm_psci_vcpu_on
+8c58be34494b    : 5.6                           : KVM: arm/arm64: vgic-i=
ts: Fix restoration of unmapped collections
 #---------------:-------------------------------:-----------------------=
----------------------------
--=20
2.25.1

