Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7CB511C1D0
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 02:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfLLBDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 20:03:05 -0500
Received: from mga05.intel.com ([192.55.52.43]:61888 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727403AbfLLBDF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 20:03:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 17:03:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,303,1571727600"; 
   d="scan'208";a="210945278"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by fmsmga008.fm.intel.com with ESMTP; 11 Dec 2019 17:03:03 -0800
Date:   Thu, 12 Dec 2019 09:04:24 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 4/7] KVM: VMX: Load CET states on vmentry/vmexit
Message-ID: <20191212010423.GB17570@local-michael-cet-test.sh.intel.com>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-5-weijiang.yang@intel.com>
 <20191210212305.GM15758@linux.intel.com>
 <20191211015423.GC12845@local-michael-cet-test>
 <20191211163510.GF5044@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211163510.GF5044@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 08:35:10AM -0800, Sean Christopherson wrote:
> On Wed, Dec 11, 2019 at 09:54:23AM +0800, Yang Weijiang wrote:
> > On Tue, Dec 10, 2019 at 01:23:05PM -0800, Sean Christopherson wrote:
> > > On Fri, Nov 01, 2019 at 04:52:19PM +0800, Yang Weijiang wrote:
> > > > @@ -2834,6 +2837,9 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
> > > >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > > >  	unsigned long hw_cr0;
> > > >  
> > > > +	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
> > > > +		cr0 |= X86_CR0_WP;
> > > 
> > > Huh?  What's the interaction between CR4.CET and CR0.WP?  If there really
> > > is some non-standard interaction then it needs to be documented in at least
> > > the changelog and probably with a comment as well.
> > >
> > The processor does not allow CR4.CET to be set if CR0.WP = 0 (similarly, it
> > does not allow CR0.WP to be cleared while CR4.CET = 1).
> 
> Ya, as you surmised below, this needs to be a #GP condition.
>
OK, will do it.

> Have you tested SMM at all?  The interaction between CR0 and CR4 may be
> problematic for em_rsm() and/or rsm_enter_protected_mode().
>
Not yet, what's an easy way to test code in SMM mode?
Thanks!

> > > > +
> > > >  	hw_cr0 = (cr0 & ~KVM_VM_CR0_ALWAYS_OFF);
> > > >  	if (enable_unrestricted_guest)
> > > >  		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
> > > > @@ -2936,6 +2942,22 @@ static bool guest_cet_allowed(struct kvm_vcpu *vcpu, u32 feature, u32 mode)
> > > >  	return false;
> > > >  }
> > > >  
> > > > +bool is_cet_bit_allowed(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +	unsigned long cr0;
> > > > +	bool cet_allowed;
> > > > +
> > > > +	cr0 = kvm_read_cr0(vcpu);
> > > > +	cet_allowed = guest_cet_allowed(vcpu, X86_FEATURE_SHSTK,
> > > > +					XFEATURE_MASK_CET_USER) ||
> > > > +		      guest_cet_allowed(vcpu, X86_FEATURE_IBT,
> > > > +					XFEATURE_MASK_CET_USER);
> > > > +	if ((cr0 & X86_CR0_WP) && cet_allowed)
> > > > +		return true;
> > > 
> > > So, attempting to set CR4.CET if CR0.WP=0 takes a #GP?  But attempting
> > > to clear CR0.WP if CR4.CET=1 is ignored?
> > > 
> > Per above words in spec., inject #GP to guest in either case?
> > 
> > > > +
> > > > +	return false;
> > > > +}
> > > > +
