Return-Path: <kvm+bounces-10083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13FDD869048
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 13:22:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA649286901
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 12:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C62B14601A;
	Tue, 27 Feb 2024 12:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="seMRokYK"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8654146009
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 12:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709036366; cv=none; b=QNm7nx9TqU4UrojM11Bf+HRPNjNfzDt18JK8G3yIm2YHHQdc5ZkfoYic9kaOFZKHjo57d0od0UDMZaJ1c/v8bynv9AVcAIFkYjt1kUkjyPmYUzSGTgcD/3OYJ7HxO+xMdrS0+QIJMKCKhMS7k0DbzzcbqDUQzH6rvYvEZcRyqOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709036366; c=relaxed/simple;
	bh=d8vgNyQwZfsDXdkfeL5PhgxhbR732Ns+eP3wEDj36ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ivn5WBWT31kwKztDcf6NaARZK8LVytDMRVa8TpDskdOhBQG3BKG1z8+2qxjc4kc6zwi3LJQyi9RCfoCdjNBCpFMHSxwlV1VZFaBTfqFXifh0o63jj4Vj7jyAztcxqWFzBqntWJO96JqeQFVnwdu0sSrD6VzF6+9ClUo9em7N1JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=seMRokYK; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mZmUrqTSZafu4Ig0+vbHfabSb5U88VLiQudL87QgNhI=; b=seMRokYKlWuSuTxAYXnXaX4ord
	bJIhQtPebbnvQJLTv697hWa73T1NfZ1FVQmLp3Ha2MOTY/a0wSpjgYYreSCkltbHaKxQsqSsQC/CY
	wqFQfEx+PnUIe7x8MZmzhcZWQuh7zqqut/yiuoNuUrWHRCUVrzDI7aOwMhpDzVgbp/5UT37V56Jai
	+6Kv/l6QVNftqmpnVfx0p0ITu/JRwf0PGnjwNM+p6X0dDx/Dt8s+nINUNlyCwyQ9m/S1sx0coM9DD
	OAKNJq8yPfHqSuu6zGm69fH6W+rKJNcwfK7xkzxDJ6w4PR19dhzyPvDlclu5ObMxaBOw2Qi+XtNWO
	xuWSwQxg==;
Received: from [2001:8b0:10b:1::ebe] (helo=i7.infradead.org)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4p-00000002JfQ-3Fwp;
	Tue, 27 Feb 2024 11:56:52 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rew4o-000000000wd-0Hoh;
	Tue, 27 Feb 2024 11:56:50 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Paul Durrant <pdurrant@amazon.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Woodhouse <dwmw2@infradead.org>,
	x86@kernel.org
Subject: [PATCH v2 6/8] KVM: x86/xen: split up kvm_xen_set_evtchn_fast()
Date: Tue, 27 Feb 2024 11:49:20 +0000
Message-ID: <20240227115648.3104-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240227115648.3104-1-dwmw2@infradead.org>
References: <20240227115648.3104-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

From: Paul Durrant <pdurrant@amazon.com>

The implementation of kvm_xen_set_evtchn_fast() is a rather lengthy piece
of code that performs two operations: updating of the shared_info
evtchn_pending mask, and updating of the vcpu_info evtchn_pending_sel
mask. Introduce a separate function to perform each of those operations and
re-work kvm_xen_set_evtchn_fast() to use them.

No functional change intended.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
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
---
 arch/x86/kvm/xen.c | 173 ++++++++++++++++++++++++++-------------------
 1 file changed, 99 insertions(+), 74 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index e87b36590809..c16b6d394d55 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -1728,112 +1728,137 @@ static void kvm_xen_check_poller(struct kvm_vcpu *vcpu, int port)
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
+static int set_shinfo_evtchn_pending(struct kvm_vcpu *vcpu, u32 port)
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
+
 		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
 		mask_bits = (unsigned long *)&shinfo->evtchn_mask;
-		port_word_bit = xe->port / 64;
 	} else {
 		struct compat_shared_info *shinfo = gpc->khva;
+
 		pending_bits = (unsigned long *)&shinfo->evtchn_pending;
 		mask_bits = (unsigned long *)&shinfo->evtchn_mask;
-		port_word_bit = xe->port / 32;
 	}
 
-	/*
-	 * If this port wasn't already set, and if it isn't masked, then
-	 * we try to set the corresponding bit in the in-kernel shadow of
-	 * evtchn_pending_sel for the target vCPU. And if *that* wasn't
-	 * already set, then we kick the vCPU in question to write to the
-	 * *real* evtchn_pending_sel in its own guest vcpu_info struct.
-	 */
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
+ out:
+	read_unlock_irqrestore(&gpc->lock, flags);
+	return rc;
+}
+
+static bool set_vcpu_info_evtchn_pending(struct kvm_vcpu *vcpu, u32 port)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct gfn_to_pfn_cache *gpc = &vcpu->arch.xen.vcpu_info_cache;
+	unsigned long flags;
+	bool kick_vcpu = false;
+
+	read_lock_irqsave(&gpc->lock, flags);
+
+	/*
+	 * Try to deliver the event directly to the vcpu_info. If successful and
+	 * the guest is using upcall_vector delivery, send the MSI.
+	 * If the pfncache is invalid, set the shadow. In this case, or if the
+	 * guest is using another form of event delivery, the vCPU must be
+	 * kicked to complete the delivery.
+	 */
+	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
+		struct vcpu_info *vcpu_info = gpc->khva;
+		int port_word_bit = port / 64;
+
+		if (!kvm_gpc_check(gpc, sizeof(*vcpu_info))) {
 			if (!test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel))
 				kick_vcpu = true;
-			goto out_rcu;
+			goto out;
 		}
 
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
+		if (!test_and_set_bit(port_word_bit, &vcpu_info->evtchn_pending_sel)) {
+			WRITE_ONCE(vcpu_info->evtchn_upcall_pending, 1);
+			kick_vcpu = true;
+		}
+	} else {
+		struct compat_vcpu_info *vcpu_info = gpc->khva;
+		int port_word_bit = port / 32;
+
+		if (!kvm_gpc_check(gpc, sizeof(*vcpu_info))) {
+			if (!test_and_set_bit(port_word_bit, &vcpu->arch.xen.evtchn_pending_sel))
 				kick_vcpu = true;
-			}
+			goto out;
 		}
 
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
+	if (xe->port >= max_evtchn_port(kvm))
+		return -EINVAL;
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	rc = set_shinfo_evtchn_pending(vcpu, xe->port);
+	if (rc == 1) /* Delivered to the bitmap in shared_info */
+		kick_vcpu = set_vcpu_info_evtchn_pending(vcpu, xe->port);
+
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	if (kick_vcpu) {
-- 
2.43.0


