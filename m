Return-Path: <kvm+bounces-56508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D68F2B3EBEA
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 18:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFC1418971A5
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D742EC0A2;
	Mon,  1 Sep 2025 16:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zfibh0hW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C8E2EC090
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756742984; cv=none; b=FEAZ52wjdafqdlPlJ31j4eTz1WFIDLqUTIPCY/TeROB56/MGdCasDMMeGFUCTereixvL1aCb9S1Hp92c1duFeJfEF80y25WSW1lxif2Zu1gc2PQ7KWKq01vwvaFTk7uMyNGPA2oxuJ4xXvAmpyWLBMlKNCuDzQO3CZl7M66T4cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756742984; c=relaxed/simple;
	bh=8o9MSeGyjka2YIkOKa8nP2VBMBZdX1wxLIA+kQOxqmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8n9/k9SJNTkVxZ3FQncmEJfTL4KNzB3mho7emzLUqRRI9hxaYBkjIWlT5/jwu5NttD/g3xhJbivwXXmU33Uxszmdb87kpcXaSj65qkRiP8XYDLhIdPCnVN6rskxdDR3Vmz+VXymQJK6NLOvzL9Pmw2g4A6Hbhuw5/11thECrq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zfibh0hW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756742981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ILG8lOYeP81n1upiKDtnLYC19g1Qye1JLya30e5LpQ=;
	b=Zfibh0hWfTMXZVKDPVN4rH+Nz47/FAVs5N6xoLzoLntfYUqT0ma9KTOQ7HOkFYKRYpkl+l
	xw66WugRmBppCPiRJ8s12rzCZNdHbzu/Aqt6PoKAGi7ZX2bnyxby3SScssp2WLA0xckZHk
	4mwFsgVTqvQx/BJ+LeA9x0QIjNEcduo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-q-DWYd9DOuaYKMtEV8vq4w-1; Mon, 01 Sep 2025 12:09:40 -0400
X-MC-Unique: q-DWYd9DOuaYKMtEV8vq4w-1
X-Mimecast-MFC-AGG-ID: q-DWYd9DOuaYKMtEV8vq4w_1756742980
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4b31ba1392fso58708081cf.2
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 09:09:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756742980; x=1757347780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/ILG8lOYeP81n1upiKDtnLYC19g1Qye1JLya30e5LpQ=;
        b=Tm4H8r2MKiMPViZIHT7P4nJt2kfvRBFat3i9K+vybH3Vj88oqxa9sJC7eIJuB/tFV2
         qvuqXDL7cKPi+TjsSq5YLUDlM0+FCr8ky9uJGZaQJeMmN1q/X2fcq6ZsAmxmiQxCXGoG
         Y3YiYkYP+In56aeW+1zapVmz5thOKjtekp6UtoG7KVKygJ1jeZfVF785jUWFvKGFdzTK
         1B80GrptKWbHXJuWD/lpx9xBu52YI6EOEEAlk1G7J/jhXk9RQ/FURpWLEVqotaL1Pbf2
         GfvxdJDukQgJ6VOw4tPGTN8x8nzaDy4ce7jDEYrHdYD3Sj4Qb+W/I2p+uOrHfxrAl4VG
         4WhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAT9+KewzC6qR/hO86RIPO8uCBC6kX4bL1dSBXQhdEpjLu+2B/8Y6zRQm6CGTxLSodenw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHakWpV2pMObzqQlkcTRWTLDN0z0AFtgQEEFCntoTFd34rsHDg
	Tdr+SvWrxxvQQnhU36YQmOT3wlhiQ5QrgZBLjCegwgcAnjf8ZGbkYcT+7eytYgAKRdiWuI5QDU2
	TwXRULck13hFgBJgqmwLdc1MefV5lCVMvAoQsfIwPjbwNM74C2x/S2Q==
X-Gm-Gg: ASbGncssW5UgxTqeuYEQC8wKpIZM1POva4TicSmppO/mYjd09jfoxuGABNHgDfuEAwQ
	rWgXZX4CCFXfCqr4IDzfHTWBB/zfCuKif0dltUSzCpGfed4uvewFopZdHx/w9MIs66HAZj1Gw3z
	rwJrF/oDdB6uA3wG2nLu8Pba2ZERTmf2IjzaCUJFqMq/OZ0Rj4izsoNPKf53bCCDnFB/LUF/kpi
	wVGTEK/84CBBjsiOldeBEPo5pCMXmI1/xMbcNZmUJbyA3G266o8WQDftqWbNsYUS7p/Gd18sVtS
	H6BiiaquEk//Q+E/RE6qilZO5PpDv/lAoLpY4L3kUefINRnt8CbvnKxmJuyZH2VEQrfSBNjWPTj
	0aLl5o5CDL8lsSPotA+y3I44ooZngZJTLcrjYogiTNX0S3LamwcVH7KKN/6KNY0NtyULX
X-Received: by 2002:a05:622a:138b:b0:4b0:6c7c:a955 with SMTP id d75a77b69052e-4b31da15393mr88332771cf.35.1756742980139;
        Mon, 01 Sep 2025 09:09:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHDti1nmXO9Q+sLEIfixu7lgNBZ2vr81Q1E5oR04YXTrIW3a1NX5lesAlwj4ITitS6AR6+hhQ==
X-Received: by 2002:a05:622a:138b:b0:4b0:6c7c:a955 with SMTP id d75a77b69052e-4b31da15393mr88332171cf.35.1756742979465;
        Mon, 01 Sep 2025 09:09:39 -0700 (PDT)
Received: from [10.201.49.111] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7fc14849559sm686458885a.41.2025.09.01.09.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:09:38 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com,
	x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	kai.huang@intel.com,
	seanjc@google.com,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	farrah.chen@intel.com
Subject: [PATCH 1/7] x86/kexec: Consolidate relocate_kernel() function parameters
Date: Mon,  1 Sep 2025 18:09:24 +0200
Message-ID: <20250901160930.1785244-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250901160930.1785244-1-pbonzini@redhat.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

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
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
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
index 8593760c255a..fdd04b5bb70e 100644
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
2.51.0


