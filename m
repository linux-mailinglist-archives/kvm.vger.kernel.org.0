Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B25624057
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 11:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiKJKu5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 05:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbiKJKus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 05:50:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C6B2AC5C
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 02:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668077384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zHFWHrDPitAZ2CFICQlKxokmuu7CotBRVEubYjCqj1c=;
        b=bwyAVWdwtC2V8HAIWyJPkttr9LOET/NfYJp1ldkCjyDl0Z2Eg5wAvaKaCnJrRsRbr3axJI
        hPcZ9T78Z/WqDtX9FCdssSC8G8oOUDGLGejGdyaHX1skrt2tZFu6yzCporClsk+0QgtKyA
        61K5I7K9pVEfl9tFAwtR+pYrPMpH1ec=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-ledIJDHuNkeyPyZBm_WESA-1; Thu, 10 Nov 2022 05:49:41 -0500
X-MC-Unique: ledIJDHuNkeyPyZBm_WESA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC9983C0F229;
        Thu, 10 Nov 2022 10:49:40 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-49.bne.redhat.com [10.64.54.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7374F141511F;
        Thu, 10 Nov 2022 10:49:34 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        seanjc@google.com, shuah@kernel.org, catalin.marinas@arm.com,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, dmatlack@google.com, will@kernel.org,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v10 1/7] KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
Date:   Thu, 10 Nov 2022 18:49:08 +0800
Message-Id: <20221110104914.31280-2-gshan@redhat.com>
In-Reply-To: <20221110104914.31280-1-gshan@redhat.com>
References: <20221110104914.31280-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VCPU isn't expected to be runnable when the dirty ring becomes soft
full, until the dirty pages are harvested and the dirty ring is reset
from userspace. So there is a check in each guest's entrace to see if
the dirty ring is soft full or not. The VCPU is stopped from running if
its dirty ring has been soft full. The similar check will be needed when
the feature is going to be supported on ARM64. As Marc Zyngier suggested,
a new event will avoid pointless overhead to check the size of the dirty
ring ('vcpu->kvm->dirty_ring_size') in each guest's entrance.

Add KVM_REQ_DIRTY_RING_SOFT_FULL. The event is raised when the dirty ring
becomes soft full in kvm_dirty_ring_push(). The event is only cleared in
the check, done in the newly added helper kvm_dirty_ring_check_request().
Since the VCPU is not runnable when the dirty ring becomes soft full, the
KVM_REQ_DIRTY_RING_SOFT_FULL event is always set to prevent the VCPU from
running until the dirty pages are harvested and the dirty ring is reset by
userspace.

kvm_dirty_ring_soft_full() becomes a private function with the newly added
helper kvm_dirty_ring_check_request(). The alignment for the various event
definitions in kvm_host.h is changed to tab character by the way. In order
to avoid using 'container_of()', the argument @ring is replaced by @vcpu
in kvm_dirty_ring_push().

Link: https://lore.kernel.org/kvmarm/87lerkwtm5.wl-maz@kernel.org
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c             | 15 ++++++---------
 include/linux/kvm_dirty_ring.h | 12 ++++--------
 include/linux/kvm_host.h       |  9 +++++----
 virt/kvm/dirty_ring.c          | 32 ++++++++++++++++++++++++++++++--
 virt/kvm/kvm_main.c            |  3 +--
 5 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f5eb577d583..a228a1b872bb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10515,20 +10515,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	bool req_immediate_exit = false;
 
-	/* Forbid vmenter if vcpu dirty ring is soft-full */
-	if (unlikely(vcpu->kvm->dirty_ring_size &&
-		     kvm_dirty_ring_soft_full(&vcpu->dirty_ring))) {
-		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
-		trace_kvm_dirty_ring_exit(vcpu);
-		r = 0;
-		goto out;
-	}
-
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
 			r = -EIO;
 			goto out;
 		}
+
+		if (kvm_dirty_ring_check_request(vcpu)) {
+			r = 0;
+			goto out;
+		}
+
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
 				r = 0;
diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 906f899813dc..9c13c4c3d30c 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -49,7 +49,7 @@ static inline int kvm_dirty_ring_reset(struct kvm *kvm,
 	return 0;
 }
 
