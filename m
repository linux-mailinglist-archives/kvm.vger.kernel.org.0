Return-Path: <kvm+bounces-53534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 033B0B13A7B
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 14:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D95DB170FCF
	for <lists+kvm@lfdr.de>; Mon, 28 Jul 2025 12:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEA4F265CAA;
	Mon, 28 Jul 2025 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hizi4mMN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4C026563C;
	Mon, 28 Jul 2025 12:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753705743; cv=none; b=igSiYLEw0XjDbh1hTIIwnh8bzXIm0rDpvDH7B0UsGV50xba+4PjFtH+8HJu/9L9dPSN4V/rBDdZHI84vNjh30Ptv9itzzpoYwXMZJ5FWBjYTFp1sSxn+ronb4CU+iZYfNCEvkI7y3mhl2F8QDnF3+v2Nj58B92EBFSDxPNYCuaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753705743; c=relaxed/simple;
	bh=zPp2F2i+Po0uyGj+tTdxebQGCP+/7nZdEvYd3tuPUbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AL1QpmJvbdN7WhfazPqoF+1QjoWKYEF3BCYSeuHxXNVPzkvgm6R7hLQLvEcH+EOQFFHhEnpPtli2L+Mdf2f1lV6w7HIFkW2gIV4msMYz2AhyJ2VYF0/MhzMUxjO6r+isa7NugToYojM6Nt9P/wYoJC4y5ofr3JXYLJ8uv3uDn0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hizi4mMN; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753705742; x=1785241742;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zPp2F2i+Po0uyGj+tTdxebQGCP+/7nZdEvYd3tuPUbo=;
  b=hizi4mMNOiXCvjoniJSfZMNiFIfFd+bzTMCJOqwj7Q+y8JSwxC87m+MP
   Gmz9c0yZl+Ko3dflggOC7Vaou6vm4DGig3wPUIFa86b9JS7tJ3p6RHvYY
   /HLMhVQYilqZMqphvV5uOWouGX1vdCw8HGaOTlmjSOta648+TG82TCVpW
   Zmdgtan6AJ0tuUYMwii7f5hk8E2puSPFOxnWdy3TG96X/YYatPoIwX891
   hu9G3I+4D69E181ucYkPcbsUxF2nmqlsImaBA5IrCLfXf1bfBurunppz2
   8V2CWl1LSUMPdsEVCfx0Y4aUv4Nek7yIjSQnuC/22TlF+Kjdr1c9bOGOu
   Q==;
X-CSE-ConnectionGUID: uBICTQ86RYm48OJEQWxtvQ==
X-CSE-MsgGUID: sLEYCaf6RGateEmCMd6YTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11504"; a="56043300"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="56043300"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 05:29:01 -0700
X-CSE-ConnectionGUID: lWjsCdmtS8ikJPDDlRgE7g==
X-CSE-MsgGUID: sqzoC42IQQOmCgtMs/urVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="193375589"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.220.205])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2025 05:28:56 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com
Subject: [PATCH v5 1/7] x86/kexec: Consolidate relocate_kernel() function parameters
Date: Tue, 29 Jul 2025 00:28:35 +1200
Message-ID: <48b3b8dc2ece4095d29f21a439664c0302f3c979.1753679792.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1753679792.git.kai.huang@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During kexec, the kernel jumps to the new kernel in relocate_kernel(),
which is implemented in assembly and both 32-bit and 64-bit have their
own version.

Currently, for both 32-bit and 64-bit, the last two parameters of the
relocate_kernel() are both 'unsigned int' but actually they only convey
a boolean, i.e., one bit information.  The 'unsigned int' has enough
space to carry two bits information therefore there's no need to pass
the two booleans in two separate 'unsigned int'.

Consolidate the last two function parameters of relocate_kernel() into a
single 'unsigned int' and pass flags instead.

Only consolidate the 64-bit version albeit the similar optimization can
be done for the 32-bit version too.  Don't bother changing the 32-bit
version while it is working (since assembly code change is required).

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

 v4 -> v5:
  - RELOC_KERNEL_HOST_MEM_ACTIVE -> RELOC_KERNEL_HOST_MEM_ENC_ACTIVE
    (Tom)
  - Add a comment to explain only RELOC_KERNEL_PRESERVE_CONTEXT is
    restored after jumping back from peer kernel for preserved_context
    kexec (pointed out by Tom).
  - Use testb instead of testq when comparing the flag with R11 to save
    3 bytes (Hpa).

 v4:
  - new patch

---
 arch/x86/include/asm/kexec.h         | 12 ++++++++++--
 arch/x86/kernel/machine_kexec_64.c   | 22 +++++++++++++---------
 arch/x86/kernel/relocate_kernel_64.S | 25 +++++++++++++++----------
 3 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index f2ad77929d6e..12cebbcdb6c8 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -13,6 +13,15 @@
 # define KEXEC_DEBUG_EXC_HANDLER_SIZE	6 /* PUSHI, PUSHI, 2-byte JMP */
 #endif
 
+#ifdef CONFIG_X86_64
+
+#include <linux/bits.h>
+
+#define RELOC_KERNEL_PRESERVE_CONTEXT		BIT(0)
+#define RELOC_KERNEL_HOST_MEM_ENC_ACTIVE	BIT(1)
+
+#endif
+
 # define KEXEC_CONTROL_PAGE_SIZE	4096
 # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
 
