Return-Path: <kvm+bounces-763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AF387E26FE
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:36:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 114F328157D
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 14:36:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E484228DCA;
	Mon,  6 Nov 2023 14:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61A528DC5
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 14:35:46 +0000 (UTC)
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDFDC6
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 06:35:44 -0800 (PST)
X-IronPort-AV: E=Sophos;i="6.03,281,1694736000"; 
   d="scan'208";a="682419969"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 14:35:44 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id 0237E40D52;
	Mon,  6 Nov 2023 14:35:37 +0000 (UTC)
Received: from EX19MTAUWA001.ant.amazon.com [10.0.7.35:8079]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.186:2525] with esmtp (Farcaster)
 id 412408a9-6880-48e2-bde9-8f615dae06ec; Mon, 6 Nov 2023 14:35:37 +0000 (UTC)
X-Farcaster-Flow-ID: 412408a9-6880-48e2-bde9-8f615dae06ec
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Mon, 6 Nov 2023 14:35:32 +0000
Received: from u3832b3a9db3152.ant.amazon.com (10.106.83.6) by
 mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP Server id
 15.2.1118.39 via Frontend Transport; Mon, 6 Nov 2023 14:35:29 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: <qemu-devel@nongnu.org>
CC: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Peter
 Maydell <peter.maydell@linaro.org>, Stefano Stabellini
	<sstabellini@kernel.org>, Anthony Perard <anthony.perard@citrix.com>, Paul
 Durrant <paul@xen.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?=
	<marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Richard
 Henderson <richard.henderson@linaro.org>, Eduardo Habkost
	<eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>, Jason Wang <jasowang@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, <qemu-block@nongnu.org>,
	<xen-devel@lists.xenproject.org>, <kvm@vger.kernel.org>
Subject: [PATCH v4 06/17] hw/xen: automatically assign device index to block devices
Date: Mon, 6 Nov 2023 14:34:56 +0000
Message-ID: <20231106143507.1060610-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231106143507.1060610-1-dwmw2@infradead.org>
References: <20231106143507.1060610-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: Bulk

From: David Woodhouse <dwmw@amazon.co.uk>

There's no need to force the user to assign a vdev. We can automatically
assign one, starting at xvda and searching until we find the first disk
name that's unused.

This means we can now allow '-drive if=xen,file=xxx' to work without an
explicit separate -driver argument, just like if=virtio.

Rip out the legacy handling from the xenpv machine, which was scribbling
over any disks configured by the toolstack, and didn't work with anything
but raw images.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Kevin Wolf <kwolf@redhat.com>
---
 blockdev.c                          |  15 +++-
 hw/block/xen-block.c                | 118 ++++++++++++++++++++++++++--
 hw/xen/xen_devconfig.c              |  28 -------
 hw/xenpv/xen_machine_pv.c           |   9 ---
 include/hw/xen/xen-legacy-backend.h |   1 -
 5 files changed, 125 insertions(+), 46 deletions(-)

diff --git a/blockdev.c b/blockdev.c
index 1517dc6210..e9b7e38dc4 100644
--- a/blockdev.c
+++ b/blockdev.c
@@ -255,13 +255,13 @@ void drive_check_orphaned(void)
          * Ignore default drives, because we create certain default
          * drives unconditionally, then leave them unclaimed.  Not the
          * users fault.
