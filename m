Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF1D377DF7
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhEJIVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:21:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23632 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230049AbhEJIVh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:21:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620634832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HfUuHKSBBdFn+jdFhIQV1RKcbYBM+dU846Gqym8cI/M=;
        b=gXy5E7H+n48F54l1MplVXtRKhzdJxx7wFLITcHtF7lnCp7ip+eBJJr+pV1eH6EWxB8otly
        N/Vpp1wYhjjnJTCPsjyoff6hGLJx9eoer2jXWjAPJM7FZsSjQjlozrxqEHguwwvrgZvGFU
        l/HDlM8xyEaqtFWK2VHoX6e4S4XnlIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-F2PMQ6YTNIGGSrih2GUaMw-1; Mon, 10 May 2021 04:20:31 -0400
X-MC-Unique: F2PMQ6YTNIGGSrih2GUaMw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 749C8107ACCD;
        Mon, 10 May 2021 08:20:29 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D4AE1037F2C;
        Mon, 10 May 2021 08:20:26 +0000 (UTC)
Message-ID: <a2f50fdadff9d51aab38c633f230c80914d80d33.camel@redhat.com>
Subject: Re: [PATCH 06/15] KVM: SVM: Probe and load MSR_TSC_AUX regardless
 of RDTSCP support in host
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:20:25 +0300
In-Reply-To: <20210504171734.1434054-7-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-7-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Probe MSR_TSC_AUX whether or not RDTSCP is supported in the host, and
> if probing succeeds, load the guest's MSR_TSC_AUX into hardware prior to
> VMRUN.  Because SVM doesn't support interception of RDPID, RDPID cannot
> be disallowed in the guest (without resorting to binary translation).
> Leaving the host's MSR_TSC_AUX in hardware would leak the host's value to
> the guest if RDTSCP is not supported.
> 
> Note, there is also a kernel bug that prevents leaking the host's value.
> The host kernel initializes MSR_TSC_AUX if and only if RDTSCP is
> supported, even though the vDSO usage consumes MSR_TSC_AUX via RDPID.
> I.e. if RDTSCP is not supported, there is no host value to leak.  But,
> if/when the host kernel bug is fixed, KVM would start leaking MSR_TSC_AUX
> in the case where hardware supports RDPID but RDTSCP is unavailable for
> whatever reason.
> 
> Probing MSR_TSC_AUX will also allow consolidating the probe and define
> logic in common x86, and will make it simpler to condition the existence
> of MSR_TSX_AUX (from the guest's perspective) on RDTSCP *or* RDPID.
> 
> Fixes: AMD CPUs
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8f2b184270c0..b3153d40cc4d 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -212,7 +212,7 @@ DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
>   * RDTSCP and RDPID are not used in the kernel, specifically to allow KVM to
>   * defer the restoration of TSC_AUX until the CPU returns to userspace.
>   */
> -#define TSC_AUX_URET_SLOT	0
> +static int tsc_aux_uret_slot __read_mostly = -1;
>  
>  static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
>  
> @@ -959,8 +959,10 @@ static __init int svm_hardware_setup(void)
>  		kvm_tsc_scaling_ratio_frac_bits = 32;
>  	}
>  
> -	if (boot_cpu_has(X86_FEATURE_RDTSCP))
> -		kvm_define_user_return_msr(TSC_AUX_URET_SLOT, MSR_TSC_AUX);
> +	if (!kvm_probe_user_return_msr(MSR_TSC_AUX)) {
> +		tsc_aux_uret_slot = 0;
> +		kvm_define_user_return_msr(tsc_aux_uret_slot, MSR_TSC_AUX);
> +	}
>  
>  	/* Check for pause filtering support */
>  	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
> @@ -1454,8 +1456,8 @@ static void svm_prepare_guest_switch(struct kvm_vcpu *vcpu)
>  		}
>  	}
>  
> -	if (static_cpu_has(X86_FEATURE_RDTSCP))
> -		kvm_set_user_return_msr(TSC_AUX_URET_SLOT, svm->tsc_aux, -1ull);
> +	if (likely(tsc_aux_uret_slot >= 0))
> +		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
>  
>  	svm->guest_state_loaded = true;
>  }
> @@ -2664,7 +2666,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			msr_info->data |= (u64)svm->sysenter_esp_hi << 32;
>  		break;
>  	case MSR_TSC_AUX:
> -		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
> +		if (tsc_aux_uret_slot < 0)
>  			return 1;
>  		if (!msr_info->host_initiated &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> @@ -2885,7 +2887,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		svm->sysenter_esp_hi = guest_cpuid_is_intel(vcpu) ? (data >> 32) : 0;
>  		break;
>  	case MSR_TSC_AUX:
> -		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
> +		if (tsc_aux_uret_slot < 0)
>  			return 1;
>  
>  		if (!msr->host_initiated &&
> @@ -2908,7 +2910,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		 * guest via direct_access_msrs, and switch it via user return.
>  		 */
>  		preempt_disable();
> -		r = kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
> +		r = kvm_set_user_return_msr(tsc_aux_uret_slot, data, -1ull);
>  		preempt_enable();
>  		if (r)
>  			return 1;

If L1 has ignore_msrs=1, then we will end up writing the IA32_TSC_AUX for nothing,
but this shouldn't be that of a big deal, so:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


