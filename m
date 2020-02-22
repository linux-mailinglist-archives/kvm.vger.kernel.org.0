Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23E61168D69
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2020 09:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgBVIC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Feb 2020 03:02:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:63022 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbgBVIB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Feb 2020 03:01:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Feb 2020 00:01:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,471,1574150400"; 
   d="scan'208";a="240547662"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by orsmga006.jf.intel.com with ESMTP; 22 Feb 2020 00:01:56 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com
Cc:     pbonzini@redhat.com, mst@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        yi.l.liu@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        kvm@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v3.1 04/22] hw/iommu: introduce HostIOMMUContext
Date:   Sat, 22 Feb 2020 00:07:05 -0800
Message-Id: <1582358843-51931-5-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
References: <1582358843-51931-1-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, many platform vendors provide the capability of dual stage
DMA address translation in hardware. For example, nested translation
on Intel VT-d scalable mode, nested stage translation on ARM SMMUv3,
and etc. In dual stage DMA address translation, there are two stages
address translation, stage-1 (a.k.a first-level) and stage-2 (a.k.a
second-level) translation structures. Stage-1 translation results are
also subjected to stage-2 translation structures. Take vSVA (Virtual
Shared Virtual Addressing) as an example, guest IOMMU driver owns
stage-1 translation structures (covers GVA->GPA translation), and host
IOMMU driver owns stage-2 translation structures (covers GPA->HPA
translation). VMM is responsible to bind stage-1 translation structures
to host, thus hardware could achieve GVA->GPA and then GPA->HPA
translation. For more background on SVA, refer the below links.
 - https://www.youtube.com/watch?v=Kq_nfGK5MwQ
 - https://events19.lfasiallc.com/wp-content/uploads/2017/11/\
Shared-Virtual-Memory-in-KVM_Yi-Liu.pdf

In QEMU, vIOMMU emualtors expose IOMMUs to VM per their own spec. Devices
are pass-through to guest via device pass-through components like VFIO.
VFIO is a userspace driver framework which exposes host IOMMU programming
capability to userspace in a secure way. e.g. IOVA MAP/UNMAP requests. Thus
the major connection between VFIO and vIOMMU are MAP/UNMAP. However, with
the dual stage DMA translation support, there are more interactions between
vIOMMU and VFIO as below:
 1) PASID allocation (allow host to intercept in PASID allocation)
 2) bind stage-1 translation structures to host
 3) propagate stage-1 cache invalidation to host
 4) DMA address translation fault (I/O page fault) servicing etc.

With the above new interactions, it requires an abstract layer to abstract
the above operations and expose to vIOMMU emulators as an explicit way for
vIOMMU emulators call into VFIO. This patch introduces HostIOMMUContext to
stand for hardware IOMMU w/ dual stage DMA address translation capability.
PASID allocation/free are the first two operations included to demonstrate
the design, in future, there will be more operations like bind_stage1_pgtbl
and invalidate_stage1_cache and etc.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 hw/Makefile.objs                      |  1 +
 hw/iommu/Makefile.objs                |  1 +
 hw/iommu/host_iommu_context.c         | 55 +++++++++++++++++++++++++++++++
 include/hw/iommu/host_iommu_context.h | 61 +++++++++++++++++++++++++++++++++++
 4 files changed, 118 insertions(+)
 create mode 100644 hw/iommu/Makefile.objs
 create mode 100644 hw/iommu/host_iommu_context.c
 create mode 100644 include/hw/iommu/host_iommu_context.h

diff --git a/hw/Makefile.objs b/hw/Makefile.objs
index 660e2b4..cab83fe 100644
--- a/hw/Makefile.objs
+++ b/hw/Makefile.objs
@@ -40,6 +40,7 @@ devices-dirs-$(CONFIG_MEM_DEVICE) += mem/
 devices-dirs-$(CONFIG_NUBUS) += nubus/
 devices-dirs-y += semihosting/
 devices-dirs-y += smbios/
+devices-dirs-y += iommu/
 endif
 
 common-obj-y += $(devices-dirs-y)
