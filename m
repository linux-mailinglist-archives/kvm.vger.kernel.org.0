Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47919500B80
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 12:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242502AbiDNKuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 06:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242464AbiDNKuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 06:50:05 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058197DAB7
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 03:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649933260; x=1681469260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3UceRf2HWmSm4CQsvPTxQRPUH75cKHVY3AXYZmTVfe8=;
  b=LZ7qUKOzs67P/0hMoNoiGWJj7g5L9vOjMZEMFIFlC61qnaQOdslE5KpD
   5dOr06neDRqKSdEf+/JvGYo4nvLaMc+rKaKCFq909u5kyHdkjJ9N8zug0
   1arGbV87S7myQRLUhFHf8sBLsXvmyuNmVr/DttXRHBdn3QutuOPv0ydwd
   4sQTXnoBJdxFDykpC/zyBoTbQsipWdfTKU7UvzygxDPiGDM5cYBCF8p1C
   jzCW+4ECvtr6TYf+UISxVvksiSRP5SDJSgwYXIznNNgMnzvsAGY3wP17L
   x+cFD46HyqdfUzCN21hWvreFnsOSC/g5uGlXQtOJQEvkkLj4IpfDM0yht
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="325808698"
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="325808698"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 03:47:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,259,1643702400"; 
   d="scan'208";a="803091249"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmsmga006.fm.intel.com with ESMTP; 14 Apr 2022 03:47:21 -0700
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
Subject: [RFC 14/18] hw/iommufd: Creation
Date:   Thu, 14 Apr 2022 03:47:06 -0700
Message-Id: <20220414104710.28534-15-yi.l.liu@intel.com>
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

Introduce iommufd utility library which can be compiled out with
CONFIG_IOMMUFD configuration. This code is bound to be called by
several subsystems: vdpa, and vfio.

Co-authored-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 MAINTAINERS                  |   7 ++
 hw/Kconfig                   |   1 +
 hw/iommufd/Kconfig           |   4 +
 hw/iommufd/iommufd.c         | 209 +++++++++++++++++++++++++++++++++++
 hw/iommufd/meson.build       |   1 +
 hw/iommufd/trace-events      |  11 ++
 hw/iommufd/trace.h           |   1 +
 hw/meson.build               |   1 +
 include/hw/iommufd/iommufd.h |  37 +++++++
 meson.build                  |   1 +
 10 files changed, 273 insertions(+)
 create mode 100644 hw/iommufd/Kconfig
 create mode 100644 hw/iommufd/iommufd.c
 create mode 100644 hw/iommufd/meson.build
 create mode 100644 hw/iommufd/trace-events
 create mode 100644 hw/iommufd/trace.h
 create mode 100644 include/hw/iommufd/iommufd.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 4ad2451e03..f6bcb25f7f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1954,6 +1954,13 @@ F: hw/vfio/ap.c
 F: docs/system/s390x/vfio-ap.rst
 L: qemu-s390x@nongnu.org
 
