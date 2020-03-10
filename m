Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95711800C3
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 15:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgCJOzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 10:55:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60997 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727650AbgCJOzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 10:55:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583852108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dAVG56X+6csWDSwqTHTjLZjsQD1ORBj1oN7BRQ6tzIs=;
        b=M2gipR06JvO4h6VUX6QhJlxbHDCl1ZLxDgGMF+7mUBwhLnSvS/mx2Qc8cR1r5V5HEJLMVS
        RWheIT1d4CZ+e7hrwU3tvXmYiY8A2Z3cUWajd9F4BNpSB+zVekB5LVN9/eP1yFiHTjklW0
        5r8BEoZ3Cvh+nH1+iqIVD1BNdEnGd9k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-ZZ7gt7pEPiG9NA2c8Qq4og-1; Tue, 10 Mar 2020 10:55:07 -0400
X-MC-Unique: ZZ7gt7pEPiG9NA2c8Qq4og-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E6D3800D50;
        Tue, 10 Mar 2020 14:55:05 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-117-85.ams2.redhat.com [10.36.117.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A870F60BF3;
        Tue, 10 Mar 2020 14:54:55 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v5 08/13] arm/arm64: ITS: Device and collection Initialization
Date:   Tue, 10 Mar 2020 15:54:05 +0100
Message-Id: <20200310145410.26308-9-eric.auger@redhat.com>
In-Reply-To: <20200310145410.26308-1-eric.auger@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce an helper functions to register
- a new device, characterized by its device id and the
  max number of event IDs that dimension its ITT (Interrupt
  Translation Table).  The function allocates the ITT.

- a new collection, characterized by its ID and the
  target processing engine (PE).

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v3 -> v4:
- remove unused its_baser variable from its_create_device()
- use get_order()
- device->itt becomes a GVA instead of GPA

v2 -> v3:
- s/report_abort/assert

v1 -> v2:
- s/nb_/nr_
---
 lib/arm64/asm/gic-v3-its.h | 19 +++++++++++++++++++
 lib/arm64/gic-v3-its.c     | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
index 1e95977..3da548b 100644
--- a/lib/arm64/asm/gic-v3-its.h
+++ b/lib/arm64/asm/gic-v3-its.h
@@ -27,6 +27,19 @@ struct its_baser {
 };
=20
 #define GITS_BASER_NR_REGS              8
+#define GITS_MAX_DEVICES		8
+#define GITS_MAX_COLLECTIONS		8
+
+struct its_device {
+	u32 device_id;	/* device ID */
+	u32 nr_ites;	/* Max Interrupt Translation Entries */
+	void *itt;	/* Interrupt Translation Table GVA */
+};
+
+struct its_collection {
+	u64 target_address;
+	u16 col_id;
+};
=20
 struct its_data {
 	void *base;
@@ -35,6 +48,10 @@ struct its_data {
 	struct its_baser coll_baser;
 	struct its_cmd_block *cmd_base;
 	struct its_cmd_block *cmd_write;
+	struct its_device devices[GITS_MAX_DEVICES];
+	u32 nr_devices;		/* Allocated Devices */
+	struct its_collection collections[GITS_MAX_COLLECTIONS];
+	u32 nr_collections;	/* Allocated Collections */
 };
=20
 extern struct its_data its_data;
@@ -89,5 +106,7 @@ extern void its_parse_typer(void);
 extern void its_init(void);
 extern int its_baser_lookup(int i, struct its_baser *baser);
 extern void its_enable_defaults(void);
+extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
+extern struct its_collection *its_create_collection(u32 col_id, u32 targ=
et_pe);
=20
 #endif /* _ASMARM64_GIC_V3_ITS_H_ */
diff --git a/lib/arm64/gic-v3-its.c b/lib/arm64/gic-v3-its.c
index c431f31..442dcf0 100644
--- a/lib/arm64/gic-v3-its.c
+++ b/lib/arm64/gic-v3-its.c
@@ -110,3 +110,41 @@ void its_enable_defaults(void)
=20
 	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
 }
+
+struct its_device *its_create_device(u32 device_id, int nr_ites)
+{
+	struct its_device *new;
+	unsigned long n;
+
+	assert(its_data.nr_devices < GITS_MAX_DEVICES);
+
+	new =3D &its_data.devices[its_data.nr_devices];
+
+	new->device_id =3D device_id;
+	new->nr_ites =3D nr_ites;
+
+	n =3D (its_data.typer.ite_size * nr_ites) >> PAGE_SHIFT;
+	new->itt =3D alloc_pages(get_order(n));
+
+	its_data.nr_devices++;
+	return new;
+}
+
+struct its_collection *its_create_collection(u32 col_id, u32 pe)
+{
+	struct its_collection *new;
+
+	assert(its_data.nr_collections < GITS_MAX_COLLECTIONS);
+
+	new =3D &its_data.collections[its_data.nr_collections];
+
+	new->col_id =3D col_id;
+
+	if (its_data.typer.pta)
+		new->target_address =3D (u64)gicv3_data.redist_base[pe];
+	else
+		new->target_address =3D pe << 16;
+
+	its_data.nr_collections++;
+	return new;
+}
--=20
2.20.1

