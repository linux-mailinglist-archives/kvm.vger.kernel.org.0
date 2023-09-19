Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCCD7A6587
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 15:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbjISNmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 09:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbjISNmT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 09:42:19 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8E4F1;
        Tue, 19 Sep 2023 06:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
        s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:Cc:To:From;
        bh=pmNbzWpjKyD6nXJeVaKSsSXm22qdGsvLHPdebtOiJ8Q=; b=CQmVWMHNpeg1EdQZnitwNwIp9i
        hPhDpQmux9AlbPfZQo4pGtfc67smZAa0BXQa6Y0scHjV3bXZKQelcpeJTH8V3TSiZ8bkvI748VSc1
        HEgoHDI++gFWX2nXWJLEdPleBzeMQGtNjulEKCR9thnhhLwPfbAGAp1FR+XWAFAulsyI=;
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiazN-00046h-IM; Tue, 19 Sep 2023 13:42:05 +0000
Received: from ec2-63-33-11-17.eu-west-1.compute.amazonaws.com ([63.33.11.17] helo=REM-PW02S00X.ant.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <paul@xen.org>)
        id 1qiazN-0005jy-Ab; Tue, 19 Sep 2023 13:42:05 +0000
From:   Paul Durrant <paul@xen.org>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v4 07/13] KVM: xen: prepare for using 'default' vcpu_info
Date:   Tue, 19 Sep 2023 13:41:43 +0000
Message-Id: <20230919134149.6091-8-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230919134149.6091-1-paul@xen.org>
References: <20230919134149.6091-1-paul@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>

The shared_info page contains an array of 32 vcpu_info structures
which may be used by guests (with fewer than 32 vCPUs) if they don't
explicitly register vcpu_info structures in their own memory, using
a VCPUOP_register_vcpu_info hypercall.
Currently we rely on the VMM always registering vcpu_info structures,
even if the guest doesn't make that hypercall, which is somewhat
bogus as (as has been stated in the comment of a previous commit)
the shared_info page is not guest memory.
Prepare to automatically use the vcpu_info info embedded in shared_info
by default, by adding a get_vcpu_info_cache() helper function. This
function also passes back an offset to be added to the cached khva.
This is currently always zero since we're still relying on the
current VMM behaviour. A subsequent patch will make proper use of
it.

No functional change intended.

NOTE: To avoid leaking detail of the vcpu_info duality into the main
      x86 code, a kvm_xen_guest_time_update() has also been added
      and use of this requires that kvm_setup_guest_pvclock() ceases
      to be a static function.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
---
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org

v4:
 - Added missing offset into calls to kvm_gpc_check() and
   kvm_gpc_refresh().

v2:
 - Fix build warning.
---
 arch/x86/include/asm/kvm_host.h |  4 +++
 arch/x86/kvm/x86.c              | 12 +++----
 arch/x86/kvm/xen.c              | 60 ++++++++++++++++++++++++---------
 arch/x86/kvm/xen.h              |  6 +++-
 4 files changed, 58 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a4def36d5bb..6d896f9161c2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2238,4 +2238,8 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
  */
 #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
 
+void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
+			     struct gfn_to_pfn_cache *gpc,
+			     unsigned int offset);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d669a8801265..2d7d0ae18820 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3094,9 +3094,9 @@ u64 get_kvmclock_ns(struct kvm *kvm)
 	return data.clock;
 }
 
-static void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
-				    struct gfn_to_pfn_cache *gpc,
-				    unsigned int offset)
+void kvm_setup_guest_pvclock(struct kvm_vcpu *v,
+			     struct gfn_to_pfn_cache *gpc,
+			     unsigned int offset)
 {
 	struct kvm_vcpu_arch *vcpu = &v->arch;
 	struct pvclock_vcpu_time_info *guest_hv_clock;
@@ -3232,11 +3232,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 
 	if (vcpu->pv_time.active)
 		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
-	if (vcpu->xen.vcpu_info_cache.active)
-		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_info_cache,
-					offsetof(struct compat_vcpu_info, time));
-	if (vcpu->xen.vcpu_time_info_cache.active)
-		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
+	kvm_xen_guest_time_update(v);
 	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
 	return 0;
 }
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 1abb4547642a..9449cfe1048f 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -489,6 +489,29 @@ static void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
 	WARN_ON_ONCE(!kvm_irq_delivery_to_apic_fast(v->kvm, NULL, &irq, &r, NULL));
 }
 
