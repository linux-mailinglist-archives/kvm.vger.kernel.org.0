Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C69F7DE0F
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 16:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbfHAOin (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 10:38:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36216 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731397AbfHAOiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 10:38:20 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1htCDU-0000lv-Qd; Thu, 01 Aug 2019 16:38:04 +0200
Message-Id: <20190801143250.370326052@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 01 Aug 2019 16:32:50 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: [patch 0/5] posix-cpu-timers: Move expiry into task work context
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Running posix cpu timers in hard interrupt context has a few downsides:

 - For PREEMPT_RT it cannot work as the expiry code needs to take sighand
   lock, which is a 'sleeping spinlock' in RT

 - For fine grained accounting it's just wrong to run this in context of
   the timer interrupt because that way a process specific cpu time is
   accounted to the timer interrupt.

There is no real hard requirement to run the expiry code in hard interrupt
context. The posix CPU timers are an approximation anyway, so having them
expired and evaluated in task work context does not really make them worse.

That unearthed the fact that KVM is missing to handle task work before
entering a VM which is delaying pending task work until the vCPU thread
goes all the way back to user space qemu.

The series implements the necessary handling for x86/KVM and switches the
posix cpu timer expiry into task work for X86. The posix timer modification
is conditional on a selectable config switch as this requires that
task work is handled in KVM.

The available tests pass and no problematic difference has been observed.

Thanks,

	tglx

8<--------------------
 arch/x86/kvm/x86.c             |    8 ++++-
 arch/x86/Kconfig               |    1 
 include/linux/sched.h          |    3 ++
 include/linux/tracehook.h      |   15 ++++++++++
 kernel/task_work.c             |   19 ++++++++++++
 kernel/time/Kconfig            |    5 +++
 kernel/time/posix-cpu-timers.c |   61 ++++++++++++++++++++++++++++++-----------
 7 files changed, 95 insertions(+), 17 deletions(-)



