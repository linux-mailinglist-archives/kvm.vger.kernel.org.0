Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA621D950A
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 13:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbgESLQc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 07:16:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33390 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgESLQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 07:16:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0LhBPYF7Etu/FHeJftm3ehboKFuLvunUInUXuPg2u/A=; b=kqA8ASBuk6KBuEoEi1C0hnnNXH
        QgR5oL5CfN2Tkb8qDZbH7J0JhNz71FE/de7R0sg0cM1kO+jTnIJv9spy3KQPKDtb4OpugxPd+jkma
        e+Gw9KW7GQQSmiq4CwdVjxz4wtCjaQ82qD8yWASOLxGb7S+CbbKLqpJe6TdVWzclYi5TYot3WLtNs
        jdDP/3tucZrk7BFA9YfXdZdj8bQHDLCDrpJejYdXxjcehuQkcNbCYhiSmiMMf+DwM+U5vI5HLP1Wf
        n5U320t9+x9Q8AoxPqQRSRvQZXV+usfodcy6q1Ba2J/bKjb2pWggwEjSi+7H7wR6PnWKgZ65qkpTp
        /aAvmHBw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jb0E6-0005rZ-10; Tue, 19 May 2020 11:16:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1DF10301A80;
        Tue, 19 May 2020 13:16:00 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 08BBA2B7E294F; Tue, 19 May 2020 13:15:59 +0200 (CEST)
Date:   Tue, 19 May 2020 13:15:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com
Subject: Re: [PATCH v11 10/11] KVM: x86/pmu: Check guest LBR availability in
 case host reclaims them
Message-ID: <20200519111559.GJ279861@hirez.programming.kicks-ass.net>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
 <20200514083054.62538-11-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514083054.62538-11-like.xu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 14, 2020 at 04:30:53PM +0800, Like Xu wrote:

> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index ea4faae56473..db185dca903d 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -646,6 +646,43 @@ static void intel_pmu_lbr_cleanup(struct kvm_vcpu *vcpu)
>  		intel_pmu_free_lbr_event(vcpu);
>  }
>  
> +static bool intel_pmu_lbr_is_availabile(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	if (!pmu->lbr_event)
> +		return false;
> +
> +	if (event_is_oncpu(pmu->lbr_event)) {
> +		intel_pmu_intercept_lbr_msrs(vcpu, false);
> +	} else {
> +		intel_pmu_intercept_lbr_msrs(vcpu, true);
> +		return false;
> +	}
> +
> +	return true;
> +}

This is unreadable gunk, what?

> +/*
> + * Higher priority host perf events (e.g. cpu pinned) could reclaim the
> + * pmu resources (e.g. LBR) that were assigned to the guest. This is
> + * usually done via ipi calls (more details in perf_install_in_context).
> + *
> + * Before entering the non-root mode (with irq disabled here), double
> + * confirm that the pmu features enabled to the guest are not reclaimed
> + * by higher priority host events. Otherwise, disallow vcpu's access to
> + * the reclaimed features.
> + */
> +static void intel_pmu_availability_check(struct kvm_vcpu *vcpu)
> +{
> +	lockdep_assert_irqs_disabled();
> +
> +	if (lbr_is_enabled(vcpu) && !intel_pmu_lbr_is_availabile(vcpu) &&
> +		(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
> +		pr_warn_ratelimited("kvm: vcpu-%d: LBR is temporarily unavailable.\n",
> +			vcpu->vcpu_id);

More unreadable nonsense; when the events go into ERROR state, it's a
permanent fail, they'll not come back.

> +}
> +
>  struct kvm_pmu_ops intel_pmu_ops = {
>  	.find_arch_event = intel_find_arch_event,
>  	.find_fixed_event = intel_find_fixed_event,
> @@ -662,4 +699,5 @@ struct kvm_pmu_ops intel_pmu_ops = {
>  	.reset = intel_pmu_reset,
>  	.deliver_pmi = intel_pmu_deliver_pmi,
>  	.lbr_cleanup = intel_pmu_lbr_cleanup,
> +	.availability_check = intel_pmu_availability_check,
>  };
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9969d663826a..80d036c5f64a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6696,8 +6696,10 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  
>  	pt_guest_enter(vmx);
>  
> -	if (vcpu_to_pmu(vcpu)->version)
> +	if (vcpu_to_pmu(vcpu)->version) {
>  		atomic_switch_perf_msrs(vmx);
> +		kvm_x86_ops.pmu_ops->availability_check(vcpu);
> +	}

AFAICT you just did a call out to the kvm_pmu crud in
atomic_switch_perf_msrs(), why do another call?


