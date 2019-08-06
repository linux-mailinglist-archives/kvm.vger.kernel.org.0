Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2446883928
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 20:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfHFS5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 14:57:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:40914 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfHFS5H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 14:57:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Aug 2019 11:56:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,353,1559545200"; 
   d="scan'208";a="176715066"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 06 Aug 2019 11:56:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 02/20] i386: Add 'sgx-epc' device to expose EPC sections to guest
Date:   Tue,  6 Aug 2019 11:56:31 -0700
Message-Id: <20190806185649.2476-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190806185649.2476-1-sean.j.christopherson@intel.com>
References: <20190806185649.2476-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGX EPC is enumerated through CPUID, i.e. EPC "devices" need to be
realized prior to realizing the vCPUs themselves, which occurs long
before generic devices are parsed and realized.  Because of this,
do not allow 'sgx-epc' devices to be instantiated after vCPUS have
been created.

The 'sgx-epc' device is essentially a placholder at this time, it will
be fully implemented in a future patch along with a dedicated command
to create 'sgx-epc' devices.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 hw/i386/Makefile.objs     |   1 +
 hw/i386/sgx-epc.c         | 169 ++++++++++++++++++++++++++++++++++++++
 include/hw/i386/sgx-epc.h |  44 ++++++++++
 qapi/misc.json            |  32 +++++++-
 4 files changed, 244 insertions(+), 2 deletions(-)
 create mode 100644 hw/i386/sgx-epc.c
 create mode 100644 include/hw/i386/sgx-epc.h

diff --git a/hw/i386/Makefile.objs b/hw/i386/Makefile.objs
index 5d9c9efd5f..18c9693d9d 100644
--- a/hw/i386/Makefile.objs
+++ b/hw/i386/Makefile.objs
@@ -13,3 +13,4 @@ obj-$(CONFIG_VMMOUSE) += vmmouse.o
 
 obj-y += kvmvapic.o
 obj-y += acpi-build.o
