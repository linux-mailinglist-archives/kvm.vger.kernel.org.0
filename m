Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D68535514
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 03:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfFEBuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 21:50:40 -0400
Received: from mga04.intel.com ([192.55.52.120]:17889 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfFEBuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 21:50:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 18:50:39 -0700
X-ExtLoop1: 1
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 04 Jun 2019 18:50:37 -0700
Date:   Wed, 5 Jun 2019 09:49:45 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yu-cheng.yu@intel.com
Subject: Re: [PATCH v5 5/8] KVM: VMX: Load Guest CET via VMCS when CET is
 enabled in Guest
Message-ID: <20190605014944.GA28360@local-michael-cet-test>
References: <20190522070101.7636-1-weijiang.yang@intel.com>
 <20190522070101.7636-6-weijiang.yang@intel.com>
 <20190604200336.GC7476@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604200336.GC7476@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 04, 2019 at 01:03:36PM -0700, Sean Christopherson wrote:
> On Wed, May 22, 2019 at 03:00:58PM +0800, Yang Weijiang wrote:
> > "Load Guest CET state" bit controls whether Guest CET states
> > will be loaded at Guest entry. Before doing that, KVM needs
> > to check if CPU CET feature is available to Guest.
> > 
> > Note: SHSTK and IBT features share one control MSR:
> > MSR_IA32_{U,S}_CET, which means it's difficult to hide
> > one feature from another in the case of SHSTK != IBT,
> > after discussed in community, it's agreed to allow Guest
> > control two features independently as it won't introduce
> > security hole.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 9321da538f65..1c0d487a4037 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -47,6 +47,7 @@
> >  #include <asm/spec-ctrl.h>
> >  #include <asm/virtext.h>
> >  #include <asm/vmx.h>
> > +#include <asm/cet.h>
> 
> Is this include actually needed?  I haven't attempted to compile, but a
> glance everything should be in cpufeatures.h or vmx.h.
> 
  Thanks Sean!
  My original purpose is to re-use the macro cpu_x86_cet_enabled() to
  check host CET status, for somehow, the check is not there, but to resolve
  your below question, I need to use the macro to check it, so will keep
  this include and add the check in next version.

> >  #include "capabilities.h"
> >  #include "cpuid.h"
> > @@ -2929,6 +2930,17 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >  		if (!nested_vmx_allowed(vcpu) || is_smm(vcpu))
> >  			return 1;
> >  	}
> > +	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT)) {
> > +		if (cr4 & X86_CR4_CET)
> > +			vmcs_set_bits(VM_ENTRY_CONTROLS,
> > +				      VM_ENTRY_LOAD_GUEST_CET_STATE);
> > +		else
> > +			vmcs_clear_bits(VM_ENTRY_CONTROLS,
> > +					VM_ENTRY_LOAD_GUEST_CET_STATE);
> > +	} else if (cr4 & X86_CR4_CET) {
> > +		return 1;
> > +	}
> 
> Don't we also need to check for host CET support prior to toggling
> VM_ENTRY_LOAD_GUEST_CET_STATE?

Yes, need add back the check. v3 patch changed the CET CPUID enumeration to
guest, and lost the check from then on.
> 
> >  
> >  	if (to_vmx(vcpu)->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
> >  		return 1;
> > -- 
> > 2.17.2
> > 
