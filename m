Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91421BACEA
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 20:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgD0Shi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 14:37:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:8491 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgD0Shi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 14:37:38 -0400
IronPort-SDR: OIG6xCkYhX128gK8WLaGHjGIayXvJeh+E6Srz+qSIiGjpY7/iQ+83T6BuoodQ0iE3RBwmUubI/
 oDkHfSd6lWSQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 11:37:38 -0700
IronPort-SDR: GHzQaaYSS2CVqQZ+1PfWMy+cfbt0jEuiMlFvPP2l2LHV7kW2Hw2WjsCu81fnBBuHIIzJFM74/i
 etf4UdNP/NVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="247484671"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga007.fm.intel.com with ESMTP; 27 Apr 2020 11:37:37 -0700
Date:   Mon, 27 Apr 2020 11:37:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
Subject: Re: [PATCH v3 3/5] KVM: VMX: Optimize posted-interrupt delivery for
 timer fastpath
Message-ID: <20200427183737.GP14870@linux.intel.com>
References: <1587709364-19090-1-git-send-email-wanpengli@tencent.com>
 <1587709364-19090-4-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587709364-19090-4-git-send-email-wanpengli@tencent.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 02:22:42PM +0800, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Optimizing posted-interrupt delivery especially for the timer fastpath 
> scenario, I observe kvm_x86_ops.deliver_posted_interrupt() has more latency 
> then vmx_sync_pir_to_irr() in the case of timer fastpath scenario, since 
> it needs to wait vmentry, after that it can handle external interrupt, ack 
> the notification vector, read posted-interrupt descriptor etc, it is slower 
> than evaluate and delivery during vmentry immediately approach. Let's skip 
> sending interrupt to notify target pCPU and replace by vmx_sync_pir_to_irr() 
> before each cont_run.
> 
> Tested-by: Haiwei Li <lihaiwei@tencent.com>
> Cc: Haiwei Li <lihaiwei@tencent.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 9 ++++++---
>  virt/kvm/kvm_main.c    | 1 +
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 5c21027..d21b66b 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3909,8 +3909,9 @@ static int vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu, int vector)
>  	if (pi_test_and_set_on(&vmx->pi_desc))
>  		return 0;
>  
> -	if (!kvm_vcpu_trigger_posted_interrupt(vcpu, false))
> -		kvm_vcpu_kick(vcpu);
> +	if (vcpu != kvm_get_running_vcpu() &&
> +		!kvm_vcpu_trigger_posted_interrupt(vcpu, false))

Bad indentation.

> +		kvm_vcpu_kick(vcpu);
>  
>  	return 0;
>  }
> @@ -6757,8 +6758,10 @@ static enum exit_fastpath_completion vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	if (!kvm_need_cancel_enter_guest(vcpu)) {
>  		exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
>  		/* static call is better with retpolines */
> -		if (exit_fastpath == EXIT_FASTPATH_CONT_RUN)
> +		if (exit_fastpath == EXIT_FASTPATH_CONT_RUN) {
> +			vmx_sync_pir_to_irr(vcpu);
>  			goto cont_run;
> +		}
>  	}
>  
>  	return exit_fastpath;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e7436d0..6a289d1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4633,6 +4633,7 @@ struct kvm_vcpu *kvm_get_running_vcpu(void)
>  
>  	return vcpu;
>  }
> +EXPORT_SYMBOL_GPL(kvm_get_running_vcpu);
>  
>  /**
>   * kvm_get_running_vcpus - get the per-CPU array of currently running vcpus.
> -- 
> 2.7.4
> 
