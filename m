Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 014E9187946
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 06:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgCQFd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 01:33:29 -0400
Received: from mga18.intel.com ([134.134.136.126]:36674 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgCQFd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 01:33:29 -0400
IronPort-SDR: hzCWmpJGBuv79Yn8utzAU+uCd2NISYc7BmL48HKzWeBjMZDwFBfXASxvPknYyQKOWezjowqmdf
 Xp6N050BZ7Pw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 22:33:28 -0700
IronPort-SDR: ID65nFnfKpZivIijbXTcmaGV8dqg+OdEMnbV5uMOhlFfpPLRu48+JgT1CsHwcRJpzXZOLLSI0t
 pUmzw7CSsl9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="279284202"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 16 Mar 2020 22:33:27 -0700
Date:   Mon, 16 Mar 2020 22:33:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 01/10] KVM: nVMX: Move reflection check into
 nested_vmx_reflect_vmexit()
Message-ID: <20200317053327.GR24267@linux.intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
 <20200312184521.24579-2-sean.j.christopherson@intel.com>
 <87k13opi6m.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k13opi6m.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 13, 2020 at 01:12:33PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Move the call to nested_vmx_exit_reflected() from vmx_handle_exit() into
> > nested_vmx_reflect_vmexit() and change the semantics of the return value
> > for nested_vmx_reflect_vmexit() to indicate whether or not the exit was
> > reflected into L1.  nested_vmx_exit_reflected() and
> > nested_vmx_reflect_vmexit() are intrinsically tied together, calling one
> > without simultaneously calling the other makes little sense.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.h | 16 +++++++++++-----
> >  arch/x86/kvm/vmx/vmx.c    |  4 ++--
> >  2 files changed, 13 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
> > index 21d36652f213..6bc379cf4755 100644
> > --- a/arch/x86/kvm/vmx/nested.h
> > +++ b/arch/x86/kvm/vmx/nested.h
> > @@ -72,12 +72,16 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
> >  }
> >  
> >  /*
> > - * Reflect a VM Exit into L1.
> > + * Conditionally reflect a VM-Exit into L1.  Returns %true if the VM-Exit was
> > + * reflected into L1.
> >   */
> > -static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
> > -					    u32 exit_reason)
> > +static inline bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
> > +					     u32 exit_reason)
> >  {
> > -	u32 exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
> > +	u32 exit_intr_info;
> > +
> > +	if (!nested_vmx_exit_reflected(vcpu, exit_reason))
> > +		return false;
> 
> (unrelated to your patch)
> 
> It's probably just me but 'nested_vmx_exit_reflected()' name always
> makes me thinkg 'the vmexit WAS [already] reflected' and not 'the vmexit
> NEEDS to be reflected'. 'nested_vmx_exit_needs_reflecting()' maybe?

Not just you.  It'd be nice if the name some how reflected (ha) that the
logic is mostly based on whether or not L1 expects the exit, with a few
exceptions.  E.g. something like

	if (!l1_expects_vmexit(...) && !is_system_vmexit(...))
		return false;

The downside of that is the logic is split, which is probably a net loss?
