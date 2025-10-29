Return-Path: <kvm+bounces-61434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 968FAC1D839
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 22:50:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECF104043E6
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B0F2DCF78;
	Wed, 29 Oct 2025 21:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b="YB2SZvlX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B299274FE8
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 21:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761774637; cv=none; b=W5w4FwgIKGzghk5COeYA3usUUwaMjVGzqsI4d9dF/KRoxqhmSL8dmP/4QdvolnfO9flYjNEc4hhWcU6kpn5o8RHdWunG7thrMUliPZUen7iD+9loZ4NakFOlCOY7YUzWQ5cG8YtkJ3eIndhTJa0LiAjNQq67Ra0BrvqDqPNjBTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761774637; c=relaxed/simple;
	bh=iq0AGFyihtsKqgio62MQ8z5/NVAcZT0ULl3xYzwqCq8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ex/jwVhjtACeC4kgKpeHYauR/vmUOzVC8rL+G+Av2dSPkpEQ3qPcwK/ywa4HRPzZVRtdh8QSfjZwxgj7OqEwsakKqpIDRnFF/oDQ5DA5OqLz4rNX5mSjHbWqtXpd013rH0dTdI3vFfgFHqPMbbI8hQdS+XucVlKjKVpl3+o9wt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com; spf=none smtp.mailfrom=osandov.com; dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b=YB2SZvlX; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osandov.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7a27f2469b8so48585b3a.0
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 14:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1761774634; x=1762379434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oA/Fe1afu+0GIgAA+IsjNXNHdyIgEcFgCjgbpF+EbPI=;
        b=YB2SZvlXzhmdfOemk+bLwyUp5/AvqkR98nA6tcTOXA+sUfq/jzssLTWkN4vLDXXgSM
         Zpu8cdhChFHohz6FUUd9vE4Cl1+NcOYFhq8Ob+4Ppn6qxCDyWK996uz7NIMIcrJSt8WZ
         GNdVCZ/yWGaJOOYK7LYUf/KgrjrkFZjS4N5okUzeok4ejGtBiCV5k8LJNG33U3BCClkr
         Qa/lofBzes2ho/2QVQZKI9ooYq+J1McflkEo5mrTm8Jk3Rb3dYNNs2xBscLQGAmWoNtI
         IiA1cLbs81WFmFNKGVRuaXQVXDBPthr6OMBVGOXLuBJd9GCSeUCfQcvPByTrgs8KuXea
         SShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761774634; x=1762379434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oA/Fe1afu+0GIgAA+IsjNXNHdyIgEcFgCjgbpF+EbPI=;
        b=hWFtJqiKjz86E5gpCm452IEzEAyTk7H5zBJLQw9MvtSJlQqi7iJjhLyp/JQgBQ4s5s
         z1p5570gCn2oWL242qnz/M1bfimqfOiWUSxdAvtyjl5Hns/Coy/kRf8+uXPOcyFUwyf8
         pvrKSAjQ4vppfh1CDUMdL12GxjgUaFMlUXstojSpBDl8x1yv8oNjrq6Ap+h9djWr92jq
         LIjJto6kTFDGQn9b0kuU6ltgp+/Q857tM+PsBYVJbHFno62/tPtrOCx0eWwBbpWHGv0D
         cg9MBc+wK8yDzzhxJjF6Rw/UpU2NzaIIRjL/5bbnibUoDAkR2E9NspcP2BIxxiZT0Lmn
         BRRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWP1kO6zPcGIdDeolOiVkeepf8mrJvnuKjXvDGI8AH8u+/vYTpw32XYwpppqkJ1GclfTq0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwV8gcaOp2ctaNbBIm8O+vR3RN2T+5zmokTjZ5CYj+n9vMK/LUP
	3+Fs7RUG6mnAUHI4qQVxoE1D3JQSfXz6jlzHpneTFPTci7sk/ap9NibwsE28dhMg6Ts=
X-Gm-Gg: ASbGncsmgn5AUxwNc09PX0Ny8Wl4UU+B6U8ti2GcLva9ug3wKF7UWyBMTwpRmlGqIsI
	1j8zgfZIhpbIHE3Up1Cgdr2osTMTANNtnRmezzxhrxCWcsinkskoNMiIiVUSEG2UXnDObHcB3Hf
	7X13jOnpwCtE+PexM2lFGzsI8u2uqVrpioWmhoXYERPUQU0EXu1TAJU+Vs0fxWzisUXHbFWX8Hf
	Btoci5a1g5eIYUOG5kWN+yRt987dmoq7ndhVFpxeGEy2RzI4JbDUfQNz2SE2rGISqzTPbfXPPFB
	3Y5HfD9pTTLkRWyh5tc7TdcuXjPN63U7AUbiPLqCd8ZOAbk6vLh/o8XM89RTsaaPhqIb/IocN/D
	Fvs7aPRT1Aa1P64e+3gNLktBORWNEUyKdpgXw1CwpFUaDjDPI9suX8TrFQdsR7dAJlhko54yUrd
	vbXrzx6Dk+lTi9gig=
