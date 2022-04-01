Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D823B4EE619
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 04:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244119AbiDACjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 22:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239801AbiDACju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 22:39:50 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFB125A485
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 19:38:01 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x31so1320837pfh.9
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 19:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y+NXBR7DWoBlJxEoGR+g1W+eIuKZVzZpKdbHii9zsjA=;
        b=dXVP+Ow//NhPpO4UQkGrjY6ldoxW+dSrWG3JnMvr8gz/P49CAJ723lwJjdYk2xqu2Z
         ni5KNWrbdip+WkAmQrIum6TESPTynDD3hLpJhVIiuZ55en0LYdmjyMqwJ1VHwAsJnU+z
         8w5Mq9ejOakEtI7+pZiQpXKiiBC2eKxwTWskzZ/HJA+nRcrx0UBwncfrcmrM4P02xABD
         G6lNzHe8dSwhdIXfu/TyfUtsFJvVDNJ6MJdY5JCMxafuhrmg5ue27Mm8vuVVmqi26E6w
         PgDhAGxF1qzu3PDKVB9JCNU9IYs65o3M3baR6HBvfOmgpnWog1dIt6KtulQwfZt31srx
         6o5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y+NXBR7DWoBlJxEoGR+g1W+eIuKZVzZpKdbHii9zsjA=;
        b=Id/G5EEqneRA5l2ncX9KsQULmuNskPtaQEQ0zMXSRIHQpYYyMe6j0baIqwFK5OxMgB
         ibFJux+uxucNzHdvJj5pVtufkGHkbjkIk9u2bE3w1gLzdW4nlOIl8+32y+jPhmr6mak+
         v2Pcf7ZOzXABmfRgV+Keezyx/6C/I9YZ6gmAUQPtrH4CWMXbNS49B/hUXWB+YxPw2HDA
         tzl22CP9lHNN2pdhWHwyqrKAM8q7DGawDKyQN9dW2Xkqpiq425+Uo/HffifMs4rdFeuq
         nUrDs4fENYwiy2P2wSasAxWJ0rku0M0XP8Z+foMxBVjdzdXw+Sg+z/GpB7ZaYjc/Hu09
         2sag==
X-Gm-Message-State: AOAM533ACMFjaBsJILKha7YEoFXhLIUks3MX4lkfje5e46F9Qif0BZsC
        X2jGs1NurpVBELdpOezPXZqYBw==
X-Google-Smtp-Source: ABdhPJyyszJaSjpuR6xq4ntVmas+108B6AJWPxGG2GR5VOyT5P7q8PXu1U0L5SfY4FxePGhBoHk+1w==
X-Received: by 2002:a62:cf82:0:b0:4fa:e33e:4225 with SMTP id b124-20020a62cf82000000b004fae33e4225mr8533445pfg.25.1648780680527;
        Thu, 31 Mar 2022 19:38:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 73-20020a62194c000000b004fab3b767ccsm841018pfz.216.2022.03.31.19.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 19:37:59 -0700 (PDT)
Date:   Fri, 1 Apr 2022 02:37:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH v7 8/8] KVM: VMX: enable IPI virtualization
Message-ID: <YkZlhI7nAAqDhT0D@google.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-9-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304080725.18135-9-guang.zeng@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022, Zeng Guang wrote:
> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
> index ff20776dc83b..7ce616af2db2 100644
> --- a/arch/x86/include/asm/vmxfeatures.h
> +++ b/arch/x86/include/asm/vmxfeatures.h
> @@ -86,4 +86,6 @@
>  #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
>  #define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* "" VM-Exit when bus lock caused */
>  
> +/* Tertiary Processor-Based VM-Execution Controls, word 3 */
> +#define VMX_FEATURE_IPI_VIRT		(3*32 +  4) /* "" Enable IPI virtualization */

Please follow the existing (weird) spacing and style.  And this should definitely
be enumerated to userspace, it's one of the more interesting VMX features, i.e. drop
the "".

#define VMX_FEATURE_IPI_VIRT		( 3*32+  4) /* Enable IPI virtualization */

