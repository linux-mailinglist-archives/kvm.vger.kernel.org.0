Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E26500B7C
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242483AbiDNKuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242495AbiDNKuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:50:08 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355B87E5BA
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933264; x=1681469264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F9ZmIqeNr50Fo8Vzy6kBuBQvKFH22JABuQLYrlJNHNM=;
  b=nnCXKlxbbU7ZhPjVAl5ZMUCkyF3O8gdxINOsBnCuvWXKHA34tC4d2MHk
   yllEsI6XS2D0ebAqjZNnT0ZDk5oLkBw7K1zgkFi/Drb61nlRen8hhY00g
   10MddOX6srdhBewYgknsr0JFPGFgb0aMaF0jILPfj7mo5HBQS42o6XQuM
   z4jkQcX9/YIqf00m9Ejlku99V0RAjgZ8ooF1NiwFO5MSXcLHb4vaK1Hqs
   zuA/lbALsWS7T7cNE83aDTeKllzSbozCTIM4FDxDGxV3fivb9bViK+JgE
   lCWzU/yANMaIQ/kw7WFHfybhOx2AwNWGP47oL3dkJcesM1mCu/x2fSUrV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808702"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808702"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091263"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:24 -0700
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
Subject: [RFC 17/18] vfio/as: Allow the selection of a given iommu backend
Date:   Thu, 14 Apr 2022 03:47:09 -0700
Message-Id: <20220414104710.28534-18-yi.l.liu@intel.com>
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

Now we support two types of iommu backends, let's add the capability
to select one of them. This is based on a VFIODevice auto/on/off
iommu_be field. This field is likely to be forced to a given value or
set by a device option.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 hw/vfio/as.c                  | 31 ++++++++++++++++++++++++++++++-
 include/hw/vfio/vfio-common.h |  1 +
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/hw/vfio/as.c b/hw/vfio/as.c
index 13a6653a0d..fce7a088e9 100644
--- a/hw/vfio/as.c
+++ b/hw/vfio/as.c
@@ -985,16 +985,45 @@ vfio_get_container_class(VFIOIOMMUBackendType be)
     case VFIO_IOMMU_BACKEND_TYPE_LEGACY:
         klass = object_class_by_name(TYPE_VFIO_LEGACY_CONTAINER);
         return VFIO_CONTAINER_OBJ_CLASS(klass);
+    case VFIO_IOMMU_BACKEND_TYPE_IOMMUFD:
+        klass = object_class_by_name(TYPE_VFIO_IOMMUFD_CONTAINER);
+        return VFIO_CONTAINER_OBJ_CLASS(klass);
     default:
         return NULL;
     }
 }
 
+static VFIOContainerClass *
+select_iommu_backend(OnOffAuto value, Error **errp)
+{
+    VFIOContainerClass *vccs = NULL;
+
+    if (value == ON_OFF_AUTO_OFF) {
+        return vfio_get_container_class(VFIO_IOMMU_BACKEND_TYPE_LEGACY);
+    } else {
+        int iommufd = qemu_open_old("/dev/iommu", O_RDWR);
+
+        vccs = vfio_get_container_class(VFIO_IOMMU_BACKEND_TYPE_IOMMUFD);
+        if (iommufd < 0 || !vccs) {
+            if (value == ON_OFF_AUTO_AUTO) {
+                vccs = vfio_get_container_class(VFIO_IOMMU_BACKEND_TYPE_LEGACY);
+            } else { /* ON */
+                error_setg(errp, "iommufd backend is not supported by %s",
+                           iommufd < 0 ? "the host" : "QEMU");
+                error_append_hint(errp, "set iommufd=off\n");
+                vccs = NULL;
+            }
+        }
+        close(iommufd);
+    }
+    return vccs;
+}
+
 int vfio_attach_device(VFIODevice *vbasedev, AddressSpace *as, Error **errp)
 {
     VFIOContainerClass *vccs;
 
-    vccs = vfio_get_container_class(VFIO_IOMMU_BACKEND_TYPE_LEGACY);
+    vccs = select_iommu_backend(vbasedev->iommufd_be, errp);
     if (!vccs) {
         return -ENOENT;
     }
diff --git a/include/hw/vfio/vfio-common.h b/include/hw/vfio/vfio-common.h
index bef48ddfaf..2d941aae70 100644
--- a/include/hw/vfio/vfio-common.h
+++ b/include/hw/vfio/vfio-common.h
@@ -126,6 +126,7 @@ typedef struct VFIODevice {
     VFIOMigration *migration;
     Error *migration_blocker;
     OnOffAuto pre_copy_dirty_page_tracking;
+    OnOffAuto iommufd_be;
 } VFIODevice;
 
 struct VFIODeviceOps {
-- 
2.27.0

