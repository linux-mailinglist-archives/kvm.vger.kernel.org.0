Return-Path: <kvm+bounces-65323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F58CA6D4C
	for <lists+kvm@lfdr.de>; Fri, 05 Dec 2025 10:11:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AAB88329064F
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 08:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBCA533A6E0;
	Fri,  5 Dec 2025 07:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Bt1uw1Ge";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Bt1uw1Ge"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819D12FC89C
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 07:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764920794; cv=none; b=SupaN7se/Qnm/U0xd9CyyWxIXtP5X7vNbK1ZMQHhSp/61mcv24rNu7EHa8dRycD9I7npwlQdTFUVG3F3SGvIM+L2jIuIMpkCn81zSSuYq83FyrjYrbdb/pn+Fpfsjem+tT07FeslcSGhnO2f81AcS0BhEA62l+WChS5JFaJBxD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764920794; c=relaxed/simple;
	bh=LgeEYC7RcfL1pTZYXxSRzd77aHiHaIRQ1ZpIvBSns1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcdUyaXodcZi1QTM1I1Meg3dVxkeyCuLJY8FmAc4W8TJQZecLEasfZk27Ssk2Uz6zNHRnVHXGzaXtbobApiGBqZR2zK2ewhfuy2vfy+zLS3qXVmAhjTRdJOXz1qeZMc1zcdRuQR1fbstQoIACtyAe0GbMQBp1cBYidl2UkEGkw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Bt1uw1Ge; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Bt1uw1Ge; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A57AE336CE;
	Fri,  5 Dec 2025 07:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TzU0lTqNH6rTkNfJ6/9hmniTpZVirQk/Sr1oT3hVCWA=;
	b=Bt1uw1GeW1jwYGM67In9mW3Aa6jYHLIeHAViJaS5PX/zVuHxirJSHmwawi1xKQN5v95J2S
	9I0suKowmYzvwoTHgo7aL8WNNpH78RiKBCusN1YqTlGG7k7qMet5d1f+erIrHS8N6PhQhq
	Dw4mLujN8Q5eq6g50TcH9Q716ai9CS8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1764920757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TzU0lTqNH6rTkNfJ6/9hmniTpZVirQk/Sr1oT3hVCWA=;
	b=Bt1uw1GeW1jwYGM67In9mW3Aa6jYHLIeHAViJaS5PX/zVuHxirJSHmwawi1xKQN5v95J2S
	9I0suKowmYzvwoTHgo7aL8WNNpH78RiKBCusN1YqTlGG7k7qMet5d1f+erIrHS8N6PhQhq
	Dw4mLujN8Q5eq6g50TcH9Q716ai9CS8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4124A3EA63;
	Fri,  5 Dec 2025 07:45:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id glQtDrWNMmlzEgAAD6G6ig
	(envelope-from <jgross@suse.com>); Fri, 05 Dec 2025 07:45:57 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 03/10] KVM/x86: Let x86_emulate_ops.set_cr() return a bool
Date: Fri,  5 Dec 2025 08:45:30 +0100
Message-ID: <20251205074537.17072-4-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205074537.17072-1-jgross@suse.com>
References: <20251205074537.17072-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.989];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Today x86_emulate_ops.set_cr() is returning "0" for okay and "1" in
case of an error. In order to get rid of the literal numbers, use bool
as return type for x86_emulate_ops.set_cr() and related sub-functions.

Note that in the case of an illegal cr specified emulator_set_cr()
will return -1. As all callers are either ignoring the return value or
are testing only for 0, returning just true for that case is fine.

No change of functionality intended.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/kvm_host.h |  8 ++---
 arch/x86/kvm/kvm_emulate.h      |  2 +-
 arch/x86/kvm/smm.c              |  2 +-
 arch/x86/kvm/svm/svm.c          |  6 ++--
 arch/x86/kvm/vmx/vmx.c          | 14 ++++-----
 arch/x86/kvm/x86.c              | 54 ++++++++++++++++-----------------
 6 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2b289708b56b..7997ed36de38 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2203,10 +2203,10 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 
 void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned long cr0);
 void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned long cr4);
