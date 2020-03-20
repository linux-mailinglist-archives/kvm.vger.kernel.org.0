Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C94218DAC7
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgCTWFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:05:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37507 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgCTWET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:19 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk1-0004TN-5N; Fri, 20 Mar 2020 23:03:45 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 9F4A8FFC8D;
        Fri, 20 Mar 2020 23:03:44 +0100 (CET)
Message-Id: <20200320175956.033706968@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 18:59:56 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paul McKenney <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [RESEND][patch V3 00/23] x86/entry: Consolidation part II (syscalls)
Content-transfer-encoding: 8-bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

Sorry for the resend noise. I managed to fatfinger one of my scripts
so it dropped all Ccs and sent it only to LKML. Sigh....

This is the third version of the syscall entry code consolidation
series. V2 can be found here:

  https://lore.kernel.org/r/20200308222359.370649591@linutronix.de

It applies on top of

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/entry

and is also available from git:

    git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel entry-v3-part2

The changes vs. V2:

 - A massive rework utilizing Peter Zijlstras objtool patches to analyze
   the new .noinstr.text section:

   https://lore.kernel.org/r/20200317170234.897520633@infradead.org

   Working with this was really helpful as it clearly pin pointed code
   which calls out of the protected section which is much more efficient
   and focussed than chasing everything manually.

 - Picked up the two RCU patches from Paul for completeness. The bugfix
   is required anyway and the comments have been really helpful to see
   where the defense line has to be.

 - As the tool flagged KVM as red zone, I looked at the context tracking
   usage there and it has similar if not worse issues. New set of patches
   dealing with that.

Please have a close look at the approach and the resulting protected areas.

Known issues:

  - The kprobes '.noinstr.text' exclusion currently works only for built
    in code. Haven't figured out how to to fix that, but I'm sure that
    Masami knows :)

  - The various SANitizers if enabled ruin the picture. Peter and I still
    have no brilliant idea what to do about that.

Thanks,

	tglx
---
 arch/x86/entry/common.c                |  173 ++++++++++++++++++++++++---------
 arch/x86/entry/entry_32.S              |   24 ----
 arch/x86/entry/entry_64.S              |    6 -
 arch/x86/entry/entry_64_compat.S       |   32 ------
 arch/x86/entry/thunk_64.S              |   45 +++++++-
 arch/x86/include/asm/bug.h             |    3 
 arch/x86/include/asm/hardirq.h         |    4 
 arch/x86/include/asm/irqflags.h        |    3 
 arch/x86/include/asm/nospec-branch.h   |    4 
 arch/x86/include/asm/paravirt.h        |    3 
 arch/x86/kvm/svm.c                     |  152 ++++++++++++++++++----------
 arch/x86/kvm/vmx/ops.h                 |    4 
 arch/x86/kvm/vmx/vmenter.S             |    2 
 arch/x86/kvm/vmx/vmx.c                 |   78 +++++++++++---
 arch/x86/kvm/x86.c                     |    4 
 b/include/asm-generic/bug.h            |    9 +
 include/asm-generic/sections.h         |    3 
 include/asm-generic/vmlinux.lds.h      |    4 
 include/linux/compiler.h               |   24 ++++
 include/linux/compiler_types.h         |    4 
 include/linux/context_tracking.h       |   27 +++--
 include/linux/context_tracking_state.h |    6 -
 include/linux/irqflags.h               |    6 +
 include/linux/sched.h                  |    1 
 kernel/context_tracking.c              |   14 +-
 kernel/kprobes.c                       |   11 ++
 kernel/locking/lockdep.c               |   66 +++++++++---
 kernel/panic.c                         |    4 
 kernel/rcu/tree.c                      |   91 +++++++++++------
 kernel/rcu/tree_plugin.h               |    4 
 kernel/rcu/update.c                    |    7 -
 kernel/trace/trace_preemptirq.c        |   25 ++++
 lib/debug_locks.c                      |    2 
 lib/smp_processor_id.c                 |   10 -
 scripts/mod/modpost.c                  |    2 
 35 files changed, 590 insertions(+), 267 deletions(-)


