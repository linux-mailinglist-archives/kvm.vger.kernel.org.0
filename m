Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773F8442A2A
	for <lists+kvm@lfdr.de>; Tue,  2 Nov 2021 10:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhKBJSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Nov 2021 05:18:12 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:34012 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229720AbhKBJSL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Nov 2021 05:18:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UujaDv1_1635844534;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UujaDv1_1635844534)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 02 Nov 2021 17:15:35 +0800
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
Subject: [PATCH v2 2/4] KVM: x86: Add an emulation type to handle completion of user exits
Date:   Tue,  2 Nov 2021 17:15:30 +0800
Message-Id: <8f8c8e268b65f31d55c2881a4b30670946ecfa0d.1635842679.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1635842679.git.houwenlong93@linux.alibaba.com>
References: <cover.1635842679.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next patch would use kvm_emulate_instruction() with
EMULTYPE_SKIP in complete_userspace_io callback to fix a
problem in msr access emulation. However, EMULTYPE_SKIP
only updates RIP, more things like updating interruptibility
state and injecting single-step #DBs would be done in the
callback. Since the emulator also does those things after
x86_emulate_insn(), add a new emulation type to pair with
EMULTYPE_SKIP to do those things for completion of user exits
within the emulator.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h |  8 +++++++-
 arch/x86/kvm/x86.c              | 13 ++++++++++---
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 88fce6ab4bbd..b99e62b39097 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1635,7 +1635,8 @@ extern u64 kvm_mce_cap_supported;
  *
  * EMULTYPE_SKIP - Set when emulating solely to skip an instruction, i.e. to
  *		   decode the instruction length.  For use *only* by
- *		   kvm_x86_ops.skip_emulated_instruction() implementations.
+ *		   kvm_x86_ops.skip_emulated_instruction() implementations if
+ *		   EMULTYPE_COMPLETE_USER_EXIT is not set.
  *
  * EMULTYPE_ALLOW_RETRY_PF - Set when the emulator should resume the guest to
  *			     retry native execution under certain conditions,
@@ -1655,6 +1656,10 @@ extern u64 kvm_mce_cap_supported;
  *
  * EMULTYPE_PF - Set when emulating MMIO by way of an intercepted #PF, in which
  *		 case the CR2/GPA value pass on the stack is valid.
+ *
+ * EMULTYPE_COMPLETE_USER_EXIT - Set when the emulator should update interruptibility
+ *				 state and inject single-step #DBs after skipping
+ *				 an instruction (after completing userspace I/O).
  */
 #define EMULTYPE_NO_DECODE	    (1 << 0)
 #define EMULTYPE_TRAP_UD	    (1 << 1)
@@ -1663,6 +1668,7 @@ extern u64 kvm_mce_cap_supported;
 #define EMULTYPE_TRAP_UD_FORCED	    (1 << 4)
 #define EMULTYPE_VMWARE_GP	    (1 << 5)
 #define EMULTYPE_PF		    (1 << 6)
+#define EMULTYPE_COMPLETE_USER_EXIT (1 << 7)
 
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3d7fc5c21ceb..a961b49c8c44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8119,9 +8119,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	}
 
 	/*
-	 * Note, EMULTYPE_SKIP is intended for use *only* by vendor callbacks
-	 * for kvm_skip_emulated_instruction().  The caller is responsible for
-	 * updating interruptibility state and injecting single-step #DBs.
+	 * EMULTYPE_SKIP without EMULTYPE_COMPLETE_USER_EXIT is intended for
+	 * use *only* by vendor callbacks for kvm_skip_emulated_instruction().
+	 * The caller is responsible for updating interruptibility state and
+	 * injecting single-step #DBs.
 	 */
 	if (emulation_type & EMULTYPE_SKIP) {
 		if (ctxt->mode != X86EMUL_MODE_PROT64)
@@ -8129,6 +8130,11 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		else
 			ctxt->eip = ctxt->_eip;
 
+		if (emulation_type & EMULTYPE_COMPLETE_USER_EXIT) {
+			r = 1;
+			goto writeback;
+		}
+
 		kvm_rip_write(vcpu, ctxt->eip);
 		if (ctxt->eflags & X86_EFLAGS_RF)
 			kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
@@ -8198,6 +8204,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	else
 		r = 1;
 
+writeback:
 	if (writeback) {
 		unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
 		toggle_interruptibility(vcpu, ctxt->interruptibility);
-- 
2.31.1

