Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22D618F424
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 13:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgCWMM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 08:12:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:20994 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727401AbgCWMMz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 08:12:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584965573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5qx8zhPCnTE2qfI2i3stQlj2dT0PZ4HXDVQ2fRtvOJ8=;
        b=JwVoPvTxqyu9A8bEcRMf+mDNzp8Y/9MlPf6hhHpPj7+5DAoe+sV7gQYekTKvs4Z3E4DDmL
        joQUTNrAcbWiEysfNVzMKoo74nonRRr5zq7Y14ON2wS0SwBuC1UB0AzgNInZ5txAGnlGVv
        eN0JfW7HCiTB9HCUjevZYSAEVsy1HmA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-AHSDKD0XNiiBY46MRJTEzg-1; Mon, 23 Mar 2020 08:12:51 -0400
X-MC-Unique: AHSDKD0XNiiBY46MRJTEzg-1
Received: by mail-wm1-f70.google.com with SMTP id t22so464580wmt.4
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 05:12:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5qx8zhPCnTE2qfI2i3stQlj2dT0PZ4HXDVQ2fRtvOJ8=;
        b=r2+Fp5KH6AB6UK8dYshRXn91f9Nm5yhU5XA5O3s9TsIr+CL8y5chrCIGcqLlAZjYIA
         gwsAgF8y6f4Wm3ZUtAhMX3f4NMYHqvOK8qqSFH5Zb/D049GnllOw+1JE8iRoRlXcSiNv
         MSFiEoBD45GTf6i+VWnkCXgUoyCZK+zt6qp21YOyVgLy0mjR8oVq+TGcTrcyE1UW1/Hq
         QOJIpzb6DW3f2u0Fd3PW9XlmCfW6yXsNAS0X9UzdJpRzbfURT4wG6qlDbEpCQs3DhPG5
         mqFktm/pIOwF4a8WMPc9GcnFmgSfVe4+obj39Z8N4azBu6BQRRdaIQyRwE024pWdXgAE
         O3Mg==
X-Gm-Message-State: ANhLgQ3Uk1jKhcWSgYjRS/v1RsY/OLO5R6cyd96W8ofuAi4ltHTEPRz6
        Cnt4aD2dKog+3xgdDS1MMSdG5XuGnV/zwgBuVa8qjS2lx/SIUuQ7Y370ea2JePzF3K1aYJsSUqn
        yFFA9EVT5Kztm
X-Received: by 2002:a1c:7dc8:: with SMTP id y191mr26149370wmc.167.1584965570414;
        Mon, 23 Mar 2020 05:12:50 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvxdntzGTAq5lGTsloo1YunEi0RacH3kYz7CeYUhon5iCYkq0bwrHPPjatnROv0Mk0H2zrWhQ==
X-Received: by 2002:a1c:7dc8:: with SMTP id y191mr26149348wmc.167.1584965570127;
        Mon, 23 Mar 2020 05:12:50 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id p16sm20678671wmi.40.2020.03.23.05.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 05:12:49 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/9] KVM: VMX: Move hardware_setup() definition below vmx_x86_ops
