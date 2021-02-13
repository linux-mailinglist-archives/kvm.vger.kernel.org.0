Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A3531A952
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 02:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbhBMBIH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 20:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbhBMBHd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 20:07:33 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2CCC06121E
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:49 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id n1so894626qvi.4
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 17:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GxRBYEs4CWruEYRrtfSKHL2sbkupVmuIYWg19YRJTeE=;
        b=tAORAmccBwtfDWDhkawqa8cU8ojcedEsrhUixpTf5QdFmHVDSKBZyAeNrFo9/ztSlK
         6lXXruk94Ka9i7EBZXRDZ3R3MH/PPzra+CEyyq5rpqxD9TVIfGVZK1nfXpTJkmCtr/X2
         5JT1y4gSq6EjbERzpgy+kqs4qy2iLDG5GH3hCywBVKmWAMI6nxb6SC4ovu1wOrvtloMg
         APQxY7wUuIc9yaBgbsZjX3Dz0yxcECv3RSAXNnaV5l8vl+fDw/lU22HpNuK4Z1YSSRcf
         XZbpB+Fdm3go9bnDeQnxuhCcIotQ+rW4gxZZfzUWCVzXbvFduMrtiFR/bYjp1/NpiBLW
         QBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GxRBYEs4CWruEYRrtfSKHL2sbkupVmuIYWg19YRJTeE=;
        b=UYS9J/SQVBfAEbJUvnLEKeZaC87k6revYiGtQ0DeTIa/OPa2ORISYTTjo2/dv/0kXV
         giLStaRf/ehG7UxpT7MCilgfOdAsEgfhaqzSgILqBPstdKZx/ulJnRSDeIxt6eH70m3b
         R3VwgmqvKq3jG3++mCSM6l9OuDfnz80KzKbLzqHQmLSWWXJGQrZWPsCqjTiVKYu0nF1C
         L2L9we2wF7VpoIVEqjzVZmSTUtSAVWZN1HuV3J+/o9zSC/KlEk2VsBga0UwB0iL2GUxM
         9w5mhL19U2X8gJInvsp4+HNMYPnTpjlOG1t6ATT85RTq8QEcDWIL4blKZKTaDu92os4u
         ddbA==
X-Gm-Message-State: AOAM532o0SIfXBOIXvQpRkzLDgWwgCjgvbtnWe3I515/uGTGbclKog9d
        v1fl+OLaZx1AAtOKbJGYW+HnnEGrE/o=
X-Google-Smtp-Source: ABdhPJyKLwZoEBRJ36RbXivN6C+aGywSGAgjsVtG0ymGdiyD/xd5LCqkYdu/GmD11UBmFe3spDJkjVoEOxk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a0c:e38c:: with SMTP id a12mr5121096qvl.38.1613178348349;
 Fri, 12 Feb 2021 17:05:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 17:05:18 -0800
In-Reply-To: <20210213010518.1682691-1-seanjc@google.com>
Message-Id: <20210213010518.1682691-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210213010518.1682691-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 9/9] KVM: x86: Rename GPR accessors to make mode-aware
 variants the defaults
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Append raw to the direct variants of kvm_register_read/write(), and
drop the "l" from the mode-aware variants.  I.e. make the mode-aware
variants the default, and make the direct variants scary sounding so as
to discourage use.  Accessing the full 64-bit values irrespective of
mode is rarely the desired behavior.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 19 ++++++++++++-------
 arch/x86/kvm/svm/svm.c        |  8 ++++----
 arch/x86/kvm/vmx/nested.c     | 20 ++++++++++----------
 arch/x86/kvm/vmx/vmx.c        | 12 ++++++------
 arch/x86/kvm/x86.c            |  8 ++++----
 arch/x86/kvm/x86.h            |  8 ++++----
 arch/x86/kvm/xen.c            |  2 +-
 7 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 2e11da2f5621..3db5c42c9ecd 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -62,7 +62,12 @@ static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
 	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
 }
 
-static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
+/*
+ * The "raw" register helpers are only for cases where the full 64 bits of a
+ * register are read/written irrespective of current vCPU mode.  In other words,
+ * odds are good you shouldn't be using the raw variants.
+ */
+static inline unsigned long kvm_register_read_raw(struct kvm_vcpu *vcpu, int reg)
 {
 	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
 		return 0;
@@ -73,8 +78,8 @@ static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
 	return vcpu->arch.regs[reg];
 }
 
