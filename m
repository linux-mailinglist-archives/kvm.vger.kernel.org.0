Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A357052D763
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 17:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240872AbiESPWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 11:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240801AbiESPWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 11:22:36 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EFDEC33E
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 08:22:31 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id v11so5437037pff.6
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 08:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bWjEMev9ajuRS1nciq9J62Rk6yEktXUlae30g4fnIW8=;
        b=iTq077DV71kYOjOKP9BG/2DodkpUgQ8JRAgSE8Z2UW/F+5v7krbw6x2eMOIZ2SI8QH
         YCy11T87q/VBPbnGBXPpSzIPc/XXGU2Y3moVfS62O1JIr5vL60/hDeN20b0fd3+T1F5P
         yRGITUIGfA4EyMrnqFKtVGWZSwtF63nyy9GhMvz6qD8Di+ofADtRDi6/+VsFL87Ogla0
         Eh2P7SvHq78ahfMNqooCExLtrI3c/sSvtO6RyERH5NB6nIkZCFNzZQJFPIFh+KIpkuXL
         4t9q6HhM+NAWdjonhZBq3Q7Oj1o+VdLCeI2ff8ZumkF9D/i/6c5fTtXMhGWo+5C2F4Xz
         FIvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bWjEMev9ajuRS1nciq9J62Rk6yEktXUlae30g4fnIW8=;
        b=r/DVk/4YpJFX/qNqQXxCFu5kAc2qGp+CHWchZgwGf43McNkOfBH5rd6YvHpTOCmDd1
         b8B/gDvpU+Lp4j3InRQcVMp+lV1XM2sN8sAlIpRZsjXdxGHKxV0cg0RG7nDQgDGRRxHH
         5/L6TPIcyAeFOe3BpLZ8oCbSmt+RuxrQPu0GyeMrV1OyI6eqw8lGAcJ1GADKmfPhPWgC
         TqNoebjwhFdQ9yM6LPI6GAvOQrwJygzNUSSCu0NXH5XIvSDDhNaD+Qc7l0qiAlb+Grrh
         oKT71NDv4oEzbYvP+X5rcBAjX9ptuykPGllf49OAKWnFJ+DJkM4qzQ9nrrFbc+TwDP97
         2MOw==
X-Gm-Message-State: AOAM531GnKI3iIV7J2jghh/2MPdDjcttBReylXWkKAb+5B8uWiraOsy7
        JTX64f5LFKhZdIjkAB82ZErbchJa9HD95Q==
X-Google-Smtp-Source: ABdhPJzQG8MLgMIEoPtONITwJ7YdvDNd1MAzVhWcFIUYfu4DhAu5vVjkwBNAX1XrtS+pBavi/fgRCQ==
X-Received: by 2002:a05:6a00:158c:b0:50f:83c5:c147 with SMTP id u12-20020a056a00158c00b0050f83c5c147mr5411859pfk.44.1652973750387;
        Thu, 19 May 2022 08:22:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u32-20020a634720000000b003db580384d6sm3611554pga.60.2022.05.19.08.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 08:22:29 -0700 (PDT)
Date:   Thu, 19 May 2022 15:22:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] KVM: VMX: Enable Notify VM exit
Message-ID: <YoZgsng3wNWgEXaM@google.com>
References: <20220421072958.16375-1-chenyi.qiang@intel.com>
 <20220421072958.16375-4-chenyi.qiang@intel.com>
 <YoVzf8tPgONxjmZM@google.com>
 <a3212daa-16d8-71a8-ef65-f73af268c089@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3212daa-16d8-71a8-ef65-f73af268c089@intel.com>
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

