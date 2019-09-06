Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB253AB412
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 10:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388611AbfIFIdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 04:33:22 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46448 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388188AbfIFIdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 04:33:22 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AF3E2BC4DD8F5A5EE6DC;
        Fri,  6 Sep 2019 16:33:20 +0800 (CST)
Received: from HGHY1z004218071.china.huawei.com (10.177.29.32) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 16:33:11 +0800
From:   Xiang Zheng <zhengxiang9@huawei.com>
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <jonathan.cameron@huawei.com>,
        <xuwei5@huawei.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <linuxarm@huawei.com>
CC:     <zhengxiang9@huawei.com>, <wanghaibin.wang@huawei.com>
Subject: [PATCH v18 4/6] KVM: Move hwpoison page related functions into include/sysemu/kvm_int.h
Date:   Fri, 6 Sep 2019 16:31:50 +0800
Message-ID: <20190906083152.25716-5-zhengxiang9@huawei.com>
X-Mailer: git-send-email 2.15.1.windows.2
In-Reply-To: <20190906083152.25716-1-zhengxiang9@huawei.com>
References: <20190906083152.25716-1-zhengxiang9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.29.32]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dongjiu Geng <gengdongjiu@huawei.com>

kvm_hwpoison_page_add() and kvm_unpoison_all() will both be used by X86
and ARM platforms, so moving them into "include/sysemu/kvm_int.h" to
avoid duplicate code.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
---
 accel/kvm/kvm-all.c      | 33 +++++++++++++++++++++++++++++++++
 include/sysemu/kvm_int.h | 23 +++++++++++++++++++++++
 target/arm/kvm.c         |  3 +++
 target/i386/kvm.c        | 34 ----------------------------------
 4 files changed, 59 insertions(+), 34 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index b09bad0804..c6c052ba57 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -821,6 +821,39 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension)
     return ret;
 }
 
+typedef struct HWPoisonPage {
+    ram_addr_t ram_addr;
+    QLIST_ENTRY(HWPoisonPage) list;
+} HWPoisonPage;
+
+static QLIST_HEAD(, HWPoisonPage) hwpoison_page_list =
+    QLIST_HEAD_INITIALIZER(hwpoison_page_list);
+
+void kvm_unpoison_all(void *param)
+{
+    HWPoisonPage *page, *next_page;
+
+    QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
+        QLIST_REMOVE(page, list);
+        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
+        g_free(page);
+    }
+}
+
+void kvm_hwpoison_page_add(ram_addr_t ram_addr)
+{
+    HWPoisonPage *page;
+
+    QLIST_FOREACH(page, &hwpoison_page_list, list) {
+        if (page->ram_addr == ram_addr) {
+            return;
+        }
+    }
+    page = g_new(HWPoisonPage, 1);
+    page->ram_addr = ram_addr;
+    QLIST_INSERT_HEAD(&hwpoison_page_list, page, list);
+}
+
 static uint32_t adjust_ioeventfd_endianness(uint32_t val, uint32_t size)
 {
 #if defined(HOST_WORDS_BIGENDIAN) != defined(TARGET_WORDS_BIGENDIAN)
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 72b2d1b3ae..3ad49f9a28 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -41,4 +41,27 @@ typedef struct KVMMemoryListener {
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
                                   AddressSpace *as, int as_id);
 
+/**
+ * kvm_hwpoison_page_add:
+ *
+ * Parameters:
+ *  @ram_addr: the address in the RAM for the poisoned page
+ *
+ * Add a poisoned page to the list
+ *
+ * Return: None.
+ */
+void kvm_hwpoison_page_add(ram_addr_t ram_addr);
+
+/**
+ * kvm_unpoison_all:
+ *
+ * Parameters:
+ *  @param: some data may be passed to this function
+ *
+ * Free and remove all the poisoned pages in the list
+ *
+ * Return: None.
+ */
+void kvm_unpoison_all(void *param);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b2eaa50b8d..3a110be7b8 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -20,6 +20,7 @@
 #include "sysemu/sysemu.h"
 #include "sysemu/kvm.h"
 #include "sysemu/kvm_int.h"
+#include "sysemu/reset.h"
 #include "kvm_arm.h"
 #include "cpu.h"
 #include "trace.h"
@@ -195,6 +196,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
     cap_has_mp_state = kvm_check_extension(s, KVM_CAP_MP_STATE);
 
+    qemu_register_reset(kvm_unpoison_all, NULL);
+
     return 0;
 }
 
diff --git a/target/i386/kvm.c b/target/i386/kvm.c
index 8023c679ea..4f9f3682ee 100644
--- a/target/i386/kvm.c
+++ b/target/i386/kvm.c
@@ -476,40 +476,6 @@ uint32_t kvm_arch_get_supported_msr_feature(KVMState *s, uint32_t index)
     return msr_data.entries[0].data;
 }
 
-
-typedef struct HWPoisonPage {
-    ram_addr_t ram_addr;
-    QLIST_ENTRY(HWPoisonPage) list;
-} HWPoisonPage;
-
-static QLIST_HEAD(, HWPoisonPage) hwpoison_page_list =
-    QLIST_HEAD_INITIALIZER(hwpoison_page_list);
-
-static void kvm_unpoison_all(void *param)
-{
-    HWPoisonPage *page, *next_page;
-
-    QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
-        QLIST_REMOVE(page, list);
-        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
-        g_free(page);
-    }
-}
-
-static void kvm_hwpoison_page_add(ram_addr_t ram_addr)
-{
-    HWPoisonPage *page;
-
-    QLIST_FOREACH(page, &hwpoison_page_list, list) {
-        if (page->ram_addr == ram_addr) {
-            return;
-        }
-    }
-    page = g_new(HWPoisonPage, 1);
-    page->ram_addr = ram_addr;
-    QLIST_INSERT_HEAD(&hwpoison_page_list, page, list);
-}
-
 static int kvm_get_mce_cap_supported(KVMState *s, uint64_t *mce_cap,
                                      int *max_banks)
 {
-- 
2.19.1


