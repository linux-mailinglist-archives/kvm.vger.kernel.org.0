Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A00B22C9CA
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 18:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgGXQEX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 12:04:23 -0400
Received: from 8bytes.org ([81.169.241.247]:59420 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727834AbgGXQEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 12:04:21 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 8D88EFB8;
        Fri, 24 Jul 2020 18:04:12 +0200 (CEST)
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
Subject: [PATCH v5 30/75] x86/head/64: Setup MSR_GS_BASE before calling into C code
Date:   Fri, 24 Jul 2020 18:02:51 +0200
Message-Id: <20200724160336.5435-31-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200724160336.5435-1-joro@8bytes.org>
References: <20200724160336.5435-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When stack-protector is enabled a valid GS_BASE is needed before
calling any C code function, because the stack canary is loaded from
per-cpu data.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/head64.c  | 7 +++++++
 arch/x86/kernel/head_64.S | 8 ++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 8c82be44be94..b0ab5627900b 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -36,6 +36,7 @@
 #include <asm/microcode.h>
 #include <asm/kasan.h>
 #include <asm/fixmap.h>
+#include <asm/realmode.h>
 
 /*
  * Manage page tables very early on.
@@ -513,6 +514,8 @@ void __init x86_64_start_reservations(char *real_mode_data)
  */
 void __head startup_64_setup_env(unsigned long physbase)
 {
+	unsigned long gsbase;
+
 	/* Load GDT */
 	startup_gdt_descr.address = (unsigned long)fixup_pointer(startup_gdt, physbase);
 	native_load_gdt(&startup_gdt_descr);
@@ -521,4 +524,8 @@ void __head startup_64_setup_env(unsigned long physbase)
 	asm volatile("movl %%eax, %%ds\n"
 		     "movl %%eax, %%ss\n"
 		     "movl %%eax, %%es\n" : : "a"(__KERNEL_DS) : "memory");
+
+	/* Setup GS_BASE - needed for stack protector */
+	gsbase = (unsigned long)fixup_pointer((void *)initial_gs, physbase);
+	__wrmsr(MSR_GS_BASE, (u32)gsbase, (u32)(gsbase >> 32));
 }
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 2b2e91627221..800053219054 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -78,6 +78,14 @@ SYM_CODE_START_NOALIGN(startup_64)
 	call	startup_64_setup_env
 	popq	%rsi
 
+	/*
+	 * Setup %gs here already to make stack-protector work - it needs to be
+	 * setup again after the switch to kernel addresses. The address read
+	 * from initial_gs is a kernel address, so it needs to be adjusted first
+	 * for the identity mapping.
+	 */
+	movl	$MSR_GS_BASE,%ecx
+
 	/* Now switch to __KERNEL_CS so IRET works reliably */
 	pushq	$__KERNEL_CS
 	leaq	.Lon_kernel_cs(%rip), %rax
-- 
2.27.0

