Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801E9378FFB
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243695AbhEJN6Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 09:58:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50215 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242904AbhEJNxn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:53:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620654756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MI2ab/xAbkhNhihdYpcXn68AJNeUWNudE5P2Wmv4SFE=;
        b=Lz65gy5V0kk/QNGn0N5+Zr9OfzKsFXDusJTzPGBJ8atxvYJCE4nLDB8AGILnn3OrPMN7IX
        BHshOhFpNSwBOb2wstOLupOvPhDXNhq+kHQvQ7iyCMbdpzv8ipG4xgvED/QboOLAEk8c5d
        AZiQXTBbS7JRb54qwEVVsIIZImPpykY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-GZD_5SdBNfeqctXRgPn9cw-1; Mon, 10 May 2021 09:52:34 -0400
X-MC-Unique: GZD_5SdBNfeqctXRgPn9cw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2075106BB24;
        Mon, 10 May 2021 13:52:32 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D81F19C99;
        Mon, 10 May 2021 13:52:28 +0000 (UTC)
Message-ID: <b87ca34b3251f06c807e5d46bbf821756e57ff5b.camel@redhat.com>
Subject: Re: [PATCH 3/8] KVM: X86: Pass an additional 'L1' argument to
 kvm_scale_tsc()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     ilstam@mailbox.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Date:   Mon, 10 May 2021 16:52:27 +0300
In-Reply-To: <20210506103228.67864-4-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-4-ilstam@mailbox.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-06 at 10:32 +0000, ilstam@mailbox.org wrote:
> From: Ilias Stamatis <ilstam@amazon.com>
> 
> Sometimes kvm_scale_tsc() needs to use the current scaling ratio and
> other times (like when reading the TSC from user space) it needs to use
> L1's scaling ratio. Have the caller specify this by passing an
> additional boolean argument.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/x86.c              | 21 +++++++++++++--------
>  2 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 132e820525fb..cdddbf0b1177 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1779,7 +1779,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>  void kvm_define_user_return_msr(unsigned index, u32 msr);
>  int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
>  
> -u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
> +u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, bool l1);
>  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc);
>  
>  unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7bc5155ac6fd..26a4c0f46f15 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2241,10 +2241,14 @@ static inline u64 __scale_tsc(u64 ratio, u64 tsc)
>  	return mul_u64_u64_shr(tsc, ratio, kvm_tsc_scaling_ratio_frac_bits);
>  }
>  
> -u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc)
> +/*
> + * If l1 is true the TSC is scaled using L1's scaling ratio, otherwise
> + * the current scaling ratio is used.
> + */
> +u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc, bool l1)
>  {
>  	u64 _tsc = tsc;
> -	u64 ratio = vcpu->arch.tsc_scaling_ratio;
> +	u64 ratio = l1 ? vcpu->arch.l1_tsc_scaling_ratio : vcpu->arch.tsc_scaling_ratio;
>  
>  	if (ratio != kvm_default_tsc_scaling_ratio)
>  		_tsc = __scale_tsc(ratio, tsc);
I do wonder if it is better to have kvm_scale_tsc_l1 and kvm_scale_tsc instead for better
readablility?



> @@ -2257,14 +2261,14 @@ static u64 kvm_compute_tsc_offset(struct kvm_vcpu *vcpu, u64 target_tsc)
>  {
>  	u64 tsc;
>  
> -	tsc = kvm_scale_tsc(vcpu, rdtsc());
> +	tsc = kvm_scale_tsc(vcpu, rdtsc(), true);
Here we have a somewhat dangerous assumption that this function 
will always be used with L1 tsc values. 

The kvm_compute_tsc_offset should at least be renamed to
kvm_compute_tsc_offset_l1 or something like that.

Currently the assumption holds though:

We call the kvm_compute_tsc_offset in:

-> kvm_synchronize_tsc which is nowadays thankfully only called
on TSC writes from qemu, which are assumed to be L1 values.

(this is pending a rework of the whole thing which I started
some time ago but haven't had a chance to finish it yet)

-> Guest write of MSR_IA32_TSC. The value written is in L1 units,
since TSC offset/scaling only covers RDTSC and RDMSR of the IA32_TSC,
while WRMSR should be intercepted by L1 and emulated.
If it is not emulated, then L2 would just write L1 value.

-> in kvm_arch_vcpu_load, when TSC is unstable, we always try to resume
the guest from the same TSC value as it had seen last time,
and then catchup.

Also host TSC values are used, and after reading this function,
I recommend to rename the vcpu->arch.last_guest_tsc
to vcpu->arch.last_guest_tsc_l1 to document this.


>  
>  	return target_tsc - tsc;
>  }
>  
>  u64 kvm_read_l1_tsc(struct kvm_vcpu *vcpu, u64 host_tsc)
>  {
> -	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc(vcpu, host_tsc);
> +	return vcpu->arch.l1_tsc_offset + kvm_scale_tsc(vcpu, host_tsc, true);
OK
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_l1_tsc);
>  
> @@ -2395,9 +2399,9 @@ static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,
>  
>  static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
>  {
> -	if (vcpu->arch.tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
> +	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
>  		WARN_ON(adjustment < 0);
This should belong to patch 2 IMHO.

> -	adjustment = kvm_scale_tsc(vcpu, (u64) adjustment);
> +	adjustment = kvm_scale_tsc(vcpu, (u64) adjustment, true);
OK
>  	adjust_tsc_offset_guest(vcpu, adjustment);
>  }
>  
> @@ -2780,7 +2784,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	/* With all the info we got, fill in the values */
>  
>  	if (kvm_has_tsc_control)
> -		tgt_tsc_khz = kvm_scale_tsc(v, tgt_tsc_khz);
> +		tgt_tsc_khz = kvm_scale_tsc(v, tgt_tsc_khz, true);
OK (kvmclock is for L1 only, L1 hypervisor is free to expose its own kvmclock to L2)
>  
>  	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
>  		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
> @@ -3474,7 +3478,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		u64 tsc_offset = msr_info->host_initiated ? vcpu->arch.l1_tsc_offset :
>  							    vcpu->arch.tsc_offset;
>  
> -		msr_info->data = kvm_scale_tsc(vcpu, rdtsc()) + tsc_offset;
> +		msr_info->data = kvm_scale_tsc(vcpu, rdtsc(),
> +					       msr_info->host_initiated) + tsc_offset;

Since we now do two things that depend on msr_info->host_initiated, I 
think I would prefer to convert this back to regular 'if'.
I don't have a strong opinion on this though.


>  		break;
>  	}
>  	case MSR_MTRRcap:


Best regards,
	Maxim Levitsky