>  #endif /* _ASM_X86_VMXFEATURES_H */
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 31f3d88b3e4d..5f656c9e33be 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -13,6 +13,7 @@ extern bool __read_mostly enable_ept;
>  extern bool __read_mostly enable_unrestricted_guest;
>  extern bool __read_mostly enable_ept_ad_bits;
>  extern bool __read_mostly enable_pml;
> +extern bool __read_mostly enable_ipiv;
>  extern int __read_mostly pt_mode;
>  
>  #define PT_MODE_SYSTEM		0
> @@ -283,6 +284,11 @@ static inline bool cpu_has_vmx_apicv(void)
>  		cpu_has_vmx_posted_intr();
>  }
>  
> +static inline bool cpu_has_vmx_ipiv(void)
> +{
> +	return vmcs_config.cpu_based_3rd_exec_ctrl & TERTIARY_EXEC_IPI_VIRT;
> +}
> +
>  static inline bool cpu_has_vmx_flexpriority(void)
>  {
>  	return cpu_has_vmx_tpr_shadow() &&
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index aa1fe9085d77..0882115a9b7a 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -177,11 +177,24 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>  	local_irq_restore(flags);
>  }
>  
> +static bool vmx_can_use_pi_wakeup(struct kvm *kvm)
> +{
> +	/*
> +	 * If a blocked vCPU can be the target of posted interrupts,
> +	 * switching notification vector is needed so that kernel can
> +	 * be informed when an interrupt is posted and get the chance
> +	 * to wake up the blocked vCPU. For now, using posted interrupt
> +	 * for vCPU wakeup when IPI virtualization or VT-d PI can be
> +	 * enabled.
> +	 */
> +	return vmx_can_use_ipiv(kvm) || vmx_can_use_vtd_pi(kvm);
> +}
> +
>  void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>  {
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  
> -	if (!vmx_can_use_vtd_pi(vcpu->kvm))
> +	if (!vmx_can_use_pi_wakeup(vcpu->kvm))
>  		return;
>  
>  	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7beba7a9f247..121d4f0b35b9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -105,6 +105,9 @@ module_param(fasteoi, bool, S_IRUGO);
>  
>  module_param(enable_apicv, bool, S_IRUGO);
>  
> +bool __read_mostly enable_ipiv = true;
> +module_param(enable_ipiv, bool, 0444);
> +
>  /*
>   * If nested=1, nested virtualization is supported, i.e., guests may use
>   * VMX and be a hypervisor for its own guests. If nested=0, guests may not
> @@ -227,6 +230,8 @@ static const struct {
>  };
>  
>  #define L1D_CACHE_ORDER 4
> +#define PID_TABLE_ENTRY_VALID 1

Put this in posted_intr.h to give the "PID" part some context.

diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 9a45d5c9f116..26992076552e 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -5,6 +5,8 @@
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1

+#define PID_TABLE_ENTRY_VALID 1
+
 /* Posted-Interrupt Descriptor */
 struct pi_desc {
        u32 pir[8];     /* Posted interrupt requested */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index bbdd77a0388f..6a757e31d1d1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -230,7 +230,6 @@ static const struct {
 };

 #define L1D_CACHE_ORDER 4
-#define PID_TABLE_ENTRY_VALID 1

 static void *vmx_l1d_flush_pages;

> +
>  static void *vmx_l1d_flush_pages;
>  
>  static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
> @@ -2543,7 +2548,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	}
>  
>  	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
> -		u64 opt3 = 0;
> +		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
>  		u64 min3 = 0;
>  
>  		if (adjust_vmx_controls_64(min3, opt3,
> @@ -3898,6 +3903,8 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu)
>  		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
>  		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
>  		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
> +		if (enable_ipiv)
> +			vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR),MSR_TYPE_RW);

Missing space after the last comma.