-static inline void kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
+static inline void kvm_dirty_ring_push(struct kvm_vcpu *vcpu,
 				       u32 slot, u64 offset)
 {
 }
@@ -64,11 +64,6 @@ static inline void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
 {
 }
 
-static inline bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
-{
-	return true;
-}
-
 #else /* CONFIG_HAVE_KVM_DIRTY_RING */
 
 u32 kvm_dirty_ring_get_rsvd_entries(void);
@@ -84,13 +79,14 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring);
  * returns =0: successfully pushed
  *         <0: unable to push, need to wait
  */
-void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset);
+void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset);
+
+bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu);
 
 /* for use in vm_operations_struct */
 struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset);
 
 void kvm_dirty_ring_free(struct kvm_dirty_ring *ring);
-bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring);
 
 #endif /* CONFIG_HAVE_KVM_DIRTY_RING */
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 18592bdf4c1b..6fab55e58111 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -153,10 +153,11 @@ static inline bool is_error_page(struct page *page)
  * Architecture-independent vcpu->requests bit members
  * Bits 3-7 are reserved for more arch-independent bits.
  */
-#define KVM_REQ_TLB_FLUSH         (0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_VM_DEAD           (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_UNBLOCK           2
-#define KVM_REQUEST_ARCH_BASE     8
+#define KVM_REQ_TLB_FLUSH		(0 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_UNBLOCK			2
+#define KVM_REQ_DIRTY_RING_SOFT_FULL	3
+#define KVM_REQUEST_ARCH_BASE		8
 
 /*
  * KVM_REQ_OUTSIDE_GUEST_MODE exists is purely as way to force the vCPU to
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index d6fabf238032..fecbb7d75ad2 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -26,7 +26,7 @@ static u32 kvm_dirty_ring_used(struct kvm_dirty_ring *ring)
 	return READ_ONCE(ring->dirty_index) - READ_ONCE(ring->reset_index);
 }
 
-bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
+static bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
 {
 	return kvm_dirty_ring_used(ring) >= ring->soft_limit;
 }
@@ -142,13 +142,19 @@ int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
 
 	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
 
+	/*
+	 * The request KVM_REQ_DIRTY_RING_SOFT_FULL will be cleared
+	 * by the VCPU thread next time when it enters the guest.
+	 */
+
 	trace_kvm_dirty_ring_reset(ring);
 
 	return count;
 }
 
-void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
+void kvm_dirty_ring_push(struct kvm_vcpu *vcpu, u32 slot, u64 offset)
 {
+	struct kvm_dirty_ring *ring = &vcpu->dirty_ring;
 	struct kvm_dirty_gfn *entry;
 
 	/* It should never get full */
@@ -166,6 +172,28 @@ void kvm_dirty_ring_push(struct kvm_dirty_ring *ring, u32 slot, u64 offset)
 	kvm_dirty_gfn_set_dirtied(entry);
 	ring->dirty_index++;
 	trace_kvm_dirty_ring_push(ring, slot, offset);
+
+	if (kvm_dirty_ring_soft_full(ring))
+		kvm_make_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
+}
+
+bool kvm_dirty_ring_check_request(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * The VCPU isn't runnable when the dirty ring becomes soft full.
+	 * The KVM_REQ_DIRTY_RING_SOFT_FULL event is always set to prevent
+	 * the VCPU from running until the dirty pages are harvested and
+	 * the dirty ring is reset by userspace.
+	 */
+	if (kvm_check_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu) &&
+	    kvm_dirty_ring_soft_full(&vcpu->dirty_ring)) {
+		kvm_make_request(KVM_REQ_DIRTY_RING_SOFT_FULL, vcpu);
+		vcpu->run->exit_reason = KVM_EXIT_DIRTY_RING_FULL;
+		trace_kvm_dirty_ring_exit(vcpu);
+		return true;
+	}
+
+	return false;
 }
 
 struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 offset)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 25d7872b29c1..c865d7d82685 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3314,8 +3314,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
 		if (kvm->dirty_ring_size)
-			kvm_dirty_ring_push(&vcpu->dirty_ring,
-					    slot, rel_gfn);
+			kvm_dirty_ring_push(vcpu, slot, rel_gfn);
 		else
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
-- 
2.23.0

