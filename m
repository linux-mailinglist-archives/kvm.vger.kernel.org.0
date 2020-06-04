Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B921EE3A9
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 13:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgFDLs0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 07:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgFDLs0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 07:48:26 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F07C03E96D;
        Thu,  4 Jun 2020 04:48:26 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 21C4126F; Thu,  4 Jun 2020 13:48:23 +0200 (CEST)
Date:   Thu, 4 Jun 2020 13:48:21 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
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
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 31/75] x86/head/64: Install boot GDT
Message-ID: <20200604114821.GA30945@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-32-joro@8bytes.org>
 <20200518082313.GA25034@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518082313.GA25034@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 18, 2020 at 10:23:13AM +0200, Borislav Petkov wrote:
> On Tue, Apr 28, 2020 at 05:16:41PM +0200, Joerg Roedel wrote:
> > @@ -480,6 +500,22 @@ SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
> >  SYM_DATA(phys_base, .quad 0x0)
> >  EXPORT_SYMBOL(phys_base)
> >
> > +/* Boot GDT used when kernel addresses are not mapped yet */
> > +SYM_DATA_LOCAL(boot_gdt_descr,		.word boot_gdt_end - boot_gdt)
> > +SYM_DATA_LOCAL(boot_gdt_base,		.quad 0)
> > +SYM_DATA_START(boot_gdt)
> > +	.quad	0
> > +	.quad   0x00cf9a000000ffff	/* __KERNEL32_CS */
> > +	.quad   0x00af9a000000ffff	/* __KERNEL_CS */
> > +	.quad   0x00cf92000000ffff	/* __KERNEL_DS */
> > +	.quad	0			/* __USER32_CS - unused */
> > +	.quad	0			/* __USER_DS   - unused */
> > +	.quad	0			/* __USER_CS   - unused */
> > +	.quad	0			/* unused */
> > +	.quad   0x0080890000000000	/* TSS descriptor */
> > +	.quad   0x0000000000000000	/* TSS continued */
> 
> Any chance you could use macros ala GDT_ENTRY_INIT() for those instead
> of the naked values?

Yeah, seems to work. Updated patch attached.

From 1350746f9063147a33156c0b56a7b12b1794f555 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <jroedel@suse.de>
Date: Fri, 15 Nov 2019 13:49:55 +0100
Subject: [PATCH 31/74] x86/head/64: Install boot GDT

Handling exceptions during boot requires a working GDT. The kernel GDT
is not yet ready for use, so install a temporary boot GDT.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/head64.c  | 19 +++++++++++++++++++
 arch/x86/kernel/head_64.S | 25 +++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 206a4b6144c2..900c3372cc6a 100644
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
index 4bbc770af632..62513dd1e0e4 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -72,6 +72,26 @@ SYM_CODE_START_NOALIGN(startup_64)
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
 
@@ -143,6 +163,11 @@ SYM_CODE_START(secondary_startup_64)
 1:
 	UNWIND_HINT_EMPTY
 
+	/* Setup boot GDT descriptor and load boot GDT */
+	leaq	boot_gdt(%rip), %rax
+	movq	%rax, boot_gdt_descr+2(%rip)
+	lgdt	boot_gdt_descr(%rip)
+
 	/* Check if nx is implemented */
 	movl	$0x80000001, %eax
 	cpuid
-- 
2.26.2

