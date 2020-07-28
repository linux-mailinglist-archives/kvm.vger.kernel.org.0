Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D682302A9
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgG1GVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:21:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:26362 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727889AbgG1GVD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:21:03 -0400
IronPort-SDR: bGsQej7oEKNIENMRiu5dNvCJIiG6f/BJub18ixTM1S+3++3vP4ja9vKjMbTsA+wTaC02G7Eq6j
 ZSgW0Ftt6iSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="212681251"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="212681251"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:20:57 -0700
IronPort-SDR: gXAOZDukgeX+kYdgb8zM1TTJdu2c5GzPJb9m+STapDMByJIVXy4EWfOg2G3IIHZCE9u8D+wy7f
 G2H6KiVCQSWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="320274428"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 27 Jul 2020 23:20:56 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 14/15] vfio: Document dual stage control
Date:   Mon, 27 Jul 2020 23:27:43 -0700
Message-Id: <1595917664-33276-15-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

The VFIO API was enhanced to support nested stage control: a bunch of
new ioctls and usage guideline.

Let's document the process to follow to set up nested mode.

Cc: Kevin Tian <kevin.tian@intel.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
v5 -> v6:
*) tweak per Eric's comments.

v3 -> v4:
*) add review-by from Stefan Hajnoczi

v2 -> v3:
*) address comments from Stefan Hajnoczi

v1 -> v2:
*) new in v2, compared with Eric's original version, pasid table bind
   and fault reporting is removed as this series doesn't cover them.
   Original version from Eric.
   https://lkml.org/lkml/2020/3/20/700
---
 Documentation/driver-api/vfio.rst | 75 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index f1a4d3c..c0d43f0 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -239,6 +239,81 @@ group and can access them as follows::
 	/* Gratuitous device reset and go... */
 	ioctl(device, VFIO_DEVICE_RESET);
 
+IOMMU Dual Stage Control
+------------------------
+
+Some IOMMUs support 2 stages/levels of translation. Stage corresponds
+to the ARM terminology while level corresponds to Intel's terminology.
+In the following text we use either without distinction.
+
+This is useful when the guest is exposed with a virtual IOMMU and some
+devices are assigned to the guest through VFIO. Then the guest OS can
+use stage-1 (GIOVA -> GPA or GVA->GPA), while the hypervisor uses stage
+2 for VM isolation (GPA -> HPA).
+
+Under dual stage translation, the guest gets ownership of the stage-1 page
+tables and also owns stage-1 configuration structures. The hypervisor owns
+the root configuration structure (for security reason), including stage-2
+configuration. This works as long as configuration structures and page table
+formats are compatible between the virtual IOMMU and the physical IOMMU.
+
+Assuming the HW supports it, this nested mode is selected by choosing the
+VFIO_TYPE1_NESTING_IOMMU type through:
+
+    ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
+
+This forces the hypervisor to use the stage-2, leaving stage-1 available
+for guest usage. The stage-1 format and binding method are vendor specific
+and reported in nesting cap (VFIO_IOMMU_TYPE1_INFO_CAP_NESTING) through
+VFIO_IOMMU_GET_INFO:
+
+    ioctl(container->fd, VFIO_IOMMU_GET_INFO, &nesting_info);
+
+The nesting cap info is available only after NESTING_IOMMU is selected.
+If underlying IOMMU doesn't support nesting, VFIO_SET_IOMMU fails and
+userspace should try other IOMMU types. Details of the nesting cap info
+can be found in Documentation/userspace-api/iommu.rst.
+
+The stage-1 page table can be bound to the IOMMU in two methods: directly
+or indirectly. Direct binding requires userspace to notify VFIO of every
+guest stage-1 page table binding, while indirect binding allows userspace
+to bind once with an intermediate structure (e.g. PASID table) which
+indirectly links to guest stage-1 page tables. The actual binding method
+depends on IOMMU vendor. Currently only the direct binding capability (
+IOMMU_NESTING_FEAT_BIND_PGTBL) is supported:
+
+    nesting_op->flags = VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
+    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
+    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
+
+When multiple stage-1 page tables are supported on a device, each page
+table is associated with a PASID (Process Address Space ID) to differentiate
+with each other. In such case, userspace should include PASID in the
+bind_data when issuing direct binding request.
+
+PASID could be managed per-device or system-wide which, again, depends on
+IOMMU vendor and is reported in nesting cap info. When system-wide policy
+is reported (IOMMU_NESTING_FEAT_SYSWIDE_PASID), e.g. as by Intel platforms,
+userspace *must* allocate PASID from VFIO before attempting binding of
+stage-1 page table:
+
+    req.flags = VFIO_IOMMU_ALLOC_PASID;
+    ioctl(container, VFIO_IOMMU_PASID_REQUEST, &req);
+
+Once the stage-1 page table is bound to the IOMMU, the guest is allowed to
+fully manage its mapping at its disposal. The IOMMU walks nested stage-1
+and stage-2 page tables when serving DMA requests from assigned device, and
+may cache the stage-1 mapping in the IOTLB. When required (IOMMU_NESTING_
+FEAT_CACHE_INVLD), userspace *must* forward guest stage-1 invalidation to
+the host, so the IOTLB is invalidated:
+
+    nesting_op->flags = VFIO_IOMMU_NESTING_OP_CACHE_INVLD;
+    memcpy(&nesting_op->data, &cache_inv_data, sizeof(cache_inv_data));
+    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
+
+Forwarded invalidations can happen at various granularity levels (page
+level, context level, etc.)
+
 VFIO User API
 -------------------------------------------------------------------------------
 
-- 
2.7.4

