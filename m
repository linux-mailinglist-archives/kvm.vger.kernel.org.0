Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E821124C57
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 17:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfLRQCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 11:02:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:30328 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbfLRQCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 11:02:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 08:02:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="217895963"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 18 Dec 2019 08:02:28 -0800
Date:   Wed, 18 Dec 2019 08:02:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com, yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 3/7] KVM: VMX: Pass through CET related MSRs
Message-ID: <20191218160228.GB25201@linux.intel.com>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-4-weijiang.yang@intel.com>
 <20191210211821.GL15758@linux.intel.com>
 <20191216021816.GA10764@local-michael-cet-test>
 <20191218003455.GP11771@linux.intel.com>
 <20191218135513.GB7926@local-michael-cet-test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218135513.GB7926@local-michael-cet-test>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 18, 2019 at 09:55:13PM +0800, Yang Weijiang wrote:
> On Tue, Dec 17, 2019 at 04:34:55PM -0800, Sean Christopherson wrote:
> > On Mon, Dec 16, 2019 at 10:18:16AM +0800, Yang Weijiang wrote:
> > > On Tue, Dec 10, 2019 at 01:18:21PM -0800, Sean Christopherson wrote:
> > > > On Fri, Nov 01, 2019 at 04:52:18PM +0800, Yang Weijiang wrote:
> > > > > CET MSRs pass through Guest directly to enhance performance.
> > > > > CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
> > > > > Shadow Stack Pointer(SSP) are stored in MSR_IA32_PL{0,1,2,3}_SSP,
> > > > > SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
> > > > > these MSRs are defined in kernel and re-used here.
> > > > > 
> > >  > +
> > > > >  static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> > > > >  {
> > > > >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > > > > @@ -7025,6 +7087,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> > > > >  	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> > > > >  			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
> > > > >  		update_intel_pt_cfg(vcpu);
> > > > > +
> > > > > +	if (!is_guest_mode(vcpu))
> > > > > +		vmx_pass_cet_msrs(vcpu);
> > > > 
> > > > Hmm, this looks insufficent, e.g. deliberately toggling CET from on->off
> > > > while in guest mode would put KVM in a weird state as the msr bitmap for
> > > > L1 would still allow L1 to access the CET MSRs.
> > > >
> > > Hi, Sean,
> > > I don't get you, there's guest mode check before access CET msrs, it'll
> > > fail if it's in guest mode.
> > 
> > KVM can exit to userspae while L2 is active.  If userspace then did a
> > KVM_SET_CPUID2, e.g. instead of KVM_RUN, vmx_cpuid_update() would skip
> > vmx_pass_cet_msrs() and KVM would never update L1's MSR bitmaps.
> >
> Thanks, it makes sense to me. Given current implementation, how about
> removing above check and adding it in CET CPUID
> enumeration for L2 so that no CET msrs passed through to L2 when
> is_guest_mode() is true?

But you still need to update L1's MSR bitmaps.  That can obviously be done
all at once, but it's annoying and IMO unnecessarily complex.

> > > > Allowing KVM_SET_CPUID{2} while running a nested guest seems bogus, can we
> > > > kill that path entirely with -EINVAL?
> > > >
> > > Do you mean don't expose CET cpuids to L2 guest?
> > 
> > I mean completely disallow KVM_SET_CPUID and KVM_SET_CPUID2 if
> > is_guest_mode() is true.  My question is mostly directed at Paolo and
> > anyone else that has an opinion on whether we can massage the ABI to
> > retroactively change KVM_SET_CPUID{2} behavior.
>
> This sounds like something deserving an individual patch after get
> agreement in community. I'll put it aside right now.

Normally I would agree, but I think in this case it would significantly
reduce the complexity and implementation cost of CET support.  I'll send a
patch to kickstart the conversation, it's a tiny change in terms of code.
