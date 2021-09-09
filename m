Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8F0404967
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 13:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236296AbhIILjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 07:39:22 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:43989 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236022AbhIILjL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 07:39:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UnnR7jA_1631187479;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0UnnR7jA_1631187479)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Sep 2021 19:38:00 +0800
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
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH 3/3] kvm: x86: Emulate hypercall instead of fixing hypercall instruction
Date:   Thu,  9 Sep 2021 19:37:56 +0800
Message-Id: <9e4dc073caad1f098caf3c7dea06b9285a165602.1631186996.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631186996.git.houwenlong93@linux.alibaba.com>
References: <cover.1631186996.git.houwenlong93@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is guest's resposibility to use right instruction for hypercall,
hypervisor could emulate wrong instruction instead of modifying
guest's instruction.

Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/kvm/emulate.c     | 20 +++++++++-----------
 arch/x86/kvm/kvm_emulate.h |  2 +-
 arch/x86/kvm/x86.c         | 17 ++++++++---------
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2837110e66ed..671008a4ee20 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3732,13 +3732,11 @@ static int em_clts(struct x86_emulate_ctxt *ctxt)
 
 static int em_hypercall(struct x86_emulate_ctxt *ctxt)
 {
-	int rc = ctxt->ops->fix_hypercall(ctxt);
+	int rc = ctxt->ops->hypercall(ctxt);
 
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 
-	/* Let the processor re-execute the fixed hypercall */
-	ctxt->_eip = ctxt->eip;
 	/* Disable writeback. */
 	ctxt->dst.type = OP_NONE;
 	return X86EMUL_CONTINUE;
@@ -4298,14 +4296,14 @@ static const struct opcode group7_rm2[] = {
 };
 
 static const struct opcode group7_rm3[] = {
-	DIP(SrcNone | Prot | Priv,		vmrun,		check_svme_pa),
-	II(SrcNone  | Prot | EmulateOnUD,	em_hypercall,	vmmcall),
-	DIP(SrcNone | Prot | Priv,		vmload,		check_svme_pa),
-	DIP(SrcNone | Prot | Priv,		vmsave,		check_svme_pa),
-	DIP(SrcNone | Prot | Priv,		stgi,		check_svme),
-	DIP(SrcNone | Prot | Priv,		clgi,		check_svme),
-	DIP(SrcNone | Prot | Priv,		skinit,		check_svme),
-	DIP(SrcNone | Prot | Priv,		invlpga,	check_svme),
+	DIP(SrcNone | Prot | Priv,			vmrun,		check_svme_pa),
+	II(SrcNone  | Prot | Priv | EmulateOnUD,	em_hypercall,	vmmcall),
+	DIP(SrcNone | Prot | Priv,			vmload,		check_svme_pa),
+	DIP(SrcNone | Prot | Priv,			vmsave,		check_svme_pa),
+	DIP(SrcNone | Prot | Priv,			stgi,		check_svme),
+	DIP(SrcNone | Prot | Priv,			clgi,		check_svme),
+	DIP(SrcNone | Prot | Priv,			skinit,		check_svme),
+	DIP(SrcNone | Prot | Priv,			invlpga,	check_svme),
 };
 
 static const struct opcode group7_rm7[] = {
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 68b420289d7e..b090ec0688a6 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -216,7 +216,7 @@ struct x86_emulate_ops {
 	int (*read_pmc)(struct x86_emulate_ctxt *ctxt, u32 pmc, u64 *pdata);
 	void (*halt)(struct x86_emulate_ctxt *ctxt);
 	void (*wbinvd)(struct x86_emulate_ctxt *ctxt);
-	int (*fix_hypercall)(struct x86_emulate_ctxt *ctxt);
+	int (*hypercall)(struct x86_emulate_ctxt *ctxt);
 	int (*intercept)(struct x86_emulate_ctxt *ctxt,
 			 struct x86_instruction_info *info,
 			 enum x86_intercept_stage stage);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8d799e1c57c..aee3b08a1d85 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -329,7 +329,7 @@ static struct kmem_cache *kvm_alloc_emulator_cache(void)
 					  size - useroffset, NULL);
 }
 
-static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt);
+static int emulator_hypercall(struct x86_emulate_ctxt *ctxt);
 
 static inline void kvm_async_pf_hash_reset(struct kvm_vcpu *vcpu)
 {
@@ -7352,7 +7352,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.read_pmc            = emulator_read_pmc,
 	.halt                = emulator_halt,
 	.wbinvd              = emulator_wbinvd,
-	.fix_hypercall       = emulator_fix_hypercall,
+	.hypercall           = emulator_hypercall,
 	.intercept           = emulator_intercept,
 	.get_cpuid           = emulator_get_cpuid,
 	.guest_has_long_mode = emulator_guest_has_long_mode,
@@ -8747,16 +8747,15 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
 
-static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
+static int emulator_hypercall(struct x86_emulate_ctxt *ctxt)
 {
+	int ret;
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
-	char instruction[3];
-	unsigned long rip = kvm_rip_read(vcpu);
-
-	static_call(kvm_x86_patch_hypercall)(vcpu, instruction);
 
-	return emulator_write_emulated(ctxt, rip, instruction, 3,
-		&ctxt->exception);
+	ret = kvm_emulate_hypercall_noskip(vcpu);
+	if (ret)
+		return X86EMUL_CONTINUE;
+	return X86EMUL_IO_NEEDED;
 }
 
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
-- 
2.31.1

