Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48EAB3163BE
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 11:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhBJKZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 05:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbhBJKWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 05:22:41 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F175CC06174A;
        Wed, 10 Feb 2021 02:22:00 -0800 (PST)
Received: from cap.home.8bytes.org (p549adcf6.dip0.t-ipconnect.de [84.154.220.246])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 27A3B48E;
        Wed, 10 Feb 2021 11:21:58 +0100 (CET)
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
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 6/7] x86/boot/compressed/64: Check SEV encryption in 32-bit boot-path
Date:   Wed, 10 Feb 2021 11:21:34 +0100
Message-Id: <20210210102135.30667-7-joro@8bytes.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210210102135.30667-1-joro@8bytes.org>
References: <20210210102135.30667-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Check whether the hypervisor reported the correct C-bit when running as
an SEV guest. Using a wrong C-bit position could be used to leak
sensitive data from the guest to the hypervisor.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/boot/compressed/head_64.S     | 80 ++++++++++++++++++++++++++
 arch/x86/boot/compressed/mem_encrypt.S |  1 +
 2 files changed, 81 insertions(+)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index eadaa0a082b8..047af1cba041 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -185,11 +185,18 @@ SYM_FUNC_START(startup_32)
 	 */
 	call	get_sev_encryption_bit
 	xorl	%edx, %edx
+#ifdef	CONFIG_AMD_MEM_ENCRYPT
 	testl	%eax, %eax
 	jz	1f
 	subl	$32, %eax	/* Encryption bit is always above bit 31 */
 	bts	%eax, %edx	/* Set encryption mask for page tables */
+	/*
+	 * Store the sme_me_mask as an indicator that SEV is active. It will be
+	 * set again in startup_64().
+	 */
+	movl	%edx, rva(sme_me_mask+4)(%ebp)
 1:
+#endif
 
 	/* Initialize Page tables to 0 */
 	leal	rva(pgtable)(%ebx), %edi
@@ -274,6 +281,9 @@ SYM_FUNC_START(startup_32)
 	movl	%esi, %edx
 1:
 #endif
+	/* Check if the C-bit position is correct when SEV is active */
+	call	sev_startup32_cbit_check
+
 	pushl	$__KERNEL_CS
 	pushl	%eax
 
@@ -870,6 +880,76 @@ SYM_FUNC_START(startup32_load_idt)
 	ret
 SYM_FUNC_END(startup32_load_idt)
 #endif
+
+/*
+ * Check for the correct C-bit position when the startup_32 boot-path is used.
+ *
+ * The check makes use of the fact that all memory is encrypted when paging is
+ * disabled. The function creates 64 bits of random data using the RDRAND
+ * instruction. RDRAND is mandatory for SEV guests, so always available. If the
+ * hypervisor violates that the kernel will crash right here.
+ *
+ * The 64 bits of random data are stored to a memory location and at the same
+ * time kept in the %eax and %ebx registers. Since encryption is always active
+ * when paging is off the random data will be stored encrypted in main memory.
+ *
+ * Then paging is enabled. When the C-bit position is correct all memory is
+ * still mapped encrypted and comparing the register values with memory will
+ * succeed. An incorrect C-bit position will map all memory unencrypted, so that
+ * the compare will use the encrypted random data and fail.
+ */
+SYM_FUNC_START(sev_startup32_cbit_check)
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	pushl	%eax
+	pushl	%ebx
+	pushl	%ecx
+	pushl	%edx
+
+	/* Check for non-zero sev_status */
+	movl	rva(sev_status)(%ebp), %eax
+	testl	%eax, %eax
+	jz	4f
+
+	/*
+	 * Get two 32-bit random values - Don't bail out if RDRAND fails
+	 * because it is better to prevent forward progress if no random value
+	 * can be gathered.
+	 */
+1:	rdrand	%eax
+	jnc	1b
+2:	rdrand	%ebx
+	jnc	2b
+
+	/* Store to memory and keep it in the registers */
+	movl	%eax, rva(sev_check_data)(%ebp)
+	movl	%ebx, rva(sev_check_data+4)(%ebp)
+
+	/* Enable paging to see if encryption is active */
+	movl	%cr0, %edx	/* Backup %cr0 in %edx */
+	movl	$(X86_CR0_PG | X86_CR0_PE), %ecx /* Enable Paging and Protected mode */
+	movl	%ecx, %cr0
+
+	cmpl	%eax, rva(sev_check_data)(%ebp)
+	jne	3f
+	cmpl	%ebx, rva(sev_check_data+4)(%ebp)
+	jne	3f
+
+	movl	%edx, %cr0	/* Restore previous %cr0 */
+
+	jmp	4f
+
+3:	/* Check failed - hlt the machine */
+	hlt
+	jmp	3b
+
+4:
+	popl	%edx
+	popl	%ecx
+	popl	%ebx
+	popl	%eax
+#endif
+	ret
+SYM_FUNC_END(sev_startup32_cbit_check)
 /*
  * Stack and heap for uncompression
  */
diff --git a/arch/x86/boot/compressed/mem_encrypt.S b/arch/x86/boot/compressed/mem_encrypt.S
index 091502cde070..b80fed167903 100644
--- a/arch/x86/boot/compressed/mem_encrypt.S
+++ b/arch/x86/boot/compressed/mem_encrypt.S
@@ -7,6 +7,7 @@
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  */
 
+#define rva(X) ((X) - startup_32)
 #include <linux/linkage.h>
 
 #include <asm/processor-flags.h>
-- 
2.30.0

