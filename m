Return-Path: <kvm+bounces-9925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ECBAB867946
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 16:00:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72ED81F24429
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:00:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB7B14A08B;
	Mon, 26 Feb 2024 14:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcm2MFsR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8649512AADA;
	Mon, 26 Feb 2024 14:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958340; cv=none; b=mzU897vbxTasLG3KJvAdsDOHWs4N14GYdVNdMDyZ2uDw18RPCnDYKLIu5qk7NOD2TgifD71VLgWhVAVwDtPEjAGEG9t/8TLrkmxi38YbeJYRQpgnaS2XRSGCJA23H/+pOGL0L79bCYxJwpqXbKNg19HUhIdVg5WorwOnW/06sNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958340; c=relaxed/simple;
	bh=PlFQWKQVgSVHs1FKXuyLOo//+7TJ3KioqGv56Yq15H0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g+vwgR5HekCdbAekaQeZFOWZ9dFUELsr5Lu71Xk8AYk6HDIAyySWoEFEe7zXoru97Om2JCKqMZ1Wou97XDyafmPJdW7D3TWsXP1aEpnvgoMsoleV/xUFyiVI3EHmZ/12BxM+i/RNc6RvxbbN0XhFNMof2obWm5q2jFWFRPFWzBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mcm2MFsR; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6e53f3f1f82so217878b3a.2;
        Mon, 26 Feb 2024 06:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958338; x=1709563138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Np68LovMToSBu5RVhorHMFTejoXHFfwbO2NJYg4bpNo=;
        b=mcm2MFsRiSu6/4q73/xxJfmQoc7sq0IM8GRX1OG/7M+0ILTe6HEfjUW2IAY4SB2yeo
         UwFfWHe9KzrWhoH9yVf+w7kXe/TGmHDiLqkVW21OcbaMvSURyQle4Y8BepVksTgnVN9h
         U1FheYSwH++34r389jXi5EjhKEwXdQuAt2yTyva1c0GZSq64JdWGR59U0TLiNYp9LCNx
         uhUKi//oQ9Or3J8vKZ1WgBAFYyiIEWoX5SfdF1f6yipfqAfGoTxbs7vfg+39SwcRGBgv
         NX6nZ4l5dT5tURkPOATAL8GMZ91BGXJZS+Camx0X/9A6hn5kZpMyPlTQEPreFseulk1+
         SYng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958338; x=1709563138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Np68LovMToSBu5RVhorHMFTejoXHFfwbO2NJYg4bpNo=;
        b=FxdFGovYx6iFJFeShpsghXZ7+rbkt9SIJxIfk4AOWxi8K7R153N5g4158YOBV38JID
         m0rtM7eTGmMUWa6h5tGNX/BjNvwGZyV8bOOY27lOvPGPdekUEtnub3WKk4oKWE/iyfDw
         IGRc7Vg5D4JxSjPDJ4+qrAvPZkG1qf4J7oGwWvM7RyVJQWX+EO79eZhZLsTPmHIZWrEf
         dFWfNzsoUdwerksYJth5bM13CXKiVr7kBBfErzS7Xit0Rf78/9rhze7L0kD8kMHAfzD3
         ipl5yqkv/DH9X1jb+gCVxQhvtVHjNMR8jU6qGepJEhxnDnnxrCSln7RLjfwQMDZQ82dJ
         HKDA==
X-Forwarded-Encrypted: i=1; AJvYcCX4pI/OieRxS4JESpuXRU3MwkINbse5uqpt76u/4SM1O1C3O5srlOwkt8eqP09TJWjCvFmilyO8amSDTcT3EH6RCr2x
X-Gm-Message-State: AOJu0Yw+P/g7Qy9aFXxjZrNJ1CRINZsnCZSfnmbjJpeIgJfj30FSlRpZ
	qdlC3Flak5U4p35PE/TwQ0D+/TL6gGCF/YzNedgG1SAuYJWOjfoZfP7XjIp0
X-Google-Smtp-Source: AGHT+IEUOW5x94cpzV4bcvaCVnBjAKoiMDPSirqAMkLuAwFFgvGAt9Nnyg7nIAZ6iu3cxOovBq6vXQ==
X-Received: by 2002:a05:6a20:4386:b0:1a0:6c04:4bba with SMTP id i6-20020a056a20438600b001a06c044bbamr7886045pzl.11.1708958337590;
        Mon, 26 Feb 2024 06:38:57 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id e1-20020a170902744100b001dc944299acsm2628990plt.217.2024.02.26.06.38.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:38:57 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Brian Gerst <brgerst@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Thomas Garnier <thgarnie@chromium.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 62/73] x86/pvm: Add early kernel event entry and dispatch code
