Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7A038F29F
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhEXR4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:56:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46066 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233660AbhEXR4V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 13:56:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621878893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pprdheKjoLQ3SalBsgMHJmlILNR7iozORggHAFAxdsI=;
        b=GKAlaiRLRDE5s+nBJOEsOnYltmoHHZSnCIX9DydGTjPZstrLzdSas4sTnM+iR2X3vUPiYR
        uVGkD1rDS0l9xFqLhBRg+BVIGDBPTwF8B6CWXJBGrQ2tRH8weji0gUEMjtk0/sc1gwweUk
        wh+UATNa+ct++jcQ597q596FF5qhvpE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-u5gQSUEeME6grBtlGdY7wA-1; Mon, 24 May 2021 13:54:52 -0400
X-MC-Unique: u5gQSUEeME6grBtlGdY7wA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86DE7108C27B;
        Mon, 24 May 2021 17:54:50 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 368A21001281;
        Mon, 24 May 2021 17:54:46 +0000 (UTC)
Message-ID: <6d8da1e886ebb84ac5168f485148473dc2e2a0b4.camel@redhat.com>
Subject: Re: [PATCH v3 10/12] KVM: VMX: Set the TSC offset and multiplier on
 nested entry and exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, zamsden@gmail.com,
        mtosatti@redhat.com, dwmw@amazon.co.uk
Date:   Mon, 24 May 2021 20:54:45 +0300
In-Reply-To: <20210521102449.21505-11-ilstam@amazon.com>
References: <20210521102449.21505-1-ilstam@amazon.com>
         <20210521102449.21505-11-ilstam@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2021-05-21 at 11:24 +0100, Ilias Stamatis wrote:
> Calculate the nested TSC offset and multiplier on entering L2 using the
> corresponding functions. Restore the L1 values on L2's exit.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 239154d3e4e7..f75c4174cbcf 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2532,6 +2532,15 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
>  		vmcs_write64(GUEST_IA32_PAT, vmx->vcpu.arch.pat);
>  	}
>  
> +	vcpu->arch.tsc_offset = kvm_calc_nested_tsc_offset(
> +			vcpu->arch.l1_tsc_offset,
> +			vmx_get_l2_tsc_offset(vcpu),
> +			vmx_get_l2_tsc_multiplier(vcpu));
> +
> +	vcpu->arch.tsc_scaling_ratio = kvm_calc_nested_tsc_multiplier(
> +			vcpu->arch.l1_tsc_scaling_ratio,
> +			vmx_get_l2_tsc_multiplier(vcpu));
> +

This code can be in theory put to the common x86 code,
since it uses the vendor callbacks anyway, but this is
probably not worth it.

>  	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
>  	if (kvm_has_tsc_control)
>  		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);
> @@ -3353,8 +3362,6 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	}
>  
>  	enter_guest_mode(vcpu);
> -	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
> -		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
>  
>  	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
>  		exit_reason.basic = EXIT_REASON_INVALID_STATE;
> @@ -4462,8 +4469,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  	if (nested_cpu_has_preemption_timer(vmcs12))
>  		hrtimer_cancel(&to_vmx(vcpu)->nested.preemption_timer);
>  
> -	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
> -		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
> +	if (nested_cpu_has(vmcs12, CPU_BASED_USE_TSC_OFFSETTING)) {
> +		vcpu->arch.tsc_offset = vcpu->arch.l1_tsc_offset;
> +		if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_TSC_SCALING))
> +			vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
> +	}

Same here.
>  
>  	if (likely(!vmx->fail)) {
>  		sync_vmcs02_to_vmcs12(vcpu, vmcs12);


Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

