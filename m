Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7B0E998C
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 10:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfJ3JyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 05:54:16 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40110 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfJ3JyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Oct 2019 05:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IypdXo2BjPTNYwDWeB+njTi8FJ2gNBSS1QRTWSa8df4=; b=bPuSTciOW5f+Mliv3i/eKysqU
        o2lrMX0BUq+c/91/ziGJbSJDos5HPlwTRVnylRvFlWy/GdTi9nBUqcxQDYjkMk+1BWx8zOQnFPdB4
        qSOe4NLP88ODzurO6AiDMq2L/yZtSmJCZ3AHS1AlazcNc6O2MbUMnSN1g5+3buy4y0VR4kQU0AumT
        RTOTafxxE/6TpzZyla71kbaCSB4STurKHXNYSevCUo3LlUHCn59Ll7m8zS85eeXhu0o7zrixCR88S
        JUekYvS7BFOQNJjV+0mZdDWwmVZsCXMhKlGB8pILly2CTU9gbjLkPNpAMuEk7aFJH1mPU9gXdZQ52
        r1z37pmFA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPkfy-0002Gm-7G; Wed, 30 Oct 2019 09:54:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 82C4230025A;
        Wed, 30 Oct 2019 10:52:59 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9DD452B4574F5; Wed, 30 Oct 2019 10:54:00 +0100 (CET)
Date:   Wed, 30 Oct 2019 10:54:00 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Kang, Luwei" <luwei.kang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "alexander.shishkin@linux.intel.com" 
        <alexander.shishkin@linux.intel.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: Re: [PATCH v1 8/8] perf/x86: Add event owner check when PEBS output
 to Intel PT
Message-ID: <20191030095400.GU4097@hirez.programming.kicks-ass.net>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-9-git-send-email-luwei.kang@intel.com>
 <20191029151302.GO4097@hirez.programming.kicks-ass.net>
 <82D7661F83C1A047AF7DC287873BF1E173835B6A@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82D7661F83C1A047AF7DC287873BF1E173835B6A@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 30, 2019 at 04:07:31AM +0000, Kang, Luwei wrote:
> > > For PEBS output to Intel PT, a Intel PT event should be the group
> > > leader of an PEBS counter event in host. For Intel PT virtualization
> > > enabling in KVM guest, the PT facilities will be passthrough to guest
> > > and do not allocate PT event from host perf event framework. This is
> > > different with PMU virtualization.
> > >
> > > Intel new hardware feature that can make PEBS enabled in KVM guest by
> > > output PEBS records to Intel PT buffer. KVM need to allocate a event
> > > counter for this PEBS event without Intel PT event leader.
> > >
> > > This patch add event owner check for PEBS output to PT event that only
> > > non-kernel event need group leader(PT).
> > >
> > > Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> > > ---
> > >  arch/x86/events/core.c     | 3 ++-
> > >  include/linux/perf_event.h | 1 +
> > >  kernel/events/core.c       | 2 +-
> > >  3 files changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c index
> > > 7b21455..214041a 100644
> > > --- a/arch/x86/events/core.c
> > > +++ b/arch/x86/events/core.c
> > > @@ -1014,7 +1014,8 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
> > >  		 * away, the group was broken down and this singleton event
> > >  		 * can't schedule any more.
> > >  		 */
> > > -		if (is_pebs_pt(leader) && !leader->aux_event)
> > > +		if (is_pebs_pt(leader) && !leader->aux_event &&
> > > +					!is_kernel_event(leader))
> > 
> > indent fail, but also, I'm not sure I buy this.
> > 
> > Surely pt-on-kvm has a perf event to claim PT for the vCPU context?
> 
> Hi Peter,
>     PT on KVM will not allocate perf events from host (this is different from performance counter). The guest PT MSRs value will be load to hardware directly before VM-entry.
>     A PT event is needed by PEBS event as the event group leader in native. In virtualization, we can allocate a counter for PEBS but can't assign a PT event as the leader of this PEBS event.

Please, fix your MUA already.

Then how does KVM deal with the host using PT? You can't just steal PT.
