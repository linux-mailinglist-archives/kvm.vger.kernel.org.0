Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAC721F0AF
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 14:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgGNMP3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 08:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728308AbgGNMKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 08:10:53 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC079C061755;
        Tue, 14 Jul 2020 05:10:52 -0700 (PDT)
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 2398AF19;
        Tue, 14 Jul 2020 14:10:49 +0200 (CEST)
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v4 30/75] x86/head/64: Install boot GDT
Date:   Tue, 14 Jul 2020 14:08:32 +0200
Message-Id: <20200714120917.11253-31-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714120917.11253-1-joro@8bytes.org>
References: <20200714120917.11253-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Handling exceptions during boot requires a working GDT. The kernel GDT
is not yet ready for use, so install a temporary boot GDT.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/head64.c  | 19 +++++++++++++++++++
 arch/x86/kernel/head_64.S | 20 ++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index cbb71c1b574f..51059bfd4b99 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -61,6 +61,25 @@ unsigned long vmemmap_base __ro_after_init = __VMEMMAP_BASE_L4;
 EXPORT_SYMBOL(vmemmap_base);
 #endif
 
+/*
+ * GDT used before %gs is set up and the kernel can use gdt_page. Needed for
+ * early exception handling.
+ */
+struct desc_struct boot_gdt[GDT_ENTRIES] = {
+	[GDT_ENTRY_KERNEL32_CS]         = GDT_ENTRY_INIT(0xc09b, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_CS]           = GDT_ENTRY_INIT(0xa09b, 0, 0xfffff),
+	[GDT_ENTRY_KERNEL_DS]           = GDT_ENTRY_INIT(0xc093, 0, 0xfffff),
+};
+
+/*
+ * Address needs to be set at runtime because it references the boot_gdt while
+ * the kernel still uses a direct mapping.
+ */
+struct desc_ptr boot_gdt_descr = {
+	.size = sizeof(boot_gdt),
+	.address = 0,
+};
+
 #define __head	__section(.head.text)
 
 static void __head *fixup_pointer(void *ptr, unsigned long physaddr)
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 16da4ac01597..473e60a12e2f 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -73,6 +73,26 @@ SYM_CODE_START_NOALIGN(startup_64)
 	/* Set up the stack for verify_cpu(), similar to initial_stack below */
 	leaq	(__end_init_task - SIZEOF_PTREGS)(%rip), %rsp
 
+	/* Setup boot GDT descriptor and load boot GDT */
+	leaq	boot_gdt(%rip), %rax
+	movq	%rax, boot_gdt_descr+2(%rip)
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
 
-- 
2.27.0

