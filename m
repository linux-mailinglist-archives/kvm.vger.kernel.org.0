Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB15014B2C4
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 11:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgA1Kg0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 05:36:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28938 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726281AbgA1Kg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 05:36:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580207785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ubJcGFSByeAYXmA6ZsXY2QS9ypGCX/uJRAkeSeWnSn8=;
        b=LujidaQNPhdQadnWYKyHegBS9v5j6zNNLqwFvHJkAUDADz7JM3LbETTSvTMocn0z8jkXhl
        iabEpSwVMai++7D7DnlBRWuTxSgGGOt3kopG0rv7uVyIdMhUzNh9UJI/bsECPcWUlEyMQ0
        1WbQHthmz6tVy25dOjmkied2PRcr3cg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-DQXSTh9CMxKCq8ZczajPmw-1; Tue, 28 Jan 2020 05:36:23 -0500
X-MC-Unique: DQXSTh9CMxKCq8ZczajPmw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF2DBDB60;
        Tue, 28 Jan 2020 10:36:21 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 362721001B30;
        Tue, 28 Jan 2020 10:36:15 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 09/14] arm/arm64: ITS: Device and collection Initialization
Date:   Tue, 28 Jan 2020 11:34:54 +0100
Message-Id: <20200128103459.19413-10-eric.auger@redhat.com>
In-Reply-To: <20200128103459.19413-1-eric.auger@redhat.com>
References: <20200128103459.19413-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

v2 -> v3:
- s/report_abort/assert

v1 -> v2:
- s/nb_/nr_
---
 lib/arm/asm/gic-v3-its.h | 20 +++++++++++++++++-
 lib/arm/gic-v3-its.c     | 44 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index fe73c04..acd97a9 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -31,6 +31,19 @@ struct its_baser {
 };
=20
 #define GITS_BASER_NR_REGS              8
+#define GITS_MAX_DEVICES		8
+#define GITS_MAX_COLLECTIONS		8
+
+struct its_device {
+	u32 device_id;	/* device ID */
+	u32 nr_ites;	/* Max Interrupt Translation Entries */
+	void *itt;	/* Interrupt Translation Table GPA */
+};
+
+struct its_collection {
+	u64 target_address;
+	u16 col_id;
+};
=20
 struct its_data {
 	void *base;
@@ -38,6 +51,10 @@ struct its_data {
 	struct its_baser baser[GITS_BASER_NR_REGS];
 	struct its_cmd_block *cmd_base;
 	struct its_cmd_block *cmd_write;
+	struct its_device devices[GITS_MAX_DEVICES];
+	u32 nr_devices;		/* Allocated Devices */
+	struct its_collection collections[GITS_MAX_COLLECTIONS];
+	u32 nr_collections;	/* Allocated Collections */
 };
=20
 extern struct its_data its_data;
@@ -90,7 +107,6 @@ extern struct its_data its_data;
 #define GITS_BASER_TYPE_DEVICE		1
 #define GITS_BASER_TYPE_COLLECTION	4
=20
-
 struct its_cmd_block {
 	u64 raw_cmd[4];
 };
@@ -100,6 +116,8 @@ extern void its_init(void);
 extern int its_parse_baser(int i, struct its_baser *baser);
 extern struct its_baser *its_lookup_baser(int type);
 extern void its_enable_defaults(void);
+extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
+extern struct its_collection *its_create_collection(u32 col_id, u32 targ=
et_pe);
=20
 #else /* __arm__ */
=20
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index d1e7e52..c2dcd01 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -175,3 +175,47 @@ void its_enable_defaults(void)
=20
 	writel(GITS_CTLR_ENABLE, its_data.base + GITS_CTLR);
 }
+
+struct its_device *its_create_device(u32 device_id, int nr_ites)
+{
+	struct its_baser *baser;
+	struct its_device *new;
+	unsigned long n, order;
+
+	assert(its_data.nr_devices < GITS_MAX_DEVICES);
+
+	baser =3D its_lookup_baser(GITS_BASER_TYPE_DEVICE);
+	if (!baser)
+		return NULL;
+
+	new =3D &its_data.devices[its_data.nr_devices];
+
+	new->device_id =3D device_id;
+	new->nr_ites =3D nr_ites;
+
+	n =3D (its_data.typer.ite_size * nr_ites) >> PAGE_SHIFT;
+	order =3D is_power_of_2(n) ? fls(n) : fls(n) + 1;
+	new->itt =3D (void *)virt_to_phys(alloc_pages(order));
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

