Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEC21B77F5
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 16:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgDXOFy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 10:05:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:32011 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgDXOFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 10:05:54 -0400
IronPort-SDR: qL1izba6z5ZhxCOgJp/XB1tPtG2pk9SDAgdvmBi25OK7Nn//Dwg/ZLw58kClErbARcvT6nADmM
 bI5Tt/1erMHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 07:05:52 -0700
IronPort-SDR: 4UElGFTvdSIDCKBdl8gBliJHKUIGJSN6Kys9Yjm3CqmNII/Bb4WohMbL/jtyQ0V3yh8rxWkRsV
 B4PYdjCLbcgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="457353752"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga005.fm.intel.com with ESMTP; 24 Apr 2020 07:05:49 -0700
Date:   Fri, 24 Apr 2020 22:07:51 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 2/9] KVM: VMX: Set guest CET MSRs per KVM and host
 configuration
Message-ID: <20200424140751.GE24039@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-3-weijiang.yang@intel.com>
 <20200423162749.GG17824@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423162749.GG17824@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 09:27:49AM -0700, Sean Christopherson wrote:
> On Thu, Mar 26, 2020 at 04:18:39PM +0800, Yang Weijiang wrote:
> > @@ -3033,6 +3033,13 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
> >  		vmcs_writel(GUEST_CR3, guest_cr3);
> >  }
> >  
> > +static bool is_cet_mode_allowed(struct kvm_vcpu *vcpu, u32 mode_mask)
> 
> CET itself isn't a mode.  And since this ends up being an inner helper for
> is_cet_supported(), I think __is_cet_supported() would be the way to go.
> 
> Even @mode_mask is a bit confusing without the context of it being kernel
> vs. user.  The callers are very readable, e.g. I'd much prefer passing the
> mask as opposed to doing 'bool kernel'.  Maybe s/mode_mask/cet_mask?  That
> doesn't exactly make things super clear, but at least the reader knows the
> mask is for CET features.
Make sense, will change it.

> 
> > +{
> > +	return ((supported_xss & mode_mask) &&
> > +		(guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > +		guest_cpuid_has(vcpu, X86_FEATURE_IBT)));
> > +}
> > +
> >  int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -7064,6 +7071,35 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
> >  		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
> >  }
> >  
> > +static void vmx_update_intercept_for_cet_msr(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> > +	bool flag;
> 
> Maybe s/flag/incpt or something to make it more obvious that the bool is
> true if we want to intercept?  vmx_set_intercept_for_msr()s's @value isn't
> any better :-/.
I prefer using incpt now ;-) 
> > +
> > +	flag = !is_cet_mode_allowed(vcpu, XFEATURE_MASK_CET_USER);
> > +	/*
> > +	 * U_CET is required for USER CET, and U_CET, PL3_SPP are bound as
> > +	 * one component and controlled by IA32_XSS[bit 11].
> > +	 */
> > +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_U_CET, MSR_TYPE_RW, flag);
> > +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL3_SSP, MSR_TYPE_RW, flag);
> > +
> > +	flag = !is_cet_mode_allowed(vcpu, XFEATURE_MASK_CET_KERNEL);
> > +	/*
> > +	 * S_CET is required for KERNEL CET, and PL0_SSP ... PL2_SSP are
> > +	 * bound as one component and controlled by IA32_XSS[bit 12].
> > +	 */
> > +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_S_CET, MSR_TYPE_RW, flag);
> > +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL0_SSP, MSR_TYPE_RW, flag);
> > +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL1_SSP, MSR_TYPE_RW, flag);
> > +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_PL2_SSP, MSR_TYPE_RW, flag);
> > +
> > +	flag |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> > +	/* SSP_TAB is only available for KERNEL SHSTK.*/
> > +	vmx_set_intercept_for_msr(msr_bitmap, MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW, flag);
> > +}
> > +
> >  static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -7102,6 +7138,10 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> >  			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
> >  		}
> >  	}
> > +
> > +	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> > +		vmx_update_intercept_for_cet_msr(vcpu);
> 
> This is wrong, it will miss the case where userspace double configures CPUID
> and goes from CET=1 to CET=0.  This should instead be:
> 
> 	if (supported_xss & (XFEATURE_MASK_CET_KERNEL | XFEATURE_MASK_CET_USER))
> 		vmx_update_intercept_for_cet_msr(vcpu);
> 
> >  }
Here CET=1/0, did you mean the CET bit in XSS or CR4.CET? If it's the
former, then it's OK for me.

> >  
> >  static __init void vmx_set_cpu_caps(void)
> > -- 
> > 2.17.2
> > 
