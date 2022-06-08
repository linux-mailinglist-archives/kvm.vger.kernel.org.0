Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D03543072
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbiFHMb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239292AbiFHMbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:31:50 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9CE250E76
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654691508; x=1686227508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VDUDde22/mftjnQk63dwew8A4G2v7RPHGmdbSSc+W0I=;
  b=S5w4/R0g9CDzjU8pRexrUxrncNd2qth8U2QSACQBS8fpJ2Gd77lHWX2W
   U8T0+c85Zyp5VoCMDPG5KVpInr7Ve13DBkc0CSWn2m5b3xfyETxn8QW2F
   U5UtfqvutWxnYPO2qjPH/krYe57OAQhzzhBfQg5NxNS0FyZ0gwbJJpmEk
   /esf1ZWwkBQUJDbaCccTKHYjk04TJ+155VL4zebJdJwkmIjMUj7Yed90b
   WzMlG/KGus1F31a2Apq8AXix4EDxbbZygNn7hi6NnEhF5kZTFyhIUflJ1
   bX0EOomtl2QVQr/sgSXM1AppswvxswvJ9LkqfVsov15sesb+sL+VNAB/5
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="302238066"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="302238066"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:31:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="670529867"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jun 2022 05:31:47 -0700
From:   Yi Liu <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, eric.auger@redhat.com,
        eric.auger.pro@gmail.com, kevin.tian@intel.com, yi.l.liu@intel.com,
        chao.p.peng@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com
Subject: [RFC v2 11/15] backends/iommufd: Introduce the iommufd object
Date:   Wed,  8 Jun 2022 05:31:35 -0700
Message-Id: <20220608123139.19356-12-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220608123139.19356-1-yi.l.liu@intel.com>
References: <20220608123139.19356-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

Introduce an iommufd object which allows the interaction
with the host /dev/iommu device.

The /dev/iommu can have been already pre-opened outside of qemu,
in which case the fd can be passed directly along with the
iommufd object:

This allows the iommufd object to be shared accross several
subsystems (VFIO, VDPA, ...). For example, libvirt would open
the /dev/iommu once.

If no fd is passed along with the iommufd object, the /dev/iommu
is opened by the qemu code.

The CONFIG_IOMMUFD option must be set to compile this new object.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Suggested-by: Alex Williamson <alex.williamson@redhat.com>
---
 MAINTAINERS              |   7 ++
 backends/Kconfig         |   5 +
 backends/iommufd.c       | 265 +++++++++++++++++++++++++++++++++++++++
 backends/meson.build     |   1 +
 backends/trace-events    |  12 ++
 include/sysemu/iommufd.h |  47 +++++++
 qapi/qom.json            |  16 ++-
 qemu-options.hx          |  12 ++
 8 files changed, 364 insertions(+), 1 deletion(-)
 create mode 100644 backends/iommufd.c
 create mode 100644 include/sysemu/iommufd.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5580a36b68..c6aa4e7fd0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1984,6 +1984,13 @@ F: hw/vfio/ap.c
 F: docs/system/s390x/vfio-ap.rst
 L: qemu-s390x@nongnu.org
 
+iommufd
+M: Yi Liu <yi.l.liu@intel.com>
+M: Eric Auger <eric.auger@redhat.com>
+S: Supported
+F: backends/iommufd.c
+F: include/sysemu/iommufd.h
+
 vhost
 M: Michael S. Tsirkin <mst@redhat.com>
 S: Supported
diff --git a/backends/Kconfig b/backends/Kconfig
index f35abc1609..aad57e8f53 100644
--- a/backends/Kconfig
+++ b/backends/Kconfig
@@ -1 +1,6 @@
 source tpm/Kconfig
