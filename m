Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7469D78D941
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjH3ScG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243823AbjH3Lss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 07:48:48 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1F21B0
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 04:48:43 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RbMwp3w51z6HJcB;
        Wed, 30 Aug 2023 19:47:38 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 30 Aug 2023 12:48:36 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>
CC:     <peter.maydell@linaro.org>, <gshan@redhat.com>,
        <ricarkol@google.com>, <jonathan.cameron@huawei.com>,
        <kvm@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [PATCH v3] arm/kvm: Enable support for KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE
Date:   Wed, 30 Aug 2023 12:48:18 +0100
Message-ID: <20230830114818.641-1-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have Eager Page Split support added for ARM in the kernel,
enable it in Qemu. This adds,
 -eager-split-size to -accel sub-options to set the eager page split chunk size.
 -enable KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE.

The chunk size specifies how many pages to break at a time, using a
single allocation. Bigger the chunk size, more pages need to be
allocated ahead of time.

Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
v2: https://lore.kernel.org/qemu-devel/20230815092709.1290-1-shameerali.kolothum.thodi@huawei.com/
   -Addressed comments from Gavin(Thanks).
RFC v1: https://lore.kernel.org/qemu-devel/20230725150002.621-1-shameerali.kolothum.thodi@huawei.com/
  -Updated qemu-options.hx with description
  -Addressed review comments from Peter and Gavin(Thanks).
---
 accel/kvm/kvm-all.c      |  1 +
 include/sysemu/kvm_int.h |  1 +
 qemu-options.hx          | 15 +++++++++
 target/arm/kvm.c         | 68 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 85 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 2ba7521695..ff1578bb32 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3763,6 +3763,7 @@ static void kvm_accel_instance_init(Object *obj)
     /* KVM dirty ring is by default off */
     s->kvm_dirty_ring_size = 0;
     s->kvm_dirty_ring_with_bitmap = false;
+    s->kvm_eager_split_size = 0;
     s->notify_vmexit = NOTIFY_VMEXIT_OPTION_RUN;
     s->notify_window = 0;
     s->xen_version = 0;
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 511b42bde5..a5b9122cb8 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -116,6 +116,7 @@ struct KVMState
     uint64_t kvm_dirty_ring_bytes;  /* Size of the per-vcpu dirty ring */
     uint32_t kvm_dirty_ring_size;   /* Number of dirty GFNs per ring */
     bool kvm_dirty_ring_with_bitmap;
+    uint64_t kvm_eager_split_size;  /* Eager Page Splitting chunk size */
     struct KVMDirtyRingReaper reaper;
     NotifyVmexitOption notify_vmexit;
     uint32_t notify_window;
diff --git a/qemu-options.hx b/qemu-options.hx
index 29b98c3d4c..2e70704ee8 100644
--- a/qemu-options.hx
+++ b/qemu-options.hx
@@ -186,6 +186,7 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
     "                split-wx=on|off (enable TCG split w^x mapping)\n"
     "                tb-size=n (TCG translation block cache size)\n"
     "                dirty-ring-size=n (KVM dirty ring GFN count, default 0)\n"
+    "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
     "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
     "                thread=single|multi (enable multi-threaded TCG)\n", QEMU_ARCH_ALL)
 SRST
@@ -244,6 +245,20 @@ SRST
         is disabled (dirty-ring-size=0).  When enabled, KVM will instead
         record dirty pages in a bitmap.
 
+    ``eager-split-size=n``
+        KVM implements dirty page logging at the PAGE_SIZE granularity and
+        enabling dirty-logging on a huge-page requires breaking it into
+        PAGE_SIZE pages in the first place. KVM on ARM does this splitting
+        lazily by default. There are performance benefits in doing huge-page
+        split eagerly, especially in situations where TLBI costs associated
+        with break-before-make sequences are considerable and also if guest
+        workloads are read intensive. The size here specifies how many pages
+        to break at a time and needs to be a valid block size which is
+        1GB/2MB/4KB, 32MB/16KB and 512MB/64KB for 4KB/16KB/64KB PAGE_SIZE
+        respectively. Be wary of specifying a higher size as it will have an
+        impact on the memory. By default, this feature is disabled
+        (eager-split-size=0).
+
     ``notify-vmexit=run|internal-error|disable,notify-window=n``
         Enables or disables notify VM exit support on x86 host and specify
         the corresponding notify window to trigger the VM exit if enabled.
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 23aeb09949..28d81ca790 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -30,6 +30,7 @@
 #include "exec/address-spaces.h"
 #include "hw/boards.h"
 #include "hw/irq.h"
+#include "qapi/visitor.h"
 #include "qemu/log.h"
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
@@ -247,6 +248,12 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
     return ret > 0 ? ret : 40;
 }
 
+static inline bool kvm_arm_eager_split_size_valid(uint64_t req_size,
+                                                  uint32_t sizes)
+{
+    return req_size & sizes;
+}
+
 int kvm_arch_get_default_type(MachineState *ms)
 {
     bool fixed_ipa;
@@ -287,6 +294,27 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    if (s->kvm_eager_split_size) {
+        uint32_t sizes;
+
+        sizes = kvm_vm_check_extension(s, KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES);
+        if (!sizes) {
+            s->kvm_eager_split_size = 0;
+            warn_report("Eager Page Split support not available");
+        } else if (!kvm_arm_eager_split_size_valid(s->kvm_eager_split_size,
+                                                   sizes)) {
+            error_report("Eager Page Split requested chunk size not valid");
+            ret = -EINVAL;
+        } else {
+            ret = kvm_vm_enable_cap(s, KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE, 0,
+                                    s->kvm_eager_split_size);
+            if (ret < 0) {
+                error_report("Enabling of Eager Page Split failed: %s",
+                             strerror(-ret));
+            }
+        }
+    }
+
     kvm_arm_init_debug(s);
 
     return ret;
@@ -1069,6 +1097,46 @@ bool kvm_arch_cpu_check_are_resettable(void)
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
+        error_setg(errp, "Unable to set early-split-size after KVM has been initialized");
+        return;
+    }
+
+    if (!visit_type_size(v, name, &value, errp)) {
+        return;
+    }
+
+    if (value && !is_power_of_2(value)) {
+        error_setg(errp, "early-split-size must be a power of two");
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
+        "Eager Page Split chunk size for hugepages. (default: 0, disabled)");
 }
-- 
2.34.1