@@ -121,8 +130,7 @@ typedef unsigned long
 relocate_kernel_fn(unsigned long indirection_page,
 		   unsigned long pa_control_page,
 		   unsigned long start_address,
-		   unsigned int preserve_context,
-		   unsigned int host_mem_enc_active);
+		   unsigned int flags);
 #endif
 extern relocate_kernel_fn relocate_kernel;
 #define ARCH_HAS_KIMAGE_ARCH
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 697fb99406e6..5cda8d8d8b13 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -384,16 +384,10 @@ void __nocfi machine_kexec(struct kimage *image)
 {
 	unsigned long reloc_start = (unsigned long)__relocate_kernel_start;
 	relocate_kernel_fn *relocate_kernel_ptr;
-	unsigned int host_mem_enc_active;
+	unsigned int relocate_kernel_flags;
 	int save_ftrace_enabled;
 	void *control_page;
 
-	/*
-	 * This must be done before load_segments() since if call depth tracking
-	 * is used then GS must be valid to make any function calls.
-	 */
-	host_mem_enc_active = cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT);
-
 #ifdef CONFIG_KEXEC_JUMP
 	if (image->preserve_context)
 		save_processor_state();
@@ -427,6 +421,17 @@ void __nocfi machine_kexec(struct kimage *image)
 	 */
 	relocate_kernel_ptr = control_page + (unsigned long)relocate_kernel - reloc_start;
 
+	relocate_kernel_flags = 0;
+	if (image->preserve_context)
+		relocate_kernel_flags |= RELOC_KERNEL_PRESERVE_CONTEXT;
+
+	/*
+	 * This must be done before load_segments() since if call depth tracking
+	 * is used then GS must be valid to make any function calls.
+	 */
+	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
+		relocate_kernel_flags |= RELOC_KERNEL_HOST_MEM_ENC_ACTIVE;
+
 	/*
 	 * The segment registers are funny things, they have both a
 	 * visible and an invisible part.  Whenever the visible part is
@@ -443,8 +448,7 @@ void __nocfi machine_kexec(struct kimage *image)
 	image->start = relocate_kernel_ptr((unsigned long)image->head,
 					   virt_to_phys(control_page),
 					   image->start,
-					   image->preserve_context,
-					   host_mem_enc_active);
+					   relocate_kernel_flags);
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (image->preserve_context)
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index ea604f4d0b52..26e945f85d19 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -66,8 +66,7 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
 	 * %rdi indirection_page
 	 * %rsi pa_control_page
 	 * %rdx start address
-	 * %rcx preserve_context
-	 * %r8  host_mem_enc_active
+	 * %rcx flags: RELOC_KERNEL_*
 	 */
 
 	/* Save the CPU context, used for jumping back */
@@ -111,7 +110,7 @@ SYM_CODE_START_NOALIGN(relocate_kernel)
 	/* save indirection list for jumping back */
 	movq	%rdi, pa_backup_pages_map(%rip)
 
-	/* Save the preserve_context to %r11 as swap_pages clobbers %rcx. */
+	/* Save the flags to %r11 as swap_pages clobbers %rcx. */
 	movq	%rcx, %r11
 
 	/* setup a new stack at the end of the physical control page */
@@ -129,9 +128,8 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	/*
 	 * %rdi	indirection page
 	 * %rdx start address
-	 * %r8 host_mem_enc_active
 	 * %r9 page table page
-	 * %r11 preserve_context
+	 * %r11 flags: RELOC_KERNEL_*
 	 * %r13 original CR4 when relocate_kernel() was invoked
 	 */
 
@@ -204,7 +202,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	 * entries that will conflict with the now unencrypted memory
 	 * used by kexec. Flush the caches before copying the kernel.
 	 */
-	testq	%r8, %r8
+	testb	$RELOC_KERNEL_HOST_MEM_ENC_ACTIVE, %r11b
 	jz .Lsme_off
 	wbinvd
 .Lsme_off:
@@ -220,7 +218,7 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	movq	%cr3, %rax
 	movq	%rax, %cr3
 
-	testq	%r11, %r11	/* preserve_context */
+	testb	$RELOC_KERNEL_PRESERVE_CONTEXT, %r11b
 	jnz .Lrelocate
 
 	/*
@@ -273,7 +271,13 @@ SYM_CODE_START_LOCAL_NOALIGN(identity_mapped)
 	ANNOTATE_NOENDBR
 	andq	$PAGE_MASK, %r8
 	lea	PAGE_SIZE(%r8), %rsp
-	movl	$1, %r11d	/* Ensure preserve_context flag is set */
+	/*
+	 * Ensure RELOC_KERNEL_PRESERVE_CONTEXT flag is set so that
+	 * swap_pages() can swap pages correctly.  Note all other
+	 * RELOC_KERNEL_* flags passed to relocate_kernel() are not
+	 * restored.
+	 */
+	movl	$RELOC_KERNEL_PRESERVE_CONTEXT, %r11d
 	call	swap_pages
 	movq	kexec_va_control_page(%rip), %rax
 0:	addq	$virtual_mapped - 0b, %rax
@@ -321,7 +325,7 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
 	UNWIND_HINT_END_OF_STACK
 	/*
 	 * %rdi indirection page
-	 * %r11 preserve_context
+	 * %r11 flags: RELOC_KERNEL_*
 	 */
 	movq	%rdi, %rcx	/* Put the indirection_page in %rcx */
 	xorl	%edi, %edi
@@ -357,7 +361,8 @@ SYM_CODE_START_LOCAL_NOALIGN(swap_pages)
 	movq	%rdi, %rdx    /* Save destination page to %rdx */
 	movq	%rsi, %rax    /* Save source page to %rax */
 
-	testq	%r11, %r11    /* Only actually swap for ::preserve_context */
+	/* Only actually swap for ::preserve_context */
+	testb	$RELOC_KERNEL_PRESERVE_CONTEXT, %r11b
 	jz	.Lnoswap
 
 	/* copy source page to swap page */
-- 
2.50.1