+
+config IOMMUFD
+    bool
+    default y
+    depends on LINUX
diff --git a/backends/iommufd.c b/backends/iommufd.c
new file mode 100644
index 0000000000..6a66948d5d
--- /dev/null
+++ b/backends/iommufd.c
@@ -0,0 +1,265 @@
+/*
+ * iommufd container backend
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
+#include "sysemu/iommufd.h"
+#include "qapi/error.h"
+#include "qapi/qmp/qerror.h"
+#include "qemu/module.h"
+#include "qom/object_interfaces.h"
+#include "qemu/error-report.h"
+#include "monitor/monitor.h"
+#include "trace.h"
+#include <sys/ioctl.h>
+#include <linux/iommufd.h>
+
+static void iommufd_backend_init(Object *obj)
+{
+    IOMMUFDBackend *be = IOMMUFD_BACKEND(obj);
+
+    be->fd = -1;
+    be->users = 0;
+    be->owned = true;
+    qemu_mutex_init(&be->lock);
+}
+
+static void iommufd_backend_finalize(Object *obj)
+{
+    IOMMUFDBackend *be = IOMMUFD_BACKEND(obj);
+
+    if (be->owned) {
+        close(be->fd);
+        be->fd = -1;
+    }
+}
+
+static void iommufd_backend_set_fd(Object *obj, const char *str, Error **errp)
+{
+    IOMMUFDBackend *be = IOMMUFD_BACKEND(obj);
+    int fd = -1;
+
+    fd = monitor_fd_param(monitor_cur(), str, errp);
+    if (fd == -1) {
+        error_prepend(errp, "Could not parse remote object fd %s:", str);
+        return;
+    }
+    qemu_mutex_lock(&be->lock);
+    be->fd = fd;
+    be->owned = false;
+    qemu_mutex_unlock(&be->lock);
+    trace_iommu_backend_set_fd(be->fd);
+}
+
+static void iommufd_backend_class_init(ObjectClass *oc, void *data)
+{
+    object_class_property_add_str(oc, "fd", NULL, iommufd_backend_set_fd);
+}
+
+int iommufd_backend_connect(IOMMUFDBackend *be, Error **errp)
+{
+    int fd, ret = 0;
+
+    qemu_mutex_lock(&be->lock);
+    if (be->users == UINT32_MAX) {
+        error_setg(errp, "too many connections");
+        ret = -E2BIG;
+        goto out;
+    }
+    if (be->owned && !be->users) {
+        fd = qemu_open_old("/dev/iommu", O_RDWR);
+        if (fd < 0) {
+            error_setg_errno(errp, errno, "/dev/iommu opening failed");
+            ret = fd;
+            goto out;
+        }
+        be->fd = fd;
+    }
+    be->users++;
+out:
+    trace_iommufd_backend_connect(be->fd, be->owned,
+                                  be->users, ret);
+    qemu_mutex_unlock(&be->lock);
+    return ret;
+}
+
+void iommufd_backend_disconnect(IOMMUFDBackend *be)
+{
+    qemu_mutex_lock(&be->lock);
+    if (!be->users) {
+        goto out;
+    }
+    be->users--;
+    if (!be->users && be->owned) {
+        close(be->fd);
+        be->fd = -1;
+    }
+out:
+    trace_iommufd_backend_disconnect(be->fd, be->users);
+    qemu_mutex_unlock(&be->lock);
+}
+
+static int iommufd_backend_alloc_ioas(int fd, uint32_t *ioas)
+{
+    int ret;
+    struct iommu_ioas_alloc alloc_data  = {
+        .size = sizeof(alloc_data),
+        .flags = 0,
+    };
+
+    ret = ioctl(fd, IOMMU_IOAS_ALLOC, &alloc_data);
+    if (ret) {
+        error_report("Failed to allocate ioas %m");
+    }
+
+    *ioas = alloc_data.out_ioas_id;
+    trace_iommufd_backend_alloc_ioas(fd, *ioas, ret);
+
+    return ret;
+}
+
+static void iommufd_backend_free_ioas(int fd, uint32_t ioas)
+{
+    int ret;
+    struct iommu_destroy des = {
+        .size = sizeof(des),
+        .id = ioas,
+    };
+
+    ret = ioctl(fd, IOMMU_DESTROY, &des);
+    trace_iommufd_backend_free_ioas(fd, ioas, ret);
+    if (ret) {
+        error_report("Failed to free ioas: %u %m", ioas);
+    }
+}
+
+int iommufd_backend_get_ioas(IOMMUFDBackend *be, uint32_t *ioas_id)
+{
+    int ret;
+
+    ret = iommufd_backend_alloc_ioas(be->fd, ioas_id);
+    trace_iommufd_backend_get_ioas(be->fd, *ioas_id, ret);
+    return ret;
+}
+
+void iommufd_backend_put_ioas(IOMMUFDBackend *be, uint32_t ioas)
+{
+    trace_iommufd_backend_put_ioas(be->fd, ioas);
+    iommufd_backend_free_ioas(be->fd, ioas);
+}
+
+int iommufd_backend_unmap_dma(IOMMUFDBackend *be, uint32_t ioas,
+                              hwaddr iova, ram_addr_t size)
+{
+    int ret;
+    struct iommu_ioas_unmap unmap = {
+        .size = sizeof(unmap),
+        .ioas_id = ioas,
+        .iova = iova,
+        .length = size,
+    };
+
+    ret = ioctl(be->fd, IOMMU_IOAS_UNMAP, &unmap);
+    trace_iommufd_backend_unmap_dma(be->fd, ioas, iova, size, ret);
+    if (ret) {
+        error_report("IOMMU_IOAS_UNMAP failed: %s", strerror(errno));
+    }
+    return !ret ? 0 : -errno;
+}
+
+int iommufd_backend_map_dma(IOMMUFDBackend *be, uint32_t ioas, hwaddr iova,
+                            ram_addr_t size, void *vaddr, bool readonly)
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
+    ret = ioctl(be->fd, IOMMU_IOAS_MAP, &map);
+    trace_iommufd_backend_map_dma(be->fd, ioas, iova, size,
+                                  vaddr, readonly, ret);
+    if (ret) {
+        error_report("IOMMU_IOAS_MAP failed: %s", strerror(errno));
+    }
+    return !ret ? 0 : -errno;
+}
+
+int iommufd_backend_copy_dma(IOMMUFDBackend *be, uint32_t src_ioas,
+                             uint32_t dst_ioas, hwaddr iova,
+                             ram_addr_t size, bool readonly)
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
+    ret = ioctl(be->fd, IOMMU_IOAS_COPY, &copy);
+    trace_iommufd_backend_copy_dma(be->fd, src_ioas, dst_ioas,
+                                   iova, size, readonly, ret);
+    if (ret) {
+        error_report("IOMMU_IOAS_COPY failed: %s", strerror(errno));
+    }
+    return !ret ? 0 : -errno;
+}
+
+static const TypeInfo iommufd_backend_info = {
+    .name = TYPE_IOMMUFD_BACKEND,
+    .parent = TYPE_OBJECT,
+    .instance_size = sizeof(IOMMUFDBackend),
+    .instance_init = iommufd_backend_init,
+    .instance_finalize = iommufd_backend_finalize,
+    .class_size = sizeof(IOMMUFDBackendClass),
+    .class_init = iommufd_backend_class_init,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_USER_CREATABLE },
+        { }
+    }
+};
+
+static void register_types(void)
+{
+    type_register_static(&iommufd_backend_info);
+}
+
+type_init(register_types);
diff --git a/backends/meson.build b/backends/meson.build
index b1884a88ec..5cbdd3a858 100644
--- a/backends/meson.build
+++ b/backends/meson.build
@@ -15,6 +15,7 @@ softmmu_ss.add(when: 'CONFIG_LINUX', if_true: files('hostmem-memfd.c'))
 if have_vhost_user
   softmmu_ss.add(when: 'CONFIG_VIRTIO', if_true: files('vhost-user.c'))
 endif
+specific_ss.add(when: 'CONFIG_IOMMUFD', if_true: files('iommufd.c'))
 softmmu_ss.add(when: 'CONFIG_VIRTIO_CRYPTO', if_true: files('cryptodev-vhost.c'))
 if have_vhost_user_crypto
   softmmu_ss.add(when: 'CONFIG_VIRTIO_CRYPTO', if_true: files('cryptodev-vhost-user.c'))
diff --git a/backends/trace-events b/backends/trace-events
index 652eb76a57..2c8af3e726 100644
--- a/backends/trace-events
+++ b/backends/trace-events
@@ -5,3 +5,15 @@ dbus_vmstate_pre_save(void)
 dbus_vmstate_post_load(int version_id) "version_id: %d"
 dbus_vmstate_loading(const char *id) "id: %s"
 dbus_vmstate_saving(const char *id) "id: %s"
+
+# iommufd.c
+iommufd_backend_connect(int fd, bool owned, uint32_t users, int ret) "fd=%d owned=%d users=%d (%d)"
+iommufd_backend_disconnect(int fd, uint32_t users) "fd=%d users=%d"
+iommu_backend_set_fd(int fd) "pre-opened /dev/iommu fd=%d"
+iommufd_backend_get_ioas(int iommufd, uint32_t ioas, int ret) " iommufd=%d ioas=%d (%d)"
+iommufd_backend_put_ioas(int iommufd, uint32_t ioas) " iommufd=%d ioas=%d"
+iommufd_backend_unmap_dma(int iommufd, uint32_t ioas, uint64_t iova, uint64_t size, int ret) " iommufd=%d ioas=%d iova=0x%"PRIx64" size=0x%"PRIx64" (%d)"
+iommufd_backend_map_dma(int iommufd, uint32_t ioas, uint64_t iova, uint64_t size, void *vaddr, bool readonly, int ret) " iommufd=%d ioas=%d iova=0x%"PRIx64" size=0x%"PRIx64" addr=%p readonly=%d (%d)"
+iommufd_backend_copy_dma(int iommufd, uint32_t src_ioas, uint32_t dst_ioas, uint64_t iova, uint64_t size, bool readonly, int ret) " iommufd=%d src_ioas=%d dst_ioas=%d iova=0x%"PRIx64" size=0x%"PRIx64" readonly=%d (%d)"
+iommufd_backend_alloc_ioas(int iommufd, uint32_t ioas, int ret) " iommufd=%d ioas=%d (%d)"
+iommufd_backend_free_ioas(int iommufd, uint32_t ioas, int ret) " iommufd=%d ioas=%d (%d)"
diff --git a/include/sysemu/iommufd.h b/include/sysemu/iommufd.h
new file mode 100644
index 0000000000..06a866d1bd
--- /dev/null
+++ b/include/sysemu/iommufd.h
@@ -0,0 +1,47 @@
+#ifndef SYSEMU_IOMMUFD_H
+#define SYSEMU_IOMMUFD_H
+
+#include "qom/object.h"
+#include "qemu/thread.h"
+#include "exec/hwaddr.h"
+#include "exec/ram_addr.h"
+
+#define TYPE_IOMMUFD_BACKEND "iommufd"
+OBJECT_DECLARE_TYPE(IOMMUFDBackend, IOMMUFDBackendClass,
+                    IOMMUFD_BACKEND)
+#define IOMMUFD_BACKEND(obj) \
+    OBJECT_CHECK(IOMMUFDBackend, (obj), TYPE_IOMMUFD_BACKEND)
+#define IOMMUFD_BACKEND_GET_CLASS(obj) \
+    OBJECT_GET_CLASS(IOMMUFDBackendClass, (obj), TYPE_IOMMUFD_BACKEND)
+#define IOMMUFD_BACKEND_CLASS(klass) \
+    OBJECT_CLASS_CHECK(IOMMUFDBackendClass, (klass), TYPE_IOMMUFD_BACKEND)
+struct IOMMUFDBackendClass {
+    ObjectClass parent_class;
+};
+
+struct IOMMUFDBackend {
+    Object parent;
+
+    /*< protected >*/
+    int fd;            /* /dev/iommu file descriptor */
+    bool owned;        /* is the /dev/iommu opened internally */
+    QemuMutex lock;
+    uint32_t users;
+
+    /*< public >*/
+};
+
+int iommufd_backend_connect(IOMMUFDBackend *be, Error **errp);
+void iommufd_backend_disconnect(IOMMUFDBackend *be);
+
+int iommufd_backend_get_ioas(IOMMUFDBackend *be, uint32_t *ioas_id);
+void iommufd_backend_put_ioas(IOMMUFDBackend *be, uint32_t ioas_id);
+int iommufd_backend_unmap_dma(IOMMUFDBackend *be, uint32_t ioas,
+                              hwaddr iova, ram_addr_t size);
+int iommufd_backend_map_dma(IOMMUFDBackend *be, uint32_t ioas, hwaddr iova,
+                            ram_addr_t size, void *vaddr, bool readonly);
+int iommufd_backend_copy_dma(IOMMUFDBackend *be, uint32_t src_ioas,
+                             uint32_t dst_ioas, hwaddr iova,
+                             ram_addr_t size, bool readonly);
+
+#endif
diff --git a/qapi/qom.json b/qapi/qom.json
index 6a653c6636..f609e7f667 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -734,6 +734,18 @@
 { 'struct': 'RemoteObjectProperties',
   'data': { 'fd': 'str', 'devid': 'str' } }
 
