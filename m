Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6733411FCC5
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 03:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfLPCRF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Dec 2019 21:17:05 -0500
Received: from mga06.intel.com ([134.134.136.31]:20303 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbfLPCRF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Dec 2019 21:17:05 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Dec 2019 18:17:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,320,1571727600"; 
   d="scan'208";a="297549621"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 15 Dec 2019 18:17:02 -0800
Date:   Mon, 16 Dec 2019 10:18:16 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        yu-cheng.yu@intel.com
Subject: Re: [PATCH v8 3/7] KVM: VMX: Pass through CET related MSRs
Message-ID: <20191216021816.GA10764@local-michael-cet-test>
References: <20191101085222.27997-1-weijiang.yang@intel.com>
 <20191101085222.27997-4-weijiang.yang@intel.com>
 <20191210211821.GL15758@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210211821.GL15758@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 01:18:21PM -0800, Sean Christopherson wrote:
> On Fri, Nov 01, 2019 at 04:52:18PM +0800, Yang Weijiang wrote:
> > CET MSRs pass through Guest directly to enhance performance.
> > CET runtime control settings are stored in MSR_IA32_{U,S}_CET,
> > Shadow Stack Pointer(SSP) are stored in MSR_IA32_PL{0,1,2,3}_SSP,
> > SSP table base address is stored in MSR_IA32_INT_SSP_TAB,
> > these MSRs are defined in kernel and re-used here.
> > 
 > +
> >  static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > @@ -7025,6 +7087,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> >  	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> >  			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
> >  		update_intel_pt_cfg(vcpu);
> > +
> > +	if (!is_guest_mode(vcpu))
> > +		vmx_pass_cet_msrs(vcpu);
> 
> Hmm, this looks insufficent, e.g. deliberately toggling CET from on->off
> while in guest mode would put KVM in a weird state as the msr bitmap for
> L1 would still allow L1 to access the CET MSRs.
>
Hi, Sean,
I don't get you, there's guest mode check before access CET msrs, it'll
fail if it's in guest mode.

> Allowing KVM_SET_CPUID{2} while running a nested guest seems bogus, can we
> kill that path entirely with -EINVAL?
>
Do you mean don't expose CET cpuids to L2 guest?
thanks!

> >  }
> >  
> >  static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> > -- 
> > 2.17.2
> > 
