Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81B33308EF
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 08:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhCHHsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 02:48:50 -0500
Received: from mga18.intel.com ([134.134.136.126]:17192 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231195AbhCHHsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 02:48:33 -0500
IronPort-SDR: /UE+lyvPJsNUhuc03PMTE/g2QPXHqKAfEf8Bi4nB4ilNyd3cXJ3XSAZ8eqmB3jMmVrlK4EEIgG
 S6wNZABj0ZNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="175598054"
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="175598054"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2021 23:48:33 -0800
IronPort-SDR: +ebTyNZM3wupNkoQprJ1QH7EdxENAsN7Ba4Ijt9e69Y6Y0L2LWYogutPOPv981RQhJmBT/p568
 CgFi/1l5EI/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,231,1610438400"; 
   d="scan'208";a="369341148"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.166])
  by orsmga003.jf.intel.com with ESMTP; 07 Mar 2021 23:48:31 -0800
Date:   Mon, 8 Mar 2021 16:01:09 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <20210308080108.GA1160@local-michael-cet-test.sh.intel.com>
References: <20210304060740.11339-1-weijiang.yang@intel.com>
 <20210304060740.11339-2-weijiang.yang@intel.com>
 <YEEO9bcLnc0gyLyP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEEO9bcLnc0gyLyP@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 04, 2021 at 08:46:45AM -0800, Sean Christopherson wrote:
> On Thu, Mar 04, 2021, Yang Weijiang wrote:
> > @@ -3375,6 +3391,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> >  	if (kvm_mpx_supported() &&
> >  		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
> >  		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> > +	if (kvm_cet_supported() &&
> > +		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> 
> Alignment.
> 
> > +		vmx->nested.vmcs01_guest_ssp = vmcs_readl(GUEST_SSP);
> > +		vmx->nested.vmcs01_guest_s_cet = vmcs_readl(GUEST_S_CET);
> > +		vmx->nested.vmcs01_guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> > +	}
> >  
> >  	/*
> >  	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
> > @@ -4001,6 +4023,9 @@ static bool is_vmcs12_ext_field(unsigned long field)
> >  	case GUEST_IDTR_BASE:
> >  	case GUEST_PENDING_DBG_EXCEPTIONS:
> >  	case GUEST_BNDCFGS:
> > +	case GUEST_SSP:
> > +	case GUEST_INTR_SSP_TABLE:
> > +	case GUEST_S_CET:
> >  		return true;
> >  	default:
> >  		break;
> > @@ -4052,6 +4077,11 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
> >  		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
> >  	if (kvm_mpx_supported())
> >  		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> > +	if (kvm_cet_supported()) {
> 
> Isn't the existing kvm_mpx_supported() check wrong in the sense that KVM only
> needs to sync to vmcs12 if KVM and the guest both support MPX?  

For MPX, if guest_cpuid_has() is not efficent, can it be checked by BNDCFGS EN bit?
E.g.:

if (kvm_mpx_supported() && (vmcs12->guest_bndcfgs & 1))

> Same would apply to CET. Not sure it'd be a net positive in terms of performance since
> guest_cpuid_has() can be quite slow, but overwriting vmcs12 fields that technically don't exist
> feels wrong.

For CET, can we get equivalent effect by checking vmcs12->guest_cr4.CET?
E.g.:
if (kvm_cet_supported() && (vmcs12->guest_cr4 & X86_CR4_CET))

> 
> > +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
> > +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
> > +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> > +	}
> >  
> >  	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
> >  }
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 9d3a557949ac..36dc4fdb0909 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -155,6 +155,9 @@ struct nested_vmx {
> >  	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
> >  	u64 vmcs01_debugctl;
> >  	u64 vmcs01_guest_bndcfgs;
> > +	u64 vmcs01_guest_ssp;
> > +	u64 vmcs01_guest_s_cet;
> > +	u64 vmcs01_guest_ssp_tbl;
> >  
> >  	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
> >  	int l1_tpr_threshold;
> > -- 
> > 2.26.2
> > 
