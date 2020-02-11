Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7186E159C5F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbgBKWii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:38:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:58431 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727041AbgBKWih (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:38:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Feb 2020 14:38:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,428,1574150400"; 
   d="scan'208";a="251707124"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 11 Feb 2020 14:38:36 -0800
Date:   Tue, 11 Feb 2020 14:38:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: do not reset microcode version on INIT or RESET
Message-ID: <20200211223837.GC21526@linux.intel.com>
References: <1581444279-10033-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581444279-10033-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 07:04:39PM +0100, Paolo Bonzini wrote:
> The microcode version should be set just once, since it is essentially
> a CPU feature; so do it on vCPU creation rather than reset.

I wouldn't call it a CPU feature, CPU features generally can't be
arbitrarily changed while running.  I'd prefer to have a changelog that
at least somewhat ties the change to hardware behavior. 

  Do not initialize the microcode version at RESET or INIT.   Microcode
  updates are not lost during INIT, and exact behavior across a warm RESET
  is microarchitectural, i.e. defer to userspace to emulate behavior for
  RESET as it sees fit.

For the code:

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

> Userspace can tie the fix to the availability of MSR_IA32_UCODE_REV in
> the list of emulated MSRs.
> 
> Reported-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm.c     | 2 +-
>  arch/x86/kvm/vmx/vmx.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index a7e63b613837..280f6d024e84 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2185,7 +2185,6 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	u32 dummy;
>  	u32 eax = 1;
>  
> -	vcpu->arch.microcode_version = 0x01000065;
>  	svm->spec_ctrl = 0;
>  	svm->virt_spec_ctrl = 0;
>  
> @@ -2276,6 +2275,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
>  	init_vmcb(svm);
>  
>  	svm_init_osvw(vcpu);
> +	vcpu->arch.microcode_version = 0x01000065;
>  
>  	return 0;
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9a6664886f2e..d625b4b0e7b4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4238,7 +4238,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  	vmx->msr_ia32_umwait_control = 0;
>  
> -	vcpu->arch.microcode_version = 0x100000000ULL;
>  	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
>  	vmx->hv_deadline_tsc = -1;
>  	kvm_set_cr8(vcpu, 0);
> @@ -6763,6 +6762,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  	vmx->nested.posted_intr_nv = -1;
>  	vmx->nested.current_vmptr = -1ull;
>  
> +	vcpu->arch.microcode_version = 0x100000000ULL;
>  	vmx->msr_ia32_feature_control_valid_bits = FEAT_CTL_LOCKED;
>  
>  	/*
> -- 
> 1.8.3.1
> 
