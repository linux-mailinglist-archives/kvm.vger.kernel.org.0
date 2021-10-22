Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9090B437052
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 05:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbhJVDCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 23:02:18 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:51354 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232627AbhJVDCS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 23:02:18 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UtCHuz3_1634871598;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UtCHuz3_1634871598)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Oct 2021 10:59:58 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: VMX: fix instruction skipping when handling UD exception
Date:   Fri, 22 Oct 2021 10:59:56 +0800
Message-Id: <8ad4de9dae77ee3690ee9bd3c5a51d235d619eb6.1634870747.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634870747.git.houwenlong93@linux.alibaba.com>
References: <cover.1634870747.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When kvm.force_emulation_prefix is enabled, instruction with
kvm prefix would trigger an UD exception and do instruction
emulation. The emulation may need to exit to userspace due
to userspace io, and the complete_userspace_io callback may
skip instruction, i.e. MSR accesses emulation would exit to
userspace if userspace wanted to know about the MSR fault.
However, VM_EXIT_INSTRUCTION_LEN in vmcs is invalid now, it
should use kvm_emulate_instruction() to skip instruction.

Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 arch/x86/kvm/vmx/vmx.h | 9 +++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1c8b2b6e7ed9..01049d65da26 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1501,8 +1501,8 @@ static int skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 * (namely Hyper-V) don't set it due to it being undefined behavior,
 	 * i.e. we end up advancing IP with some random value.
 	 */
-	if (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
-	    exit_reason.basic != EXIT_REASON_EPT_MISCONFIG) {
+	if (!is_ud_exit(vcpu) && (!static_cpu_has(X86_FEATURE_HYPERVISOR) ||
+	    exit_reason.basic != EXIT_REASON_EPT_MISCONFIG)) {
 		instr_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
 
 		/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 592217fd7d92..e7a7f580acd1 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -481,6 +481,15 @@ static inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
 	return vmx->exit_intr_info;
 }
 
+static inline bool is_ud_exit(struct kvm_vcpu *vcpu)
+{
+	union vmx_exit_reason exit_reason = to_vmx(vcpu)->exit_reason;
+	u32 intr_info = vmx_get_intr_info(vcpu);
+
+	return exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
+	       is_invalid_opcode(intr_info);
+}
+
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
 void free_vmcs(struct vmcs *vmcs);
 int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
-- 
2.31.1

