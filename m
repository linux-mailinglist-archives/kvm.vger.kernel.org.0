Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364D87CFE30
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 17:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346387AbjJSPlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 11:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346336AbjJSPk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 11:40:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7BF12F
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 08:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=YiCYoQ74dUkz+/Yw6CbN6HlBrhYYc3OdkjhDV5gESs0=; b=GXhFdhy/z+aIbY/iYsIiOAlfI5
        lHmr8No/KBo7JHtk+f4Y7hin/kTcgjMWRdOZvFYaiPCRvW9JKOiEbJBa/P8wl4QqDU2gCaRwdSS/Z
        WZhqK2E7gBhb8a1vtH06wnAQfaf4pE1w4fP7MFv5acAPdeY8Q+fXsUF4WcNSECZTUPJWX+4JW5/KS
        RGx7n0OSqnRnT5uVPuR3dW2fK92QSbwyAvknxlfjqWM/K71GuJB3Ibd2mg/8I8HZ/QAGiUKSsdfVe
        vyvgVC+0zC4A0k/de7T5EB/cUD0DTOrf4IE5ySm0ocl54PZlNBDLeL/KovBRe21dDx3vH+2ACmN9J
        c+qtwl2g==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qtV8M-007osp-TI; Thu, 19 Oct 2023 15:40:26 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qtV8M-000PuO-1b;
        Thu, 19 Oct 2023 16:40:26 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cleber Rosa <crosa@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Beraldo Leal <bleal@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
Subject: [PATCH v2 11/24] hw/xen: automatically assign device index to block devices
Date:   Thu, 19 Oct 2023 16:40:07 +0100
Message-Id: <20231019154020.99080-12-dwmw2@infradead.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231019154020.99080-1-dwmw2@infradead.org>
References: <20231019154020.99080-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
 blockdev.c                          | 15 +++++++++---
 hw/block/xen-block.c                | 38 +++++++++++++++++++++++++++++
 hw/xen/xen_devconfig.c              | 28 ---------------------
 hw/xenpv/xen_machine_pv.c           |  9 -------
 include/hw/xen/xen-legacy-backend.h |  1 -
 5 files changed, 50 insertions(+), 41 deletions(-)

diff --git a/blockdev.c b/blockdev.c
index a01c62596b..5d9f2e5395 100644
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
index a07cd7eb5d..f490b24ec8 100644
--- a/hw/block/xen-block.c
+++ b/hw/block/xen-block.c
@@ -27,6 +27,7 @@
 #include "sysemu/block-backend.h"
 #include "sysemu/iothread.h"
 #include "dataplane/xen-block.h"
+#include "hw/xen/interface/io/xs_wire.h"
 #include "trace.h"
 
 static char *xen_block_get_name(XenDevice *xendev, Error **errp)
@@ -34,6 +35,43 @@ static char *xen_block_get_name(XenDevice *xendev, Error **errp)
     XenBlockDevice *blockdev = XEN_BLOCK_DEVICE(xendev);
     XenBlockVdev *vdev = &blockdev->props.vdev;
 
+    if (blockdev->props.vdev.type == XEN_BLOCK_VDEV_TYPE_INVALID) {
+        XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
+        char fe_path[XENSTORE_ABS_PATH_MAX + 1];
+        char *value;
+        int disk = 0;
+        unsigned long idx;
+
+        /* Find an unoccupied device name */
+        while (disk < (1 << 20)) {
+            if (disk < (1 << 4)) {
+                idx = (202 << 8) | (disk << 4);
+            } else {
+                idx = (1 << 28) | (disk << 8);
+            }
+            snprintf(fe_path, sizeof(fe_path),
+                     "/local/domain/%u/device/vbd/%lu",
+                     xendev->frontend_id, idx);
+            value = qemu_xen_xs_read(xenbus->xsh, XBT_NULL, fe_path, NULL);
+            if (!value) {
+                if (errno == ENOENT) {
+                    vdev->type = XEN_BLOCK_VDEV_TYPE_XVD;
+                    vdev->partition = 0;
+                    vdev->disk = disk;
+                    vdev->number = idx;
+                    goto found;
+                }
+                error_setg(errp, "cannot read %s: %s", fe_path,
+                           strerror(errno));
+                return NULL;
+            }
+            free(value);
+            disk++;
+        }
+        error_setg(errp, "cannot find device vdev for block device");
+        return NULL;
+    }
+ found:
     return g_strdup_printf("%lu", vdev->number);
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
2.40.1

