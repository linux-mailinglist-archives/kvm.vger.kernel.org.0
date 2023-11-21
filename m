Return-Path: <kvm+bounces-2220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 666C67F35F7
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 19:30:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F20A282FF7
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 18:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBE851030;
	Tue, 21 Nov 2023 18:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen.org header.i=@xen.org header.b="sg8jJO/7"
X-Original-To: kvm@vger.kernel.org
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C1D191;
	Tue, 21 Nov 2023 10:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
	s=20200302mail; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-Id:Date:Subject:To:From;
	bh=OQwHECWoxaFZf+yMkkeBPS72E7Shexvq/XcENS5y4Lk=; b=sg8jJO/7AKBvFQzK3svFGTdkdH
	y1FlSZYwL7oRrvh0+7E1n9c7HPKf2MFC1XBAEozaUGG+pnirJ4BrNP7qJEF2joC3OKLsP/ptroa6D
	RJgjLpmSjEp6B6ecTK04j01sh+328hD2WqBrloXQzRmKPX1q+ZdzstGb1+nOGcDYpM6s=;
Received: from xenbits.xenproject.org ([104.239.192.120])
	by mail.xenproject.org with esmtp (Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5VVq-0000Bo-Ad; Tue, 21 Nov 2023 18:30:18 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=REM-PW02S00X.ant.amazon.com)
	by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <paul@xen.org>)
	id 1r5V5s-0004Z3-Hd; Tue, 21 Nov 2023 18:03:28 +0000
From: Paul Durrant <paul@xen.org>
To: David Woodhouse <dwmw2@infradead.org>,
	Paul Durrant <paul@xen.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 14/15] KVM: xen: split up kvm_xen_set_evtchn_fast()
Date: Tue, 21 Nov 2023 18:02:22 +0000
Message-Id: <20231121180223.12484-15-paul@xen.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231121180223.12484-1-paul@xen.org>
References: <20231121180223.12484-1-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paul Durrant <pdurrant@amazon.com>

The implementation of kvm_xen_set_evtchn_fast() is a rather lengthy piece
of code that performs two operations: updating of the shared_info
evtchn_pending mask, and updating of the vcpu_info evtchn_pending_sel
mask. Introdude a separate function to perform each of those operations and
re-work kvm_xen_set_evtchn_fast() to use them.

No functional change intended.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org

v8:
 - New in this version.
---
 arch/x86/kvm/xen.c | 170 +++++++++++++++++++++++++--------------------
 1 file changed, 96 insertions(+), 74 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 42a9f1ea25b3..eff405eead1c 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1623,60 +1623,28 @@ static void kvm_xen_check_poller(struct kvm_vcpu *vcpu, int port)
 	}
 }
 
-/*
- * The return value from this function is propagated to kvm_set_irq() API,
- * so it returns:
- *  < 0   Interrupt was ignored (masked or not delivered for other reasons)
- *  = 0   Interrupt was coalesced (previous irq is still pending)
- *  > 0   Number of CPUs interrupt was delivered to
- *
- * It is also called directly from kvm_arch_set_irq_inatomic(), where the
- * only check on its return value is a comparison with -EWOULDBLOCK'.
- */
-int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
+static int set_shinfo_evtchn_pending(struct kvm_vcpu *vcpu, u32 port, u32 *port_word_bit)
 {
+	struct kvm *kvm = vcpu->kvm;
 	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
-	struct kvm_vcpu *vcpu;
 	unsigned long *pending_bits, *mask_bits;
 	unsigned long flags;
-	int port_word_bit;
-	bool kick_vcpu = false;
-	int vcpu_idx, idx, rc;
-
-	vcpu_idx = READ_ONCE(xe->vcpu_idx);
-	if (vcpu_idx >= 0)
-		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
-	else {
-		vcpu = kvm_get_vcpu_by_id(kvm, xe->vcpu_id);
-		if (!vcpu)
-			return -EINVAL;
-		WRITE_ONCE(xe->vcpu_idx, vcpu->vcpu_idx);
-	}
-
-	if (!vcpu->arch.xen.vcpu_info_cache.active)
-		return -EINVAL;
-
-	if (xe->port >= max_evtchn_port(kvm))
-		return -EINVAL;
-
-	rc = -EWOULDBLOCK;
-
-	idx = srcu_read_lock(&kvm->srcu);
+	int rc = -EWOULDBLOCK;
 
 	read_lock_irqsave(&gpc->lock, flags);
 	if (!kvm_gpc_check(gpc, PAGE_SIZE))
-		goto out_rcu;
+		goto out;
 
 	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
 		struct shared_info *shinfo = gpc->khva;
 		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
 		mask_bits = (unsigned long *)&shinfo->evtchn_mask;
-		port_word_bit = xe->port / 64;
+		*port_word_bit = port / 64;
 	} else {
 		struct compat_shared_info *shinfo = gpc->khva;
 		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
 		mask_bits = (unsigned long *)&shinfo->evtchn_mask;
-		port_word_bit = xe->port / 32;
+		*port_word_bit = port / 32;
 	}
 
 	/*
@@ -1686,52 +1654,106 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	 * already set, then we kick the vCPU in question to write to the
 	 * *real* evtchn_pending_sel in its own guest vcpu_info struct.
 	 */
