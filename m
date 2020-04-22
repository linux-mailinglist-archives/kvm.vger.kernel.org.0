Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C94C1B34B5
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 03:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDVB6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 21:58:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:46869 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgDVB6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 21:58:00 -0400
IronPort-SDR: 6MZFnnKAdLRUl3BSZzjTW+Aa1Fajc8WYf9KgRu62RlmxJaYNL9dT5+LKMk0msH/GPbgvN8u8T2
 5/Yx/9XwrvAA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 18:57:59 -0700
IronPort-SDR: WD+uJhq4rQL85dMqO8cDV7jeRPbSO1Ui7I17S2/P4h8ZwJdrtyt9s94PHfHoyUPcU6nZSLTkqe
 CLeu/biOSTew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,412,1580803200"; 
   d="scan'208";a="290671750"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 21 Apr 2020 18:57:59 -0700
Date:   Tue, 21 Apr 2020 18:57:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Makarand Sonare <makarandsonare@google.com>
Cc:     kvm@vger.kernel.org, pshier@google.com, jmattson@google.com
Subject: Re: [kvm PATCH 2/2] KVM: nVMX: Don't clobber preemption timer in the
 VMCS12 before L2 ran
Message-ID: <20200422015759.GE17836@linux.intel.com>
References: <20200417183452.115762-1-makarandsonare@google.com>
 <20200417183452.115762-3-makarandsonare@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417183452.115762-3-makarandsonare@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 11:34:52AM -0700, Makarand Sonare wrote:
> Don't clobber the VMX-preemption timer value in the VMCS12 during
> migration on the source while handling an L1 VMLAUNCH/VMRESUME but
> before L2 ran. In that case the VMCS12 preemption timer value
> should not be touched as it will be restarted on the target
> from its original value. This emulates migration occurring while L1
> awaits completion of its VMLAUNCH/VMRESUME instruction.
> 
> Signed-off-by: Makarand Sonare <makarandsonare@google.com>
> Signed-off-by: Peter Shier <pshier@google.com>

The SOB tags are reversed, i.e. Peter's should be first to show that he
wrote the patch and then transfered it to you for upstreaming.

> Change-Id: I376d151585d4f1449319f7512151f11bbf08c5bf
> ---
>  arch/x86/kvm/vmx/nested.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 5365d7e5921ea..66155e9114114 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3897,11 +3897,13 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  		vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;
>  
>  	if (nested_cpu_has_preemption_timer(vmcs12)) {
> -		vmx->nested.preemption_timer_remaining =
> -			vmx_get_preemption_timer_value(vcpu);
> -		if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> -			vmcs12->vmx_preemption_timer_value =
> -				vmx->nested.preemption_timer_remaining;
> +		if (!vmx->nested.nested_run_pending) {
> +			vmx->nested.preemption_timer_remaining =
> +				vmx_get_preemption_timer_value(vcpu);
> +			if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
> +				vmcs12->vmx_preemption_timer_value =
> +					vmx->nested.preemption_timer_remaining;
> +			}

This indentation is messed up, the closing brace is for !nested_run_pending,
but it's aligned with (vm_exit_controls & ..._PREEMPTION_TIMER).

Even better than fixing the indentation would be to include !nested_run_pending
in the top-level if statement, which reduces the nesting level and produces
a much cleaner diff, e.g.

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 409a39af121f..7dd6440425ab 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3951,7 +3951,8 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
        else
                vmcs12->guest_activity_state = GUEST_ACTIVITY_ACTIVE;

-       if (nested_cpu_has_preemption_timer(vmcs12)) {
+       if (nested_cpu_has_preemption_timer(vmcs12) &&
+           !vmx->nested.nested_run_pending) {
                vmx->nested.preemption_timer_remaining =
                        vmx_get_preemption_timer_value(vcpu);
                if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)

>  	}
>  
>  	/*
> -- 
> 2.26.1.301.g55bc3eb7cb9-goog
> 
