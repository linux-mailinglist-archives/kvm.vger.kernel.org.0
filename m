Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AA01B6477
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 21:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgDWTbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 15:31:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:45090 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbgDWTbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 15:31:09 -0400
IronPort-SDR: CTNkFYoa3JcqBpK/uI4fzZ0XoE68i/cIPBPn03BjjcqFwtYJLk99rUNy1DoXkKE4daruisg+Sb
 ppVCedPGY1Kg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 12:31:09 -0700
IronPort-SDR: tqg+y67A/vNG+cYI5UcNzAeImAaYvydHXeRdJYcr+b08J/agvX+DJI0UNOTHxHxpPb/1zAWlwI
 phuRR75eTgaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="430444846"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 23 Apr 2020 12:31:09 -0700
Date:   Thu, 23 Apr 2020 12:31:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] kvm: x86: skip DRn reload if previous VM exit is
 DR access VM exit
Message-ID: <20200423193108.GP17824@linux.intel.com>
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
 <20200416101509.73526-4-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416101509.73526-4-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 16, 2020 at 06:15:09PM +0800, Xiaoyao Li wrote:
> When DR access vm exit, there is no DRn change throughout VM exit to
> next VM enter. Skip the DRn reload in this case and fix the comments.

Same thing as the previous patch, the hardware values aren't stable.  In
this case, MOV DR won't exit so KVM needs to ensure hardware has the guest
values, irrespective of whether breakpoints are enabled.

> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/svm/svm.c | 8 +++++---
>  arch/x86/kvm/vmx/vmx.c | 8 +++++---
>  arch/x86/kvm/x86.c     | 2 +-
>  3 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 66123848448d..c6883a0bf8c3 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2287,9 +2287,11 @@ static int dr_interception(struct vcpu_svm *svm)
>  
>  	if (svm->vcpu.guest_debug == 0) {
>  		/*
> -		 * No more DR vmexits; force a reload of the debug registers
> -		 * and reenter on this instruction.  The next vmexit will
> -		 * retrieve the full state of the debug registers.
> +		 * No more DR vmexits and reenter on this instruction.
> +		 * The next vmexit will retrieve the full state of the debug
> +		 * registers and re-enable DR vmexits.
> +		 * No need to set KVM_DEBUGREG_NEED_RELOAD because no DRn change
> +		 * since this DR vmexit.
>  		 */
>  		clr_dr_intercepts(svm);
>  		svm->vcpu.arch.switch_db_regs |= KVM_DEBUGREG_WONT_EXIT;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index aa1b8cf7c915..22eff8503048 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4967,9 +4967,11 @@ static int handle_dr(struct kvm_vcpu *vcpu)
>  		exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_MOV_DR_EXITING);
>  
>  		/*
> -		 * No more DR vmexits; force a reload of the debug registers
> -		 * and reenter on this instruction.  The next vmexit will
> -		 * retrieve the full state of the debug registers.
> +		 * No more DR vmexits and reenter on this instruction.
> +		 * The next vmexit will retrieve the full state of the debug
> +		 * registers and re-enable DR vmexits.
> +		 * No need to set KVM_DEBUGREG_NEED_RELOAD because no DRn change
> +		 * since this DR vmexit.
>  		 */
>  		vcpu->arch.switch_db_regs |= KVM_DEBUGREG_WONT_EXIT;
>  		return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 71264df64001..8983848cbf45 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8400,7 +8400,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	if (test_thread_flag(TIF_NEED_FPU_LOAD))
>  		switch_fpu_return();
>  
> -	if (unlikely(vcpu->arch.switch_db_regs)) {
> +	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_NEED_RELOAD)) {
>  		set_debugreg(0, 7);
>  		set_debugreg(vcpu->arch.eff_db[0], 0);
>  		set_debugreg(vcpu->arch.eff_db[1], 1);
> -- 
> 2.20.1
> 
