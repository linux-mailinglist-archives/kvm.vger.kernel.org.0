Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42C118AF5B
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 10:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgCSJPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 05:15:55 -0400
Received: from 8bytes.org ([81.169.241.247]:52476 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727504AbgCSJOr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 05:14:47 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 32B06ED8; Thu, 19 Mar 2020 10:14:28 +0100 (CET)
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 64/70] x86/realmode: Add SEV-ES specific trampoline entry point
Date:   Thu, 19 Mar 2020 10:14:01 +0100
Message-Id: <20200319091407.1481-65-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319091407.1481-1-joro@8bytes.org>
References: <20200319091407.1481-1-joro@8bytes.org>
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
2.17.1

