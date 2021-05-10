Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D8D378FFE
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241144AbhEJN6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 09:58:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30051 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243615AbhEJNzH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620654841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6P2i+RhM1OYPYHwpadlC5bT+w+LT/aqVEDcPTboBbfQ=;
        b=fqyleGnoLgDdaMoEq1WeK7PaXIhx8nwnbhDwp3et8mC+QVaF3MUSCjDZyV8h5I7SLMK9CQ
        F7eew8LruPbFOrvlgjWnkndWLjquOWquwSSACm+aR3VfyVR7x8YdXUaV1MCGYlgVAdnUEq
        jkeQxEvWesZbo50T1Ly4jUO9kkNzjvY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-Vl-6a3k3MyuUdJ9K6a0k1A-1; Mon, 10 May 2021 09:53:59 -0400
X-MC-Unique: Vl-6a3k3MyuUdJ9K6a0k1A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3B21A34854;
        Mon, 10 May 2021 13:53:43 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 895C71045E8D;
        Mon, 10 May 2021 13:53:39 +0000 (UTC)
Message-ID: <4bb959a084e7acc4043f683888b9660f1a4a3fd7.camel@redhat.com>
Subject: Re: [PATCH 4/8] KVM: VMX: Adjust the TSC-related VMCS fields on L2
 entry and exit
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     ilstam@mailbox.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Date:   Mon, 10 May 2021 16:53:38 +0300
In-Reply-To: <20210506103228.67864-5-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-5-ilstam@mailbox.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-06 at 10:32 +0000, ilstam@mailbox.org wrote:
> From: Ilias Stamatis <ilstam@amazon.com>
> 
> When L2 is entered we need to "merge" the TSC multiplier and TSC offset
> values of VMCS01 and VMCS12 and store the result into the current
> VMCS02.
> 
> The 02 values are calculated using the following equations:
>   offset_02 = ((offset_01 * mult_12) >> 48) + offset_12
>   mult_02 = (mult_01 * mult_12) >> 48

I would mention that 48 is kvm_tsc_scaling_ratio_frac_bits instead.
Also maybe add the common code in a separate patch?

> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/vmx/nested.c       | 26 ++++++++++++++++++++++----
>  arch/x86/kvm/x86.c              | 25 +++++++++++++++++++++++++
>  3 files changed, 48 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cdddbf0b1177..e7a1eb36f95a 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1780,6 +1780,7 @@ void kvm_define_user_return_msr(unsigned index, u32 msr);
>  int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
>  
>  u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, bool l1);
> +u64 kvm_compute_02_tsc_offset(u64 l1_offset, u64 l2_multiplier, u64 l2_offset);
>  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
>  
>  unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index bced76637823..a1bf28f33837 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3353,8 +3353,22 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
>  	}
>  
>  	enter_guest_mode(vcpu);
> -	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
> -		vcpu->arch.tsc_offset += vmcs12->tsc_offset;
> +
> +	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING) {
> +		if (vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING) {
> +			vcpu->arch.tsc_offset = kvm_compute_02_tsc_offset(
> +					vcpu->arch.l1_tsc_offset,
> +					vmcs12->tsc_multiplier,
> +					vmcs12->tsc_offset);
> +
> +			vcpu->arch.tsc_scaling_ratio = mul_u64_u64_shr(
> +					vcpu->arch.tsc_scaling_ratio,
> +					vmcs12->tsc_multiplier,
> +					kvm_tsc_scaling_ratio_frac_bits);
> +		} else {
> +			vcpu->arch.tsc_offset += vmcs12->tsc_offset;
> +		}
> +	}
>  
>  	if (prepare_vmcs02(vcpu, vmcs12, &entry_failure_code)) {
>  		exit_reason.basic = EXIT_REASON_INVALID_STATE;
> @@ -4454,8 +4468,12 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
>  	if (nested_cpu_has_preemption_timer(vmcs12))
>  		hrtimer_cancel(&to_vmx(vcpu)->nested.preemption_timer);
>  
> -	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING)
> -		vcpu->arch.tsc_offset -= vmcs12->tsc_offset;
> +	if (vmcs12->cpu_based_vm_exec_control & CPU_BASED_USE_TSC_OFFSETTING) {
> +		vcpu->arch.tsc_offset = vcpu->arch.l1_tsc_offset;
> +
> +		if (vmcs12->secondary_vm_exec_control & SECONDARY_EXEC_TSC_SCALING)
> +			vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
> +	}
>  
>  	if (likely(!vmx->fail)) {
>  		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 26a4c0f46f15..87deb119c521 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2266,6 +2266,31 @@ static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
>  	return target_tsc - tsc;
>  }
>  
> +/*
> + * This function computes the TSC offset that is stored in VMCS02 when entering
> + * L2 by combining the offset and multiplier values of VMCS01 and VMCS12.
> + */
> +u64 kvm_compute_02_tsc_offset(u64 l1_offset, u64 l2_multiplier, u64 l2_offset)
> +{
> +	u64 offset;
> +
> +	/*
> +	 * The L1 offset is interpreted as a signed number by the CPU and can
> +	 * be negative. So we extract the sign before the multiplication and
> +	 * put it back afterwards if needed.
If I understand correctly the reason for sign extraction is that we don't
have mul_s64_u64_shr. Maybe we should add it?

The pattern of (A * B) >> shift appears many times in TSC scaling.

So instead of this function maybe just use something like that?

merged_offset = l2_offset + mul_s64_u64_shr ((s64) l1_offset, 
                                             l2_multiplier, 
                                             kvm_tsc_scaling_ratio_frac_bits)

Or another idea:

How about

u64 __kvm_scale_tsc_value(u64 value, u64 multiplier) {
	return mul_u64_u64_shr(value, 
			       multiplier, 
			       kvm_tsc_scaling_ratio_frac_bits);
}


and

s64 __kvm_scale_tsc_offset(u64 value, u64 multiplier)
{
	return mul_s64_u64_shr((s64)value,
			       multiplier, 
			       kvm_tsc_scaling_ratio_frac_bits);
}

And then use them in the code.

Overall though the code *looks* correct to me
but I might have missed something.

Best regards,
	Maxim Levitsky


> +	 */
> +	offset = mul_u64_u64_shr(abs((s64) l1_offset),
> +				 l2_multiplier,
> +				 kvm_tsc_scaling_ratio_frac_bits);
> +
> +	if ((s64) l1_offset < 0)
> +		offset = -((s64) offset);
> +
> +	offset += l2_offset;
> +	return offset;
> +}
> +EXPORT_SYMBOL_GPL(kvm_compute_02_tsc_offset);
> +
>  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
>  {
>  	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc(vcpu, host_tsc, true);


