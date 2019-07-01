Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DC639C3F
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2019 11:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfFHJto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Jun 2019 05:49:44 -0400
Received: from terminus.zytor.com ([198.137.202.136]:54697 "EHLO
        terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfFHJto (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Jun 2019 05:49:44 -0400
Received: from terminus.zytor.com (localhost [127.0.0.1])
        by terminus.zytor.com (8.15.2/8.15.2) with ESMTPS id x589nGY12915658
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sat, 8 Jun 2019 02:49:16 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x589nGY12915658
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2019051801; t=1559987357;
        bh=xud/tY9QU6ISxDLO94RhQ0+L8m6TRftpBj+aXoE8ZlA=;
        h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
        b=SqzFiLK7+eZYQkM0zs8MoLsNh7GMhvTLfJQfBI/1cubIYlmpkEu3Z9QRSdwHG50RI
         N7d7WS5Fy2bOgLBLxUQJYQVNGkjiViHoxjMj9ZHV0Sh+mTV2r39WMqNjjd5ydqzJIu
         X+QV/WMypPdd3WToFeSX+iGR0o9RtBPEHoRPGho643+nWg7DQJ66PEiLPrl+oMSMWm
         KFOqYtN+dyC8frYYb3XOJQJbw6OzaLePpJO/OaYQM1D72fnoIInPeFVZydr62pxJJ9
         C3q1ShPH9WlcumoFNBPdtaN+XLQ3HLYoPYbETLewZb4WcXH4dkVquU+GG204jfag+l
         kPuzgR35FdkBA==
Received: (from tipbot@localhost)
        by terminus.zytor.com (8.15.2/8.15.2/Submit) id x589nEsi2915653;
        Sat, 8 Jun 2019 02:49:14 -0700
Date:   Sat, 8 Jun 2019 02:49:14 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
From:   tip-bot for Sebastian Andrzej Siewior <tipbot@zytor.com>
Message-ID: <tip-aab8445c4e1cceeb3f739352041ec1c2586bc923@git.kernel.org>
Cc:     mingo@kernel.org, bigeasy@linutronix.de, riel@surriel.com,
        tglx@linutronix.de, dave.hansen@intel.com, rkrcmar@redhat.com,
        Jason@zx2c4.com, ebiggers@kernel.org, luto@kernel.org,
        hughd@google.com, kvm@vger.kernel.org, mingo@redhat.com,
        bp@suse.de, x86@kernel.org, hpa@zytor.com, jannh@google.com,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org
Reply-To: x86@kernel.org, hpa@zytor.com, bp@suse.de, hughd@google.com,
          mingo@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com,
          jannh@google.com, linux-kernel@vger.kernel.org,
          bigeasy@linutronix.de, mingo@kernel.org, tglx@linutronix.de,
          riel@surriel.com, dave.hansen@intel.com, ebiggers@kernel.org,
          rkrcmar@redhat.com, Jason@zx2c4.com, luto@kernel.org
In-Reply-To: <20190607142915.y52mfmgk5lvhll7n@linutronix.de>
References: <20190607142915.y52mfmgk5lvhll7n@linutronix.de>
To:     linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/fpu: Update kernel's FPU state before using
 for the fsave header
Git-Commit-ID: aab8445c4e1cceeb3f739352041ec1c2586bc923
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-2.4 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        DATE_IN_FUTURE_96_Q,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF
        autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit-ID:  aab8445c4e1cceeb3f739352041ec1c2586bc923
Gitweb:     https://git.kernel.org/tip/aab8445c4e1cceeb3f739352041ec1c2586bc923
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Fri, 7 Jun 2019 16:29:16 +0200
Committer:  Borislav Petkov <bp@suse.de>
CommitDate: Sat, 8 Jun 2019 11:45:15 +0200

x86/fpu: Update kernel's FPU state before using for the fsave header

In commit

  39388e80f9b0c ("x86/fpu: Don't save fxregs for ia32 frames in copy_fpstate_to_sigframe()")

I removed the statement

|       if (ia32_fxstate)
|               copy_fxregs_to_kernel(fpu);

and argued that it was wrongly merged because the content was already
saved in kernel's state.

This was wrong: It is required to write it back because it is only
saved on the user-stack and save_fsave_header() reads it from task's
FPU-state. I missed that part…

Save x87 FPU state unless thread's FPU registers are already up to date.

Fixes: 39388e80f9b0c ("x86/fpu: Don't save fxregs for ia32 frames in copy_fpstate_to_sigframe()")
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Eric Biggers <ebiggers@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: kvm ML <kvm@vger.kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20190607142915.y52mfmgk5lvhll7n@linutronix.de
---
 arch/x86/kernel/fpu/signal.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 060d6188b453..0071b794ed19 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -62,6 +62,11 @@ static inline int save_fsave_header(struct task_struct *tsk, void __user *buf)
 		struct user_i387_ia32_struct env;
 		struct _fpstate_32 __user *fp = buf;
 
+		fpregs_lock();
+		if (!test_thread_flag(TIF_NEED_FPU_LOAD))
+			copy_fxregs_to_kernel(&tsk->thread.fpu);
+		fpregs_unlock();
+
 		convert_from_fxsr(&env, tsk);
 
 		if (__copy_to_user(buf, &env, sizeof(env)) ||
