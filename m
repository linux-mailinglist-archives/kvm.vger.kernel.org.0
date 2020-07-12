Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DCC21C8CA
	for <lists+kvm@lfdr.de>; Sun, 12 Jul 2020 13:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgGLLOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Jul 2020 07:14:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:45842 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgGLLOm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Jul 2020 07:14:42 -0400
IronPort-SDR: Zds/Nq9M4fu9M9OB0wadj7DaDw9PkYDhVcpftVkoeLuKm5saSRK+DXEf8eiWHEUynkTBLHrHS4
 OQjGB52VWtLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9679"; a="149952707"
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="149952707"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2020 04:14:30 -0700
IronPort-SDR: 03Gj6Zb8FCAKTGHfutw7cz8QK1SdZ/OLlD5h4XmGhZTuEVFTpSFsbQBEDUvrKJTOfl+99OkOz0
 7Mbw8cpyILpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,343,1589266800"; 
   d="scan'208";a="315788591"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga008.jf.intel.com with ESMTP; 12 Jul 2020 04:14:30 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, jean-philippe@linaro.org, peterx@redhat.com,
        hao.wu@intel.com, stefanha@gmail.com,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 14/15] vfio: Document dual stage control
Date:   Sun, 12 Jul 2020 04:21:09 -0700
Message-Id: <1594552870-55687-15-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

The VFIO API was enhanced to support nested stage control: a bunch of
new iotcls and usage guideline.

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
 Documentation/driver-api/vfio.rst | 67 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index f1a4d3c..0672c45 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -239,6 +239,73 @@ group and can access them as follows::
 	/* Gratuitous device reset and go... */
 	ioctl(device, VFIO_DEVICE_RESET);
 
+IOMMU Dual Stage Control
+------------------------
+
+Some IOMMUs support 2 stages/levels of translation. Stage corresponds to
+the ARM terminology while level corresponds to Intel's VTD terminology.
+In the following text we use either without distinction.
+
+This is useful when the guest is exposed with a virtual IOMMU and some
+devices are assigned to the guest through VFIO. Then the guest OS can use
+stage 1 (GIOVA -> GPA or GVA->GPA), while the hypervisor uses stage 2 for
+VM isolation (GPA -> HPA).
+
+Under dual stage translation, the guest gets ownership of the stage 1 page
+tables and also owns stage 1 configuration structures. The hypervisor owns
+the root configuration structure (for security reason), including stage 2
+configuration. This works as long as configuration structures and page table
+formats are compatible between the virtual IOMMU and the physical IOMMU.
+
+Assuming the HW supports it, this nested mode is selected by choosing the
+VFIO_TYPE1_NESTING_IOMMU type through:
+
+    ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
+
+This forces the hypervisor to use the stage 2, leaving stage 1 available
+for guest usage. The guest stage 1 format depends on IOMMU vendor, and
+it is the same with the nesting configuration method. User space should
+check the format and configuration method after setting nesting type by
+using:
+
+    ioctl(container->fd, VFIO_IOMMU_GET_INFO, &nesting_info);
+
+Details can be found in Documentation/userspace-api/iommu.rst. For Intel
+VT-d, each stage 1 page table is bound to host by:
+
+    nesting_op->flags = VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
+    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
+    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
+
+As mentioned above, guest OS may use stage 1 for GIOVA->GPA or GVA->GPA.
+GVA->GPA page tables are available when PASID (Process Address Space ID)
+is exposed to guest. e.g. guest with PASID-capable devices assigned. For
+such page table binding, the bind_data should include PASID info, which
+is allocated by guest itself or by host. This depends on hardware vendor.
+e.g. Intel VT-d requires to allocate PASID from host. This requirement is
+defined by the Virtual Command Support in VT-d 3.0 spec, guest software
+running on VT-d should allocate PASID from host kernel. To allocate PASID
+from host, user space should check the IOMMU_NESTING_FEAT_SYSWIDE_PASID
+bit of the nesting info reported from host kernel. VFIO reports the nesting
+info by VFIO_IOMMU_GET_INFO. User space could allocate PASID from host by:
+
+    req.flags = VFIO_IOMMU_ALLOC_PASID;
+    ioctl(container, VFIO_IOMMU_PASID_REQUEST, &req);
+
+With first stage/level page table bound to host, it allows to combine the
+guest stage 1 translation along with the hypervisor stage 2 translation to
+get final address.
+
+When the guest invalidates stage 1 related caches, invalidations must be
+forwarded to the host through
+
+    nesting_op->flags = VFIO_IOMMU_NESTING_OP_CACHE_INVLD;
+    memcpy(&nesting_op->data, &inv_data, sizeof(inv_data));
+    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
+
+Those invalidations can happen at various granularity levels, page, context,
+...
+
 VFIO User API
 -------------------------------------------------------------------------------
 
-- 
2.7.4

