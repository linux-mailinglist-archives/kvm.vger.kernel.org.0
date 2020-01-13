Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02C6139129
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 13:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgAMMgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 07:36:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33104 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMMga (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 07:36:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pJ1ajlLalSb1lnSWYzrZ3l95cR2DmPwww/lMVi/JmI8=; b=gGBpvza+J9GkHFPjo1zmKUMn+
        anND46i/9BDOMeU7JceBSIFp5gTujs10uCYe3iG/R06NirqZMIRQDsVgmLY2AHkc4afOCqFnSh4vB
        0Rpdp5jF4TQjAY021SKBbvURAawSBKXRrk0+vrq88VzjFhIWcD2ijHHnRFrBBhG6zQu+8QY9P/0cD
        tx8mZDbwkRuXktfh0FpKRJAGinJoDNMkFKXUk6klwdBLzi1iLUAVIe8i6LIQOHt7ivCNipOmVLubG
        OaTHrpXuli4LcHWKpVtzItd3N2qmBqGtCms5UVV3StB6soEF9YE8JpmYyQztuMnhUDEDIEZ74VRGX
        iEUqhlGmw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iqyws-000416-I6; Mon, 13 Jan 2020 12:36:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 33C63304121;
        Mon, 13 Jan 2020 13:34:23 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8A4392B6B2F93; Mon, 13 Jan 2020 13:35:58 +0100 (CET)
Date:   Mon, 13 Jan 2020 13:35:58 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KarimAllah <karahmed@amazon.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        christopher.s.hall@intel.com, hubert.chrzaniuk@intel.com,
        len.brown@intel.com, thomas.lendacky@amd.com, rjw@rjwysocki.net
Subject: Re: [PATCH RFC] sched/fair: Penalty the cfs task which executes
 mwait/hlt
Message-ID: <20200113123558.GF2827@hirez.programming.kicks-ass.net>
References: <1578448201-28218-1-git-send-email-wanpengli@tencent.com>
 <20200108155040.GB2827@hirez.programming.kicks-ass.net>
 <00d884a7-d463-74b4-82cf-9deb0aa70971@redhat.com>
 <CANRm+Cx0LMK1b2mJiU7edCDoRfPfGLzY1Zqr5paBEPcWFFALhQ@mail.gmail.com>
 <20200113104314.GU2844@hirez.programming.kicks-ass.net>
 <ee2b6da2-be8c-2540-29e9-ffbb9fdfd3fc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee2b6da2-be8c-2540-29e9-ffbb9fdfd3fc@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 13, 2020 at 12:52:20PM +0100, Paolo Bonzini wrote:
> On 13/01/20 11:43, Peter Zijlstra wrote:
> > So the very first thing we need to get sorted is that MPERF/TSC ratio
> > thing. TurboStat does it, but has 'funny' hacks on like:
> > 
> >   b2b34dfe4d9a ("tools/power turbostat: KNL workaround for %Busy and Avg_MHz")
> > 
> > and I imagine that there's going to be more exceptions there. You're
> > basically going to have to get both Intel and AMD to commit to this.
> > 
> > IFF we can get concensus on MPERF/TSC, then yes, that is a reasonable
> > way to detect a VCPU being idle I suppose. I've added a bunch of people
> > who seem to know about this.
> > 
> > Anyone, what will it take to get MPERF/TSC 'working' ?
> 
> Do we really need MPERF/TSC for this use case, or can we just track
> APERF as well and do MPERF/APERF to compute the "non-idle" time?

So MPERF runs at fixed frequency (when !IDLE and typically the same
frequency as TSC), APERF runs at variable frequency (when !IDLE)
depending on DVFS state.

So APERF/MPERF gives the effective frequency of the core, but since both
stop during IDLE, it will not be a good indication of IDLE.

Otoh, TSC doesn't stop in idle (.oO this depends on
X86_FEATURE_CONSTANT_TSC) and therefore the MPERF/TSC ratio gives how
much !idle time there was between readings.


