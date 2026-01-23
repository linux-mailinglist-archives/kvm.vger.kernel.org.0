Return-Path: <kvm+bounces-69026-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uFxOEEj6c2mf0gAAu9opvQ
	(envelope-from <kvm+bounces-69026-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:46:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A56C7B3B4
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 23:46:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C99543055F4F
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 22:45:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8589C2857F6;
	Fri, 23 Jan 2026 22:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SNDPLbmA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAB42D3228
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 22:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769208324; cv=none; b=mWMPvJ7EDBPbJ5NTjgEhwLA8su2x4cTFlZOKoYGsMdzpbtMh4BRWTSCapaaeyLejPf/MJYYf8oT7NB4Q/g0yr8kkhT9igktcp6nPB3na/oiUTVBL/tyGt3qRwXoKUyW6COghQ9XqaMe9wpycYXpNFV7U5rntTcxbzlErAnquztE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769208324; c=relaxed/simple;
	bh=Ucvy3mCSRlDP1/idUF+uj0a+ZsMEHMK6vqwX5ekHvlE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ApDYCbSshWYaHfhPywyCpZcN6cPojQMJlMBjp9To9Sl41m518GaqUNtm1j30Wa2nbs7To7LhYx05WHI9T7ggUY4GeijX1opGcSU4oLt51O66Mw/CYKXXnacFMjlA5ZjMlejg7CkmO7zURm83GrLZddGeHM51T4ZXxTUwUnmFJAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SNDPLbmA; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c5454bf50e0so4441686a12.2
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 14:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769208322; x=1769813122; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=6KEU0oyTWRASi8ApGU00J+KrwOMhi5teKUB83me0wcM=;
        b=SNDPLbmA3Yz+OIrK6XNKbCENJDnKp+lnBJJZ9S/cmhVR2eOTikoxPSotQePKmhVe8j
         p5P8c/Z1hkMHu6dUfJkd1x/ahBwv9Suzm81eSFOQ+sBBvTnsHQpeVvuY9D5Hh8ae40jG
         RVZHBE+2BtPJazCR+SWoM0wewjXK3oLvn6zKB9Ee/rRLfWfyH3Ejv2+CCf1JIIyzC0AG
         /GnOtpytmBc61pG2M1LCp0kukrxXBlfleOEGwhiIKTpMLKmA9RHC2NI2SMa0HDHPlOrB
         B+JB+Acvz28FHv92bKjHWoIUp9O3IZIHjIFNTUafLPaFS3bu9iQQbGDp5oa6bC5zQo+a
         NJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769208322; x=1769813122;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6KEU0oyTWRASi8ApGU00J+KrwOMhi5teKUB83me0wcM=;
        b=oBP5mgAOYaIwCqiQn1wQY7GitAzs0v69mC8RpMdcnKqgkbwaRTNgNDVIhP95vcrQ/n
         UaWt6LvPe+AbB0x84e20/jMBSlaBmZTSj39921ESWCUGaMB44JX6nqiiPErrMbh7r+kv
         Yim5mtgV06qX9qqmnR2HKWNdVeCI8bHRqu+inCYW1etC/YJhUy1MSA8EmnO3DIw4G1fe
         mrgrQ3FE3gh35MfL6N1TZ3jUSVI0oTf5FNgaquYbeEfXnkYEtaxnXBH6Z41hLxqPZTVz
         CPKLsocLCSo1jQAyJe67q1H8gp6p891Pe4P9nWUsqP+NqevqNtM6ciF09reAkzMwjoi7
         NnOA==
X-Gm-Message-State: AOJu0Yxua1FrxjeZBwZHs4ZagTvAZWqyww2N20X/nnOSbxQJiXYcC4nN
	7yQrg5aHusSsjixqZ12WtZvVRdakQZQ2r6APvDJ/OTN6i6h5JMLfVTLOo0OY4KfWMLduJde12SJ
	aLOxnqg==
X-Received: from pgg15.prod.google.com ([2002:a05:6a02:4d8f:b0:bd9:a349:94a3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c704:b0:370:73c1:6a87
 with SMTP id adf61e73a8af0-38e6f7f9940mr3774066637.58.1769208322115; Fri, 23
 Jan 2026 14:45:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Jan 2026 14:45:12 -0800
In-Reply-To: <20260123224514.2509129-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123224514.2509129-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260123224514.2509129-3-seanjc@google.com>
Subject: [PATCH v2 2/4] KVM: SVM: Fix IRQ window inhibit handling across
 multiple vCPUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-69026-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 9A56C7B3B4
X-Rspamd-Action: no action

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

Co-developed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Co-developed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 19 ++++++++++++++++-
 arch/x86/kvm/svm/svm.c          | 36 +++++++++++++++++++++++----------
 arch/x86/kvm/svm/svm.h          |  1 +
 arch/x86/kvm/x86.c              | 19 +++++++++++++++++
 4 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e441f270f354..b08baeff98b2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1427,6 +1427,7 @@ struct kvm_arch {
 	struct kvm_pit *vpit;
 #endif
 	atomic_t vapics_in_nmi_mode;
+
 	struct mutex apic_map_lock;
 	struct kvm_apic_map __rcu *apic_map;
 	atomic_t apic_map_dirty;
@@ -1434,9 +1435,13 @@ struct kvm_arch {
 	bool apic_access_memslot_enabled;
 	bool apic_access_memslot_inhibited;
 
-	/* Protects apicv_inhibit_reasons */
+	/*
+	 * Protects apicv_inhibit_reasons and apicv_nr_irq_window_req (with an
+	 * asterisk, see kvm_inc_or_dec_irq_window_inhibit() for details).
+	 */
 	struct rw_semaphore apicv_update_lock;
 	unsigned long apicv_inhibit_reasons;
+	atomic_t apicv_nr_irq_window_req;
 
 	gpa_t wall_clock;
 
@@ -2309,6 +2314,18 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
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
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 24b9c2275821..559e8fa76b7e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3729,8 +3729,11 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
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
 
 	trace_kvm_inj_virq(intr->nr, intr->soft, reinjected);
 	++vcpu->stat.irq_injections;
@@ -3932,17 +3935,28 @@ static void svm_enable_irq_window(struct kvm_vcpu *vcpu)
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
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ebd7b36b1ceb..68675b25ef8e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -333,6 +333,7 @@ struct vcpu_svm {
 
 	bool guest_state_loaded;
 
+	bool avic_irq_window;
 	bool x2avic_msrs_intercepted;
 	bool lbr_msrs_intercepted;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8acfdfc583a1..2528dfffb42b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10994,6 +10994,25 @@ void kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_or_clear_apicv_inhibit);
 
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
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_inc_or_dec_irq_window_inhibit);
+
 static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_apic_present(vcpu))
-- 
2.52.0.457.g6b5491de43-goog


