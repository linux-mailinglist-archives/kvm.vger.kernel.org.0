Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65FE7407406
	for <lists+kvm@lfdr.de>; Sat, 11 Sep 2021 01:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhIJXpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 19:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234787AbhIJXpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 19:45:05 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF02C061574
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 16:43:53 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id f3-20020a17090a638300b00199097ddf1aso2622096pjj.0
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 16:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ILgkCRK76GjonC5Id7qsQvD23kBQ2qirIYg6N/RYhUE=;
        b=AW6xN8vnSyMEP48wYLRTRim6FxHfjtvCMycqs8yucxQOKaI5WRI40G86lYEKVBUwpI
         tJyFyE0F/aUqDTI/Az6pncaDQQOgKGuHCADSPa5lvMoOePRpC3tmAv1PeeBzo1yqQVii
         KRTcnRNrrYkhMWEIqtl1a2O3sj3XzCGhfg/tbmajbQjWkxUuUOwvbo8ROG/Xigu/IiNW
         jRRkT02mftv3aW257swQYEoG8wi1H6ZdNh2vOVECOnRN13KwXr/JEbMrc3fcoSnaslo6
         ugYsS+0h7gGUNhIIC5idO7663UBM/SZSTXFO1AqxpK/fpCidPx+GktiUPVixT4LlKdrE
         fh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ILgkCRK76GjonC5Id7qsQvD23kBQ2qirIYg6N/RYhUE=;
        b=EJ9nrMmyTZFQkGP5ll/z/eizBbw8roagGMbecmbgwIcBSmIwCRRst/jiifxEzT/oWB
         FOdNFxjM4CIc8w2ChPnymp1qoqHtFhDoKduN3Ks7mk9T5THqBU4OYYF4lK2mH7/rb2sp
         mQs7um6i0k6Rfd7eULA4TQNzF1IaQnpYQ87oqFQltCftXLzOOD6XmQhC23VZgqUVXnnX
         tU4HJ14zn7cXxb+Lr3w0/m1qP0hxSlo3PwSqWOaMRvO4mZZDBa8HA1vxtPuB4DGf3R3H
         pUpmp++RFcHVwUSlxvdiXDn0MlBJqxbn4Ma3HW3wgj2NHHSXCRl7fOS6G9aMg8A5Y+rL
         zFtQ==
X-Gm-Message-State: AOAM530DSa+Rbot2qbyR0Nia6IEC/XZBqxTPZautbwnDw1+zzAENpzF8
        GhcpoqPDFYPXQwqpB3i7mt/CIg==
X-Google-Smtp-Source: ABdhPJzoKDtOvJg8ahOsTFFadApAE9mEqdHGElWcuVSd6Ym+hnH8kYuMgsjUNzoJSOb/g0zAevcUUw==
X-Received: by 2002:a17:90a:a087:: with SMTP id r7mr205406pjp.84.1631317432925;
        Fri, 10 Sep 2021 16:43:52 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h5sm21232pfr.134.2021.09.10.16.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:43:52 -0700 (PDT)
Date:   Fri, 10 Sep 2021 23:43:48 +0000
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
Subject: Re: [PATCH v4 6/6] KVM: VMX: enable IPI virtualization
Message-ID: <YTvttCcfqF7D/CXt@google.com>
References: <20210809032925.3548-1-guang.zeng@intel.com>
 <20210809032925.3548-7-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809032925.3548-7-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021, Zeng Guang wrote:
> From: Gao Chao <chao.gao@intel.com>
> 
> With IPI virtualization enabled, the processor emulates writes
> to APIC registers that would send IPIs. The processor sets the
> bit corresponding to the vector in target vCPU's PIR and may send
> a notification (IPI) specified by NDST and NV fields in target vCPU's
> PID.

PID needs to be dis-ambiguated.  Normal kernel terminology for PID is Process ID.
Skimming through the code without paying attention to the changelog, that was my
initial reaction.  My next guest was that it was some new CPU identifier.  Turns
out it's Posted-Interrupt Descriptors.

> It is similar to what IOMMU engine does when dealing with posted
> interrupt from devices.
> 
> A PID-pointer table is used by the processor to locate the PID of a
> vCPU with the vCPU's APIC ID.
> 
> Like VT-d PI, if a vCPU goes to blocked state, VMM needs to switch its
> notification vector to wakeup vector. This can ensure that when an IPI
> for blocked vCPUs arrives, VMM can get control and wake up blocked
> vCPUs. And if a VCPU is preempted, its posted interrupt notification
> is suppressed.
> 
> Note that IPI virtualization can only virualize physical-addressing,
> flat mode, unicast IPIs. Sending other IPIs would still cause a
> VM exit and need to be handled by VMM.

It's worth calling out that they are the trap-like APIC-write exits.

