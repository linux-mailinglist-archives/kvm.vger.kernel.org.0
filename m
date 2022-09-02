Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871A85AA605
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbiIBCrL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231764AbiIBCrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:47:09 -0400
Received: from out0-143.mail.aliyun.com (out0-143.mail.aliyun.com [140.205.0.143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0A28C03F;
        Thu,  1 Sep 2022 19:47:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R651e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047203;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---.P5kqMp4_1662086823;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.P5kqMp4_1662086823)
          by smtp.aliyun-inc.com;
          Fri, 02 Sep 2022 10:47:03 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: x86: Return emulator error if RDMSR/WRMSR emulation failed
Date:   Fri, 02 Sep 2022 10:47:00 +0800
Message-Id: <09b2847fc3bcb8937fb11738f0ccf7be7f61d9dd.1661930557.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1661930557.git.houwenlong.hwl@antgroup.com>
References: <cover.1661930557.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The return value of emulator_{get|set}_mst_with_filter()
is confused, since msr access error and emulator error
are mixed. Although, KVM_MSR_RET_* doesn't conflict with
X86EMUL_IO_NEEDED at present, it is better to convert
msr access error to emulator error if error value is
needed. So move "r < 0" handling for wrmsr emulation
into the set helper function, then only X86EMUL_* is
returned in the helper functions. Also add "r < 0"
check in the get helper function, although KVM doesn't
return -errno today, but assuming that will always hold
true is unnecessarily risking.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/emulate.c | 20 ++++++++------------
 arch/x86/kvm/x86.c     | 26 ++++++++++++++++----------
 2 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f092c54d1a2f..d16f7d6a81bb 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3645,13 +3645,10 @@ static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
 		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
 	r = ctxt->ops->set_msr_with_filter(ctxt, msr_index, msr_data);
 
-	if (r == X86EMUL_IO_NEEDED)
-		return r;
-
-	if (r > 0)
+	if (r == X86EMUL_PROPAGATE_FAULT)
 		return emulate_gp(ctxt, 0);
 
-	return r < 0 ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
+	return r;
 }
 
 static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
@@ -3662,15 +3659,14 @@ static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
 
 	r = ctxt->ops->get_msr_with_filter(ctxt, msr_index, &msr_data);
 
-	if (r == X86EMUL_IO_NEEDED)
-		return r;
-
-	if (r)
+	if (r == X86EMUL_PROPAGATE_FAULT)
 		return emulate_gp(ctxt, 0);
 
-	*reg_write(ctxt, VCPU_REGS_RAX) = (u32)msr_data;
-	*reg_write(ctxt, VCPU_REGS_RDX) = msr_data >> 32;
-	return X86EMUL_CONTINUE;
+	if (r == X86EMUL_CONTINUE) {
+		*reg_write(ctxt, VCPU_REGS_RAX) = (u32)msr_data;
+		*reg_write(ctxt, VCPU_REGS_RDX) = msr_data >> 32;
+	}
+	return r;
 }
 
 static int em_store_sreg(struct x86_emulate_ctxt *ctxt, int segment)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..2596f5736743 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7920,14 +7920,17 @@ static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 	int r;
 
 	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
+	if (r < 0)
+		return X86EMUL_UNHANDLEABLE;
 
-	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
-				    complete_emulated_rdmsr, r)) {
-		/* Bounce to user space */
-		return X86EMUL_IO_NEEDED;
+	if (r) {
+		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
+				       complete_emulated_rdmsr, r))
+			return X86EMUL_IO_NEEDED;
+		return X86EMUL_PROPAGATE_FAULT;
 	}
 
-	return r;
+	return X86EMUL_CONTINUE;
 }
 
 static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
@@ -7937,14 +7940,17 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 	int r;
 
 	r = kvm_set_msr_with_filter(vcpu, msr_index, data);
+	if (r < 0)
+		return X86EMUL_UNHANDLEABLE;
 
-	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
-				    complete_emulated_msr_access, r)) {
-		/* Bounce to user space */
-		return X86EMUL_IO_NEEDED;
+	if (r) {
+		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
+				       complete_emulated_msr_access, r))
+			return X86EMUL_IO_NEEDED;
+		return X86EMUL_PROPAGATE_FAULT;
 	}
 
-	return r;
+	return X86EMUL_CONTINUE;
 }
 
 static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
-- 
2.31.1

