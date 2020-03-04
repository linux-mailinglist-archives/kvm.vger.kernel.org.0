Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8DA1788B4
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 03:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387532AbgCDC4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 21:56:10 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10721 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387398AbgCDC4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 21:56:10 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B3FB6199FD87F02F1DFD;
        Wed,  4 Mar 2020 10:56:07 +0800 (CST)
Received: from localhost (10.173.228.206) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Wed, 4 Mar 2020
 10:55:57 +0800
From:   Jay Zhou <jianjay.zhou@huawei.com>
To:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
CC:     <pbonzini@redhat.com>, <mst@redhat.com>, <cohuck@redhat.com>,
        <peterx@redhat.com>, <wangxinxin.wang@huawei.com>,
        <weidong.huang@huawei.com>, <liu.jinsong@huawei.com>,
        <jianjay.zhou@huawei.com>
Subject: [PATCH] kvm: support to get/set dirty log initial-all-set capability
Date:   Wed, 4 Mar 2020 10:55:54 +0800
Message-ID: <20200304025554.2159-1-jianjay.zhou@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.228.206]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the new capability KVM_DIRTY_LOG_INITIALLY_SET of
KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 has been introduced in the
kernel, tweak the userspace side to detect and enable this
capability.

Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
---
 accel/kvm/kvm-all.c       | 21 ++++++++++++++-------
 linux-headers/linux/kvm.h |  3 +++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 439a4efe52..45ab25be63 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -100,7 +100,7 @@ struct KVMState
     bool kernel_irqchip_required;
     OnOffAuto kernel_irqchip_split;
     bool sync_mmu;
-    bool manual_dirty_log_protect;
+    uint64_t manual_dirty_log_protect;
     /* The man page (and posix) say ioctl numbers are signed int, but
      * they're not.  Linux, glibc and *BSD all treat ioctl numbers as
      * unsigned, and treating them as signed here can break things */
@@ -1882,6 +1882,7 @@ static int kvm_init(MachineState *ms)
     int ret;
     int type = 0;
     const char *kvm_type;
+    uint64_t dirty_log_manual_caps;
 
     s = KVM_STATE(ms->accelerator);
 
@@ -2007,14 +2008,20 @@ static int kvm_init(MachineState *ms)
     s->coalesced_pio = s->coalesced_mmio &&
                        kvm_check_extension(s, KVM_CAP_COALESCED_PIO);
 
-    s->manual_dirty_log_protect =
+    dirty_log_manual_caps =
         kvm_check_extension(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
-    if (s->manual_dirty_log_protect) {
-        ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0, 1);
+    dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
+                              KVM_DIRTY_LOG_INITIALLY_SET);
+    s->manual_dirty_log_protect = dirty_log_manual_caps;
+    if (dirty_log_manual_caps) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, 0,
+                                   dirty_log_manual_caps);
         if (ret) {
-            warn_report("Trying to enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 "
-                        "but failed.  Falling back to the legacy mode. ");
-            s->manual_dirty_log_protect = false;
+            warn_report("Trying to enable capability %"PRIu64" of "
+                        "KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 but failed. "
+                        "Falling back to the legacy mode. ",
+                        dirty_log_manual_caps);
+            s->manual_dirty_log_protect = 0;
         }
     }
 
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 265099100e..3cb71c2b19 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1628,4 +1628,7 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
 
+#define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
+#define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
+
 #endif /* __LINUX_KVM_H */
-- 
2.14.1.windows.1


