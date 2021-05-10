Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB0C377DFA
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhEJIV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:21:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230146AbhEJIV5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:21:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620634853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KycsCZsBmF5GXF6UVjxsWkCrzDBEjgApKN4NXuzKWms=;
        b=S9oYPP/Qo3iTUTLmfJfeImY2WRZdRZeVLmDQ/SrMK0nsZL+P+5R3WT1AoU6+56beBAIeEu
        R27I3UuOU82dETk9ZWZDMBACXzF13u803pa1C30rYWnzPdC251mw8qCtd4fiwEvlKmua5R
        G09oJpmJkw47KYui20d/t3I/wQPcik0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-988bIh9jOjqeb8rX5UHe2A-1; Mon, 10 May 2021 04:20:51 -0400
X-MC-Unique: 988bIh9jOjqeb8rX5UHe2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3005B1008060;
        Mon, 10 May 2021 08:20:50 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D3725D74B;
        Mon, 10 May 2021 08:20:46 +0000 (UTC)
Message-ID: <3699a28f75fbb541ab14e90d5856c4b3a583497e.camel@redhat.com>
Subject: Re: [PATCH 07/15] KVM: x86: Add support for RDPID without RDTSCP
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:20:45 +0300
In-Reply-To: <20210504171734.1434054-8-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-8-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Allow userspace to enable RDPID for a guest without also enabling RDTSCP.
> Aside from checking for RDPID support in the obvious flows, VMX also needs
> to set ENABLE_RDTSCP=1 when RDPID is exposed.
> 
> For the record, there is no known scenario where enabling RDPID without
> RDTSCP is desirable.  But, both AMD and Intel architectures allow for the
> condition, i.e. this is purely to make KVM more architecturally accurate.
> 
> Fixes: 41cd02c6f7f6 ("kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID")
> Cc: stable@vger.kernel.org
> Reported-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c |  6 ++++--
>  arch/x86/kvm/vmx/vmx.c | 27 +++++++++++++++++++++++----
>  arch/x86/kvm/x86.c     |  3 ++-
>  3 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b3153d40cc4d..231b9650d864 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2669,7 +2669,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (tsc_aux_uret_slot < 0)
>  			return 1;
>  		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
>  			return 1;
>  		msr_info->data = svm->tsc_aux;
>  		break;
> @@ -2891,7 +2892,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  			return 1;
>  
>  		if (!msr->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
>  			return 1;
>  
>  		/*
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 990ee339a05f..42e4bbaa299a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1788,7 +1788,8 @@ static void setup_msrs(struct vcpu_vmx *vmx)
>  	if (update_transition_efer(vmx))
>  		vmx_setup_uret_msr(vmx, MSR_EFER);
>  
> -	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
> +	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)  ||
> +	    guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID))
>  		vmx_setup_uret_msr(vmx, MSR_TSC_AUX);
>  
>  	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL);
> @@ -1994,7 +1995,8 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		break;
>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
>  			return 1;
>  		goto find_uret_msr;
>  	case MSR_IA32_DEBUGCTLMSR:
> @@ -2314,7 +2316,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		break;
>  	case MSR_TSC_AUX:
>  		if (!msr_info->host_initiated &&
> -		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
>  			return 1;
>  		/* Check reserved bit, higher 32 bits should be zero */
>  		if ((data >> 32) != 0)
> @@ -4368,7 +4371,23 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  						  xsaves_enabled, false);
>  	}
>  
> -	vmx_adjust_sec_exec_feature(vmx, &exec_control, rdtscp, RDTSCP);
> +	/*
> +	 * RDPID is also gated by ENABLE_RDTSCP, turn on the control if either
> +	 * feature is exposed to the guest.  This creates a virtualization hole
> +	 * if both are supported in hardware but only one is exposed to the
> +	 * guest, but letting the guest execute RDTSCP or RDPID when either one
> +	 * is advertised is preferable to emulating the advertised instruction
> +	 * in KVM on #UD, and obviously better than incorrectly injecting #UD.
> +	 */
> +	if (cpu_has_vmx_rdtscp()) {
> +		bool rdpid_or_rdtscp_enabled =
> +			guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
> +			guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
> +
> +		vmx_adjust_secondary_exec_control(vmx, &exec_control,
> +						  SECONDARY_EXEC_ENABLE_RDTSCP,
> +						  rdpid_or_rdtscp_enabled, false);
> +	}
>  	vmx_adjust_sec_exec_feature(vmx, &exec_control, invpcid, INVPCID);
>  
>  	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdrand, RDRAND);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e304447be42d..b4516d303413 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5978,7 +5978,8 @@ static void kvm_init_msr_list(void)
>  				continue;
>  			break;
>  		case MSR_TSC_AUX:
> -			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
> +			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP) &&
> +			    !kvm_cpu_cap_has(X86_FEATURE_RDPID))
>  				continue;
>  			break;
>  		case MSR_IA32_UMWAIT_CONTROL:

Reviewed-by : Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


