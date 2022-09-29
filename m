Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDED5EEE9D
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 09:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiI2HOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 03:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbiI2HOO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 03:14:14 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E07132FC9
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 00:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664435647; x=1695971647;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=1HHLTf+mZEpAZdLpZzQsDowRVBDqPVQnup/F4dRvES4=;
  b=M36mFj52JVgKog7mul6OGEnj27d6vSwF4OliiydaHX9ylofyPeIfSRlX
   7PLxA7xogkGuB9+Uc+y4JaBJxm4fGyvz6go3JUNYYbCTCT6a98XFq/925
   uorX+VWiwbOl+hgIZKnDO72Tgj6nc8Oc1IO5/wMkQuUBqYvCyH0QQUPEq
   oXE0BomC0z0bw8/9FofpFs773UslDHupocTexLSc8je8OJ3YBYiTbM2sI
   ZLnGTuAbxjdzfUDVaniHgMK8dx7+9YSseJPQxwaUPygB1xeLV267tfLiL
   gAnXnOrJ5m32fKQBZtiUDp34K71Qcw3nLvsd3t4TPe7Yd83EFEJVDwti2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="288978817"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="288978817"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:14:05 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="655440736"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="655440736"
Received: from chenyi-pc.sh.intel.com ([10.239.159.53])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 00:14:03 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Peter Xu <peterx@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [RESEND PATCH v8 3/4] kvm: expose struct KVMState
Date:   Thu, 29 Sep 2022 15:20:13 +0800
Message-Id: <20220929072014.20705-4-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220929072014.20705-1-chenyi.qiang@intel.com>
References: <20220929072014.20705-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose struct KVMState out of kvm-all.c so that the field of struct
KVMState can be accessed when defining target-specific accelerator
properties.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 accel/kvm/kvm-all.c      | 74 ---------------------------------------
 include/sysemu/kvm_int.h | 75 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 74 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f90c5cb285..3624ed8447 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -77,86 +77,12 @@
     do { } while (0)
 #endif
 
-#define KVM_MSI_HASHTAB_SIZE    256
-
 struct KVMParkedVcpu {
     unsigned long vcpu_id;
     int kvm_fd;
     QLIST_ENTRY(KVMParkedVcpu) node;
 };
 
-enum KVMDirtyRingReaperState {
-    KVM_DIRTY_RING_REAPER_NONE = 0,
-    /* The reaper is sleeping */
-    KVM_DIRTY_RING_REAPER_WAIT,
-    /* The reaper is reaping for dirty pages */
-    KVM_DIRTY_RING_REAPER_REAPING,
-};
-
-/*
- * KVM reaper instance, responsible for collecting the KVM dirty bits
- * via the dirty ring.
- */
-struct KVMDirtyRingReaper {
-    /* The reaper thread */
-    QemuThread reaper_thr;
-    volatile uint64_t reaper_iteration; /* iteration number of reaper thr */
-    volatile enum KVMDirtyRingReaperState reaper_state; /* reap thr state */
-};
-
-struct KVMState
-{
-    AccelState parent_obj;
-
-    int nr_slots;
-    int fd;
-    int vmfd;
-    int coalesced_mmio;
-    int coalesced_pio;
-    struct kvm_coalesced_mmio_ring *coalesced_mmio_ring;
-    bool coalesced_flush_in_progress;
-    int vcpu_events;
-    int robust_singlestep;
-    int debugregs;
-#ifdef KVM_CAP_SET_GUEST_DEBUG
-    QTAILQ_HEAD(, kvm_sw_breakpoint) kvm_sw_breakpoints;
-#endif
-    int max_nested_state_len;
-    int many_ioeventfds;
-    int intx_set_mask;
-    int kvm_shadow_mem;
-    bool kernel_irqchip_allowed;
-    bool kernel_irqchip_required;
-    OnOffAuto kernel_irqchip_split;
-    bool sync_mmu;
-    uint64_t manual_dirty_log_protect;
-    /* The man page (and posix) say ioctl numbers are signed int, but
-     * they're not.  Linux, glibc and *BSD all treat ioctl numbers as
-     * unsigned, and treating them as signed here can break things */
-    unsigned irq_set_ioctl;
-    unsigned int sigmask_len;
-    GHashTable *gsimap;
-#ifdef KVM_CAP_IRQ_ROUTING
-    struct kvm_irq_routing *irq_routes;
-    int nr_allocated_irq_routes;
-    unsigned long *used_gsi_bitmap;
-    unsigned int gsi_count;
-    QTAILQ_HEAD(, KVMMSIRoute) msi_hashtab[KVM_MSI_HASHTAB_SIZE];
-#endif
-    KVMMemoryListener memory_listener;
-    QLIST_HEAD(, KVMParkedVcpu) kvm_parked_vcpus;
-
-    /* For "info mtree -f" to tell if an MR is registered in KVM */
-    int nr_as;
-    struct KVMAs {
-        KVMMemoryListener *ml;
-        AddressSpace *as;
-    } *as;
-    uint64_t kvm_dirty_ring_bytes;  /* Size of the per-vcpu dirty ring */
-    uint32_t kvm_dirty_ring_size;   /* Number of dirty GFNs per ring */
-    struct KVMDirtyRingReaper reaper;
-};
-
 KVMState *kvm_state;
 bool kvm_kernel_irqchip;
 bool kvm_split_irqchip;
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index 1f5487d9b7..07394744ad 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -36,6 +36,81 @@ typedef struct KVMMemoryListener {
     int as_id;
 } KVMMemoryListener;
 
