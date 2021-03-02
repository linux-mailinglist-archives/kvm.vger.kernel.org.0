Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC1F32A730
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837868AbhCBQFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:05:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:37924 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1446897AbhCBMl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:41:28 -0500
IronPort-SDR: gNxeoZDESLjeTqDsyShJALHRZyMPC70jBjReRWPpxwYQKZ3OgqbfUkI8Lqwv0vy+yfivnRaenR
 M0IS5JFzV71g==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="206431284"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="206431284"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:37:30 -0800
IronPort-SDR: +bnqDXtZjncSG44eBre9yQ1J3gqP/VB8tzZfP4kWU5t71DypcRw0wyIkYZ2r573PuPSL9leJxx
 Q96lIiyp2U2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472182"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:37:26 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        jasowang@redhat.com, hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        jgg@nvidia.com, Lingshan.Zhu@intel.com, vivek.gautam@arm.com,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [Patch v8 09/10] vfio: Document dual stage control
Date:   Wed,  3 Mar 2021 04:35:44 +0800
Message-Id: <20210302203545.436623-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203545.436623-1-yi.l.liu@intel.com>
References: <20210302203545.436623-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
v7 -> v8:
*) remove SYSWIDE_PASID description, point to /dev/ioasid when mentioning
   PASID allocation from host.

v6 -> v7:
*) tweak per Eric's comments.

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
   https://lore.kernel.org/kvm/20200320161911.27494-12-eric.auger@redhat.com/
---
 Documentation/driver-api/vfio.rst | 77 +++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index f1a4d3c3ba0b..9ccf9d63b72f 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -239,6 +239,83 @@ group and can access them as follows::
 	/* Gratuitous device reset and go... */
 	ioctl(device, VFIO_DEVICE_RESET);
 
+IOMMU Dual Stage Control
+------------------------
+
+Some IOMMUs support 2 stages/levels of translation. Stage corresponds
+to the ARM terminology while level corresponds to Intel's terminology.
+In the following text, we use either without distinction.
+
+This is useful when the guest is exposed with a virtual IOMMU and some
+devices are assigned to the guest through VFIO. Then the guest OS can
+use stage-1 (GIOVA -> GPA or GVA->GPA), while the hypervisor uses stage
+2 for VM isolation (GPA -> HPA).
+
+Under dual-stage translation, the guest gets ownership of the stage-1
+page tables or both the stage-1 configuration structures and page tables.
+This depends on vendor. e.g. on Intel platform, the guest owns stage-1
+page tables under nesting. While on ARM, the guest owns both the stage-1
+configuration structures and page tables under nesting. The hypervisor
+owns the root configuration structure (for security reasons), including
+stage-2 configuration. This works as long as configuration structures
+and page table formats are compatible between the virtual IOMMU and the
+physical IOMMU.
+
+Assuming the HW supports it, this nested mode is selected by choosing the
+VFIO_TYPE1_NESTING_IOMMU type through:
+
+    ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
+
+This forces the hypervisor to use the stage-2, leaving stage-1 available
+for guest usage.
+The stage-1 format and binding method are reported in nesting capability.
+(VFIO_IOMMU_TYPE1_INFO_CAP_NESTING) through VFIO_IOMMU_GET_INFO:
+
+    ioctl(container->fd, VFIO_IOMMU_GET_INFO, &nesting_info);
+
+The nesting cap info is available only after NESTING_IOMMU is selected.
+If the underlying IOMMU doesn't support nesting, VFIO_SET_IOMMU fails and
+userspace should try other IOMMU types. Details of the nesting cap info
+can be found in Documentation/userspace-api/iommu.rst.
+
+Bind stage-1 page table to the IOMMU differs per platform. On Intel,
+the stage1 page table info are mediated by the userspace for each PASID.
+On ARM, the userspace directly passes the GPA of the whole PASID table.
+Currently only Intel's binding is supported (IOMMU_NESTING_FEAT_BIND_PGTBL)
+is supported:
+
+    nesting_op->flags = VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
+    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
+    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
+
+When multiple stage-1 page tables are supported on a device, each page
+table is associated with a PASID (Process Address Space ID) to differentiate
+with each other. In such case, userspace should include PASID in the
+bind_data when issuing direct binding requests.
+
+PASID could be managed per-device or system-wide which, again, depends on
+IOMMU vendor. e.g. as by Intel platforms, userspace *must* allocate PASID
+from host before attempting binding of stage-1 page table, the allocation
+is done by the /dev/ioasid interface. For systems without /dev/ioasid,
+userspace should not go further binding page table and shall be failed
+by the kernel. For the usage of /dev/ioasid, please refer to below doc:
+
+    Documentation/userspace-api/ioasid.rst
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
2.25.1