On Thu, May 19, 2022, Chenyi Qiang wrote:
> 
> 
> On 5/19/2022 6:30 AM, Sean Christopherson wrote:
> Thanks Sean for your patch. I think an unintentional change is mixed in it:
> 
> @@ -4739,7 +4725,8 @@ static int
> kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>  	return (kvm_arch_interrupt_allowed(vcpu) &&
>  		kvm_cpu_accept_dm_intr(vcpu) &&
>  		!kvm_event_needs_reinjection(vcpu) &&
> -		!vcpu->arch.exception.pending);
> +		!vcpu->arch.exception.pending &&
> +		!kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu));
>  }
> 
> Maybe this should belong to the patch 1?

Good eyes!  Let's keep it out for now.  I do think it's the right behavior, but
it is woefully incomplete; pretty much every patch that checks
vcpu->arch.exception.pending also needs to check for pending triple fault.

I'll add a patch to my exception/event cleanup series[*], which introduces
kvm_is_exception_pending(), i.e. provides exactly the wrapper needed to handle
a pending triple fault with minimal effort.

[*] https://lore.kernel.org/all/20220311032801.3467418-1-seanjc@google.com


Here's a new version without the spurious change...

--
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 May 2022 13:52:51 -0700
Subject: [PATCH] KVM: x86: Introduce "struct kvm_caps" to track misc
 caps/settings

Add kvm_caps to hold a variety of capabilites and defaults that aren't
handled by kvm_cpu_caps because they aren't CPUID bits in order to reduce
the amount of boilerplate code required to add a new feature.  The vast
majority (all?) of the caps interact with vendor code and are written
only during initialization, i.e. should be tagged __read_mostly, declared
extern in x86.h, and exported.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 15 -----
 arch/x86/kvm/cpuid.c            |  8 +--
 arch/x86/kvm/debugfs.c          |  4 +-
 arch/x86/kvm/lapic.c            |  2 +-
 arch/x86/kvm/svm/nested.c       |  4 +-
 arch/x86/kvm/svm/svm.c          | 13 +++--
 arch/x86/kvm/vmx/nested.c       |  4 +-
 arch/x86/kvm/vmx/vmx.c          | 22 ++++----
 arch/x86/kvm/x86.c              | 97 ++++++++++++++-------------------
 arch/x86/kvm/x86.h              | 26 ++++++++-
 10 files changed, 94 insertions(+), 101 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9cdc5bbd721f..d895d25c5b2f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1661,21 +1661,6 @@ extern bool tdp_enabled;

 u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);

-/* control of guest tsc rate supported? */
-extern bool kvm_has_tsc_control;
-/* maximum supported tsc_khz for guests */
-extern u32  kvm_max_guest_tsc_khz;
-/* number of bits of the fractional part of the TSC scaling ratio */
-extern u8   kvm_tsc_scaling_ratio_frac_bits;
-/* maximum allowed value of TSC scaling ratio */
-extern u64  kvm_max_tsc_scaling_ratio;
-/* 1ull << kvm_tsc_scaling_ratio_frac_bits */
-extern u64  kvm_default_tsc_scaling_ratio;
-/* bus lock detection supported? */
-extern bool kvm_has_bus_lock_exit;
-
-extern u64 kvm_mce_cap_supported;
-
 /*
  * EMULTYPE_NO_DECODE - Set when re-emulating an instruction (after completing
  *			userspace I/O) to indicate that the emulation context
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8c1a3b2430a8..6822fc9ae86d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -199,7 +199,7 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)

 /*
  * Calculate guest's supported XCR0 taking into account guest CPUID data and
- * supported_xcr0 (comprised of host configuration and KVM_SUPPORTED_XCR0).
+ * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
  */
 static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
 {
@@ -209,7 +209,7 @@ static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
 	if (!best)
 		return 0;

-	return (best->eax | ((u64)best->edx << 32)) & supported_xcr0;
+	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
 }

 static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
