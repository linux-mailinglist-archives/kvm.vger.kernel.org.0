Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BAE35007
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 20:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfFDSyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 14:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbfFDSyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 14:54:00 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1E782075C;
        Tue,  4 Jun 2019 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559674440;
        bh=Cp6VeCqZCzW+nl+JJJp4Ag83997W0UrXA7j/yyUXqCw=;
        h=Date:From:To:Cc:Subject:From;
        b=Hz4F5IAWX5K7ns5/iauYd6ztC2uFH45l1oTRY+3CZ9LVNjvf+Wc4JueKy6VVfTQzD
         mnlH5aQ8RPlnFpo1TAQeptBSMvVYdAvE1MxukfkctfinBCwhR7iI+5A4OtOts4fTDD
         8nJ2aS2GQoARjwQdpfnL9rkq56s1TjtwvCiG7vaI=
Date:   Tue, 4 Jun 2019 11:53:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Borislav Petkov <bp@suse.de>, Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        kvm ML <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Rik van Riel <riel@surriel.com>, x86-ml <x86@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [5.2 regression] copy_fpstate_to_sigframe() change causing crash in
 32-bit process
Message-ID: <20190604185358.GA820@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On latest Linus' tree I'm getting a crash in a 32-bit Wine process.

I bisected it to the following commit:

commit 39388e80f9b0c3788bfb6efe3054bdce0c3ead45
Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Wed Apr 3 18:41:35 2019 +0200

    x86/fpu: Don't save fxregs for ia32 frames in copy_fpstate_to_sigframe()

Reverting the commit by applying the following diff makes the problem go away.

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 5a8d118bc423e..ed16a24aab497 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -157,6 +157,7 @@ static inline int copy_fpregs_to_sigframe(struct xregs_state __user *buf)
  */
 int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 {
+	struct fpu *fpu = &current->thread.fpu;
 	struct task_struct *tsk = current;
 	int ia32_fxstate = (buf != buf_fx);
 	int ret;
@@ -202,6 +203,10 @@ int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 		return -EFAULT;
 	}
 
+	/* Update the thread's fxstate to save the fsave header. */
+	if (ia32_fxstate)
+		copy_fxregs_to_kernel(fpu);
+
 	/* Save the fsave header for the 32-bit frames. */
 	if ((ia32_fxstate || !use_fxsr()) && save_fsave_header(tsk, buf))
 		return -1;

Apparently the problem is that save_fsave_header() assumes the registers have
been saved to fpu->state.fxsave, yet the code that does so was removed.

Note, bisection was not straightforward because there was another bug also
causing a crash temporarily introduced during the FPU code rework: commit
39ea9baffda9 ("x86/fpu: Remove fpu->initialized usage in __fpu__restore_sig()")
forgot to call fpstate_init() on the temporary 'state' buffer, so
XCOMP_BV_COMPACTED_FORMAT was never set, causing xrstors to fail.  But that bug
went away in later commits.

- Eric
