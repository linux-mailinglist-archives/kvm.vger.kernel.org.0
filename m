Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F83533AB83
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 07:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhCOGOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 02:14:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:62126 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhCOGOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 02:14:35 -0400
IronPort-SDR: ciO835APx1i3nfQ7Y5pbUrAPC0NfIuIZj7ABVh46pC7IWfOMQicn6NL9zTp0FTbr5tFXmBDgut
 +XOFXlKvUF+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="208938057"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="208938057"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2021 23:14:34 -0700
IronPort-SDR: 2IsMkTcOw1sn9UK3hGIzTm40Q1utLFn5qQzeYsBi9PtOgBIDbS7NcfeURG+P6fbvkGGVzCYcBV
 rS0vME5SKzeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="378401328"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.166])
  by fmsmga007.fm.intel.com with ESMTP; 14 Mar 2021 23:14:32 -0700
Date:   Mon, 15 Mar 2021 14:26:57 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <20210315062656.GA6688@local-michael-cet-test.sh.intel.com>
References: <20210304060740.11339-1-weijiang.yang@intel.com>
 <20210304060740.11339-2-weijiang.yang@intel.com>
 <YEEO9bcLnc0gyLyP@google.com>
 <20210308080108.GA1160@local-michael-cet-test.sh.intel.com>
 <YEv5IFrh/HBUsMR/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEv5IFrh/HBUsMR/@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 03:28:32PM -0800, Sean Christopherson wrote:
> On Mon, Mar 08, 2021, Yang Weijiang wrote:
> > On Thu, Mar 04, 2021 at 08:46:45AM -0800, Sean Christopherson wrote:
> > > On Thu, Mar 04, 2021, Yang Weijiang wrote:
> > > > @@ -3375,6 +3391,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> > > >  	if (kvm_mpx_supported() &&
> > > >  		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
> > > >  		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> > > > +	if (kvm_cet_supported() &&
> > > > +		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)) {
> > > 
> > > Alignment.
> > > 
> > > > +		vmx->nested.vmcs01_guest_ssp = vmcs_readl(GUEST_SSP);
> > > > +		vmx->nested.vmcs01_guest_s_cet = vmcs_readl(GUEST_S_CET);
> > > > +		vmx->nested.vmcs01_guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> > > > +	}
> > > >  
> > > >  	/*
> > > >  	 * Overwrite vmcs01.GUEST_CR3 with L1's CR3 if EPT is disabled *and*
> > > > @@ -4001,6 +4023,9 @@ static bool is_vmcs12_ext_field(unsigned long field)
> > > >  	case GUEST_IDTR_BASE:
> > > >  	case GUEST_PENDING_DBG_EXCEPTIONS:
> > > >  	case GUEST_BNDCFGS:
> > > > +	case GUEST_SSP:
> > > > +	case GUEST_INTR_SSP_TABLE:
> > > > +	case GUEST_S_CET:
> > > >  		return true;
> > > >  	default:
> > > >  		break;
> > > > @@ -4052,6 +4077,11 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
> > > >  		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
> > > >  	if (kvm_mpx_supported())
> > > >  		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> > > > +	if (kvm_cet_supported()) {
> > > 
> > > Isn't the existing kvm_mpx_supported() check wrong in the sense that KVM only
> > > needs to sync to vmcs12 if KVM and the guest both support MPX?  
> > 
> > For MPX, if guest_cpuid_has() is not efficent, can it be checked by BNDCFGS EN bit?
> > E.g.:
> > 
> > if (kvm_mpx_supported() && (vmcs12->guest_bndcfgs & 1))
> > 
> > > Same would apply to CET. Not sure it'd be a net positive in terms of performance since
> > > guest_cpuid_has() can be quite slow, but overwriting vmcs12 fields that technically don't exist
> > > feels wrong.
> > 
> > For CET, can we get equivalent effect by checking vmcs12->guest_cr4.CET?
> > E.g.:
> > if (kvm_cet_supported() && (vmcs12->guest_cr4 & X86_CR4_CET))
> 
> No, because the existence of the fields does not depend on them being enabled.
> E.g. things will go sideways if the values change while L2 is running, L2
> disables CET, and then an exit occurs.
> 
> This is already a slow path, maybe the guest_cpuid_has() checks are a non-issue.

Agree, then will add the check to both MPX and CET. Thanks!

>
> 
> > 
> > > 
> > > > +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
> > > > +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
> > > > +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> > > > +	}
> > > >  
> > > >  	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
> > > >  }
> > > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > > index 9d3a557949ac..36dc4fdb0909 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.h
> > > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > > @@ -155,6 +155,9 @@ struct nested_vmx {
> > > >  	/* to migrate it to L2 if VM_ENTRY_LOAD_DEBUG_CONTROLS is off */
> > > >  	u64 vmcs01_debugctl;
> > > >  	u64 vmcs01_guest_bndcfgs;
> > > > +	u64 vmcs01_guest_ssp;
> > > > +	u64 vmcs01_guest_s_cet;
> > > > +	u64 vmcs01_guest_ssp_tbl;
> > > >  
> > > >  	/* to migrate it to L1 if L2 writes to L1's CR8 directly */
> > > >  	int l1_tpr_threshold;
> > > > -- 
> > > > 2.26.2
> > > > 
