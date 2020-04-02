Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC85419C4F5
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 16:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388933AbgDBOyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 10:54:11 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31574 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388830AbgDBOyK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Apr 2020 10:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585839249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QhrZeK5drwApiePPY4lvBKjmy/lVD4J+Wgvu5CSrsas=;
        b=VCm7gjbi4eSie3Hv3l8537M65R/tn+Z7keFBlICGVY9/sQtPXBaE1tCVV0s1crkwBFAgmp
        bSiozr90NB04Vvzmg0I74FHSzBQhP1d+rmKWs3heZHHejVG1EVD4LTmXWHQxaN4dxd6yD/
        dgAqHNl1wHZ66VOn6FdU1JZyygd18YA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-wnr8vXZKObeps7E-lb9zaA-1; Thu, 02 Apr 2020 10:54:08 -0400
X-MC-Unique: wnr8vXZKObeps7E-lb9zaA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F02618C35A1;
        Thu,  2 Apr 2020 14:54:05 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C7755D9C9;
        Thu,  2 Apr 2020 14:53:54 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v8 13/13] arm/arm64: ITS: pending table migration test
Date:   Thu,  2 Apr 2020 16:52:27 +0200
Message-Id: <20200402145227.20109-14-eric.auger@redhat.com>
In-Reply-To: <20200402145227.20109-1-eric.auger@redhat.com>
References: <20200402145227.20109-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add two new migration tests. One testing the migration of
a topology where collection were unmapped. The second test
checks the migration of the pending table.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v7 -> v8:
- removed set_lpi()
- change expected alloc, ie. s/malloc/calloc,
  this latter does memset()

v6 -> v7:
- test_migrate_unmapped_collection now uses pe0=3D0. Otherwise,
  depending on SMP value it collides with collections created
  by setup1()
- use of for_each_present_cpu

v5 -> v6:
- s/Set the PTZ/Clear the PTZ
- Move the collection inval after MAPC
- remove the unmap collection test

v4 -> v5:
- move stub from header to arm/gic.c

v3 -> v4:
- do not talk about odd/even CPUs, use pe0 and pe1
- comment the delay

v2 -> v3:
- tests belong to both its and migration groups
- use LPI(i)
- gicv3_lpi_set_pending_table_bit renamed into gicv3_lpi_set_clr_pending
---
 arm/gic.c         | 130 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  16 ++++++
 2 files changed, 146 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index 6ae5515..ddf0f9d 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -193,6 +193,7 @@ static void lpi_handler(struct pt_regs *regs __unused=
)
 	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
 	lpi_stats.observed.cpu_id =3D smp_processor_id();
 	lpi_stats.observed.lpi_id =3D irqnr;
+	acked[lpi_stats.observed.cpu_id]++;
 	smp_wmb(); /* pairs with rmb in check_lpi_stats */
 }
=20
@@ -238,6 +239,22 @@ static void secondary_lpi_test(void)
 	while (1)
 		wfi();
 }
+
+static void check_lpi_hits(int *expected, const char *msg)
+{
+	bool pass =3D true;
+	int i;
+
+	for_each_present_cpu(i) {
+		if (acked[i] !=3D expected[i]) {
+			report_info("expected %d LPIs on PE #%d, %d observed",
+				    expected[i], i, acked[i]);
+			pass =3D false;
+			break;
+		}
+	}
+	report(pass, "%s", msg);
+}
 #endif
=20
 static void gicv2_ipi_send_self(void)
@@ -593,6 +610,8 @@ static void gic_test_mmio(void)
 static void test_its_introspection(void) {}
 static void test_its_trigger(void) {}
 static void test_its_migration(void) {}
+static void test_its_pending_migration(void) {}
+static void test_migrate_unmapped_collection(void) {}
=20
 #else /* __aarch64__ */
=20
@@ -792,6 +811,109 @@ static void test_its_migration(void)
 	its_send_int(dev7, 255);
 	check_lpi_stats("dev7/eventid=3D255 triggers LPI 8196 on PE #2 after mi=
gration");
 }