+obj-y += sgx-epc.o
diff --git a/hw/i386/sgx-epc.c b/hw/i386/sgx-epc.c
new file mode 100644
index 0000000000..73221ba86b
--- /dev/null
+++ b/hw/i386/sgx-epc.c
@@ -0,0 +1,169 @@
+/*
+ * SGX EPC device
+ *
+ * Copyright (C) 2019 Intel Corporation
+ *
+ * Authors:
+ *   Sean Christopherson <sean.j.christopherson@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ */
+#include "qemu/osdep.h"
+#include "hw/i386/pc.h"
+#include "hw/i386/sgx-epc.h"
+#include "hw/mem/memory-device.h"
+#include "monitor/qdev.h"
+#include "qapi/error.h"
+#include "qapi/visitor.h"
+#include "qemu/config-file.h"
+#include "qemu/error-report.h"
+#include "qemu/option.h"
+#include "qemu/units.h"
+#include "target/i386/cpu.h"
+
+static Property sgx_epc_properties[] = {
+    DEFINE_PROP_UINT64(SGX_EPC_ADDR_PROP, SGXEPCDevice, addr, 0),
+    DEFINE_PROP_LINK(SGX_EPC_MEMDEV_PROP, SGXEPCDevice, hostmem,
+                     TYPE_MEMORY_BACKEND, HostMemoryBackend *),
+    DEFINE_PROP_END_OF_LIST(),
+};
+
+static void sgx_epc_get_size(Object *obj, Visitor *v, const char *name,
+                             void *opaque, Error **errp)
+{
+    Error *local_err = NULL;
+    uint64_t value;
+
+    value = memory_device_get_region_size(MEMORY_DEVICE(obj), &local_err);
+    if (local_err) {
+        error_propagate(errp, local_err);
+        return;
+    }
+
+    visit_type_uint64(v, name, &value, errp);
+}
+
+static void sgx_epc_init(Object *obj)
+{
+    object_property_add(obj, SGX_EPC_SIZE_PROP, "uint64", sgx_epc_get_size,
+                        NULL, NULL, NULL, &error_abort);
+}
+
+static void sgx_epc_realize(DeviceState *dev, Error **errp)
+{
+    PCMachineState *pcms = PC_MACHINE(qdev_get_machine());
+    SGXEPCDevice *epc = SGX_EPC(dev);
+
+    if (pcms->boot_cpus != 0) {
+        error_setg(errp,
+            "'" TYPE_SGX_EPC "' can't be created after vCPUs, e.g. via -device");
+        return;
+    }
+
+    if (!epc->hostmem) {
+        error_setg(errp, "'" SGX_EPC_MEMDEV_PROP "' property is not set");
+        return;
+    } else if (host_memory_backend_is_mapped(epc->hostmem)) {
+        char *path = object_get_canonical_path_component(OBJECT(epc->hostmem));
+        error_setg(errp, "can't use already busy memdev: %s", path);
+        g_free(path);
+        return;
+    }
+
+    error_setg(errp, "'" TYPE_SGX_EPC "' not supported");
+}
+
+static void sgx_epc_unrealize(DeviceState *dev, Error **errp)
+{
+    SGXEPCDevice *epc = SGX_EPC(dev);
+
+    host_memory_backend_set_mapped(epc->hostmem, false);
+}
+
+static uint64_t sgx_epc_md_get_addr(const MemoryDeviceState *md)
+{
+    const SGXEPCDevice *epc = SGX_EPC(md);
+
+    return epc->addr;
+}
+
+static void sgx_epc_md_set_addr(MemoryDeviceState *md, uint64_t addr,
+                                Error **errp)
+{
+    object_property_set_uint(OBJECT(md), addr, SGX_EPC_ADDR_PROP, errp);
+}
+
+static uint64_t sgx_epc_md_get_plugged_size(const MemoryDeviceState *md,
+                                            Error **errp)
+{
+    return 0;
+}
+
+static MemoryRegion *sgx_epc_md_get_memory_region(MemoryDeviceState *md,
+                                                  Error **errp)
+{
+    SGXEPCDevice *epc = SGX_EPC(md);
+
+    if (!epc->hostmem) {
+        error_setg(errp, "'" SGX_EPC_MEMDEV_PROP "' property must be set");
+        return NULL;
+    }
+
+    return host_memory_backend_get_memory(epc->hostmem);
+}
+
+static void sgx_epc_md_fill_device_info(const MemoryDeviceState *md,
+                                        MemoryDeviceInfo *info)
+{
+    SGXEPCDeviceInfo *di = g_new0(SGXEPCDeviceInfo, 1);
+    const SGXEPCDevice *epc = SGX_EPC(md);
+    const DeviceState *dev = DEVICE(md);
+
+    if (dev->id) {
+        di->has_id = true;
+        di->id = g_strdup(dev->id);
+    }
+    di->addr = epc->addr;
+    di->node = 0 /* TODO: EPC NUMA spec not yet defined */;
+    di->size = memory_device_get_region_size(MEMORY_DEVICE(epc), &error_fatal);
+    di->memdev = object_get_canonical_path(OBJECT(epc->hostmem));
+}
+
+static void sgx_epc_class_init(ObjectClass *oc, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(oc);
+    MemoryDeviceClass *mdc = MEMORY_DEVICE_CLASS(oc);
+
+    dc->hotpluggable = false;
+    dc->realize = sgx_epc_realize;
+    dc->unrealize = sgx_epc_unrealize;
+    dc->props = sgx_epc_properties;
+    dc->desc = "SGX EPC section";
+
+    mdc->get_addr = sgx_epc_md_get_addr;
+    mdc->set_addr = sgx_epc_md_set_addr;
+    mdc->get_plugged_size = sgx_epc_md_get_plugged_size;
+    mdc->get_memory_region = sgx_epc_md_get_memory_region;
+    mdc->fill_device_info = sgx_epc_md_fill_device_info;
+}
+
+static TypeInfo sgx_epc_info = {
+    .name          = TYPE_SGX_EPC,
+    .parent        = TYPE_DEVICE,
+    .instance_size = sizeof(SGXEPCDevice),
+    .instance_init = sgx_epc_init,
+    .class_init    = sgx_epc_class_init,
+    .class_size    = sizeof(DeviceClass),
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_MEMORY_DEVICE },
+        { }
+    },
+};
+
+static void sgx_epc_register_types(void)
+{
+    type_register_static(&sgx_epc_info);
+}
+
+type_init(sgx_epc_register_types)
diff --git a/include/hw/i386/sgx-epc.h b/include/hw/i386/sgx-epc.h
new file mode 100644
index 0000000000..5fd9ae2d0c
--- /dev/null
+++ b/include/hw/i386/sgx-epc.h
@@ -0,0 +1,44 @@
+/*
+ * SGX EPC device
+ *
+ * Copyright (C) 2019 Intel Corporation
+ *
+ * Authors:
+ *   Sean Christopherson <sean.j.christopherson@intel.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ */
+#ifndef QEMU_SGX_EPC_H
+#define QEMU_SGX_EPC_H
+
+#include "sysemu/hostmem.h"
+
+#define TYPE_SGX_EPC "sgx-epc"
+#define SGX_EPC(obj) \
+    OBJECT_CHECK(SGXEPCDevice, (obj), TYPE_SGX_EPC)
+#define SGX_EPC_CLASS(oc) \
+    OBJECT_CLASS_CHECK(SGXEPCDeviceClass, (oc), TYPE_SGX_EPC)
+#define SGX_EPC_GET_CLASS(obj) \
+    OBJECT_GET_CLASS(SGXEPCDeviceClass, (obj), TYPE_SGX_EPC)
+
+#define SGX_EPC_ADDR_PROP "addr"
+#define SGX_EPC_SIZE_PROP "size"
+#define SGX_EPC_MEMDEV_PROP "memdev"
+
+/**
+ * SGXEPCDevice:
+ * @addr: starting guest physical address, where @SGXEPCDevice is mapped.
+ *         Default value: 0, means that address is auto-allocated.
+ * @hostmem: host memory backend providing memory for @SGXEPCDevice
+ */
+typedef struct SGXEPCDevice {
+    /* private */
+    DeviceState parent_obj;
+
+    /* public */
+    uint64_t addr;
+    HostMemoryBackend *hostmem;
+} SGXEPCDevice;
+
+#endif
diff --git a/qapi/misc.json b/qapi/misc.json
index a7fba7230c..965905c9e8 100644
--- a/qapi/misc.json
+++ b/qapi/misc.json
@@ -1573,19 +1573,47 @@
           }
 }
 
