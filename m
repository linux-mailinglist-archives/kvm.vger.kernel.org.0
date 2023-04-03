Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67C26D4670
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 16:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbjDCOFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 10:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbjDCOFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 10:05:16 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1440E2B0E0;
        Mon,  3 Apr 2023 07:05:04 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id qe8-20020a17090b4f8800b0023f07253a2cso30627976pjb.3;
        Mon, 03 Apr 2023 07:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680530703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhwgcDtAklxhqM6EYQPuvUq6965STEsFa04g+nFznic=;
        b=Hel87nL2p8AdJk1YAXlMZNr6u+Kyo+BZ3Q4c7lJ4uY9DgXLnyJhjYijHU8kvz4xTAl
         lvAe0p7Mmzkp4d4j5eq4FfqeqenxwXTf6z2NGqxgESMZHL/fL2y+xbXQGxCHVFA9xo4h
         V0Snthjpt0jP4POzvJlQ4FNwbaDHXHQcZR6w0dcT8iFP11VdsmMpwqnY/5CjCblOgYmu
         cAC62agxmrtJ16rqlfD12Hb0rMFxVy18UwEQriL3uiNa6qhISCkNJZy5my1Ebae43KOD
         0hIvN8ny4TGjXoVj8JkjLtzY26lPcfLSwNQhYG1jC8J406wFY/zqTiEvJBNKfGIrgaVV
         quzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680530703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vhwgcDtAklxhqM6EYQPuvUq6965STEsFa04g+nFznic=;
        b=LtmD4KceTCw/C1xurdFi2y1p3hTi6KkuUYzmKk3mgN6pnT9hLZjbuFcRpw7pFRx6lG
         2A25YzHcC+oYDxtfwYuPhPFjCyN+/OyXcevam3hDNhl4RZxdDQdzu0IKFlI5Gb/zFwRO
         5dL+Uc10/jxuVlSeqGpPZjocHWr+LBCgBmjkKQ2K0ms7CyIT8X0p6KjfJcTad+18EAYq
         xQHHP80J4SEgL3KO2YPGHUSHBdes288DqFngt9VsM9SCwo9Yya9uONMCJJNLv3H2NS/n
         S3cxwGpdc7OaI/JWSdJ531yHf078O3goeyi6962EnI+/td9R17tcFH41EU+XZEI+eU92
         2i+A==
X-Gm-Message-State: AAQBX9cjGZkCU/DNKRzjm5ht1uY20c3Gk7P9/J/Lhf3PKjGDB/9L5X/m
        EPZ3798o8lVRIfQ6MtfByhIPVBmF+Vs=
X-Google-Smtp-Source: AKy350YnS84lfoLQEq2h2XyjaFwgl6Kx+j2bUv9CN4OsPSXeoGN8xOUShHAKm7jSA2d910IbQAmmiw==
X-Received: by 2002:a17:902:d4c6:b0:1a1:cc5a:b07 with SMTP id o6-20020a170902d4c600b001a1cc5a0b07mr45012190plg.37.1680530702603;
        Mon, 03 Apr 2023 07:05:02 -0700 (PDT)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id b19-20020a170902d89300b001a072be70desm6696500plz.41.2023.04.03.07.05.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Apr 2023 07:05:02 -0700 (PDT)
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
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 1/7] x86/entry: Move PUSH_AND_CLEAR_REGS out of paranoid_entry
Date:   Mon,  3 Apr 2023 22:05:59 +0800
Message-Id: <20230403140605.540512-2-jiangshanlai@gmail.com>
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

Prepare to call paranoid_entry() with pt_regs pushed.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/entry/entry_64.S | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index eccc3431e515..49ddc4dd3117 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -475,11 +475,13 @@ SYM_CODE_START(\asmsym)
 	testb	$3, CS-ORIG_RAX(%rsp)
 	jnz	.Lfrom_usermode_switch_stack_\@
 
