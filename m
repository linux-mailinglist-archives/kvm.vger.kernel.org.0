Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D23C1DB33E
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 14:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgETMcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 08:32:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35849 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726840AbgETMcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 08:32:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589977942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1BbevjkskbYyrE6QMfKDlnrNUXXr2l9bYZtaGxMJ0i4=;
        b=R4vegIxhbzCLUkvbXyyhc3dyMYJgp3IHwOq0DHXPIToMY67H16dhma0iBvzNiXaxqv0HUc
        W1FM5LzlhzfGnDVihFfYscmgejEsh19OVVEZXTyxUjNomzAaCtzeKMMn7TPRmmDZGNbNwL
        vKBp8yZNnK+qd3vxdjGij8bdNqlN0zo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-C4agVaK3MXaX72D2Rbyy1A-1; Wed, 20 May 2020 08:32:16 -0400
X-MC-Unique: C4agVaK3MXaX72D2Rbyy1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 910A7835B46;
        Wed, 20 May 2020 12:32:14 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EAAE62B10;
        Wed, 20 May 2020 12:32:10 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 02/19] vfio: Convert to ram_block_discard_disable()
Date:   Wed, 20 May 2020 14:31:35 +0200
Message-Id: <20200520123152.60527-3-david@redhat.com>
In-Reply-To: <20200520123152.60527-1-david@redhat.com>
References: <20200520123152.60527-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO is (except devices without a physical IOMMU or some mediated devices)
incompatible with discarding of RAM. The kernel will pin basically all VM
memory. Let's convert to ram_block_discard_disable(), which can now
fail, in contrast to qemu_balloon_inhibit().

Leave "x-balloon-allowed" named as it is for now.

Cc: Cornelia Huck <cohuck@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: Halil Pasic <pasic@linux.ibm.com>
Cc: Pierre Morel <pmorel@linux.ibm.com>
Cc: Eric Farman <farman@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 hw/vfio/ap.c                  | 10 +++----
 hw/vfio/ccw.c                 | 11 ++++----
 hw/vfio/common.c              | 53 +++++++++++++++++++----------------
 hw/vfio/pci.c                 |  6 ++--
 include/hw/vfio/vfio-common.h |  4 +--
 5 files changed, 45 insertions(+), 39 deletions(-)

diff --git a/hw/vfio/ap.c b/hw/vfio/ap.c
index 95564c17ed..d0b1bc7581 100644
--- a/hw/vfio/ap.c
+++ b/hw/vfio/ap.c
@@ -105,12 +105,12 @@ static void vfio_ap_realize(DeviceState *dev, Error **errp)
     vapdev->vdev.dev = dev;
 
     /*
-     * vfio-ap devices operate in a way compatible with
-     * memory ballooning, as no pages are pinned in the host.
-     * This needs to be set before vfio_get_device() for vfio common to
-     * handle the balloon inhibitor.
+     * vfio-ap devices operate in a way compatible discarding of memory in
+     * RAM blocks, as no pages are pinned in the host. This needs to be
+     * set before vfio_get_device() for vfio common to handle
+     * ram_block_discard_disable().
      */
