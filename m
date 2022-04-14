Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA115007FB
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 10:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbiDNILC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 04:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiDNILA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 04:11:00 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D0846171;
        Thu, 14 Apr 2022 01:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=s7m8aUZarjH0kMKNpCqlqnKae3PMDs6eLSAyWMfSdxQ=; b=cQEYeqRmFgzXIGvMPjdfew7nD2
        yIIYAcxVwHLpz2sxnKhIjCDP4qaiIG//PhwRKGh1Z0XMnLvgqGRc5/oiK01V8QbQ5byLslYKGVd65
        WEMDpYjsPhD+MudsSxd2ce7LB9bmUeyVOsnCOI2h8SXVsDtImS3NmdVW/0d6ZQxnEEZ5+SbYTqxOH
        BmfE2RcB3VJznEBMKsWpDI5uChxbS+IaErJxxvCPmo0qNJ1TJgMyWy0W2NE8O49pI48qYGCEISkxh
        EWHnlT4OAIEK6Tzv28lfVZDSsNZXybupvOu99SgcDmfCkd6jhRanpxrnDDc2qx/qh+7nBImAI8rOc
        gNX0LA/Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1neuWM-004x5O-2x; Thu, 14 Apr 2022 08:08:06 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id A23CE981548; Thu, 14 Apr 2022 10:08:03 +0200 (CEST)
Date:   Thu, 14 Apr 2022 10:08:03 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 3/5] KVM: X86: Boost vCPU which is in critical section
Message-ID: <20220414080803.GZ2731@worktop.programming.kicks-ass.net>
References: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
 <1648800605-18074-4-git-send-email-wanpengli@tencent.com>
 <YldD56m2nEUPLwx1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YldD56m2nEUPLwx1@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022 at 09:43:03PM +0000, Sean Christopherson wrote:
> +tglx and PeterZ
> 
> On Fri, Apr 01, 2022, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> > 
> > The missing semantic gap that occurs when a guest OS is preempted 
> > when executing its own critical section, this leads to degradation 
> > of application scalability. We try to bridge this semantic gap in 
> > some ways, by passing guest preempt_count to the host and checking 
> > guest irq disable state, the hypervisor now knows whether guest 
> > OSes are running in the critical section, the hypervisor yield-on-spin 
> > heuristics can be more smart this time to boost the vCPU candidate 
> > who is in the critical section to mitigate this preemption problem, 
> > in addition, it is more likely to be a potential lock holder.
> > 
> > Testing on 96 HT 2 socket Xeon CLX server, with 96 vCPUs VM 100GB RAM,
> > one VM running benchmark, the other(none-2) VMs running cpu-bound 
> > workloads, There is no performance regression for other benchmarks 
> > like Unixbench etc.
> 
> ...
> 
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> >  arch/x86/kvm/x86.c       | 22 ++++++++++++++++++++++
> >  include/linux/kvm_host.h |  1 +
> >  virt/kvm/kvm_main.c      |  7 +++++++
> >  3 files changed, 30 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9aa05f79b743..b613cd2b822a 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10377,6 +10377,28 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
> >  	return r;
> >  }
> >  
> > +static bool kvm_vcpu_is_preemptible(struct kvm_vcpu *vcpu)
> > +{
> > +	int count;
> > +
> > +	if (!vcpu->arch.pv_pc.preempt_count_enabled)
> > +		return false;
> > +
> > +	if (!kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_pc.preempt_count_cache,
> > +	    &count, sizeof(int)))
> > +		return !(count & ~PREEMPT_NEED_RESCHED);
> 
> As I pointed out in v1[*], this makes PREEMPT_NEED_RESCHED and really the entire
> __preempt_count to some extent, KVM guest/host ABI.  That needs acks from sched
> folks, and if they're ok with it, needs to be formalized somewhere in kvm_para.h,
> not buried in the KVM host code.

Right, not going to happen. There's been plenty changes to
__preempt_count over the past years, suggesting that making it ABI will
be an incredibly bad idea.

It also only solves part of the problem; namely spinlocks, but doesn't
help at all with mutexes, which can be equally short lived, as evidenced
by the adaptive spinning mutex code etc..

Also, I'm not sure I fully understand the problem, doesn't the paravirt
spinlock code give sufficient clues?