+	PUSH_AND_CLEAR_REGS
+	UNWIND_HINT_REGS
+	ENCODE_FRAME_POINTER
+
 	/* paranoid_entry returns GS information for paranoid_exit in EBX. */
 	call	paranoid_entry
 
-	UNWIND_HINT_REGS
-
 	movq	%rsp, %rdi		/* pt_regs pointer */
 
 	call	\cfunc
@@ -530,14 +532,16 @@ SYM_CODE_START(\asmsym)
 	testb	$3, CS-ORIG_RAX(%rsp)
 	jnz	.Lfrom_usermode_switch_stack_\@
 
+	PUSH_AND_CLEAR_REGS
+	UNWIND_HINT_REGS
+	ENCODE_FRAME_POINTER
+
 	/*
 	 * paranoid_entry returns SWAPGS flag for paranoid_exit in EBX.
 	 * EBX == 0 -> SWAPGS, EBX == 1 -> no SWAPGS
 	 */
 	call	paranoid_entry
 
-	UNWIND_HINT_REGS
-
 	/*
 	 * Switch off the IST stack to make it free for nested exceptions. The
 	 * vc_switch_off_ist() function will switch back to the interrupted
@@ -587,9 +591,12 @@ SYM_CODE_START(\asmsym)
 	ASM_CLAC
 	cld
 
+	PUSH_AND_CLEAR_REGS
+	UNWIND_HINT_REGS
+	ENCODE_FRAME_POINTER
+
 	/* paranoid_entry returns GS information for paranoid_exit in EBX. */
 	call	paranoid_entry
-	UNWIND_HINT_REGS
 
 	movq	%rsp, %rdi		/* pt_regs pointer into first argument */
 	movq	ORIG_RAX(%rsp), %rsi	/* get error code into 2nd argument*/
@@ -903,8 +910,8 @@ SYM_CODE_END(xen_failsafe_callback)
 #endif /* CONFIG_XEN_PV */
 
 /*
- * Save all registers in pt_regs. Return GSBASE related information
- * in EBX depending on the availability of the FSGSBASE instructions:
+ * Return GSBASE related information in EBX depending on the availability
+ * of the FSGSBASE instructions:
  *
  * FSGSBASE	R/EBX
  *     N        0 -> SWAPGS on exit
@@ -915,11 +922,8 @@ SYM_CODE_END(xen_failsafe_callback)
  * R14 - old CR3
  * R15 - old SPEC_CTRL
  */
-SYM_CODE_START(paranoid_entry)
+SYM_FUNC_START(paranoid_entry)
 	ANNOTATE_NOENDBR
-	UNWIND_HINT_FUNC
-	PUSH_AND_CLEAR_REGS save_ret=1
-	ENCODE_FRAME_POINTER 8
 
 	/*
 	 * Always stash CR3 in %r14.  This value will be restored,
@@ -988,7 +992,7 @@ SYM_CODE_START(paranoid_entry)
 	UNTRAIN_RET_FROM_CALL
 
 	RET
-SYM_CODE_END(paranoid_entry)
+SYM_FUNC_END(paranoid_entry)
 
 /*
  * "Paranoid" exit path from exception stack.  This is invoked
@@ -1443,6 +1447,10 @@ end_repeat_nmi:
 	 */
 	pushq	$-1				/* ORIG_RAX: no syscall to restart */
 
+	PUSH_AND_CLEAR_REGS
+	UNWIND_HINT_REGS
+	ENCODE_FRAME_POINTER
+
 	/*
 	 * Use paranoid_entry to handle SWAPGS, but no need to use paranoid_exit
 	 * as we should not be calling schedule in NMI context.
@@ -1451,7 +1459,6 @@ end_repeat_nmi:
 	 * exceptions might do.
 	 */
 	call	paranoid_entry
-	UNWIND_HINT_REGS
 
 	movq	%rsp, %rdi
 	movq	$-1, %rsi
-- 
2.19.1.6.gb485710b