+
+static void test_migrate_unmapped_collection(void)
+{
+	struct its_collection *col;
+	struct its_device *dev2, *dev7;
+	int pe0 =3D 0;
+	u8 config;
+
+	if (its_setup1())
+		return;
+
+	col =3D its_create_collection(pe0, pe0);
+	dev2 =3D its_get_device(2);
+	dev7 =3D its_get_device(7);
+
+	/* MAPTI with the collection unmapped */
+	its_send_mapti(dev2, 8192, 0, col);
+	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
+
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report_info("Migration complete");
+
+	/* on the destination, map the collection */
+	its_send_mapc(col, true);
+	its_send_invall(col);
+
+	lpi_stats_expect(2, 8196);
+	its_send_int(dev7, 255);
+	check_lpi_stats("dev7/eventid=3D 255 triggered LPI 8196 on PE #2");
+
+	config =3D gicv3_lpi_get_config(8192);
+	report(config =3D=3D LPI_PROP_DEFAULT,
+	       "Config of LPI 8192 was properly migrated");
+
+	lpi_stats_expect(pe0, 8192);
+	its_send_int(dev2, 0);
+	check_lpi_stats("dev2/eventid =3D 0 triggered LPI 8192 on PE0");
+}
+
+static void test_its_pending_migration(void)
+{
+	struct its_device *dev;
+	struct its_collection *collection[2];
+	int *expected =3D calloc(nr_cpus, sizeof(int));
+	int pe0 =3D nr_cpus - 1, pe1 =3D nr_cpus - 2;
+	u64 pendbaser;
+	void *ptr;
+	int i;
+
+	if (its_prerequisites(4))
+		return;
+
+	dev =3D its_create_device(2 /* dev id */, 8 /* nb_ites */);
+	its_send_mapd(dev, true);
+
+	collection[0] =3D its_create_collection(pe0, pe0);
+	collection[1] =3D its_create_collection(pe1, pe1);
+	its_send_mapc(collection[0], true);
+	its_send_mapc(collection[1], true);
+
+	/* disable lpi at redist level */
+	gicv3_lpi_rdist_disable(pe0);
+	gicv3_lpi_rdist_disable(pe1);
+
+	/* lpis are interleaved inbetween the 2 PEs */
+	for (i =3D 0; i < 256; i++) {
+		struct its_collection *col =3D i % 2 ? collection[0] :
+						     collection[1];
+		int vcpu =3D col->target_address >> 16;
+
+		its_send_mapti(dev, LPI(i), i, col);
+		gicv3_lpi_set_config(LPI(i), LPI_PROP_DEFAULT);
+		gicv3_lpi_set_clr_pending(vcpu, LPI(i), true);
+	}
+	its_send_invall(collection[0]);
+	its_send_invall(collection[1]);
+
+	/* Clear the PTZ bit on each pendbaser */
+
+	expected[pe0] =3D 128;
+	expected[pe1] =3D 128;
+
+	ptr =3D gicv3_data.redist_base[pe0] + GICR_PENDBASER;
+	pendbaser =3D readq(ptr);
+	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
+
+	ptr =3D gicv3_data.redist_base[pe1] + GICR_PENDBASER;
+	pendbaser =3D readq(ptr);
+	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
+
+	gicv3_lpi_rdist_enable(pe0);
+	gicv3_lpi_rdist_enable(pe1);
+
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report_info("Migration complete");
+
+	/* let's wait for the 256 LPIs to be handled */
+	mdelay(1000);
+
+	check_lpi_hits(expected, "128 LPIs on both PE0 and PE1 after migration"=
);
+}
 #endif
=20
 int main(int argc, char **argv)
@@ -833,6 +955,14 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		test_its_migration();
 		report_prefix_pop();
+	} else if (!strcmp(argv[1], "its-pending-migration")) {
+		report_prefix_push(argv[1]);
+		test_its_pending_migration();
+		report_prefix_pop();
+	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection")) {
+		report_prefix_push(argv[1]);
+		test_migrate_unmapped_collection();
+		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") =3D=3D 0) {
 		report_prefix_push(argv[1]);
 		test_its_introspection();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 480adec..b96f0a1 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -144,6 +144,22 @@ extra_params =3D -machine gic-version=3D3 -append 'i=
ts-migration'
 groups =3D its migration
 arch =3D arm64
=20
+[its-pending-migration]
+file =3D gic.flat
+smp =3D $MAX_SMP
+accel =3D kvm
+extra_params =3D -machine gic-version=3D3 -append 'its-pending-migration=
'
+groups =3D its migration
+arch =3D arm64
+
+[its-migrate-unmapped-collection]
+file =3D gic.flat
+smp =3D $MAX_SMP
+accel =3D kvm
+extra_params =3D -machine gic-version=3D3 -append 'its-migrate-unmapped-=
collection'
+groups =3D its migration
+arch =3D arm64
+
 # Test PSCI emulation
 [psci]
 file =3D psci.flat
--=20
2.20.1

