Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B931B788A
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 16:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgDXOtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 10:49:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:32360 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbgDXOtm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 10:49:42 -0400
IronPort-SDR: 2oJk/eMyKU66Z0o5ldPTmRQMQIcNNRf76ZhWv2XpI8WZ7ilmYU2gpJqetyTqC0zGkSNkvmym1N
 R/HNQh6b+WOA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 07:49:41 -0700
IronPort-SDR: 1Tx0dwELXp2ZTzsHwYeOabfLacs7b+OWc86nvOc7BelhRVKGbHKFLjoMKpSWkDcjKat+j2LSaB
 vTkZFAY5LHoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="256388642"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 24 Apr 2020 07:49:41 -0700
Date:   Fri, 24 Apr 2020 07:49:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 3/9] KVM: VMX: Set host/guest CET states for
 vmexit/vmentry
Message-ID: <20200424144941.GC30013@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-4-weijiang.yang@intel.com>
 <20200423171741.GH17824@linux.intel.com>
 <20200424143510.GH24039@local-michael-cet-test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424143510.GH24039@local-michael-cet-test>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 10:35:10PM +0800, Yang Weijiang wrote:
> On Thu, Apr 23, 2020 at 10:17:41AM -0700, Sean Christopherson wrote:
> > On Thu, Mar 26, 2020 at 04:18:40PM +0800, Yang Weijiang wrote:
> > > @@ -7140,8 +7175,23 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> > >  	}
> > >  
> > >  	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > > -	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> > > +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT)) {
> > >  		vmx_update_intercept_for_cet_msr(vcpu);
> > > +
> > > +		if (cpu_has_cet_guest_load_ctrl() && is_cet_supported(vcpu))
> > > +			vm_entry_controls_setbit(to_vmx(vcpu),
> > > +						 VM_ENTRY_LOAD_GUEST_CET_STATE);
> > > +		else
> > > +			vm_entry_controls_clearbit(to_vmx(vcpu),
> > > +						   VM_ENTRY_LOAD_GUEST_CET_STATE);
> > > +
> > > +		if (cpu_has_cet_host_load_ctrl() && is_cet_supported(vcpu))
> > > +			vm_exit_controls_setbit(to_vmx(vcpu),
> > > +						VM_EXIT_LOAD_HOST_CET_STATE);
> > > +		else
> > > +			vm_exit_controls_clearbit(to_vmx(vcpu),
> > > +						  VM_EXIT_LOAD_HOST_CET_STATE);
> > 
> > As above, I think this can be done in vmx_set_cr4().
> >
> Hmm, it's in vmx_set_cr4() in early versions, OK, will move them back.

Did I advise you to move them out of vmx_set_cr4()?  It's entirely possible
I forgot some detail since the last time I reviewed this series.
