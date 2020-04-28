Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF421BC2DC
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgD1PTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:19:19 -0400
Received: from 8bytes.org ([81.169.241.247]:39078 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728452AbgD1PSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 11:18:22 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 3F236F4E; Tue, 28 Apr 2020 17:17:56 +0200 (CEST)
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
Subject: [PATCH v3 72/75] x86/head/64: Rename start_cpu0
Date:   Tue, 28 Apr 2020 17:17:22 +0200
Message-Id: <20200428151725.31091-73-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

For SEV-ES this entry point will be used for restarting APs after they
have been offlined. Remove the '0' from the name to reflect that.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/cpu.h | 2 +-
 arch/x86/kernel/head_32.S  | 4 ++--
 arch/x86/kernel/head_64.S  | 6 +++---
 arch/x86/kernel/smpboot.c  | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index dd17c2da1af5..427ae362bbdd 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -29,7 +29,7 @@ struct x86_cpu {
 #ifdef CONFIG_HOTPLUG_CPU
 extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
-extern void start_cpu0(void);
+extern void start_cpu(void);
 #ifdef CONFIG_DEBUG_HOTPLUG_CPU0
 extern int _debug_hotplug_cpu(int cpu, int action);
 #endif
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index f66a6b90f954..aad62c677486 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -174,12 +174,12 @@ SYM_CODE_END(startup_32)
  * up already except stack. We just set up stack here. Then call
  * start_secondary().
  */
-SYM_FUNC_START(start_cpu0)
+SYM_FUNC_START(start_cpu)
 	movl initial_stack, %ecx
 	movl %ecx, %esp
 	call *(initial_code)
 1:	jmp 1b
-SYM_FUNC_END(start_cpu0)
+SYM_FUNC_END(start_cpu)
 #endif
 
 /*
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 72b8f0834de1..4502f5d3b9b1 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -302,15 +302,15 @@ SYM_CODE_END(secondary_startup_64)
 
 #ifdef CONFIG_HOTPLUG_CPU
 /*
- * Boot CPU0 entry point. It's called from play_dead(). Everything has been set
+ * CPU entry point. It's called from play_dead(). Everything has been set
  * up already except stack. We just set up stack here. Then call
  * start_secondary() via .Ljump_to_C_code.
  */
-SYM_CODE_START(start_cpu0)
+SYM_CODE_START(start_cpu)
 	UNWIND_HINT_EMPTY
 	movq	initial_stack(%rip), %rsp
 	jmp	.Ljump_to_C_code
-SYM_CODE_END(start_cpu0)
+SYM_CODE_END(start_cpu)
 #endif
 
 	/* Both SMP bootup and ACPI suspend change these variables */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8c89e4d9ad28..f57685d81bb6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1721,7 +1721,7 @@ static inline void mwait_play_dead(void)
 		 * If NMI wants to wake up CPU0, start CPU0.
 		 */
 		if (wakeup_cpu0())
-			start_cpu0();
+			start_cpu();
 	}
 }
 
@@ -1736,7 +1736,7 @@ void hlt_play_dead(void)
 		 * If NMI wants to wake up CPU0, start CPU0.
 		 */
 		if (wakeup_cpu0())
-			start_cpu0();
+			start_cpu();
 	}
 }
 
-- 
2.17.1

