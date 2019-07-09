Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D83F6360E
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 14:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfGIMix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 08:38:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38066 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfGIMiw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 08:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AkO0qGwBqpTh3ze3nd2E/zoDfg+sbnDSZsXsHUXKFtg=; b=OWdldj2rR1D83RUzoQFzQwo+N
        SByCu3cdtGi001/bgVfqRlgTrBDcgrjzSQs/YLoiPSGYfq6krg67DuRugNqfrTEdFd6U+hcDSY3D3
        y+rc4wioob7F3xhuP3+/xf5lSlr2i1HzOawA/XBf7xt/lUtwLxMRbeG35j7p8WFbHf2yoe/VVWAXi
        9koVK59wRHHDlxBJCNajnyat0t7vtgSk7sAZHzB1Hghtk3IqSlhx1wakdBc8eFNFDFhzBh7r4KRwU
        fRnHa79TK7gHM7zDvIvJ0PD0nOvVot3XTzfOBX8vlyaJL9vRgNjJw/SGEZnPqe6VxsyrtgfhCflaX
        4QQy/+OeA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hkpOK-0006bA-Ic; Tue, 09 Jul 2019 12:38:40 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6AA4720976D9C; Tue,  9 Jul 2019 14:38:38 +0200 (CEST)
Date:   Tue, 9 Jul 2019 14:38:38 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ankur Arora <ankur.a.arora@oracle.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: cputime takes cstate into consideration
Message-ID: <20190709123838.GA3402@hirez.programming.kicks-ass.net>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
 <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
 <20190626145413.GE6753@char.us.oracle.com>
 <1561575536.25880.10.camel@amazon.de>
 <alpine.DEB.2.21.1906262119430.32342@nanos.tec.linutronix.de>
 <7f721d94-aa19-20a4-6930-9ed4d1cd4834@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f721d94-aa19-20a4-6930-9ed4d1cd4834@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 08, 2019 at 07:00:08PM -0700, Ankur Arora wrote:
> On 2019-06-26 12:23 p.m., Thomas Gleixner wrote:
> > On Wed, 26 Jun 2019, Raslan, KarimAllah wrote:
> > > On Wed, 2019-06-26 at 10:54 -0400, Konrad Rzeszutek Wilk wrote:
> > > > There were some ideas that Ankur (CC-ed) mentioned to me of using the perf
> > > > counters (in the host) to sample the guest and construct a better
> > > > accounting idea of what the guest does. That way the dashboard
> > > > from the host would not show 100% CPU utilization.
> > > 
> > > You can either use the UNHALTED cycles perf-counter or you can use MPERF/APERF
> > > MSRs for that. (sorry I got distracted and forgot to send the patch)
> > 
> > Sure, but then you conflict with the other people who fight tooth and nail
> > over every single performance counter.
> How about using Intel PT PwrEvt extensions? This should allow us to
> precisely track idle residency via just MWAIT and TSC packets. Should
> be pretty cheap too. It's post Cascade Lake though.

That would fully claim PT just for this stupid accounting thing and be
completely Intel specific.

Just stop this madness already.