@@ -927,8 +927,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		}
 		break;
 	case 0xd: {
-		u64 permitted_xcr0 = supported_xcr0 & xstate_get_guest_group_perm();
-		u64 permitted_xss = supported_xss;
+		u64 permitted_xcr0 = kvm_caps.supported_xcr0 & xstate_get_guest_group_perm();
+		u64 permitted_xss = kvm_caps.supported_xss;

 		entry->eax &= permitted_xcr0;
 		entry->ebx = xstate_required_size(permitted_xcr0, false);
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index 9240b3b7f8dd..cfed36aba2f7 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -48,7 +48,7 @@ DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_fops, vcpu_get_tsc_scaling_ratio, NULL,

 static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
 {
-	*val = kvm_tsc_scaling_ratio_frac_bits;
+	*val = kvm_caps.tsc_scaling_ratio_frac_bits;
 	return 0;
 }

@@ -66,7 +66,7 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 				    debugfs_dentry, vcpu,
 				    &vcpu_timer_advance_ns_fops);

-	if (kvm_has_tsc_control) {
+	if (kvm_caps.has_tsc_control) {
 		debugfs_create_file("tsc-scaling-ratio", 0444,
 				    debugfs_dentry, vcpu,
 				    &vcpu_tsc_scaling_fops);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 21ab69db689b..5fd678c90288 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1602,7 +1602,7 @@ static inline void __wait_lapic_expire(struct kvm_vcpu *vcpu, u64 guest_cycles)
 	 * that __delay() uses delay_tsc whenever the hardware has TSC, thus
 	 * always for VMX enabled hardware.
 	 */
-	if (vcpu->arch.tsc_scaling_ratio == kvm_default_tsc_scaling_ratio) {
+	if (vcpu->arch.tsc_scaling_ratio == kvm_caps.default_tsc_scaling_ratio) {
 		__delay(min(guest_cycles,
 			nsec_to_cycles(vcpu, timer_advance_ns)));
 	} else {
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bed5e1692cef..d14370cec23a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -648,7 +648,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)

 	vmcb02->control.tsc_offset = vcpu->arch.tsc_offset;

-	if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
+	if (svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio) {
 		WARN_ON(!svm->tsc_scaling_enabled);
 		nested_svm_update_tsc_ratio_msr(vcpu);
 	}
@@ -979,7 +979,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
 	}

-	if (svm->tsc_ratio_msr != kvm_default_tsc_scaling_ratio) {
+	if (svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio) {
 		WARN_ON(!svm->tsc_scaling_enabled);
 		vcpu->arch.tsc_scaling_ratio = vcpu->arch.l1_tsc_scaling_ratio;
 		svm_write_tsc_multiplier(vcpu, vcpu->arch.tsc_scaling_ratio);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3b49337998ec..480eef001074 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1225,7 +1225,7 @@ static void __svm_vcpu_reset(struct kvm_vcpu *vcpu)

 	svm_init_osvw(vcpu);
 	vcpu->arch.microcode_version = 0x01000065;
-	svm->tsc_ratio_msr = kvm_default_tsc_scaling_ratio;
+	svm->tsc_ratio_msr = kvm_caps.default_tsc_scaling_ratio;

 	if (sev_es_guest(vcpu->kvm))
 		sev_es_vcpu_reset(svm);
@@ -4769,7 +4769,7 @@ static __init void svm_set_cpu_caps(void)
 {
 	kvm_set_cpu_caps();

-	supported_xss = 0;
+	kvm_caps.supported_xss = 0;

 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
 	if (nested) {
@@ -4845,7 +4845,8 @@ static __init int svm_hardware_setup(void)

 	init_msrpm_offsets();

-	supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
+				     XFEATURE_MASK_BNDCSR);

 	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
 		kvm_enable_efer_bits(EFER_FFXSR);
@@ -4855,11 +4856,11 @@ static __init int svm_hardware_setup(void)
 			tsc_scaling = false;
 		} else {
 			pr_info("TSC scaling supported\n");
-			kvm_has_tsc_control = true;
+			kvm_caps.has_tsc_control = true;
 		}
 	}
-	kvm_max_tsc_scaling_ratio = SVM_TSC_RATIO_MAX;
-	kvm_tsc_scaling_ratio_frac_bits = 32;
+	kvm_caps.max_tsc_scaling_ratio = SVM_TSC_RATIO_MAX;
+	kvm_caps.tsc_scaling_ratio_frac_bits = 32;

 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a6688663da4d..aab4745eb1ee 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2548,7 +2548,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			vmx_get_l2_tsc_multiplier(vcpu));

 	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
-	if (kvm_has_tsc_control)
+	if (kvm_caps.has_tsc_control)
 		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);

 	nested_vmx_transition_tlb_flush(vcpu, vmcs12, true);
@@ -4610,7 +4610,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 	vmcs_write64(TSC_OFFSET, vcpu->arch.tsc_offset);
-	if (kvm_has_tsc_control)
+	if (kvm_caps.has_tsc_control)
 		vmcs_write64(TSC_MULTIPLIER, vcpu->arch.tsc_scaling_ratio);

 	if (vmx->nested.l1_tpr_threshold != -1)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8bbcf2071faf..b06eafa5884d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1715,7 +1715,7 @@ u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
 	    nested_cpu_has2(vmcs12, SECONDARY_EXEC_TSC_SCALING))
 		return vmcs12->tsc_multiplier;

