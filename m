Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C57A21F065
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 14:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgGNMMA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 08:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728595AbgGNMLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 08:11:20 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA51C061794;
        Tue, 14 Jul 2020 05:11:20 -0700 (PDT)
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 3BFD8FEA;
        Tue, 14 Jul 2020 14:11:11 +0200 (CEST)
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
Subject: [PATCH v4 69/75] x86/head/64: Setup TSS early for secondary CPUs
Date:   Tue, 14 Jul 2020 14:09:11 +0200
Message-Id: <20200714120917.11253-70-joro@8bytes.org>
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

The #VC exception will trigger very early in head_64.S, when the first
CPUID instruction is executed. When secondary CPUs boot, they already
load the real system IDT, which has the #VC handler configured to use an
IST stack. IST stacks require a TSS to be loaded, so set up the TSS
early for bringing up the secondary CPUs. Use the read-write version of
the per-CPU TSS struct early, until cpu_init() switches to the read-only
mapping.

On the boot CPU the TSS will also be loaded early, but not used as the
the early boot #VC handlers do not use IST stacks.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/head64.c  | 13 +++++++++++++
 arch/x86/kernel/head_64.S |  5 +++++
 2 files changed, 18 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 23d492091f3b..f57eefb1e4ba 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -545,6 +545,19 @@ void __head early_idt_setup_early_handler(unsigned long descr_addr, unsigned lon
 	}
 }
 
+void __head early_load_tss(void)
+{
+	struct desc_struct *gdt = (struct desc_struct *)boot_gdt;
+	struct tss_struct *tss = this_cpu_ptr(&cpu_tss_rw);
+	tss_desc tss_desc;
+
+	set_tssldt_descriptor(&tss_desc, (unsigned long)tss, DESC_TSS,
+			      __KERNEL_TSS_LIMIT);
+	native_write_gdt_entry(gdt, GDT_ENTRY_TSS, &tss_desc, DESC_TSS);
+
+	asm volatile("ltr %w0"::"q" (GDT_ENTRY_TSS*8));
+}
+
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 static void __head set_early_idt_handler(gate_desc *idt, int n, void *handler)
 {
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 3bd4c36d1d36..5b577d6bce7a 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -235,6 +235,11 @@ SYM_CODE_START(secondary_startup_64)
 	 */
 	movq initial_stack(%rip), %rsp
 
+	/* Setup a TSS for early IST handlers - needs %gs to be set up */
+	pushq	%rsi
+	call	early_load_tss
+	popq	%rsi
+
 	/* Load IDT */
 	lidt	idt_descr(%rip)
 
-- 
2.27.0

