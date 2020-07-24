Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD2D22CA04
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 18:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgGXQFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 12:05:44 -0400
Received: from 8bytes.org ([81.169.241.247]:60312 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728169AbgGXQEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 12:04:44 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 7B931F3C;
        Fri, 24 Jul 2020 18:04:36 +0200 (CEST)
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
Subject: [PATCH v5 67/75] x86/realmode: Add SEV-ES specific trampoline entry point
Date:   Fri, 24 Jul 2020 18:03:28 +0200
Message-Id: <20200724160336.5435-68-joro@8bytes.org>
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

The code at the trampoline entry point is executed in real-mode. In
real-mode #VC exceptions can't be handled, so anything that might cause
such an exception must be avoided.

In the standard trampoline entry code this is the WBINVD instruction and
the call to verify_cpu(), which are both not needed anyway when running
as an SEV-ES guest.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/realmode.h      |  3 +++
 arch/x86/realmode/rm/header.S        |  3 +++
 arch/x86/realmode/rm/trampoline_64.S | 20 ++++++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realmode.h
index b35030eeec36..6590394af309 100644
--- a/arch/x86/include/asm/realmode.h
+++ b/arch/x86/include/asm/realmode.h
@@ -21,6 +21,9 @@ struct real_mode_header {
 	/* SMP trampoline */
 	u32	trampoline_start;
 	u32	trampoline_header;
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	u32	sev_es_trampoline_start;
+#endif
 #ifdef CONFIG_X86_64
 	u32	trampoline_pgd;
 #endif
diff --git a/arch/x86/realmode/rm/header.S b/arch/x86/realmode/rm/header.S
index af04512c02d9..8c1db5bf5d78 100644
--- a/arch/x86/realmode/rm/header.S
+++ b/arch/x86/realmode/rm/header.S
@@ -20,6 +20,9 @@ SYM_DATA_START(real_mode_header)
 	/* SMP trampoline */
 	.long	pa_trampoline_start
 	.long	pa_trampoline_header
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	.long	pa_sev_es_trampoline_start
+#endif
 #ifdef CONFIG_X86_64
 	.long	pa_trampoline_pgd;
 #endif
diff --git a/arch/x86/realmode/rm/trampoline_64.S b/arch/x86/realmode/rm/trampoline_64.S
index 251758ed7443..84c5d1b33d10 100644
--- a/arch/x86/realmode/rm/trampoline_64.S
+++ b/arch/x86/realmode/rm/trampoline_64.S
@@ -56,6 +56,7 @@ SYM_CODE_START(trampoline_start)
 	testl   %eax, %eax		# Check for return code
 	jnz	no_longmode
 
+.Lswitch_to_protected:
 	/*
 	 * GDT tables in non default location kernel can be beyond 16MB and
 	 * lgdt will not be able to load the address as in real mode default
@@ -80,6 +81,25 @@ no_longmode:
 	jmp no_longmode
 SYM_CODE_END(trampoline_start)
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+/* SEV-ES supports non-zero IP for entry points - no alignment needed */
+SYM_CODE_START(sev_es_trampoline_start)
+	cli			# We should be safe anyway
+
+	LJMPW_RM(1f)
+1:
+	mov	%cs, %ax	# Code and data in the same place
+	mov	%ax, %ds
+	mov	%ax, %es
+	mov	%ax, %ss
+
+	# Setup stack
+	movl	$rm_stack_end, %esp
+
+	jmp	.Lswitch_to_protected
+SYM_CODE_END(sev_es_trampoline_start)
+#endif	/* CONFIG_AMD_MEM_ENCRYPT */
+
 #include "../kernel/verify_cpu.S"
 
 	.section ".text32","ax"
-- 
2.27.0