-static inline void kvm_register_write(struct kvm_vcpu *vcpu, int reg,
-				      unsigned long val)
+static inline void kvm_register_write_raw(struct kvm_vcpu *vcpu, int reg,
+					  unsigned long val)
 {
 	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
 		return;
@@ -85,22 +90,22 @@ static inline void kvm_register_write(struct kvm_vcpu *vcpu, int reg,
 
 static inline unsigned long kvm_rip_read(struct kvm_vcpu *vcpu)
 {
-	return kvm_register_read(vcpu, VCPU_REGS_RIP);
+	return kvm_register_read_raw(vcpu, VCPU_REGS_RIP);
 }
 
 static inline void kvm_rip_write(struct kvm_vcpu *vcpu, unsigned long val)
 {
-	kvm_register_write(vcpu, VCPU_REGS_RIP, val);
+	kvm_register_write_raw(vcpu, VCPU_REGS_RIP, val);
 }
 
 static inline unsigned long kvm_rsp_read(struct kvm_vcpu *vcpu)
 {
-	return kvm_register_read(vcpu, VCPU_REGS_RSP);
+	return kvm_register_read_raw(vcpu, VCPU_REGS_RSP);
 }
 
 static inline void kvm_rsp_write(struct kvm_vcpu *vcpu, unsigned long val)
 {
-	kvm_register_write(vcpu, VCPU_REGS_RSP, val);
+	kvm_register_write_raw(vcpu, VCPU_REGS_RSP, val);
 }
 
 static inline u64 kvm_pdptr_read(struct kvm_vcpu *vcpu, int index)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4dc64ebaa756..55afe41b4102 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2531,7 +2531,7 @@ static int cr_interception(struct vcpu_svm *svm)
 	err = 0;
 	if (cr >= 16) { /* mov to cr */
 		cr -= 16;
-		val = kvm_register_readl(&svm->vcpu, reg);
+		val = kvm_register_read(&svm->vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
@@ -2577,7 +2577,7 @@ static int cr_interception(struct vcpu_svm *svm)
 			kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 			return 1;
 		}
-		kvm_register_writel(&svm->vcpu, reg, val);
+		kvm_register_write(&svm->vcpu, reg, val);
 		trace_kvm_cr_read(cr, val);
 	}
 	return kvm_complete_insn_gp(&svm->vcpu, err);
@@ -2642,11 +2642,11 @@ static int dr_interception(struct vcpu_svm *svm)
 	dr = svm->vmcb->control.exit_code - SVM_EXIT_READ_DR0;
 	if (dr >= 16) { /* mov to DRn  */
 		dr -= 16;
-		val = kvm_register_readl(&svm->vcpu, reg);
+		val = kvm_register_read(&svm->vcpu, reg);
 		err = kvm_set_dr(&svm->vcpu, dr, val);
 	} else {
 		kvm_get_dr(&svm->vcpu, dr, &val);
-		kvm_register_writel(&svm->vcpu, reg, val);
+		kvm_register_write(&svm->vcpu, reg, val);
 	}
 
 	return kvm_complete_insn_gp(&svm->vcpu, err);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a02d8744ca66..358747586037 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4601,9 +4601,9 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	else if (addr_size == 0)
 		off = (gva_t)sign_extend64(off, 15);
 	if (base_is_valid)
-		off += kvm_register_readl(vcpu, base_reg);
+		off += kvm_register_read(vcpu, base_reg);
 	if (index_is_valid)
-		off += kvm_register_readl(vcpu, index_reg) << scaling;
+		off += kvm_register_read(vcpu, index_reg) << scaling;
 	vmx_get_segment(vcpu, &s, seg_reg);
 
 	/*
@@ -5005,7 +5005,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		return nested_vmx_failInvalid(vcpu);
 
 	/* Decode instruction info and find the field to read */
-	field = kvm_register_readl(vcpu, (((instr_info) >> 28) & 0xf));
+	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
 
 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)
@@ -5023,7 +5023,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	 * on the guest's mode (32 or 64 bit), not on the given field's length.
 	 */
 	if (instr_info & BIT(10)) {
-		kvm_register_writel(vcpu, (((instr_info) >> 3) & 0xf), value);
+		kvm_register_write(vcpu, (((instr_info) >> 3) & 0xf), value);
 	} else {
 		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
@@ -5097,7 +5097,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		return nested_vmx_failInvalid(vcpu);
 
 	if (instr_info & BIT(10))
-		value = kvm_register_readl(vcpu, (((instr_info) >> 3) & 0xf));
+		value = kvm_register_read(vcpu, (((instr_info) >> 3) & 0xf));
 	else {
 		len = is_64_bit_mode(vcpu) ? 8 : 4;
 		if (get_vmx_mem_address(vcpu, exit_qualification,
@@ -5108,7 +5108,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 			return kvm_handle_memory_failure(vcpu, r, &e);
 	}
 
-	field = kvm_register_readl(vcpu, (((instr_info) >> 28) & 0xf));
+	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
 
 	offset = vmcs_field_to_offset(field);
 	if (offset < 0)
@@ -5305,7 +5305,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 		return 1;
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);
+	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
 
 	types = (vmx->nested.msrs.ept_caps >> VMX_EPT_EXTENT_SHIFT) & 6;
 
@@ -5385,7 +5385,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
 		return 1;
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);
+	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
 
 	types = (vmx->nested.msrs.vpid_caps &
 			VMX_VPID_EXTENT_SUPPORTED_MASK) >> 8;
@@ -5646,7 +5646,7 @@ static bool nested_vmx_exit_handled_cr(struct kvm_vcpu *vcpu,
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
 		reg = (exit_qualification >> 8) & 15;
-		val = kvm_register_readl(vcpu, reg);
+		val = kvm_register_read(vcpu, reg);
 		switch (cr) {
 		case 0:
 			if (vmcs12->cr0_guest_host_mask &
@@ -5717,7 +5717,7 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 
 	/* Decode instruction info and find the field to access */
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
+	field = kvm_register_read(vcpu, (((vmx_instruction_info) >> 28) & 0xf));
 
 	/* Out-of-range fields always cause a VM exit from L2 to L1 */
 	if (field >> 15)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 115826a020ff..03cc2b236d9a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5025,7 +5025,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 	reg = (exit_qualification >> 8) & 15;
 	switch ((exit_qualification >> 4) & 3) {
 	case 0: /* mov to cr */
-		val = kvm_register_readl(vcpu, reg);
+		val = kvm_register_read(vcpu, reg);
 		trace_kvm_cr_write(cr, val);
 		switch (cr) {
 		case 0:
@@ -5067,12 +5067,12 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		case 3:
 			WARN_ON_ONCE(enable_unrestricted_guest);
 			val = kvm_read_cr3(vcpu);
-			kvm_register_writel(vcpu, reg, val);
+			kvm_register_write(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		case 8:
 			val = kvm_get_cr8(vcpu);
-			kvm_register_writel(vcpu, reg, val);
+			kvm_register_write(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		}
@@ -5145,10 +5145,10 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		unsigned long val;
 
 		kvm_get_dr(vcpu, dr, &val);
-		kvm_register_writel(vcpu, reg, val);
+		kvm_register_write(vcpu, reg, val);
 		err = 0;
 	} else {
-		err = kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg));
+		err = kvm_set_dr(vcpu, dr, kvm_register_read(vcpu, reg));
 	}
 
 out:
@@ -5565,7 +5565,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	}
 
 	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
-	type = kvm_register_readl(vcpu, (vmx_instruction_info >> 28) & 0xf);
+	type = kvm_register_read(vcpu, (vmx_instruction_info >> 28) & 0xf);
 
 	if (type > 3) {
 		kvm_inject_gp(vcpu, 0);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 72fd8d384df7..37ad41a63a33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6873,12 +6873,12 @@ static bool emulator_guest_has_fxsr(struct x86_emulate_ctxt *ctxt)
 
 static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
 {
-	return kvm_register_read(emul_to_vcpu(ctxt), reg);
+	return kvm_register_read_raw(emul_to_vcpu(ctxt), reg);
 }
 
 static void emulator_write_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg, ulong val)
 {
-	kvm_register_write(emul_to_vcpu(ctxt), reg, val);
+	kvm_register_write_raw(emul_to_vcpu(ctxt), reg, val);
 }
 
 static void emulator_set_nmi_mask(struct x86_emulate_ctxt *ctxt, bool masked)
@@ -8524,7 +8524,7 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, char *buf)
 	put_smstate(u32, buf, 0x7ff0, kvm_rip_read(vcpu));
 
 	for (i = 0; i < 8; i++)
-		put_smstate(u32, buf, 0x7fd0 + i * 4, kvm_register_read(vcpu, i));
+		put_smstate(u32, buf, 0x7fd0 + i * 4, kvm_register_read_raw(vcpu, i));
 
 	kvm_get_dr(vcpu, 6, &val);
 	put_smstate(u32, buf, 0x7fcc, (u32)val);
@@ -8570,7 +8570,7 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
 	int i;
 
 	for (i = 0; i < 16; i++)
-		put_smstate(u64, buf, 0x7ff8 - i * 8, kvm_register_read(vcpu, i));
+		put_smstate(u64, buf, 0x7ff8 - i * 8, kvm_register_read_raw(vcpu, i));
 
 	put_smstate(u64, buf, 0x7f78, kvm_rip_read(vcpu));
 	put_smstate(u32, buf, 0x7f70, kvm_get_rflags(vcpu));
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 39eb04887141..ddf47a59054d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -222,19 +222,19 @@ static inline bool vcpu_match_mmio_gpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	return false;
 }
 
-static inline unsigned long kvm_register_readl(struct kvm_vcpu *vcpu, int reg)
+static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
 {
-	unsigned long val = kvm_register_read(vcpu, reg);
+	unsigned long val = kvm_register_read_raw(vcpu, reg);
 
 	return is_64_bit_mode(vcpu) ? val : (u32)val;
 }
 
-static inline void kvm_register_writel(struct kvm_vcpu *vcpu,
+static inline void kvm_register_write(struct kvm_vcpu *vcpu,
 				       int reg, unsigned long val)
 {
 	if (!is_64_bit_mode(vcpu))
 		val = (u32)val;
-	return kvm_register_write(vcpu, reg, val);
+	return kvm_register_write_raw(vcpu, reg, val);
 }
 
 static inline bool kvm_check_has_quirk(struct kvm *kvm, u64 quirk)
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 5bfed72edd07..af8f6562fce4 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -383,7 +383,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 	bool longmode;
 	u64 input, params[6];
 
-	input = (u64)kvm_register_readl(vcpu, VCPU_REGS_RAX);
+	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
 
 	/* Hyper-V hypercalls get bit 31 set in EAX */
 	if ((input & 0x80000000) &&
-- 
2.30.0.478.g8a0d178c01-goog

