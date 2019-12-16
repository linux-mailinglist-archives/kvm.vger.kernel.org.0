Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAB1512080D
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 15:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbfLPOFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 09:05:03 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52218 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728015AbfLPOFD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Dec 2019 09:05:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576505102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=50Vms+tgESY3M8NHXPohpfNztkjGMy8JPeeKVTKoeLA=;
        b=KMoKcd/hzZFs/Yn3HDNwIQQ2CUJbktmBs8RVkvQMnIrMaRJObiOnfIvhcr8VaT0gsrg3Ef
        utHKEGXaKaVcsZdzeh6Lo6QsEQi5fMhFYwFBh/d6BzhmLkzg2/mKS9XDgKEjem3zk6T1Dt
        oEu3ipmj1b9j8FNcL9GU4X/SwpyUUBU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-i2RWS0w7O9OR_4XEIYzBcg-1; Mon, 16 Dec 2019 09:04:19 -0500
X-MC-Unique: i2RWS0w7O9OR_4XEIYzBcg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CCD180257B;
        Mon, 16 Dec 2019 14:04:17 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3242968863;
        Mon, 16 Dec 2019 14:04:14 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH 11/16] arm/arm64: ITS: Device and collection Initialization
Date:   Mon, 16 Dec 2019 15:02:30 +0100
Message-Id: <20191216140235.10751-12-eric.auger@redhat.com>
In-Reply-To: <20191216140235.10751-1-eric.auger@redhat.com>
References: <20191216140235.10751-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
---
 lib/arm/asm/gic-v3-its.h | 20 +++++++++++++++++
 lib/arm/gic-v3-its.c     | 46 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
index ab639c5..245ef61 100644
--- a/lib/arm/asm/gic-v3-its.h
+++ b/lib/arm/asm/gic-v3-its.h
@@ -87,6 +87,9 @@
=20
 #define ITS_FLAGS_CMDQ_NEEDS_FLUSHING           (1ULL << 0)
=20
+#define GITS_MAX_DEVICES		8
+#define GITS_MAX_COLLECTIONS		8
+
 struct its_typer {
 	unsigned int ite_size;
 	unsigned int eventid_bits;
@@ -117,6 +120,17 @@ struct its_cmd_block {
 	u64     raw_cmd[4];
 };
=20
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
+
 struct its_data {
 	void *base;
 	struct its_typer typer;
@@ -124,6 +138,10 @@ struct its_data {
 	struct its_cmd_block *cmd_base;
 	struct its_cmd_block *cmd_write;
 	struct its_cmd_block *cmd_readr;
+	struct its_device devices[GITS_MAX_DEVICES];
+	u32 nb_devices;		/* Allocated Devices */
+	struct its_collection collections[GITS_MAX_COLLECTIONS];
+	u32 nb_collections;	/* Allocated Collections */
 };
=20
 extern struct its_data its_data;
@@ -140,6 +158,8 @@ extern u8 get_lpi_config(int n);
 extern void set_pending_table_bit(int rdist, int n, bool set);
 extern void gicv3_rdist_ctrl_lpi(u32 redist, bool set);
 extern void its_enable_defaults(void);
+extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
+extern struct its_collection *its_create_collection(u32 col_id, u32 targ=
et_pe);
=20
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_V3_ITS_H_ */
diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
index 9a51ef4..9906428 100644
--- a/lib/arm/gic-v3-its.c
+++ b/lib/arm/gic-v3-its.c
@@ -284,3 +284,49 @@ void its_enable_defaults(void)
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
+	if (its_data.nb_devices >=3D GITS_MAX_DEVICES)
+		report_abort("%s redimension GITS_MAX_DEVICES", __func__);
+
+	baser =3D its_lookup_baser(GITS_BASER_TYPE_DEVICE);
+	if (!baser)
+		return NULL;
+
+	new =3D &its_data.devices[its_data.nb_devices];
+
+	new->device_id =3D device_id;
+	new->nr_ites =3D nr_ites;
+
+	n =3D (baser->esz * nr_ites) >> PAGE_SHIFT;
+	order =3D is_power_of_2(n) ? fls(n) : fls(n) + 1;
+	new->itt =3D (void *)virt_to_phys(alloc_pages(order));
+
+	its_data.nb_devices++;
+	return new;
+}
+
+struct its_collection *its_create_collection(u32 col_id, u32 pe)
+{
+	struct its_collection *new;
+
+	if (its_data.nb_collections >=3D GITS_MAX_COLLECTIONS)
+		report_abort("%s redimension GITS_MAX_COLLECTIONS", __func__);
+
+	new =3D &its_data.collections[its_data.nb_collections];
+
+	new->col_id =3D col_id;
+
+	if (its_data.typer.pta)
+		new->target_address =3D (u64)gicv3_data.redist_base[pe];
+	else
+		new->target_address =3D pe << 16;
+
+	its_data.nb_collections++;
+	return new;
+}
--=20
2.20.1