+static struct gfn_to_pfn_cache *get_vcpu_info_cache(struct kvm_vcpu *v, unsigned long *offset)
+{
+	if (offset)
+		*offset = 0;
+
+	return &v->arch.xen.vcpu_info_cache;
+}
+
+void kvm_xen_guest_time_update(struct kvm_vcpu *v)
+{
+	unsigned long offset;
+	struct gfn_to_pfn_cache *gpc = get_vcpu_info_cache(v, &offset);
+
+	BUILD_BUG_ON(offsetof(struct vcpu_info, time) !=
+		     offsetof(struct compat_vcpu_info, time));
+
+	if (gpc->active)
+		kvm_setup_guest_pvclock(v, gpc, offset + offsetof(struct compat_vcpu_info, time));
+
+	if (v->arch.xen.vcpu_time_info_cache.active)
+		kvm_setup_guest_pvclock(v, &v->arch.xen.vcpu_time_info_cache, 0);
+}
+
 /*
  * On event channel delivery, the vcpu_info may not have been accessible.
  * In that case, there are bits in vcpu->arch.xen.evtchn_pending_sel which
@@ -499,7 +522,8 @@ static void kvm_xen_inject_vcpu_vector(struct kvm_vcpu *v)
 void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 {
 	unsigned long evtchn_pending_sel = READ_ONCE(v->arch.xen.evtchn_pending_sel);
-	struct gfn_to_pfn_cache *gpc = &v->arch.xen.vcpu_info_cache;
+	unsigned long offset;
+	struct gfn_to_pfn_cache *gpc = get_vcpu_info_cache(v, &offset);
 	unsigned long flags;
 
 	if (!evtchn_pending_sel)
@@ -511,10 +535,10 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	 * little more honest about it.
 	 */
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
+	while (!kvm_gpc_check(gpc, offset + sizeof(struct vcpu_info))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
-		if (kvm_gpc_refresh(gpc, sizeof(struct vcpu_info)))
+		if (kvm_gpc_refresh(gpc, offset + sizeof(struct vcpu_info)))
 			return;
 
 		read_lock_irqsave(&gpc->lock, flags);
@@ -522,7 +546,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 
 	/* Now gpc->khva is a valid kernel address for the vcpu_info */
 	if (IS_ENABLED(CONFIG_64BIT) && v->kvm->arch.xen.long_mode) {
-		struct vcpu_info *vi = gpc->khva;
+		struct vcpu_info *vi = gpc->khva + offset;
 
 		asm volatile(LOCK_PREFIX "orq %0, %1\n"
 			     "notq %0\n"
@@ -534,7 +558,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 		WRITE_ONCE(vi->evtchn_upcall_pending, 1);
 	} else {
 		u32 evtchn_pending_sel32 = evtchn_pending_sel;
-		struct compat_vcpu_info *vi = gpc->khva;
+		struct compat_vcpu_info *vi = gpc->khva + offset;
 
 		asm volatile(LOCK_PREFIX "orl %0, %1\n"
 			     "notl %0\n"
@@ -556,7 +580,8 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 {
-	struct gfn_to_pfn_cache *gpc = &v->arch.xen.vcpu_info_cache;
+	unsigned long offset;
+	struct gfn_to_pfn_cache *gpc = get_vcpu_info_cache(v, &offset);
 	unsigned long flags;
 	u8 rc = 0;
 
@@ -574,7 +599,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
 	read_lock_irqsave(&gpc->lock, flags);
-	while (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
+	while (!kvm_gpc_check(gpc, offset + sizeof(struct vcpu_info))) {
 		read_unlock_irqrestore(&gpc->lock, flags);
 
 		/*
@@ -588,7 +613,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		if (in_atomic() || !task_is_running(current))
 			return 1;
 
-		if (kvm_gpc_refresh(gpc, sizeof(struct vcpu_info))) {
+		if (kvm_gpc_refresh(gpc, offset + sizeof(struct vcpu_info))) {
 			/*
 			 * If this failed, userspace has screwed up the
 			 * vcpu_info mapping. No interrupts for you.
@@ -598,7 +623,7 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 		read_lock_irqsave(&gpc->lock, flags);
 	}
 
-	rc = ((struct vcpu_info *)gpc->khva)->evtchn_upcall_pending;
+	rc = ((struct vcpu_info *)(gpc->khva + offset))->evtchn_upcall_pending;
 	read_unlock_irqrestore(&gpc->lock, flags);
 	return rc;
 }
@@ -1567,7 +1592,7 @@ static void kvm_xen_check_poller(struct kvm_vcpu *vcpu, int port)
  */
 int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 {
-	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
+	struct gfn_to_pfn_cache *gpc;
 	struct kvm_vcpu *vcpu;
 	unsigned long *pending_bits, *mask_bits;
 	unsigned long flags;
@@ -1585,7 +1610,8 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		WRITE_ONCE(xe->vcpu_idx, vcpu->vcpu_idx);
 	}
 
-	if (!vcpu->arch.xen.vcpu_info_cache.active)
+	gpc = get_vcpu_info_cache(vcpu, NULL);
+	if (!gpc->active)
 		return -EINVAL;
 
 	if (xe->port >= max_evtchn_port(kvm))
@@ -1594,6 +1620,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	rc = -EWOULDBLOCK;
 
 	idx = srcu_read_lock(&kvm->srcu);
+	gpc = &kvm->arch.xen.shinfo_cache;
 
 	read_lock_irqsave(&gpc->lock, flags);
 	if (!kvm_gpc_check(gpc, PAGE_SIZE))
@@ -1624,13 +1651,16 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		rc = -ENOTCONN; /* Masked */
 		kvm_xen_check_poller(vcpu, xe->port);
 	} else {
+		unsigned long offset;
+
 		rc = 1; /* Delivered to the bitmap in shared_info. */
+
 		/* Now switch to the vCPU's vcpu_info to set the index and pending_sel */
 		read_unlock_irqrestore(&gpc->lock, flags);
-		gpc = &vcpu->arch.xen.vcpu_info_cache;
+		gpc = get_vcpu_info_cache(vcpu, &offset);
 
 		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
+		if (!kvm_gpc_check(gpc, offset + sizeof(struct vcpu_info))) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
 			 * and prod the vCPU to deliver it for itself.
@@ -1641,13 +1671,13 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 		}
 
 		if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
-			struct vcpu_info *vcpu_info = gpc->khva;
+			struct vcpu_info *vcpu_info = gpc->khva + offset;
 			if (!test_and_set_bit(port_word_bit, &vcpu_info->evtchn_pending_sel)) {
 				WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
 				kick_vcpu = true;
 			}
 		} else {
-			struct compat_vcpu_info *vcpu_info = gpc->khva;
+			struct compat_vcpu_info *vcpu_info = gpc->khva + offset;
 			if (!test_and_set_bit(port_word_bit,
 					      (unsigned long *)&vcpu_info->evtchn_pending_sel)) {
 				WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index f8f1fe22d090..c4d29ccbc3ab 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -16,6 +16,7 @@
 
 extern struct static_key_false_deferred kvm_xen_enabled;
 
+void kvm_xen_guest_time_update(struct kvm_vcpu *vcpu);
 int __kvm_xen_has_interrupt(struct kvm_vcpu *vcpu);
 void kvm_xen_inject_pending_events(struct kvm_vcpu *vcpu);
 int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data);
@@ -52,7 +53,6 @@ static inline bool kvm_xen_hypercall_enabled(struct kvm *kvm)
 static inline int kvm_xen_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	if (static_branch_unlikely(&kvm_xen_enabled.key) &&
-	    vcpu->arch.xen.vcpu_info_cache.active &&
 	    vcpu->kvm->arch.xen.upcall_vector)
 		return __kvm_xen_has_interrupt(vcpu);
 
@@ -80,6 +80,10 @@ static inline int kvm_xen_has_pending_timer(struct kvm_vcpu *vcpu)
 
 void kvm_xen_inject_timer_irqs(struct kvm_vcpu *vcpu);
 #else
+static inline void kvm_xen_guest_time_update(struct kvm_vcpu *vcpu)
+{
+}
+
 static inline int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
 {
 	return 1;
-- 
2.39.2

