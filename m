Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B1A611DEB
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 01:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiJ1XJC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 19:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiJ1XIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 19:08:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2058D23796E
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 16:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666998472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zQ/PQI7XSQLct7CzEIw/+Gp4LZYS8CDJyuAw8kMqneU=;
        b=Upx6xjI9pFrJDCCuur4YSJyUlPlSgwpHkgmR5YC4Wr/WXFd6Ntljr3tu5q9y+jGCvrLniw
        kskG7Ag5nj0Xsot4xSirYDwbpD1MY/oQGmY62XGguHVGoh3vFmT6PTTrih4rJkEcrhGM7R
        EDEcq7ngLhNLlf/0Tl8LUvuImO3NAeo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-78-UJN0IFByOlupsnLUO3FFRw-1; Fri, 28 Oct 2022 19:07:50 -0400
X-MC-Unique: UJN0IFByOlupsnLUO3FFRw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5403D811E67;
        Fri, 28 Oct 2022 23:07:45 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7F0840C947B;
        Fri, 28 Oct 2022 23:07:30 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com, jpoimboe@kernel.org
Subject: [PATCH 2/7] KVM: VMX: more cleanups to __vmx_vcpu_run
Date:   Fri, 28 Oct 2022 19:07:18 -0400
Message-Id: <20221028230723.3254250-3-pbonzini@redhat.com>
In-Reply-To: <20221028230723.3254250-1-pbonzini@redhat.com>
References: <20221028230723.3254250-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Slightly improve register allocation, loading vmx only once
before vmlaunch/vmresume.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmenter.S | 40 +++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 1362fe5859f9..0aea6b348a96 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -81,13 +81,12 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	 * there must not be any returns or indirect branches between this code
 	 * and vmentry.
 	 */
-	movl VMX_spec_ctrl(%_ASM_DI), %edi
+	movl VMX_spec_ctrl(%_ASM_DI), %eax
 	movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
-	cmp %edi, %esi
+	cmp %eax, %esi
 	je .Lspec_ctrl_done
 	mov $MSR_IA32_SPEC_CTRL, %ecx
 	xor %edx, %edx
-	mov %edi, %eax
 	wrmsr
 
 .Lspec_ctrl_done:
@@ -97,31 +96,28 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	 * an LFENCE to stop speculation from skipping the wrmsr.
 	 */
 
-	/* Load @vmx to RAX. */
-	mov WORD_SIZE(%_ASM_SP), %_ASM_AX
-
 	/* Check if vmlaunch or vmresume is needed */
 	testb $VMX_RUN_VMRESUME, %bl
 
 	/* Load guest registers.  Don't clobber flags. */
-	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
-	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
-	mov VCPU_RBX(%_ASM_AX), %_ASM_BX
-	mov VCPU_RBP(%_ASM_AX), %_ASM_BP
-	mov VCPU_RSI(%_ASM_AX), %_ASM_SI
-	mov VCPU_RDI(%_ASM_AX), %_ASM_DI
+	mov VCPU_RAX(%_ASM_DI), %_ASM_AX
+	mov VCPU_RCX(%_ASM_DI), %_ASM_CX
+	mov VCPU_RDX(%_ASM_DI), %_ASM_DX
+	mov VCPU_RBX(%_ASM_DI), %_ASM_BX
+	mov VCPU_RBP(%_ASM_DI), %_ASM_BP
+	mov VCPU_RSI(%_ASM_DI), %_ASM_SI
 #ifdef CONFIG_X86_64
-	mov VCPU_R8 (%_ASM_AX),  %r8
-	mov VCPU_R9 (%_ASM_AX),  %r9
-	mov VCPU_R10(%_ASM_AX), %r10
-	mov VCPU_R11(%_ASM_AX), %r11
-	mov VCPU_R12(%_ASM_AX), %r12
-	mov VCPU_R13(%_ASM_AX), %r13
-	mov VCPU_R14(%_ASM_AX), %r14
-	mov VCPU_R15(%_ASM_AX), %r15
+	mov VCPU_R8 (%_ASM_DI),  %r8
+	mov VCPU_R9 (%_ASM_DI),  %r9
+	mov VCPU_R10(%_ASM_DI), %r10
+	mov VCPU_R11(%_ASM_DI), %r11
+	mov VCPU_R12(%_ASM_DI), %r12
+	mov VCPU_R13(%_ASM_DI), %r13
+	mov VCPU_R14(%_ASM_DI), %r14
+	mov VCPU_R15(%_ASM_DI), %r15
 #endif
-	/* Load guest RAX.  This kills the @vmx pointer! */
-	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
+	/* Load guest RDI.  This kills the @vmx pointer! */
+	mov VCPU_RDI(%_ASM_DI), %_ASM_DI
 
 	/* Check EFLAGS.ZF from 'testb' above */
 	jz .Lvmlaunch
-- 
2.31.1


