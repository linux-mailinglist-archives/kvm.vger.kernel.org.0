Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4332D362B8
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 19:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFERdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 13:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbfFERdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 13:33:00 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3063420866;
        Wed,  5 Jun 2019 17:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559755979;
        bh=5QFfJ1gknqDsD3E2MuuC3H7OUAv/kY6TNj3u7Qn2ZxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ue0KrUu0WvrPuRI7UsZVg2ilc0IYh952GntcuYBCkrP/hwiQ1jfLvUtucouJe0TNS
         HIqzU0LHH/d1QaTtAFI2vIyJuYjfyyNlMY5/Jzm7IlvNgmM5KmPfSju7YubrT4ci8j
         WqAB6FM7g+HodzUzN1FrXJldMXbaY4M1RP1sFKK4=
Date:   Wed, 5 Jun 2019 10:32:57 -0700
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
Subject: Re: [5.2 regression] copy_fpstate_to_sigframe() change causing crash
 in 32-bit process
Message-ID: <20190605173256.GA86462@gmail.com>
References: <20190604185358.GA820@sol.localdomain>
 <20190605140405.2nnpqslnjpfe2ig2@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605140405.2nnpqslnjpfe2ig2@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 05, 2019 at 04:04:05PM +0200, Sebastian Andrzej Siewior wrote:
> On 2019-06-04 11:53:58 [-0700], Eric Biggers wrote:
> > On latest Linus' tree I'm getting a crash in a 32-bit Wine process.
> > 
> > I bisected it to the following commit:
> > 
> > commit 39388e80f9b0c3788bfb6efe3054bdce0c3ead45
> > Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Date:   Wed Apr 3 18:41:35 2019 +0200
> > 
> >     x86/fpu: Don't save fxregs for ia32 frames in copy_fpstate_to_sigframe()
> > 
> > Reverting the commit by applying the following diff makes the problem go away.
> 
> This looked like a merge artifact and it has been confirmed as such. Now
> you say that this was a needed piece of code. Interesting.
> Is that wine process/testcase something you can share? I will try to
> take a closer look.
> 
> Sebastian

As I said, the commit looks broken to me.  save_fsave_header() reads from
tsk->thread.fpu.state.fxsave, which due to that commit isn't being updated with
the latest registers.  Am I missing something?  Note the comment you deleted:

	/* Update the thread's fxstate to save the fsave header. */

My test case was "run some Win32 game for a few minutes and see if it crashes"
so it's not really sharable, sorry.  But I expect it would be possible to write
a minimal test case, where a 32-bit process sends a signal to itself and checks
whether the i387 floating point stuff gets restored correctly afterwards.

- Eric
