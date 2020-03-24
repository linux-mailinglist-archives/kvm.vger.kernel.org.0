Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06682191D6F
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 00:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCXXWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 19:22:16 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46567 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgCXXWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 19:22:16 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGsra-0007qx-Pt; Wed, 25 Mar 2020 00:21:39 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 367BC100C51; Wed, 25 Mar 2020 00:21:38 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Paul McKenney <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes \(Google\)" <joel@joelfernandes.org>,
        "Steven Rostedt \(VMware\)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RESEND][patch V3 19/23] x86/kvm/vmx: Add hardirq tracing to guest enter/exit
In-Reply-To: <20200324230320.GX2452@worktop.programming.kicks-ass.net>
References: <20200320175956.033706968@linutronix.de> <20200320180034.297670977@linutronix.de> <20200324230320.GX2452@worktop.programming.kicks-ass.net>
Date:   Wed, 25 Mar 2020 00:21:38 +0100
Message-ID: <87o8slz6d9.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Fri, Mar 20, 2020 at 07:00:15PM +0100, Thomas Gleixner wrote:
>> The VMX code does not track hard interrupt state correctly. The state in
>> tracing and lockdep is 'OFF' all the way during guest mode. From the host
>> point of view this is wrong because the VMENTER reenables interrupts like a
>> return to user space and VMENTER disables them again like an entry from
>> user space.
>> 
>> Make it do exactly the same thing as enter/exit user mode does.
>> 
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> This patch (and the SVM counterpart) result in:
>
> ERROR: "lockdep_hardirqs_on" [arch/x86/kvm/kvm-amd.ko] undefined!
> ERROR: "lockdep_hardirqs_off" [arch/x86/kvm/kvm-amd.ko] undefined!
> ERROR: "__trace_hardirqs_off" [arch/x86/kvm/kvm-amd.ko] undefined!
> ERROR: "lockdep_hardirqs_on_prepare" [arch/x86/kvm/kvm-amd.ko] undefined!
> ERROR: "__trace_hardirqs_on" [arch/x86/kvm/kvm-amd.ko] undefined!
> ERROR: "lockdep_hardirqs_on" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: "lockdep_hardirqs_off" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: "__trace_hardirqs_off" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: "lockdep_hardirqs_on_prepare" [arch/x86/kvm/kvm-intel.ko] undefined!
> ERROR: "__trace_hardirqs_on" [arch/x86/kvm/kvm-intel.ko] undefined!
>
> on allmodconfig.
>
> I suppose them things need an EXPORT_SYMBOL_GPL() on them.

Indeed.
