Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A98DC1BC32E
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgD1PWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:22:50 -0400
Received: from 8bytes.org ([81.169.241.247]:37386 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728263AbgD1PSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:18:03 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id E526AF0E; Tue, 28 Apr 2020 17:17:47 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
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
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 31/75] x86/head/64: Install boot GDT
Date:   Tue, 28 Apr 2020 17:16:41 +0200
Message-Id: <20200428151725.31091-32-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Handling exceptions during boot requires a working GDT. The kernel GDT
is not yet ready for use, so install a temporary boot GDT.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/head_64.S | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 4bbc770af632..11a28c1fb51f 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -72,6 +72,26 @@ SYM_CODE_START_NOALIGN(startup_64)
 	/* Set up the stack for verify_cpu(), similar to initial_stack below */
 	leaq	(__end_init_task - SIZEOF_PTREGS)(%rip), %rsp
 
+	/* Setup boot GDT descriptor and load boot GDT */
+	leaq	boot_gdt(%rip), %rax
+	movq	%rax, boot_gdt_base(%rip)
+	lgdt	boot_gdt_descr(%rip)
+
+	/* New GDT is live - reload data segment registers */
+	movl	$__KERNEL_DS, %eax
+	movl	%eax, %ds
+	movl	%eax, %ss
+	movl	%eax, %es
+
+	/* Now switch to __KERNEL_CS so IRET works reliably */
+	pushq	$__KERNEL_CS
+	leaq	.Lon_kernel_cs(%rip), %rax
+	pushq	%rax
+	lretq
+
+.Lon_kernel_cs:
+	UNWIND_HINT_EMPTY
+
 	/* Sanitize CPU configuration */
 	call verify_cpu
 
@@ -480,6 +500,22 @@ SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
 SYM_DATA(phys_base, .quad 0x0)
 EXPORT_SYMBOL(phys_base)
 
+/* Boot GDT used when kernel addresses are not mapped yet */
+SYM_DATA_LOCAL(boot_gdt_descr,		.word boot_gdt_end - boot_gdt)
+SYM_DATA_LOCAL(boot_gdt_base,		.quad 0)
+SYM_DATA_START(boot_gdt)
+	.quad	0
+	.quad   0x00cf9a000000ffff	/* __KERNEL32_CS */
+	.quad   0x00af9a000000ffff	/* __KERNEL_CS */
+	.quad   0x00cf92000000ffff	/* __KERNEL_DS */
+	.quad	0			/* __USER32_CS - unused */
+	.quad	0			/* __USER_DS   - unused */
+	.quad	0			/* __USER_CS   - unused */
+	.quad	0			/* unused */
+	.quad   0x0080890000000000	/* TSS descriptor */
+	.quad   0x0000000000000000	/* TSS continued */
+SYM_DATA_END_LABEL(boot_gdt, SYM_L_LOCAL, boot_gdt_end)
+
 #include "../../x86/xen/xen-head.S"
 
 	__PAGE_ALIGNED_BSS
-- 
2.17.1

