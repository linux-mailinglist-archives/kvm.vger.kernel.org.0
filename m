Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F4A1BABC4
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 19:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgD0R4s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 13:56:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:18653 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbgD0R4s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 13:56:48 -0400
IronPort-SDR: 3dXglAy1oN7zYNVmuX34tO7qIovq1LqlmDunV/9d5KkpqZOqrVn2jIGpULvbkzQeJn+W0+gGMU
 mwnKCMi2wKbw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 10:56:48 -0700
IronPort-SDR: VMqz5JP/v6+Xipo7yk79MoKh7DT+hIdwj2pgAYG7iyo+P5HvnpbpRlhEEdEg6YoQGkuTrlnCvh
 VX6WGnLDvddw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="248940043"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 27 Apr 2020 10:56:47 -0700
Date:   Mon, 27 Apr 2020 10:56:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 3/9] KVM: VMX: Set host/guest CET states for
 vmexit/vmentry
Message-ID: <20200427175647.GK14870@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-4-weijiang.yang@intel.com>
 <20200423171741.GH17824@linux.intel.com>
 <20200424143510.GH24039@local-michael-cet-test>
 <20200424144941.GC30013@linux.intel.com>
 <20200425092021.GB26221@local-michael-cet-test>
 <20200427170426.GH14870@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427170426.GH14870@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 27, 2020 at 10:04:26AM -0700, Sean Christopherson wrote:
> On Sat, Apr 25, 2020 at 05:20:21PM +0800, Yang Weijiang wrote:
> > On Fri, Apr 24, 2020 at 07:49:41AM -0700, Sean Christopherson wrote:
> > > On Fri, Apr 24, 2020 at 10:35:10PM +0800, Yang Weijiang wrote:
> > > > On Thu, Apr 23, 2020 at 10:17:41AM -0700, Sean Christopherson wrote:
> > > > > On Thu, Mar 26, 2020 at 04:18:40PM +0800, Yang Weijiang wrote:
> > > > > > @@ -7140,8 +7175,23 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> > > > > >  	}
> > > > > >  
> > > > > >  	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > > > > > -	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> > > > > > +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT)) {
> > > > > >  		vmx_update_intercept_for_cet_msr(vcpu);
> > > > > > +
> > > > > > +		if (cpu_has_cet_guest_load_ctrl() && is_cet_supported(vcpu))
> > > > > > +			vm_entry_controls_setbit(to_vmx(vcpu),
> > > > > > +						 VM_ENTRY_LOAD_GUEST_CET_STATE);
> > > > > > +		else
> > > > > > +			vm_entry_controls_clearbit(to_vmx(vcpu),
> > > > > > +						   VM_ENTRY_LOAD_GUEST_CET_STATE);
> > > > > > +
> > > > > > +		if (cpu_has_cet_host_load_ctrl() && is_cet_supported(vcpu))
> > > > > > +			vm_exit_controls_setbit(to_vmx(vcpu),
> > > > > > +						VM_EXIT_LOAD_HOST_CET_STATE);
> > > > > > +		else
> > > > > > +			vm_exit_controls_clearbit(to_vmx(vcpu),
> > > > > > +						  VM_EXIT_LOAD_HOST_CET_STATE);
> > > > > 
> > > > > As above, I think this can be done in vmx_set_cr4().
> > > > >
> > > > Hmm, it's in vmx_set_cr4() in early versions, OK, will move them back.
> > > 
> > > Did I advise you to move them out of vmx_set_cr4()?  It's entirely possible
> > > I forgot some detail since the last time I reviewed this series.
> > Things are always changing, I'm willing to change any part of the patch
> > before it's landed :-).
> 
> I'm worried that there was a reason for requesting the logic to be moved
> out vmx_set_cr4() that I've since forgotten.  I'll see if I can dredge up
> the old mail.

Aha.  v1-v7 had this in cr4.  In v7, you stated that you would move the
toggling to VM-Enter, and in v8 you did just that[2].  In v9 I questioned
why the bits were being toggled in vmx_vcpu_run() and advised moving the
code to vmx_cpuid_update()[3], obviously forgetting that earlier versions
did the toggling in vmx_set_cr4().

AFAICT, I was only reacting to the immediate patch when I advised moving
the code to vmx_cpuid_update(), i.e. the recommendation to move the code
to vmx_set_cr4() doesn't contradict any previous feedback and thus doesn't
reintroduce a known bug.

[1] https://patchwork.kernel.org/patch/11163639/#22931561
[2] https://patchwork.kernel.org/patch/11222763/
[3] https://patchwork.kernel.org/patch/11310823/
