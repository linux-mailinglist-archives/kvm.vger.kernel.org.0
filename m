Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 521F819E5E3
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgDDOjg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:39:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42926 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726683AbgDDOjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 10:39:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uvnZtk9MYZ3Ee6O6BcV8wY1ClITdYU83OUWZcVLM8OQ=;
        b=IWPv0Z/lQOiLdnQf3sKe+pvSrQia7JeP77NR+odZUSC/TPl5aBdwaKadVFGn0ER2B9MQAp
        q68b/lDcd+n5aQM/bjIx4lBsrpnJkH+KiI+J0Xxjwl3TgjB1oB6ZNqui/cTF3o1Gs4EWJ8
        jhbBr5V8TozoesWrwWHLKprpjsGOrcQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-q4bsuQKJOnOrl5rpaXtw8A-1; Sat, 04 Apr 2020 10:39:32 -0400
X-MC-Unique: q4bsuQKJOnOrl5rpaXtw8A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57D6E8017CE;
        Sat,  4 Apr 2020 14:39:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0810A9B912;
        Sat,  4 Apr 2020 14:39:29 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Eric Auger <eric.auger@redhat.com>
Subject: [PULL kvm-unit-tests 39/39] arm/arm64: ITS: pending table migration test
Date:   Sat,  4 Apr 2020 16:37:31 +0200
Message-Id: <20200404143731.208138-40-drjones@redhat.com>
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

Add two new migration tests. One testing the migration of
a topology where collection were unmapped. The second test
checks the migration of the pending table.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
[ Complete migration even when the test is skipped. Otherwise the
  migration scripts hang. Also, without the KVM fix for unmapped
  collections, migration will fail and the test will hang, so use
  errata to skip it instead. ]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c         | 152 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  16 +++++
 errata.txt        |   1 +
 3 files changed, 169 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index d98d70a5d9e9..dc1e88c67a9c 100644
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
@@ -193,6 +194,7 @@ static void lpi_handler(struct pt_regs *regs __unused=
)
 	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
 	lpi_stats.observed.cpu_id =3D smp_processor_id();
 	lpi_stats.observed.lpi_id =3D irqnr;
+	acked[lpi_stats.observed.cpu_id]++;
 	smp_wmb(); /* pairs with rmb in check_lpi_stats */
 }
=20
@@ -238,6 +240,22 @@ static void secondary_lpi_test(void)
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
@@ -593,6 +611,8 @@ static void gic_test_mmio(void)
 static void test_its_introspection(void) {}
 static void test_its_trigger(void) {}
 static void test_its_migration(void) {}
+static void test_its_pending_migration(void) {}
+static void test_migrate_unmapped_collection(void) {}
=20
 #else /* __aarch64__ */
=20
@@ -798,6 +818,130 @@ do_migrate:
 	its_send_int(dev7, 255);
 	check_lpi_stats("dev7/eventid=3D255 triggers LPI 8196 on PE #2 after mi=
gration");
 }
+
+#define ERRATA_UNMAPPED_COLLECTIONS "ERRATA_8c58be34494b"
+
+static void test_migrate_unmapped_collection(void)
+{
+	struct its_collection *col =3D NULL;
+	struct its_device *dev2 =3D NULL, *dev7 =3D NULL;
+	bool test_skipped =3D false;
+	int pe0 =3D 0;
+	u8 config;
+
+	if (its_setup1()) {
+		test_skipped =3D true;
+		goto do_migrate;
+	}
+
+	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
+		report_skip("Skipping test, as this test hangs without the fix. "
+			    "Set %s=3Dy to enable.", ERRATA_UNMAPPED_COLLECTIONS);
+		test_skipped =3D true;
+		goto do_migrate;
+	}
+
+	col =3D its_create_collection(pe0, pe0);
+	dev2 =3D its_get_device(2);
+	dev7 =3D its_get_device(7);
+
+	/* MAPTI with the collection unmapped */
+	its_send_mapti(dev2, 8192, 0, col);
+	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
+
+do_migrate:
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report_info("Migration complete");
+	if (test_skipped)
+		return;
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
+	bool test_skipped =3D false;
+	u64 pendbaser;
+	void *ptr;
+	int i;
+
+	if (its_prerequisites(4)) {
+		test_skipped =3D true;
+		goto do_migrate;
+	}
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
+do_migrate:
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report_info("Migration complete");
+	if (test_skipped)
+		return;
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
@@ -839,6 +983,14 @@ int main(int argc, char **argv)
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
index 20a1ae269571..f776b66ef96d 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -199,6 +199,22 @@ extra_params =3D -machine gic-version=3D3 -append 'i=
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

