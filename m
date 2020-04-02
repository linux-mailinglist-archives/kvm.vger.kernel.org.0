Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B9419C4EB
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 16:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388905AbgDBOxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 10:53:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42455 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388896AbgDBOxq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 10:53:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585839225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LHdlDzfLttBP9GST+8szpXA1mg4e/OBBrq0DXUu0i84=;
        b=Z2pcSPW+VucnAMSAULf4uLyMY7USdgVgZnaCirOlYKMtK0r1kimbwNBeOSYfPY+S0f4gVX
        4OtqAb1tBgX8epMCJap4gEgO6OgStSePjQgxvXZXaaEmpDnJD/tUOs3Zi5kRIDP9yauygc
        UGz+U3YSgotfWmjufIFiQ7Zobbr7/1o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-DAxfSmNtOAyAdTdKxyBOqQ-1; Thu, 02 Apr 2020 10:53:43 -0400
X-MC-Unique: DAxfSmNtOAyAdTdKxyBOqQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8FDB1005513;
        Thu,  2 Apr 2020 14:53:41 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-58.ams2.redhat.com [10.36.112.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E79E5D9C9;
        Thu,  2 Apr 2020 14:53:33 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v8 09/13] arm/arm64: ITS: Commands
Date:   Thu,  2 Apr 2020 16:52:23 +0200
Message-Id: <20200402145227.20109-10-eric.auger@redhat.com>
In-Reply-To: <20200402145227.20109-1-eric.auger@redhat.com>
References: <20200402145227.20109-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement main ITS commands. The code is largely inherited from
the ITS driver.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

---

v7 -> v8:
- use its_mask_encode()
- added Zenghui's R-b

v6 -> v7:
- remove #include <asm/gic-v3-its.h>

v5 -> v6:
- fix 2 printfs
- removed GITS_CMD_MAPVI

v3 -> v4:
- device's itt now is a VGA
- pass verbose to choose whether we shall print the cmd
- use printf instead of report_info

v2 -> v3:
- do not use report() anymore
- assert if cmd_write exceeds the queue capacity

v1 -> v2:
- removed its_print_cmd_state
---
 arm/Makefile.arm64         |   2 +-
 lib/arm64/asm/gic-v3-its.h |  55 +++++
 lib/arm64/gic-v3-its-cmd.c | 459 +++++++++++++++++++++++++++++++++++++
 3 files changed, 515 insertions(+), 1 deletion(-)
 create mode 100644 lib/arm64/gic-v3-its-cmd.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 60182ae..dfd0c56 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -19,7 +19,7 @@ endef
 cstart.o =3D $(TEST_DIR)/cstart64.o
 cflatobjs +=3D lib/arm64/processor.o
 cflatobjs +=3D lib/arm64/spinlock.o
-cflatobjs +=3D lib/arm64/gic-v3-its.o
+cflatobjs +=3D lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
=20
 OBJDIRS +=3D lib/arm64
=20
diff --git a/lib/arm64/asm/gic-v3-its.h b/lib/arm64/asm/gic-v3-its.h
index 628eedf..c203293 100644
--- a/lib/arm64/asm/gic-v3-its.h
+++ b/lib/arm64/asm/gic-v3-its.h
@@ -106,6 +106,26 @@ extern struct its_data its_data;
 #define GITS_BASER_TYPE_DEVICE		1
 #define GITS_BASER_TYPE_COLLECTION	4
=20
+/*
+ * ITS commands
+ */
+#define GITS_CMD_MAPD			0x08
+#define GITS_CMD_MAPC			0x09
+#define GITS_CMD_MAPTI			0x0a
+#define GITS_CMD_MAPI			0x0b
+#define GITS_CMD_MOVI			0x01
+#define GITS_CMD_DISCARD		0x0f
+#define GITS_CMD_INV			0x0c
+#define GITS_CMD_MOVALL			0x0e
+#define GITS_CMD_INVALL			0x0d
+#define GITS_CMD_INT			0x03
+#define GITS_CMD_CLEAR			0x04
+#define GITS_CMD_SYNC			0x05
+
+struct its_cmd_block {
+	u64 raw_cmd[4];
+};
+
 extern void its_parse_typer(void);
 extern void its_init(void);
 extern int its_baser_lookup(int i, struct its_baser *baser);
