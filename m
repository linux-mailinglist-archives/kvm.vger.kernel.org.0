Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69875EA85
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 20:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbfD2Sw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 14:52:29 -0400
Received: from terminus.zytor.com ([198.137.202.136]:55089 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbfD2Sw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 14:52:28 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x3TIq3m01032703
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Mon, 29 Apr 2019 11:52:03 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3TIq3m01032703
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019041745; t=1556563924;
        bh=xrDkEfZHqOrpJnGdbeTXyzFwzlz6S9jYWqO5Soq4z6g=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=uWs5FBirevUZWCNC6P0DPhaAl4R5GQuoYxWZeYKBq1JlU01ZBMtkqVcQ7cb+Yhm0W
         eheN2psQahNsb+YIBzs8CR6tXojw5QmMREoMO/qV6XfcVSf4ynvc3Z5A7vDcpbodo2
         yRUP3QQf5ovj8M9xe07c7V/o6JQXCtZHYnJOJYj7hl2ZlWYblfyMWyfMSOvLu0MVhj
         3h3qxFRQK2FBooBjKzsoLD7KukLXjb4ftzXyyZ6V1jP8mTGkUgojfS+q1dD9dMgRy7
         hCEr06qroyzjf4guJukpfc0evIln2Vy7t8wNETcKgGt9S27fnXMYfmcZJluASgi37F
         GH0hxP1XNrvBg==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x3TIq25r1032698;
        Mon, 29 Apr 2019 11:52:02 -0700
Date:   Mon, 29 Apr 2019 11:52:02 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Sebastian Andrzej Siewior <tipbot@zytor.com>
Message-ID: <tip-eeec00d73be2e92ebce16c89154726250f2c80ef@git.kernel.org>
Cc:     jannh@google.com, bp@suse.de, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, bigeasy@linutronix.de,
        riel@surriel.com, kurt.kanzenbach@linutronix.de,
        luto@amacapital.net, tglx@linutronix.de, pbonzini@redhat.com,
        kvm@vger.kernel.org, mingo@kernel.org, x86@kernel.org
Reply-To: jannh@google.com, bp@suse.de, riel@surriel.com,
          bigeasy@linutronix.de, linux-kernel@vger.kernel.org,
          hpa@zytor.com, dave.hansen@intel.com, pbonzini@redhat.com,
          tglx@linutronix.de, kvm@vger.kernel.org, luto@amacapital.net,
          kurt.kanzenbach@linutronix.de, x86@kernel.org, mingo@kernel.org
In-Reply-To: <20190429163953.gqxgsc5okqxp4olv@linutronix.de>
References: <20190429163953.gqxgsc5okqxp4olv@linutronix.de>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86/fpu: Fault-in user stack if
 copy_fpstate_to_sigframe() fails
Git-Commit-ID: eeec00d73be2e92ebce16c89154726250f2c80ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-3.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        T_DATE_IN_FUTURE_96_Q autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit-ID:  eeec00d73be2e92ebce16c89154726250f2c80ef
Gitweb:     https://git.kernel.org/tip/eeec00d73be2e92ebce16c89154726250f2c80ef
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Mon, 29 Apr 2019 18:39:53 +0200
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Mon, 29 Apr 2019 20:25:45 +0200

x86/fpu: Fault-in user stack if copy_fpstate_to_sigframe() fails

In the compacted form, XSAVES may save only the XMM+SSE state but skip
FP (x87 state).

This is denoted by header->xfeatures = 6. The fastpath
(copy_fpregs_to_sigframe()) does that but _also_ initialises the FP
state (cwd to 0x37f, mxcsr as we do, remaining fields to 0).

The slowpath (copy_xstate_to_user()) leaves most of the FP
state untouched. Only mxcsr and mxcsr_flags are set due to
xfeatures_mxcsr_quirk(). Now that XFEATURE_MASK_FP is set
unconditionally, see

  04944b793e18 ("x86: xsave: set FP, SSE bits in the xsave header in the user sigcontext"),

on return from the signal, random garbage is loaded as the FP state.

Instead of utilizing copy_xstate_to_user(), fault-in the user memory
and retry the fast path. Ideally, the fast path succeeds on the second
attempt but may be retried again if the memory is swapped out due
to memory pressure. If the user memory can not be faulted-in then
get_user_pages() returns an error so we don't loop forever.

Fault in memory via get_user_pages() so copy_fpregs_to_sigframe()
succeeds without a fault.

Fixes: 69277c98f5eef ("x86/fpu: Always store the registers in copy_fpstate_to_sigframe()")
Reported-by: Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason@zx2c4.com
Cc: kvm ML <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: rkrcmar@redhat.com
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190429163953.gqxgsc5okqxp4olv@linutronix.de
---
 arch/x86/kernel/fpu/signal.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 7026f1c4e5e3..6d6c2d6afde4 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -158,7 +158,6 @@ static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf)
 int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 {
 	struct fpu *fpu = &current->thread.fpu;
-	struct xregs_state *xsave = &fpu->state.xsave;
 	struct task_struct *tsk = current;
 	int ia32_fxstate = (buf != buf_fx);
 	int ret = -EFAULT;
@@ -174,11 +173,12 @@ int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 			sizeof(struct user_i387_ia32_struct), NULL,
 			(struct _fpstate_32 __user *) buf) ? -1 : 1;
 
+retry:
 	/*
 	 * Load the FPU registers if they are not valid for the current task.
 	 * With a valid FPU state we can attempt to save the state directly to
-	 * userland's stack frame which will likely succeed. If it does not, do
-	 * the slowpath.
+	 * userland's stack frame which will likely succeed. If it does not,
+	 * resolve the fault in the user memory and try again.
 	 */
 	fpregs_lock();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
@@ -193,14 +193,17 @@ int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 	fpregs_unlock();
 
 	if (ret) {
-		if (using_compacted_format()) {
-			if (copy_xstate_to_user(buf_fx, xsave, 0, size))
-				return -1;
-		} else {
-			fpstate_sanitize_xstate(fpu);
-			if (__copy_to_user(buf_fx, xsave, fpu_user_xstate_size))
-				return -1;
-		}
+		int aligned_size;
+		int nr_pages;
+
+		aligned_size = offset_in_page(buf_fx) + fpu_user_xstate_size;
+		nr_pages = DIV_ROUND_UP(aligned_size, PAGE_SIZE);
+
+		ret = get_user_pages((unsigned long)buf_fx, nr_pages,
+				     FOLL_WRITE, NULL, NULL);
+		if (ret == nr_pages)
+			goto retry;
+		return -EFAULT;
 	}
 
 	/* Save the fsave header for the 32-bit frames. */
