Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0712302CB
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 08:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgG1G1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 02:27:41 -0400
Received: from mga04.intel.com ([192.55.52.120]:60856 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgG1G1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 02:27:41 -0400
IronPort-SDR: CJaeiUUZ4PsNn+/hVasmTW460/f3oJ4yzVIBCd8D5plARcTyL0rhkp5qxWcaAkl+LUVeC1dZBt
 dx6Op0ZUJEZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="148623390"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="148623390"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 23:27:38 -0700
IronPort-SDR: CndkFYdms0oLMOelQ6q8I9YUaQjxnVMcHupfnPwhUFTuxyj+SQBT+t0QZM+8trQwC9E4Iqf5Xe
 ywi9UCVqDlGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="394232862"
Received: from jacob-builder.jf.intel.com ([10.7.199.155])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jul 2020 23:27:37 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v9 08/25] hw/iommu: introduce HostIOMMUContext
Date:   Mon, 27 Jul 2020 23:34:01 -0700
Message-Id: <1595918058-33392-9-git-send-email-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
References: <1595918058-33392-1-git-send-email-yi.l.liu@intel.com>
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

In QEMU, vIOMMU emulators expose IOMMUs to VM per their own spec (e.g.
Intel VT-d spec). Devices are pass-through to guest via device pass-
through components like VFIO. VFIO is a userspace driver framework
which exposes host IOMMU programming capability to userspace in a
secure manner. e.g. IOVA MAP/UNMAP requests. Information, different
from map/unmap notifications need to be passed from QEMU vIOMMU device
to/from the host IOMMU driver through the VFIO/IOMMU layer:
 1) PASID allocation (allow host to intercept in PASID allocation)
 2) bind stage-1 translation structures to host
 3) propagate stage-1 cache invalidation to host
 4) DMA address translation fault (I/O page fault) servicing etc.

With the above new interactions in QEMU, it requires an abstract layer
to facilitate the above operations and expose to vIOMMU emulators as an
explicit way for vIOMMU emulators call into VFIO. This patch introduces
HostIOMMUContext to serve it. The HostIOMMUContext is an object which
allows to manage the stage-1 translation when a vIOMMU is implemented
upon physical IOMMU nested paging (VFIO case). It is an abstract object
which needs to be derived for each vIOMMU immplementation based on
physical nested paging. An HostIOMMUContext derived object will be passed
to each VFIO device protected by a vIOMMU using physical nested paging.

This patchg also introduces HostIOMMUContextClass to provide methods for
vIOMMU emulators to propagate dual-stage translation related requests to
host. As a beginning, PASID allocation/free are defined to propagate PASID
allocation/free requests to host which is required for the vendors which
manage PASID in system-wide.

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
 hw/iommu/host_iommu_context.c         | 97 +++++++++++++++++++++++++++++++++++
 include/hw/iommu/host_iommu_context.h | 75 +++++++++++++++++++++++++++
 4 files changed, 174 insertions(+)
 create mode 100644 hw/iommu/Makefile.objs
 create mode 100644 hw/iommu/host_iommu_context.c
 create mode 100644 include/hw/iommu/host_iommu_context.h

