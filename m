Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B206C5E63
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 06:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjCWFIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 01:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjCWFIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 01:08:14 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4A013D5D;
        Wed, 22 Mar 2023 22:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679548088; x=1711084088;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FdONquWcPrciSMSG9VJ10s8v+lY1FDG1spblU1KxGJg=;
  b=jqtzag3zyrzp5WEFJJ6TN0cUGIsh9NTfEm0DR6O8z8rNRgUHGaZ0ZD0V
   DFocpW1D4ICpgniUwHXHRYjwwAO++hpPNrdmtUP83Z3nIKV0MS47FNsfT
   uXD2xn12lavqrYT0wv4+4ZkChC/ZsyfemheqaotlTu2TZZ26twH8ZZSZg
   AGKQQMeMcJfX/iGNtz4v01wDMkc6F5HU0h3isnQntUmccGmDzok3IPnhc
   7qNSOhM+uQE1HeyVGsfLdFMRKXP4oGr8FAZ4FuprXvmINRCDlg7oubIcJ
   /0zNL4Zpwbnb37OolgFSh5fdhWGFsB6o8q033r1/2kKwIV8pnuMBcdP5r
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="319787348"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="319787348"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 22:08:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="825684119"
X-IronPort-AV: E=Sophos;i="5.98,283,1673942400"; 
   d="scan'208";a="825684119"
Received: from jmichaud-mobl.amr.corp.intel.com (HELO desk) ([10.252.131.127])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 22:08:07 -0700
Date:   Wed, 22 Mar 2023 22:07:53 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 5/6] KVM: x86: Virtualize FLUSH_L1D and passthrough
 MSR_IA32_FLUSH_CMD
Message-ID: <20230323050753.rufixzrzt2sf3avv@desk>
References: <20230322011440.2195485-1-seanjc@google.com>
 <20230322011440.2195485-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322011440.2195485-6-seanjc@google.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 06:14:39PM -0700, Sean Christopherson wrote:
> Virtualize FLUSH_L1D so that the guest can use the performant L1D flush
> if one of the many mitigations might require a flush in the guest, e.g.
> Linux provides an option to flush the L1D when switching mms.
> 
> Passthrough MSR_IA32_FLUSH_CMD for write when it's supported in hardware
> and exposed to the guest, i.e. always let the guest write it directly if
> FLUSH_L1D is fully supported.
> 
> Forward writes to hardware in host context on the off chance that KVM
> ends up emulating a WRMSR, or in the really unlikely scenario where
> userspace wants to force a flush.  Restrict these forwarded WRMSRs to
> the known command out of an abundance of caution.  Passing through the
> MSR means the guest can throw any and all values at hardware, but doing
> so in host context is arguably a bit more dangerous.
> 
> Link: https://lkml.kernel.org/r/CALMp9eTt3xzAEoQ038bJQ9LN0ZOXrSWsN7xnNUD%2B0SS%3DWwF7Pg%40mail.gmail.com
> Link: https://lore.kernel.org/all/20230201132905.549148-2-eesposit@redhat.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c      |  2 +-
>  arch/x86/kvm/svm/svm.c    |  5 +++++
>  arch/x86/kvm/vmx/nested.c |  3 +++
>  arch/x86/kvm/vmx/vmx.c    |  5 +++++
>  arch/x86/kvm/vmx/vmx.h    |  2 +-
>  arch/x86/kvm/x86.c        | 12 ++++++++++++
>  6 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 599aebec2d52..9583a110cf5f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -653,7 +653,7 @@ void kvm_set_cpu_caps(void)
>  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>  		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>  		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
> -		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16)
> +		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(FLUSH_L1D)
>  	);
>  
>  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 85bb535fc321..b32edaf5a74b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -95,6 +95,7 @@ static const struct svm_direct_access_msrs {
>  #endif
>  	{ .index = MSR_IA32_SPEC_CTRL,			.always = false },
>  	{ .index = MSR_IA32_PRED_CMD,			.always = false },
> +	{ .index = MSR_IA32_FLUSH_CMD,			.always = false },
>  	{ .index = MSR_IA32_LASTBRANCHFROMIP,		.always = false },
>  	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
>  	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
> @@ -4140,6 +4141,10 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PRED_CMD, 0,
>  				     !!guest_has_pred_cmd_msr(vcpu));
>  
> +	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))

Just curious, will this ever be true on AMD hardware? AFAIK,
X86_FEATURE_FLUSH_L1D is Intel-defined CPU feature.

> +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_FLUSH_CMD, 0,
> +				     !!guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
> +
>  	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
>  	if (sev_guest(vcpu->kvm)) {
>  		best = kvm_find_cpuid_entry(vcpu, 0x8000001F);
