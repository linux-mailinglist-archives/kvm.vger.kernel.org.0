Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F5B7F668
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 14:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731420AbfHBMEM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 08:04:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731018AbfHBMEM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 08:04:12 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD98330821A0;
        Fri,  2 Aug 2019 12:04:11 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.136])
        by smtp.corp.redhat.com (Postfix) with SMTP id AC4DA5D704;
        Fri,  2 Aug 2019 12:04:08 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri,  2 Aug 2019 14:04:11 +0200 (CEST)
Date:   Fri, 2 Aug 2019 14:04:07 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [patch 2/5] x86/kvm: Handle task_work on VMENTER/EXIT
Message-ID: <20190802120407.GB20111@redhat.com>
References: <20190801143250.370326052@linutronix.de>
 <20190801143657.887648487@linutronix.de>
 <20190801162451.GE31538@redhat.com>
 <alpine.DEB.2.21.1908012025100.1789@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908012025100.1789@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 02 Aug 2019 12:04:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01, Thomas Gleixner wrote:
>
> On Thu, 1 Aug 2019, Oleg Nesterov wrote:
> > On 08/01, Thomas Gleixner wrote:
> > >
> > > @@ -8172,6 +8174,10 @@ static int vcpu_run(struct kvm_vcpu *vcp
> > >  			++vcpu->stat.signal_exits;
> > >  			break;
> > >  		}
> > > +
> > > +		if (notify_resume_pending())
> > > +			tracehook_handle_notify_resume();
> >
> > shouldn't you drop kvm->srcu before tracehook_handle_notify_resume() ?
> >
> > I don't understand this code at all, but vcpu_run() does this even before
> > cond_resched().
>
> Yeah, I noticed that it's dropped around cond_resched().
>
> My understanding is that for voluntary giving up the CPU via cond_resched()
> it needs to be dropped.

I am not sure it really needs, but this doesn't matter.

tracehook_handle_notify_resume() can do "anything", say it can run the
works queued by systemtap. I don't think it should delay synchronize_srcu().
And may be this is simply unsafe, even if I don't think a task_work can
ever call synchronize_srcu(kvm->srcu) directly.

Oleg.

