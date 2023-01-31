Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A917868380A
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbjAaU4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjAaUzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:55:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EC59ED7
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 12:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675198492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q6lMoZ+cQikWTb4InCvBka6E168DizOdczxQ5sDFk1k=;
        b=GUkLjET5PS4slQE6s9VyHS63Du/+NI/kwYeXjvB6ArwYzMzYdjbUf3TRQr1l1SCDU01K5Q
        usMGto15M3ODdxRHGSQSHSgggJguU7FK+JzV6mS+K8OB6vLAkuwREm2y31f0t0WIRwDkcj
        RcthqW4BRkZnSNEL3b9pkNerDiARIJM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-86EKuDKZOsKvR5W--eNfZA-1; Tue, 31 Jan 2023 15:54:49 -0500
X-MC-Unique: 86EKuDKZOsKvR5W--eNfZA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 40EE5855305;
        Tue, 31 Jan 2023 20:54:48 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C06340C2064;
        Tue, 31 Jan 2023 20:54:41 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com, alex.williamson@redhat.com,
        clg@redhat.com, qemu-devel@nongnu.org
Cc:     david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        nicolinc@nvidia.com, kevin.tian@intel.com, chao.p.peng@intel.com,
        peterx@redhat.com, shameerali.kolothum.thodi@huawei.com,
        zhangfei.gao@linaro.org, berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
Subject: [RFC v3 14/18] backends/iommufd: Introduce the iommufd object
Date:   Tue, 31 Jan 2023 21:53:01 +0100
Message-Id: <20230131205305.2726330-15-eric.auger@redhat.com>
In-Reply-To: <20230131205305.2726330-1-eric.auger@redhat.com>
References: <20230131205305.2726330-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

v2 -> v3:
- add stub file
---
 MAINTAINERS              |   7 ++
 qapi/qom.json            |  16 ++-
 include/sysemu/iommufd.h |  47 +++++++
 backends/iommufd.c       | 265 +++++++++++++++++++++++++++++++++++++++
 backends/iommufd_stub.c  |  35 ++++++
 backends/Kconfig         |   5 +
 backends/meson.build     |   2 +
 backends/trace-events    |  12 ++
 qemu-options.hx          |  12 ++
 9 files changed, 400 insertions(+), 1 deletion(-)
 create mode 100644 include/sysemu/iommufd.h
 create mode 100644 backends/iommufd.c
 create mode 100644 backends/iommufd_stub.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c581c11a64..48e41e4c1b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2020,6 +2020,13 @@ F: hw/vfio/ap.c
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
diff --git a/qapi/qom.json b/qapi/qom.json
index 30e76653ad..8be01867b5 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -752,6 +752,18 @@
 { 'struct': 'VfioUserServerProperties',
   'data': { 'socket': 'SocketAddress', 'device': 'str' } }
 
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
@@ -903,6 +915,7 @@
     'qtest',
     'rng-builtin',
     'rng-egd',
+    'iommufd',
     { 'name': 'rng-random',
       'if': 'CONFIG_POSIX' },
     'secret',
@@ -984,7 +997,8 @@
       'tls-creds-x509':             'TlsCredsX509Properties',
       'tls-cipher-suites':          'TlsCredsProperties',
       'x-remote-object':            'RemoteObjectProperties',
-      'x-vfio-user-server':         'VfioUserServerProperties'
+      'x-vfio-user-server':         'VfioUserServerProperties',
+      'iommufd':                    'IOMMUFDProperties'
   } }
 
 ##
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
diff --git a/backends/iommufd_stub.c b/backends/iommufd_stub.c
new file mode 100644
index 0000000000..388da66825
--- /dev/null
+++ b/backends/iommufd_stub.c
@@ -0,0 +1,35 @@
+/*
+ * iommufd container backend stub
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
+#include "qemu/error-report.h"
+
+int iommufd_backend_connect(IOMMUFDBackend *be, Error **errp)
+{
+    return 0;
+}
+
+void iommufd_backend_disconnect(IOMMUFDBackend *be)
+{
+}
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
diff --git a/backends/meson.build b/backends/meson.build
index 954e658b25..a84d7ed6aa 100644
--- a/backends/meson.build
+++ b/backends/meson.build
@@ -18,6 +18,8 @@ endif
 if have_vhost_user
   softmmu_ss.add(when: 'CONFIG_VIRTIO', if_true: files('vhost-user.c'))
 endif
+specific_ss.add(when: 'CONFIG_IOMMUFD', if_true: files('iommufd.c'),
+                                        if_false: files('iommufd_stub.c'))
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
diff --git a/qemu-options.hx b/qemu-options.hx
index d59d19704b..6c343d8e17 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -4993,6 +4993,18 @@ SRST
 
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
2.37.3

