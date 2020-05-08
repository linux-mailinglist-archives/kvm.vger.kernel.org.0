Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813921CBA7E
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 00:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEHWQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 18:16:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:51818 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgEHWQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 18:16:27 -0400
IronPort-SDR: Gqe8AGgTg7zqSJBaWBSk/Ox1CcQMY+4CvpNcD4Z9rn+PxpEFpBrdgFKCfyV7k6c40cZSVW+xbf
 FyQ3wix8re8g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 15:16:27 -0700
IronPort-SDR: bJjMcqbRQLWGSyR19dwjX59W6Ip4S3Bn7a5nAucXtpYJn4e/oNOla2kpaCeTJXYUbwwTMhefZx
 p11/5vDzfUaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="462731680"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 08 May 2020 15:16:27 -0700
Date:   Fri, 8 May 2020 15:16:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Subject: Re: [PATCH 1/3] KVM: nVMX: Really make emulated nested preemption
 timer pinned
Message-ID: <20200508221626.GU27052@linux.intel.com>
References: <20200508203643.85477-1-jmattson@google.com>
 <20200508203643.85477-2-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508203643.85477-2-jmattson@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LOL, love the shortlog :-)

On Fri, May 08, 2020 at 01:36:41PM -0700, Jim Mattson wrote:
> The PINNED bit is ignored by hrtimer_init. It is only considered when
> starting the timer.
> 
> When the hrtimer isn't pinned to the same logical processor as the
> vCPU thread to be interrupted, the emulated VMX-preemption timer
> often fails to adhere to the architectural specification.
> 
> Fixes: f15a75eedc18e ("KVM: nVMX: make emulated nested preemption timer pinned")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index fd78ffbde644..1f7fe6f47cbc 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2041,7 +2041,7 @@ static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu)
>  	preemption_timeout *= 1000000;
>  	do_div(preemption_timeout, vcpu->arch.virtual_tsc_khz);
>  	hrtimer_start(&vmx->nested.preemption_timer,
> -		      ns_to_ktime(preemption_timeout), HRTIMER_MODE_REL);
> +		      ns_to_ktime(preemption_timeout), HRTIMER_MODE_REL_PINNED);
>  }
>  
>  static u64 nested_vmx_calc_efer(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> -- 
> 2.26.2.645.ge9eca65c58-goog
> 
