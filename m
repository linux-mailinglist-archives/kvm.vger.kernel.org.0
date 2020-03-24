Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FECC1909EA
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 10:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgCXJry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 05:47:54 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44248 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgCXJry (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 05:47:54 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGg9j-0000xm-7b; Tue, 24 Mar 2020 10:47:31 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 39C86100292; Tue, 24 Mar 2020 10:47:30 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Paul McKenney <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes \(Google\)" <joel@joelfernandes.org>,
        "Steven Rostedt \(VMware\)" <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [patch V3 04/23] kprobes: Prevent probes in .noinstr.text section
In-Reply-To: <20200324144953.eec3e73f249901582bdf564e@kernel.org>
References: <20200320175956.033706968@linutronix.de> <20200320180032.799569116@linutronix.de> <20200323230025.a24f949a2143dbd5f208f00c@kernel.org> <87mu87oy7n.fsf@nanos.tec.linutronix.de> <20200324144953.eec3e73f249901582bdf564e@kernel.org>
Date:   Tue, 24 Mar 2020 10:47:30 +0100
Message-ID: <87369yf5jh.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Masami Hiramatsu <mhiramat@kernel.org> writes:
> On Mon, 23 Mar 2020 17:03:24 +0100
> Thomas Gleixner <tglx@linutronix.de> wrote:
>> > @@ -2212,6 +2212,10 @@ static int __init populate_kprobe_blacklist(unsigned long *start,
>> >  	ret = kprobe_add_area_blacklist((unsigned long)__kprobes_text_start,
>> >  					(unsigned long)__kprobes_text_end);
>> >  
>> > +	/* Symbols in noinstr section are blacklisted */
>> > +	ret = kprobe_add_area_blacklist((unsigned long)__noinstr_text_start,
>> > +					(unsigned long)__noinstr_text_end);
>> > +
>> >  	return ret ? : arch_populate_kprobe_blacklist();
>> >  }
>> 
>> So that extra function is not required when adding that, right?
>
> That's right :)
>
>> 
>> >> +/* Functions in .noinstr.text must not be probed */
>> >> +static bool within_noinstr_text(unsigned long addr)
>> >> +{
>> >> +	/* FIXME: Handle module .noinstr.text */
>
> And this reminds me that the module .kprobes.text is not handled yet :(.

Correct. Any idea how to do that with a simple oneliner like the above?

Thanks,

        tglx
