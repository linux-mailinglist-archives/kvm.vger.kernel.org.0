Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5DD5EAAC5
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 07:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfJaGzL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 31 Oct 2019 02:55:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:36926 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfJaGzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 02:55:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Oct 2019 23:55:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,250,1569308400"; 
   d="scan'208";a="375140915"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga005.jf.intel.com with ESMTP; 30 Oct 2019 23:55:09 -0700
Received: from fmsmsx122.amr.corp.intel.com (10.18.125.37) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 30 Oct 2019 23:55:08 -0700
Received: from shsmsx153.ccr.corp.intel.com (10.239.6.53) by
 fmsmsx122.amr.corp.intel.com (10.18.125.37) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 30 Oct 2019 23:55:08 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX153.ccr.corp.intel.com ([169.254.12.215]) with mapi id 14.03.0439.000;
 Thu, 31 Oct 2019 14:55:06 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
Subject: RE: [PATCH v1 8/8] perf/x86: Add event owner check when PEBS output
 to Intel PT
Thread-Topic: [PATCH v1 8/8] perf/x86: Add event owner check when PEBS
 output to Intel PT
Thread-Index: AQHVjLd7YuomyMFGekW7/CerqBL266dxNysAgAFIGiD///EXAIABvUSA
Date:   Thu, 31 Oct 2019 06:55:06 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E173836317@SHSMSX104.ccr.corp.intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
 <1572217877-26484-9-git-send-email-luwei.kang@intel.com>
 <20191029151302.GO4097@hirez.programming.kicks-ass.net>
 <82D7661F83C1A047AF7DC287873BF1E173835B6A@SHSMSX104.ccr.corp.intel.com>
 <20191030095400.GU4097@hirez.programming.kicks-ass.net>
In-Reply-To: <20191030095400.GU4097@hirez.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiN2MxY2Y0YWYtOTMwZC00MzM4LTljNjItY2UxZjJmMjVlNDk5IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiME1DZnZiMmtFajIyUGxXcXVqY0JUVmVhK0swVHpGNEtXN3cxXC9IdmJVMTVIb01cL0x3YkFiZHhwOFQyZUZFb2VFIn0=
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > > For PEBS output to Intel PT, a Intel PT event should be the group
> > > > leader of an PEBS counter event in host. For Intel PT
> > > > virtualization enabling in KVM guest, the PT facilities will be
> > > > passthrough to guest and do not allocate PT event from host perf
> > > > event framework. This is different with PMU virtualization.
> > > >
> > > > Intel new hardware feature that can make PEBS enabled in KVM guest
> > > > by output PEBS records to Intel PT buffer. KVM need to allocate a
> > > > event counter for this PEBS event without Intel PT event leader.
> > > >
> > > > This patch add event owner check for PEBS output to PT event that
> > > > only non-kernel event need group leader(PT).
> > > >
> > > > Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> > > > ---
> > > >  arch/x86/events/core.c     | 3 ++-
> > > >  include/linux/perf_event.h | 1 +
> > > >  kernel/events/core.c       | 2 +-
> > > >  3 files changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c index
> > > > 7b21455..214041a 100644
> > > > --- a/arch/x86/events/core.c
> > > > +++ b/arch/x86/events/core.c
> > > > @@ -1014,7 +1014,8 @@ static int collect_events(struct cpu_hw_events *cpuc, struct perf_event *leader,
> > > >  		 * away, the group was broken down and this singleton event
> > > >  		 * can't schedule any more.
> > > >  		 */
> > > > -		if (is_pebs_pt(leader) && !leader->aux_event)
> > > > +		if (is_pebs_pt(leader) && !leader->aux_event &&
> > > > +					!is_kernel_event(leader))
> > >
> > > indent fail, but also, I'm not sure I buy this.
> > >
> > > Surely pt-on-kvm has a perf event to claim PT for the vCPU context?
> >
> > Hi Peter,
> >     PT on KVM will not allocate perf events from host (this is different from performance counter). The guest PT MSRs value will be
> load to hardware directly before VM-entry.
> >     A PT event is needed by PEBS event as the event group leader in native. In virtualization, we can allocate a counter for PEBS but
> can't assign a PT event as the leader of this PEBS event.
> 
> Please, fix your MUA already.
> 
> Then how does KVM deal with the host using PT? You can't just steal PT.

Intel PT in virtualization can work in system and host_guest mode.
In system mode (default), the trace produced by host and guest will be saved in host PT buffer. Intel PT will not be exposed to guest in this mode.
 In host_guest mode, Intel PT will be exposed to guest and guest can use PT like native. The value of host PT register will be saved and guest PT register value will be restored during VM-entry. Both trace of host and guest are exported to their respective PT buffer. The host PT buffer not include guest trace in this mode.

Thanks,
Luwei Kang



