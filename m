Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF51761CD4
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjGYPDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjGYPCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:02:50 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C4635A2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:01:47 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4R9Kr04P0Cz6GD6B;
        Tue, 25 Jul 2023 22:57:04 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 25 Jul 2023 16:01:19 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>
CC:     <peter.maydell@linaro.org>, <ricarkol@google.com>,
        <kvm@vger.kernel.org>, <jonathan.cameron@huawei.com>,
        <linuxarm@huawei.com>
Subject: [RFC PATCH] arm/kvm: Enable support for KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
Date:   Tue, 25 Jul 2023 16:00:02 +0100
Message-ID: <20230725150002.621-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.2 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have Eager Page Split support added for ARM in the kernel[0],
enable it in Qemu. This adds,
 -eager-split-size to Qemu options to set the eager page split chunk size.
 -enable KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE.

The chunk size specifies how many pages to break at a time, using a
single allocation. Bigger the chunk size, more pages need to be
allocated ahead of time.

Notes:
 - I am not sure whether we need to call kvm_vm_check_extension() for
   KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE or not as kernel seems to disable
   eager page size by default and it will return zero always.

  -ToDo: Update qemu-options.hx

[0]: https://lore.kernel.org/all/168426111477.3193133.10748106199843780930.b4-ty@linux.dev/

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 include/sysemu/kvm_int.h |  1 +
 target/arm/kvm.c         | 73 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 511b42bde5..03a1660d40 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -116,6 +116,7 @@ struct KVMState
     uint64_t kvm_dirty_ring_bytes;  /* Size of the per-vcpu dirty ring */
     uint32_t kvm_dirty_ring_size;   /* Number of dirty GFNs per ring */
     bool kvm_dirty_ring_with_bitmap;
+    uint64_t kvm_eager_split_size; /* Eager Page Splitting chunk size */
     struct KVMDirtyRingReaper reaper;
     NotifyVmexitOption notify_vmexit;
     uint32_t notify_window;
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b4c7654f49..985d901062 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -30,6 +30,7 @@
 #include "exec/address-spaces.h"
 #include "hw/boards.h"
 #include "hw/irq.h"
+#include "qapi/visitor.h"
 #include "qemu/log.h"
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
@@ -247,6 +248,23 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
     return ret > 0 ? ret : 40;
 }
 
+static bool kvm_arm_eager_split_size_valid(uint64_t req_size, uint32_t sizes)
+{
+    int i;
+
+    for (i = 0; i < sizeof(uint32_t) * BITS_PER_BYTE; i++) {
+        if (!(sizes & (1 << i))) {
+            continue;
+        }
+
+        if (req_size == (1 << i)) {
+            return true;
+        }
+    }
+
+    return false;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret = 0;
@@ -280,6 +298,21 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    if (s->kvm_eager_split_size) {
+        uint32_t sizes;
+
+        sizes = kvm_vm_check_extension(s, KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES);
+        if (!sizes) {
+            error_report("Eager Page Split not supported on host");
+        } else if (!kvm_arm_eager_split_size_valid(s->kvm_eager_split_size,
+                                                   sizes)) {
+            error_report("Eager Page Split requested chunk size not valid");
+        } else if (kvm_vm_enable_cap(s, KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE, 0,
+                                     s->kvm_eager_split_size)) {
+            error_report("Failed to set Eager Page Split chunk size");
+        }
+    }
+
     kvm_arm_init_debug(s);
 
     return ret;
@@ -1062,6 +1095,46 @@ bool kvm_arch_cpu_check_are_resettable(void)
     return true;
 }
 
+static void kvm_arch_get_eager_split_size(Object *obj, Visitor *v,
+                                          const char *name, void *opaque,
+                                          Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    uint64_t value = s->kvm_eager_split_size;
+
+    visit_type_size(v, name, &value, errp);
+}
+
+static void kvm_arch_set_eager_split_size(Object *obj, Visitor *v,
+                                          const char *name, void *opaque,
+                                          Error **errp)
+{
+    KVMState *s = KVM_STATE(obj);
+    uint64_t value;
+
+    if (s->fd != -1) {
+        error_setg(errp, "Cannot set properties after the accelerator has been initialized");
+        return;
+    }
+
+    if (!visit_type_size(v, name, &value, errp)) {
+        return;
+    }
+
+    if (value & (value - 1)) {
+        error_setg(errp, "early-split-size must be a power of two.");
+        return;
+    }
+
+    s->kvm_eager_split_size = value;
+}
+
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
+    object_class_property_add(oc, "eager-split-size", "size",
+                              kvm_arch_get_eager_split_size,
+                              kvm_arch_set_eager_split_size, NULL, NULL);
+
+    object_class_property_set_description(oc, "eager-split-size",
+        "Configure Eager Page Split chunk size for hugepages. (default: 0, disabled)");
 }
-- 
2.34.1

