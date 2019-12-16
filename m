Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6BB1207EF
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 15:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfLPOEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 09:04:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55760 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728085AbfLPOED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 09:04:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576505041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XB5s37rAPv1BzFFArVrq1786MkybtY4z+dn+u1KH+UE=;
        b=GBpT9wgFsiqCBwL1qL8i0ZjoimNi2wlht3Z6STIn+N5GBCf9aZcrGtmgBfngh+WJTCEPvM
        qKumrRLvLYWpr+f7VbRl4c5gLfCvDoU6P1gScsc40YJjxMMwgXPjTU+fNgDHaVg4fUoIsx
        l7IsQ+KB++pz7brJSp3Qmst7JKMN6c4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-394-4Pdl_56RMCGLwFQgWWRfxw-1; Mon, 16 Dec 2019 09:04:00 -0500
X-MC-Unique: 4Pdl_56RMCGLwFQgWWRfxw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA4FC107ACC9;
        Mon, 16 Dec 2019 14:03:57 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2565675BE;
        Mon, 16 Dec 2019 14:03:54 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 06/16] arm/arm64: ITS: Test BASER
Date:   Mon, 16 Dec 2019 15:02:25 +0100
Message-Id: <20191216140235.10751-7-eric.auger@redhat.com>
In-Reply-To: <20191216140235.10751-1-eric.auger@redhat.com>
References: <20191216140235.10751-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helper routines to parse and set up BASER registers.
Add a new test dedicated to BASER<n> accesses.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/gic.c                | 20 ++++++++++
 arm/unittests.cfg        |  6 +++
 lib/arm/asm/gic-v3-its.h | 17 ++++++++
 lib/arm/gic-v3-its.c     | 84 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 127 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index adeb981..8b56fce 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -536,6 +536,22 @@ static void test_its_introspection(void)
 			typer->pta ? "Redist basse address" : "PE #");
 }
=20
+static void test_its_baser(void)
+{
+	struct its_baser *dev_baser, *coll_baser;
+
+	if (!gicv3_its_base()) {
+		report_skip("No ITS, skip ...");
+		return;
+	}
+
+	dev_baser =3D its_lookup_baser(GITS_BASER_TYPE_DEVICE);
+	coll_baser =3D its_lookup_baser(GITS_BASER_TYPE_COLLECTION);
+	report(dev_baser && coll_baser, "detect device and collection BASER");
+	report_info("device baser entry_size =3D 0x%x", dev_baser->esz);
+	report_info("collection baser entry_size =3D 0x%x", dev_baser->esz);
+}
+
 int main(int argc, char **argv)
 {
 	if (!gic_init()) {
@@ -571,6 +587,10 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		test_its_introspection();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "its-baser") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_its_baser();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index bd20460..2234a0f 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -128,6 +128,12 @@ smp =3D $MAX_SMP
 extra_params =3D -machine gic-version=3D3 -append 'its-introspection'
 groups =3D its
=20
+[its-baser]
+file =3D gic.flat
+smp =3D $MAX_SMP
+extra_params =3D -machine gic-version=3D3 -append 'its-baser'
+groups =3D its
+
 # Test PSCI emulation
 [psci]
 file =3D psci.flat
diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index 2ce483e..0c0178d 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -100,9 +100,23 @@ struct its_typer {
 	bool virt_lpi;
 };
=20
+struct its_baser {
+	unsigned int index;
+	int type;
+	u64 cache;
+	int shr;
+	size_t psz;
+	int nr_pages;
+	bool indirect;
+	phys_addr_t table_addr;
+	bool valid;
+	int esz;
+};
+
 struct its_data {
 	void *base;
 	struct its_typer typer;
+	struct its_baser baser[GITS_BASER_NR_REGS];
 };
=20
 extern struct its_data its_data;
@@ -111,6 +125,9 @@ extern struct its_data its_data;
=20
 extern void its_parse_typer(void);
 extern void its_init(void);
+extern int its_parse_baser(int i, struct its_baser *baser);
+extern void its_setup_baser(int i, struct its_baser *baser);
+extern struct its_baser *its_lookup_baser(int type);
=20
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_V3_ITS_H_ */
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index 34f4d0e..303022f 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -4,6 +4,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <asm/gic.h>
+#include <alloc_page.h>
=20
 struct its_data its_data;
=20
@@ -31,11 +32,94 @@ void its_parse_typer(void)
 	its_data.typer.phys_lpi =3D typer & GITS_TYPER_PLPIS;
 }