@@ -113,4 +133,39 @@ extern void its_enable_defaults(void);
 extern struct its_device *its_create_device(u32 dev_id, int nr_ites);
 extern struct its_collection *its_create_collection(u16 col_id, u32 targ=
et_pe);
=20
+extern void __its_send_mapd(struct its_device *dev, int valid, bool verb=
ose);
+extern void __its_send_mapc(struct its_collection *col, int valid, bool =
verbose);
+extern void __its_send_mapti(struct its_device *dev, u32 irq_id, u32 eve=
nt_id,
+			     struct its_collection *col, bool verbose);
+extern void __its_send_int(struct its_device *dev, u32 event_id, bool ve=
rbose);
+extern void __its_send_inv(struct its_device *dev, u32 event_id, bool ve=
rbose);
+extern void __its_send_discard(struct its_device *dev, u32 event_id, boo=
l verbose);
+extern void __its_send_clear(struct its_device *dev, u32 event_id, bool =
verbose);
+extern void __its_send_invall(struct its_collection *col, bool verbose);
+extern void __its_send_movi(struct its_device *dev, struct its_collectio=
n *col,
+			    u32 id, bool verbose);
+extern void __its_send_sync(struct its_collection *col, bool verbose);
+
+#define its_send_mapd(dev, valid)			__its_send_mapd(dev, valid, true)
+#define its_send_mapc(col, valid)			__its_send_mapc(col, valid, true)
+#define its_send_mapti(dev, irqid, eventid, col)	__its_send_mapti(dev, i=
rqid, eventid, col, true)
+#define its_send_int(dev, eventid)			__its_send_int(dev, eventid, true)
+#define its_send_inv(dev, eventid)			__its_send_inv(dev, eventid, true)
+#define its_send_discard(dev, eventid)			__its_send_discard(dev, eventid=
, true)
+#define its_send_clear(dev, eventid)			__its_send_clear(dev, eventid, tr=
ue)
+#define its_send_invall(col)				__its_send_invall(col, true)
+#define its_send_movi(dev, col, id)			__its_send_movi(dev, col, id, true=
)
+#define its_send_sync(col)				__its_send_sync(col, true)
+
+#define its_send_mapd_nv(dev, valid)			__its_send_mapd(dev, valid, false=
)
+#define its_send_mapc_nv(col, valid)			__its_send_mapc(col, valid, false=
)
+#define its_send_mapti_nv(dev, irqid, eventid, col)	__its_send_mapti(dev=
, irqid, eventid, col, false)
+#define its_send_int_nv(dev, eventid)			__its_send_int(dev, eventid, fal=
se)
+#define its_send_inv_nv(dev, eventid)			__its_send_inv(dev, eventid, fal=
se)
+#define its_send_discard_nv(dev, eventid)		__its_send_discard(dev, event=
id, false)
+#define its_send_clear_nv(dev, eventid)			__its_send_clear(dev, eventidn=
 false)
+#define its_send_invall_nv(col)				__its_send_invall(col, false)
+#define its_send_movi_nv(dev, col, id)			__its_send_movi(dev, col, id, f=
alse)
+#define its_send_sync_nv(col)				__its_send_sync(col, false)
+
 #endif /* _ASMARM64_GIC_V3_ITS_H_ */
