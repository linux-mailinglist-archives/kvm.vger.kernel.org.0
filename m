Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1B11D9A87
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 16:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbgESO7L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 10:59:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53162 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbgESO7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 10:59:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=iDRSv4J4B4xFK8cXysXCGc6Xy6/lr+lLLXlM45hQqIw=; b=N9MDY5T+hbZmkPK/gFmMYLlxeb
        qzwVUpmIbf5icmwzDCNFRXwwT4lhbty+6JzJ3ydROXYeZM3G/kvhgAEjbSJPUYipEyBghU3dxomRX
        WUdZvc7U1Zzg4Nwq3kqCleZUiCnUQbEHErs/SdWI9McbnVIvs0cG4bTMqtCXq7oGBB5U8atXOLk3R
        hUejaB5AXP2M863tNSjMw04ahlg5ic2AzeDRerfDBKmyDRhv8gVqOF8HM59mfmTgX9F5AzyLZ2Cqy
        dxOxUXCiYzSExjx258fDvD8H3eMQOimE39t8F1UIlWfpB5Fq/kD91MCr1v9jgukF7GJVlPfb4GguI
        IsNiF13Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb3gx-0002Nz-Ly; Tue, 19 May 2020 14:58:03 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4B145301A80;
        Tue, 19 May 2020 16:57:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 361E922B8C6B5; Tue, 19 May 2020 16:57:56 +0200 (CEST)
Date:   Tue, 19 May 2020 16:57:56 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Like Xu <like.xu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
Subject: Re: [PATCH v11 10/11] KVM: x86/pmu: Check guest LBR availability in
 case host reclaims them
Message-ID: <20200519145756.GC317569@hirez.programming.kicks-ass.net>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-11-like.xu@linux.intel.com>
 <20200519111559.GJ279861@hirez.programming.kicks-ass.net>
 <3a234754-e103-907f-9b06-44b5e7ae12d3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3a234754-e103-907f-9b06-44b5e7ae12d3@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 19, 2020 at 09:10:58PM +0800, Xu, Like wrote:
> On 2020/5/19 19:15, Peter Zijlstra wrote:
> > On Thu, May 14, 2020 at 04:30:53PM +0800, Like Xu wrote:
> > 
> > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > > index ea4faae56473..db185dca903d 100644
> > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > @@ -646,6 +646,43 @@ static void intel_pmu_lbr_cleanup(struct kvm_vcpu *vcpu)
> > >   		intel_pmu_free_lbr_event(vcpu);
> > >   }
> > > +static bool intel_pmu_lbr_is_availabile(struct kvm_vcpu *vcpu)
> > > +{
> > > +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > > +
> > > +	if (!pmu->lbr_event)
> > > +		return false;
> > > +
> > > +	if (event_is_oncpu(pmu->lbr_event)) {
> > > +		intel_pmu_intercept_lbr_msrs(vcpu, false);
> > > +	} else {
> > > +		intel_pmu_intercept_lbr_msrs(vcpu, true);
> > > +		return false;
> > > +	}
> > > +
> > > +	return true;
> > > +}
> > This is unreadable gunk, what?
> 
> Abstractly, it is saying "KVM would passthrough the LBR satck MSRs if
> event_is_oncpu() is true, otherwise cancel the passthrough state if any."
> 
> I'm using 'event->oncpu != -1' to represent the guest LBR event
> is scheduled on rather than 'event->state == PERF_EVENT_STATE_ERROR'.
> 
> For intel_pmu_intercept_lbr_msrs(), false means to passthrough the LBR stack
> MSRs to the vCPU, and true means to cancel the passthrough state and make
> LBR MSR accesses trapped by the KVM.

To me it seems very weird to change state in a function that is supposed
to just query state.

'is_available' seems to suggest a simple: return 'lbr_event->state ==
PERF_EVENT_STATE_ACTIVE' or something.


> > > +static void intel_pmu_availability_check(struct kvm_vcpu *vcpu)
> > > +{
> > > +	lockdep_assert_irqs_disabled();
> > > +
> > > +	if (lbr_is_enabled(vcpu) && !intel_pmu_lbr_is_availabile(vcpu) &&
> > > +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
> > > +		pr_warn_ratelimited("kvm: vcpu-%d: LBR is temporarily unavailable.\n",
> > > +			vcpu->vcpu_id);
> > More unreadable nonsense; when the events go into ERROR state, it's a
> > permanent fail, they'll not come back.
> It's not true.  The guest LBR event with 'ERROR state' or 'oncpu != -1'
> would be
> lazy released and re-created in the next time the
> intel_pmu_create_lbr_event() is
> called and it's supposed to be re-scheduled and re-do availability_check()
> as well.

Where? Also, wth would you need to destroy and re-create an event for
that?

> > > @@ -6696,8 +6696,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> > >   	pt_guest_enter(vmx);
> > > -	if (vcpu_to_pmu(vcpu)->version)
> > > +	if (vcpu_to_pmu(vcpu)->version) {
> > >   		atomic_switch_perf_msrs(vmx);
> > > +		kvm_x86_ops.pmu_ops->availability_check(vcpu);
> > > +	}
> > AFAICT you just did a call out to the kvm_pmu crud in
> > atomic_switch_perf_msrs(), why do another call?
> In fact, availability_check() is only called here for just one time.
> 
> The callchain looks like:
> - vmx_vcpu_run()
>     - kvm_x86_ops.pmu_ops->availability_check();
>         - intel_pmu_availability_check()
>             - intel_pmu_lbr_is_availabile()
>                 - event_is_oncpu() ...
> 

What I'm saying is that you just did a pmu_ops indirect call in
atomic_switch_perf_msrs(), why add another?
