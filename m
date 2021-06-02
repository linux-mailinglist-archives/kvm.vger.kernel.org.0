Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C69B398C9A
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhFBOXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhFBOXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:23:00 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98DDC061756;
        Wed,  2 Jun 2021 07:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jwYPkOxp8bIiCCDES8Qxb1QGLyBu3SVZdBROZyNFfA0=; b=Xxv615xncdZQEFrr1bHRLMMu2U
        OqaCFWc54sHFbTJW13AtDPYewqZ8YcVTPwpd9Qc5OnoRpWsz8cfAQ9eSQ5KwoRC3/+EzjpcSDWh0H
        7W8reQPpnsPRXAwnvQmGxgENdJISBUxRfQv5GPB1VAMjsjLbgKsStP7MzLEasOohCJxysGOkYECMg
        Gwxo27rOG3a3S55yEdquv7sYRJNKvPMn8Kfz+MsY9z6svoP1ekd/je9c+Jaqi8y/arGNfbGhikW+b
        mNh4hH1eic9Rqr3hoPm+9JiRu5HuJ/MAdfZebjLsT7iBJPHGKrZ9jTKO2FPHmhESyUiqFe2yraAZt
        seVktLsg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loRjL-002ucj-FS; Wed, 02 Jun 2021 14:20:30 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 09CFB300269;
        Wed,  2 Jun 2021 16:20:29 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EBF7120223DBF; Wed,  2 Jun 2021 16:20:28 +0200 (CEST)
Date:   Wed, 2 Jun 2021 16:20:28 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, bristot <bristot@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86 <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        dm-devel <dm-devel@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        acme <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        paulmck <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Joel Fernandes, Google" <joel@joelfernandes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cgroups <cgroups@vger.kernel.org>,
        kgdb-bugreport <kgdb-bugreport@lists.sourceforge.net>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        linux-pm <linux-pm@vger.kernel.org>, rcu <rcu@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/6] sched: Change task_struct::state
Message-ID: <YLeTrNDgBnAMMwEX@hirez.programming.kicks-ass.net>
References: <20210602131225.336600299@infradead.org>
 <20210602133040.587042016@infradead.org>
 <896642516.5866.1622642818225.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <896642516.5866.1622642818225.JavaMail.zimbra@efficios.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 10:06:58AM -0400, Mathieu Desnoyers wrote:
> ----- On Jun 2, 2021, at 9:12 AM, Peter Zijlstra peterz@infradead.org wrote:

> > @@ -134,14 +134,14 @@ struct task_group;
> > 	do {							\
> > 		WARN_ON_ONCE(is_special_task_state(state_value));\
> > 		current->task_state_change = _THIS_IP_;		\
> > -		current->state = (state_value);			\
> > +		WRITE_ONCE(current->__state, (state_value));	\
> > 	} while (0)
> 
> Why not introduce set_task_state(p) and get_task_state(p) rather than sprinkle
> READ_ONCE() and WRITE_ONCE() all over the kernel ?

set_task_state() is fundamentally unsound, there's very few sites that
_set_ state on anything other than current, and those sites are super
tricky, eg. ptrace.

Having get_task_state() would seem to suggest it's actually a sane thing
to do, it's not really. Inspecting remote state is full of races, and
some of that really wants cleaning up, but that's for another day.
