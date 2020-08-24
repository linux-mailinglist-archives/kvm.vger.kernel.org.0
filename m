Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E36624F6AD
	for <lists+kvm@lfdr.de>; Mon, 24 Aug 2020 11:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbgHXJC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Aug 2020 05:02:26 -0400
Received: from 8bytes.org ([81.169.241.247]:37840 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730574AbgHXI4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Aug 2020 04:56:38 -0400
Received: from cap.home.8bytes.org (p4ff2bb8d.dip0.t-ipconnect.de [79.242.187.141])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 248CC12E7;
        Mon, 24 Aug 2020 10:56:30 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        Kees Cook <keescook@chromium.org>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v6 72/76] x86/head/64: Rename start_cpu0
Date:   Mon, 24 Aug 2020 10:55:07 +0200
Message-Id: <20200824085511.7553-73-joro@8bytes.org>
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

For SEV-ES this entry point will be used for restarting APs after they
have been offlined. Remove the '0' from the name to reflect that.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20200724160336.5435-72-joro@8bytes.org
---
 arch/x86/include/asm/cpu.h | 2 +-
 arch/x86/kernel/head_32.S  | 4 ++--
 arch/x86/kernel/head_64.S  | 6 +++---
 arch/x86/kernel/smpboot.c  | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index da78ccbd493b..1536b607971f 100644
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
index 7ed84c282233..f63e1b7f4141 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -143,12 +143,12 @@ SYM_CODE_END(startup_32)
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
index a708107688a2..352311c5d8d1 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -309,15 +309,15 @@ SYM_CODE_END(secondary_startup_64)
 
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
index fb55d28332e2..c6311c55b84c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1726,7 +1726,7 @@ static inline void mwait_play_dead(void)
 		 * If NMI wants to wake up CPU0, start CPU0.
 		 */
 		if (wakeup_cpu0())
-			start_cpu0();
+			start_cpu();
 	}
 }
 
@@ -1741,7 +1741,7 @@ void hlt_play_dead(void)
 		 * If NMI wants to wake up CPU0, start CPU0.
 		 */
 		if (wakeup_cpu0())
-			start_cpu0();
+			start_cpu();
 	}
 }
 
-- 
2.28.0

