Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D048C3337A7
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 09:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhCJIo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 03:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbhCJIn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 03:43:58 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C24C061762;
        Wed, 10 Mar 2021 00:43:55 -0800 (PST)
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 01E094CA;
        Wed, 10 Mar 2021 09:43:52 +0100 (CET)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 3/7] x86/boot/compressed/64: Setup IDT in startup_32 boot path
Date:   Wed, 10 Mar 2021 09:43:21 +0100
Message-Id: <20210310084325.12966-4-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210310084325.12966-1-joro@8bytes.org>
References: <20210310084325.12966-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This boot path needs exception handling when it is used with SEV-ES.
Setup an IDT and provide a helper function to write IDT entries for
use in 32-bit protected mode.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/head_64.S | 72 ++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index c59c80ca546d..2001c3bf0748 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -116,6 +116,9 @@ SYM_FUNC_START(startup_32)
 	lretl
 1:
 
+	/* Setup Exception handling for SEV-ES */
+	call	startup32_load_idt
+
 	/* Make sure cpu supports long mode. */
 	call	verify_cpu
 	testl	%eax, %eax
@@ -701,6 +704,19 @@ SYM_DATA_START(boot_idt)
 	.endr
 SYM_DATA_END_LABEL(boot_idt, SYM_L_GLOBAL, boot_idt_end)
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+SYM_DATA_START(boot32_idt_desc)
+	.word   boot32_idt_end - boot32_idt - 1
+	.long   0
+SYM_DATA_END(boot32_idt_desc)
+	.balign 8
+SYM_DATA_START(boot32_idt)
+	.rept 32
+	.quad 0
+	.endr
+SYM_DATA_END_LABEL(boot32_idt, SYM_L_GLOBAL, boot32_idt_end)
+#endif
+
 #ifdef CONFIG_EFI_STUB
 SYM_DATA(image_offset, .long 0)
 #endif
@@ -793,6 +809,62 @@ SYM_DATA_START_LOCAL(loaded_image_proto)
 SYM_DATA_END(loaded_image_proto)
 #endif
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	__HEAD
+	.code32
+/*
+ * Write an IDT entry into boot32_idt
+ *
+ * Parameters:
+ *
+ * %eax:	Handler address
+ * %edx:	Vector number
+ *
+ * Physical offset is expected in %ebp
+ */
+SYM_FUNC_START(startup32_set_idt_entry)
+	push    %ebx
+	push    %ecx
+
+	/* IDT entry address to %ebx */
+	leal    rva(boot32_idt)(%ebp), %ebx
+	shl	$3, %edx
+	addl    %edx, %ebx
+
+	/* Build IDT entry, lower 4 bytes */
+	movl    %eax, %edx
+	andl    $0x0000ffff, %edx	# Target code segment offset [15:0]
+	movl    $__KERNEL32_CS, %ecx	# Target code segment selector
+	shl     $16, %ecx
+	orl     %ecx, %edx
+
+	/* Store lower 4 bytes to IDT */
+	movl    %edx, (%ebx)
+
+	/* Build IDT entry, upper 4 bytes */
+	movl    %eax, %edx
+	andl    $0xffff0000, %edx	# Target code segment offset [31:16]
+	orl     $0x00008e00, %edx	# Present, Type 32-bit Interrupt Gate
+
+	/* Store upper 4 bytes to IDT */
+	movl    %edx, 4(%ebx)
+
+	pop     %ecx
+	pop     %ebx
+	ret
+SYM_FUNC_END(startup32_set_idt_entry)
+#endif
+
+SYM_FUNC_START(startup32_load_idt)
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	/* Load IDT */
+	leal	rva(boot32_idt)(%ebp), %eax
+	movl	%eax, rva(boot32_idt_desc+2)(%ebp)
+	lidt    rva(boot32_idt_desc)(%ebp)
+#endif
+	ret
+SYM_FUNC_END(startup32_load_idt)
+
 /*
  * Stack and heap for uncompression
  */
-- 
2.30.1

