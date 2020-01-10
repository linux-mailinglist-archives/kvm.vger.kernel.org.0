Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61C7113704E
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 15:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgAJOzF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 09:55:05 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40936 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728395AbgAJOyy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jan 2020 09:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578668093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=So3e0V/LUBPnehm9Y9Au2M9MYM91iN9NSNK40gnxpnE=;
        b=Y23bUA2INRJS2yeqy3wG9avsoHgfPeTvd7d5nX98FzDZG3lAJoWHdxErTx3C610MZ8Jpz3
        hctDpabopwoTm5KPlNLoXGwDa0jjc2uJ1/4HjnNgrjoJNq/v6NnzhFTbYFuXyGx0cTl3R0
        XnSaD2c+fKNT0SHhk0oxJyNw6Fn2+EQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-t4h7zcAyMMmPAqIqHvdivw-1; Fri, 10 Jan 2020 09:54:51 -0500
X-MC-Unique: t4h7zcAyMMmPAqIqHvdivw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF2CE107ACC9;
        Fri, 10 Jan 2020 14:54:49 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-108.ams2.redhat.com [10.36.117.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 106DB7BA5F;
        Fri, 10 Jan 2020 14:54:46 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 06/16] arm/arm64: ITS: Test BASER
Date:   Fri, 10 Jan 2020 15:54:02 +0100
Message-Id: <20200110145412.14937-7-eric.auger@redhat.com>
In-Reply-To: <20200110145412.14937-1-eric.auger@redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
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

v2 -> v3:
- remove everything related to memory attributes
- s/dev_baser/coll_baser/ in report_info
- add extra line
- removed index filed in its_baser
---
 arm/gic.c                | 21 ++++++++++-
 arm/unittests.cfg        |  6 +++
 lib/arm/asm/gic-v3-its.h | 14 +++++++
 lib/arm/gic-v3-its.c     | 80 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/arm/gic.c b/arm/gic.c
index adeb981..3597ac3 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -531,11 +531,26 @@ static void test_its_introspection(void)
 		    typer->collid_bits);
 	report(typer->eventid_bits && typer->deviceid_bits &&
 	       typer->collid_bits, "ID spaces");
-	report(!typer->hw_collections, "collections only in ext memory");
 	report_info("Target address format %s",
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
+	report_info("collection baser entry_size =3D 0x%x", coll_baser->esz);
+}
+
 int main(int argc, char **argv)
 {
 	if (!gic_init()) {
@@ -571,6 +586,10 @@ int main(int argc, char **argv)
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
index 8816d57..5a4dfe9 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -65,9 +65,20 @@ struct its_typer {
 	bool virt_lpi;
 };
=20
+struct its_baser {
+	int type;
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
@@ -76,6 +87,9 @@ extern struct its_data its_data;
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
index ce607bb..79946c3 100644
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
@@ -29,11 +30,90 @@ void its_parse_typer(void)
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
+
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