diff --git a/hw/Makefile.objs b/hw/Makefile.objs
index 14b7ea4..0648ff9 100644
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
index 0000000..5fb2223
--- /dev/null
+++ b/hw/iommu/host_iommu_context.c
@@ -0,0 +1,97 @@
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
+#include "qapi/error.h"
+#include "qom/object.h"
+#include "qapi/visitor.h"
+#include "hw/iommu/host_iommu_context.h"
+
+int host_iommu_ctx_pasid_alloc(HostIOMMUContext *iommu_ctx, uint32_t min,
+                               uint32_t max, uint32_t *pasid)
+{
+    HostIOMMUContextClass *hicxc;
+
+    if (!iommu_ctx) {
+        return -EINVAL;
+    }
+
+    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(iommu_ctx);
+
+    if (!hicxc) {
+        return -EINVAL;
+    }
+
+    if (!(iommu_ctx->flags & HOST_IOMMU_PASID_REQUEST) ||
+        !hicxc->pasid_alloc) {
+        return -EINVAL;
+    }
+
+    return hicxc->pasid_alloc(iommu_ctx, min, max, pasid);
+}
+
+int host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx, uint32_t pasid)
+{
+    HostIOMMUContextClass *hicxc;
+
+    if (!iommu_ctx) {
+        return -EINVAL;
+    }
+
+    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(iommu_ctx);
+    if (!hicxc) {
+        return -EINVAL;
+    }
+
+    if (!(iommu_ctx->flags & HOST_IOMMU_PASID_REQUEST) ||
+        !hicxc->pasid_free) {
+        return -EINVAL;
+    }
+
+    return hicxc->pasid_free(iommu_ctx, pasid);
+}
+
+void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
+                         const char *mrtypename,
+                         uint64_t flags)
+{
+    HostIOMMUContext *iommu_ctx;
+
+    object_initialize(_iommu_ctx, instance_size, mrtypename);
+    iommu_ctx = HOST_IOMMU_CONTEXT(_iommu_ctx);
+    iommu_ctx->flags = flags;
+    iommu_ctx->initialized = true;
+}
+
+static const TypeInfo host_iommu_context_info = {
+    .parent             = TYPE_OBJECT,
+    .name               = TYPE_HOST_IOMMU_CONTEXT,
+    .class_size         = sizeof(HostIOMMUContextClass),
+    .instance_size      = sizeof(HostIOMMUContext),
+    .abstract           = true,
+};
+
+static void host_iommu_ctx_register_types(void)
+{
+    type_register_static(&host_iommu_context_info);
+}
+
+type_init(host_iommu_ctx_register_types)
diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
new file mode 100644
index 0000000..35c4861
--- /dev/null
+++ b/include/hw/iommu/host_iommu_context.h
@@ -0,0 +1,75 @@
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
+#include "qemu/thread.h"
+#include "qom/object.h"
+#include <linux/iommu.h>
+#ifndef CONFIG_USER_ONLY
+#include "exec/hwaddr.h"
+#endif
+
+#define TYPE_HOST_IOMMU_CONTEXT "qemu:host-iommu-context"
+#define HOST_IOMMU_CONTEXT(obj) \
+        OBJECT_CHECK(HostIOMMUContext, (obj), TYPE_HOST_IOMMU_CONTEXT)
+#define HOST_IOMMU_CONTEXT_GET_CLASS(obj) \
+        OBJECT_GET_CLASS(HostIOMMUContextClass, (obj), \
+                         TYPE_HOST_IOMMU_CONTEXT)
+
+typedef struct HostIOMMUContext HostIOMMUContext;
+
+typedef struct HostIOMMUContextClass {
+    /* private */
+    ObjectClass parent_class;
+
+    /* Allocate pasid from HostIOMMUContext (a.k.a. host software) */
+    int (*pasid_alloc)(HostIOMMUContext *iommu_ctx,
+                       uint32_t min,
+                       uint32_t max,
+                       uint32_t *pasid);
+    /* Reclaim pasid from HostIOMMUContext (a.k.a. host software) */
+    int (*pasid_free)(HostIOMMUContext *iommu_ctx,
+                      uint32_t pasid);
+} HostIOMMUContextClass;
+
+/*
+ * This is an abstraction of host IOMMU with dual-stage capability
+ */
+struct HostIOMMUContext {
+    Object parent_obj;
+#define HOST_IOMMU_PASID_REQUEST (1ULL << 0)
+    uint64_t flags;
+    bool initialized;
+};
+
+int host_iommu_ctx_pasid_alloc(HostIOMMUContext *iommu_ctx, uint32_t min,
+                               uint32_t max, uint32_t *pasid);
+int host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx, uint32_t pasid);
+
+void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
+                         const char *mrtypename,
+                         uint64_t flags);
+void host_iommu_ctx_destroy(HostIOMMUContext *iommu_ctx);
+
+#endif
-- 
2.7.4