-	return kvm_default_tsc_scaling_ratio;
+	return kvm_caps.default_tsc_scaling_ratio;
 }

 static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
@@ -7537,7 +7537,7 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);

 	/* CPUID 0xD.1 */
-	supported_xss = 0;
+	kvm_caps.supported_xss = 0;
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);

@@ -7678,9 +7678,9 @@ static int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 		delta_tsc = 0;

 	/* Convert to host delta tsc if tsc scaling is enabled */
-	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio &&
+	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_caps.default_tsc_scaling_ratio &&
 	    delta_tsc && u64_shl_div_u64(delta_tsc,
-				kvm_tsc_scaling_ratio_frac_bits,
+				kvm_caps.tsc_scaling_ratio_frac_bits,
 				vcpu->arch.l1_tsc_scaling_ratio, &delta_tsc))
 		return -ERANGE;

@@ -8057,8 +8057,8 @@ static __init int hardware_setup(void)
 	}

 	if (!cpu_has_vmx_mpx())
-		supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
-				    XFEATURE_MASK_BNDCSR);
+		kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
+					     XFEATURE_MASK_BNDCSR);

 	if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
 	    !(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
@@ -8125,11 +8125,11 @@ static __init int hardware_setup(void)
 		enable_ipiv = false;

 	if (cpu_has_vmx_tsc_scaling())
-		kvm_has_tsc_control = true;
+		kvm_caps.has_tsc_control = true;

-	kvm_max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
-	kvm_tsc_scaling_ratio_frac_bits = 48;
-	kvm_has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
+	kvm_caps.max_tsc_scaling_ratio = KVM_VMX_TSC_MULTIPLIER_MAX;
+	kvm_caps.tsc_scaling_ratio_frac_bits = 48;
+	kvm_caps.has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();

 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */

@@ -8186,7 +8186,7 @@ static __init int hardware_setup(void)
 		vmx_x86_ops.request_immediate_exit = __kvm_request_immediate_exit;
 	}

-	kvm_mce_cap_supported |= MCG_LMCE_P;
+	kvm_caps.supported_mce_cap |= MCG_LMCE_P;

 	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
 		return -EINVAL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04812eaaf61b..a1ad422e2f37 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -87,8 +87,11 @@

 #define MAX_IO_MSRS 256
 #define KVM_MAX_MCE_BANKS 32
-u64 __read_mostly kvm_mce_cap_supported = MCG_CTL_P | MCG_SER_P;
-EXPORT_SYMBOL_GPL(kvm_mce_cap_supported);
+
+struct kvm_caps kvm_caps __read_mostly = {
+	.supported_mce_cap = MCG_CTL_P | MCG_SER_P,
+};
+EXPORT_SYMBOL_GPL(kvm_caps);

 #define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))

