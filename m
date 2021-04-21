Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97D336675E
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 10:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbhDUI4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 04:56:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:56256 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234632AbhDUI4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 04:56:38 -0400
IronPort-SDR: asUTHq2RgW9bZ5UZc7OyasdvReTSX0gbQusNQ3dYRoSlORF9rqMthnEx/kWcKIOzWUjDSimXuK
 PmIlKyvBFscQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="175150522"
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="175150522"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2021 01:56:02 -0700
IronPort-SDR: X3MLDVnPNARxbqg8K95yuBIQnr/6gJbvj/iMY567p/+ljcC+gTrtUUb3O2H5+hI/E8QW8B/p5V
 cryKlB0L8QBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,238,1613462400"; 
   d="scan'208";a="427440568"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.166])
  by orsmga008.jf.intel.com with ESMTP; 21 Apr 2021 01:55:59 -0700
Date:   Wed, 21 Apr 2021 17:08:03 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/3] KVM: nVMX: Sync L2 guest CET states between L1/L2
Message-ID: <20210421090803.GA10596@local-michael-cet-test.sh.intel.com>
References: <20210409064345.31497-1-weijiang.yang@intel.com>
 <20210409064345.31497-2-weijiang.yang@intel.com>
 <YH8QxRhX4iJFS6+D@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH8QxRhX4iJFS6+D@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021 at 05:35:01PM +0000, Sean Christopherson wrote:
> On Fri, Apr 09, 2021, Yang Weijiang wrote:
> > These fields are rarely updated by L1 QEMU/KVM, sync them when L1 is trying to
> > read/write them and after they're changed. If CET guest entry-load bit is not
> > set by L1 guest, migrate them to L2 manaully.
> > 
> > Opportunistically remove one blank line in previous patch.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c      |  1 -
> >  arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.h    |  3 +++
> >  3 files changed, 33 insertions(+), 1 deletion(-)
> > 
> >  	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
> >  
> >  	/* EXCEPTION_BITMAP and CR0_GUEST_HOST_MASK should basically be the
> > @@ -3375,6 +3391,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
> >  	if (kvm_mpx_supported() &&
> >  		!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
> >  		vmx->nested.vmcs01_guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
> > +	if (kvm_cet_supported() && !vmx->nested.nested_run_pending) {
> 
> This needs to be:
> 
> 	if (kvm_cet_supported() && (!vmx->nested.nested_run_pending ||
> 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE)))
> 
> otherwise the vmcs01_* members will be stale when emulating VM-Enter with
> vcmc12.vm_entry_controls.LOAD_CET_STATE=0.
> 
Thanks Sean! Change is included in v6 patch series.

> > +		vmx->nested.vmcs01_guest_ssp = vmcs_readl(GUEST_SSP);
> > +		vmx->nested.vmcs01_guest_s_cet = vmcs_readl(GUEST_S_CET);
> > +		vmx->nested.vmcs01_guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
> > +	}
