Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53AA71324A
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 18:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfECQfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 12:35:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:28983 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbfECQfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 12:35:25 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 May 2019 09:35:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,426,1549958400"; 
   d="scan'208";a="343244440"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by fmsmga006.fm.intel.com with ESMTP; 03 May 2019 09:35:24 -0700
Date:   Fri, 3 May 2019 09:35:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        marcorr@google.com, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/3] kvm: nVMX: Set nested_run_pending in
 vmx_set_nested_state after checks complete
Message-ID: <20190503163524.GB32628@linux.intel.com>
References: <20190502183125.257005-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502183125.257005-1-aaronlewis@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 02, 2019 at 11:31:25AM -0700, Aaron Lewis wrote:
> nested_run_pending=1 implies we have successfully entered guest mode.
> Move setting from external state in vmx_set_nested_state() until after
> all other checks are complete.
> 
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6401eb7ef19c..081dea6e211a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5460,9 +5460,6 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
>  		return 0;
>  
> -	vmx->nested.nested_run_pending =
> -		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);

@nested_run_pending is consumed by nested_vmx_enter_non_root_mode(),
e.g. prepare_vmcs02().  I'm guessing its current location is deliberate.

> -
>  	if (nested_cpu_has_shadow_vmcs(vmcs12) &&
>  	    vmcs12->vmcs_link_pointer != -1ull) {
>  		struct vmcs12 *shadow_vmcs12 = get_shadow_vmcs12(vcpu);
> @@ -5489,6 +5486,9 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
>  	if (ret)
>  		return -EINVAL;
>  
> +	vmx->nested.nested_run_pending =
> +		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
> +
>  	return 0;
>  }
>  
> -- 
> 2.21.0.593.g511ec345e18-goog
> 
