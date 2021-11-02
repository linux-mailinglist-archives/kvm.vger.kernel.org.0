Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D489442A2F
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhKBJSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:18:22 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:33232 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231232AbhKBJSO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 05:18:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Uuk5J7D_1635844535;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0Uuk5J7D_1635844535)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Nov 2021 17:15:36 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] KVM: x86: Use different callback if msr access comes from the emulator
Date:   Tue,  2 Nov 2021 17:15:31 +0800
Message-Id: <34208da8f51580a06e45afefac95afea0e3f96e3.1635842679.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1635842679.git.houwenlong93@linux.alibaba.com>
References: <cover.1635842679.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If msr access triggers an exit to userspace, the
complete_userspace_io callback would skip instruction by vendor
callback for kvm_skip_emulated_instruction(). However, when msr
access comes from the emulator, e.g. if kvm.force_emulation_prefix
is enabled and the guest uses rdmsr/wrmsr with kvm prefix,
VM_EXIT_INSTRUCTION_LEN in vmcs is invalid and
kvm_emulate_instruction() should be used to skip instruction
instead.

As Sean noted, unlike the previous case, there's no #UD if
unrestricted guest is disabled and the guest accesses an MSR in
Big RM. So the correct way to fix this is to attach a different
callback when the msr access comes from the emulator.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/kvm/x86.c | 85 +++++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a961b49c8c44..5eadf5ddba3e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -116,6 +116,7 @@ static void enter_smm(struct kvm_vcpu *vcpu);
 static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
+static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu);
 
 static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
@@ -1814,18 +1815,45 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_set_msr);
 
-static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
+static void __complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
 {
-	int err = vcpu->run->msr.error;
-	if (!err) {
+	if (!vcpu->run->msr.error) {
 		kvm_rax_write(vcpu, (u32)vcpu->run->msr.data);
 		kvm_rdx_write(vcpu, vcpu->run->msr.data >> 32);
 	}
+}
+
+static int complete_emulated_msr_access(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->run->msr.error) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	return kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE | EMULTYPE_SKIP |
+				       EMULTYPE_COMPLETE_USER_EXIT);
+}
+
+static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
+{
+	__complete_emulated_rdmsr(vcpu);
 
-	return static_call(kvm_x86_complete_emulated_msr)(vcpu, err);
+	return complete_emulated_msr_access(vcpu);
 }
 
 static int complete_emulated_wrmsr(struct kvm_vcpu *vcpu)
+{
+	return complete_emulated_msr_access(vcpu);
+}
+
+static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
+{
+	__complete_emulated_rdmsr(vcpu);
+
+	return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run->msr.error);
+}
+
+static int complete_fast_wrmsr(struct kvm_vcpu *vcpu)
 {
 	return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run->msr.error);
 }
@@ -1864,18 +1892,6 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
 	return 1;
 }
 
-static int kvm_get_msr_user_space(struct kvm_vcpu *vcpu, u32 index, int r)
-{
-	return kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_RDMSR, 0,
-				   complete_emulated_rdmsr, r);
-}
-
-static int kvm_set_msr_user_space(struct kvm_vcpu *vcpu, u32 index, u64 data, int r)
-{
-	return kvm_msr_user_space(vcpu, index, KVM_EXIT_X86_WRMSR, data,
-				   complete_emulated_wrmsr, r);
-}
-
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 {
 	u32 ecx = kvm_rcx_read(vcpu);
@@ -1884,18 +1900,16 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 
 	r = kvm_get_msr(vcpu, ecx, &data);
 
-	/* MSR read failed? See if we should ask user space */
-	if (r && kvm_get_msr_user_space(vcpu, ecx, r)) {
-		/* Bounce to user space */
-		return 0;
-	}
-
 	if (!r) {
 		trace_kvm_msr_read(ecx, data);
 
 		kvm_rax_write(vcpu, data & -1u);
 		kvm_rdx_write(vcpu, (data >> 32) & -1u);
 	} else {
+		/* MSR read failed? See if we should ask user space */
+		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_RDMSR, 0,
+				       complete_fast_rdmsr, r))
+			return 0;
 		trace_kvm_msr_read_ex(ecx);
 	}
 
@@ -1911,19 +1925,18 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 
 	r = kvm_set_msr(vcpu, ecx, data);
 
-	/* MSR write failed? See if we should ask user space */
-	if (r && kvm_set_msr_user_space(vcpu, ecx, data, r))
-		/* Bounce to user space */
-		return 0;
-
-	/* Signal all other negative errors to userspace */
-	if (r < 0)
-		return r;
-
-	if (!r)
+	if (!r) {
 		trace_kvm_msr_write(ecx, data);
-	else
+	} else {
+		/* MSR write failed? See if we should ask user space */
+		if (kvm_msr_user_space(vcpu, ecx, KVM_EXIT_X86_WRMSR, data,
+				       complete_fast_wrmsr, r))
+			return 0;
+		/* Signal all other negative errors to userspace */
+		if (r < 0)
+			return r;
 		trace_kvm_msr_write_ex(ecx, data);
+	}
 
 	return static_call(kvm_x86_complete_emulated_msr)(vcpu, r);
 }
@@ -7387,7 +7400,8 @@ static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 
 	r = kvm_get_msr(vcpu, msr_index, pdata);
 
-	if (r && kvm_get_msr_user_space(vcpu, msr_index, r)) {
+	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
+				    complete_emulated_rdmsr, r)) {
 		/* Bounce to user space */
 		return X86EMUL_IO_NEEDED;
 	}
@@ -7403,7 +7417,8 @@ static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
 
 	r = kvm_set_msr(vcpu, msr_index, data);
 
-	if (r && kvm_set_msr_user_space(vcpu, msr_index, data, r)) {
+	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
+				    complete_emulated_wrmsr, r)) {
 		/* Bounce to user space */
 		return X86EMUL_IO_NEEDED;
 	}
-- 
2.31.1