@@ -151,19 +154,6 @@ module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
 static bool __read_mostly kvmclock_periodic_sync = true;
 module_param(kvmclock_periodic_sync, bool, S_IRUGO);

-bool __read_mostly kvm_has_tsc_control;
-EXPORT_SYMBOL_GPL(kvm_has_tsc_control);
-u32  __read_mostly kvm_max_guest_tsc_khz;
-EXPORT_SYMBOL_GPL(kvm_max_guest_tsc_khz);
-u8   __read_mostly kvm_tsc_scaling_ratio_frac_bits;
-EXPORT_SYMBOL_GPL(kvm_tsc_scaling_ratio_frac_bits);
-u64  __read_mostly kvm_max_tsc_scaling_ratio;
-EXPORT_SYMBOL_GPL(kvm_max_tsc_scaling_ratio);
-u64 __read_mostly kvm_default_tsc_scaling_ratio;
-EXPORT_SYMBOL_GPL(kvm_default_tsc_scaling_ratio);
-bool __read_mostly kvm_has_bus_lock_exit;
-EXPORT_SYMBOL_GPL(kvm_has_bus_lock_exit);
-
 /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
 static u32 __read_mostly tsc_tolerance_ppm = 250;
 module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
@@ -235,8 +225,6 @@ EXPORT_SYMBOL_GPL(enable_apicv);

 u64 __read_mostly host_xss;
 EXPORT_SYMBOL_GPL(host_xss);
-u64 __read_mostly supported_xss;
-EXPORT_SYMBOL_GPL(supported_xss);

 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
@@ -309,8 +297,6 @@ const struct kvm_stats_header kvm_vcpu_stats_header = {
 };

 u64 __read_mostly host_xcr0;
-u64 __read_mostly supported_xcr0;
-EXPORT_SYMBOL_GPL(supported_xcr0);

 static struct kmem_cache *x86_emulator_cache;

@@ -2345,12 +2331,12 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)

 	/* Guest TSC same frequency as host TSC? */
 	if (!scale) {
-		kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
+		kvm_vcpu_write_tsc_multiplier(vcpu, kvm_caps.default_tsc_scaling_ratio);
 		return 0;
 	}

 	/* TSC scaling supported? */
