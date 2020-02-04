Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6541522F6
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 00:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgBDXRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 18:17:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56128 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBDXRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 18:17:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580858264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fXkSZIYg+CxNFfkQFswaGct5gf6MoWDvY2IKAJ/JqLk=;
        b=jK9ZUoaz4n5KUOrgmPCSgdOT9J2YmYiQBNfr66cirFnCaaTGBmHvUQ5RBvoap++g0Bmwjy
        XTb5iS2SSerW4ebRGVVo3FfCa1yIBDwCEyUPO4xA/2iRx6b52dclQfOimcYI9AbEg9Sev1
        ikLmXvrLDMiVPVHdlTju9tO117WAl9U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-vjVLerJNNjCAcy2yIZMWIg-1; Tue, 04 Feb 2020 18:17:39 -0500
X-MC-Unique: vjVLerJNNjCAcy2yIZMWIg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78A7A802562;
        Tue,  4 Feb 2020 23:17:38 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9059590A6;
        Tue,  4 Feb 2020 23:17:37 +0000 (UTC)
Date:   Tue, 4 Feb 2020 16:17:37 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        dev@dpdk.org, mtosatti@redhat.com, thomas@monjalon.net,
        bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, cohuck@redhat.com
Subject: Re: [RFC PATCH 0/7] vfio/pci: SR-IOV support
Message-ID: <20200204161737.34696b91@w520.home>
In-Reply-To: <158085337582.9445.17682266437583505502.stgit@gimli.home>
References: <158085337582.9445.17682266437583505502.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Promised example QEMU test case...

commit 3557c63bcb286c71f3f7242cad632edd9e297d26
Author: Alex Williamson <alex.williamson@redhat.com>
Date:   Tue Feb 4 13:47:41 2020 -0700

    vfio-pci: QEMU support for vfio-pci VF tokens
    
    Example support for using a vf_token to gain access to a device as
    well as using the VFIO_DEVICE_FEATURE interface to set the VF token.
    Note that the kernel will disregard the additional option where it's
    not required, such as opening the PF with no VF users, so we can
    always provide it.
    
    NB. It's unclear whether there's value to this QEMU support without
    further exposure of SR-IOV within a VM.  This is meant mostly as a
    test case where the real initial users will likely be DPDK drivers.
    
    Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 337a173ce7c6..b755b4caa870 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2816,12 +2816,45 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
         goto error;
     }
 
-    ret = vfio_get_device(group, vdev->vbasedev.name, &vdev->vbasedev, errp);
+    if (!qemu_uuid_is_null(&vdev->vf_token)) {
+        char *uuid = qemu_uuid_unparse_strdup(&vdev->vf_token);
+
+        tmp = g_strdup_printf("%s vf_token=%s", vdev->vbasedev.name, uuid);
+        g_free(uuid);
+    } else {
+        tmp = g_strdup_printf("%s", vdev->vbasedev.name);
+    }
+
+    ret = vfio_get_device(group, tmp, &vdev->vbasedev, errp);
+
+    g_free(tmp);
+
     if (ret) {
         vfio_put_group(group);
         goto error;
     }
 
+    if (!qemu_uuid_is_null(&vdev->vf_token)) {
+        struct vfio_device_feature *feature;
+
+        feature = g_malloc0(sizeof(*feature) + 16);
+        feature->argsz = sizeof(*feature) + 16;
+        feature->flags = VFIO_DEVICE_FEATURE_PROBE | VFIO_DEVICE_FEATURE_SET |
+                         VFIO_DEVICE_FEATURE_PCI_VF_TOKEN;
+
+        if (!ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feature)) {
+            feature->flags &= ~VFIO_DEVICE_FEATURE_PROBE;
+            memcpy(&feature->data, vdev->vf_token.data, 16);
+            if (ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feature)) {
+                g_free(feature);
+                error_setg_errno(errp, errno, "failed to set vf_token UUID");
+                goto error;
+            }
+        }
+
+        g_free(feature);
+    }
+
     vfio_populate_device(vdev, &err);
     if (err) {
         error_propagate(errp, err);
@@ -3149,6 +3182,7 @@ static void vfio_instance_init(Object *obj)
 static Property vfio_pci_dev_properties[] = {
     DEFINE_PROP_PCI_HOST_DEVADDR("host", VFIOPCIDevice, host),
     DEFINE_PROP_STRING("sysfsdev", VFIOPCIDevice, vbasedev.sysfsdev),
+    DEFINE_PROP_UUID_NODEFAULT("vf_token", VFIOPCIDevice, vf_token),
     DEFINE_PROP_ON_OFF_AUTO("display", VFIOPCIDevice,
                             display, ON_OFF_AUTO_OFF),
     DEFINE_PROP_UINT32("xres", VFIOPCIDevice, display_xres, 0),
diff --git a/hw/vfio/pci.h b/hw/vfio/pci.h
index 35626cd63e9d..7f25672d7500 100644
--- a/hw/vfio/pci.h
+++ b/hw/vfio/pci.h
@@ -18,6 +18,7 @@
 #include "qemu/event_notifier.h"
 #include "qemu/queue.h"
 #include "qemu/timer.h"
+#include "qemu/uuid.h"
 
 #define PCI_ANY_ID (~0)
 
@@ -170,6 +171,7 @@ typedef struct VFIOPCIDevice {
     VFIODisplay *dpy;
     Error *migration_blocker;
     Notifier irqchip_change_notifier;
+    QemuUUID vf_token;
 } VFIOPCIDevice;
 
 uint32_t vfio_pci_read_config(PCIDevice *pdev, uint32_t addr, int len);
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index fb10370d2928..9bc28cc1d272 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -707,6 +707,43 @@ struct vfio_device_ioeventfd {
 
 #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_DEVICE_FEATURE - _IORW(VFIO_TYPE, VFIO_BASE + 17,
+ *			       struct vfio_device_feature
+ *
+ * Get, set, or probe feature data of the device.  The feature is selected
+ * using the FEATURE_MASK portion of the flags field.  Support for a feature
+ * can be probed by setting both the FEATURE_MASK and PROBE bits.  A probe
+ * may optionally include the GET and/or SET bits to determine read vs write
+ * access of the feature respectively.  Probing a feature will return success
+ * if the feature is supporedt and all of the optionally indicated GET/SET
+ * methods are supported.  The format of the data portion of the structure is
+ * specific to the given feature.  The data portion is not required for
+ * probing.
+ *
+ * Return 0 on success, -errno on failure.
+ */
+struct vfio_device_feature {
+	__u32	argsz;
+	__u32	flags;
+#define VFIO_DEVICE_FEATURE_MASK	(0xffff) /* 16-bit feature index */
+#define VFIO_DEVICE_FEATURE_GET		(1 << 16) /* Get feature into data[] */
+#define VFIO_DEVICE_FEATURE_SET		(1 << 17) /* Set feature from data[] */
+#define VFIO_DEVICE_FEATURE_PROBE	(1 << 18) /* Probe feature support */
+	__u8	data[];
+};
+
+#define VFIO_DEVICE_FEATURE		_IO(VFIO_TYPE, VFIO_BASE + 17)
+
+/*
+ * Provide support for setting a PCI VF Token, which is used as a shared
+ * secret between PF and VF drivers.  This feature may only be set on a
+ * PCI SR-IOV PF when SR-IOV is enabled on the PF and there are no existing
+ * open VFs.  Data provided when setting this feature is a 16-byte array
+ * (__u8 b[16]), representing a UUID.
+ */
+#define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**

