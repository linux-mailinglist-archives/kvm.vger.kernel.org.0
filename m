Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBA11BD9D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 21:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729092AbfEMTMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 15:12:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:54188 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbfEMTMz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 15:12:55 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 May 2019 12:12:54 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga004.fm.intel.com with ESMTP; 13 May 2019 12:12:54 -0700
Date:   Mon, 13 May 2019 12:12:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com
Subject: Re: [PATCH 7/8][KVM nVMX]: Enable "load IA32_PERF_GLOBAL_CTRL
 VM-{entry,exit} controls
Message-ID: <20190513191254.GJ28561@linux.intel.com>
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-8-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424231724.2014-8-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 24, 2019 at 07:17:23PM -0400, Krish Sadhukhan wrote:
>  ...based on whether the guest CPU supports PMU
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Suggested-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4d39f731bc33..fa9c786afcfa 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6964,6 +6964,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
>  static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	bool pmu_enabled = guest_cpuid_has_pmu(vcpu);

A revert has been sent for the patch that added guest_cpuid_has_pmu().

Regardless, checking only the guest's CPUID 0xA is not sufficient, e.g.
at the bare minimum, exposing the controls can be done if and only if
cpu_has_load_perf_global_ctrl() is true.

In general, it's difficult for me to understand exactly what functionality
you intend to introduce.  Proper changelogs would be very helpful.

>  
>  	if (kvm_mpx_supported()) {
>  		bool mpx_enabled = guest_cpuid_has(vcpu, X86_FEATURE_MPX);
> @@ -6976,6 +6977,17 @@ static void nested_vmx_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
>  			vmx->nested.msrs.exit_ctls_high &= ~VM_EXIT_CLEAR_BNDCFGS;
>  		}
>  	}
> +	if (pmu_enabled) {
> +		vmx->nested.msrs.entry_ctls_high |=
> +		    VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		vmx->nested.msrs.exit_ctls_high |=
> +		    VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +	} else {
> +		vmx->nested.msrs.entry_ctls_high &=
> +		    ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		vmx->nested.msrs.exit_ctls_high &=
> +		    ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +	}
>  }
>  
>  static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
> -- 
> 2.17.2
> 
