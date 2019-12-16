Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3C37120809
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 15:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbfLPOEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 09:04:37 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40809 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728015AbfLPOEh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 09:04:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576505075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=olbkIGqVdpmbfsbYDxrstaTae7GtUoDRav6L33mLKZM=;
        b=Ehfn8tjVj4GtRUptdOQybGkNR5DPbjxRoWZyS8iUGYiz+IMvhvo9i5IRoUwlb/RCTiV/CD
        9s3vpg1zAToOL6m2MAuAqcK17DZ+AZeGgWSxRig93Xs7qoE15f3lBS1v9kichL65u3tdRH
        95S2Kg//5G7gHxT3aSXhxThrVkaKdN0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-64-Kf2l28LmO9O_7pIkl3byZg-1; Mon, 16 Dec 2019 09:04:34 -0500
X-MC-Unique: Kf2l28LmO9O_7pIkl3byZg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEA6F593A2;
        Mon, 16 Dec 2019 14:04:32 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8645675BE;
        Mon, 16 Dec 2019 14:04:29 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 15/16] arm/arm64: ITS: migration tests
Date:   Mon, 16 Dec 2019 15:02:34 +0100
Message-Id: <20191216140235.10751-16-eric.auger@redhat.com>
In-Reply-To: <20191216140235.10751-1-eric.auger@redhat.com>
References: <20191216140235.10751-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test maps LPIs (populates the device table, the collection table,
interrupt translation tables, configuration table), migrates and make
sure the translation is correct on the destination.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/gic.c                | 55 +++++++++++++++++++++++++++++++++++++---
 arm/unittests.cfg        |  7 +++++
 lib/arm/asm/gic-v3-its.h |  2 ++
 lib/arm/gic-v3-its.c     | 22 ++++++++++++++++
 4 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 6b73258..8cca743 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -642,13 +642,19 @@ static int its_prerequisites(int nb_cpus)
 	return 0;
 }
=20
-static void test_its_trigger(void)
+/*
+ * Setup the configuration for those mappings:
+ * dev_id=3D2 event=3D20 -> vcpu 3, intid=3D8195
+ * dev_id=3D7 event=3D255 -> vcpu 2, intid=3D8196
+ * LPIs ready to hit
+ */
+static int its_setup1(void)
 {
 	struct its_collection *col3, *col2;
 	struct its_device *dev2, *dev7;
=20
 	if (its_prerequisites(4))
-		return;
+		return -1;
=20
 	dev2 =3D its_create_device(2 /* dev id */, 8 /* nb_ites */);
 	dev7 =3D its_create_device(7 /* dev id */, 8 /* nb_ites */);
@@ -662,8 +668,6 @@ static void test_its_trigger(void)
 	its_send_invall(col2);
 	its_send_invall(col3);
=20
-	report_prefix_push("int");
-
 	its_send_mapd(dev2, true);
 	its_send_mapd(dev7, true);
=20
@@ -674,6 +678,23 @@ static void test_its_trigger(void)
 		       20 /* event id */, col3);
 	its_send_mapti(dev7, 8196 /* lpi id */,
 		       255 /* event id */, col2);
+	return 0;
+}
+
+static void test_its_trigger(void)
+{
+	struct its_collection *col3, *col2;
+	struct its_device *dev2, *dev7;
+
+	if (its_setup1())
+		return;
+
+	col3 =3D its_get_collection(3);
+	col2 =3D its_get_collection(2);
+	dev2 =3D its_get_device(2);
+	dev7 =3D its_get_device(7);
+
+	report_prefix_push("int");
=20
 	lpi_stats_expect(3, 8195);
 	its_send_int(dev2, 20);
@@ -722,6 +743,28 @@ static void test_its_trigger(void)
 	check_lpi_stats();
 }
=20
+static void test_its_migration(void)
+{
+	struct its_device *dev2, *dev7;
+
+	if (its_setup1())
+		return;
+
+	dev2 =3D its_get_device(2);
+	dev7 =3D its_get_device(7);
+
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report(true, "Migration complete");
+
+	lpi_stats_expect(3, 8195);
+	its_send_int(dev2, 20);
+	check_lpi_stats();
+
+	lpi_stats_expect(2, 8196);
+	its_send_int(dev7, 255);
+	check_lpi_stats();
+}
=20
 int main(int argc, char **argv)
 {
@@ -757,6 +800,10 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		test_its_trigger();
 		report_prefix_pop();
+	} else if (!strcmp(argv[1], "its-migration")) {
+		report_prefix_push(argv[1]);
+		test_its_migration();
+		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") =3D=3D 0) {
 		report_prefix_push(argv[1]);
 		test_its_introspection();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 80a1d27..29e2efc 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -140,6 +140,13 @@ smp =3D $MAX_SMP
 extra_params =3D -machine gic-version=3D3 -append 'its-trigger'
 groups =3D its
=20
+[its-migration]
+file =3D gic.flat
+smp =3D $MAX_SMP
+accel =3D kvm
+extra_params =3D -machine gic-version=3D3 -append 'its-migration'
+groups =3D its migration
+
 # Test PSCI emulation
 [psci]
 file =3D psci.flat
diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index d4fd799..c38d524 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -206,6 +206,8 @@ extern void its_send_movi(struct its_device *dev,
 			  struct its_collection *col, u32 id);
 extern void its_send_sync(struct its_collection *col);
 extern void its_print_cmd_state(void);
+extern struct its_device *its_get_device(u32 id);
+extern struct its_collection *its_get_collection(u32 id);
=20
 #define ITS_FLAGS_CMDQ_NEEDS_FLUSHING           (1ULL << 0)
 #define ITS_FLAGS_WORKAROUND_CAVIUM_22375       (1ULL << 1)
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index 9906428..e2e289c 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -330,3 +330,25 @@ struct its_collection *its_create_collection(u32 col=
_id, u32 pe)
 	its_data.nb_collections++;
 	return new;
 }
+
+struct its_device *its_get_device(u32 id)
+{
+	int i;
+
+	for (i =3D 0; i < GITS_MAX_DEVICES; i++) {
+		if (its_data.devices[i].device_id =3D=3D id)
+			return &its_data.devices[i];
+	}
+	return NULL;
+}
+
+struct its_collection *its_get_collection(u32 id)
+{
+	int i;
+
+	for (i =3D 0; i < GITS_MAX_COLLECTIONS; i++) {
+		if (its_data.collections[i].col_id =3D=3D id)
+			return &its_data.collections[i];
+	}
+	return NULL;
+}
--=20
2.20.1

