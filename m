Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEE9500B73
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbiDNKtq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242453AbiDNKti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:49:38 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9534618B38
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933234; x=1681469234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YuSxzN1sk1kFCryZVtMQM+rLrQtwU641Y1zSVCUmBuE=;
  b=ncnQE6pDLnGHx09P1Yo8GFpGN963ATDuJDJDM4ycSjuT6s+mfs3q7a0W
   am0SwT+pkvQd6YBmJQ5NrqAN3OyPxHhoD93ZYEErYhMetL6i9YDSL/Pcy
   QgIZclg7CbBYcxQdqNFyKNoPdxT7B7mWVtpdsO3aNNc8IUzqIGC7BHn+5
   poeNgdu0FZMRHTMrfRmBlz8Jb42qmk3Cg6CWUhwAwiPBqJm8dkUMczJrj
   pDQC25nCfszHW+iIbKiNdVHQlIFqXPmypzpyNgjEAelxH/oRo+aSYFts3
   HIMeWeY21k+qLYipn2VGXJjsSQCJ9PDhlx/XcbJxOHr/ZNb0ml17Tp9U2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808664"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808664"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091189"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:13 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com
Subject: [RFC 04/18] vfio/pci: Use vbasedev local variable in vfio_realize()
Date:   Thu, 14 Apr 2022 03:46:56 -0700
Message-Id: <20220414104710.28534-5-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220414104710.28534-1-yi.l.liu@intel.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

Using a VFIODevice handle local variable to improve the code readability.

