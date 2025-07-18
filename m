Return-Path: <kvm+bounces-52863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1E98B09BB1
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 08:50:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69ACAA651D0
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 06:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2DEC211A35;
	Fri, 18 Jul 2025 06:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q9ugq7bi"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149394689;
	Fri, 18 Jul 2025 06:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752821410; cv=none; b=HUZZvtBwW+f996y76nDdtXKXkMfGgFtjEi5IHQVVIvlK2F7VtAKKkL9JOid1MG5wnl20sZyckJFUO4sTruLmqxiTUh0bnvMQuBUryZk3ev+lS14AjwWrKcjnUOZYmKRSMCZfP+IN1OrYBmrsUZOdQOZEIQ+hOOUoiPBirlxrjpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752821410; c=relaxed/simple;
	bh=XrFBk8x+OWa3nl89tWLrZkApIwuYMYk2RcQ5/FWpPdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJvufDS7T6V6+w50u5lYJGsOJ6Sg/0kXeAr2LgLsqIbrzf40DB/MwcdbYTw51WD1WIHaSK41+PdKpAc1YBbFJ/s3d0RODLzJSSsYls1kgId9Br/+Lx3rM9OCpsInLF+Vtl8Trf5/kqjhQjmOgHYhhs3PU4l5Il2MXVnuo1ZUqRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q9ugq7bi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28987C4CEED;
	Fri, 18 Jul 2025 06:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752821409;
	bh=XrFBk8x+OWa3nl89tWLrZkApIwuYMYk2RcQ5/FWpPdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9ugq7bijBxQOK9l6vImmigEf+SS722OXKzO/GF77b796++AN7FszwrWYGOqrz2+0
	 VX+zOxVMv/ucIFZSrfgLT0Pu5A1VU1pu4jfPkbszu7tqBdHeGtZc4iVUMELP6IQT8M
	 iBOD1sTFsXLGX3PtE4shJNqwdioIE0KBAneUIL/n9XFZ/3haVLJbq6/yTnMwHVOuo/
	 uuYUckhRQFJ+I4Yuhm12lllxEobymJvlsJDlIg6ROtmwJm7fEP33IANEP+k4YsxhxE
	 FDtgUfTYrgEs+aldY3t0t+C4gXEjWOOR1Z9gBg5s5rTzMsYsclDgCLE9fgn8uHiDd1
	 b2nFvaW7yYvwg==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 2/3] KVM: SVM: Fix IRQ window inhibit handling across multiple vCPUs
Date: Fri, 18 Jul 2025 12:13:35 +0530
Message-ID: <26732815475bf1c5ba672bc3b1785265f1a994e6.1752819570.git.naveen@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1752819570.git.naveen@kernel.org>
References: <cover.1752819570.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IRQ window inhibits can be requested by multiple vCPUs at the same time
for injecting interrupts meant for different vCPUs. However, AVIC
inhibition is VM-wide and hence it is possible for the inhibition to be
cleared prematurely by the first vCPU that obtains the IRQ window even
though a second vCPU is still waiting for its IRQ window. This is likely
not a functional issue since the other vCPU will again see that
interrupts are pending to be injected (due to KVM_REQ_EVENT), and will
again request for an IRQ window inhibition. However, this can result in
AVIC being rapidly toggled resulting in high contention on
apicv_update_lock and degrading performance of the guest.

Address this by maintaining a VM-wide count of the number of vCPUs that
have requested for an IRQ window. Set/clear the inhibit reason when the
count transitions between 0 and 1. This ensures that the inhibit reason
is not cleared as long as there are some vCPUs still waiting for an IRQ
window.

---
 arch/x86/include/asm/kvm_host.h | 16 +++++++++++++++
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/svm/svm.c          | 36 +++++++++++++++++++++++----------
 arch/x86/kvm/x86.c              | 19 +++++++++++++++++
 4 files changed, 61 insertions(+), 11 deletions(-)

I think patch tags for this should be:
	From: Sean Christopherson <seanjc@google.com>

	Signed-off-by: Sean Christopherson <seanjc@google.com>
	Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
	Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
	Co-developed-by: Naveen N Rao (AMD) <naveen@kernel.org>
	Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>

- Naveen

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..b781b4f1d304 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1395,6 +1395,10 @@ struct kvm_arch {
 	struct kvm_pit *vpit;
 #endif
 	atomic_t vapics_in_nmi_mode;
+
+	/* Keep this in a cacheline separate from apicv_update_lock */
+	atomic_t apicv_nr_irq_window_req;
+
 	struct mutex apic_map_lock;
 	struct kvm_apic_map __rcu *apic_map;
 	atomic_t apic_map_dirty;
@@ -2263,6 +2267,18 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
 	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
 }
 