> Signed-off-by: Gao Chao <chao.gao@intel.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/include/asm/vmx.h         |  8 ++++
>  arch/x86/include/asm/vmxfeatures.h |  2 +
>  arch/x86/kvm/vmx/capabilities.h    |  7 +++
>  arch/x86/kvm/vmx/posted_intr.c     | 22 +++++++---
>  arch/x86/kvm/vmx/vmx.c             | 69 ++++++++++++++++++++++++++++--
>  arch/x86/kvm/vmx/vmx.h             |  3 ++
>  6 files changed, 101 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 8c929596a299..b79b6438acaa 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -76,6 +76,11 @@
>  #define SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE	VMCS_CONTROL_BIT(USR_WAIT_PAUSE)
>  #define SECONDARY_EXEC_BUS_LOCK_DETECTION	VMCS_CONTROL_BIT(BUS_LOCK_DETECTION)
>  
> +/*
> + * Definitions of Tertiary Processor-Based VM-Execution Controls.
> + */
> +#define TERTIARY_EXEC_IPI_VIRT			VMCS_CONTROL_BIT(IPI_VIRT)
> +
>  #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
>  #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
>  #define PIN_BASED_VIRTUAL_NMIS                  VMCS_CONTROL_BIT(VIRTUAL_NMIS)
> @@ -159,6 +164,7 @@ static inline int vmx_misc_mseg_revid(u64 vmx_misc)
>  enum vmcs_field {
>  	VIRTUAL_PROCESSOR_ID            = 0x00000000,
>  	POSTED_INTR_NV                  = 0x00000002,
> +	LAST_PID_POINTER_INDEX		= 0x00000008,
>  	GUEST_ES_SELECTOR               = 0x00000800,
>  	GUEST_CS_SELECTOR               = 0x00000802,
>  	GUEST_SS_SELECTOR               = 0x00000804,
> @@ -224,6 +230,8 @@ enum vmcs_field {
>  	TSC_MULTIPLIER_HIGH             = 0x00002033,
>  	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
>  	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
> +	PID_POINTER_TABLE		= 0x00002042,
> +	PID_POINTER_TABLE_HIGH		= 0x00002043,
>  	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
>  	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
>  	VMCS_LINK_POINTER               = 0x00002800,
> diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
> index b264f5c43b5f..e7b368a68c7c 100644
> --- a/arch/x86/include/asm/vmxfeatures.h
> +++ b/arch/x86/include/asm/vmxfeatures.h
> @@ -86,4 +86,6 @@
>  #define VMX_FEATURE_ENCLV_EXITING	( 2*32+ 28) /* "" VM-Exit on ENCLV (leaf dependent) */
>  #define VMX_FEATURE_BUS_LOCK_DETECTION	( 2*32+ 30) /* "" VM-Exit when bus lock caused */
>  
> +/* Tertiary Processor-Based VM-Execution Controls, word 3 */
> +#define VMX_FEATURE_IPI_VIRT		( 3*32 + 4) /* "" Enable IPI virtualization */

I don't think this should be suppressed, finding CPUs with IPIv support is
definitely interesting.

>  #endif /* _ASM_X86_VMXFEATURES_H */

...

> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 5f81ef092bd4..8c1400aaa1e7 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -81,9 +81,12 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
>  {
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  
> -	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
> -		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
> -		!kvm_vcpu_apicv_active(vcpu))
> +	if (!kvm_vcpu_apicv_active(vcpu))
> +		return;
> +
> +	if ((!kvm_arch_has_assigned_device(vcpu->kvm) ||
> +		!irq_remapping_cap(IRQ_POSTING_CAP)) &&
> +		!enable_ipiv)

Please fix the indentation while you're at it.

And maybe check for enable_ipi first so that the fast path (IPIv enabled) is
optimized to reduce mispredicts?

>  		return;
>  
>  	/* Set SN when the vCPU is preempted */
> @@ -141,9 +144,16 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
>  	struct pi_desc old, new;
>  	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
>  
> -	if (!kvm_arch_has_assigned_device(vcpu->kvm) ||
> -		!irq_remapping_cap(IRQ_POSTING_CAP)  ||
> -		!kvm_vcpu_apicv_active(vcpu))
> +	if (!kvm_vcpu_apicv_active(vcpu))
> +		return 0;
> +
> +	/* Put vCPU into a list and set NV to wakeup vector if it is

	/*
	 * Multi-line comment goes here...
	 */

> +	 * one of the following cases:
> +	 * 1. any assigned device is in use.
> +	 * 2. IPI virtualization is enabled.
> +	 */
> +	if ((!kvm_arch_has_assigned_device(vcpu->kvm) ||
> +		!irq_remapping_cap(IRQ_POSTING_CAP)) && !enable_ipiv)

Can we encapsulate this logic in a helper?  No idea what the name would be.

>  		return 0;
>  
>  	WARN_ON(irqs_disabled());
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9eb351c351ce..684c556395bf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -104,6 +104,9 @@ module_param(fasteoi, bool, S_IRUGO);
>  
>  module_param(enable_apicv, bool, S_IRUGO);
>  
> +bool __read_mostly enable_ipiv = 1;
> +module_param(enable_ipiv, bool, S_IRUGO);

Please use octal, i.e. 0444.

> +
>  /*
>   * If nested=1, nested virtualization is supported, i.e., guests may use
>   * VMX and be a hypervisor for its own guests. If nested=0, guests may not
> @@ -225,6 +228,7 @@ static const struct {
>  };
>  
>  #define L1D_CACHE_ORDER 4
> +#define PID_TABLE_ORDER get_order(KVM_MAX_VCPU_ID << 3)

IMO, the shift is unnecessary obfuscation:

  #define PID_TABLE_ORDER get_order(KVM_MAX_VCPU_ID * sizeof(u64))

>  static void *vmx_l1d_flush_pages;
>  
>  static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
> @@ -2514,7 +2518,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>  	}
>  
>  	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
> -		u64 opt3 = 0;
> +		u64 opt3 = enable_ipiv ? TERTIARY_EXEC_IPI_VIRT : 0;

This is not the right place to deal with module params.  It's not horrific when
there's only one control, but it'll devolve into a mess as more features are
added, e.g. try applying this pattern to secondary execution controls :-)

>  		u64 min3 = 0;
>  
>  		if (adjust_vmx_controls_64(min3, opt3,
> @@ -3870,6 +3874,8 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
>  		vmx_enable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_TMCCT), MSR_TYPE_RW);
>  		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_EOI), MSR_TYPE_W);
>  		vmx_disable_intercept_for_msr(vcpu, X2APIC_MSR(APIC_SELF_IPI), MSR_TYPE_W);
> +		vmx_set_intercept_for_msr(vcpu, X2APIC_MSR(APIC_ICR),
> +				MSR_TYPE_RW, !enable_ipiv);

This needs to account for kvm_vcpu_apicv_active(), otherwise KVM will expose the
"real" ICR to the guest if APICv and thus IPIv are deactivated for whatever reason.
It might be worth adding kvm_vcpu_ipiv_active().

>  	}
>  }
>  
> @@ -4138,14 +4144,21 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>  
>  	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
>  	if (cpu_has_secondary_exec_ctrls()) {
> -		if (kvm_vcpu_apicv_active(vcpu))
> +		if (kvm_vcpu_apicv_active(vcpu)) {
>  			secondary_exec_controls_setbit(vmx,
>  				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
>  				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> -		else
> +			if (cpu_has_tertiary_exec_ctrls() && enable_ipiv)
> +				tertiary_exec_controls_setbit(vmx,
> +					TERTIARY_EXEC_IPI_VIRT);
> +		} else {
>  			secondary_exec_controls_clearbit(vmx,
>  					SECONDARY_EXEC_APIC_REGISTER_VIRT |
>  					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
> +			if (cpu_has_tertiary_exec_ctrls())
> +				tertiary_exec_controls_clearbit(vmx,
> +					TERTIARY_EXEC_IPI_VIRT);
> +		}
>  	}
>  
>  	if (cpu_has_vmx_msr_bitmap())
> @@ -4180,7 +4193,13 @@ u32 vmx_exec_control(struct vcpu_vmx *vmx)
>  
>  static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
>  {
> -	return vmcs_config.cpu_based_3rd_exec_ctrl;
> +	struct kvm_vcpu *vcpu = &vmx->vcpu;
> +	u64 exec_control = vmcs_config.cpu_based_3rd_exec_ctrl;
> +
> +	if (!kvm_vcpu_apicv_active(vcpu))

This should be:

	if (!enable_ipiv || !kvm_vcpu_apicv_active(vcpu))

or with a helper

	if (!kvm_vcpu_ipiv_active(vcpu))

I believe you took the dependency only on kvm_vcpu_apicv_active() because
enable_ipiv is handled in setup_vmcs_config(), but that's fragile since it falls
apart if enable_ipiv is forced off for some other reason.

> +		exec_control &= ~TERTIARY_EXEC_IPI_VIRT;
> +
> +	return exec_control;
>  }
>  
>  /*
> @@ -4330,6 +4349,17 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
>  
>  #define VMX_XSS_EXIT_BITMAP 0
>  
> +static void install_pid(struct vcpu_vmx *vmx)
> +{
> +	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vmx->vcpu.kvm);
> +
> +	BUG_ON(vmx->vcpu.vcpu_id > kvm_vmx->pid_last_index);

This is pointless since pid_last_index is hardcoded.  E.g. if we drop
pid_last_index then this becomes

	BUG_ON(vmx->vcpu.vcpu_id > KVM_MAX_VCPU_ID)

which is silly.  And if pid_last_index is ever needed because the table grows
dynamically, the BUG_ON would still be silly since pid_last_index would be
derived directly from the max vcpu_id.

> +	/* Bit 0 is the valid bit */

Use a #define instead of a comment.

> +	kvm_vmx->pid_table[vmx->vcpu.vcpu_id] = __pa(&vmx->pi_desc) | 1;

This needs WRITE_ONCE to avoid theoretical badness if userspace creates a vCPU
while others are running and a vCPU concurrently accesses the entry, e.g. CPU
sees '1' but not the PA (which I think the compiler can technically do?).

And IIUC, IPIv works for both xAPIC and x2APIC.  With xAPIC, the guest can change
its APIC ID at will, and all of this goes kaput.  I assume kvm_apic_set_xapic_id()
and maybe even kvm_apic_set_x2apic_id() need to hook into IPIv.  E.g. see

	case APIC_ID:		/* Local APIC ID */
		if (!apic_x2apic_mode(apic))
			kvm_apic_set_xapic_id(apic, val >> 24);
		else
			ret = 1;
		break;


> +	vmcs_write64(PID_POINTER_TABLE, __pa(kvm_vmx->pid_table));
> +	vmcs_write16(LAST_PID_POINTER_INDEX, kvm_vmx->pid_last_index);
> +}
> +
>  /*
>   * Noting that the initialization of Guest-state Area of VMCS is in
>   * vmx_vcpu_reset().
> @@ -4367,6 +4397,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  
>  		vmcs_write16(POSTED_INTR_NV, POSTED_INTR_VECTOR);
>  		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
> +
> +		if (enable_ipiv)
> +			install_pid(vmx);

I'd say avoid the whole "pid" naming mess and drop the helper.  Without context,
intall_pid() absolutely looks like it's installing a process ID somewhere.  The
line wraps can be largely avoided with a bit of value caching, e.g.

 static void init_vmcs(struct vcpu_vmx *vmx)
 {
+       struct kvm_vcpu *vcpu = &vmx->vcpu;
+       u64 *pid_table = to_kvm_vmx(vcpu->kvm)->pid_table;
+
        if (nested)
                nested_vmx_set_vmcs_shadowing_bitmap();

@@ -4428,8 +4420,12 @@ static void init_vmcs(struct vcpu_vmx *vmx)
                vmcs_write16(POSTED_INTR_NV, POSTED_INTR_VECTOR);
                vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));

-               if (enable_ipiv)
-                       install_pid(vmx);
+               if (enable_ipiv) {
+                       pid_table[vcpu->vcpu_id] = __pa(&vmx->pi_desc) |
+                                                  PID_TABLE_ENTRY_VALID;
+                       vmcs_write64(PID_POINTER_TABLE, __pa(pid_table));
+                       vmcs_write16(LAST_PID_POINTER_INDEX, KVM_MAX_VCPU_ID);
+               }
        }

>  	}
>  
>  	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
> @@ -6965,6 +6998,22 @@ static int vmx_vm_init(struct kvm *kvm)
>  			break;
>  		}
>  	}
> +
> +	if (enable_ipiv) {
> +		struct page *pages;
> +
> +		/* Allocate pages for PID table in order of PID_TABLE_ORDER
> +		 * depending on KVM_MAX_VCPU_ID. Each PID entry is 8 bytes.
> +		 */

Not a helpful comment, it doesn't provide any info that isn't readily available
in the code.

> +		pages = alloc_pages(GFP_KERNEL | __GFP_ZERO, PID_TABLE_ORDER);
> +

Unnecessary space.

> +		if (!pages)
> +			return -ENOMEM;
> +
> +		to_kvm_vmx(kvm)->pid_table = (void *)page_address(pages);
> +		to_kvm_vmx(kvm)->pid_last_index = KVM_MAX_VCPU_ID;

I don't see the point of pid_last_index if we're hardcoding it to KVM_MAX_VCPU_ID.
If I understand the ucode pseudocode, there's no performance hit in the happy
case, i.e. it only guards against out-of-bounds accesses.

And I wonder if we want to fail the build if this grows beyond an order-1
allocation, e.g.

		BUILD_BUG_ON(PID_TABLE_ORDER > 1);

Allocating two pages per VM isn't terrible, but 4+ starts to get painful when
considering the fact that most VMs aren't going to need more than one page.  For
now I agree the simplicity of not dynamically growing the table is worth burning
a page.

> +	}
> +
>  	return 0;
>  }
