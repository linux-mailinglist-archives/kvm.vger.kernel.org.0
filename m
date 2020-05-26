Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9AE1A63CE
	for <lists+kvm@lfdr.de>; Mon, 13 Apr 2020 09:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgDMHuj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Apr 2020 03:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729435AbgDMHui (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Apr 2020 03:50:38 -0400
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA8BC008609
        for <kvm@vger.kernel.org>; Mon, 13 Apr 2020 00:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586764237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=zFvG+YcwjZoETKu4AwjE24+iK2LSK2xSQXF5Cz5Lw7U=;
        b=YehfLY2FaTXvsCK16gkvM5IcBjOG8nDJ7R1Vh38Fadyn0l701VLW146U6dXkFFtZsCxRW/
        NxtNEvAqcq8g/8nDgqScZFA0TNIN3hbqH/reidVJ7UHcWIkquE2LW4xxyMC6pegQgJYec6
        wYomoK3wzE060K7bXyP8+cObTRawVfE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-yGxMz_h3PrSrnuhHErAqTQ-1; Mon, 13 Apr 2020 03:50:35 -0400
X-MC-Unique: yGxMz_h3PrSrnuhHErAqTQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15806800D53;
        Mon, 13 Apr 2020 07:50:34 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9927F5C296;
        Mon, 13 Apr 2020 07:50:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     ubizjak@gmail.com
Subject: [PATCH] KVM: SVM: move more vmentry code to assembly
Date:   Mon, 13 Apr 2020 03:50:32 -0400
Message-Id: <20200413075032.5546-2-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Manipulate IF around vmload/vmsave to remove the confusing usage of
local_irq_enable where interrupts are actually disabled via GIF.
And stuff the RSB immediately without waiting for a RET to avoid
Spectre-v2 attacks.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/nospec-branch.h | 21 ---------------------
 arch/x86/kvm/svm/svm.c               |  7 -------
 arch/x86/kvm/svm/vmenter.S           |  9 +++++++++
 3 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 07e95dcb40ad..7e9a281e2660 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -237,27 +237,6 @@ enum ssb_mitigation {
 extern char __indirect_thunk_start[];
 extern char __indirect_thunk_end[];
 
-/*
- * On VMEXIT we must ensure that no RSB predictions learned in the guest
- * can be followed in the host, by overwriting the RSB completely. Both
- * retpoline and IBRS mitigations for Spectre v2 need this; only on future
- * CPUs with IBRS_ALL *might* it be avoided.
- */
-static inline void vmexit_fill_RSB(void)
-{
-#ifdef CONFIG_RETPOLINE
-	unsigned long loops;
-
-	asm volatile (ANNOTATE_NOSPEC_ALTERNATIVE
-		      ALTERNATIVE("jmp 910f",
-				  __stringify(__FILL_RETURN_BUFFER(%0, RSB_CLEAR_LOOPS, %1)),
-				  X86_FEATURE_RETPOLINE)
-		      "910:"
-		      : "=r" (loops), ASM_CALL_CONSTRAINT
-		      : : "memory" );
-#endif
-}
-
 static __always_inline
 void alternative_msr_write(unsigned int msr, u64 val, unsigned int feature)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2be5bbae3a40..117bb0b28535 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3330,13 +3330,8 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	local_irq_enable();
-
 	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
-	/* Eliminate branch target predictions from guest mode */
-	vmexit_fill_RSB();
-
 #ifdef CONFIG_X86_64
 	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
 #else
@@ -3366,8 +3361,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	reload_tss(vcpu);
 
-	local_irq_disable();
-
 	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	vcpu->arch.cr2 = svm->vmcb->save.cr2;
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index fa1af90067e9..723887e35e95 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -3,6 +3,7 @@
 #include <asm/asm.h>
 #include <asm/bitsperlong.h>
 #include <asm/kvm_vcpu_regs.h>
+#include <asm/nospec-branch.h>
 
 #define WORD_SIZE (BITS_PER_LONG / 8)
 
@@ -78,6 +79,7 @@ SYM_FUNC_START(__svm_vcpu_run)
 	pop %_ASM_AX
 
 	/* Enter guest mode */
+	sti
 1:	vmload %_ASM_AX
 	jmp 3f
 2:	cmpb $0, kvm_rebooting
@@ -99,6 +101,13 @@ SYM_FUNC_START(__svm_vcpu_run)
 	ud2
 	_ASM_EXTABLE(5b, 6b)
 7:
+	cli
+
+#ifdef CONFIG_RETPOLINE
+	/* IMPORTANT: Stuff the RSB immediately after VM-Exit, before RET! */
+	FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOPS, X86_FEATURE_RETPOLINE
+#endif
+
 	/* "POP" @regs to RAX. */
 	pop %_ASM_AX
 
-- 
2.18.2