=20
+int its_parse_baser(int i, struct its_baser *baser)
+{
+	void *reg_addr =3D gicv3_its_base() + GITS_BASER + i * 8;
+	u64 val =3D readq(reg_addr);
+
+	if (!val) {
+		memset(baser, 0, sizeof(*baser));
+		return -1;
+	}
+
+	baser->valid =3D val & GITS_BASER_VALID;
+	baser->indirect =3D val & GITS_BASER_INDIRECT;
+	baser->type =3D GITS_BASER_TYPE(val);
+	baser->esz =3D GITS_BASER_ENTRY_SIZE(val);
+	baser->nr_pages =3D GITS_BASER_NR_PAGES(val);
+	baser->table_addr =3D val & GITS_BASER_PHYS_ADDR_MASK;
+	baser->cache =3D (val >> GITS_BASER_INNER_CACHEABILITY_SHIFT) &
+			GITS_BASER_CACHEABILITY_MASK;
+	switch (val & GITS_BASER_PAGE_SIZE_MASK) {
+	case GITS_BASER_PAGE_SIZE_4K:
+		baser->psz =3D SZ_4K;
+		break;
+	case GITS_BASER_PAGE_SIZE_16K:
+		baser->psz =3D SZ_16K;
+		break;
+	case GITS_BASER_PAGE_SIZE_64K:
+		baser->psz =3D SZ_64K;
+		break;
+	default:
+		baser->psz =3D SZ_64K;
+	}
+	baser->shr =3D (val >> 10) & 0x3;
+	return 0;
+}
+
+struct its_baser *its_lookup_baser(int type)
+{
+	int i;
+
+	for (i =3D 0; i < GITS_BASER_NR_REGS; i++) {
+		struct its_baser *baser =3D &its_data.baser[i];
+
+		if (baser->type =3D=3D type)
+			return baser;
+	}
+	return NULL;
+}
+
 void its_init(void)
 {
+	int i;
 	if (!its_data.base)
 		return;
=20
 	its_parse_typer();
+	for (i =3D 0; i < GITS_BASER_NR_REGS; i++)
+		its_parse_baser(i, &its_data.baser[i]);
+}
+
+void its_setup_baser(int i, struct its_baser *baser)
+{
+	unsigned long n =3D (baser->nr_pages * baser->psz) >> PAGE_SHIFT;
+	unsigned long order =3D is_power_of_2(n) ? fls(n) : fls(n) + 1;
+	u64 val;
+
+	baser->table_addr =3D (u64)virt_to_phys(alloc_pages(order));
+
+	val =3D ((u64)baser->table_addr					|
+		((u64)baser->type	<< GITS_BASER_TYPE_SHIFT)	|
+		((u64)(baser->esz - 1)	<< GITS_BASER_ENTRY_SIZE_SHIFT)	|
+		((baser->nr_pages - 1)	<< GITS_BASER_PAGES_SHIFT)	|
+		baser->cache						|
+		baser->shr						|
+		(u64)baser->indirect	<< 62				|
+		(u64)baser->valid	<< 63);
+
+	switch (baser->psz) {
+	case SZ_4K:
+		val |=3D GITS_BASER_PAGE_SIZE_4K;
+		break;
+	case SZ_16K:
+		val |=3D GITS_BASER_PAGE_SIZE_16K;
+		break;
+	case SZ_64K:
+		val |=3D GITS_BASER_PAGE_SIZE_64K;
+		break;
+	}
+
+	writeq(val, gicv3_its_base() + GITS_BASER + i * 8);
 }
=20
--=20
2.20.1