-         * Ignore IF_VIRTIO, because it gets desugared into -device,
-         * so we can leave failing to -device.
+         * Ignore IF_VIRTIO or IF_XEN, because it gets desugared into
+         * -device, so we can leave failing to -device.
          * Ignore IF_NONE, because leaving unclaimed IF_NONE remains
          * available for device_add is a feature.
          */
         if (dinfo->is_default || dinfo->type == IF_VIRTIO
-            || dinfo->type == IF_NONE) {
+            || dinfo->type == IF_XEN || dinfo->type == IF_NONE) {
             continue;
         }
         if (!blk_get_attached_dev(blk)) {
@@ -977,6 +977,15 @@ DriveInfo *drive_new(QemuOpts *all_opts, BlockInterfaceType block_default_type,
         qemu_opt_set(devopts, "driver", "virtio-blk", &error_abort);
         qemu_opt_set(devopts, "drive", qdict_get_str(bs_opts, "id"),
                      &error_abort);
+    } else if (type == IF_XEN) {
+        QemuOpts *devopts;
+        devopts = qemu_opts_create(qemu_find_opts("device"), NULL, 0,
+                                   &error_abort);
+        qemu_opt_set(devopts, "driver",
+                     (media == MEDIA_CDROM) ? "xen-cdrom" : "xen-disk",
+                     &error_abort);
+        qemu_opt_set(devopts, "drive", qdict_get_str(bs_opts, "id"),
+                     &error_abort);
     }
 
     filename = qemu_opt_get(legacy_opts, "file");
diff --git a/hw/block/xen-block.c b/hw/block/xen-block.c
index bfa53960c3..6d64ede94f 100644
--- a/hw/block/xen-block.c
+++ b/hw/block/xen-block.c
@@ -27,13 +27,119 @@
 #include "sysemu/block-backend.h"
 #include "sysemu/iothread.h"
 #include "dataplane/xen-block.h"
+#include "hw/xen/interface/io/xs_wire.h"
 #include "trace.h"
 
+#define XVDA_MAJOR 202
+#define XVDQ_MAJOR (1 << 20)
+#define XVDBGQCV_MAJOR ((1 << 21) - 1)
+#define HDA_MAJOR 3
+#define HDC_MAJOR 22
+#define SDA_MAJOR 8
+
+
+static int vdev_to_diskno(unsigned int vdev_nr)
+{
+    switch (vdev_nr >> 8) {
+    case XVDA_MAJOR:
+    case SDA_MAJOR:
+        return (vdev_nr >> 4) & 0x15;
+
+    case HDA_MAJOR:
+        return (vdev_nr >> 6) & 1;
+
+    case HDC_MAJOR:
+        return ((vdev_nr >> 6) & 1) + 2;
+
+    case XVDQ_MAJOR ... XVDBGQCV_MAJOR:
+        return (vdev_nr >> 8) & 0xfffff;
+
+    default:
+        return -1;
+    }
+}
+
+#define MAX_AUTO_VDEV 4096
+
+/*
+ * Find a free device name in the xvda → xvdfan range and set it in
+ * blockdev->props.vdev. Our definition of "free" is that there must
+ * be no other disk or partition with the same disk number.
+ *
+ * You are technically permitted to have all of hda, hda1, sda, sda1,
+ * xvda and xvda1 as *separate* PV block devices with separate backing
+ * stores. That doesn't make it a good idea. This code will skip xvda
+ * if *any* of those "conflicting" devices already exists.
+ *
+ * The limit of xvdfan (disk 4095) is fairly arbitrary just to avoid a
+ * stupidly sized bitmap, but Linux as of v6.6 doesn't support anything
+ * higher than that anyway.
+ */
+static bool xen_block_find_free_vdev(XenBlockDevice *blockdev, Error **errp)
+{
+    XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(blockdev)));
+    unsigned long used_devs[BITS_TO_LONGS(MAX_AUTO_VDEV)];
+    XenBlockVdev *vdev = &blockdev->props.vdev;
+    char fe_path[XENSTORE_ABS_PATH_MAX + 1];
+    char **existing_frontends;
+    unsigned int nr_existing = 0;
+    unsigned int vdev_nr;
+    int i, disk = 0;
+
+    snprintf(fe_path, sizeof(fe_path), "/local/domain/%u/device/vbd",
+             blockdev->xendev.frontend_id);
+
+    existing_frontends = qemu_xen_xs_directory(xenbus->xsh, XBT_NULL, fe_path,
+                                               &nr_existing);
+    if (!existing_frontends && errno != ENOENT) {
+        error_setg_errno(errp, errno, "cannot read %s", fe_path);
+        return false;
+    }
+
+    memset(used_devs, 0, sizeof(used_devs));
+    for (i = 0; i < nr_existing; i++) {
+        if (qemu_strtoui(existing_frontends[i], NULL, 10, &vdev_nr)) {
+            free(existing_frontends[i]);
+            continue;
+        }
+
+        free(existing_frontends[i]);
+
+        disk = vdev_to_diskno(vdev_nr);
+        if (disk < 0 || disk >= MAX_AUTO_VDEV) {
+            continue;
+        }
+
+        set_bit(disk, used_devs);
+    }
+    free(existing_frontends);
+
+    disk = find_first_zero_bit(used_devs, MAX_AUTO_VDEV);
+    if (disk == MAX_AUTO_VDEV) {
+        error_setg(errp, "cannot find device vdev for block device");
+        return false;
+    }
+
+    vdev->type = XEN_BLOCK_VDEV_TYPE_XVD;
+    vdev->partition = 0;
+    vdev->disk = disk;
+    if (disk < (1 << 4)) {
+        vdev->number = (XVDA_MAJOR << 8) | (disk << 4);
+    } else {
+        vdev->number = (XVDQ_MAJOR << 8) | (disk << 8);
+    }
+    return true;
+}
+
 static char *xen_block_get_name(XenDevice *xendev, Error **errp)
 {
     XenBlockDevice *blockdev = XEN_BLOCK_DEVICE(xendev);
     XenBlockVdev *vdev = &blockdev->props.vdev;
 
+    if (vdev->type == XEN_BLOCK_VDEV_TYPE_INVALID &&
+        !xen_block_find_free_vdev(blockdev, errp)) {
+        return NULL;
+    }
     return g_strdup_printf("%lu", vdev->number);
 }
 