Date: Mon, 26 Feb 2024 22:36:19 +0800
Message-Id: <20240226143630.33643-63-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

Since PVM doesn't support IDT-based event delivery, it needs to handle
early kernel events during the booting. Currently, there are two stages
before the final IDT setup. Firstly, all exception handlers are set as
do_early_exception() in idt_setup_early_handlers(). Later, #DB, #BP, and
dispatch code.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/pvm_para.h |  5 +++++
 arch/x86/kernel/head_64.S       | 21 +++++++++++++++++++++
 arch/x86/kernel/pvm.c           | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/arch/x86/include/asm/pvm_para.h b/arch/x86/include/asm/pvm_para.h
index 9216e539fea8..bfb08f0ea293 100644
--- a/arch/x86/include/asm/pvm_para.h
+++ b/arch/x86/include/asm/pvm_para.h
@@ -13,6 +13,7 @@ typedef void (*idtentry_t)(struct pt_regs *regs);
 #include <uapi/asm/kvm_para.h>
 
 void __init pvm_early_setup(void);
+void __init pvm_setup_early_traps(void);
 void __init pvm_install_sysvec(unsigned int sysvec, idtentry_t handler);
 bool __init pvm_kernel_layout_relocate(void);
 
@@ -70,6 +71,10 @@ static inline void pvm_early_setup(void)
 {
 }
 
+static inline void pvm_setup_early_traps(void)
+{
+}
+
 static inline void pvm_install_sysvec(unsigned int sysvec, idtentry_t handler)
 {
 }
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 1d931bab4393..6ad3aedca7da 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -633,6 +633,27 @@ SYM_CODE_START_NOALIGN(vc_no_ghcb)
 SYM_CODE_END(vc_no_ghcb)
 #endif
 
+#ifdef CONFIG_PVM_GUEST
+	.align 256
+SYM_CODE_START_NOALIGN(pvm_early_kernel_event_entry)
+	UNWIND_HINT_ENTRY
+	ENDBR
+
+	incl	early_recursion_flag(%rip)
+
+	/* set %rcx, %r11 per PVM event handling specification */
+	movq	6*8(%rsp), %rcx
+	movq	7*8(%rsp), %r11
+
+	PUSH_AND_CLEAR_REGS
+	movq	%rsp, %rdi	/* %rdi -> pt_regs */
+	call	pvm_early_event
+
+	decl	early_recursion_flag(%rip)
+	jmp	pvm_restore_regs_and_return_to_kernel
+SYM_CODE_END(pvm_early_kernel_event_entry)
+#endif
+
 #define SYM_DATA_START_PAGE_ALIGNED(name)			\
 	SYM_START(name, SYM_L_GLOBAL, .balign PAGE_SIZE)
 
diff --git a/arch/x86/kernel/pvm.c b/arch/x86/kernel/pvm.c
index 88b013185ecd..b3b4ff0bbc91 100644
--- a/arch/x86/kernel/pvm.c
+++ b/arch/x86/kernel/pvm.c
@@ -17,6 +17,7 @@
 #include <asm/cpu_entry_area.h>
 #include <asm/desc.h>
 #include <asm/pvm_para.h>
+#include <asm/setup.h>
 #include <asm/traps.h>
 
 DEFINE_PER_CPU_PAGE_ALIGNED(struct pvm_vcpu_struct, pvm_vcpu_struct);
@@ -24,6 +25,38 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct pvm_vcpu_struct, pvm_vcpu_struct);
 unsigned long pvm_range_start __initdata;
 unsigned long pvm_range_end __initdata;
 
+static bool early_traps_setup __initdata;
+
+void __init pvm_early_event(struct pt_regs *regs)
+{
+	int vector = regs->orig_ax >> 32;
+
+	if (!early_traps_setup) {
+		do_early_exception(regs, vector);
+		return;
+	}
+
+	switch (vector) {
+	case X86_TRAP_DB:
+		exc_debug(regs);
+		return;
+	case X86_TRAP_BP:
+		exc_int3(regs);
+		return;
+	case X86_TRAP_PF:
+		exc_page_fault(regs, regs->orig_ax);
+		return;
+	default:
+		do_early_exception(regs, vector);
+		return;
+	}
+}
+
+void __init pvm_setup_early_traps(void)
+{
+	early_traps_setup = true;
+}
+
 static noinstr void pvm_bad_event(struct pt_regs *regs, unsigned long vector,
 				  unsigned long error_code)
 {
-- 
2.19.1.6.gb485710b


