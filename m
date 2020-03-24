Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E401191D37
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 00:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgCXXDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 19:03:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40406 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727325AbgCXXDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 19:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PJCYjOu8R2ta57vVLwE755dKHWIUMoa5zPTtSZ88Blw=; b=jI7uVy4/ijBVdch08B8q7US9K9
        dsmAh5RZwBUnV7igJKXGd1n3ydk2w5GZqK1ir0bMSe7Y8xLvay18gAlnHWzwrAE4tQVVRdR62Hc/i
        d1Hv5edDgM5dKQKRJowedTnym9F+1JWD8Ek4pYl+Ueyk0FcjPm4PnQNGOyfkzv8Q1Ug3ks3frxJpQ
        0Aby4fYLjEaappipohwdx96UOSYdL4dmgRXU7qstI+lT8ByoWc4wrsk8tTJeeoZ2fneoPKK6YTN9J
        NcUKPgFusopjANzcFHxrL6Xa4wINIfOamHvlXtWV1zQO0CEm9M+o2JIlA5PE+uicOJODwzbaD+eqf
        EFQPouRQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGsZv-0007Jl-IV; Tue, 24 Mar 2020 23:03:23 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 56F35980FA6; Wed, 25 Mar 2020 00:03:20 +0100 (CET)
Date:   Wed, 25 Mar 2020 00:03:20 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Paul McKenney <paulmck@kernel.org>,
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
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RESEND][patch V3 19/23] x86/kvm/vmx: Add hardirq tracing to
 guest enter/exit
Message-ID: <20200324230320.GX2452@worktop.programming.kicks-ass.net>
References: <20200320175956.033706968@linutronix.de>
 <20200320180034.297670977@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320180034.297670977@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 07:00:15PM +0100, Thomas Gleixner wrote:
> The VMX code does not track hard interrupt state correctly. The state in
> tracing and lockdep is 'OFF' all the way during guest mode. From the host
> point of view this is wrong because the VMENTER reenables interrupts like a
> return to user space and VMENTER disables them again like an entry from
> user space.
> 
> Make it do exactly the same thing as enter/exit user mode does.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

This patch (and the SVM counterpart) result in:

ERROR: "lockdep_hardirqs_on" [arch/x86/kvm/kvm-amd.ko] undefined!
ERROR: "lockdep_hardirqs_off" [arch/x86/kvm/kvm-amd.ko] undefined!
ERROR: "__trace_hardirqs_off" [arch/x86/kvm/kvm-amd.ko] undefined!
ERROR: "lockdep_hardirqs_on_prepare" [arch/x86/kvm/kvm-amd.ko] undefined!
ERROR: "__trace_hardirqs_on" [arch/x86/kvm/kvm-amd.ko] undefined!
ERROR: "lockdep_hardirqs_on" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: "lockdep_hardirqs_off" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: "__trace_hardirqs_off" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: "lockdep_hardirqs_on_prepare" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: "__trace_hardirqs_on" [arch/x86/kvm/kvm-intel.ko] undefined!

on allmodconfig.

I suppose them things need an EXPORT_SYMBOL_GPL() on them.
