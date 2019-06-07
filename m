Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B45A394AD
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 20:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732052AbfFGSwZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 14:52:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:2030 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729673AbfFGSwZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 14:52:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 11:52:24 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 07 Jun 2019 11:52:24 -0700
Date:   Fri, 7 Jun 2019 11:52:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
Subject: Re: [PATCH] nVMX: Get rid of prepare_vmcs02_early_full and inline
 its content in the caller
Message-ID: <20190607185224.GI9083@linux.intel.com>
References: <20190607180544.17241-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190607180544.17241-1-krish.sadhukhan@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 07, 2019 at 02:05:44PM -0400, Krish Sadhukhan wrote:
>  ..as there is no need for a separate function
> 
> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 30 +++++++++++++-----------------
>  1 file changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index f1a69117ac0f..4643eb3a97f7 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1963,28 +1963,24 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
>  	vmx_set_constant_host_state(vmx);
>  }
>  
> -static void prepare_vmcs02_early_full(struct vcpu_vmx *vmx,
> -				      struct vmcs12 *vmcs12)
> -{
> -	prepare_vmcs02_constant_state(vmx);
> -
> -	vmcs_write64(VMCS_LINK_POINTER, -1ull);
> -
> -	if (enable_vpid) {
> -		if (nested_cpu_has_vpid(vmcs12) && vmx->nested.vpid02)
> -			vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->nested.vpid02);
> -		else
> -			vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
> -	}
> -}
> -
>  static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  {
>  	u32 exec_control, vmcs12_exec_ctrl;
>  	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
>  
> -	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs)
> -		prepare_vmcs02_early_full(vmx, vmcs12);
> +	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs) {
> +		prepare_vmcs02_constant_state(vmx);
> +
> +		vmcs_write64(VMCS_LINK_POINTER, -1ull);
> +
> +		if (enable_vpid) {
> +			if (nested_cpu_has_vpid(vmcs12) && vmx->nested.vpid02)
> +				vmcs_write16(VIRTUAL_PROCESSOR_ID,
> +					     vmx->nested.vpid02);
> +			else
> +				vmcs_write16(VIRTUAL_PROCESSOR_ID, vmx->vpid);
> +		}
> +	}

My vote is to keep the separate helper.  I agree that it's a bit
superfluous, but I really like having symmetry across the "early" and
"late" prepartion flows, i.e. there's value in having both
prepare_vmcs02_full() and prepare_vmcs02_early_full().

>  
>  	/*
>  	 * PIN CONTROLS
> -- 
> 2.20.1
> 