-	if (!kvm_has_tsc_control) {
+	if (!kvm_caps.has_tsc_control) {
 		if (user_tsc_khz > tsc_khz) {
 			vcpu->arch.tsc_catchup = 1;
 			vcpu->arch.tsc_always_catchup = 1;
@@ -2362,10 +2348,10 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 	}

 	/* TSC scaling required  - calculate ratio */
-	ratio = mul_u64_u32_div(1ULL << kvm_tsc_scaling_ratio_frac_bits,
+	ratio = mul_u64_u32_div(1ULL << kvm_caps.tsc_scaling_ratio_frac_bits,
 				user_tsc_khz, tsc_khz);

-	if (ratio == 0 || ratio >= kvm_max_tsc_scaling_ratio) {
+	if (ratio == 0 || ratio >= kvm_caps.max_tsc_scaling_ratio) {
 		pr_warn_ratelimited("Invalid TSC scaling ratio - virtual-tsc-khz=%u\n",
 			            user_tsc_khz);
 		return -1;
@@ -2383,7 +2369,7 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 	/* tsc_khz can be zero if TSC calibration fails */
 	if (user_tsc_khz == 0) {
 		/* set tsc_scaling_ratio to a safe value */
-		kvm_vcpu_write_tsc_multiplier(vcpu, kvm_default_tsc_scaling_ratio);
+		kvm_vcpu_write_tsc_multiplier(vcpu, kvm_caps.default_tsc_scaling_ratio);
 		return -1;
 	}

@@ -2460,18 +2446,18 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
  * (frac) represent the fractional part, ie. ratio represents a fixed
  * point number (mult + frac * 2^(-N)).
  *
- * N equals to kvm_tsc_scaling_ratio_frac_bits.
+ * N equals to kvm_caps.tsc_scaling_ratio_frac_bits.
  */
 static inline u64 __scale_tsc(u64 ratio, u64 tsc)
 {
-	return mul_u64_u64_shr(tsc, ratio, kvm_tsc_scaling_ratio_frac_bits);
+	return mul_u64_u64_shr(tsc, ratio, kvm_caps.tsc_scaling_ratio_frac_bits);
 }

 u64 kvm_scale_tsc(u64 tsc, u64 ratio)
 {
 	u64 _tsc = tsc;

-	if (ratio != kvm_default_tsc_scaling_ratio)
+	if (ratio != kvm_caps.default_tsc_scaling_ratio)
 		_tsc = __scale_tsc(ratio, tsc);

 	return _tsc;
@@ -2498,11 +2484,11 @@ u64 kvm_calc_nested_tsc_offset(u64 l1_offset, u64 l2_offset, u64 l2_multiplier)
 {
 	u64 nested_offset;

-	if (l2_multiplier == kvm_default_tsc_scaling_ratio)
+	if (l2_multiplier == kvm_caps.default_tsc_scaling_ratio)
 		nested_offset = l1_offset;
 	else
 		nested_offset = mul_s64_u64_shr((s64) l1_offset, l2_multiplier,
-						kvm_tsc_scaling_ratio_frac_bits);
+						kvm_caps.tsc_scaling_ratio_frac_bits);

 	nested_offset += l2_offset;
 	return nested_offset;
@@ -2511,9 +2497,9 @@ EXPORT_SYMBOL_GPL(kvm_calc_nested_tsc_offset);

 u64 kvm_calc_nested_tsc_multiplier(u64 l1_multiplier, u64 l2_multiplier)
 {
-	if (l2_multiplier != kvm_default_tsc_scaling_ratio)
+	if (l2_multiplier != kvm_caps.default_tsc_scaling_ratio)
 		return mul_u64_u64_shr(l1_multiplier, l2_multiplier,
-				       kvm_tsc_scaling_ratio_frac_bits);
+				       kvm_caps.tsc_scaling_ratio_frac_bits);

 	return l1_multiplier;
 }
@@ -2555,7 +2541,7 @@ static void kvm_vcpu_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 l1_multipli
 	else
 		vcpu->arch.tsc_scaling_ratio = l1_multiplier;

-	if (kvm_has_tsc_control)
+	if (kvm_caps.has_tsc_control)
 		static_call(kvm_x86_write_tsc_multiplier)(
 			vcpu, vcpu->arch.tsc_scaling_ratio);
 }
@@ -2691,7 +2677,7 @@ static inline void adjust_tsc_offset_guest(struct kvm_vcpu *vcpu,

 static inline void adjust_tsc_offset_host(struct kvm_vcpu *vcpu, s64 adjustment)
 {
-	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_default_tsc_scaling_ratio)
+	if (vcpu->arch.l1_tsc_scaling_ratio != kvm_caps.default_tsc_scaling_ratio)
 		WARN_ON(adjustment < 0);
 	adjustment = kvm_scale_tsc((u64) adjustment,
 				   vcpu->arch.l1_tsc_scaling_ratio);
@@ -3104,7 +3090,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)

 	/* With all the info we got, fill in the values */

-	if (kvm_has_tsc_control)
+	if (kvm_caps.has_tsc_control)
 		tgt_tsc_khz = kvm_scale_tsc(tgt_tsc_khz,
 					    v->arch.l1_tsc_scaling_ratio);

@@ -3610,7 +3596,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
 		 * XSAVES/XRSTORS to save/restore PT MSRs.
 		 */
-		if (data & ~supported_xss)
+		if (data & ~kvm_caps.supported_xss)
 			return 1;
 		vcpu->arch.ia32_xss = data;
 		kvm_update_cpuid_runtime(vcpu);
@@ -4370,7 +4356,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_TSC_CONTROL:
 	case KVM_CAP_VM_TSC_CONTROL:
-		r = kvm_has_tsc_control;
+		r = kvm_caps.has_tsc_control;
 		break;
 	case KVM_CAP_X2APIC_API:
 		r = KVM_X2APIC_API_VALID_FLAGS;
@@ -4392,7 +4378,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = sched_info_on();
 		break;
 	case KVM_CAP_X86_BUS_LOCK_EXIT:
-		if (kvm_has_bus_lock_exit)
+		if (kvm_caps.has_bus_lock_exit)
 			r = KVM_BUS_LOCK_DETECTION_OFF |
 			    KVM_BUS_LOCK_DETECTION_EXIT;
 		else
@@ -4401,7 +4387,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_XSAVE2: {
 		u64 guest_perm = xstate_get_guest_group_perm();

-		r = xstate_required_size(supported_xcr0 & guest_perm, false);
+		r = xstate_required_size(kvm_caps.supported_xcr0 & guest_perm, false);
 		if (r < sizeof(struct kvm_xsave))
 			r = sizeof(struct kvm_xsave);
 		break;
@@ -4439,7 +4425,7 @@ static int kvm_x86_dev_get_attr(struct kvm_device_attr *attr)

 	switch (attr->attr) {
 	case KVM_X86_XCOMP_GUEST_SUPP:
-		if (put_user(supported_xcr0, uaddr))
+		if (put_user(kvm_caps.supported_xcr0, uaddr))
 			return -EFAULT;
 		return 0;
 	default:
@@ -4516,8 +4502,8 @@ long kvm_arch_dev_ioctl(struct file *filp,
 	}
 	case KVM_X86_GET_MCE_CAP_SUPPORTED:
 		r = -EFAULT;
-		if (copy_to_user(argp, &kvm_mce_cap_supported,
-				 sizeof(kvm_mce_cap_supported)))
+		if (copy_to_user(argp, &kvm_caps.supported_mce_cap,
+				 sizeof(kvm_caps.supported_mce_cap)))
 			goto out;
 		r = 0;
 		break;
@@ -4801,7 +4787,7 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 	r = -EINVAL;
 	if (!bank_num || bank_num > KVM_MAX_MCE_BANKS)
 		goto out;
-	if (mcg_cap & ~(kvm_mce_cap_supported | 0xff | 0xff0000))
+	if (mcg_cap & ~(kvm_caps.supported_mce_cap | 0xff | 0xff0000))
 		goto out;
 	r = 0;
 	vcpu->arch.mcg_cap = mcg_cap;
@@ -5093,7 +5079,8 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,

 	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu,
 					      guest_xsave->region,
-					      supported_xcr0, &vcpu->arch.pkru);
+					      kvm_caps.supported_xcr0,
+					      &vcpu->arch.pkru);
 }

 static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
@@ -5598,8 +5585,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = -EINVAL;
 		user_tsc_khz = (u32)arg;

-		if (kvm_has_tsc_control &&
-		    user_tsc_khz >= kvm_max_guest_tsc_khz)
+		if (kvm_caps.has_tsc_control &&
+		    user_tsc_khz >= kvm_caps.max_guest_tsc_khz)
 			goto out;

 		if (user_tsc_khz == 0)
@@ -6039,7 +6026,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		    (cap->args[0] & KVM_BUS_LOCK_DETECTION_EXIT))
 			break;

-		if (kvm_has_bus_lock_exit &&
+		if (kvm_caps.has_bus_lock_exit &&
 		    cap->args[0] & KVM_BUS_LOCK_DETECTION_EXIT)
 			kvm->arch.bus_lock_detection_enabled = true;
 		r = 0;
@@ -6588,8 +6575,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = -EINVAL;
 		user_tsc_khz = (u32)arg;

-		if (kvm_has_tsc_control &&
-		    user_tsc_khz >= kvm_max_guest_tsc_khz)
+		if (kvm_caps.has_tsc_control &&
+		    user_tsc_khz >= kvm_caps.max_guest_tsc_khz)
 			goto out;

 		if (user_tsc_khz == 0)
@@ -8745,7 +8732,7 @@ static void kvm_hyperv_tsc_notifier(void)
 	/* TSC frequency always matches when on Hyper-V */
 	for_each_present_cpu(cpu)
 		per_cpu(cpu_tsc_khz, cpu) = tsc_khz;
-	kvm_max_guest_tsc_khz = tsc_khz;
+	kvm_caps.max_guest_tsc_khz = tsc_khz;

 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		__kvm_start_pvclock_update(kvm);
@@ -9007,7 +8994,7 @@ int kvm_arch_init(void *opaque)

 	if (boot_cpu_has(X86_FEATURE_XSAVE)) {
 		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
-		supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
+		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
 	}

 	if (pi_inject_timer == -1)
@@ -11703,13 +11690,13 @@ int kvm_arch_hardware_setup(void *opaque)
 	kvm_register_perf_callbacks(ops->handle_intel_pt_intr);

 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-		supported_xss = 0;
+		kvm_caps.supported_xss = 0;

 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
 	cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
 #undef __kvm_cpu_cap_has

-	if (kvm_has_tsc_control) {
+	if (kvm_caps.has_tsc_control) {
 		/*
 		 * Make sure the user can only configure tsc_khz values that
 		 * fit into a signed integer.
@@ -11717,10 +11704,10 @@ int kvm_arch_hardware_setup(void *opaque)
 		 * be 1 on all machines.
 		 */
 		u64 max = min(0x7fffffffULL,
-			      __scale_tsc(kvm_max_tsc_scaling_ratio, tsc_khz));
-		kvm_max_guest_tsc_khz = max;
+			      __scale_tsc(kvm_caps.max_tsc_scaling_ratio, tsc_khz));
+		kvm_caps.max_guest_tsc_khz = max;
 	}
-	kvm_default_tsc_scaling_ratio = 1ULL << kvm_tsc_scaling_ratio_frac_bits;
+	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
 	kvm_init_msr_list();
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 588792f00334..359d0454ad28 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -8,6 +8,25 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"

+struct kvm_caps {
+	/* control of guest tsc rate supported? */
+	bool has_tsc_control;
+	/* maximum supported tsc_khz for guests */
+	u32  max_guest_tsc_khz;
+	/* number of bits of the fractional part of the TSC scaling ratio */
+	u8   tsc_scaling_ratio_frac_bits;
+	/* maximum allowed value of TSC scaling ratio */
+	u64  max_tsc_scaling_ratio;
+	/* 1ull << kvm_caps.tsc_scaling_ratio_frac_bits */
+	u64  default_tsc_scaling_ratio;
+	/* bus lock detection supported? */
+	bool has_bus_lock_exit;
+
+	u64 supported_mce_cap;
+	u64 supported_xcr0;
+	u64 supported_xss;
+};
+
 void kvm_spurious_fault(void);

 #define KVM_NESTED_VMENTER_CONSISTENCY_CHECK(consistency_check)		\
@@ -283,14 +302,15 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);

 extern u64 host_xcr0;
-extern u64 supported_xcr0;
 extern u64 host_xss;
-extern u64 supported_xss;
+
+extern struct kvm_caps kvm_caps;
+
 extern bool enable_pmu;

 static inline bool kvm_mpx_supported(void)
 {
-	return (supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR))
+	return (kvm_caps.supported_xcr0 & (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR))
 		== (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
 }


base-commit: a3808d88461270c71d3fece5e51cc486ecdac7d0
--
2.36.1.124.g0e6072fb45-goog