+void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc);
+
+static inline void kvm_inc_apicv_irq_window_req(struct kvm *kvm)
+{
+	kvm_inc_or_dec_irq_window_inhibit(kvm, true);
+}
+
+static inline void kvm_dec_apicv_irq_window_req(struct kvm *kvm)
+{
+	kvm_inc_or_dec_irq_window_inhibit(kvm, false);
+}
+
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_print_sptes(struct kvm_vcpu *vcpu, gpa_t gpa, const char *msg);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 58b9d168e0c8..9ef6b5494e77 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -331,6 +331,7 @@ struct vcpu_svm {
 
 	bool guest_state_loaded;
 
+	bool avic_irq_window;
 	bool x2avic_msrs_intercepted;
 
 	/* Guest GIF value, used when vGIF is not enabled */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bbe439c0e36a..0211b713174c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3681,8 +3681,11 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 	 * the case in which the interrupt window was requested while L1 was
 	 * active (the vCPU was not running nested).
 	 */
-	if (!kvm_cpu_has_injectable_intr(vcpu) || is_guest_mode(vcpu))
-		kvm_clear_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
+	if (svm->avic_irq_window &&
+	    (!kvm_cpu_has_injectable_intr(vcpu) || is_guest_mode(vcpu))) {
+		svm->avic_irq_window = false;
+		kvm_dec_apicv_irq_window_req(svm->vcpu.kvm);
+	}
 
 	if (vcpu->arch.interrupt.soft) {
 		if (svm_update_soft_interrupt_rip(vcpu))
@@ -3895,17 +3898,28 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
 	 */
 	if (vgif || gif_set(svm)) {
 		/*
-		 * IRQ window is not needed when AVIC is enabled,
-		 * unless we have pending ExtINT since it cannot be injected
-		 * via AVIC. In such case, KVM needs to temporarily disable AVIC,
-		 * and fallback to injecting IRQ via V_IRQ.
+		 * KVM only enables IRQ windows when AVIC is enabled if there's
+		 * pending ExtINT since it cannot be injected via AVIC (ExtINT
+		 * bypasses the local APIC).  V_IRQ is ignored by hardware when
+		 * AVIC is enabled, and so KVM needs to temporarily disable
+		 * AVIC in order to detect when it's ok to inject the ExtINT.
 		 *
-		 * If running nested, AVIC is already locally inhibited
-		 * on this vCPU, therefore there is no need to request
-		 * the VM wide AVIC inhibition.
+		 * If running nested, AVIC is already locally inhibited on this
+		 * vCPU (L2 vCPUs use a different MMU that never maps the AVIC
+		 * backing page), therefore there is no need to increment the
+		 * VM-wide AVIC inhibit.  KVM will re-evaluate events when the
+		 * vCPU exits to L1 and enable an IRQ window if the ExtINT is
+		 * still pending.
+		 *
+		 * Note, the IRQ window inhibit needs to be updated even if
+		 * AVIC is inhibited for a different reason, as KVM needs to
+		 * keep AVIC inhibited if the other reason is cleared and there
+		 * is still an injectable interrupt pending.
 		 */
-		if (!is_guest_mode(vcpu))
-			kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_IRQWIN);
+		if (enable_apicv && !svm->avic_irq_window && !is_guest_mode(vcpu)) {
+			svm->avic_irq_window = true;
+			kvm_inc_apicv_irq_window_req(vcpu->kvm);
+		}
 
 		svm_set_vintr(svm);
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..216d1801a4f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10575,6 +10575,25 @@ void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_set_or_clear_apicv_inhibit);
 
+void kvm_inc_or_dec_irq_window_inhibit(struct kvm *kvm, bool inc)
+{
+	int add = inc ? 1 : -1;
+
+	if (!enable_apicv)
+		return;
+
+	/*
+	 * Strictly speaking, the lock is only needed if going 0->1 or 1->0,
+	 * a la atomic_dec_and_mutex_lock.  However, ExtINTs are rare and
+	 * only target a single CPU, so that is the common case; do not
+	 * bother eliding the down_write()/up_write() pair.
+	 */
+	guard(rwsem_write)(&kvm->arch.apicv_update_lock);
+	if (atomic_add_return(add, &kvm->arch.apicv_nr_irq_window_req) == inc)
+		__kvm_set_or_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_IRQWIN, inc);
+}
+EXPORT_SYMBOL_GPL(kvm_inc_or_dec_irq_window_inhibit);
+
 static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_apic_present(vcpu))
-- 
2.50.1