-int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
-int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
-int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
+bool kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
+bool kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
+bool kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
+bool kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
 int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
 unsigned long kvm_get_dr(struct kvm_vcpu *vcpu, int dr);
 unsigned long kvm_get_cr8(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 7b5ddb787a25..efc64396d717 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -209,7 +209,7 @@ struct x86_emulate_ops {
 	void (*set_gdt)(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt);
 	void (*set_idt)(struct x86_emulate_ctxt *ctxt, struct desc_ptr *dt);
 	ulong (*get_cr)(struct x86_emulate_ctxt *ctxt, int cr);
-	int (*set_cr)(struct x86_emulate_ctxt *ctxt, int cr, ulong val);
+	bool (*set_cr)(struct x86_emulate_ctxt *ctxt, int cr, ulong val);
 	int (*cpl)(struct x86_emulate_ctxt *ctxt);
 	ulong (*get_dr)(struct x86_emulate_ctxt *ctxt, int dr);
 	int (*set_dr)(struct x86_emulate_ctxt *ctxt, int dr, ulong value);
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index f623c5986119..87af91f4f9f2 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -419,7 +419,7 @@ static int rsm_load_seg_64(struct kvm_vcpu *vcpu,
 static int rsm_enter_protected_mode(struct kvm_vcpu *vcpu,
 				    u64 cr0, u64 cr3, u64 cr4)
 {
-	int bad;
+	bool bad;
 	u64 pcid;
 
 	/* In order to later set CR4.PCIDE, CR3[11:0] must be zero.  */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f354cf0b6c1c..98bd087dda9c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2448,7 +2448,7 @@ static int cr_interception(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int reg, cr;
 	unsigned long val;
-	int err;
+	bool err;
 
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
 		return emulate_on_interception(vcpu);
@@ -2462,7 +2462,7 @@ static int cr_interception(struct kvm_vcpu *vcpu)
 	else
 		cr = svm->vmcb->control.exit_code - SVM_EXIT_READ_CR0;
 
-	err = 0;
+	err = false;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
 		val = kvm_register_read(vcpu, reg);
@@ -2522,7 +2522,7 @@ static int cr_trap(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long old_value, new_value;
 	unsigned int cr;
-	int ret = 0;
+	bool ret = false;
 
 	new_value = (unsigned long)svm->vmcb->control.exit_info_1;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 91b6f2f3edc2..ff0c684d9c28 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5394,7 +5394,7 @@ void vmx_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 }
 
 /* called to set cr0 as appropriate for a mov-to-cr0 exit. */
-static int handle_set_cr0(struct kvm_vcpu *vcpu, unsigned long val)
+static bool handle_set_cr0(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	if (is_guest_mode(vcpu)) {
 		struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -5412,15 +5412,15 @@ static int handle_set_cr0(struct kvm_vcpu *vcpu, unsigned long val)
 			(vmcs12->guest_cr0 & vmcs12->cr0_guest_host_mask);
 
 		if (kvm_set_cr0(vcpu, val))
-			return 1;
+			return true;
 		vmcs_writel(CR0_READ_SHADOW, orig_val);
-		return 0;
+		return false;
 	} else {
 		return kvm_set_cr0(vcpu, val);
 	}
 }
 
-static int handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
+static bool handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	if (is_guest_mode(vcpu)) {
 		struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -5430,9 +5430,9 @@ static int handle_set_cr4(struct kvm_vcpu *vcpu, unsigned long val)
 		val = (val & ~vmcs12->cr4_guest_host_mask) |
 			(vmcs12->guest_cr4 & vmcs12->cr4_guest_host_mask);
 		if (kvm_set_cr4(vcpu, val))
-			return 1;
+			return true;
 		vmcs_writel(CR4_READ_SHADOW, orig_val);
-		return 0;
+		return false;
 	} else
 		return kvm_set_cr4(vcpu, val);
 }
@@ -5454,7 +5454,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 	unsigned long exit_qualification, val;
 	int cr;
 	int reg;
-	int err;
+	bool err;
 	int ret;
 
 	exit_qualification = vmx_get_exit_qual(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7c84d9ea9de..462954633c1d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1153,12 +1153,12 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_post_set_cr0);
 
-int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+bool kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	unsigned long old_cr0 = kvm_read_cr0(vcpu);
 
 	if (!kvm_is_valid_cr0(vcpu, cr0))
-		return 1;
+		return true;
 
 	cr0 |= X86_CR0_ET;
 
@@ -1171,29 +1171,29 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		int cs_db, cs_l;
 
 		if (!is_pae(vcpu))
-			return 1;
+			return true;
 		kvm_x86_call(get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
 		if (cs_l)
-			return 1;
+			return true;
 	}
 #endif
 	if (!(vcpu->arch.efer & EFER_LME) && (cr0 & X86_CR0_PG) &&
 	    is_pae(vcpu) && ((cr0 ^ old_cr0) & X86_CR0_PDPTR_BITS) &&
 	    !load_pdptrs(vcpu, kvm_read_cr3(vcpu)))
-		return 1;
+		return true;
 
 	if (!(cr0 & X86_CR0_PG) &&
 	    (is_64_bit_mode(vcpu) || kvm_is_cr4_bit_set(vcpu, X86_CR4_PCIDE)))
-		return 1;
+		return true;
 
 	if (!(cr0 & X86_CR0_WP) && kvm_is_cr4_bit_set(vcpu, X86_CR4_CET))
-		return 1;
+		return true;
 
 	kvm_x86_call(set_cr0)(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
 
-	return 0;
+	return false;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_cr0);
 
@@ -1366,37 +1366,37 @@ void kvm_post_set_cr4(struct kvm_vcpu *vcpu, unsigned long old_cr4, unsigned lon
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_post_set_cr4);
 
-int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+bool kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 
 	if (!kvm_is_valid_cr4(vcpu, cr4))
-		return 1;
+		return true;
 
 	if (is_long_mode(vcpu)) {
 		if (!(cr4 & X86_CR4_PAE))
-			return 1;
+			return true;
 		if ((cr4 ^ old_cr4) & X86_CR4_LA57)
-			return 1;
+			return true;
 	} else if (is_paging(vcpu) && (cr4 & X86_CR4_PAE)
 		   && ((cr4 ^ old_cr4) & X86_CR4_PDPTR_BITS)
 		   && !load_pdptrs(vcpu, kvm_read_cr3(vcpu)))
-		return 1;
+		return true;
 
 	if ((cr4 & X86_CR4_PCIDE) && !(old_cr4 & X86_CR4_PCIDE)) {
 		/* PCID can not be enabled when cr3[11:0]!=000H or EFER.LMA=0 */
 		if ((kvm_read_cr3(vcpu) & X86_CR3_PCID_MASK) || !is_long_mode(vcpu))
-			return 1;
+			return true;
 	}
 
 	if ((cr4 & X86_CR4_CET) && !kvm_is_cr0_bit_set(vcpu, X86_CR0_WP))
-		return 1;
+		return true;
 
 	kvm_x86_call(set_cr4)(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
 
-	return 0;
+	return false;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_cr4);
 
@@ -1443,7 +1443,7 @@ static void kvm_invalidate_pcid(struct kvm_vcpu *vcpu, unsigned long pcid)
 	kvm_mmu_free_roots(vcpu->kvm, mmu, roots_to_free);
 }
 
-int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+bool kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
 	bool skip_tlb_flush = false;
 	unsigned long pcid = 0;
@@ -1465,10 +1465,10 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	 * the current vCPU mode is accurate.
 	 */
 	if (!kvm_vcpu_is_legal_cr3(vcpu, cr3))
-		return 1;
+		return true;
 
 	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
-		return 1;
+		return true;
 
 	if (cr3 != kvm_read_cr3(vcpu))
 		kvm_mmu_new_pgd(vcpu, cr3);
@@ -1488,19 +1488,19 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (!skip_tlb_flush)
 		kvm_invalidate_pcid(vcpu, pcid);
 
-	return 0;
+	return false;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_cr3);
 
-int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
+bool kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
 	if (cr8 & CR8_RESERVED_BITS)
-		return 1;
+		return true;
 	if (lapic_in_kernel(vcpu))
 		kvm_lapic_set_tpr(vcpu, cr8);
 	else
 		vcpu->arch.cr8 = cr8;
-	return 0;
+	return false;
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_set_cr8);
 
@@ -8571,10 +8571,10 @@ static unsigned long emulator_get_cr(struct x86_emulate_ctxt *ctxt, int cr)
 	return value;
 }
 
-static int emulator_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
+static bool emulator_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	int res = 0;
+	bool res = false;
 
 	switch (cr) {
 	case 0:
@@ -8594,7 +8594,7 @@ static int emulator_set_cr(struct x86_emulate_ctxt *ctxt, int cr, ulong val)
 		break;
 	default:
 		kvm_err("%s: unexpected cr %u\n", __func__, cr);
-		res = -1;
+		res = true;
 	}
 
 	return res;
@@ -11912,7 +11912,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	/* re-sync apic's tpr */
 	if (!lapic_in_kernel(vcpu)) {
-		if (kvm_set_cr8(vcpu, kvm_run->cr8) != 0) {
+		if (kvm_set_cr8(vcpu, kvm_run->cr8)) {
 			r = -EINVAL;
 			goto out;
 		}
-- 
2.51.0


