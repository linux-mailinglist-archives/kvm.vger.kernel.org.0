Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7763337AD
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 09:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbhCJIoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 03:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhCJIn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 03:43:58 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC4AC061763;
        Wed, 10 Mar 2021 00:43:56 -0800 (PST)
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id A10D44DB;
        Wed, 10 Mar 2021 09:43:53 +0100 (CET)
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
Subject: [PATCH v2 4/7] x86/boot/compressed/64: Add 32-bit boot #VC handler
Date:   Wed, 10 Mar 2021 09:43:22 +0100
Message-Id: <20210310084325.12966-5-joro@8bytes.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210310084325.12966-1-joro@8bytes.org>
References: <20210310084325.12966-1-joro@8bytes.org>
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
 arch/x86/boot/compressed/mem_encrypt.S | 96 +++++++++++++++++++++++++-
 2 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2001c3bf0748..ee448aedb8b0 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -34,6 +34,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/bootparam.h>
 #include <asm/desc_defs.h>
+#include <asm/trapnr.h>
 #include "pgtable.h"
 
 /*
@@ -857,6 +858,11 @@ SYM_FUNC_END(startup32_set_idt_entry)
 
 SYM_FUNC_START(startup32_load_idt)
 #ifdef CONFIG_AMD_MEM_ENCRYPT
+	/* #VC handler */
+	leal    rva(startup32_vc_handler)(%ebp), %eax
+	movl    $X86_TRAP_VC, %edx
+	call    startup32_set_idt_entry
+
 	/* Load IDT */
 	leal	rva(boot32_idt)(%ebp), %eax
 	movl	%eax, rva(boot32_idt_desc+2)(%ebp)
diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
index aa561795efd1..2ca056a3707c 100644
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -67,10 +67,104 @@ SYM_FUNC_START(get_sev_encryption_bit)
 	ret
 SYM_FUNC_END(get_sev_encryption_bit)
 
+/**
+ * sev_es_req_cpuid - Request a CPUID value from the Hypervisor using
+ *		      the GHCB MSR protocol
+ *
+ * @%eax:	Register to request (0=EAX, 1=EBX, 2=ECX, 3=EDX)
+ * @%edx:	CPUID Function
+ *
+ * Returns 0 in %eax on sucess, non-zero on failure
+ * %edx returns CPUID value on success
+ */
+SYM_CODE_START_LOCAL(sev_es_req_cpuid)
+	shll	$30, %eax
+	orl     $0x00000004, %eax
+	movl    $MSR_AMD64_SEV_ES_GHCB, %ecx
+	wrmsr
+	rep; vmmcall		# VMGEXIT
+	rdmsr
+
+	/* Check response */
+	movl	%eax, %ecx
+	andl	$0x3ffff000, %ecx	# Bits [12-29] MBZ
+	jnz	2f
+
+	/* Check return code */
+	andl    $0xfff, %eax
+	cmpl    $5, %eax
+	jne	2f
+
+	/* All good - return success */
+	xorl	%eax, %eax
+1:
+	ret
+2:
+	movl	$-1, %eax
+	jmp	1b
+SYM_CODE_END(sev_es_req_cpuid)
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
+	movl	$0, %eax		# Request CPUID[fn].EAX
+	movl	%ebx, %edx		# CPUID fn
+	call	sev_es_req_cpuid	# Call helper
+	testl	%eax, %eax		# Check return code
+	jnz	.Lfail
+	movl	%edx, 12(%esp)		# Store result
+
+	movl	$1, %eax		# Request CPUID[fn].EBX
+	movl	%ebx, %edx		# CPUID fn
+	call	sev_es_req_cpuid	# Call helper
+	testl	%eax, %eax		# Check return code
+	jnz	.Lfail
+	movl	%edx, 8(%esp)		# Store result
+
+	movl	$2, %eax		# Request CPUID[fn].ECX
+	movl	%ebx, %edx		# CPUID fn
+	call	sev_es_req_cpuid	# Call helper
+	testl	%eax, %eax		# Check return code
+	jnz	.Lfail
+	movl	%edx, 4(%esp)		# Store result
+
+	movl	$3, %eax		# Request CPUID[fn].EDX
+	movl	%ebx, %edx		# CPUID fn
+	call	sev_es_req_cpuid	# Call helper
+	testl	%eax, %eax		# Check return code
+	jnz	.Lfail
+	movl	%edx, 0(%esp)		# Store result
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
2.30.1

