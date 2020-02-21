Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B97E1681DF
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgBUPgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:36:22 -0500
Received: from mga14.intel.com ([192.55.52.115]:29395 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728976AbgBUPgV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 10:36:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 07:36:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,468,1574150400"; 
   d="scan'208";a="270022489"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 21 Feb 2020 07:36:19 -0800
Date:   Fri, 21 Feb 2020 07:36:19 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/10] KVM: VMX: Use vpid_sync_context() directly when
 possible
Message-ID: <20200221153619.GE12665@linux.intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
 <20200220204356.8837-2-sean.j.christopherson@intel.com>
 <878skwt6yt.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878skwt6yt.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 02:17:46PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Use vpid_sync_context() directly for flows that run if and only if
> > enable_vpid=1, or more specifically, nested VMX flows that are gated by
> > vmx->nested.msrs.secondary_ctls_high.SECONDARY_EXEC_ENABLE_VPID being
> > set, which is allowed if and only if enable_vpid=1.  Because these flows
> > call __vmx_flush_tlb() with @invalidate_gpa=false, the if-statement that
> > decides between INVEPT and INVVPID will always go down the INVVPID path,
> > i.e. call vpid_sync_context() because
> > "enable_ept && (invalidate_gpa || !enable_vpid)" always evaluates false.
> >
> > This helps pave the way toward removing @invalidate_gpa and @vpid from
> > __vmx_flush_tlb() and its callers.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 657c2eda357c..19ac4083667f 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -2466,7 +2466,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
> >  		if (nested_cpu_has_vpid(vmcs12) && nested_has_guest_tlb_tag(vcpu)) {
> >  			if (vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
> >  				vmx->nested.last_vpid = vmcs12->virtual_processor_id;
> > -				__vmx_flush_tlb(vcpu, nested_get_vpid02(vcpu), false);
> > +				vpid_sync_context(nested_get_vpid02(vcpu));
> >  			}
> >  		} else {
> >  			/*
> > @@ -5154,17 +5154,17 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
> >  			__invvpid(VMX_VPID_EXTENT_INDIVIDUAL_ADDR,
> >  				vpid02, operand.gla);
> >  		} else
> > -			__vmx_flush_tlb(vcpu, vpid02, false);
> > +			vpid_sync_context(vpid02);
> 
> This is a pre-existing condition but coding style requires braces even
> for single statements when they were used in another branch.

I'll fix this in v2.

> >  		break;
> >  	case VMX_VPID_EXTENT_SINGLE_CONTEXT:
> >  	case VMX_VPID_EXTENT_SINGLE_NON_GLOBAL:
> >  		if (!operand.vpid)
> >  			return nested_vmx_failValid(vcpu,
> >  				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
> > -		__vmx_flush_tlb(vcpu, vpid02, false);
> > +		vpid_sync_context(vpid02);
> >  		break;
> >  	case VMX_VPID_EXTENT_ALL_CONTEXT:
> > -		__vmx_flush_tlb(vcpu, vpid02, false);
> > +		vpid_sync_context(vpid02);
> >  		break;
> >  	default:
> >  		WARN_ON_ONCE(1);
> 
> Seems to be no change indeed,

Heh, that's about the same level of confidence I had :-)
 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
