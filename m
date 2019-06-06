Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F71F37A22
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbfFFQxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:53:43 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55326 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfFFQxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:53:43 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so637683wmj.5
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 09:53:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SuYESJ9iiWvL9dtRpfuFmhFxdHTDgBnnMGxfl5uoJd0=;
        b=lrgTjIm/yoPUyuZY5K+/8uMIXPCaKp6lqmtqNc5aMzx//tuPc+5Y4IjFgBR8AdMO4N
         1Z6uYH7tTdfCtVrqne8N2/xjgiwa5ocVmjl/ZIJIvBb9XXlAdgD25D8C1ssSWgeCg+/1
         816RIccPQff4PHixQ190L2Kbfk9P9qi4+dyotJUFJDKKRC2vjnyivwwTA2Xpg2zhDXXz
         vg5gxWEn5PfMDXrhXqTJmBIG2hfaS84jwqJSRc3ilIETgP5D7Ao2bn7yMOWkEXvKdvlA
         5+d8wTaUvebLW3B3SHMmyJoMFG43IJNqn6iggvZcHD3CAhyXkNM4JRkYa6SntptVqR+B
         1I1Q==
X-Gm-Message-State: APjAAAXR4RVXJKL+jaGAmYQexbs4wsECR0HjjMZOoEmsAIVqKYLg/tVG
        Oj9uJfa6PFLACT0VfufV8aabug==
X-Google-Smtp-Source: APXvYqy32FaTv7M0u6sIhZJSTn3/3Oqpe+zjUWXmd4oFYX9clf2FJ3fy3KN9bE42p0DEDQX4k97Acg==
X-Received: by 2002:a1c:1c5:: with SMTP id 188mr659936wmb.34.1559840020508;
        Thu, 06 Jun 2019 09:53:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id j123sm2801277wmb.32.2019.06.06.09.53.37
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 09:53:39 -0700 (PDT)
Subject: Re: [PATCH 15/15] KVM: nVMX: Copy PDPTRs to/from vmcs12 only when
 necessary
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
 <20190507160640.4812-16-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <be8527e9-8793-0b15-fda2-fd73fb40d446@redhat.com>
Date:   Thu, 6 Jun 2019 18:53:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507160640.4812-16-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 18:06, Sean Christopherson wrote:
> Per Intel's SDM:
> 
>   ... the logical processor uses PAE paging if CR0.PG=1, CR4.PAE=1 and
>   IA32_EFER.LME=0.  A VM entry to a guest that uses PAE paging loads the
>   PDPTEs into internal, non-architectural registers based on the setting
>   of the "enable EPT" VM-execution control.
> 
> and:
> 
>   [GUEST_PDPTR] values are saved into the four PDPTE fields as follows:
> 
>     - If the "enable EPT" VM-execution control is 0 or the logical
>       processor was not using PAE paging at the time of the VM exit,
>       the values saved are undefined.
> 
> In other words, if EPT is disabled or the guest isn't using PAE paging,
> then the PDPTRS aren't consumed by hardware on VM-Entry and are loaded
> with junk on VM-Exit.  From a nesting perspective, all of the above hold
> true, i.e. KVM can effectively ignore the VMCS PDPTRs.  E.g. KVM already
> loads the PDPTRs from memory when nested EPT is disabled (see
> nested_vmx_load_cr3()).
> 
> Because KVM intercepts setting CR4.PAE, there is no danger of consuming
> a stale value or crushing L1's VMWRITEs regardless of whether L1
> intercepts CR4.PAE. The vmcs12's values are unchanged up until the
> VM-Exit where L2 sets CR4.PAE, i.e. L0 will see the new PAE state on the
> subsequent VM-Entry and propagate the PDPTRs from vmcs12 to vmcs02.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 36 +++++++++++++++++++++---------------
>  1 file changed, 21 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index cfdc04fde8eb..b8bd446b2c8b 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2184,17 +2184,6 @@ static void prepare_vmcs02_full(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  		vmcs_writel(GUEST_SYSENTER_ESP, vmcs12->guest_sysenter_esp);
>  		vmcs_writel(GUEST_SYSENTER_EIP, vmcs12->guest_sysenter_eip);
>  
> -		/*
> -		 * L1 may access the L2's PDPTR, so save them to construct
> -		 * vmcs12
> -		 */
> -		if (enable_ept) {
> -			vmcs_write64(GUEST_PDPTR0, vmcs12->guest_pdptr0);
> -			vmcs_write64(GUEST_PDPTR1, vmcs12->guest_pdptr1);
> -			vmcs_write64(GUEST_PDPTR2, vmcs12->guest_pdptr2);
> -			vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
> -		}
> -
>  		if (vmx->nested.nested_run_pending &&
>  		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
>  			vmcs_write64(GUEST_IA32_DEBUGCTL,
> @@ -2256,10 +2245,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
> +	bool load_guest_pdptrs_vmcs12 = false;
>  
>  	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs) {
>  		prepare_vmcs02_full(vmx, vmcs12);
>  		vmx->nested.dirty_vmcs12 = false;
> +
> +		load_guest_pdptrs_vmcs12 = !vmx->nested.hv_evmcs ||
> +			!(vmx->nested.hv_evmcs->hv_clean_fields &
> +			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
>  	}
>  
>  	/*
> @@ -2366,6 +2360,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  		return -EINVAL;
>  	}
>  
> +	/* Late preparation of GUEST_PDPTRs now that EFER and CRs are set. */
> +	if (load_guest_pdptrs_vmcs12 && nested_cpu_has_ept(vmcs12) &&
> +	    !is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
> +		vmcs_write64(GUEST_PDPTR0, vmcs12->guest_pdptr0);
> +		vmcs_write64(GUEST_PDPTR1, vmcs12->guest_pdptr1);
> +		vmcs_write64(GUEST_PDPTR2, vmcs12->guest_pdptr2);
> +		vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
> +	}

This probably should be merged into nested_vmx_load_cr3, but something
for later.  I've just sent a patch to create a new is_pae_paging
function that can be used here.

Paolo

>  	/* Shadow page tables on either EPT or shadow page tables. */
>  	if (nested_vmx_load_cr3(vcpu, vmcs12->guest_cr3, nested_cpu_has_ept(vmcs12),
>  				entry_failure_code))
> @@ -3467,10 +3470,13 @@ static void sync_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>  	 */
>  	if (enable_ept) {
>  		vmcs12->guest_cr3 = vmcs_readl(GUEST_CR3);
> -		vmcs12->guest_pdptr0 = vmcs_read64(GUEST_PDPTR0);
> -		vmcs12->guest_pdptr1 = vmcs_read64(GUEST_PDPTR1);
> -		vmcs12->guest_pdptr2 = vmcs_read64(GUEST_PDPTR2);
> -		vmcs12->guest_pdptr3 = vmcs_read64(GUEST_PDPTR3);
> +		if (nested_cpu_has_ept(vmcs12) && !is_long_mode(vcpu) &&
> +		    is_pae(vcpu) && is_paging(vcpu)) {
> +			vmcs12->guest_pdptr0 = vmcs_read64(GUEST_PDPTR0);
> +			vmcs12->guest_pdptr1 = vmcs_read64(GUEST_PDPTR1);
> +			vmcs12->guest_pdptr2 = vmcs_read64(GUEST_PDPTR2);
> +			vmcs12->guest_pdptr3 = vmcs_read64(GUEST_PDPTR3);
> +		}
>  	}
>  
>  	vmcs12->guest_linear_address = vmcs_readl(GUEST_LINEAR_ADDRESS);
> 