>  	}
>  }
>  
> @@ -4219,14 +4226,21 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  
>  	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
>  	if (cpu_has_secondary_exec_ctrls()) {
> -		if (kvm_vcpu_apicv_active(vcpu))
> +		if (kvm_vcpu_apicv_active(vcpu)) {
>  			secondary_exec_controls_setbit(vmx,
>  				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
>  				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> -		else
> +			if (enable_ipiv)
> +				tertiary_exec_controls_setbit(vmx,
> +						TERTIARY_EXEC_IPI_VIRT);
> +		} else {
>  			secondary_exec_controls_clearbit(vmx,
>  					SECONDARY_EXEC_APIC_REGISTER_VIRT |
>  					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> +			if (enable_ipiv)
> +				tertiary_exec_controls_clearbit(vmx,
> +						TERTIARY_EXEC_IPI_VIRT);

Oof.  The existing code is kludgy.  We should never reach this point without
enable_apicv=true, and enable_apicv should be forced off if APICv isn't supported,
let alone seconary exec being support.

Unless I'm missing something, throw a prep patch earlier in the series to drop
the cpu_has_secondary_exec_ctrls() check, that will clean this code up a smidge.

> +		}
>  	}
>  
>  	vmx_update_msr_bitmap_x2apic(vcpu);
> @@ -4260,7 +4274,16 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  
>  static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
>  {
> -	return vmcs_config.cpu_based_3rd_exec_ctrl;
> +	u64 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;
> +
> +	/*
> +	 * IPI virtualization relies on APICv. Disable IPI
> +	 * virtualization if APICv is inhibited.

Wrap comments at 80 chars.

> +	 */
> +	if (!enable_ipiv || !kvm_vcpu_apicv_active(&vmx->vcpu))
> +		exec_control &= ~TERTIARY_EXEC_IPI_VIRT;
> +
> +	return exec_control;
>  }
>  
>  /*
> @@ -4408,6 +4431,29 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
>  	return exec_control;
>  }
>  
> +static int vmx_alloc_pid_table(struct kvm_vmx *kvm_vmx)
> +{
> +	struct page *pages;
> +
> +	if(kvm_vmx->pid_table)

Needs a space after the "if".  Moot point though, this shouldn't exist.

> +		return 0;
> +
> +	pages = alloc_pages(GFP_KERNEL | __GFP_ZERO,
> +			get_order(kvm_vmx->kvm.arch.max_vcpu_id * sizeof(u64)));

Instead of sizeof(u64), do sizeof(*kvm_vmx->pid_table), that way the code is more
self documenting and less fragile.  The PID table size obviously shouldn't change
since it architecturally, but it's a good habit/style.

> +
> +	if (!pages)
> +		return -ENOMEM;
> +
> +	kvm_vmx->pid_table = (void *)page_address(pages);
> +	kvm_vmx->pid_last_index = kvm_vmx->kvm.arch.max_vcpu_id - 1;

No need to cache pid_last_index, it's only used in one place (initializing the
VMCS field).  The allocation/free paths can use max_vcpu_id directly.  Actually,
for the alloc/free, add a helper to provide the order, that'll clean up both
call sites and avoid duplicate math.  E.g.

int vmx_get_pid_table_order(struct kvm_vmx *kvm_vmx)
{
	return get_order(kvm_vmx->kvm.arch.max_vcpu_ids * sizeof(*kvm_vmx->pid_table));
}

> +	return 0;
> +}
> +
> +bool vmx_can_use_ipiv(struct kvm *kvm)
> +{
> +	return irqchip_in_kernel(kvm) && enable_ipiv;
> +}

Move this helper to posted_intr.h (or maybe vmx.h, though I think posted_intr.h
is a slightly better fit) and make it static inline.  This patch already exposes
enable_ipiv, and the usage in vmx_can_use_pi_wakeup() will be frequent enough
that making it inline is worthwhile.

> +
>  #define VMX_XSS_EXIT_BITMAP 0
>  
>  static void init_vmcs(struct vcpu_vmx *vmx)
> @@ -4443,6 +4489,13 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
>  	}
>  
> +	if (vmx_can_use_ipiv(vmx->vcpu.kvm)) {
> +		struct kvm_vmx *kvm_vmx = to_kvm_vmx(vmx->vcpu.kvm);

Hoist this to the top of the function, that way we don't end up with variable
shadowing and don't have to move it if future code also needs to access kvm_vmx.

> +
> +		vmcs_write64(PID_POINTER_TABLE, __pa(kvm_vmx->pid_table));
> +		vmcs_write16(LAST_PID_POINTER_INDEX, kvm_vmx->pid_last_index);
> +	}
> +
>  	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
>  		vmcs_write32(PLE_GAP, ple_gap);
>  		vmx->ple_window = ple_window;
> @@ -7123,6 +7176,22 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  			goto free_vmcs;
>  	}
>  
> +	/*
> +	 * Allocate PID-table and program this vCPU's PID-table
> +	 * entry if IPI virtualization can be enabled.

Please wrap comments at 80 chars.  But I'd just drop this one entirely, the code
is self-explanatory once the allocation and setting of the vCPU's entry are split.

> +	 */
> +	if (vmx_can_use_ipiv(vcpu->kvm)) {
> +		struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
> +
> +		mutex_lock(&vcpu->kvm->lock);
> +		err = vmx_alloc_pid_table(kvm_vmx);
> +		mutex_unlock(&vcpu->kvm->lock);

This belongs in vmx_vm_init(), doing it in vCPU creation is a remnant of the
dynamic resize approach that's no longer needed.

 
> +		if (err)
> +			goto free_vmcs;
> +		WRITE_ONCE(kvm_vmx->pid_table[vcpu->vcpu_id],
> +			__pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);

This gets to stay though.  Please align the indentation, i.e.


	if (vmx_can_use_ipiv(vcpu->kvm))
		WRITE_ONCE(to_kvm_vmx(vcpu->kvm)->pid_table[vcpu->vcpu_id],
			   __pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);

> +	}
> +
>  	return 0;
>  
>  free_vmcs:
> @@ -7756,6 +7825,15 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
>  	return supported & BIT(bit);
>  }
>  
> +static void vmx_vm_destroy(struct kvm *kvm)
> +{
> +	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
> +
> +	if (kvm_vmx->pid_table)
> +		free_pages((unsigned long)kvm_vmx->pid_table,
> +			get_order((kvm_vmx->pid_last_index + 1) * sizeof(u64)));
> +}
> +
>  static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  	.name = "kvm_intel",
>  
> @@ -7768,6 +7846,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
>  
>  	.vm_size = sizeof(struct kvm_vmx),
>  	.vm_init = vmx_vm_init,
> +	.vm_destroy = vmx_vm_destroy,
>  
>  	.vcpu_create = vmx_create_vcpu,
>  	.vcpu_free = vmx_free_vcpu,
> @@ -8022,6 +8101,9 @@ static __init int hardware_setup(void)
>  	if (!enable_apicv)
>  		vmx_x86_ops.sync_pir_to_irr = NULL;
>  
> +	if (!enable_apicv || !cpu_has_vmx_ipiv())
> +		enable_ipiv = false;
> +
>  	if (cpu_has_vmx_tsc_scaling()) {
>  		kvm_has_tsc_control = true;
>  		kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index d4a647d3ed4a..5b65930a750e 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -365,6 +365,9 @@ struct kvm_vmx {
>  	unsigned int tss_addr;
>  	bool ept_identity_pagetable_done;
>  	gpa_t ept_identity_map_addr;
> +	/* PID table for IPI virtualization */

I like having a comment here since "pid_table" is ambiguous, but take the opportunity
to explain PID, i.e.

	/* Posted Interrupt Descriptor (PID) table for IPI virtualization. */

> +	u64 *pid_table;
> +	u16 pid_last_index;
>  };
>  
>  bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
> @@ -584,4 +587,6 @@ static inline int vmx_get_instr_info_reg2(u32 vmx_instr_info)
>  	return (vmx_instr_info >> 28) & 0xf;
>  }
>  
> +bool vmx_can_use_ipiv(struct kvm *kvm);
> +
>  #endif /* __KVM_X86_VMX_H */
> -- 
> 2.27.0
> 
