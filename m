Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17510611DF6
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 01:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiJ1XKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 19:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiJ1XJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 19:09:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8DB3237F87
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 16:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666998474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YGfDYy2FKRGq+kLUF8iKroe6+TjvZzPPI1zHdOCFjiw=;
        b=a3nNTTPjKWynn6/OqhPXf3QJEkDdhjN+BhciK2HFmmoQKW1xsS4qg0EoouQZdPyOEgWfeh
        tu58bHJmM0jAYR/0YVTcHshhMc6VFXgFPeTNpb+aaddU79+VGWnXwSQFK3v30bUTYclLFa
        Jnx4WP3CpEczEzMzJNMV5o9tSoL7s+M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-nipQUrsKOqmwOy47cmzw3w-1; Fri, 28 Oct 2022 19:07:50 -0400
X-MC-Unique: nipQUrsKOqmwOy47cmzw3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21412858282;
        Fri, 28 Oct 2022 23:07:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0926340C94EE;
        Fri, 28 Oct 2022 23:07:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, jpoimboe@kernel.org
Subject: [PATCH 5/7] KVM: SVM: adjust register allocation for __svm_vcpu_run
Date:   Fri, 28 Oct 2022 19:07:21 -0400
Message-Id: <20221028230723.3254250-6-pbonzini@redhat.com>
In-Reply-To: <20221028230723.3254250-1-pbonzini@redhat.com>
References: <20221028230723.3254250-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for moving SPEC_CTRL access to __svm_vcpu_run,
keep the pointer to the struct vcpu_svm in %rdi, which is not
used by rdmsr/wrmsr.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/vmenter.S | 39 +++++++++++++++++++-------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 8fac744361e5..51a63a47d74f 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -53,30 +53,31 @@ SYM_FUNC_START(__svm_vcpu_run)
 	/* Save @vmcb. */
 	push %_ASM_ARG1
 
-	/* Move @svm to RAX. */
-	mov %_ASM_ARG2, %_ASM_AX
+	/* Move @svm to RDI. */
+	mov %_ASM_ARG2, %_ASM_DI
 
-	/* Load guest registers. */
-	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
-	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
-	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
-	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
-	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
-	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
-#ifdef CONFIG_X86_64
-	mov VCPU_R8 (%_ASM_AX),  %r8
-	mov VCPU_R9 (%_ASM_AX),  %r9
-	mov VCPU_R10(%_ASM_AX), %r10
-	mov VCPU_R11(%_ASM_AX), %r11
-	mov VCPU_R12(%_ASM_AX), %r12
-	mov VCPU_R13(%_ASM_AX), %r13
-	mov VCPU_R14(%_ASM_AX), %r14
-	mov VCPU_R15(%_ASM_AX), %r15
-#endif
 
 	/* "POP" @vmcb to RAX. */
 	pop %_ASM_AX
 
+	/* Load guest registers. */
+	mov VCPU_RCX(%_ASM_DI), %_ASM_CX
+	mov VCPU_RDX(%_ASM_DI), %_ASM_DX
+	mov VCPU_RBX(%_ASM_DI), %_ASM_BX
+	mov VCPU_RBP(%_ASM_DI), %_ASM_BP
+	mov VCPU_RSI(%_ASM_DI), %_ASM_SI
+#ifdef CONFIG_X86_64
+	mov VCPU_R8 (%_ASM_DI),  %r8
+	mov VCPU_R9 (%_ASM_DI),  %r9
+	mov VCPU_R10(%_ASM_DI), %r10
+	mov VCPU_R11(%_ASM_DI), %r11
+	mov VCPU_R12(%_ASM_DI), %r12
+	mov VCPU_R13(%_ASM_DI), %r13
+	mov VCPU_R14(%_ASM_DI), %r14
+	mov VCPU_R15(%_ASM_DI), %r15
+#endif
+	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
+
 	/* Enter guest mode */
 	sti
 
-- 
2.31.1