+##
+# @SGXEPCDeviceInfo:
+#
+# SGX EPC state information
+#
+# @id: device's ID
+#
+# @addr: physical address, where device is mapped
+#
+# @size: size of memory that the device provides
+#
+# @node: NUMA node number where device is plugged in
+#
+# @memdev: memory backend linked with device
+#
+# Since: TBD
+##
+{ 'struct': 'SGXEPCDeviceInfo',
+  'data': { '*id': 'str',
+            'addr': 'int',
+            'size': 'int',
+            'node': 'int',
+            'memdev': 'str'
+          }
+}
+
 ##
 # @MemoryDeviceInfo:
 #
 # Union containing information about a memory device
 #
-# nvdimm is included since 2.12. virtio-pmem is included since 4.1.
+# nvdimm is included since 2.12. virtio-pmem is included since 4.1,
+# sgx-epc is included since TBD.
 #
 # Since: 2.1
 ##
 { 'union': 'MemoryDeviceInfo',
   'data': { 'dimm': 'PCDIMMDeviceInfo',
             'nvdimm': 'PCDIMMDeviceInfo',
-            'virtio-pmem': 'VirtioPMEMDeviceInfo'
+            'virtio-pmem': 'VirtioPMEMDeviceInfo',
+            'sgx-epc': 'SGXEPCDeviceInfo'
           }
 }
 
-- 
2.22.0

