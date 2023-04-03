Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63616D4679
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 16:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbjDCOGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 10:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbjDCOGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 10:06:02 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F413E40DF;
        Mon,  3 Apr 2023 07:05:32 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so32643515pjp.1;
        Mon, 03 Apr 2023 07:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680530731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tn2wKwx0EXmrg4KUjii9CLG1/m9PFl3nKLSeijJ1CpQ=;
        b=bpKyUkA1BBY1Z8ckFIx6sm8b6cCHlPM87VXGt5UEhc2HjF2VVp1oJCzKyVvcA3lOAo
         17R5cyzdXHXyhp0+HVocGg6LkmttssT7gvSXdAgjGl36dq8ejzCOrDYjKs9yCWjKZ/nU
         N4+PTIFOPadNrsJO2ZDeNJ/tMy3LO/8xYGHR9NhvpLOdo04i5UrCDXlc4RjhUuPIYH4O
         smVPF7cWsawXXpUnRln2PoRwwBbbSFvlOeq1PxciVcAhAE2BkVj1PKsvhKxk06JUI8jL
         5stDFNzAv80qVPEEJnx2w2qMP0gm6ZQYEam5LzVdE4ATvyP7KWrbaFn8AJNejem8o2bI
         ucQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680530731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tn2wKwx0EXmrg4KUjii9CLG1/m9PFl3nKLSeijJ1CpQ=;
        b=PowNg5mS3zQD54Y0gG3byy97C0m4v5wBPhYIOFcTWy2nO6t85mCVNX5ZBW01e5311B
         2oZWM0Wk3ZQ+OIkyH35/2ar3uRPqOp71/X0ZwaEOKUcPx2xLzNr5Q80Qi5r8sSIoXWGu
         uFdp18j/QYgZPQAx/ljcTZYICopUEszVKkBvg2GE44c/O6KCV4CBWA4VzFkENI3pobAi
         OPD/IwCkgZyWWdbVX+p7mzkXGMQrQMu/fwH0SkF3n8Uqgp6LfC8YkWZYxDVFPOt9Bxoy
         i/j5TOAvLFNQfBDzBXIPxO0ltjoXUmccBGd916X9KtYSvxpXwiBrV83RgJQ1IvjnD7aa
         GOag==
X-Gm-Message-State: AAQBX9eCSQ6zILdg/A1N6mOIwbr6PEbnHwKEXKhHxnU6ii1sFazVc97J
        4iI6s9RgyIk3QRxVCZRltPlcNsToQpU=
X-Google-Smtp-Source: AKy350YMy6MWeagJFudQRTfciSmnNqn7Ihy86w3MRx93dio4hrdleDz+fZZhiUbRi9zPHWP23WD/Qw==
X-Received: by 2002:a17:903:2312:b0:1a1:a6e5:764b with SMTP id d18-20020a170903231200b001a1a6e5764bmr48814320plh.60.1680530731648;
        Mon, 03 Apr 2023 07:05:31 -0700 (PDT)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id f19-20020a170902e99300b0019acd3151d0sm6649416plb.114.2023.04.03.07.05.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Apr 2023 07:05:31 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Dirk Hohndel <dirkhh@vmware.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [RFC PATCH 5/7] x86/entry: Use atomic-IST-entry for MCE and DB
Date:   Mon,  3 Apr 2023 22:06:03 +0800
Message-Id: <20230403140605.540512-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230403140605.540512-1-jiangshanlai@gmail.com>
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/entry/entry_64.S       | 53 ---------------------------------
 arch/x86/entry/ist_entry.c      |  4 +--
 arch/x86/include/asm/idtentry.h |  4 +--
 3 files changed, 4 insertions(+), 57 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 2bb7ab8512dc..e4ddc793f841 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -621,59 +621,6 @@ _ASM_NOKPROBE(\asmsym)
 SYM_CODE_END(\asmsym)
 .endm
 
-/**
- * idtentry_mce_db - Macro to generate entry stubs for #MC and #DB
- * @vector:		Vector number
- * @asmsym:		ASM symbol for the entry point
- * @cfunc:		C function to be called
- *
- * The macro emits code to set up the kernel context for #MC and #DB
- *
- * If the entry comes from user space it uses the normal entry path
- * including the return to user space work and preemption checks on
- * exit.
- *
- * If hits in kernel mode then it needs to go through the paranoid
- * entry as the exception can hit any random state. No preemption
- * check on exit to keep the paranoid path simple.
- */
-.macro idtentry_mce_db vector asmsym cfunc
-SYM_CODE_START(\asmsym)
-	UNWIND_HINT_IRET_REGS
-	ENDBR
-	ASM_CLAC
-	cld
-
-	pushq	$-1			/* ORIG_RAX: no syscall to restart */
-
-	/*
-	 * If the entry is from userspace, switch stacks and treat it as
-	 * a normal entry.
-	 */
-	testb	$3, CS-ORIG_RAX(%rsp)
-	jnz	.Lfrom_usermode_switch_stack_\@
-
-	PUSH_AND_CLEAR_REGS
-	UNWIND_HINT_REGS
-	ENCODE_FRAME_POINTER
-
-	/* paranoid_entry returns GS information for paranoid_exit in EBX. */
-	call	paranoid_entry
-
-	movq	%rsp, %rdi		/* pt_regs pointer */
-
-	call	\cfunc
-
-	jmp	paranoid_exit
-
-	/* Switch to the regular task stack and use the noist entry point */
-.Lfrom_usermode_switch_stack_\@:
-	idtentry_body noist_\cfunc, has_error_code=0
-
-_ASM_NOKPROBE(\asmsym)
-SYM_CODE_END(\asmsym)
-.endm
-
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 /**
  * idtentry_vc - Macro to generate entry stub for #VC
diff --git a/arch/x86/entry/ist_entry.c b/arch/x86/entry/ist_entry.c
index 407571cc4a8c..946b3b537bd5 100644
--- a/arch/x86/entry/ist_entry.c
+++ b/arch/x86/entry/ist_entry.c
@@ -42,8 +42,8 @@ static __always_inline bool identify_ist_##sym_name(				\
 }
 
 DEFINE_IDENTIFY_IST(NMI, nmi, true)
-DEFINE_IDENTIFY_IST(DB, debug, false)
-DEFINE_IDENTIFY_IST(MCE, machine_check, false)
+DEFINE_IDENTIFY_IST(DB, debug, true)
+DEFINE_IDENTIFY_IST(MCE, machine_check, IS_ENABLED(CONFIG_X86_MCE))
 DEFINE_IDENTIFY_IST(VC, vmm_communication, false)
 
 static __always_inline bool identify_ist(
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index b568f1de6da6..01f3152ffe82 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -454,10 +454,10 @@ __visible noinstr void func(struct pt_regs *regs,			\
 	idtentry_ist vector asm_##func func func has_error_code=0 stack_offset=CEA_stacks_NMI
 
 # define DECLARE_IDTENTRY_MCE(vector, func)				\
-	idtentry_mce_db vector asm_##func func
+	idtentry_ist vector asm_##func func noist_##func has_error_code=0 stack_offset=CEA_stacks_MCE
 
 # define DECLARE_IDTENTRY_DEBUG(vector, func)				\
-	idtentry_mce_db vector asm_##func func
+	idtentry_ist vector asm_##func func noist_##func has_error_code=0 stack_offset=CEA_stacks_DB
 
 # define DECLARE_IDTENTRY_DF(vector, func)				\
 	idtentry_df vector asm_##func func
-- 
2.19.1.6.gb485710b

