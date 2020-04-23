Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62651B5E11
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 16:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728403AbgDWOmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 10:42:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:40291 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgDWOmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 10:42:10 -0400
IronPort-SDR: Y5r+AXxd6Q4bljWGySnDoehbm4Qk+E05YC0Tnr7TxtArcGnn9oD0ccZBw9ZCLYjMMBzrI2Mj/N
 V9D9BEjssB9g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 07:42:09 -0700
IronPort-SDR: heL70kamjV8fP3qeZ86FGQrHpl921Z+ulj0rEDtSvkjoGH+G/3HYAUI3tYQm05YAwuf90SuGC7
 tAtBeguRjE7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,307,1583222400"; 
   d="scan'208";a="430344560"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 23 Apr 2020 07:42:09 -0700
Date:   Thu, 23 Apr 2020 07:42:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cathy Avery <cavery@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, wei.huang2@amd.com
Subject: Re: [PATCH 2/2] KVM: x86: check_nested_events if there is an
 injectable NMI
Message-ID: <20200423144209.GA17824@linux.intel.com>
References: <20200414201107.22952-1-cavery@redhat.com>
 <20200414201107.22952-3-cavery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414201107.22952-3-cavery@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 14, 2020 at 04:11:07PM -0400, Cathy Avery wrote:
> With NMI intercept moved to check_nested_events there is a race
> condition where vcpu->arch.nmi_pending is set late causing

How is nmi_pending set late?  The KVM_{G,S}ET_VCPU_EVENTS paths can't set
it because the current KVM_RUN thread holds the mutex, and the only other
call to process_nmi() is in the request path of vcpu_enter_guest, which has
already executed.

> the execution of check_nested_events to not setup correctly
> for nested.exit_required. A second call to check_nested_events
> allows the injectable nmi to be detected in time in order to
> require immediate exit from L2 to L1.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 027dfd278a97..ecfafcd93536 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7734,10 +7734,17 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
>  		vcpu->arch.smi_pending = false;
>  		++vcpu->arch.smi_count;
>  		enter_smm(vcpu);
> -	} else if (vcpu->arch.nmi_pending && kvm_x86_ops.nmi_allowed(vcpu)) {
> -		--vcpu->arch.nmi_pending;
> -		vcpu->arch.nmi_injected = true;
> -		kvm_x86_ops.set_nmi(vcpu);
> +	} else if (vcpu->arch.nmi_pending) {
> +		if (is_guest_mode(vcpu) && kvm_x86_ops.check_nested_events) {
> +			r = kvm_x86_ops.check_nested_events(vcpu);
> +			if (r != 0)
> +				return r;
> +		}
> +		if (kvm_x86_ops.nmi_allowed(vcpu)) {
> +			--vcpu->arch.nmi_pending;
> +			vcpu->arch.nmi_injected = true;
> +			kvm_x86_ops.set_nmi(vcpu);
> +		}
>  	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
>  		/*
>  		 * Because interrupts can be injected asynchronously, we are
> -- 
> 2.20.1
> 