+#define KVM_MSI_HASHTAB_SIZE    256
+
+enum KVMDirtyRingReaperState {
+    KVM_DIRTY_RING_REAPER_NONE = 0,
+    /* The reaper is sleeping */
+    KVM_DIRTY_RING_REAPER_WAIT,
+    /* The reaper is reaping for dirty pages */
+    KVM_DIRTY_RING_REAPER_REAPING,
+};
+
+/*
+ * KVM reaper instance, responsible for collecting the KVM dirty bits
+ * via the dirty ring.
+ */
+struct KVMDirtyRingReaper {
+    /* The reaper thread */
+    QemuThread reaper_thr;
+    volatile uint64_t reaper_iteration; /* iteration number of reaper thr */
+    volatile enum KVMDirtyRingReaperState reaper_state; /* reap thr state */
+};
+struct KVMState
+{
+    AccelState parent_obj;
+
+    int nr_slots;
+    int fd;
+    int vmfd;
+    int coalesced_mmio;
+    int coalesced_pio;
+    struct kvm_coalesced_mmio_ring *coalesced_mmio_ring;
+    bool coalesced_flush_in_progress;
+    int vcpu_events;
+    int robust_singlestep;
+    int debugregs;
+#ifdef KVM_CAP_SET_GUEST_DEBUG
+    QTAILQ_HEAD(, kvm_sw_breakpoint) kvm_sw_breakpoints;
+#endif
+    int max_nested_state_len;
+    int many_ioeventfds;
+    int intx_set_mask;
+    int kvm_shadow_mem;
+    bool kernel_irqchip_allowed;
+    bool kernel_irqchip_required;
+    OnOffAuto kernel_irqchip_split;
+    bool sync_mmu;
+    uint64_t manual_dirty_log_protect;
+    /* The man page (and posix) say ioctl numbers are signed int, but
+     * they're not.  Linux, glibc and *BSD all treat ioctl numbers as
+     * unsigned, and treating them as signed here can break things */
+    unsigned irq_set_ioctl;
+    unsigned int sigmask_len;
+    GHashTable *gsimap;
+#ifdef KVM_CAP_IRQ_ROUTING
+    struct kvm_irq_routing *irq_routes;
+    int nr_allocated_irq_routes;
+    unsigned long *used_gsi_bitmap;
+    unsigned int gsi_count;
+    QTAILQ_HEAD(, KVMMSIRoute) msi_hashtab[KVM_MSI_HASHTAB_SIZE];
+#endif
+    KVMMemoryListener memory_listener;
+    QLIST_HEAD(, KVMParkedVcpu) kvm_parked_vcpus;
+
+    /* For "info mtree -f" to tell if an MR is registered in KVM */
+    int nr_as;
+    struct KVMAs {
+        KVMMemoryListener *ml;
+        AddressSpace *as;
+    } *as;
+    uint64_t kvm_dirty_ring_bytes;  /* Size of the per-vcpu dirty ring */
+    uint32_t kvm_dirty_ring_size;   /* Number of dirty GFNs per ring */
+    struct KVMDirtyRingReaper reaper;
+    NotifyVmexitOption notify_vmexit;
+    uint32_t notify_window;
+};
+
 void kvm_memory_listener_register(KVMState *s, KVMMemoryListener *kml,
                                   AddressSpace *as, int as_id, const char *name);
 
-- 
2.17.1

