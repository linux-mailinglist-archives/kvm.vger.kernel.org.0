Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD8A197311
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 06:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgC3ETR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 00:19:17 -0400
Received: from mga04.intel.com ([192.55.52.120]:46070 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbgC3ETQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 00:19:16 -0400
IronPort-SDR: AZJNbPPgHthjJpxglBvouSLUKtanadxVoWuL5s/Wj8alwc6aaTEcPMmxy7zKMwblvkl8IR25++
 QhwKFqulC9TQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2020 21:19:15 -0700
IronPort-SDR: pvzNqe/wRmrOT/Q4jA66Yw2/UoXbFi0XPuJL5NXYzvOeW9gh/4WqsiHVdhFjHd5hGz//eQPJ2J
 2/A4NAuMWmfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,322,1580803200"; 
   d="scan'208";a="327632016"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga001.jf.intel.com with ESMTP; 29 Mar 2020 21:19:15 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [PATCH v2 03/22] vfio: check VFIO_TYPE1_NESTING_IOMMU support
Date:   Sun, 29 Mar 2020 21:24:42 -0700
Message-Id: <1585542301-84087-4-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO needs to check VFIO_TYPE1_NESTING_IOMMU support with Kernel before
further using it. e.g. requires to check IOMMU UAPI version.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
 hw/vfio/common.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/hw/vfio/common.c b/hw/vfio/common.c
index 0b3593b..c276732 100644
--- a/hw/vfio/common.c
+++ b/hw/vfio/common.c
@@ -1157,12 +1157,21 @@ static void vfio_put_address_space(VFIOAddressSpace *space)
 static int vfio_get_iommu_type(VFIOContainer *container,
                                Error **errp)
 {
-    int iommu_types[] = { VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
+    int iommu_types[] = { VFIO_TYPE1_NESTING_IOMMU,
+                          VFIO_TYPE1v2_IOMMU, VFIO_TYPE1_IOMMU,
                           VFIO_SPAPR_TCE_v2_IOMMU, VFIO_SPAPR_TCE_IOMMU };
-    int i;
+    int i, version;
 
     for (i = 0; i < ARRAY_SIZE(iommu_types); i++) {
         if (ioctl(container->fd, VFIO_CHECK_EXTENSION, iommu_types[i])) {
+            if (iommu_types[i] == VFIO_TYPE1_NESTING_IOMMU) {
+                version = ioctl(container->fd, VFIO_CHECK_EXTENSION,
+                                VFIO_NESTING_IOMMU_UAPI);
+                if (version < IOMMU_UAPI_VERSION) {
+                    info_report("IOMMU UAPI incompatible for nesting");
+                    continue;
+                }
+            }
             return iommu_types[i];
         }
     }
@@ -1278,6 +1287,7 @@ static int vfio_connect_container(VFIOGroup *group, AddressSpace *as,
     }
 
     switch (container->iommu_type) {
+    case VFIO_TYPE1_NESTING_IOMMU:
     case VFIO_TYPE1v2_IOMMU:
     case VFIO_TYPE1_IOMMU:
     {
-- 
2.7.4