no functional change intended

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/pci.c | 49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index e26e65bb1f..e707329394 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -2803,6 +2803,7 @@ static void vfio_unregister_req_notifier(VFIOPCIDevice *vdev)
 static void vfio_realize(PCIDevice *pdev, Error **errp)
 {
     VFIOPCIDevice *vdev = VFIO_PCI(pdev);
+    VFIODevice *vbasedev = &vdev->vbasedev;
     VFIODevice *vbasedev_iter;
     VFIOGroup *group;
     char *tmp, *subsys, group_path[PATH_MAX], *group_name;
@@ -2813,7 +2814,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     int i, ret;
     bool is_mdev;
 
-    if (!vdev->vbasedev.sysfsdev) {
+    if (!vbasedev->sysfsdev) {
         if (!(~vdev->host.domain || ~vdev->host.bus ||
               ~vdev->host.slot || ~vdev->host.function)) {
             error_setg(errp, "No provided host device");
@@ -2821,24 +2822,24 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
                               "or -device vfio-pci,sysfsdev=PATH_TO_DEVICE\n");
             return;
         }
-        vdev->vbasedev.sysfsdev =
+        vbasedev->sysfsdev =
             g_strdup_printf("/sys/bus/pci/devices/%04x:%02x:%02x.%01x",
                             vdev->host.domain, vdev->host.bus,
                             vdev->host.slot, vdev->host.function);
     }
 
-    if (stat(vdev->vbasedev.sysfsdev, &st) < 0) {
+    if (stat(vbasedev->sysfsdev, &st) < 0) {
         error_setg_errno(errp, errno, "no such host device");
-        error_prepend(errp, VFIO_MSG_PREFIX, vdev->vbasedev.sysfsdev);
+        error_prepend(errp, VFIO_MSG_PREFIX, vbasedev->sysfsdev);
         return;
     }
 
-    vdev->vbasedev.name = g_path_get_basename(vdev->vbasedev.sysfsdev);
-    vdev->vbasedev.ops = &vfio_pci_ops;
-    vdev->vbasedev.type = VFIO_DEVICE_TYPE_PCI;
-    vdev->vbasedev.dev = DEVICE(vdev);
+    vbasedev->name = g_path_get_basename(vbasedev->sysfsdev);
+    vbasedev->ops = &vfio_pci_ops;
+    vbasedev->type = VFIO_DEVICE_TYPE_PCI;
+    vbasedev->dev = DEVICE(vdev);
 
-    tmp = g_strdup_printf("%s/iommu_group", vdev->vbasedev.sysfsdev);
+    tmp = g_strdup_printf("%s/iommu_group", vbasedev->sysfsdev);
     len = readlink(tmp, group_path, sizeof(group_path));
     g_free(tmp);
 
@@ -2856,7 +2857,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
         goto error;
     }
 
-    trace_vfio_realize(vdev->vbasedev.name, groupid);
+    trace_vfio_realize(vbasedev->name, groupid);
 
     group = vfio_get_group(groupid, pci_device_iommu_address_space(pdev), errp);
     if (!group) {
@@ -2864,7 +2865,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     }
 
     QLIST_FOREACH(vbasedev_iter, &group->device_list, next) {
-        if (strcmp(vbasedev_iter->name, vdev->vbasedev.name) == 0) {
+        if (strcmp(vbasedev_iter->name, vbasedev->name) == 0) {
             error_setg(errp, "device is already attached");
             vfio_put_group(group);
             goto error;
@@ -2877,22 +2878,22 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
      * stays in sync with the active working set of the guest driver.  Prevent
      * the x-balloon-allowed option unless this is minimally an mdev device.
      */
-    tmp = g_strdup_printf("%s/subsystem", vdev->vbasedev.sysfsdev);
+    tmp = g_strdup_printf("%s/subsystem", vbasedev->sysfsdev);
     subsys = realpath(tmp, NULL);
     g_free(tmp);
     is_mdev = subsys && (strcmp(subsys, "/sys/bus/mdev") == 0);
     free(subsys);
 
-    trace_vfio_mdev(vdev->vbasedev.name, is_mdev);
+    trace_vfio_mdev(vbasedev->name, is_mdev);
 
-    if (vdev->vbasedev.ram_block_discard_allowed && !is_mdev) {
+    if (vbasedev->ram_block_discard_allowed && !is_mdev) {
         error_setg(errp, "x-balloon-allowed only potentially compatible "
                    "with mdev devices");
         vfio_put_group(group);
         goto error;
     }
 
-    ret = vfio_get_device(group, vdev->vbasedev.name, &vdev->vbasedev, errp);
+    ret = vfio_get_device(group, vbasedev->name, vbasedev, errp);
     if (ret) {
         vfio_put_group(group);
         goto error;
@@ -2905,7 +2906,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     }
 
     /* Get a copy of config space */
-    ret = pread(vdev->vbasedev.fd, vdev->pdev.config,
+    ret = pread(vbasedev->fd, vdev->pdev.config,
                 MIN(pci_config_size(&vdev->pdev), vdev->config_size),
                 vdev->config_offset);
     if (ret < (int)MIN(pci_config_size(&vdev->pdev), vdev->config_size)) {
@@ -2933,7 +2934,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
             goto error;
         }
         vfio_add_emulated_word(vdev, PCI_VENDOR_ID, vdev->vendor_id, ~0);
-        trace_vfio_pci_emulated_vendor_id(vdev->vbasedev.name, vdev->vendor_id);
+        trace_vfio_pci_emulated_vendor_id(vbasedev->name, vdev->vendor_id);
     } else {
         vdev->vendor_id = pci_get_word(pdev->config + PCI_VENDOR_ID);
     }
@@ -2944,7 +2945,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
             goto error;
         }
         vfio_add_emulated_word(vdev, PCI_DEVICE_ID, vdev->device_id, ~0);
-        trace_vfio_pci_emulated_device_id(vdev->vbasedev.name, vdev->device_id);
+        trace_vfio_pci_emulated_device_id(vbasedev->name, vdev->device_id);
     } else {
         vdev->device_id = pci_get_word(pdev->config + PCI_DEVICE_ID);
     }
@@ -2956,7 +2957,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
         }
         vfio_add_emulated_word(vdev, PCI_SUBSYSTEM_VENDOR_ID,
                                vdev->sub_vendor_id, ~0);
-        trace_vfio_pci_emulated_sub_vendor_id(vdev->vbasedev.name,
+        trace_vfio_pci_emulated_sub_vendor_id(vbasedev->name,
                                               vdev->sub_vendor_id);
     }
 
@@ -2966,7 +2967,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
             goto error;
         }
         vfio_add_emulated_word(vdev, PCI_SUBSYSTEM_ID, vdev->sub_device_id, ~0);
-        trace_vfio_pci_emulated_sub_device_id(vdev->vbasedev.name,
+        trace_vfio_pci_emulated_sub_device_id(vbasedev->name,
                                               vdev->sub_device_id);
     }
 
@@ -3025,7 +3026,7 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
             goto out_teardown;
         }
 
-        ret = vfio_get_dev_region_info(&vdev->vbasedev,
+        ret = vfio_get_dev_region_info(vbasedev,
                         VFIO_REGION_TYPE_PCI_VENDOR_TYPE | PCI_VENDOR_ID_INTEL,
                         VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION, &opregion);
         if (ret) {
@@ -3101,9 +3102,9 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
     }
 
     if (!pdev->failover_pair_id) {
-        ret = vfio_migration_probe(&vdev->vbasedev, errp);
+        ret = vfio_migration_probe(vbasedev, errp);
         if (ret) {
-            error_report("%s: Migration disabled", vdev->vbasedev.name);
+            error_report("%s: Migration disabled", vbasedev->name);
         }
     }
 
@@ -3120,7 +3121,7 @@ out_teardown:
     vfio_teardown_msi(vdev);
     vfio_bars_exit(vdev);
 error:
-    error_prepend(errp, VFIO_MSG_PREFIX, vdev->vbasedev.name);
+    error_prepend(errp, VFIO_MSG_PREFIX, vbasedev->name);
 }
 
 static void vfio_instance_finalize(Object *obj)
-- 
2.27.0

