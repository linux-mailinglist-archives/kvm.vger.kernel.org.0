Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC971C6D8A
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgEFJu3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:50:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49823 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728640AbgEFJu2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 05:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZyQ2/G78uwjrsXG8DyLn++e8ECjOAjS5JkIsUcFHqRc=;
        b=jJY0SinqGTKGgyeVMHy3f0+bMljepKLmCS2/dVMHlCA+/mgUOxXDKUtBecjtgsqomURmgk
        CwMpbmkFNWoI6vvGCKQfi6Pp//h97JWtczup/6Gf2mImLe682m8TRt1GUkMuwOF1nHtEvX
        CtCcPv2knrODgnoQ6G/PbR7a4pKQdWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-3cLgPt92PAStbX38m3BNuw-1; Wed, 06 May 2020 05:50:20 -0400
X-MC-Unique: 3cLgPt92PAStbX38m3BNuw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 930921800D4A;
        Wed,  6 May 2020 09:50:18 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5EF75C1D4;
        Wed,  6 May 2020 09:50:05 +0000 (UTC)
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
Subject: [PATCH v1 02/17] vfio: Convert to ram_block_discard_set_broken()
Date:   Wed,  6 May 2020 11:49:33 +0200
Message-Id: <20200506094948.76388-3-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO is (except devices without a physical IOMMU or some mediated devices=
)
incompatible ram_block_discard_set_broken. The kernel will pin basically
all VM memory. Let's convert to ram_block_discard_set_broke(), which can
now fail, in contrast to qemu_balloon_inhibit().

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
index 8649ac15f9..b51546d67a 100644
--- a/hw/vfio/ap.c
+++ b/hw/vfio/ap.c
@@ -105,12 +105,12 @@ static void vfio_ap_realize(DeviceState *dev, Error=
 **errp)
     vapdev->vdev.dev =3D dev;
=20
     /*
-     * vfio-ap devices operate in a way compatible with
-     * memory ballooning, as no pages are pinned in the host.
-     * This needs to be set before vfio_get_device() for vfio common to
-     * handle the balloon inhibitor.
+     * vfio-ap devices operate in a way compatible discarding of memory =
in
+     * RAM blocks, as no pages are pinned in the host. This needs to be
+     * set before vfio_get_device() for vfio common to handle
+     * ram_block_discard_set_broken().
      */
-    vapdev->vdev.balloon_allowed =3D true;
+    vapdev->vdev.ram_block_discard_allowed =3D true;
=20
     ret =3D vfio_get_device(vfio_group, mdevid, &vapdev->vdev, errp);
     if (ret) {
diff --git a/hw/vfio/ccw.c b/hw/vfio/ccw.c
index 50cc2ec75c..0dd6c3f2ab 100644
--- a/hw/vfio/ccw.c
+++ b/hw/vfio/ccw.c
@@ -425,12 +425,13 @@ static void vfio_ccw_get_device(VFIOGroup *group, V=
FIOCCWDevice *vcdev,
=20
     /*
      * All vfio-ccw devices are believed to operate in a way compatible =
with
-     * memory ballooning, ie. pages pinned in the host are in the curren=
t
-     * working set of the guest driver and therefore never overlap with =
pages
-     * available to the guest balloon driver.  This needs to be set befo=
re
-     * vfio_get_device() for vfio common to handle the balloon inhibitor=
.
+     * discarding of memory in RAM blocks, ie. pages pinned in the host =
are
+     * in the current working set of the guest driver and therefore neve=
r
+     * overlap e.g., with pages available to the guest balloon driver.  =
This
+     * needs to be set before vfio_get_device() for vfio common to handl=
e
+     * ram_block_discard_set_broken().
      */
-    vcdev->vdev.balloon_allowed =3D true;
+    vcdev->vdev.ram_block_discard_allowed =3D true;
=20
     if (vfio_get_device(group, vcdev->cdev.mdevid, &vcdev->vdev, errp)) =
{
         goto out_err;
diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 0b3593b3c0..98b2573ae6 100644
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
@@ -1215,31 +1214,36 @@ static int vfio_connect_container(VFIOGroup *grou=
p, AddressSpace *as,
     space =3D vfio_get_address_space(as);
=20
     /*
-     * VFIO is currently incompatible with memory ballooning insofar as =
the
+     * VFIO is currently incompatible with discarding of RAM insofar as =
the
      * madvise to purge (zap) the page from QEMU's address space does no=
t
      * interact with the memory API and therefore leaves stale virtual t=
o
      * physical mappings in the IOMMU if the page was previously pinned.=
  We
-     * therefore add a balloon inhibit for each group added to a contain=
er,
+     * therefore set discarding broken for each group added to a contain=
er,
      * whether the container is used individually or shared.  This provi=
des
      * us with options to allow devices within a group to opt-in and all=
ow
-     * ballooning, so long as it is done consistently for a group (for i=
nstance
+     * discarding, so long as it is done consistently for a group (for i=
nstance
      * if the device is an mdev device where it is known that the host v=
endor
      * driver will never pin pages outside of the working set of the gue=
st
-     * driver, which would thus not be ballooning candidates).
+     * driver, which would thus not be discarding candidates).
      *
      * The first opportunity to induce pinning occurs here where we atte=
mpt to
      * attach the group to existing containers within the AddressSpace. =
 If any
-     * pages are already zapped from the virtual address space, such as =
from a
-     * previous ballooning opt-in, new pinning will cause valid mappings=
 to be
+     * pages are already zapped from the virtual address space, such as =
from
+     * previous discards, new pinning will cause valid mappings to be
      * re-established.  Likewise, when the overall MemoryListener for a =
new
      * container is registered, a replay of mappings within the AddressS=
pace
      * will occur, re-establishing any previously zapped pages as well.
      *
-     * NB. Balloon inhibiting does not currently block operation of the
-     * balloon driver or revoke previously pinned pages, it only prevent=
s
-     * calling madvise to modify the virtual mapping of ballooned pages.
+     * Especially virtio-balloon is currently only prevented from discar=
ding
+     * new memory, it will not yet set ram_block_discard_set_required() =
and
+     * therefore, neither stops us here or deals with the sudden memory
+     * consumption of inflated memory.
      */
-    qemu_balloon_inhibit(true);
+    ret =3D ram_block_discard_set_broken(true);
+    if (ret) {
+        error_setg_errno(errp, -ret, "Cannot set discarding of RAM broke=
n");
+        return ret;
+    }
=20
     QLIST_FOREACH(container, &space->containers, next) {
         if (!ioctl(group->fd, VFIO_GROUP_SET_CONTAINER, &container->fd))=
 {
@@ -1405,7 +1409,7 @@ close_fd_exit:
     close(fd);
=20
 put_space_exit:
-    qemu_balloon_inhibit(false);
+    ram_block_discard_set_broken(false);
     vfio_put_address_space(space);
=20
     return ret;
@@ -1526,8 +1530,8 @@ void vfio_put_group(VFIOGroup *group)
         return;
     }
=20
-    if (!group->balloon_allowed) {
-        qemu_balloon_inhibit(false);
+    if (!group->ram_block_discard_allowed) {
+        ram_block_discard_set_broken(false);
     }
     vfio_kvm_device_del_group(group);
     vfio_disconnect_container(group);
@@ -1565,22 +1569,23 @@ int vfio_get_device(VFIOGroup *group, const char =
*name,
     }
=20
     /*
-     * Clear the balloon inhibitor for this group if the driver knows th=
e
-     * device operates compatibly with ballooning.  Setting must be cons=
istent
-     * per group, but since compatibility is really only possible with m=
dev
-     * currently, we expect singleton groups.
+     * Set discarding of RAM as not broken for this group if the driver =
knows
+     * the device operates compatibly with discarding.  Setting must be
+     * consistent per group, but since compatibility is really only poss=
ible
+     * with mdev currently, we expect singleton groups.
      */
-    if (vbasedev->balloon_allowed !=3D group->balloon_allowed) {
+    if (vbasedev->ram_block_discard_allowed !=3D
+        group->ram_block_discard_allowed) {
         if (!QLIST_EMPTY(&group->device_list)) {
-            error_setg(errp,
-                       "Inconsistent device balloon setting within group=
");
+            error_setg(errp, "Inconsistent setting of support for discar=
ding "
+                       "RAM (e.g., balloon) within group");
             close(fd);
             return -1;
         }
=20
-        if (!group->balloon_allowed) {
-            group->balloon_allowed =3D true;
-            qemu_balloon_inhibit(false);
+        if (!group->ram_block_discard_allowed) {
+            group->ram_block_discard_allowed =3D true;
+            ram_block_discard_set_broken(false);
         }
     }
=20
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index 5e75a95129..88c630c21c 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2796,7 +2796,7 @@ static void vfio_realize(PCIDevice *pdev, Error **e=
rrp)
     }
=20
     /*
-     * Mediated devices *might* operate compatibly with memory balloonin=
g, but
+     * Mediated devices *might* operate compatibly with discarding of RA=
M, but
      * we cannot know for certain, it depends on whether the mdev vendor=
 driver
      * stays in sync with the active working set of the guest driver.  P=
revent
      * the x-balloon-allowed option unless this is minimally an mdev dev=
ice.
@@ -2809,7 +2809,7 @@ static void vfio_realize(PCIDevice *pdev, Error **e=
rrp)
=20
     trace_vfio_mdev(vdev->vbasedev.name, is_mdev);
=20
-    if (vdev->vbasedev.balloon_allowed && !is_mdev) {
+    if (vdev->vbasedev.ram_block_discard_allowed && !is_mdev) {
         error_setg(errp, "x-balloon-allowed only potentially compatible =
"
                    "with mdev devices");
         vfio_put_group(group);
@@ -3163,7 +3163,7 @@ static Property vfio_pci_dev_properties[] =3D {
                     VFIO_FEATURE_ENABLE_IGD_OPREGION_BIT, false),
     DEFINE_PROP_BOOL("x-no-mmap", VFIOPCIDevice, vbasedev.no_mmap, false=
),
     DEFINE_PROP_BOOL("x-balloon-allowed", VFIOPCIDevice,
-                     vbasedev.balloon_allowed, false),
+                     vbasedev.ram_block_discard_allowed, false),
     DEFINE_PROP_BOOL("x-no-kvm-intx", VFIOPCIDevice, no_kvm_intx, false)=
,
     DEFINE_PROP_BOOL("x-no-kvm-msi", VFIOPCIDevice, no_kvm_msi, false),
     DEFINE_PROP_BOOL("x-no-kvm-msix", VFIOPCIDevice, no_kvm_msix, false)=
,
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.=
h
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
=20
 typedef struct VFIODMABuf {
--=20
2.25.3

