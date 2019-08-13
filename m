Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F83B8AEBF
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 07:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfHMF0R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 01:26:17 -0400
Received: from mga07.intel.com ([134.134.136.100]:18045 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfHMF0Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 01:26:16 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 22:25:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,380,1559545200"; 
   d="scan'208";a="176105661"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga008.fm.intel.com with ESMTP; 12 Aug 2019 22:25:49 -0700
Date:   Tue, 13 Aug 2019 13:27:33 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, mst@redhat.com,
        rkrcmar@redhat.com, jmattson@google.com
Subject: Re: [PATCH v6 3/8] KVM: x86: Implement CET CPUID enumeration for
 Guest
Message-ID: <20190813052733.GA2037@local-michael-cet-test>
References: <20190725031246.8296-1-weijiang.yang@intel.com>
 <20190725031246.8296-4-weijiang.yang@intel.com>
 <20190813000604.GI4996@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813000604.GI4996@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 12, 2019 at 05:06:04PM -0700, Sean Christopherson wrote:
> On Thu, Jul 25, 2019 at 11:12:41AM +0800, Yang Weijiang wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 652b3876ea5c..ce1d6fe21780 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1637,6 +1637,11 @@ static inline bool vmx_feature_control_msr_valid(struct kvm_vcpu *vcpu,
> >  	return !(val & ~valid_bits);
> >  }
> >  
> > +static inline u64 vmx_supported_xss(void)
> > +{
> > +	return host_xss;
> 
> Do you know if the kernel will ever enable CET_USER but not CET_KERNEL,
> and vice versa?  I tried hunting down the logic in the main CET enabling
> series but couldn't find the relevant code.
> 
> If the kernel does enable USER vs. KERNEL independently, are we sure that
> KVM can correctly virtualize that state and that the guest OS won't die
> due to expecting all CET features or no CET features?
> 
> In other words, do we want to return host_xss as is, or do we want to
> make CET_USER and CET_KERNEL a bundle deal and avoid the headache, e.g.:
> 
> 	if (!(host_xss & XFEATURE_MASK_CET_USER) ||
> 	    !(host_xss & XFEATURE_MASK_CET_KERNEL))
> 		return host_xss & ~(XFEATURE_MASK_CET_USER |
> 				    XFEATURE_MASK_CET_KERNEL);
> 	return host_xss; 
>
Hi, Sean,
Thanks for review! CET_USER and CET_KERNEL are two independent parts of
CET, but CET_KERNEL part has not been fully implemented yet, the final target
is to enable CET_USER + CET_KERNEL in kernel. In the VMM patch, it's supposed
to enable both CET_USER and CET_KERNEL mode at one time, so the patches expose
all the features of CET to guest OS as long as platform and host kernel
support so.

> > +}
> > +
> >  static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
> >  {
> >  	switch (msr->index) {
> > @@ -7724,6 +7729,7 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
> >  	.get_vmcs12_pages = NULL,
> >  	.nested_enable_evmcs = NULL,
> >  	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
> > +	.supported_xss = vmx_supported_xss,
> >  };
> >  
> >  static void vmx_cleanup_l1d_flush(void)
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index a470ff0868c5..6a1870044752 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -288,6 +288,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, unsigned long cr2,
> >  				| XFEATURE_MASK_YMM | XFEATURE_MASK_BNDREGS \
> >  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
> >  				| XFEATURE_MASK_PKRU)
> > +
> > +#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER \
> > +				| XFEATURE_MASK_CET_KERNEL)
> > +
> >  extern u64 host_xcr0;
> >  
> >  extern u64 kvm_supported_xcr0(void);
> > -- 
> > 2.17.2
> > 
