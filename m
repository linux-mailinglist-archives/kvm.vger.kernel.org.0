Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B504D377E2D
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 10:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhEJIaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 04:30:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230098AbhEJIaH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 04:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620635342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wLO002ZAEDwCPEMDUCoBTt5K/2IsD96rah29IFBQCrw=;
        b=jIPIMB1IP0yFj713Rs6gGCSHwGIqvEpXc9GQlUO299kugatSPiMIMHZfgPjNdZB+XamUYt
        iG8+EGGrwuRSbs6yJGSpnS3rK0pRXK7l+f5O0xC+3gQRUtExdzA9H2ma7wdBLDWzgKK7oh
        5UGiscuT/IVJP7WD6NF4pCVxPF7L/GM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-k6p99uKkPXChk1_Yembhcw-1; Mon, 10 May 2021 04:29:00 -0400
X-MC-Unique: k6p99uKkPXChk1_Yembhcw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B72A107ACCA;
        Mon, 10 May 2021 08:28:58 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87B395D9F2;
        Mon, 10 May 2021 08:28:55 +0000 (UTC)
Message-ID: <f3a4ae84a227d131540762c55d357c6d7f48ac48.camel@redhat.com>
Subject: Re: [PATCH 13/15] KVM: x86: Move uret MSR slot management to common
 x86
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Date:   Mon, 10 May 2021 11:28:54 +0300
In-Reply-To: <20210504171734.1434054-14-seanjc@google.com>
References: <20210504171734.1434054-1-seanjc@google.com>
         <20210504171734.1434054-14-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-04 at 10:17 -0700, Sean Christopherson wrote:
> Now that SVM and VMX both probe MSRs before "defining" user return slots
> for them, consolidate the code for probe+define into common x86 and
> eliminate the odd behavior of having the vendor code define the slot for
> a given MSR.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +--
>  arch/x86/kvm/svm/svm.c          |  5 +----
>  arch/x86/kvm/vmx/vmx.c          | 19 ++++---------------
>  arch/x86/kvm/x86.c              | 19 +++++++++++--------
>  4 files changed, 17 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 10663610f105..a4b912f7e427 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1778,9 +1778,8 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
>  		    unsigned long ipi_bitmap_high, u32 min,
>  		    unsigned long icr, int op_64_bit);
>  
> -void kvm_define_user_return_msr(unsigned index, u32 msr);
> +int kvm_add_user_return_msr(u32 msr);
>  int kvm_find_user_return_msr(u32 msr);
> -int kvm_probe_user_return_msr(u32 msr);
>  int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
>  
>  u64 kvm_scale_tsc(struct kvm_vcpu *vcpu, u64 tsc);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 231b9650d864..de921935e8de 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -959,10 +959,7 @@ static __init int svm_hardware_setup(void)
>  		kvm_tsc_scaling_ratio_frac_bits = 32;
>  	}
>  
> -	if (!kvm_probe_user_return_msr(MSR_TSC_AUX)) {
> -		tsc_aux_uret_slot = 0;
> -		kvm_define_user_return_msr(tsc_aux_uret_slot, MSR_TSC_AUX);
> -	}
> +	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
>  
>  	/* Check for pause filtering support */
>  	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7a53568b34fc..26f82f302391 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -454,9 +454,6 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
>  
>  static unsigned long host_idt_base;
>  
> -/* Number of user return MSRs that are actually supported in hardware. */
> -static int vmx_nr_uret_msrs;
> -
>  #if IS_ENABLED(CONFIG_HYPERV)
>  static bool __read_mostly enlightened_vmcs = true;
>  module_param(enlightened_vmcs, bool, 0444);
> @@ -1218,7 +1215,7 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  	 */
>  	if (!vmx->guest_uret_msrs_loaded) {
>  		vmx->guest_uret_msrs_loaded = true;
> -		for (i = 0; i < vmx_nr_uret_msrs; ++i) {
> +		for (i = 0; i < kvm_nr_uret_msrs; ++i) {
>  			if (!vmx->guest_uret_msrs[i].load_into_hardware)
>  				continue;
>  
> @@ -6921,7 +6918,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  			goto free_vpid;
>  	}
>  
> -	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
> +	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
>  		vmx->guest_uret_msrs[i].data = 0;
>  		vmx->guest_uret_msrs[i].mask = -1ull;
>  	}
> @@ -7810,20 +7807,12 @@ static __init void vmx_setup_user_return_msrs(void)
>  		MSR_EFER, MSR_TSC_AUX, MSR_STAR,
>  		MSR_IA32_TSX_CTRL,
>  	};
> -	u32 msr;
>  	int i;
>  
>  	BUILD_BUG_ON(ARRAY_SIZE(vmx_uret_msrs_list) != MAX_NR_USER_RETURN_MSRS);
>  
> -	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i) {
> -		msr = vmx_uret_msrs_list[i];
> -
> -		if (kvm_probe_user_return_msr(msr))
> -			continue;
> -
> -		kvm_define_user_return_msr(vmx_nr_uret_msrs, msr);
> -		vmx_nr_uret_msrs++;
> -	}
> +	for (i = 0; i < ARRAY_SIZE(vmx_uret_msrs_list); ++i)
> +		kvm_add_user_return_msr(vmx_uret_msrs_list[i]);
>  }
>  
>  static __init int hardware_setup(void)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2fd46e917666..adca491d3b4b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -336,7 +336,7 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
>  	}
>  }
>  
> -int kvm_probe_user_return_msr(u32 msr)
> +static int kvm_probe_user_return_msr(u32 msr)
>  {
>  	u64 val;
>  	int ret;
> @@ -350,16 +350,18 @@ int kvm_probe_user_return_msr(u32 msr)
>  	preempt_enable();
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(kvm_probe_user_return_msr);
>  
> -void kvm_define_user_return_msr(unsigned slot, u32 msr)
> +int kvm_add_user_return_msr(u32 msr)
>  {
> -	BUG_ON(slot >= KVM_MAX_NR_USER_RETURN_MSRS);
> -	kvm_uret_msrs_list[slot] = msr;
> -	if (slot >= kvm_nr_uret_msrs)
> -		kvm_nr_uret_msrs = slot + 1;
> +	BUG_ON(kvm_nr_uret_msrs >= KVM_MAX_NR_USER_RETURN_MSRS);
> +
> +	if (kvm_probe_user_return_msr(msr))
> +		return -1;
> +
> +	kvm_uret_msrs_list[kvm_nr_uret_msrs] = msr;
> +	return kvm_nr_uret_msrs++;
>  }
> -EXPORT_SYMBOL_GPL(kvm_define_user_return_msr);
> +EXPORT_SYMBOL_GPL(kvm_add_user_return_msr);
>  
>  int kvm_find_user_return_msr(u32 msr)
>  {
> @@ -8169,6 +8171,7 @@ int kvm_arch_init(void *opaque)
>  		printk(KERN_ERR "kvm: failed to allocate percpu kvm_user_return_msrs\n");
>  		goto out_free_x86_emulator_cache;
>  	}
> +	kvm_nr_uret_msrs = 0;
>  
>  	r = kvm_mmu_module_init();
>  	if (r)
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky




