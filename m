Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DEE3163BA
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 11:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhBJKZN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 05:25:13 -0500
Received: from 8bytes.org ([81.169.241.247]:55184 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhBJKWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 05:22:40 -0500
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 1FBD846E;
        Wed, 10 Feb 2021 11:21:57 +0100 (CET)
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 4/7] x86/boot/compressed/64: Add 32-bit boot #VC handler
Date:   Wed, 10 Feb 2021 11:21:32 +0100
Message-Id: <20210210102135.30667-5-joro@8bytes.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210210102135.30667-1-joro@8bytes.org>
References: <20210210102135.30667-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Add a #VC exception handler which is used when the kernel still executes
in protected mode. This boot-path already uses CPUID, which will cause #VC
exceptions in an SEV-ES guest.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/head_64.S     |  6 ++
 arch/x86/boot/compressed/mem_encrypt.S | 77 +++++++++++++++++++++++++-
 2 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 8deeec78cdb4..eadaa0a082b8 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -34,6 +34,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/bootparam.h>
 #include <asm/desc_defs.h>
+#include <asm/trapnr.h>
 #include "pgtable.h"
 
 /*
@@ -856,6 +857,11 @@ SYM_FUNC_START(startup32_set_idt_entry)
 SYM_FUNC_END(startup32_set_idt_entry)
 
 SYM_FUNC_START(startup32_load_idt)
+	/* #VC handler */
+	leal    rva(startup32_vc_handler)(%ebp), %eax
+	movl    $X86_TRAP_VC, %edx
+	call    startup32_set_idt_entry
+
 	/* Load IDT */
 	leal	rva(boot32_idt)(%ebp), %eax
 	movl	%eax, rva(boot32_idt_desc+2)(%ebp)
diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
index aa561795efd1..350ecb56c7e4 100644
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -67,10 +67,85 @@ SYM_FUNC_START(get_sev_encryption_bit)
 	ret
 SYM_FUNC_END(get_sev_encryption_bit)
 
+/*
+ * Emit code to request an CPUID register from the Hypervisor using
+ * the MSR-based protocol.
+ *
+ * fn: The register containing the CPUID function
+ * reg: Register requested
+ *	1 = EAX
+ *	2 = EBX
+ *	3 = ECX
+ *	4 = EDX
+ *
+ * Result is in EDX. Jumps to .Lfail on error
+ */
+.macro	SEV_ES_REQ_CPUID fn:req reg:req
+	/* Request CPUID[%ebx].EAX */
+	movl	$\reg, %eax
+	shll	$30, %eax
+	orl	$0x00000004, %eax
+	movl	\fn, %edx
+	movl	$MSR_AMD64_SEV_ES_GHCB, %ecx
+	wrmsr
+	rep; vmmcall
+	rdmsr
+	/* Check response code */
+	andl	$0xfff, %eax
+	cmpl	$5, %eax
+	jne	.Lfail
+	/* All good */
+.endm
+
+SYM_CODE_START(startup32_vc_handler)
+	pushl	%eax
+	pushl	%ebx
+	pushl	%ecx
+	pushl	%edx
+
+	/* Keep CPUID function in %ebx */
+	movl	%eax, %ebx
+
+	/* Check if error-code == SVM_EXIT_CPUID */
+	cmpl	$0x72, 16(%esp)
+	jne	.Lfail
+
+	/* Request CPUID[%ebx].EAX */
+	SEV_ES_REQ_CPUID fn=%ebx reg=0
+	movl	%edx, 12(%esp)
+
+	/* Request CPUID[%ebx].EBX */
+	SEV_ES_REQ_CPUID fn=%ebx reg=1
+	movl	%edx, 8(%esp)
+
+	/* Request CPUID[%ebx].ECX */
+	SEV_ES_REQ_CPUID fn=%ebx reg=2
+	movl	%edx, 4(%esp)
+
+	/* Request CPUID[%ebx].EDX */
+	SEV_ES_REQ_CPUID fn=%ebx reg=3
+	movl	%edx, (%esp)
+
+	popl	%edx
+	popl	%ecx
+	popl	%ebx
+	popl	%eax
+
+	/* Remove error code */
+	addl	$4, %esp
+
+	/* Jump over CPUID instruction */
+	addl	$2, (%esp)
+
+	iret
+.Lfail:
+	hlt
+	jmp .Lfail
+SYM_CODE_END(startup32_vc_handler)
+
 	.code64
 
 #include "../../kernel/sev_verify_cbit.S"
-
 SYM_FUNC_START(set_sev_encryption_mask)
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 	push	%rbp
-- 
2.30.0