@@ -482,10 +588,10 @@ static void xen_block_set_vdev(Object *obj, Visitor *v, const char *name,
     case XEN_BLOCK_VDEV_TYPE_DP:
     case XEN_BLOCK_VDEV_TYPE_XVD:
         if (vdev->disk < (1 << 4) && vdev->partition < (1 << 4)) {
-            vdev->number = (202 << 8) | (vdev->disk << 4) |
+            vdev->number = (XVDA_MAJOR << 8) | (vdev->disk << 4) |
                 vdev->partition;
         } else if (vdev->disk < (1 << 20) && vdev->partition < (1 << 8)) {
-            vdev->number = (1 << 28) | (vdev->disk << 8) |
+            vdev->number = (XVDQ_MAJOR << 8) | (vdev->disk << 8) |
                 vdev->partition;
         } else {
             goto invalid;
@@ -495,10 +601,11 @@ static void xen_block_set_vdev(Object *obj, Visitor *v, const char *name,
     case XEN_BLOCK_VDEV_TYPE_HD:
         if ((vdev->disk == 0 || vdev->disk == 1) &&
             vdev->partition < (1 << 6)) {
-            vdev->number = (3 << 8) | (vdev->disk << 6) | vdev->partition;
+            vdev->number = (HDA_MAJOR << 8) | (vdev->disk << 6) |
+                vdev->partition;
         } else if ((vdev->disk == 2 || vdev->disk == 3) &&
                    vdev->partition < (1 << 6)) {
-            vdev->number = (22 << 8) | ((vdev->disk - 2) << 6) |
+            vdev->number = (HDC_MAJOR << 8) | ((vdev->disk - 2) << 6) |
                 vdev->partition;
         } else {
             goto invalid;
@@ -507,7 +614,8 @@ static void xen_block_set_vdev(Object *obj, Visitor *v, const char *name,
 
     case XEN_BLOCK_VDEV_TYPE_SD:
         if (vdev->disk < (1 << 4) && vdev->partition < (1 << 4)) {
-            vdev->number = (8 << 8) | (vdev->disk << 4) | vdev->partition;
+            vdev->number = (SDA_MAJOR << 8) | (vdev->disk << 4) |
+                vdev->partition;
         } else {
             goto invalid;
         }
diff --git a/hw/xen/xen_devconfig.c b/hw/xen/xen_devconfig.c
index 9b7304e544..3f77c675c6 100644
--- a/hw/xen/xen_devconfig.c
+++ b/hw/xen/xen_devconfig.c
@@ -46,34 +46,6 @@ static int xen_config_dev_all(char *fe, char *be)
 
 /* ------------------------------------------------------------- */
 
-int xen_config_dev_blk(DriveInfo *disk)
-{
-    char fe[256], be[256], device_name[32];
-    int vdev = 202 * 256 + 16 * disk->unit;
-    int cdrom = disk->media_cd;
-    const char *devtype = cdrom ? "cdrom" : "disk";
-    const char *mode    = cdrom ? "r"     : "w";
-    const char *filename = qemu_opt_get(disk->opts, "file");
-
-    snprintf(device_name, sizeof(device_name), "xvd%c", 'a' + disk->unit);
-    xen_pv_printf(NULL, 1, "config disk %d [%s]: %s\n",
-                  disk->unit, device_name, filename);
-    xen_config_dev_dirs("vbd", "qdisk", vdev, fe, be, sizeof(fe));
-
-    /* frontend */
-    xenstore_write_int(fe, "virtual-device",  vdev);
-    xenstore_write_str(fe, "device-type",     devtype);
-
-    /* backend */
-    xenstore_write_str(be, "dev",             device_name);
-    xenstore_write_str(be, "type",            "file");
-    xenstore_write_str(be, "params",          filename);
-    xenstore_write_str(be, "mode",            mode);
-
-    /* common stuff */
-    return xen_config_dev_all(fe, be);
-}
-
 int xen_config_dev_nic(NICInfo *nic)
 {
     char fe[256], be[256];
diff --git a/hw/xenpv/xen_machine_pv.c b/hw/xenpv/xen_machine_pv.c
index 17cda5ec13..1533f5dfb4 100644
--- a/hw/xenpv/xen_machine_pv.c
+++ b/hw/xenpv/xen_machine_pv.c
@@ -32,7 +32,6 @@
 
 static void xen_init_pv(MachineState *machine)
 {
-    DriveInfo *dinfo;
     int i;
 
     setup_xen_backend_ops();
@@ -64,14 +63,6 @@ static void xen_init_pv(MachineState *machine)
         vga_interface_created = true;
     }
 
-    /* configure disks */
-    for (i = 0; i < 16; i++) {
-        dinfo = drive_get(IF_XEN, 0, i);
-        if (!dinfo)
-            continue;
-        xen_config_dev_blk(dinfo);
-    }
-
     /* configure nics */
     for (i = 0; i < nb_nics; i++) {
         if (!nd_table[i].model || 0 != strcmp(nd_table[i].model, "xen"))
diff --git a/include/hw/xen/xen-legacy-backend.h b/include/hw/xen/xen-legacy-backend.h
index 6c307c5f2c..fc42146bc2 100644
--- a/include/hw/xen/xen-legacy-backend.h
+++ b/include/hw/xen/xen-legacy-backend.h
@@ -81,7 +81,6 @@ extern struct XenDevOps xen_usb_ops;          /* xen-usb.c         */
 
 /* configuration (aka xenbus setup) */
 void xen_config_cleanup(void);
-int xen_config_dev_blk(DriveInfo *disk);
 int xen_config_dev_nic(NICInfo *nic);
 int xen_config_dev_vfb(int vdev, const char *type);
 int xen_config_dev_vkbd(int vdev);
-- 
2.34.1