X-Google-Smtp-Source: AGHT+IGylPmTHWHLa2BFTUS6DAfKab8BgXiLAHtpcxLzxuNKsvAhckaKHkzU64p+lv3EmlrhWf1wBg==
X-Received: by 2002:a05:6a00:1404:b0:783:bb38:82f6 with SMTP id d2e1a72fcca58-7a4e0009473mr2830004b3a.0.1761774634381;
        Wed, 29 Oct 2025 14:50:34 -0700 (PDT)
Received: from telecaster.thefacebook.com ([2620:10d:c090:500::6:36f8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a41402e554sm16182145b3a.18.2025.10.29.14.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 14:50:33 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Cc: Gregory Price <gourry@gourry.net>,
	kernel-team@fb.com
Subject: [PATCH v2] KVM: SVM: Don't skip unrelated instruction if INT3/INTO is replaced
Date: Wed, 29 Oct 2025 14:50:26 -0700
Message-ID: <6ab4e8e5c5d6ea95f568a1ff8044779137dce428.1761774582.git.osandov@fb.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Omar Sandoval <osandov@fb.com>

When re-injecting a soft interrupt from an INT3, INT0, or (select) INTn
instruction, discard the exception and retry the instruction if the code
stream is changed (e.g. by a different vCPU) between when the CPU
executes the instruction and when KVM decodes the instruction to get the
next RIP.

As effectively predicted by commit 6ef88d6e36c2 ("KVM: SVM: Re-inject
INT3/INTO instead of retrying the instruction"), failure to verify that
the correct INTn instruction was decoded can effectively clobber guest
state due to decoding the wrong instruction and thus specifying the
wrong next RIP.

The bug most often manifests as "Oops: int3" panics on static branch
checks in Linux guests.  Enabling or disabling a static branch in Linux
uses the kernel's "text poke" code patching mechanism.  To modify code
while other CPUs may be executing that code, Linux (temporarily)
replaces the first byte of the original instruction with an int3 (opcode
0xcc), then patches in the new code stream except for the first byte,
and finally replaces the int3 with the first byte of the new code
stream.  If a CPU hits the int3, i.e. executes the code while it's being
modified, then the guest kernel must look up the RIP to determine how to
handle the #BP, e.g. by emulating the new instruction.  If the RIP is
incorrect, then this lookup fails and the guest kernel panics.

The bug reproduces almost instantly by hacking the guest kernel to
repeatedly check a static branch[1] while running a drgn script[2] on
the host to constantly swap out the memory containing the guest's TSS.

[1]: https://gist.github.com/osandov/44d17c51c28c0ac998ea0334edf90b5a
[2]: https://gist.github.com/osandov/10e45e45afa29b11e0c7209247afc00b

Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
Cc: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Changes from v1 (https://lore.kernel.org/all/71043b76fc073af0fb27493a8e8d7f38c3c782c0.1761606191.git.osandov@fb.com/):

- Incorporated Sean's suggested commit message (with some edits) and
  approach for implementing this in the generic KVM code instead (adding
  a comment for EMULTYPE_SKIP_SOFT_INT).
- Rebased on Linus's tree as of e53642b87a4f4b03a8d7e5f8507fc3cd0c595ea6.

 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/svm/svm.c          | 24 +++++++++++++-----------
 arch/x86/kvm/x86.c              | 21 +++++++++++++++++++++
 3 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..f0a61615b67b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2143,6 +2143,11 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
  *			     the gfn, i.e. retrying the instruction will hit a
  *			     !PRESENT fault, which results in a new shadow page
  *			     and sends KVM back to square one.
+ *
+ * EMULTYPE_SKIP_SOFT_INT - Set in combination with EMULTYPE_SKIP to only skip
+ *                          an instruction if it could generate a given software
+ *                          interrupt, which must be encoded via
+ *                          EMULTYPE_SET_SOFT_INT_VECTOR().
  */
 #define EMULTYPE_NO_DECODE	    (1 << 0)
 #define EMULTYPE_TRAP_UD	    (1 << 1)
@@ -2153,6 +2158,10 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
 #define EMULTYPE_PF		    (1 << 6)
 #define EMULTYPE_COMPLETE_USER_EXIT (1 << 7)
 #define EMULTYPE_WRITE_PF_TO_SP	    (1 << 8)
+#define EMULTYPE_SKIP_SOFT_INT	    (1 << 9)
+
+#define EMULTYPE_SET_SOFT_INT_VECTOR(v)	(((v) & 0xff) << 16)
+#define EMULTYPE_GET_SOFT_INT_VECTOR(e)	(((e) >> 16) & 0xff)
 
 static inline bool kvm_can_emulate_event_vectoring(int emul_type)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 153c12dbf3eb..a675585e6b1d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -272,6 +272,7 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 }
 
 static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
+					   int emul_type,
 					   bool commit_side_effects)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -293,7 +294,7 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 		if (unlikely(!commit_side_effects))
 			old_rflags = svm->vmcb->save.rflags;
 
-		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+		if (!kvm_emulate_instruction(vcpu, emul_type))
 			return 0;
 
 		if (unlikely(!commit_side_effects))
@@ -311,11 +312,13 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 
 static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-	return __svm_skip_emulated_instruction(vcpu, true);
+	return __svm_skip_emulated_instruction(vcpu, EMULTYPE_SKIP, true);
 }
 
-static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
+static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu, u8 vector)
 {
+	const int emul_type = EMULTYPE_SKIP | EMULTYPE_SKIP_SOFT_INT |
+			      EMULTYPE_GET_SOFT_INT_VECTOR(vector);
 	unsigned long rip, old_rip = kvm_rip_read(vcpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -331,7 +334,7 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 	 * in use, the skip must not commit any side effects such as clearing
 	 * the interrupt shadow or RFLAGS.RF.
 	 */
-	if (!__svm_skip_emulated_instruction(vcpu, !nrips))
+	if (!__svm_skip_emulated_instruction(vcpu, emul_type, !nrips))
 		return -EIO;
 
 	rip = kvm_rip_read(vcpu);
@@ -367,7 +370,7 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 	kvm_deliver_exception_payload(vcpu, ex);
 
 	if (kvm_exception_is_soft(ex->vector) &&
-	    svm_update_soft_interrupt_rip(vcpu))
+	    svm_update_soft_interrupt_rip(vcpu, ex->vector))
 		return;
 
 	svm->vmcb->control.event_inj = ex->vector
@@ -3637,11 +3640,12 @@ static bool svm_set_vnmi_pending(struct kvm_vcpu *vcpu)
 
 static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
+	struct kvm_queued_interrupt *intr = &vcpu->arch.interrupt;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 type;
 
-	if (vcpu->arch.interrupt.soft) {
-		if (svm_update_soft_interrupt_rip(vcpu))
+	if (intr->soft) {
+		if (svm_update_soft_interrupt_rip(vcpu, intr->nr))
 			return;
 
 		type = SVM_EVTINJ_TYPE_SOFT;
@@ -3649,12 +3653,10 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 		type = SVM_EVTINJ_TYPE_INTR;
 	}
 
-	trace_kvm_inj_virq(vcpu->arch.interrupt.nr,
-			   vcpu->arch.interrupt.soft, reinjected);
+	trace_kvm_inj_virq(intr->nr, intr->soft, reinjected);
 	++vcpu->stat.irq_injections;
 
-	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
-				       SVM_EVTINJ_VALID | type;
+	svm->vmcb->control.event_inj = intr->nr | SVM_EVTINJ_VALID | type;
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..9dc66cca154d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9338,6 +9338,23 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
 	return false;
 }
 
+static bool is_soft_int_instruction(struct x86_emulate_ctxt *ctxt,
+				    int emulation_type)
+{
+	u8 vector = EMULTYPE_GET_SOFT_INT_VECTOR(emulation_type);
+
+	switch (ctxt->b) {
+	case 0xcc:
+		return vector == BP_VECTOR;
+	case 0xcd:
+		return vector == ctxt->src.val;
+	case 0xce:
+		return vector == OF_VECTOR;
+	default:
+		return false;
+	}
+}
+
 /*
  * Decode an instruction for emulation.  The caller is responsible for handling
  * code breakpoints.  Note, manually detecting code breakpoints is unnecessary
@@ -9448,6 +9465,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * injecting single-step #DBs.
 	 */
 	if (emulation_type & EMULTYPE_SKIP) {
+		if (emulation_type & EMULTYPE_SKIP_SOFT_INT &&
+		    !is_soft_int_instruction(ctxt, emulation_type))
+			return 0;
+
 		if (ctxt->mode != X86EMUL_MODE_PROT64)
 			ctxt->eip = (u32)ctxt->_eip;
 		else
-- 
2.51.0


