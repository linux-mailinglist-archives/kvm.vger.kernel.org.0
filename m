Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA78E8AB27
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 01:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfHLXaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 19:30:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:20527 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfHLXaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 19:30:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 16:29:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,379,1559545200"; 
   d="scan'208";a="170220211"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 12 Aug 2019 16:29:22 -0700
Date:   Mon, 12 Aug 2019 16:29:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH v6 7/8] KVM: x86: Load Guest fpu state when accessing
 MSRs managed by XSAVES
Message-ID: <20190812232921.GE4996@linux.intel.com>
References: <20190725031246.8296-1-weijiang.yang@intel.com>
 <20190725031246.8296-8-weijiang.yang@intel.com>
 <20190812230203.GC4996@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812230203.GC4996@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 12, 2019 at 04:02:03PM -0700, Sean Christopherson wrote:
> On Thu, Jul 25, 2019 at 11:12:45AM +0800, Yang Weijiang wrote:
> > From: Sean Christopherson <sean.j.christopherson@intel.com>
> > 
> > A handful of CET MSRs are not context switched through "traditional"
> > methods, e.g. VMCS or manual switching, but rather are passed through
> > to the guest and are saved and restored by XSAVES/XRSTORS, i.e. the
> > guest's FPU state.
> > 
> > Load the guest's FPU state if userspace is accessing MSRs whose values
> > are managed by XSAVES so that the MSR helper, e.g. vmx_{get,set}_msr(),
> > can simply do {RD,WR}MSR to access the guest's value.
> > 
> > Note that guest_cpuid_has() is not queried as host userspace is allowed
> > to access MSRs that have not been exposed to the guest, e.g. it might do
> > KVM_SET_MSRS prior to KVM_SET_CPUID2.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/x86.c | 29 ++++++++++++++++++++++++++++-
> >  1 file changed, 28 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index fafd81d2c9ea..c657e6a56527 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -102,6 +102,8 @@ static void enter_smm(struct kvm_vcpu *vcpu);
> >  static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
> >  static void store_regs(struct kvm_vcpu *vcpu);
> >  static int sync_regs(struct kvm_vcpu *vcpu);
> > +static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
> > +static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
> >  
> >  struct kvm_x86_ops *kvm_x86_ops __read_mostly;
> >  EXPORT_SYMBOL_GPL(kvm_x86_ops);
> > @@ -2959,6 +2961,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_get_msr_common);
> >  
> > +static bool is_xsaves_msr(u32 index)
> > +{
> > +	return index == MSR_IA32_U_CET ||
> > +	       (index >= MSR_IA32_PL0_SSP && index <= MSR_IA32_PL3_SSP);
> > +}
> > +
> >  /*
> >   * Read or write a bunch of msrs. All parameters are kernel addresses.
> >   *
> > @@ -2969,11 +2977,30 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
> >  		    int (*do_msr)(struct kvm_vcpu *vcpu,
> >  				  unsigned index, u64 *data))
> >  {
> > +	bool fpu_loaded = false;
> >  	int i;
> > +	u64 cet_bits = XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL;
> 
> Dunno if the compiler will actually generate different code, but this can be a
> const.
> 
> > +	u64 host_xss = 0;
> > +
> > +	for (i = 0; i < msrs->nmsrs; ++i) {
> > +		if (!fpu_loaded && is_xsaves_msr(entries[i].index)) {
> > +			if (!kvm_x86_ops->xsaves_supported() ||
> > +			    !kvm_x86_ops->supported_xss())
> 
> The "!kvm_x86_ops->supported_xss()" is redundant with the host_xss check
> below.
> 
> > +				continue;
> 
> Hmm, vmx_set_msr() should be checking host_xss, arguably we should call
> do_msr() and let it handle the bad MSR access.  I don't have a strong
> opinion either way, practically speaking the end result will be the same.
> 
> If we do want to handle a misbehaving userspace here, this should be
> 'break' instead of 'continue'.
> 
> > +
> > +			host_xss = kvm_x86_ops->supported_xss();
> >  
> > -	for (i = 0; i < msrs->nmsrs; ++i)
> > +			if ((host_xss & cet_bits) != cet_bits)
> 
> I'm pretty sure this should check for either CET bit being set, not both,
> e.g. I assume it's possible to enable and expose XFEATURE_MASK_CET_USER
> but not XFEATURE_MASK_CET_KERNEL.
> 
> So something like
> 
> 	const u64 cet_bits = XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL;
> 	const bool cet_supported = kvm_x86_ops->xsaves_supported() &&
> 				   (kvm_x86_ops->supported_xss() & cet_bits);
> 
> 	for (i = 0; i < msrs->nmsrs; ++i) {
> 		if (!fpu_loaded && cet_supported &&
> 		    is_xsaves_msr(entries[i].index)) {
> 			kvm_load_guest_fpu(vcpu);
> 			fpu_loaded = true;
> 		}
> 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
> 			break;	
> 	}

After looking at patch 8/8, and assuming KVM can actually virtualize
USER and KERNEL independently, we should go with this version that defers
to do_msr(), otherwise this code would also need to differentiate between
USER and KERNEL MSRs.  In other words, have __msr_io() load the guest fpu
if CET is support and any CET MSRs is being accessed, and let vmx_set_msr()
do the fine grained fault/error handling.

> or
> 
> 	const u64 cet_bits = XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL;
> 
> 	for (i = 0; i < msrs->nmsrs; ++i) {
> 		if (!fpu_loaded && is_xsaves_msr(entries[i].index)) {
> 			if (!kvm_x86_ops->supported_xss() ||
> 			    !(kvm_x86_ops->supported_xss() & cet_bits))
> 				break;
> 			kvm_load_guest_fpu(vcpu);
> 			fpu_loaded = true;
> 		}
> 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
> 			break;	
> 	}
> 
> 
> > +				continue;
> > +
> > +			kvm_load_guest_fpu(vcpu);
> > +			fpu_loaded = true;
> > +		}
> >  		if (do_msr(vcpu, entries[i].index, &entries[i].data))
> >  			break;
> > +	}
> > +	if (fpu_loaded)
> > +		kvm_put_guest_fpu(vcpu);
> >  
> >  	return i;
> >  }
> > -- 
> > 2.17.2
> > 
