Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E248AEDB
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 07:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfHMFhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 01:37:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:14276 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbfHMFhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 01:37:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 22:36:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,380,1559545200"; 
   d="scan'208";a="327576483"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 12 Aug 2019 22:36:34 -0700
Date:   Tue, 13 Aug 2019 13:38:18 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, mst@redhat.com,
        rkrcmar@redhat.com, jmattson@google.com
Subject: Re: [PATCH v6 5/8] KVM: VMX: Load Guest CET via VMCS when CET is
 enabled in Guest
Message-ID: <20190813053818.GA2432@local-michael-cet-test>
References: <20190725031246.8296-1-weijiang.yang@intel.com>
 <20190725031246.8296-6-weijiang.yang@intel.com>
 <20190812235632.GH4996@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812235632.GH4996@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 12, 2019 at 04:56:32PM -0700, Sean Christopherson wrote:
> On Thu, Jul 25, 2019 at 11:12:43AM +0800, Yang Weijiang wrote:
> > "Load Guest CET state" bit controls whether Guest CET states
> > will be loaded at Guest entry. Before doing that, KVM needs
> > to check if CPU CET feature is enabled on host and available
> > to Guest.
> > 
> > Note: SHSTK and IBT features share one control MSR:
> > MSR_IA32_{U,S}_CET, which means it's difficult to hide
> > one feature from another in the case of SHSTK != IBT,
> > after discussed in community, it's agreed to allow Guest
> > control two features independently as it won't introduce
> > security hole.
> > 
> > Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index ce5d1e45b7a5..fbf9c335cf7b 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -44,6 +44,7 @@
> >  #include <asm/spec-ctrl.h>
> >  #include <asm/virtext.h>
> >  #include <asm/vmx.h>
> > +#include <asm/cet.h>
> >  
> >  #include "capabilities.h"
> >  #include "cpuid.h"
> > @@ -2923,6 +2924,18 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >  		if (!nested_vmx_allowed(vcpu) || is_smm(vcpu))
> >  			return 1;
> >  	}
> > +	if (cpu_x86_cet_enabled() &&
> 
> It'd probably be better to check a KVM function here, e.g. a wrapper of
> kvm_supported_xss().  I don't think it will ever matter, but it'd be nice
> to have a single kill switch given the variety of different enable bits
> for CET.
>
OK, will try to make it nicer in next version.

> > +	    (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))) {
> > +		if (cr4 & X86_CR4_CET)
> > +			vmcs_set_bits(VM_ENTRY_CONTROLS,
> > +				      VM_ENTRY_LOAD_GUEST_CET_STATE);
> > +		else
> > +			vmcs_clear_bits(VM_ENTRY_CONTROLS,
> > +					VM_ENTRY_LOAD_GUEST_CET_STATE);
> > +	} else if (cr4 & X86_CR4_CET) {
> > +		return 1;
> > +	}
> >  
> >  	if (to_vmx(vcpu)->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
> >  		return 1;
> > -- 
> > 2.17.2
> > 
