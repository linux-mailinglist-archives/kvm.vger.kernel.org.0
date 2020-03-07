Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5149917CA0E
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 02:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgCGBCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 20:02:30 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54778 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgCGBCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 20:02:30 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jANrG-0000oB-Ew; Sat, 07 Mar 2020 02:02:26 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id D65BD104088; Sat,  7 Mar 2020 02:02:25 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     paulmck@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Subject: Re: [patch 2/2] x86/kvm: Sanitize kvm_async_pf_task_wait()
In-Reply-To: <20200307002210.GJ2935@paulmck-ThinkPad-P72>
References: <20200306234204.847674001@linutronix.de> <20200307000259.448059232@linutronix.de> <20200307002210.GJ2935@paulmck-ThinkPad-P72>
Date:   Sat, 07 Mar 2020 02:02:25 +0100
Message-ID: <874kv1asf2.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Paul E. McKenney" <paulmck@kernel.org> writes:
>> In #2c RCU is eventually not watching, but as that state cannot schedule
>> anyway there is no point to worry about it so it has to invoke
>> rcu_irq_enter() before running that code. This can be optimized, but this
>> will be done as an extra step in course of the entry code consolidation
>> work.
>
> In other words, any needed rcu_irq_enter() and rcu_irq_exit() are added
> in one of the entry-code consolidation patches, and patch below depends
> on that patch, correct?

No. The patch itself is already correct when applied to mainline. It has
no dependencies.

It invokes rcu_irq_enter()/exit() for the case (#2c) where it is
relevant. All other case are already RCU safe today.

The fact that the invocation is misplaced is a different story and yes,
that is part of the entry code cleanup along with some optimization
which are possible once the entry voodoo is out of ASM and adjustable
for a particular entry point in C.

Thanks,

        tglx
