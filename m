Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FE924F759
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 11:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbgHXJMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 05:12:42 -0400
Received: from 8bytes.org ([81.169.241.247]:37380 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729014AbgHXI4K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 04:56:10 -0400
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id DB23EF6F;
        Mon, 24 Aug 2020 10:56:06 +0200 (CEST)
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
Subject: [PATCH v6 36/76] x86/head/64: Load IDT earlier
Date:   Mon, 24 Aug 2020 10:54:31 +0200
Message-Id: <20200824085511.7553-37-joro@8bytes.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824085511.7553-1-joro@8bytes.org>
References: <20200824085511.7553-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Load the IDT right after switching to virtual addresses in head_64.S
so that the kernel can handle #VC exceptions.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20200724160336.5435-36-joro@8bytes.org
---
 arch/x86/include/asm/setup.h |  3 +++
 arch/x86/kernel/head64.c     |  3 +++
 arch/x86/kernel/head_64.S    |  5 +++++
 arch/x86/kernel/idt.c        | 23 +++++++++++++++++++++++
 4 files changed, 34 insertions(+)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 8aa6ba0427b0..5c09f50ecf1c 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -50,6 +50,8 @@ extern unsigned long __startup_64(unsigned long physaddr, struct boot_params *bp
 extern unsigned long __startup_secondary_64(void);
 extern void startup_64_setup_env(unsigned long physbase);
 extern int early_make_pgtable(unsigned long address);
+extern void early_idt_setup_early_handler(unsigned long physaddr);
+extern void early_load_idt(void);
 
 #ifdef CONFIG_X86_INTEL_MID
 extern void x86_intel_mid_early_setup(void);
@@ -66,6 +68,7 @@ static inline void x86_ce4100_early_setup(void) { }
 #ifndef _SETUP
 
 #include <asm/espfix.h>
+#include <asm/sections.h>
 #include <linux/kernel.h>
 
 /*
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 8703292a35e9..096b09d06d1c 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -286,6 +286,9 @@ unsigned long __head __startup_64(unsigned long physaddr,
 		}
 	}
 
+	/* Setup IDT with early handlers */
+	early_idt_setup_early_handler(physaddr);
+
 	/*
 	 * Return the SME encryption mask (if SME is active) to be used as a
 	 * modifier for the initial pgdir entry programmed into CR3.
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index a5e1939d1dc9..28de83fecda3 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -206,6 +206,11 @@ SYM_CODE_START(secondary_startup_64)
 	 */
 	movq initial_stack(%rip), %rsp
 
+	/* Load IDT */
+	pushq	%rsi
+	call	early_load_idt
+	popq	%rsi
+
 	/* Check if nx is implemented */
 	movl	$0x80000001, %eax
 	cpuid
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index c19773174221..e2777cc264f5 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -10,6 +10,7 @@
 #include <asm/proto.h>
 #include <asm/desc.h>
 #include <asm/hw_irq.h>
+#include <asm/setup.h>
 
 struct idt_data {
 	unsigned int	vector;
@@ -385,3 +386,25 @@ void __init alloc_intr_gate(unsigned int n, const void *addr)
 	if (!WARN_ON(test_and_set_bit(n, system_vectors)))
 		set_intr_gate(n, addr);
 }
+
+void __init early_idt_setup_early_handler(unsigned long physaddr)
+{
+	gate_desc *idt;
+	int i;
+
+	idt = fixup_pointer(idt_table, physaddr);
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
+
+void early_load_idt(void)
+{
+	load_idt(&idt_descr);
+}
-- 
2.28.0

