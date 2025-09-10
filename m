Return-Path: <kvm+bounces-57167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 053C3B50BF5
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 04:55:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4359418944C8
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 02:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20553253F13;
	Wed, 10 Sep 2025 02:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="K0zWByDA"
X-Original-To: kvm@vger.kernel.org
Received: from out28-2.mail.aliyun.com (out28-2.mail.aliyun.com [115.124.28.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48907233D7B;
	Wed, 10 Sep 2025 02:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757472893; cv=none; b=AVFklSF5iMwgk08yImI303WPgLvN9pw8hY0zUwkJAjIXvlsTCLi2IXTCd5pa0EP7lklsHGPSNgWClqgoh4CMAirHXEE5dZvHyTmFgA4/mn1DIGnXO28s0EuPNInakkM2VJfDccBe2a7+3hAKsM1zinXU5lVtEFLb7ltDGFyjj08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757472893; c=relaxed/simple;
	bh=0WIDcgjZuXIJk7pDetcgQ74hoJJf5T6G/Kb2qcOc08Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dPiWa+C3wkJMHZMFEGy4A70QODEAyAk0A1riCQ2EUzAMNxVSat6jrPCoOIwwOTm5BAp2ZCU9Y3w2fmjto2FMEISOmTbyMtWXJdxXXoVkxDsQmRy5kqIDJVAZ4LYAeAh+1ODHOCQCLUG6dCKNhdW2qKydRvGgEcYjuKVgYx8LOkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=K0zWByDA; arc=none smtp.client-ip=115.124.28.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1757472888; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=IkAb+os3P2Jf4Ct8/iKChVCSjH0a3tMadZqmTNIXI7Q=;
	b=K0zWByDARb2QBQl4jkbaruaAsbGTKophi8FSDsop9hp40HJ5AyZIg2WgB7Yg+s6yp/TTipmFBhfnvUZWY9TS5b/1QOviPYxN8CRlAnOdWIcPqES4UfRV25A9+a0yKqL8hZLke86iwLv4k357syZ3zltBTKroQchknb9NIaWv9JQ=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.ebfNx90_1757472569 cluster:ay29)
          by smtp.aliyun-inc.com;
          Wed, 10 Sep 2025 10:49:29 +0800
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
Subject: [PATCH 5/7] KVM: VMX: Set 'BS' bit in pending debug exceptions during instruction emulation
Date: Wed, 10 Sep 2025 10:49:17 +0800
Message-Id: <b1a294bc9ed4dae532474a5dc6c8cb6e5962de7c.1757416809.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
References: <cover.1757416809.git.houwenlong.hwl@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If 'STI' or 'MOV SS' with 'X86_EFLAGS_TF' set is emulated by the
emulator (e.g., using the 'force emulation' prefix), the check for
pending debug exceptions during VM entry would fail, as #UD clears the
pending debug exceptions. Therefore, set the 'BS' bit in such situations
to make instruction emulation more robust.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/vmx/main.c            |  9 +++++++++
 arch/x86/kvm/vmx/vmx.c             | 14 +++++++++-----
 arch/x86/kvm/vmx/x86_ops.h         |  1 +
 arch/x86/kvm/x86.c                 |  7 +++++--
 6 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 18a5c3119e1a..3a0ab1683f17 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -50,6 +50,7 @@ KVM_X86_OP(get_gdt)
 KVM_X86_OP(set_gdt)
 KVM_X86_OP(sync_dirty_debug_regs)
 KVM_X86_OP(set_dr7)
+KVM_X86_OP_OPTIONAL(set_pending_dbg)
 KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
 KVM_X86_OP(set_rflags)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0d3cc0fc27af..a36ca751ee2e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1765,6 +1765,7 @@ struct kvm_x86_ops {
 	void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 	void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
 	void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
+	void (*set_pending_dbg)(struct kvm_vcpu *vcpu);
 	void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index dbab1c15b0cd..23adff73f90b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -465,6 +465,14 @@ static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 	vmx_set_dr7(vcpu, val);
 }
 
+static void vt_set_pending_dbg(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_pending_dbg(vcpu);
+}
+
 static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -906,6 +914,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_gdt = vt_op(get_gdt),
 	.set_gdt = vt_op(set_gdt),
 	.set_dr7 = vt_op(set_dr7),
+	.set_pending_dbg = vt_op(set_pending_dbg),
 	.sync_dirty_debug_regs = vt_op(sync_dirty_debug_regs),
 	.cache_reg = vt_op(cache_reg),
 	.get_rflags = vt_op(get_rflags),
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 227b45430ad8..e861a0edb3f4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5243,11 +5243,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			 */
 			if (is_icebp(intr_info))
 				WARN_ON(!skip_emulated_instruction(vcpu));
-			else if ((vmx_get_rflags(vcpu) & X86_EFLAGS_TF) &&
-				 (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
-				  (GUEST_INTR_STATE_STI | GUEST_INTR_STATE_MOV_SS)))
-				vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
-					    vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS) | DR6_BS);
+			vmx_set_pending_dbg(vcpu);
 
 			kvm_queue_exception_p(vcpu, DB_VECTOR, dr6);
 			return 1;
@@ -5554,6 +5550,14 @@ void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
 	vmcs_writel(GUEST_DR7, val);
 }
 
+void vmx_set_pending_dbg(struct kvm_vcpu *vcpu)
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
index 2b3424f638db..2913648cfe4f 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -75,6 +75,7 @@ void vmx_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
 void vmx_set_dr6(struct kvm_vcpu *vcpu, unsigned long val);
 void vmx_set_dr7(struct kvm_vcpu *vcpu, unsigned long val);
+void vmx_set_pending_dbg(struct kvm_vcpu *vcpu);
 void vmx_sync_dirty_debug_regs(struct kvm_vcpu *vcpu);
 void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83960214d5d8..464e9649cb54 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9250,10 +9250,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			if (ctxt->is_branch)
 				kvm_pmu_branch_retired(vcpu);
 			kvm_rip_write(vcpu, ctxt->eip);
-			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
+			__kvm_set_rflags(vcpu, ctxt->eflags);
+			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP))) {
 				r = kvm_vcpu_do_singlestep(vcpu);
+				if (r)
+					kvm_x86_call(set_pending_dbg)(vcpu);
+			}
 			kvm_x86_call(update_emulated_instruction)(vcpu);
-			__kvm_set_rflags(vcpu, ctxt->eflags);
 		}
 
 		/*
-- 
2.31.1


