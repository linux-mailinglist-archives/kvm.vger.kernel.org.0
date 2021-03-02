Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B170B32A72E
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575954AbhCBQFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:05:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:29145 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1444913AbhCBMl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:41:26 -0500
IronPort-SDR: 61ZgfXODtoX++Db6/EW0BPfUjKnCKkkluPPRckm7JbHw/kgFO/uAJI5ZlSyaLD275meSq7d3AQ
 0hmz4gULCjFQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="183401492"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="183401492"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:40:09 -0800
IronPort-SDR: HZKQJN3zIWAsIqymBvFgDKWmw2o5mFSLHVNhu4ud6gxffL8m1nBtPyWQi4qqxOgwRqXGI0iMxg
 dqCQU/Cp4CqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472839"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:40:03 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Lingshan.Zhu@intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v11 09/25] hw/iommu: introduce HostIOMMUContext
Date:   Wed,  3 Mar 2021 04:38:11 +0800
Message-Id: <20210302203827.437645-10-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 - https://events19.lfasiallc.com/wp-content/uploads/2017/11/Shared-Virtual-Memory-in-KVM_Yi-Liu.pdf

In QEMU, vIOMMU emulators expose IOMMUs to VM per their own spec (e.g.
Intel VT-d spec). Devices are pass-through to guest via device pass-
through components like VFIO. VFIO is a userspace driver framework
which exposes host IOMMU programming capability to userspace in a
secure manner. e.g. IOVA MAP/UNMAP requests. Information, different
from map/unmap notifications need to be passed from QEMU vIOMMU device
to/from the host IOMMU driver through the VFIO/IOMMU layer:
 1) bind stage-1 translation structures to host
 2) propagate stage-1 cache invalidation to host
 3) DMA address translation fault (I/O page fault) servicing etc.

With the above new interactions in QEMU, it requires an abstract layer
to facilitate the above operations and expose to vIOMMU emulators as an
explicit way for vIOMMU emulators call into VFIO. This patch introduces
HostIOMMUContext to serve it. The HostIOMMUContext is an object which
allows to manage the stage-1 translation when a vIOMMU is implemented
upon physical IOMMU nested paging (VFIO case). It is an abstract object
which needs to be derived for each vIOMMU immplementation based on
physical nested paging. An HostIOMMUContext derived object will be passed
to each VFIO device protected by a vIOMMU using physical nested paging.

This patch also introduces HostIOMMUContextClass to provide methods for
vIOMMU emulators to propagate dual-stage translation related requests to
host. As a beginning, bind_stage1_pgtbl/unbind_stage1_pgtbl() were defined
for configuring vIOMMU's page table to host.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Eric Auger <eric.auger@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
rfcv10 -> rfcv11:
*) removed pasid_alloc/free in HostIOMMUContextClass, define bind_stage1_pgtbl
   and unbind_stage1_pgtbl() as a start for HostIOMMUContextClass.

rfcv9 -> rfcv10:
*) adjust to meson build
---
 hw/Kconfig                            |   3 +
 hw/iommu/Kconfig                      |   4 +
 hw/iommu/host_iommu_context.c         | 106 ++++++++++++++++++++++++++
 hw/iommu/meson.build                  |   6 ++
 hw/meson.build                        |   1 +
 include/hw/iommu/host_iommu_context.h |  75 ++++++++++++++++++
 6 files changed, 195 insertions(+)
 create mode 100644 hw/iommu/Kconfig
 create mode 100644 hw/iommu/host_iommu_context.c
 create mode 100644 hw/iommu/meson.build
 create mode 100644 include/hw/iommu/host_iommu_context.h

diff --git a/hw/Kconfig b/hw/Kconfig
index 8ea26479c4..fc660790f1 100644
--- a/hw/Kconfig
+++ b/hw/Kconfig
@@ -66,6 +66,9 @@ source tricore/Kconfig
 source unicore32/Kconfig
 source xtensa/Kconfig
 
+# iommu Kconfig
+source iommu/Kconfig
+
 # Symbols used by multiple targets
 config TEST_DEVICES
     bool
