Return-Path: <kvm+bounces-66267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D5886CCC2C4
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 15:07:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0FC443050935
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 14:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 571BD34677B;
	Thu, 18 Dec 2025 14:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="GYlwE1Fw"
X-Original-To: kvm@vger.kernel.org
Received: from out28-217.mail.aliyun.com (out28-217.mail.aliyun.com [115.124.28.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADC634404D;
	Thu, 18 Dec 2025 14:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766066480; cv=none; b=hdPt+4db4TaUHZcMqHJRXuSEHSpl4+JAaPLABAPnjJMf4QoXzMLxHaBWyJm9n0mc4LggSArkBrul1u/UPH7ja3bJDjrjNT03qvg+DpoMX/exfucgf4LlZg0bkFsQ2vmD+cu607y8zyruUpj1tmRQYKrJbYMWj8u+Biog2suog1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766066480; c=relaxed/simple;
	bh=Xi0C5tcN6F9Xr4U3VHsP1PZ7lU7bj/0wwwpfeuy6jkU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZKnwevqj8D3KcKsbu2HQsNQLbmckbL6TfnqoH/S/UlxTPmBG+o89CZdBCT3fQR61ChrZFyAAuvBwWrDpPgLj/TChDLgCpUJtLvIkS5Rt6pfuU3ADrWB5dMF27ysFaFxEJYc6XfSsYoAQ8P0O2rexRcXTDvxIaiRmIfTgimcS8h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=GYlwE1Fw; arc=none smtp.client-ip=115.124.28.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1766066468; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=4VDI1G+PZ+QJUDH6eDMxLLwi+jayIGYT6bmwHQDL72E=;
	b=GYlwE1FwOscUMWxfznpFprYcEgr2t+BcZJ/aYJGBKwjjqNAc5nL3Qf1rAVaTFU3sq3j9Wkg8jLHQhTm+xaREFDBjkIRYMqSaYVLBgBwj3hEjXMVERTsbF1srG8+lnqCy1dLRWYnC1zfjSsEYWqk5a+lIWF/KCiKAUmop3O9H3/E=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.fnf5vge_1766066467 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 18 Dec 2025 22:01:07 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/9] KVM: VMX: Refresh 'PENDING_DBG_EXCEPTIONS.BS' bit during instruction emulation
Date: Thu, 18 Dec 2025 22:00:42 +0800
Message-Id: <5e667a338a27ef2392143962466d77432fcd5441.1766066076.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1766066076.git.houwenlong.hwl@antgroup.com>
References: <cover.1766066076.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The VM-Entry has a consistency check that when the 'STI' or 'MOVSS'
blocking is active, the 'PENDING_DBG_EXCEPTIONS.BS' bit must be set if
'RFLAGS.TF' is set; otherwise, a VM-Fail is triggered during VM-entry.
However, when 'STI' or 'MOV SS' is emulated (e.g., using the 'force
emulation' prefix), the emulator only refreshes interruptibility state
but pending debug exception state is not refreshed. Since the force
emulation prefix causes a VM-Exit due to #UD interception, which clears
the 'PENDING_DBG_EXCEPTIONS' bits, the emulator should refresh the
'PENDING_DBG_EXCEPTIONS.BS' bit when the 'RFLAGS.TF' bit is set to
ensure the success of VM-Entry.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/vmx/main.c            |  9 +++++++++
 arch/x86/kvm/vmx/vmx.c             | 15 ++++++++++-----
 arch/x86/kvm/vmx/x86_ops.h         |  1 +
 arch/x86/kvm/x86.c                 |  7 ++++++-
 6 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index de709fb5bd76..9a591f95adc4 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -50,6 +50,7 @@ KVM_X86_OP(get_gdt)
 KVM_X86_OP(set_gdt)
 KVM_X86_OP(sync_dirty_debug_regs)
 KVM_X86_OP(set_dr7)
+KVM_X86_OP_OPTIONAL(refresh_pending_dbg_exceptions)
 KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
 KVM_X86_OP(set_rflags)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5a3bfa293e8b..46fe25dee391 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1763,6 +1763,7 @@ struct kvm_x86_ops {
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
+	void (*refresh_pending_dbg_exceptions)(struct kvm_vcpu *vcpu);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a46ccd670785..2e20a5d65b91 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -465,6 +465,14 @@ static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 	vmx_set_dr7(vcpu, val);
 }
 
+static void vt_refresh_pending_dbg_exceptions(struct kvm_vcpu *vcpu)
+{
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return;
+
+	vmx_refresh_pending_dbg_exceptions(vcpu);
+}
+
 static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -915,6 +923,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_gdt = vt_op(get_gdt),
 	.set_gdt = vt_op(set_gdt),
 	.set_dr7 = vt_op(set_dr7),
+	.refresh_pending_dbg_exceptions = vt_op(refresh_pending_dbg_exceptions),
 	.sync_dirty_debug_regs = vt_op(sync_dirty_debug_regs),
 	.cache_reg = vt_op(cache_reg),
 	.get_rflags = vt_op(get_rflags),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4cbe8c84b636..8ed031293549 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5431,11 +5431,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			 */
 			if (is_icebp(intr_info))
 				WARN_ON(!skip_emulated_instruction(vcpu));
-			else if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
-				 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
-				  (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
-				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
-					    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
+			else
+				vmx_refresh_pending_dbg_exceptions(vcpu);
 
 			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			return 1;
@@ -5742,6 +5739,14 @@ void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 	vmcs_writel(GUEST_DR7, val);
 }
 
+void vmx_refresh_pending_dbg_exceptions(struct kvm_vcpu *vcpu)
+{
+	if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
+	    vmx_get_interrupt_shadow(vcpu))
+		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
+			    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
+}
+
 static int handle_tpr_below_threshold(struct kvm_vcpu *vcpu)
 {
 	kvm_apic_update_ppr(vcpu);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index d09abeac2b56..2978b6506ac6 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -74,6 +74,7 @@ void vmx_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val);
+void vmx_refresh_pending_dbg_exceptions(struct kvm_vcpu *vcpu);
 void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu);
 void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7352c2114bab..9167393cc0cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9232,7 +9232,12 @@ static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
 
 static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 {
-	return kvm_inject_emulated_db(vcpu, DR6_BS);
+	int r;
+
+	r = kvm_inject_emulated_db(vcpu, DR6_BS);
+	if (r)
+		kvm_x86_call(refresh_pending_dbg_exceptions)(vcpu);
+	return r;
 }
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
-- 
2.31.1