-    vapdev->vdev.balloon_allowed = true;
+    vapdev->vdev.ram_block_discard_allowed = true;
 
     ret = vfio_get_device(vfio_group, mdevid, &vapdev->vdev, errp);
     if (ret) {
diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
index c8624943c1..12dd44da52 100644
--- a/hw/vfio/ccw.c
+++ b/hw/vfio/ccw.c
@@ -425,12 +425,13 @@ static void vfio_ccw_get_device(VFIOGroup *group, VFIOCCWDevice *vcdev,
 
     /*
      * All vfio-ccw devices are believed to operate in a way compatible with
-     * memory ballooning, ie. pages pinned in the host are in the current
-     * working set of the guest driver and therefore never overlap with pages
-     * available to the guest balloon driver.  This needs to be set before
-     * vfio_get_device() for vfio common to handle the balloon inhibitor.
+     * discarding of memory in RAM blocks, ie. pages pinned in the host are
+     * in the current working set of the guest driver and therefore never
+     * overlap e.g., with pages available to the guest balloon driver.  This
+     * needs to be set before vfio_get_device() for vfio common to handle
+     * ram_block_discard_disable().
      */
-    vcdev->vdev.balloon_allowed = true;
+    vcdev->vdev.ram_block_discard_allowed = true;
 
     if (vfio_get_device(group, vcdev->cdev.mdevid, &vcdev->vdev, errp)) {
         goto out_err;
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 0b3593b3c0..33357140b8 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -33,7 +33,6 @@
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
 #include "qemu/range.h"
-#include "sysemu/balloon.h"
 #include "sysemu/kvm.h"
 #include "sysemu/reset.h"
 #include "trace.h"
@@ -1215,31 +1214,36 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
     space = vfio_get_address_space(as);
 
     /*
-     * VFIO is currently incompatible with memory ballooning insofar as the
+     * VFIO is currently incompatible with discarding of RAM insofar as the
      * madvise to purge (zap) the page from QEMU's address space does not
      * interact with the memory API and therefore leaves stale virtual to
      * physical mappings in the IOMMU if the page was previously pinned.  We
-     * therefore add a balloon inhibit for each group added to a container,
+     * therefore set discarding broken for each group added to a container,
      * whether the container is used individually or shared.  This provides
      * us with options to allow devices within a group to opt-in and allow
-     * ballooning, so long as it is done consistently for a group (for instance
+     * discarding, so long as it is done consistently for a group (for instance
      * if the device is an mdev device where it is known that the host vendor
      * driver will never pin pages outside of the working set of the guest
-     * driver, which would thus not be ballooning candidates).
+     * driver, which would thus not be discarding candidates).
      *
      * The first opportunity to induce pinning occurs here where we attempt to
      * attach the group to existing containers within the AddressSpace.  If any
-     * pages are already zapped from the virtual address space, such as from a
-     * previous ballooning opt-in, new pinning will cause valid mappings to be
+     * pages are already zapped from the virtual address space, such as from
+     * previous discards, new pinning will cause valid mappings to be
      * re-established.  Likewise, when the overall MemoryListener for a new
      * container is registered, a replay of mappings within the AddressSpace
      * will occur, re-establishing any previously zapped pages as well.
      *
-     * NB. Balloon inhibiting does not currently block operation of the
-     * balloon driver or revoke previously pinned pages, it only prevents
-     * calling madvise to modify the virtual mapping of ballooned pages.
+     * Especially virtio-balloon is currently only prevented from discarding
+     * new memory, it will not yet set ram_block_discard_set_required() and
+     * therefore, neither stops us here or deals with the sudden memory
+     * consumption of inflated memory.
      */
-    qemu_balloon_inhibit(true);
+    ret = ram_block_discard_disable(true);
+    if (ret) {
+        error_setg_errno(errp, -ret, "Cannot set discarding of RAM broken");
+        return ret;
+    }
 
     QLIST_FOREACH(container, &space->containers, next) {
         if (!ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &container->fd)) {
@@ -1405,7 +1409,7 @@ close_fd_exit:
     close(fd);
 
 put_space_exit:
-    qemu_balloon_inhibit(false);
+    ram_block_discard_disable(false);
     vfio_put_address_space(space);
 
     return ret;
@@ -1526,8 +1530,8 @@ void vfio_put_group(VFIOGroup *group)
         return;
     }
 
-    if (!group->balloon_allowed) {
-        qemu_balloon_inhibit(false);
+    if (!group->ram_block_discard_allowed) {
+        ram_block_discard_disable(false);
     }
     vfio_kvm_device_del_group(group);
     vfio_disconnect_container(group);
@@ -1565,22 +1569,23 @@ int vfio_get_device(VFIOGroup *group, const char *name,
     }
 
     /*
-     * Clear the balloon inhibitor for this group if the driver knows the
-     * device operates compatibly with ballooning.  Setting must be consistent
-     * per group, but since compatibility is really only possible with mdev
-     * currently, we expect singleton groups.
+     * Set discarding of RAM as not broken for this group if the driver knows
+     * the device operates compatibly with discarding.  Setting must be
+     * consistent per group, but since compatibility is really only possible
+     * with mdev currently, we expect singleton groups.
      */
-    if (vbasedev->balloon_allowed != group->balloon_allowed) {
+    if (vbasedev->ram_block_discard_allowed !=
+        group->ram_block_discard_allowed) {
         if (!QLIST_EMPTY(&group->device_list)) {
-            error_setg(errp,
-                       "Inconsistent device balloon setting within group");
+            error_setg(errp, "Inconsistent setting of support for discarding "
+                       "RAM (e.g., balloon) within group");
             close(fd);
             return -1;
         }
 
-        if (!group->balloon_allowed) {
-            group->balloon_allowed = true;
-            qemu_balloon_inhibit(false);
+        if (!group->ram_block_discard_allowed) {
+            group->ram_block_discard_allowed = true;
+            ram_block_discard_disable(false);
         }
     }
 
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 342dd6b912..c33c11b7e4 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2796,7 +2796,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     }
 
     /*
-     * Mediated devices *might* operate compatibly with memory ballooning, but
+     * Mediated devices *might* operate compatibly with discarding of RAM, but
      * we cannot know for certain, it depends on whether the mdev vendor driver
      * stays in sync with the active working set of the guest driver.  Prevent
      * the x-balloon-allowed option unless this is minimally an mdev device.
@@ -2809,7 +2809,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
 
     trace_vfio_mdev(vdev->vbasedev.name, is_mdev);
 
-    if (vdev->vbasedev.balloon_allowed && !is_mdev) {
+    if (vdev->vbasedev.ram_block_discard_allowed && !is_mdev) {
         error_setg(errp, "x-balloon-allowed only potentially compatible "
                    "with mdev devices");
         vfio_put_group(group);
@@ -3163,7 +3163,7 @@ static Property vfio_pci_dev_properties[] = {
                     VFIO_FEATURE_ENABLE_IGD_OPREGION_BIT, false),
     DEFINE_PROP_BOOL("x-no-mmap", VFIOPCIDevice, vbasedev.no_mmap, false),
     DEFINE_PROP_BOOL("x-balloon-allowed", VFIOPCIDevice,
-                     vbasedev.balloon_allowed, false),
+                     vbasedev.ram_block_discard_allowed, false),
     DEFINE_PROP_BOOL("x-no-kvm-intx", VFIOPCIDevice, no_kvm_intx, false),
     DEFINE_PROP_BOOL("x-no-kvm-msi", VFIOPCIDevice, no_kvm_msi, false),
     DEFINE_PROP_BOOL("x-no-kvm-msix", VFIOPCIDevice, no_kvm_msix, false),
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index fd564209ac..c78f3ff559 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -108,7 +108,7 @@ typedef struct VFIODevice {
     bool reset_works;
     bool needs_reset;
     bool no_mmap;
-    bool balloon_allowed;
+    bool ram_block_discard_allowed;
     VFIODeviceOps *ops;
     unsigned int num_irqs;
     unsigned int num_regions;
@@ -128,7 +128,7 @@ typedef struct VFIOGroup {
     QLIST_HEAD(, VFIODevice) device_list;
     QLIST_ENTRY(VFIOGroup) next;
     QLIST_ENTRY(VFIOGroup) container_next;
-    bool balloon_allowed;
+    bool ram_block_discard_allowed;
 } VFIOGroup;
 
 typedef struct VFIODMABuf {
-- 
2.25.4