diff --git a/hw/iommu/Kconfig b/hw/iommu/Kconfig
new file mode 100644
index 0000000000..039b9a4caf
--- /dev/null
+++ b/hw/iommu/Kconfig
@@ -0,0 +1,4 @@
+config IOMMU
+    bool
+    default y
+    depends on LINUX
diff --git a/hw/iommu/host_iommu_context.c b/hw/iommu/host_iommu_context.c
new file mode 100644
index 0000000000..d7139bcb86
--- /dev/null
+++ b/hw/iommu/host_iommu_context.c
@@ -0,0 +1,106 @@
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
+int host_iommu_ctx_bind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
+                                     struct iommu_gpasid_bind_data *bind)
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
+    if (!(iommu_ctx->info->features & IOMMU_NESTING_FEAT_BIND_PGTBL) ||
+        !hicxc->bind_stage1_pgtbl) {
+        return -EINVAL;
+    }
+
+    return hicxc->bind_stage1_pgtbl(iommu_ctx, bind);
+}
+
+int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
+                                 struct iommu_gpasid_bind_data *unbind)
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
+    if (!(iommu_ctx->info->features & IOMMU_NESTING_FEAT_BIND_PGTBL) ||
+        !hicxc->unbind_stage1_pgtbl) {
+        return -EINVAL;
+    }
+
+    return hicxc->unbind_stage1_pgtbl(iommu_ctx, unbind);
+}
+
+void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
+                         const char *mrtypename,
+                         struct iommu_nesting_info *info)
+{
+    HostIOMMUContext *iommu_ctx;
+
+    object_initialize(_iommu_ctx, instance_size, mrtypename);
+    iommu_ctx = HOST_IOMMU_CONTEXT(_iommu_ctx);
+    iommu_ctx->info = g_malloc0(info->argsz);
+    memcpy(iommu_ctx->info, info, info->argsz);
+    iommu_ctx->initialized = true;
+}
+
+static void host_iommu_ctx_finalize_fn(Object *obj)
+{
+    HostIOMMUContext *iommu_ctx = HOST_IOMMU_CONTEXT(obj);
+
+    g_free(iommu_ctx->info);
+}
+
+static const TypeInfo host_iommu_context_info = {
+    .parent             = TYPE_OBJECT,
+    .name               = TYPE_HOST_IOMMU_CONTEXT,
+    .class_size         = sizeof(HostIOMMUContextClass),
+    .instance_size      = sizeof(HostIOMMUContext),
+    .instance_finalize  = host_iommu_ctx_finalize_fn,
+    .abstract           = true,
+};
+
+static void host_iommu_ctx_register_types(void)
+{
+    type_register_static(&host_iommu_context_info);
+}
+
+type_init(host_iommu_ctx_register_types)
diff --git a/hw/iommu/meson.build b/hw/iommu/meson.build
new file mode 100644
index 0000000000..acf72acc4c
--- /dev/null
+++ b/hw/iommu/meson.build
@@ -0,0 +1,6 @@
+iommu_ss = ss.source_set()
+iommu_ss.add(files(
+  'host_iommu_context.c',
+))
+
+specific_ss.add_all(when: 'CONFIG_IOMMU', if_true: iommu_ss)
diff --git a/hw/meson.build b/hw/meson.build
index e615d72d4d..1370b1e79e 100644
--- a/hw/meson.build
+++ b/hw/meson.build
@@ -66,3 +66,4 @@ subdir('sparc64')
 subdir('tricore')
 subdir('unicore32')
 subdir('xtensa')
+subdir('iommu')
diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
new file mode 100644
index 0000000000..41c4176c15
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
+    /*
+     * Bind stage-1 page table to a hostIOMMU w/ dual stage
+     * DMA translation capability.
+     * @bind specifies the bind configurations.
+     */
+    int (*bind_stage1_pgtbl)(HostIOMMUContext *iommu_ctx,
+                             struct iommu_gpasid_bind_data *bind);
+    /* Undo a previous bind. @unbind specifies the unbind info. */
+    int (*unbind_stage1_pgtbl)(HostIOMMUContext *iommu_ctx,
+                               struct iommu_gpasid_bind_data *unbind);
+} HostIOMMUContextClass;
+
+/*
+ * This is an abstraction of host IOMMU with dual-stage capability
+ */
+struct HostIOMMUContext {
+    Object parent_obj;
+    struct iommu_nesting_info *info;
+    bool initialized;
+};
+
+int host_iommu_ctx_bind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
+                                     struct iommu_gpasid_bind_data *bind);
+int host_iommu_ctx_unbind_stage1_pgtbl(HostIOMMUContext *iommu_ctx,
+                                 struct iommu_gpasid_bind_data *unbind);
+void host_iommu_ctx_init(void *_iommu_ctx, size_t instance_size,
+                         const char *mrtypename,
+                         struct iommu_nesting_info *info);
+void host_iommu_ctx_destroy(HostIOMMUContext *iommu_ctx);
+
+#endif
-- 
2.25.1