+##
+# @IOMMUFDProperties:
+#
+# Properties for IOMMUFDbackend objects.
+#
+# fd: file descriptor name
+#
+# Since: 7.2
+##
+{ 'struct': 'IOMMUFDProperties',
+        'data': { '*fd': 'str' } }
+
 ##
 # @RngProperties:
 #
@@ -862,6 +874,7 @@
     'qtest',
     'rng-builtin',
     'rng-egd',
+    'iommufd',
     { 'name': 'rng-random',
       'if': 'CONFIG_POSIX' },
     'secret',
@@ -938,7 +951,8 @@
       'tls-creds-psk':              'TlsCredsPskProperties',
       'tls-creds-x509':             'TlsCredsX509Properties',
       'tls-cipher-suites':          'TlsCredsProperties',
-      'x-remote-object':            'RemoteObjectProperties'
+      'x-remote-object':            'RemoteObjectProperties',
+      'iommufd':                    'IOMMUFDProperties'
   } }
 
 ##
diff --git a/qemu-options.hx b/qemu-options.hx
index 60cf188da4..2f7204d826 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -4860,6 +4860,18 @@ SRST
 
         The ``share`` boolean option is on by default with memfd.
 
+    ``-object iommufd,id=id[,fd=fd]``
+        Creates an iommufd backend which allows control of DMA mapping
+        through the /dev/iommu device.
+
+        The ``id`` parameter is a unique ID which frontends (such as
+        vfio-pci of vdpa) will use to connect withe the iommufd backend.
+
+        The ``fd`` parameter is an optional pre-opened file descriptor
+        resulting from /dev/iommu opening. Usually the iommufd is shared
+        accross all subsystems, bringing the benefit of centralized
+        reference counting.
+
     ``-object rng-builtin,id=id``
         Creates a random number generator backend which obtains entropy
         from QEMU builtin functions. The ``id`` parameter is a unique ID
-- 
2.27.0

