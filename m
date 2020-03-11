Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46ACF181A5B
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 14:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbgCKNwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 09:52:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47819 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729521AbgCKNwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 09:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583934758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zECjVFYjuMESRPqHn8ki0Be8AU/6x/A1tFUhMH7auRI=;
        b=iuoeHHvjXSUbeyZYzq4VporGvR9I6nprdqFSSbbdNeb3RZNLOOt5VRChoe4O6aB/ZVzzqh
        PFeZg5RTSK/uZrih1U6Y88g/YmGKDqljy4d3hGdhVtv0ZKX88v4bgETEgiIE8KjfiY8Pq+
        NB0eUvzML8nwBY/Mmx19TgfZm+bdu0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-teRRPK9LPK6iCUCLmwaQvA-1; Wed, 11 Mar 2020 09:52:37 -0400
X-MC-Unique: teRRPK9LPK6iCUCLmwaQvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E21D800D4E;
        Wed, 11 Mar 2020 13:52:35 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.36.118.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A61A09296C;
        Wed, 11 Mar 2020 13:52:28 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v6 12/13] arm/arm64: ITS: migration tests
Date:   Wed, 11 Mar 2020 14:51:16 +0100
Message-Id: <20200311135117.9366-13-eric.auger@redhat.com>
In-Reply-To: <20200311135117.9366-1-eric.auger@redhat.com>
References: <20200311135117.9366-1-eric.auger@redhat.com>
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
v4 -> v5:
- move stub from header to arm/gic.c

v3 -> v4:
- assert in its_get_device/collection if the id is not found
---
 arm/gic.c                  | 58 ++++++++++++++++++++++++++++++++++----
 arm/unittests.cfg          |  8 ++++++
 lib/arm64/asm/gic-v3-its.h |  3 ++
 lib/arm64/gic-v3-its.c     | 22 +++++++++++++++
 4 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 5f1e595..6ecfdbc 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -590,6 +590,7 @@ static void gic_test_mmio(void)
=20
 static void test_its_introspection(void) {}
 static void test_its_trigger(void) {}
+static void test_its_migration(void) {}
=20
 #else /* __aarch64__ */
=20
@@ -658,13 +659,19 @@ static int its_prerequisites(int nb_cpus)
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
@@ -675,14 +682,10 @@ static void test_its_trigger(void)
 	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
 	gicv3_lpi_set_config(8196, LPI_PROP_DEFAULT);
=20
-	report_prefix_push("int");
 	/*
 	 * dev=3D2, eventid=3D20  -> lpi=3D 8195, col=3D3
 	 * dev=3D7, eventid=3D255 -> lpi=3D 8196, col=3D2
-	 * Trigger dev2, eventid=3D20 and dev7, eventid=3D255
-	 * Check both LPIs hit
 	 */
-
 	its_send_mapd(dev2, true);
 	its_send_mapd(dev7, true);
=20
@@ -694,6 +697,22 @@ static void test_its_trigger(void)
=20
 	its_send_mapti(dev2, 8195 /* lpi id */, 20 /* event id */, col3);
 	its_send_mapti(dev7, 8196 /* lpi id */, 255 /* event id */, col2);
+	return 0;
+}
+
+static void test_its_trigger(void)
+{
+	struct its_collection *col3;
+	struct its_device *dev2, *dev7;
+
+	if (its_setup1())
+		return;
+
+	col3 =3D its_get_collection(3);
+	dev2 =3D its_get_device(2);
+	dev7 =3D its_get_device(7);
+
+	report_prefix_push("int");
=20
 	lpi_stats_expect(3, 8195);
 	its_send_int(dev2, 20);
@@ -748,6 +767,29 @@ static void test_its_trigger(void)
 	check_lpi_stats("no LPI after device unmap");
 	report_prefix_pop();
 }
+
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
+	report_info("Migration complete");
+
+	lpi_stats_expect(3, 8195);
+	its_send_int(dev2, 20);
+	check_lpi_stats("dev2/eventid=3D20 triggers LPI 8195 en PE #3 after mig=
ration");
+
+	lpi_stats_expect(2, 8196);
+	its_send_int(dev7, 255);
+	check_lpi_stats("dev7/eventid=3D255 triggers LPI 8196 on PE #2 after mi=
gration");
+}
 #endif
=20
 int main(int argc, char **argv)
@@ -785,6 +827,10 @@ int main(int argc, char **argv)
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
index b9a7a2c..480adec 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -136,6 +136,14 @@ extra_params =3D -machine gic-version=3D3 -append 'i=
ts-trigger'
 groups =3D its
 arch =3D arm64
=20
+[its-migration]
+file =3D gic.flat
+smp =3D $MAX_SMP
+accel =3D kvm
+extra_params =3D -machine gic-version=3D3 -append 'its-migration'
+groups =3D its migration
+arch =3D arm64
+
 # Test PSCI emulation
 [psci]
 file =3D psci.flat
diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
index 614a8bb..872953c 100644
--- a/lib/arm64/asm/gic-v3-its.h
+++ b/lib/arm64/asm/gic-v3-its.h
@@ -164,4 +164,7 @@ extern void __its_send_sync(struct its_collection *co=
l, bool verbose);
 #define its_send_movi_nv(dev, col, id)			__its_send_movi(dev, col, id, f=
alse)
 #define its_send_sync_nv(col)				__its_send_sync(col, false)
=20
+extern struct its_device *its_get_device(u32 id);
+extern struct its_collection *its_get_collection(u32 id);
+
 #endif /* _ASMARM64_GIC_V3_ITS_H_ */
diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
index 442dcf0..9c9fa60 100644
--- a/lib/arm64/gic-v3-its.c
+++ b/lib/arm64/gic-v3-its.c
@@ -148,3 +148,25 @@ struct its_collection *its_create_collection(u32 col=
_id, u32 pe)
 	its_data.nr_collections++;
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
+	assert(0);
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
+	assert(0);
+}
--=20
2.20.1

