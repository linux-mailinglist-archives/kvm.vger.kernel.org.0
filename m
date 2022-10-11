Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928465FAC6F
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 08:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJKGRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 02:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiJKGRN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 02:17:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3B187682
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 23:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665469031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cxXXRbMI86dbdaJM15PCr0qt8aKTCDZ4n59XMHU0T0Y=;
        b=C8v60kMl+ldQ5kcImTDPnwtsi936yGIFwHvBRAuUl2NBejhqWCHDEOoCoC96C1qHNvw2gH
        rTbRN4JjRsqn6Nvk8XicU6jVMZDoKeXxTTDARFn4f8W0qK/PFOJK1zNIcX3N6HQS761Z2b
        RuTl2EL4Op2jyBeBx4YUxtTrcYPxFiU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-3DuDIG4pNKynN6rPFE8mEQ-1; Tue, 11 Oct 2022 02:17:05 -0400
X-MC-Unique: 3DuDIG4pNKynN6rPFE8mEQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D602481DB6D;
        Tue, 11 Oct 2022 06:17:04 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-52.bne.redhat.com [10.64.54.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AE6A112D402;
        Tue, 11 Oct 2022 06:16:57 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, maz@kernel.org, will@kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, dmatlack@google.com, pbonzini@redhat.com,
        zhenyzha@redhat.com, james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        seanjc@google.com, shan.gavin@gmail.com
Subject: [PATCH v6 3/8] KVM: Add support for using dirty ring in conjunction with bitmap
Date:   Tue, 11 Oct 2022 14:14:42 +0800
Message-Id: <20221011061447.131531-4-gshan@redhat.com>
In-Reply-To: <20221011061447.131531-1-gshan@redhat.com>
References: <20221011061447.131531-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some architectures (such as arm64) need to dirty memory outside of the
context of a vCPU. Of course, this simply doesn't fit with the UAPI of
KVM's per-vCPU dirty ring.

Introduce a new flavor of dirty ring that requires the use of both vCPU
dirty rings and a dirty bitmap. The expectation is that for non-vCPU
sources of dirty memory (such as the GIC ITS on arm64), KVM writes to
the dirty bitmap. Userspace should scan the dirty bitmap before
migrating the VM to the target.

Use an additional capability to advertize this behavior and require
explicit opt-in to avoid breaking the existing dirty ring ABI. And yes,
you can use this with your preferred flavor of DIRTY_RING[_ACQ_REL]. Do
not allow userspace to enable dirty ring if it hasn't also enabled the
ring && bitmap capability, as a VM is likely DOA without the pages
marked in the bitmap.

Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Peter Xu <peterx@redhat.com>
Co-developed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst | 17 ++++++++---------
 include/linux/kvm_dirty_ring.h |  6 ++++++
 include/linux/kvm_host.h       |  1 +
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/Kconfig               |  8 ++++++++
 virt/kvm/dirty_ring.c          |  5 +++++
 virt/kvm/kvm_main.c            | 34 +++++++++++++++++++++++++---------
 7 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 32427ea160df..09fa6c491c1b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8019,8 +8019,8 @@ guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
 (0x40000001). Otherwise, a guest may use the paravirtual features
 regardless of what has actually been exposed through the CPUID leaf.
 
-8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
-----------------------------------------------------------
+8.29 KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL, RING_WITH_BITMAP}
+-------------------------------------------------------------
 
 :Architectures: x86
 :Parameters: args[0] - size of the dirty log ring
@@ -8104,13 +8104,6 @@ flushing is done by the KVM_GET_DIRTY_LOG ioctl).  To achieve that, one
 needs to kick the vcpu out of KVM_RUN using a signal.  The resulting
 vmexit ensures that all dirty GFNs are flushed to the dirty rings.
 
-NOTE: the capability KVM_CAP_DIRTY_LOG_RING and the corresponding
-ioctl KVM_RESET_DIRTY_RINGS are mutual exclusive to the existing ioctls
-KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG.  After enabling
-KVM_CAP_DIRTY_LOG_RING with an acceptable dirty ring size, the virtual
-machine will switch to ring-buffer dirty page tracking and further
-KVM_GET_DIRTY_LOG or KVM_CLEAR_DIRTY_LOG ioctls will fail.
-
 NOTE: KVM_CAP_DIRTY_LOG_RING_ACQ_REL is the only capability that
 should be exposed by weakly ordered architecture, in order to indicate
 the additional memory ordering requirements imposed on userspace when
@@ -8119,6 +8112,12 @@ Architecture with TSO-like ordering (such as x86) are allowed to
 expose both KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LOG_RING_ACQ_REL
 to userspace.
 
+NOTE: There is no running vcpu and available vcpu dirty ring when pages
+becomes dirty in some cases. One example is to save arm64's vgic/its
+tables during migration. The dirty bitmap is still used to track those
+dirty pages, indicated by KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP. The ditry
+bitmap is visited by KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG ioctls.
+
 8.30 KVM_CAP_XEN_HVM
 --------------------
 
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index fe5982b46424..23b2b466aa0f 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -28,6 +28,11 @@ struct kvm_dirty_ring {
 };
 
 #ifndef CONFIG_HAVE_KVM_DIRTY_RING