In-Reply-To: <20200321202603.19355-4-sean.j.christopherson@intel.com>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com> <20200321202603.19355-4-sean.j.christopherson@intel.com>
Date:   Mon, 23 Mar 2020 13:12:47 +0100
Message-ID: <87imiv9sn4.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move VMX's hardware_setup() below its vmx_x86_ops definition so that a
> future patch can refactor hardware_setup() to modify vmx_x86_ops
> directly instead of indirectly modifying the ops via the global
> kvm_x86_ops.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 346 ++++++++++++++++++++---------------------
>  1 file changed, 173 insertions(+), 173 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ffcdcc86f5b7..82dab775d520 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7652,179 +7652,6 @@ static bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
>  	return to_vmx(vcpu)->nested.vmxon;
>  }
>  
> -static __init int hardware_setup(void)
> -{
> -	unsigned long host_bndcfgs;
> -	struct desc_ptr dt;
> -	int r, i, ept_lpage_level;
> -
> -	store_idt(&dt);
> -	host_idt_base = dt.address;
> -
> -	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i)
> -		kvm_define_shared_msr(i, vmx_msr_index[i]);
> -
> -	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
> -		return -EIO;
> -
> -	if (boot_cpu_has(X86_FEATURE_NX))
> -		kvm_enable_efer_bits(EFER_NX);
> -
> -	if (boot_cpu_has(X86_FEATURE_MPX)) {
> -		rdmsrl(MSR_IA32_BNDCFGS, host_bndcfgs);
> -		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
> -	}
> -
> -	if (!cpu_has_vmx_mpx())
> -		supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
> -				    XFEATURE_MASK_BNDCSR);
> -
> -	if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
> -	    !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
> -		enable_vpid = 0;
> -
> -	if (!cpu_has_vmx_ept() ||
> -	    !cpu_has_vmx_ept_4levels() ||
> -	    !cpu_has_vmx_ept_mt_wb() ||
> -	    !cpu_has_vmx_invept_global())
> -		enable_ept = 0;
> -
> -	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
> -		enable_ept_ad_bits = 0;
> -
> -	if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
> -		enable_unrestricted_guest = 0;
> -
> -	if (!cpu_has_vmx_flexpriority())
> -		flexpriority_enabled = 0;
> -
> -	if (!cpu_has_virtual_nmis())
> -		enable_vnmi = 0;
> -
> -	/*
> -	 * set_apic_access_page_addr() is used to reload apic access
> -	 * page upon invalidation.  No need to do anything if not
> -	 * using the APIC_ACCESS_ADDR VMCS field.
> -	 */
> -	if (!flexpriority_enabled)
> -		kvm_x86_ops->set_apic_access_page_addr = NULL;
> -
> -	if (!cpu_has_vmx_tpr_shadow())
> -		kvm_x86_ops->update_cr8_intercept = NULL;
> -
> -#if IS_ENABLED(CONFIG_HYPERV)
> -	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
> -	    && enable_ept) {
> -		kvm_x86_ops->tlb_remote_flush = hv_remote_flush_tlb;
> -		kvm_x86_ops->tlb_remote_flush_with_range =
> -				hv_remote_flush_tlb_with_range;
> -	}
> -#endif
> -
> -	if (!cpu_has_vmx_ple()) {
> -		ple_gap = 0;
> -		ple_window = 0;
> -		ple_window_grow = 0;
> -		ple_window_max = 0;
> -		ple_window_shrink = 0;
> -	}
> -
> -	if (!cpu_has_vmx_apicv()) {
> -		enable_apicv = 0;
> -		kvm_x86_ops->sync_pir_to_irr = NULL;
> -	}
> -
> -	if (cpu_has_vmx_tsc_scaling()) {
> -		kvm_has_tsc_control = true;
> -		kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
> -		kvm_tsc_scaling_ratio_frac_bits = 48;
> -	}
> -
> -	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
> -
> -	if (enable_ept)
> -		vmx_enable_tdp();
> -
> -	if (!enable_ept)
> -		ept_lpage_level = 0;
> -	else if (cpu_has_vmx_ept_1g_page())
> -		ept_lpage_level = PT_PDPE_LEVEL;
> -	else if (cpu_has_vmx_ept_2m_page())
> -		ept_lpage_level = PT_DIRECTORY_LEVEL;
> -	else
> -		ept_lpage_level = PT_PAGE_TABLE_LEVEL;
> -	kvm_configure_mmu(enable_ept, ept_lpage_level);
> -
> -	/*
> -	 * Only enable PML when hardware supports PML feature, and both EPT
> -	 * and EPT A/D bit features are enabled -- PML depends on them to work.
> -	 */
> -	if (!enable_ept || !enable_ept_ad_bits || !cpu_has_vmx_pml())
> -		enable_pml = 0;
> -
> -	if (!enable_pml) {
> -		kvm_x86_ops->slot_enable_log_dirty = NULL;
> -		kvm_x86_ops->slot_disable_log_dirty = NULL;
> -		kvm_x86_ops->flush_log_dirty = NULL;
> -		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
> -	}
> -
> -	if (!cpu_has_vmx_preemption_timer())
> -		enable_preemption_timer = false;
> -
> -	if (enable_preemption_timer) {
> -		u64 use_timer_freq = 5000ULL * 1000 * 1000;
> -		u64 vmx_msr;
> -
> -		rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
> -		cpu_preemption_timer_multi =
> -			vmx_msr & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
> -
> -		if (tsc_khz)
> -			use_timer_freq = (u64)tsc_khz * 1000;
> -		use_timer_freq >>= cpu_preemption_timer_multi;
> -
> -		/*
> -		 * KVM "disables" the preemption timer by setting it to its max
> -		 * value.  Don't use the timer if it might cause spurious exits
> -		 * at a rate faster than 0.1 Hz (of uninterrupted guest time).
> -		 */
> -		if (use_timer_freq > 0xffffffffu / 10)
> -			enable_preemption_timer = false;
> -	}
> -
> -	if (!enable_preemption_timer) {
> -		kvm_x86_ops->set_hv_timer = NULL;
> -		kvm_x86_ops->cancel_hv_timer = NULL;
> -		kvm_x86_ops->request_immediate_exit = __kvm_request_immediate_exit;
> -	}
> -
> -	kvm_set_posted_intr_wakeup_handler(wakeup_handler);
> -
> -	kvm_mce_cap_supported |= MCG_LMCE_P;
> -
> -	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
> -		return -EINVAL;
> -	if (!enable_ept || !cpu_has_vmx_intel_pt())
> -		pt_mode = PT_MODE_SYSTEM;
> -
> -	if (nested) {
> -		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
> -					   vmx_capability.ept);
> -
> -		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
> -		if (r)
> -			return r;
> -	}
> -
> -	vmx_set_cpu_caps();
> -
> -	r = alloc_kvm_area();
> -	if (r)
> -		nested_vmx_hardware_unsetup();
> -	return r;
> -}
> -
>  static __exit void hardware_unsetup(void)
>  {
>  	if (nested)
> @@ -7978,6 +7805,179 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
>  	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
>  };
>  
> +static __init int hardware_setup(void)
> +{
> +	unsigned long host_bndcfgs;
> +	struct desc_ptr dt;
> +	int r, i, ept_lpage_level;
> +
> +	store_idt(&dt);
> +	host_idt_base = dt.address;
> +
> +	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i)
> +		kvm_define_shared_msr(i, vmx_msr_index[i]);
> +
> +	if (setup_vmcs_config(&vmcs_config, &vmx_capability) < 0)
> +		return -EIO;
> +
> +	if (boot_cpu_has(X86_FEATURE_NX))
> +		kvm_enable_efer_bits(EFER_NX);
> +
> +	if (boot_cpu_has(X86_FEATURE_MPX)) {
> +		rdmsrl(MSR_IA32_BNDCFGS, host_bndcfgs);
> +		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
> +	}
> +
> +	if (!cpu_has_vmx_mpx())
> +		supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
> +				    XFEATURE_MASK_BNDCSR);
> +
> +	if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
> +	    !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
> +		enable_vpid = 0;
> +
> +	if (!cpu_has_vmx_ept() ||
> +	    !cpu_has_vmx_ept_4levels() ||
> +	    !cpu_has_vmx_ept_mt_wb() ||
> +	    !cpu_has_vmx_invept_global())
> +		enable_ept = 0;
> +
> +	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
> +		enable_ept_ad_bits = 0;
> +
> +	if (!cpu_has_vmx_unrestricted_guest() || !enable_ept)
> +		enable_unrestricted_guest = 0;
> +
> +	if (!cpu_has_vmx_flexpriority())
> +		flexpriority_enabled = 0;
> +
> +	if (!cpu_has_virtual_nmis())
> +		enable_vnmi = 0;
> +
> +	/*
> +	 * set_apic_access_page_addr() is used to reload apic access
> +	 * page upon invalidation.  No need to do anything if not
> +	 * using the APIC_ACCESS_ADDR VMCS field.
> +	 */
> +	if (!flexpriority_enabled)
> +		kvm_x86_ops->set_apic_access_page_addr = NULL;
> +
> +	if (!cpu_has_vmx_tpr_shadow())
> +		kvm_x86_ops->update_cr8_intercept = NULL;
> +
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
> +	    && enable_ept) {
> +		kvm_x86_ops->tlb_remote_flush = hv_remote_flush_tlb;
> +		kvm_x86_ops->tlb_remote_flush_with_range =
> +				hv_remote_flush_tlb_with_range;
> +	}
> +#endif
> +
> +	if (!cpu_has_vmx_ple()) {
> +		ple_gap = 0;
> +		ple_window = 0;
> +		ple_window_grow = 0;
> +		ple_window_max = 0;
> +		ple_window_shrink = 0;
> +	}
> +
> +	if (!cpu_has_vmx_apicv()) {
> +		enable_apicv = 0;
> +		kvm_x86_ops->sync_pir_to_irr = NULL;
> +	}
> +
> +	if (cpu_has_vmx_tsc_scaling()) {
> +		kvm_has_tsc_control = true;
> +		kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
> +		kvm_tsc_scaling_ratio_frac_bits = 48;
> +	}
> +
> +	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
> +
> +	if (enable_ept)
> +		vmx_enable_tdp();
> +
> +	if (!enable_ept)
> +		ept_lpage_level = 0;
> +	else if (cpu_has_vmx_ept_1g_page())
> +		ept_lpage_level = PT_PDPE_LEVEL;
> +	else if (cpu_has_vmx_ept_2m_page())
> +		ept_lpage_level = PT_DIRECTORY_LEVEL;
> +	else
> +		ept_lpage_level = PT_PAGE_TABLE_LEVEL;
> +	kvm_configure_mmu(enable_ept, ept_lpage_level);
> +
> +	/*
> +	 * Only enable PML when hardware supports PML feature, and both EPT
> +	 * and EPT A/D bit features are enabled -- PML depends on them to work.
> +	 */
> +	if (!enable_ept || !enable_ept_ad_bits || !cpu_has_vmx_pml())
> +		enable_pml = 0;
> +
> +	if (!enable_pml) {
> +		kvm_x86_ops->slot_enable_log_dirty = NULL;
> +		kvm_x86_ops->slot_disable_log_dirty = NULL;
> +		kvm_x86_ops->flush_log_dirty = NULL;
> +		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
> +	}
> +
> +	if (!cpu_has_vmx_preemption_timer())
> +		enable_preemption_timer = false;
> +
> +	if (enable_preemption_timer) {
> +		u64 use_timer_freq = 5000ULL * 1000 * 1000;
> +		u64 vmx_msr;
> +
> +		rdmsrl(MSR_IA32_VMX_MISC, vmx_msr);
> +		cpu_preemption_timer_multi =
> +			vmx_msr & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
> +
> +		if (tsc_khz)
> +			use_timer_freq = (u64)tsc_khz * 1000;
> +		use_timer_freq >>= cpu_preemption_timer_multi;
> +
> +		/*
> +		 * KVM "disables" the preemption timer by setting it to its max
> +		 * value.  Don't use the timer if it might cause spurious exits
> +		 * at a rate faster than 0.1 Hz (of uninterrupted guest time).
> +		 */
> +		if (use_timer_freq > 0xffffffffu / 10)
> +			enable_preemption_timer = false;
> +	}
> +
> +	if (!enable_preemption_timer) {
> +		kvm_x86_ops->set_hv_timer = NULL;
> +		kvm_x86_ops->cancel_hv_timer = NULL;
> +		kvm_x86_ops->request_immediate_exit = __kvm_request_immediate_exit;
> +	}
> +
> +	kvm_set_posted_intr_wakeup_handler(wakeup_handler);
> +
> +	kvm_mce_cap_supported |= MCG_LMCE_P;
> +
> +	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
> +		return -EINVAL;
> +	if (!enable_ept || !cpu_has_vmx_intel_pt())
> +		pt_mode = PT_MODE_SYSTEM;
> +
> +	if (nested) {
> +		nested_vmx_setup_ctls_msrs(&vmcs_config.nested,
> +					   vmx_capability.ept);
> +
> +		r = nested_vmx_hardware_setup(kvm_vmx_exit_handlers);
> +		if (r)
> +			return r;
> +	}
> +
> +	vmx_set_cpu_caps();
> +
> +	r = alloc_kvm_area();
> +	if (r)
> +		nested_vmx_hardware_unsetup();
> +	return r;
> +}
> +
>  static struct kvm_x86_init_ops vmx_init_ops __initdata = {
>  	.cpu_has_kvm_support = cpu_has_kvm_support,
>  	.disabled_by_bios = vmx_disabled_by_bios,

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

