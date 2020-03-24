Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94AFD190555
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 06:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgCXFuA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 01:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgCXFuA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 01:50:00 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D1B420724;
        Tue, 24 Mar 2020 05:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585028999;
        bh=yQnsvwhZXQ8wrEvynPUDNp4fQACNGhXn8ZnbVJxLhUk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=je5uGnLpPYNeLLu2JHUQ10gAQRnSIobdt/d5E5ToyOqsHfbK7XbHdM8ze+G0SWAmq
         cAcgQyaeHe5NejiG9GZ6e0nWV4WqhFagubfpDkXChr+oJRX4mmDkxUyhtyAP5fDy3X
         ovVS2JCrJYhyPNiKLKMwcyEQsCDEEL1TNfcpO6s4=
Date:   Tue, 24 Mar 2020 14:49:53 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
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
Subject: Re: [patch V3 04/23] kprobes: Prevent probes in .noinstr.text
 section
Message-Id: <20200324144953.eec3e73f249901582bdf564e@kernel.org>
In-Reply-To: <87mu87oy7n.fsf@nanos.tec.linutronix.de>
References: <20200320175956.033706968@linutronix.de>
        <20200320180032.799569116@linutronix.de>
        <20200323230025.a24f949a2143dbd5f208f00c@kernel.org>
        <87mu87oy7n.fsf@nanos.tec.linutronix.de>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Mar 2020 17:03:24 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> Masami,
> 
> Masami Hiramatsu <mhiramat@kernel.org> writes:
> > On Fri, 20 Mar 2020 19:00:00 +0100
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> >> Instrumentation is forbidden in the .noinstr.text section. Make kprobes
> >> respect this.
> >> 
> >> This lacks support for .noinstr.text sections in modules, which is required
> >> to handle VMX and SVM.
> >> 
> >
> > Would you have any plan to list or mark the noinstr symbols on
> > some debugfs interface? I need a blacklist of those symbols so that
> > user (and perf-probe) can check which function can not be probed.
> >
> > It is just calling kprobe_add_area_blacklist() like below.
> >
> > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> > index 2625c241ac00..4835b644bd2b 100644
> > --- a/kernel/kprobes.c
> > +++ b/kernel/kprobes.c
> > @@ -2212,6 +2212,10 @@ static int __init populate_kprobe_blacklist(unsigned long *start,
> >  	ret = kprobe_add_area_blacklist((unsigned long)__kprobes_text_start,
> >  					(unsigned long)__kprobes_text_end);
> >  
> > +	/* Symbols in noinstr section are blacklisted */
> > +	ret = kprobe_add_area_blacklist((unsigned long)__noinstr_text_start,
> > +					(unsigned long)__noinstr_text_end);
> > +
> >  	return ret ? : arch_populate_kprobe_blacklist();
> >  }
> 
> So that extra function is not required when adding that, right?

That's right :)

> 
> >> +/* Functions in .noinstr.text must not be probed */
> >> +static bool within_noinstr_text(unsigned long addr)
> >> +{
> >> +	/* FIXME: Handle module .noinstr.text */

And this reminds me that the module .kprobes.text is not handled yet :(.

Thank you,

> >> +	return addr >= (unsigned long)__noinstr_text_start &&
> >> +	       addr < (unsigned long)__noinstr_text_end;
> >> +}
> >> +
> >>  bool within_kprobe_blacklist(unsigned long addr)
> >>  {
> >>  	char symname[KSYM_NAME_LEN], *p;
> >>  
> >> +	if (within_noinstr_text(addr))
> >> +		return true;
> >> +
> >>  	if (__within_kprobe_blacklist(addr))
> >>  		return true;


-- 
Masami Hiramatsu <mhiramat@kernel.org>