+iommufd
+M: Yi Liu <yi.l.liu@intel.com>
+M: Eric Auger <eric.auger@redhat.com>
+S: Supported
+F: hw/iommufd/*
+F: include/hw/iommufd/*
+
 vhost
 M: Michael S. Tsirkin <mst@redhat.com>
 S: Supported
diff --git a/hw/Kconfig b/hw/Kconfig
index ad20cce0a9..d270d44760 100644
--- a/hw/Kconfig
+++ b/hw/Kconfig
@@ -63,6 +63,7 @@ source sparc/Kconfig
 source sparc64/Kconfig
 source tricore/Kconfig
 source xtensa/Kconfig
+source iommufd/Kconfig
 
 # Symbols used by multiple targets
 config TEST_DEVICES
diff --git a/hw/iommufd/Kconfig b/hw/iommufd/Kconfig
new file mode 100644
index 0000000000..4b1b00e36b
--- /dev/null
+++ b/hw/iommufd/Kconfig
@@ -0,0 +1,4 @@
+config IOMMUFD
+    bool
+    default y
+    depends on LINUX
diff --git a/hw/iommufd/iommufd.c b/hw/iommufd/iommufd.c
new file mode 100644
index 0000000000..4e8179d612
--- /dev/null
+++ b/hw/iommufd/iommufd.c
@@ -0,0 +1,209 @@
+/*
+ * QEMU IOMMUFD
+ *
+ * Copyright (C) 2022 Intel Corporation.
+ * Copyright Red Hat, Inc. 2022
+ *
+ * Authors: Yi Liu <yi.l.liu@intel.com>
+ *          Eric Auger <eric.auger@redhat.com>
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
+#include "qemu/error-report.h"
+#include "qemu/thread.h"
+#include "qemu/module.h"
+#include <sys/ioctl.h>
+#include <linux/iommufd.h>
+#include "hw/iommufd/iommufd.h"
+#include "trace.h"
+
+static QemuMutex iommufd_lock;
+static uint32_t iommufd_users;
+static int iommufd = -1;
+
+static int iommufd_get(void)
+{
+    qemu_mutex_lock(&iommufd_lock);
+    if (iommufd == -1) {
+        iommufd = qemu_open_old("/dev/iommu", O_RDWR);
+        if (iommufd < 0) {
+            error_report("Failed to open /dev/iommu!");
+        } else {
+            iommufd_users = 1;
+        }
+        trace_iommufd_get(iommufd);
+    } else if (++iommufd_users == UINT32_MAX) {
+        error_report("Failed to get iommufd: %d, count overflow", iommufd);
+        iommufd_users--;
+        qemu_mutex_unlock(&iommufd_lock);
+        return -E2BIG;
+    }
+    qemu_mutex_unlock(&iommufd_lock);
+    return iommufd;
+}
+
+static void iommufd_put(int fd)
+{
+    qemu_mutex_lock(&iommufd_lock);
+    if (--iommufd_users) {
+        qemu_mutex_unlock(&iommufd_lock);
+        return;
+    }
+    iommufd = -1;
+    trace_iommufd_put(fd);
+    close(fd);
+    qemu_mutex_unlock(&iommufd_lock);
+}
+
+static int iommufd_alloc_ioas(int iommufd, uint32_t *ioas)
+{
+    int ret;
+    struct iommu_ioas_alloc alloc_data  = {
+        .size = sizeof(alloc_data),
+        .flags = 0,
+    };
+
+    ret = ioctl(iommufd, IOMMU_IOAS_ALLOC, &alloc_data);
+    if (ret) {
+        error_report("Failed to allocate ioas %m");
+    }
+
+    *ioas = alloc_data.out_ioas_id;
+    trace_iommufd_alloc_ioas(iommufd, *ioas, ret);
+
+    return ret;
+}
+
+static void iommufd_free_ioas(int iommufd, uint32_t ioas)
+{
+    int ret;
+    struct iommu_destroy des = {
+        .size = sizeof(des),
+        .id = ioas,
+    };
+
+    ret = ioctl(iommufd, IOMMU_DESTROY, &des);
+    trace_iommufd_free_ioas(iommufd, ioas, ret);
+    if (ret) {
+        error_report("Failed to free ioas: %u %m", ioas);
+    }
+}
+
+int iommufd_get_ioas(int *fd, uint32_t *ioas_id)
+{
+    int ret;
+
+    *fd = iommufd_get();
+    if (*fd < 0) {
+        return *fd;
+    }
+
+    ret = iommufd_alloc_ioas(*fd, ioas_id);
+    trace_iommufd_get_ioas(*fd, *ioas_id, ret);
+    if (ret) {
+        iommufd_put(*fd);
+    }
+    return ret;
+}
+
+void iommufd_put_ioas(int iommufd, uint32_t ioas)
+{
+    trace_iommufd_put_ioas(iommufd, ioas);
+    iommufd_free_ioas(iommufd, ioas);
+    iommufd_put(iommufd);
+}
+
+int iommufd_unmap_dma(int iommufd, uint32_t ioas,
+                      hwaddr iova, ram_addr_t size)
+{
+    int ret;
+    struct iommu_ioas_unmap unmap = {
+        .size = sizeof(unmap),
+        .ioas_id = ioas,
+        .iova = iova,
+        .length = size,
+    };
+
+    ret = ioctl(iommufd, IOMMU_IOAS_UNMAP, &unmap);
+    trace_iommufd_unmap_dma(iommufd, ioas, iova, size, ret);
+    if (ret) {
+        error_report("IOMMU_IOAS_UNMAP failed: %s", strerror(errno));
+    }
+    return !ret ? 0 : -errno;
+}
+
+int iommufd_map_dma(int iommufd, uint32_t ioas, hwaddr iova,
+                    ram_addr_t size, void *vaddr, bool readonly)
+{
+    int ret;
+    struct iommu_ioas_map map = {
+        .size = sizeof(map),
+        .flags = IOMMU_IOAS_MAP_READABLE |
+                 IOMMU_IOAS_MAP_FIXED_IOVA,
+        .ioas_id = ioas,
+        .__reserved = 0,
+        .user_va = (int64_t)vaddr,
+        .iova = iova,
+        .length = size,
+    };
+
+    if (!readonly) {
+        map.flags |= IOMMU_IOAS_MAP_WRITEABLE;
+    }
+
+    ret = ioctl(iommufd, IOMMU_IOAS_MAP, &map);
+    trace_iommufd_map_dma(iommufd, ioas, iova, size, vaddr, readonly, ret);
+    if (ret) {
+        error_report("IOMMU_IOAS_MAP failed: %s", strerror(errno));
+    }
+    return !ret ? 0 : -errno;
+}
+
+int iommufd_copy_dma(int iommufd, uint32_t src_ioas, uint32_t dst_ioas,
+                     hwaddr iova, ram_addr_t size, bool readonly)
+{
+    int ret;
+    struct iommu_ioas_copy copy = {
+        .size = sizeof(copy),
+        .flags = IOMMU_IOAS_MAP_READABLE |
+                 IOMMU_IOAS_MAP_FIXED_IOVA,
+        .dst_ioas_id = dst_ioas,
+        .src_ioas_id = src_ioas,
+        .length = size,
+        .dst_iova = iova,
+        .src_iova = iova,
+    };
+
+    if (!readonly) {
+        copy.flags |= IOMMU_IOAS_MAP_WRITEABLE;
+    }
+
+    ret = ioctl(iommufd, IOMMU_IOAS_COPY, &copy);
+    trace_iommufd_copy_dma(iommufd, src_ioas, dst_ioas,
+                           iova, size, readonly, ret);
+    if (ret) {
+        error_report("IOMMU_IOAS_COPY failed: %s", strerror(errno));
+    }
+    return !ret ? 0 : -errno;
+}
+
+static void iommufd_register_types(void)
+{
+    qemu_mutex_init(&iommufd_lock);
+}
+
+type_init(iommufd_register_types)
diff --git a/hw/iommufd/meson.build b/hw/iommufd/meson.build
new file mode 100644
index 0000000000..515bc40cbe
--- /dev/null
+++ b/hw/iommufd/meson.build
@@ -0,0 +1 @@
+specific_ss.add(when: 'CONFIG_IOMMUFD', if_true: files('iommufd.c'))
diff --git a/hw/iommufd/trace-events b/hw/iommufd/trace-events
new file mode 100644
index 0000000000..615d80cdf4
--- /dev/null
+++ b/hw/iommufd/trace-events
@@ -0,0 +1,11 @@
+# See docs/devel/tracing.rst for syntax documentation.
+
+iommufd_get(int iommufd) " iommufd=%d"
+iommufd_put(int iommufd) " iommufd=%d"
+iommufd_alloc_ioas(int iommufd, uint32_t ioas, int ret) " iommufd=%d ioas=%d (%d)"
+iommufd_free_ioas(int iommufd, uint32_t ioas, int ret) " iommufd=%d ioas=%d (%d)"
+iommufd_get_ioas(int iommufd, uint32_t ioas, int ret) " iommufd=%d ioas=%d (%d)"
+iommufd_put_ioas(int iommufd, uint32_t ioas) " iommufd=%d ioas=%d"
+iommufd_unmap_dma(int iommufd, uint32_t ioas, uint64_t iova, uint64_t size, int ret) " iommufd=%d ioas=%d iova=0x%"PRIx64" size=0x%"PRIx64" (%d)"
+iommufd_map_dma(int iommufd, uint32_t ioas, uint64_t iova, uint64_t size, void *vaddr, bool readonly, int ret) " iommufd=%d ioas=%d iova=0x%"PRIx64" size=0x%"PRIx64" addr=%p readonly=%d (%d)"
+iommufd_copy_dma(int iommufd, uint32_t src_ioas, uint32_t dst_ioas, uint64_t iova, uint64_t size, bool readonly, int ret) " iommufd=%d src_ioas=%d dst_ioas=%d iova=0x%"PRIx64" size=0x%"PRIx64" readonly=%d (%d)"
diff --git a/hw/iommufd/trace.h b/hw/iommufd/trace.h
new file mode 100644
index 0000000000..3fb40b0932
--- /dev/null
+++ b/hw/iommufd/trace.h
@@ -0,0 +1 @@
+#include "trace/trace-hw_iommufd.h"
diff --git a/hw/meson.build b/hw/meson.build
index b3366c888e..ffb5203265 100644
--- a/hw/meson.build
+++ b/hw/meson.build
@@ -38,6 +38,7 @@ subdir('timer')
 subdir('tpm')
 subdir('usb')
 subdir('vfio')
+subdir('iommufd')
 subdir('virtio')
 subdir('watchdog')
 subdir('xen')
diff --git a/include/hw/iommufd/iommufd.h b/include/hw/iommufd/iommufd.h
new file mode 100644
index 0000000000..59835cddca
--- /dev/null
+++ b/include/hw/iommufd/iommufd.h
@@ -0,0 +1,37 @@
+/*
+ * QEMU IOMMUFD
+ *
+ * Copyright (C) 2022 Intel Corporation.
+ * Copyright Red Hat, Inc. 2022
+ *
+ * Authors: Yi Liu <yi.l.liu@intel.com>
+ *          Eric Auger <eric.auger@redhat.com>
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
+#ifndef HW_IOMMUFD_IOMMUFD_H
+#define HW_IOMMUFD_IOMMUFD_H
+#include "exec/hwaddr.h"
+#include "exec/cpu-common.h"
+
+int iommufd_get_ioas(int *fd, uint32_t *ioas_id);
+void iommufd_put_ioas(int fd, uint32_t ioas_id);
+int iommufd_unmap_dma(int iommufd, uint32_t ioas, hwaddr iova, ram_addr_t size);
+int iommufd_map_dma(int iommufd, uint32_t ioas, hwaddr iova,
+                    ram_addr_t size, void *vaddr, bool readonly);
+int iommufd_copy_dma(int iommufd, uint32_t src_ioas, uint32_t dst_ioas,
+                     hwaddr iova, ram_addr_t size, bool readonly);
+bool iommufd_supported(void);
+#endif /* HW_IOMMUFD_IOMMUFD_H */
diff --git a/meson.build b/meson.build
index 861de93c4f..45caa53db6 100644
--- a/meson.build
+++ b/meson.build
@@ -2755,6 +2755,7 @@ if have_system
     'hw/tpm',
     'hw/usb',
     'hw/vfio',
+    'hw/iommufd',
     'hw/virtio',
     'hw/watchdog',
     'hw/xen',
-- 
2.27.0

