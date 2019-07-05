Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0377B61053
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 13:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfGFLS6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 07:18:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:3884 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfGFLS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 07:18:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jul 2019 04:18:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,458,1557212400"; 
   d="scan'208";a="363354925"
Received: from yiliu-dev.bj.intel.com ([10.238.156.139])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2019 04:18:54 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com
Cc:     eric.auger@redhat.com, david@gibson.dropbear.id.au,
        tianyu.lan@intel.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v1 02/18] linux-headers: import vfio.h from kernel
Date:   Fri,  5 Jul 2019 19:01:35 +0800
Message-Id: <1562324511-2910-3-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
References: <1562324511-2910-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch imports the vIOMMU related definitions from kernel
uapi/vfio.h. e.g. pasid allocation, guest pasid bind, guest pasid
table bind and guest iommu cache invalidation.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
---
 linux-headers/linux/vfio.h | 116 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 116 insertions(+)

diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 24f5051..551648e 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/iommu.h>
 
 #define VFIO_API_VERSION	0
 
@@ -763,6 +764,121 @@ struct vfio_iommu_type1_dma_unmap {
 #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
 #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
 
+/**
+ * VFIO_IOMMU_ATTACH_PASID_TABLE - _IOWR(VFIO_TYPE, VFIO_BASE + 22,
+ *			struct vfio_iommu_type1_attach_pasid_table)
+ *
+ * Passes the PASID table to the host. Calling ATTACH_PASID_TABLE
+ * while a table is already installed is allowed: it replaces the old
+ * table. DETACH does a comprehensive tear down of the nested mode.
+ */
+struct vfio_iommu_type1_attach_pasid_table {
+	__u32	argsz;
+	__u32	flags;
+	struct iommu_pasid_table_config config;
+};
+#define VFIO_IOMMU_ATTACH_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 22)
+
+/**
+ * VFIO_IOMMU_DETACH_PASID_TABLE - - _IOWR(VFIO_TYPE, VFIO_BASE + 23)
+ * Detaches the PASID table
+ */
+#define VFIO_IOMMU_DETACH_PASID_TABLE	_IO(VFIO_TYPE, VFIO_BASE + 23)
+
+/**
+ * VFIO_IOMMU_CACHE_INVALIDATE - _IOWR(VFIO_TYPE, VFIO_BASE + 24,
+ *			struct vfio_iommu_type1_cache_invalidate)
+ *
+ * Propagate guest IOMMU cache invalidation to the host.
+ */
+struct vfio_iommu_type1_cache_invalidate {
+	__u32   argsz;
+	__u32   flags;
+	struct iommu_cache_invalidate_info info;
+};
+#define VFIO_IOMMU_CACHE_INVALIDATE      _IO(VFIO_TYPE, VFIO_BASE + 24)
+
+/*
+ * @flag=VFIO_IOMMU_PASID_ALLOC, refer to the @min_pasid and @max_pasid fields
+ * @flag=VFIO_IOMMU_PASID_FREE, refer to @pasid field
+ */
+struct vfio_iommu_type1_pasid_request {
+	__u32	argsz;
+#define VFIO_IOMMU_PASID_ALLOC	(1 << 0)
+#define VFIO_IOMMU_PASID_FREE	(1 << 1)
+	__u32	flag;
+	union {
+		struct {
+			int min_pasid;
+			int max_pasid;
+		};
+		int pasid;
+	};
+};
+
+/**
+ * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 27,
+ *				struct vfio_iommu_type1_pasid_request)
+ *
+ */
+#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 27)
+
+/*
+ * In guest use of SVA, the first level page tables is managed by the guest.
+ * we can either bind guest PASID table or explicitly bind a PASID with guest
+ * page table.
+ */
+struct vfio_iommu_type1_bind_guest_pasid {
+	struct gpasid_bind_data bind_data;
+};
+
+enum vfio_iommu_bind_type {
+	VFIO_IOMMU_BIND_PROCESS,
+	VFIO_IOMMU_BIND_GUEST_PASID,
+};
+
+/*
+ * Supported types:
+ *     - VFIO_IOMMU_BIND_PROCESS: bind native process, which takes
+ *                      vfio_iommu_type1_bind_process in data.
+ *     - VFIO_IOMMU_BIND_GUEST_PASID: bind guest pasid, which invoked
+ *                      by guest process binding, it takes
+ *                      vfio_iommu_type1_bind_guest_pasid in data.
+ */
+struct vfio_iommu_type1_bind {
+	__u32				argsz;
+	enum vfio_iommu_bind_type	bind_type;
+	__u8				data[];
+};
+
+/*
+ * VFIO_IOMMU_BIND - _IOWR(VFIO_TYPE, VFIO_BASE + 28, struct vfio_iommu_bind)
+ *
+ * Manage address spaces of devices in this container. Initially a TYPE1
+ * container can only have one address space, managed with
+ * VFIO_IOMMU_MAP/UNMAP_DMA.
+ *
+ * An IOMMU of type VFIO_TYPE1_NESTING_IOMMU can be managed by both MAP/UNMAP
+ * and BIND ioctls at the same time. MAP/UNMAP acts on the stage-2 (host) page
+ * tables, and BIND manages the stage-1 (guest) page tables. Other types of
+ * IOMMU may allow MAP/UNMAP and BIND to coexist, where MAP/UNMAP controls
+ * non-PASID traffic and BIND controls PASID traffic. But this depends on the
+ * underlying IOMMU architecture and isn't guaranteed.
+ *
+ * Availability of this feature depends on the device, its bus, the underlying
+ * IOMMU and the CPU architecture.
+ *
+ * returns: 0 on success, -errno on failure.
+ */
+#define VFIO_IOMMU_BIND		_IO(VFIO_TYPE, VFIO_BASE + 28)
+
+/*
+ * VFIO_IOMMU_UNBIND - _IOWR(VFIO_TYPE, VFIO_BASE + 29, struct vfio_iommu_bind)
+ *
+ * Undo what was done by the corresponding VFIO_IOMMU_BIND ioctl.
+ */
+#define VFIO_IOMMU_UNBIND	_IO(VFIO_TYPE, VFIO_BASE + 29)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.7.4

