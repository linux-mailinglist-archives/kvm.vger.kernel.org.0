Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2DBB500B7F
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242494AbiDNKuI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242479AbiDNKtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:49:55 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0943F7E58A
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933241; x=1681469241;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k4VcpDgjB2tGSrAgzMFAbDoDoLC4lC0u8qknfORhCBg=;
  b=XBU0qTSSAJc84L06Qpk0/NGE250U0UPvdj8DUesr60PMAMwE2hH+rD3y
   HLYA53LuJrEg4s64KGugrtRKAqSW0enjq2JunLm3Nt2IHcWVZs1fEJqmH
   AW2udxNpoJahIIVbui1UYFW/YrDSP7rXSV8xJnp1IoRFvc/pP0DJFBDyU
   JjyHlIhCsV/YP9pZM4lbwb09aswGcXq81getin5uRW96/z2u+MlPfEgAy
   jRYV/gpZqvsmQ6E/U2SXdqebkFxGOGNpPtWHbcsJ9R0oQWEDtpuZ/UQIf
   ug8GKwfYMDvIjrx8mr3EHd/AcCINAh54aRsmKxWUFdwIYmrZKsdUoLbPS
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808684"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808684"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091226"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:18 -0700
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
Subject: [RFC 10/18] vfio/ap: Use vfio_[attach/detach]_device
Date:   Thu, 14 Apr 2022 03:47:02 -0700
Message-Id: <20220414104710.28534-11-yi.l.liu@intel.com>
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

Let the vfio-ap device use vfio_attach_device() and
vfio_detach_device(), hence hiding the details of the used
IOMMU backend.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/ap.c | 62 ++++++++--------------------------------------------
 1 file changed, 9 insertions(+), 53 deletions(-)

diff --git a/hw/vfio/ap.c b/hw/vfio/ap.c
index e0dd561e85..286ac638e5 100644
--- a/hw/vfio/ap.c
+++ b/hw/vfio/ap.c
@@ -50,58 +50,17 @@ struct VFIODeviceOps vfio_ap_ops = {
     .vfio_compute_needs_reset = vfio_ap_compute_needs_reset,
 };
 
-static void vfio_ap_put_device(VFIOAPDevice *vapdev)
-{
-    g_free(vapdev->vdev.name);
-    vfio_put_base_device(&vapdev->vdev);
-}
-
-static VFIOGroup *vfio_ap_get_group(VFIOAPDevice *vapdev, Error **errp)
-{
-    GError *gerror = NULL;
-    char *symlink, *group_path;
-    int groupid;
-
-    symlink = g_strdup_printf("%s/iommu_group", vapdev->vdev.sysfsdev);
-    group_path = g_file_read_link(symlink, &gerror);
-    g_free(symlink);
-
-    if (!group_path) {
-        error_setg(errp, "%s: no iommu_group found for %s: %s",
-                   TYPE_VFIO_AP_DEVICE, vapdev->vdev.sysfsdev, gerror->message);
-        g_error_free(gerror);
-        return NULL;
-    }
-
-    if (sscanf(basename(group_path), "%d", &groupid) != 1) {
-        error_setg(errp, "vfio: failed to read %s", group_path);
-        g_free(group_path);
-        return NULL;
-    }
-
-    g_free(group_path);
-
-    return vfio_get_group(groupid, &address_space_memory, errp);
-}
-
 static void vfio_ap_realize(DeviceState *dev, Error **errp)
 {
-    int ret;
-    char *mdevid;
-    VFIOGroup *vfio_group;
     APDevice *apdev = AP_DEVICE(dev);
     VFIOAPDevice *vapdev = VFIO_AP_DEVICE(apdev);
+    VFIODevice *vbasedev = &vapdev->vdev;
+    int ret;
 
-    vfio_group = vfio_ap_get_group(vapdev, errp);
-    if (!vfio_group) {
-        return;
-    }
-
-    vapdev->vdev.ops = &vfio_ap_ops;
-    vapdev->vdev.type = VFIO_DEVICE_TYPE_AP;
-    mdevid = basename(vapdev->vdev.sysfsdev);
-    vapdev->vdev.name = g_strdup_printf("%s", mdevid);
-    vapdev->vdev.dev = dev;
+    vbasedev->name = g_path_get_basename(vbasedev->sysfsdev);
+    vbasedev->ops = &vfio_ap_ops;
+    vbasedev->type = VFIO_DEVICE_TYPE_AP;
+    vbasedev->dev = dev;
 
     /*
      * vfio-ap devices operate in a way compatible with discarding of
@@ -111,7 +70,7 @@ static void vfio_ap_realize(DeviceState *dev, Error **errp)
      */
     vapdev->vdev.ram_block_discard_allowed = true;
 
-    ret = vfio_get_device(vfio_group, mdevid, &vapdev->vdev, errp);
+    ret = vfio_attach_device(vbasedev, &address_space_memory, errp);
     if (ret) {
         goto out_get_dev_err;
     }
@@ -119,18 +78,15 @@ static void vfio_ap_realize(DeviceState *dev, Error **errp)
     return;
 
 out_get_dev_err:
-    vfio_ap_put_device(vapdev);
-    vfio_put_group(vfio_group);
+    vfio_detach_device(vbasedev);
 }
 
 static void vfio_ap_unrealize(DeviceState *dev)
 {
     APDevice *apdev = AP_DEVICE(dev);
     VFIOAPDevice *vapdev = VFIO_AP_DEVICE(apdev);
-    VFIOGroup *group = vapdev->vdev.group;
 
-    vfio_ap_put_device(vapdev);
-    vfio_put_group(group);
+    vfio_detach_device(&vapdev->vdev);
 }
 
 static Property vfio_ap_properties[] = {
-- 
2.27.0

