Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF6A192A3C
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 14:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgCYNjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 09:39:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbgCYNjy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 09:39:54 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90A142078A;
        Wed, 25 Mar 2020 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585143593;
        bh=yuWwvozHMKKmR/O++GIvoJ2kBVPow876tzB+1f2Q4l0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZKSjNK+PGupENdbT3vo6xXKF8HEAd7hVYRtJE30Dp8043BwMGlbUq6Y5zoMn4Ewt8
         7MFxtob35Un3x2aJFhQeEGHEcIx5xBYguNvaRg90BX32Qrtz96jSlvaqo58E/P7E+s
         wYBu3W4QT6EEI76IxcQky4diZZAXmyIY3qwI33Ts=
Date:   Wed, 25 Mar 2020 22:39:46 +0900
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
Message-Id: <20200325223946.837da768d92102b47c833ba3@kernel.org>
In-Reply-To: <87369yf5jh.fsf@nanos.tec.linutronix.de>
References: <20200320175956.033706968@linutronix.de>
        <20200320180032.799569116@linutronix.de>
        <20200323230025.a24f949a2143dbd5f208f00c@kernel.org>
        <87mu87oy7n.fsf@nanos.tec.linutronix.de>
        <20200324144953.eec3e73f249901582bdf564e@kernel.org>
        <87369yf5jh.fsf@nanos.tec.linutronix.de>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Mar 2020 10:47:30 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> Masami Hiramatsu <mhiramat@kernel.org> writes:
> > On Mon, 23 Mar 2020 17:03:24 +0100
> > Thomas Gleixner <tglx@linutronix.de> wrote:
> >> > @@ -2212,6 +2212,10 @@ static int __init populate_kprobe_blacklist(unsigned long *start,
> >> >  	ret = kprobe_add_area_blacklist((unsigned long)__kprobes_text_start,
> >> >  					(unsigned long)__kprobes_text_end);
> >> >  
> >> > +	/* Symbols in noinstr section are blacklisted */
> >> > +	ret = kprobe_add_area_blacklist((unsigned long)__noinstr_text_start,
> >> > +					(unsigned long)__noinstr_text_end);
> >> > +
> >> >  	return ret ? : arch_populate_kprobe_blacklist();
> >> >  }
> >> 
> >> So that extra function is not required when adding that, right?
> >
> > That's right :)
> >
> >> 
> >> >> +/* Functions in .noinstr.text must not be probed */
> >> >> +static bool within_noinstr_text(unsigned long addr)
> >> >> +{
> >> >> +	/* FIXME: Handle module .noinstr.text */
> >
> > And this reminds me that the module .kprobes.text is not handled yet :(.
> 
> Correct. Any idea how to do that with a simple oneliner like the above?

Hmm, we can store the .kprobes.text and .noinstr.text section info in the struct
module and register it in module callback. But before that, I have to introduce
a remove function. Currently, the blacklist can only add symbols. So that will
not be a oneliner.

Let me try.

Thank you,


-- 
Masami Hiramatsu <mhiramat@kernel.org>