+static inline bool kvm_dirty_ring_exclusive(struct kvm *kvm)
+{
+	return false;
+}
+
 /*
  * If CONFIG_HAVE_HVM_DIRTY_RING not defined, kvm_dirty_ring.o should
  * not be included as well, so define these nop functions for the arch.
@@ -66,6 +71,7 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
+bool kvm_dirty_ring_exclusive(struct kvm *kvm);
 int kvm_cpu_dirty_log_size(void);
 u32 kvm_dirty_ring_get_rsvd_entries(void);
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 53fa3134fee0..a3fae111f25c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -780,6 +780,7 @@ struct kvm {
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
+	bool dirty_ring_with_bitmap;
 	bool vm_bugged;
 	bool vm_dead;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d4419139a..c87b5882d7ae 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1178,6 +1178,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+#define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 224
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 800f9470e36b..228be1145cf3 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -33,6 +33,14 @@ config HAVE_KVM_DIRTY_RING_ACQ_REL
        bool
        select HAVE_KVM_DIRTY_RING
 
+# Only architectures that need to dirty memory outside of a vCPU
+# context should select this, advertising to userspace the
+# requirement to use a dirty bitmap in addition to the vCPU dirty
+# ring.
+config HAVE_KVM_DIRTY_RING_WITH_BITMAP
+	bool
+	depends on HAVE_KVM_DIRTY_RING
+
 config HAVE_KVM_EVENTFD
        bool
        select EVENTFD
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index f68d75026bc0..9cc60af291ef 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -11,6 +11,11 @@
 #include <trace/events/kvm.h>
 #include "kvm_mm.h"
 
+bool kvm_dirty_ring_exclusive(struct kvm *kvm)
+{
+	return kvm->dirty_ring_size && !kvm->dirty_ring_with_bitmap;
+}
+
 int __weak kvm_cpu_dirty_log_size(void)
 {
 	return 0;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5b064dbadaf4..8915dcefcefd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1617,7 +1617,7 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 			new->dirty_bitmap = NULL;
 		else if (old && old->dirty_bitmap)
 			new->dirty_bitmap = old->dirty_bitmap;
-		else if (!kvm->dirty_ring_size) {
+		else if (!kvm_dirty_ring_exclusive(kvm)) {
 			r = kvm_alloc_dirty_bitmap(new);
 			if (r)
 				return r;
@@ -2060,8 +2060,8 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	unsigned long n;
 	unsigned long any = 0;
 
-	/* Dirty ring tracking is exclusive to dirty log tracking */
-	if (kvm->dirty_ring_size)
+	/* Dirty ring tracking may be exclusive to dirty log tracking */
+	if (kvm_dirty_ring_exclusive(kvm))
 		return -ENXIO;
 
 	*memslot = NULL;
@@ -2125,8 +2125,8 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
-	/* Dirty ring tracking is exclusive to dirty log tracking */
-	if (kvm->dirty_ring_size)
+	/* Dirty ring tracking may be exclusive to dirty log tracking */
+	if (kvm_dirty_ring_exclusive(kvm))
 		return -ENXIO;
 
 	as_id = log->slot >> 16;
@@ -2237,8 +2237,8 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
-	/* Dirty ring tracking is exclusive to dirty log tracking */
-	if (kvm->dirty_ring_size)
+	/* Dirty ring tracking may be exclusive to dirty log tracking */
+	if (kvm_dirty_ring_exclusive(kvm))
 		return -ENXIO;
 
 	as_id = log->slot >> 16;
@@ -3305,15 +3305,20 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 #ifdef CONFIG_HAVE_KVM_DIRTY_RING
-	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
+	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
 		return;
+
+#ifndef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
+	if (WARN_ON_ONCE(!vcpu))
+		return;
+#endif
 #endif
 
 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-		if (kvm->dirty_ring_size)
+		if (vcpu && kvm->dirty_ring_size)
 			kvm_dirty_ring_push(&vcpu->dirty_ring,
 					    slot, rel_gfn);
 		else
@@ -4485,6 +4490,9 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
 #else
 		return 0;
+#endif
+#ifdef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
+	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
 #endif
 	case KVM_CAP_BINARY_STATS_FD:
 	case KVM_CAP_SYSTEM_EVENT_DATA:
@@ -4499,6 +4507,11 @@ static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
 {
 	int r;
 
+#ifdef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
+	if (!kvm->dirty_ring_with_bitmap)
+		return -EINVAL;
+#endif
+
 	if (!KVM_DIRTY_LOG_PAGE_OFFSET)
 		return -EINVAL;
 
@@ -4588,6 +4601,9 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 	case KVM_CAP_DIRTY_LOG_RING:
 	case KVM_CAP_DIRTY_LOG_RING_ACQ_REL:
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
+	case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
+		kvm->dirty_ring_with_bitmap = true;
+		return 0;
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
-- 
2.23.0

