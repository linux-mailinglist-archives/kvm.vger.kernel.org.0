Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6A51BC31A
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgD1PSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:18:08 -0400
Received: from 8bytes.org ([81.169.241.247]:37428 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbgD1PSG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:18:06 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id DDC92F1C; Tue, 28 Apr 2020 17:17:48 +0200 (CEST)
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
Subject: [PATCH v3 36/75] x86/head/64: Load IDT earlier
Date:   Tue, 28 Apr 2020 17:16:46 +0200
Message-Id: <20200428151725.31091-37-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Load the IDT right after switching to virtual addresses in head_64.S
so that the kernel can handle #VC exceptions.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/head64.c  | 15 +++++++++++++++
 arch/x86/kernel/head_64.S | 17 +++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 206a4b6144c2..0ecdf28291fc 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -489,3 +489,18 @@ void __init x86_64_start_reservations(char *real_mode_data)
 
 	start_kernel();
 }
+
+void __head early_idt_setup_early_handler(unsigned long physaddr)
+{
+	gate_desc *idt = fixup_pointer(idt_table, physaddr);
+	int i;
+
+	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
+		struct idt_data data;
+		gate_desc desc;
+
+		init_idt_data(&data, i, early_idt_handler_array[i]);
+		idt_init_desc(&desc, &data);
+		native_write_idt_entry(idt, i, &desc);
+	}
+}
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 301a76f317f3..c63e6bd432da 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -104,6 +104,20 @@ SYM_CODE_START_NOALIGN(startup_64)
 	leaq	_text(%rip), %rdi
 	pushq	%rsi
 	call	__startup_64
+	/* Save return value */
+	pushq	%rax
+
+	/*
+	 * Load IDT with early handlers - needed for SEV-ES
+	 * Do this here because this must only happen on the boot CPU
+	 * and the code below is shared with secondary CPU bringup.
+	 */
+	leaq	_text(%rip), %rdi
+	call	early_idt_setup_early_handler
+
+	/* Restore __startup_64 return value*/
+	popq	%rax
+	/* Restore pointer to real_mode_data */
 	popq	%rsi
 
 	/* Form the CR3 value being sure to include the CR3 modifier */
@@ -200,6 +214,9 @@ SYM_CODE_START(secondary_startup_64)
 	 */
 	movq initial_stack(%rip), %rsp
 
+	/* Load IDT */
+	lidt	idt_descr(%rip)
+
 	/* Check if nx is implemented */
 	movl	$0x80000001, %eax
 	cpuid
-- 
2.17.1

