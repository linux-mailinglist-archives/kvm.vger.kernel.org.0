Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA10F13B56F
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 23:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgANWqU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 17:46:20 -0500
Received: from cloudserver094114.home.pl ([79.96.170.134]:42652 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgANWqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 17:46:20 -0500
Received: from 79.184.255.90.ipv4.supernova.orange.pl (79.184.255.90) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.320)
 id 83a96a032f232429; Tue, 14 Jan 2020 23:46:18 +0100
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        KarimAllah <karahmed@amazon.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        christopher.s.hall@intel.com, hubert.chrzaniuk@intel.com,
        len.brown@intel.com, thomas.lendacky@amd.com
Subject: Re: [PATCH RFC] sched/fair: Penalty the cfs task which executes mwait/hlt
Date:   Tue, 14 Jan 2020 23:46:18 +0100
Message-ID: <1868711.0LYWRWiNKV@kreacher>
In-Reply-To: <20200113122911.GE2827@hirez.programming.kicks-ass.net>
References: <1578448201-28218-1-git-send-email-wanpengli@tencent.com> <2579281.NS3xOKR7ft@kreacher> <20200113122911.GE2827@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Monday, January 13, 2020 1:29:11 PM CET Peter Zijlstra wrote:
> On Mon, Jan 13, 2020 at 12:18:46PM +0100, Rafael J. Wysocki wrote:
> > On Monday, January 13, 2020 11:43:14 AM CET Peter Zijlstra wrote:
> 
> > > Anyone, what will it take to get MPERF/TSC 'working' ?
> > 
> > The same thing that intel_pstate does.
> 
> But intel_pstate cheats, it has a FMS listing and possible 'interesting'
> chips are excluded. For instance, Core2 has APERF/MPERF, but
> intel_pstate does not support Core2.
> 
> Simlarly, intel_pstate does (obviously) not support AMD chips, even tho
> those have APERF/MPERF.
> 
> Although I suppose Core2 doesn't have VMX and is therefore less
> interesting, but then we'd need to gate the logic with something like:
> 
> 	static_cpu_has(X86_FEATURE_APERFMPERF) &&
> 	(static_cpu_has(X86_FEATURE_VMX) || static_cpu_has(X86_FEATURE_SVM)
> 
> > Generally speaking, it shifts the mperf values by a number of positions
> > depending on the CPU model, but that is 1 except for KNL.
> > 
> > See get_target_pstate().
> 
> I'm going to go out on a limb and guess that's the same KNL hack as
> TurboStat has.
> 
> Is that really the only known case?

I'm not aware of any other at least as far as Intel chips go.