-	if (test_and_set_bit(xe->port, pending_bits)) {
+	if (test_and_set_bit(port, pending_bits)) {
 		rc = 0; /* It was already raised */
-	} else if (test_bit(xe->port, mask_bits)) {
-		rc = -ENOTCONN; /* Masked */
-		kvm_xen_check_poller(vcpu, xe->port);
+	} else if (test_bit(port, mask_bits)) {
+		rc = -ENOTCONN; /* It is masked */
+		kvm_xen_check_poller(vcpu, port);
 	} else {
-		rc = 1; /* Delivered to the bitmap in shared_info. */
-		/* Now switch to the vCPU's vcpu_info to set the index and pending_sel */
-		read_unlock_irqrestore(&gpc->lock, flags);
-		gpc = &vcpu->arch.xen.vcpu_info_cache;
+		rc = 1; /* It is newly raised */
+	}
 
-		read_lock_irqsave(&gpc->lock, flags);
-		if (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
-			/*
-			 * Could not access the vcpu_info. Set the bit in-kernel
-			 * and prod the vCPU to deliver it for itself.
-			 */
-			if (!test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel))
-				kick_vcpu = true;
-			goto out_rcu;
-		}
+ out:
+	read_unlock_irqrestore(&gpc->lock, flags);
+	return rc;
+}
 
-		if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
-			struct vcpu_info *vcpu_info = gpc->khva;
-			if (!test_and_set_bit(port_word_bit, &vcpu_info->evtchn_pending_sel)) {
-				WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
-				kick_vcpu = true;
-			}
-		} else {
-			struct compat_vcpu_info *vcpu_info = gpc->khva;
-			if (!test_and_set_bit(port_word_bit,
-					      (unsigned long *)&vcpu_info->evtchn_pending_sel)) {
-				WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
-				kick_vcpu = true;
-			}
+static bool set_vcpu_info_evtchn_pending(struct kvm_vcpu *vcpu, u32 port_word_bit)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct gfn_to_pfn_cache *gpc = &vcpu->arch.xen.vcpu_info_cache;
+	unsigned long flags;
+	bool kick_vcpu = false;
+
+	read_lock_irqsave(&gpc->lock, flags);
+	if (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
+		/*
+		 * Could not access the vcpu_info. Set the bit in-kernel
+		 * and prod the vCPU to deliver it for itself.
+		 */
+		if (!test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel))
+			kick_vcpu = true;
+		goto out;
+	}
+
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
+		struct vcpu_info *vcpu_info = gpc->khva;
+
+		if (!test_and_set_bit(port_word_bit, &vcpu_info->evtchn_pending_sel)) {
+			WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
+			kick_vcpu = true;
 		}
+	} else {
+		struct compat_vcpu_info *vcpu_info = gpc->khva;
 
-		/* For the per-vCPU lapic vector, deliver it as MSI. */
-		if (kick_vcpu && vcpu->arch.xen.upcall_vector) {
-			kvm_xen_inject_vcpu_vector(vcpu);
-			kick_vcpu = false;
+		if (!test_and_set_bit(port_word_bit,
+				      (unsigned long *)&vcpu_info->evtchn_pending_sel)) {
+			WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
+			kick_vcpu = true;
 		}
 	}
 
- out_rcu:
+	/* For the per-vCPU lapic vector, deliver it as MSI. */
+	if (kick_vcpu && vcpu->arch.xen.upcall_vector) {
+		kvm_xen_inject_vcpu_vector(vcpu);
+		kick_vcpu = false;
+	}
+
+ out:
 	read_unlock_irqrestore(&gpc->lock, flags);
+	return kick_vcpu;
+}
+
+/*
+ * The return value from this function is propagated to kvm_set_irq() API,
+ * so it returns:
+ *  < 0   Interrupt was ignored (masked or not delivered for other reasons)
+ *  = 0   Interrupt was coalesced (previous irq is still pending)
+ *  > 0   Number of CPUs interrupt was delivered to
+ *
+ * It is also called directly from kvm_arch_set_irq_inatomic(), where the
+ * only check on its return value is a comparison with -EWOULDBLOCK
+ * (which may be returned by set_shinfo_evtchn_pending()).
+ */
+int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	u32 port_word_bit;
+	bool kick_vcpu = false;
+	int vcpu_idx, idx, rc;
+
+	vcpu_idx = READ_ONCE(xe->vcpu_idx);
+	if (vcpu_idx >= 0)
+		vcpu = kvm_get_vcpu(kvm, vcpu_idx);
+	else {
+		vcpu = kvm_get_vcpu_by_id(kvm, xe->vcpu_id);
+		if (!vcpu)
+			return -EINVAL;
+		WRITE_ONCE(xe->vcpu_idx, vcpu->vcpu_idx);
+	}
+
+	if (!vcpu->arch.xen.vcpu_info_cache.active)
+		return -EINVAL;
+
+	if (xe->port >= max_evtchn_port(kvm))
+		return -EINVAL;
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	rc = set_shinfo_evtchn_pending(vcpu, xe->port, &port_word_bit);
+	if (rc == 1) /* Delivered to the bitmap in shared_info. */
+		kick_vcpu = set_vcpu_info_evtchn_pending(vcpu, port_word_bit);
+
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	if (kick_vcpu) {
-- 
2.39.2