diff --git a/lib/arm64/gic-v3-its-cmd.c b/lib/arm64/gic-v3-its-cmd.c
new file mode 100644
index 0000000..2c208d1
--- /dev/null
+++ b/lib/arm64/gic-v3-its-cmd.c
@@ -0,0 +1,459 @@
+/*
+ * Copyright (C) 2020, Red Hat Inc, Eric Auger <eric.auger@redhat.com>
+ *
+ * Most of the code is copy-pasted from:
+ * drivers/irqchip/irq-gic-v3-its.c
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+#include <asm/io.h>
+#include <asm/gic.h>
+
+#define ITS_ITT_ALIGN		SZ_256
+
+static const char * const its_cmd_string[] =3D {
+	[GITS_CMD_MAPD]		=3D "MAPD",
+	[GITS_CMD_MAPC]		=3D "MAPC",
+	[GITS_CMD_MAPTI]	=3D "MAPTI",
+	[GITS_CMD_MAPI]		=3D "MAPI",
+	[GITS_CMD_MOVI]		=3D "MOVI",
+	[GITS_CMD_DISCARD]	=3D "DISCARD",
+	[GITS_CMD_INV]		=3D "INV",
+	[GITS_CMD_MOVALL]	=3D "MOVALL",
+	[GITS_CMD_INVALL]	=3D "INVALL",
+	[GITS_CMD_INT]		=3D "INT",
+	[GITS_CMD_CLEAR]	=3D "CLEAR",
+	[GITS_CMD_SYNC]		=3D "SYNC",
+};
+
+struct its_cmd_desc {
+	union {
+		struct {
+			struct its_device *dev;
+			u32 event_id;
+		} its_inv_cmd;
+
+		struct {
+			struct its_device *dev;
+			u32 event_id;
+		} its_int_cmd;
+
+		struct {
+			struct its_device *dev;
+			bool valid;
+		} its_mapd_cmd;
+
+		struct {
+			struct its_collection *col;
+			bool valid;
+		} its_mapc_cmd;
+
+		struct {
+			struct its_device *dev;
+			u32 phys_id;
+			u32 event_id;
+			u32 col_id;
+		} its_mapti_cmd;
+
+		struct {
+			struct its_device *dev;
+			struct its_collection *col;
+			u32 event_id;
+		} its_movi_cmd;
+
+		struct {
+			struct its_device *dev;
+			u32 event_id;
+		} its_discard_cmd;
+
+		struct {
+			struct its_device *dev;
+			u32 event_id;
+		} its_clear_cmd;
+
+		struct {
+			struct its_collection *col;
+		} its_invall_cmd;
+
+		struct {
+			struct its_collection *col;
+		} its_sync_cmd;
+	};
+	bool verbose;
+};
+
+typedef void (*its_cmd_builder_t)(struct its_cmd_block *,
+				  struct its_cmd_desc *);
+
+/* ITS COMMANDS */
+
+static void its_mask_encode(u64 *raw_cmd, u64 val, int h, int l)
+{
+	u64 mask =3D GENMASK_ULL(h, l);
+	*raw_cmd &=3D ~mask;
+	*raw_cmd |=3D (val << l) & mask;
+}
+
+static void its_encode_cmd(struct its_cmd_block *cmd, u8 cmd_nr)
+{
+	its_mask_encode(&cmd->raw_cmd[0], cmd_nr, 7, 0);
+}
+
+static void its_encode_devid(struct its_cmd_block *cmd, u32 devid)
+{
+	its_mask_encode(&cmd->raw_cmd[0], devid, 63, 32);
+}
+
+static void its_encode_event_id(struct its_cmd_block *cmd, u32 id)
+{
+	its_mask_encode(&cmd->raw_cmd[1], id, 31, 0);
+}
+
+static void its_encode_phys_id(struct its_cmd_block *cmd, u32 phys_id)
+{
+	its_mask_encode(&cmd->raw_cmd[1], phys_id, 63, 32);
+}
+
+static void its_encode_size(struct its_cmd_block *cmd, u8 size)
+{
+	its_mask_encode(&cmd->raw_cmd[1], size, 4, 0);
+}
+
+static void its_encode_itt(struct its_cmd_block *cmd, u64 itt_addr)
+{
+	its_mask_encode(&cmd->raw_cmd[2], itt_addr >> 8, 50, 8);
+}
+
+static void its_encode_valid(struct its_cmd_block *cmd, int valid)
+{
+	its_mask_encode(&cmd->raw_cmd[2], !!valid, 63, 63);
+}
+
+static void its_encode_target(struct its_cmd_block *cmd, u64 target_addr=
)
+{
+	its_mask_encode(&cmd->raw_cmd[2], target_addr >> 16, 50, 16);
+}
+
+static void its_encode_collection(struct its_cmd_block *cmd, u16 col)
+{
+	its_mask_encode(&cmd->raw_cmd[2], col, 15, 0);
+}
+
+static inline void its_fixup_cmd(struct its_cmd_block *cmd)
+{
+	/* Let's fixup BE commands */
+	cmd->raw_cmd[0] =3D cpu_to_le64(cmd->raw_cmd[0]);
+	cmd->raw_cmd[1] =3D cpu_to_le64(cmd->raw_cmd[1]);
+	cmd->raw_cmd[2] =3D cpu_to_le64(cmd->raw_cmd[2]);
+	cmd->raw_cmd[3] =3D cpu_to_le64(cmd->raw_cmd[3]);
+}
+
+static u64 its_cmd_ptr_to_offset(struct its_cmd_block *ptr)
+{
+	return (ptr - its_data.cmd_base) * sizeof(*ptr);
+}
+
+static struct its_cmd_block *its_post_commands(void)
+{
+	u64 wr =3D its_cmd_ptr_to_offset(its_data.cmd_write);
+
+	writeq(wr, its_data.base + GITS_CWRITER);
+	return its_data.cmd_write;
+}
+
+static struct its_cmd_block *its_allocate_entry(void)
+{
+	struct its_cmd_block *cmd;
+
+	assert((u64)its_data.cmd_write < (u64)its_data.cmd_base + SZ_64K);
+	cmd =3D its_data.cmd_write++;
+	return cmd;
+}
+
+static void its_wait_for_range_completion(struct its_cmd_block *from,
+					  struct its_cmd_block *to)
+{
+	u64 rd_idx, from_idx, to_idx;
+	u32 count =3D 1000000;    /* 1s! */
+
+	from_idx =3D its_cmd_ptr_to_offset(from);
+	to_idx =3D its_cmd_ptr_to_offset(to);
+	while (1) {
+		rd_idx =3D readq(its_data.base + GITS_CREADR);
+		if (rd_idx >=3D to_idx || rd_idx < from_idx)
+			break;
+
+		count--;
+		if (!count) {
+			unsigned int cmd_id =3D from->raw_cmd[0] & 0xFF;
+
+			assert_msg(false, "%s timeout!",
+			       cmd_id <=3D 0xF ? its_cmd_string[cmd_id] :
+			       "Unexpected");
+		}
+		udelay(1);
+	}
+}
+
+static void its_send_single_command(its_cmd_builder_t builder,
+				    struct its_cmd_desc *desc)
+{
+	struct its_cmd_block *cmd, *next_cmd;
+
+	cmd =3D its_allocate_entry();
+	builder(cmd, desc);
+	next_cmd =3D its_post_commands();
+
+	its_wait_for_range_completion(cmd, next_cmd);
+}
+
+static void its_build_mapd_cmd(struct its_cmd_block *cmd,
+			       struct its_cmd_desc *desc)
+{
+	unsigned long itt_addr;
+	u8 size =3D desc->its_mapd_cmd.dev->nr_ites;
+
+	itt_addr =3D (unsigned long)(virt_to_phys(desc->its_mapd_cmd.dev->itt))=
;
+	itt_addr =3D ALIGN(itt_addr, ITS_ITT_ALIGN);
+
+	its_encode_cmd(cmd, GITS_CMD_MAPD);
+	its_encode_devid(cmd, desc->its_mapd_cmd.dev->device_id);
+	its_encode_size(cmd, size - 1);
+	its_encode_itt(cmd, itt_addr);
+	its_encode_valid(cmd, desc->its_mapd_cmd.valid);
+	its_fixup_cmd(cmd);
+	if (desc->verbose)
+		printf("ITS: MAPD devid=3D%d size =3D 0x%x itt=3D0x%lx valid=3D%d\n",
+			desc->its_mapd_cmd.dev->device_id,
+			size, itt_addr, desc->its_mapd_cmd.valid);
+}
+
+static void its_build_mapc_cmd(struct its_cmd_block *cmd,
+			       struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_MAPC);
+	its_encode_collection(cmd, desc->its_mapc_cmd.col->col_id);
+	its_encode_target(cmd, desc->its_mapc_cmd.col->target_address);
+	its_encode_valid(cmd, desc->its_mapc_cmd.valid);
+	its_fixup_cmd(cmd);
+	if (desc->verbose)
+		printf("MAPC col_id=3D%d target_addr =3D 0x%lx valid=3D%d\n",
+		       desc->its_mapc_cmd.col->col_id,
+		       desc->its_mapc_cmd.col->target_address,
+		       desc->its_mapc_cmd.valid);
+}
+
+static void its_build_mapti_cmd(struct its_cmd_block *cmd,
+				struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_MAPTI);
+	its_encode_devid(cmd, desc->its_mapti_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_mapti_cmd.event_id);
+	its_encode_phys_id(cmd, desc->its_mapti_cmd.phys_id);
+	its_encode_collection(cmd, desc->its_mapti_cmd.col_id);
+	its_fixup_cmd(cmd);
+	if (desc->verbose)
+		printf("MAPTI dev_id=3D%d event_id=3D%d -> phys_id=3D%d, col_id=3D%d\n=
",
+		       desc->its_mapti_cmd.dev->device_id,
+		       desc->its_mapti_cmd.event_id,
+		       desc->its_mapti_cmd.phys_id,
+		       desc->its_mapti_cmd.col_id);
+}
+
+static void its_build_invall_cmd(struct its_cmd_block *cmd,
+			      struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_INVALL);
+	its_encode_collection(cmd, desc->its_invall_cmd.col->col_id);
+	its_fixup_cmd(cmd);
+	if (desc->verbose)
+		printf("INVALL col_id=3D%d\n", desc->its_invall_cmd.col->col_id);
+}
+
+static void its_build_clear_cmd(struct its_cmd_block *cmd,
+				struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_CLEAR);
+	its_encode_devid(cmd, desc->its_clear_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_clear_cmd.event_id);
+	its_fixup_cmd(cmd);
+	if (desc->verbose)
+		printf("CLEAR dev_id=3D%d event_id=3D%d\n", desc->its_clear_cmd.dev->d=
evice_id, desc->its_clear_cmd.event_id);
+}
+
+static void its_build_discard_cmd(struct its_cmd_block *cmd,
+				  struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_DISCARD);
+	its_encode_devid(cmd, desc->its_discard_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_discard_cmd.event_id);
+	its_fixup_cmd(cmd);
+	if (desc->verbose)
+		printf("DISCARD dev_id=3D%d event_id=3D%d\n",
+			desc->its_clear_cmd.dev->device_id, desc->its_clear_cmd.event_id);
+}
+
+static void its_build_inv_cmd(struct its_cmd_block *cmd,
+			      struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_INV);
+	its_encode_devid(cmd, desc->its_inv_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_inv_cmd.event_id);
+	its_fixup_cmd(cmd);
+	if (desc->verbose)
+		printf("INV dev_id=3D%d event_id=3D%d\n",
+		       desc->its_inv_cmd.dev->device_id,
+		       desc->its_inv_cmd.event_id);
+}
+
+static void its_build_int_cmd(struct its_cmd_block *cmd,
+			      struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_INT);
+	its_encode_devid(cmd, desc->its_int_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_int_cmd.event_id);
+	its_fixup_cmd(cmd);
+	if (desc->verbose)
+		printf("INT dev_id=3D%d event_id=3D%d\n",
+		       desc->its_int_cmd.dev->device_id,
+		       desc->its_int_cmd.event_id);
+}
+
+static void its_build_sync_cmd(struct its_cmd_block *cmd,
+			       struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_SYNC);
+	its_encode_target(cmd, desc->its_sync_cmd.col->target_address);
+	its_fixup_cmd(cmd);
+	if (desc->verbose)
+		printf("SYNC target_addr =3D 0x%lx\n",
+		       desc->its_sync_cmd.col->target_address);
+}
+
+static void its_build_movi_cmd(struct its_cmd_block *cmd,
+			       struct its_cmd_desc *desc)
+{
+	its_encode_cmd(cmd, GITS_CMD_MOVI);
+	its_encode_devid(cmd, desc->its_movi_cmd.dev->device_id);
+	its_encode_event_id(cmd, desc->its_movi_cmd.event_id);
+	its_encode_collection(cmd, desc->its_movi_cmd.col->col_id);
+	its_fixup_cmd(cmd);
+	if (desc->verbose)
+		printf("MOVI dev_id=3D%d event_id =3D %d col_id=3D%d\n",
+		       desc->its_movi_cmd.dev->device_id,
+		       desc->its_movi_cmd.event_id,
+		       desc->its_movi_cmd.col->col_id);
+}
+
+void __its_send_mapd(struct its_device *dev, int valid, bool verbose)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_mapd_cmd.dev =3D dev;
+	desc.its_mapd_cmd.valid =3D !!valid;
+	desc.verbose =3D verbose;
+
+	its_send_single_command(its_build_mapd_cmd, &desc);
+}
+
+void __its_send_mapc(struct its_collection *col, int valid, bool verbose=
)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_mapc_cmd.col =3D col;
+	desc.its_mapc_cmd.valid =3D !!valid;
+	desc.verbose =3D verbose;
+
+	its_send_single_command(its_build_mapc_cmd, &desc);
+}
+
+void __its_send_mapti(struct its_device *dev, u32 irq_id,
+		      u32 event_id, struct its_collection *col, bool verbose)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_mapti_cmd.dev =3D dev;
+	desc.its_mapti_cmd.phys_id =3D irq_id;
+	desc.its_mapti_cmd.event_id =3D event_id;
+	desc.its_mapti_cmd.col_id =3D col->col_id;
+	desc.verbose =3D verbose;
+
+	its_send_single_command(its_build_mapti_cmd, &desc);
+}
+
+void __its_send_int(struct its_device *dev, u32 event_id, bool verbose)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_int_cmd.dev =3D dev;
+	desc.its_int_cmd.event_id =3D event_id;
+	desc.verbose =3D verbose;
+
+	its_send_single_command(its_build_int_cmd, &desc);
+}
+
+void __its_send_movi(struct its_device *dev, struct its_collection *col,
+		     u32 id, bool verbose)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_movi_cmd.dev =3D dev;
+	desc.its_movi_cmd.col =3D col;
+	desc.its_movi_cmd.event_id =3D id;
+	desc.verbose =3D verbose;
+
+	its_send_single_command(its_build_movi_cmd, &desc);
+}
+
+void __its_send_invall(struct its_collection *col, bool verbose)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_invall_cmd.col =3D col;
+	desc.verbose =3D verbose;
+
+	its_send_single_command(its_build_invall_cmd, &desc);
+}
+
+void __its_send_inv(struct its_device *dev, u32 event_id, bool verbose)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_inv_cmd.dev =3D dev;
+	desc.its_inv_cmd.event_id =3D event_id;
+	desc.verbose =3D verbose;
+
+	its_send_single_command(its_build_inv_cmd, &desc);
+}
+
+void __its_send_discard(struct its_device *dev, u32 event_id, bool verbo=
se)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_discard_cmd.dev =3D dev;
+	desc.its_discard_cmd.event_id =3D event_id;
+	desc.verbose =3D verbose;
+
+	its_send_single_command(its_build_discard_cmd, &desc);
+}
+
+void __its_send_clear(struct its_device *dev, u32 event_id, bool verbose=
)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_clear_cmd.dev =3D dev;
+	desc.its_clear_cmd.event_id =3D event_id;
+	desc.verbose =3D verbose;
+
+	its_send_single_command(its_build_clear_cmd, &desc);
+}
+
+void __its_send_sync(struct its_collection *col, bool verbose)
+{
+	struct its_cmd_desc desc;
+
+	desc.its_sync_cmd.col =3D col;
+	desc.verbose =3D verbose;
+
+	its_send_single_command(its_build_sync_cmd, &desc);
+}
+
--=20
2.20.1

