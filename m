Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA2637C65
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 20:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfFFSlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 14:41:19 -0400
Received: from mga05.intel.com ([192.55.52.43]:26420 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfFFSlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 14:41:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 11:41:18 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 06 Jun 2019 11:41:17 -0700
Date:   Thu, 6 Jun 2019 11:41:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Rename prepare_vmcs02_*_full to
 prepare_vmcs02_*_extra
Message-ID: <20190606184117.GJ23169@linux.intel.com>
References: <1559834652-105872-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559834652-105872-1-git-send-email-pbonzini@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 06, 2019 at 05:24:12PM +0200, Paolo Bonzini wrote:
> These function do not prepare the entire state of the vmcs02, only the
> rarely needed parts.  Rename them to make this clearer.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 84438cf23d37..fd8150ef6cce 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1955,7 +1955,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
>  	vmx_set_constant_host_state(vmx);
>  }
>  
> -static void prepare_vmcs02_early_full(struct vcpu_vmx *vmx,
> +static void prepare_vmcs02_early_extra(struct vcpu_vmx *vmx,

Or maybe 'uncommon', 'rare' or 'ext'?  I don't I particularly love any of
the names, but they're all better than 'full'.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

>  				      struct vmcs12 *vmcs12)
>  {
>  	prepare_vmcs02_constant_state(vmx);
> @@ -1976,7 +1976,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
>  
>  	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs)
> -		prepare_vmcs02_early_full(vmx, vmcs12);
> +		prepare_vmcs02_early_extra(vmx, vmcs12);
>  
>  	/*
>  	 * PIN CONTROLS
> @@ -2130,7 +2130,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  	}
>  }
>  
> -static void prepare_vmcs02_full(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
> +static void prepare_vmcs02_extra(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  {
>  	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
>  
> @@ -2254,7 +2254,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
>  	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs) {
> -		prepare_vmcs02_full(vmx, vmcs12);
> +		prepare_vmcs02_extra(vmx, vmcs12);
>  		vmx->nested.dirty_vmcs12 = false;
>  	}
>  
> -- 
> 1.8.3.1
> 