diff --git a/hw/iommu/Makefile.objs b/hw/iommu/Makefile.objs
new file mode 100644
index 0000000..e6eed4e
--- /dev/null
+++ b/hw/iommu/Makefile.objs
@@ -0,0 +1 @@
+obj-y += host_iommu_context.o
diff --git a/hw/iommu/host_iommu_context.c b/hw/iommu/host_iommu_context.c
new file mode 100644
index 0000000..11b092f
--- /dev/null
+++ b/hw/iommu/host_iommu_context.c
@@ -0,0 +1,55 @@
+/*
+ * QEMU abstract of Host IOMMU
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ *
+ * Authors: Liu Yi L <yi.l.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "qemu/osdep.h"
+#include "hw/iommu/host_iommu_context.h"
+
+int host_iommu_ctx_pasid_alloc(HostIOMMUContext *host_icx, uint32_t min,
+                               uint32_t max, uint32_t *pasid)
+{
+    if (host_icx && (host_icx->flags & HOST_IOMMU_PASID_REQUEST) &&
+        host_icx->ops && host_icx->ops->pasid_alloc) {
+        return host_icx->ops->pasid_alloc(host_icx, min, max, pasid);
+    }
+    return -ENOENT;
+}
+
+int host_iommu_ctx_pasid_free(HostIOMMUContext *host_icx, uint32_t pasid)
+{
+    if (host_icx && (host_icx->flags & HOST_IOMMU_PASID_REQUEST) &&
+        host_icx->ops && host_icx->ops->pasid_free) {
+        return host_icx->ops->pasid_free(host_icx, pasid);
+    }
+    return -ENOENT;
+}
+
+void host_iommu_ctx_init(HostIOMMUContext *host_icx,
+                         uint64_t flags, HostIOMMUOps *ops)
+{
+    host_icx->flags = flags;
+    host_icx->ops = ops;
+}
+
+void host_iommu_ctx_destroy(HostIOMMUContext *host_icx)
+{
+    host_icx->flags = 0x0;
+    host_icx->ops = NULL;
+}
diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
new file mode 100644
index 0000000..f4d811a
--- /dev/null
+++ b/include/hw/iommu/host_iommu_context.h
@@ -0,0 +1,61 @@
+/*
+ * QEMU abstraction of Host IOMMU
+ *
+ * Copyright (C) 2020 Intel Corporation.
+ *
+ * Authors: Liu Yi L <yi.l.liu@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef HW_IOMMU_CONTEXT_H
+#define HW_IOMMU_CONTEXT_H
+
+#include "qemu/queue.h"
+#ifndef CONFIG_USER_ONLY
+#include "exec/hwaddr.h"
+#endif
+
+typedef struct HostIOMMUContext HostIOMMUContext;
+typedef struct HostIOMMUOps HostIOMMUOps;
+
+struct HostIOMMUOps {
+    /* Allocate pasid from HostIOMMUContext (a.k.a. host software) */
+    int (*pasid_alloc)(HostIOMMUContext *host_icx,
+                       uint32_t min,
+                       uint32_t max,
+                       uint32_t *pasid);
+    /* Reclaim pasid from HostIOMMUContext (a.k.a. host software) */
+    int (*pasid_free)(HostIOMMUContext *host_icx,
+                      uint32_t pasid);
+};
+
+/*
+ * This is an abstraction of host IOMMU with dual-stage capability
+ */
+struct HostIOMMUContext {
+#define HOST_IOMMU_PASID_REQUEST (1ULL << 0)
+    uint64_t flags;
+    HostIOMMUOps *ops;
+};
+
+int host_iommu_ctx_pasid_alloc(HostIOMMUContext *host_icx, uint32_t min,
+                               uint32_t max, uint32_t *pasid);
+int host_iommu_ctx_pasid_free(HostIOMMUContext *host_icx, uint32_t pasid);
+
+void host_iommu_ctx_init(HostIOMMUContext *host_icx,
+                         uint64_t flags, HostIOMMUOps *ops);
+void host_iommu_ctx_destroy(HostIOMMUContext *host_icx);
+
+#endif
-- 
2.7.4

