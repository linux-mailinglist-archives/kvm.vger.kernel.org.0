Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E2422C9D1
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 18:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgGXQEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 12:04:24 -0400
Received: from 8bytes.org ([81.169.241.247]:60034 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgGXQEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 12:04:23 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 0031BFBB;
        Fri, 24 Jul 2020 18:04:13 +0200 (CEST)
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
Subject: [PATCH v5 32/75] x86/head/64: Load segment registers earlier
Date:   Fri, 24 Jul 2020 18:02:53 +0200
Message-Id: <20200724160336.5435-33-joro@8bytes.org>
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

Make sure segments are properly set up before setting up an IDT and
doing anything that might cause a #VC exception. This is later needed
for early exception handling.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/kernel/head_64.S | 52 +++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index f958d4e4ee08..057c7bd3eeb6 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -174,6 +174,32 @@ SYM_CODE_START(secondary_startup_64)
 	 */
 	lgdt	early_gdt_descr(%rip)
 
+	/* set up data segments */
+	xorl %eax,%eax
+	movl %eax,%ds
+	movl %eax,%ss
+	movl %eax,%es
+
+	/*
+	 * We don't really need to load %fs or %gs, but load them anyway
+	 * to kill any stale realmode selectors.  This allows execution
+	 * under VT hardware.
+	 */
+	movl %eax,%fs
+	movl %eax,%gs
+
+	/* Set up %gs.
+	 *
+	 * The base of %gs always points to fixed_percpu_data. If the
+	 * stack protector canary is enabled, it is located at %gs:40.
+	 * Note that, on SMP, the boot cpu uses init data section until
+	 * the per cpu areas are set up.
+	 */
+	movl	$MSR_GS_BASE,%ecx
+	movl	initial_gs(%rip),%eax
+	movl	initial_gs+4(%rip),%edx
+	wrmsr
+
 	/* Check if nx is implemented */
 	movl	$0x80000001, %eax
 	cpuid
@@ -201,32 +227,6 @@ SYM_CODE_START(secondary_startup_64)
 	pushq $0
 	popfq
 
-	/* set up data segments */
-	xorl %eax,%eax
-	movl %eax,%ds
-	movl %eax,%ss
-	movl %eax,%es
-
-	/*
-	 * We don't really need to load %fs or %gs, but load them anyway
-	 * to kill any stale realmode selectors.  This allows execution
-	 * under VT hardware.
-	 */
-	movl %eax,%fs
-	movl %eax,%gs
-
-	/* Set up %gs.
-	 *
-	 * The base of %gs always points to fixed_percpu_data. If the
-	 * stack protector canary is enabled, it is located at %gs:40.
-	 * Note that, on SMP, the boot cpu uses init data section until
-	 * the per cpu areas are set up.
-	 */
-	movl	$MSR_GS_BASE,%ecx
-	movl	initial_gs(%rip),%eax
-	movl	initial_gs+4(%rip),%edx
-	wrmsr
-
 	/* rsi is pointer to real mode structure with interesting info.
 	   pass it to C */
 	movq	%rsi, %rdi
-- 
2.27.0

