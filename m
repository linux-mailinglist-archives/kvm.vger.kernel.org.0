Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270234F9A90
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 18:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiDHQ0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 12:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbiDHQ0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 12:26:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B90357705
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 09:24:30 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u14so9126887pjj.0
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 09:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rYnVVxyhKumfFmwnr0WfWEMxVmAFk7TEKHdgXJGr0Iw=;
        b=Lb2aSr9fQtfGaUkxcjA8LrMiDQ95u/NfYqsd5OezZarMi1g23OrRGVPCN6PdH2bl9b
         rP+lYwEMkV9iJnDH/WiRpuYrIVd3vInYuQVsCMp2oInnFfobiPvpNnox73+oiXC3Ia0f
         EBbbfleWVGgWQnwDOF9NufVSz4lBUmByAVceXh/wpELX3+0IjhF80aFs2c/f1aodiyCB
         p/0FPzp3IWxSChkyw3vkaCGG/o2z+pfx0tIWXX37MQ2nBp6O2FDLRo1xIK/iKooHSD0v
         m+X+qs6R0kro0/yplqemrBpcWUfyCMghQII4Q5MOPLN7l59EuKK3SgPHfMjZs9PUjBUZ
         RyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rYnVVxyhKumfFmwnr0WfWEMxVmAFk7TEKHdgXJGr0Iw=;
        b=LxkD+cnhyETx/68vkYlPSf465iq+3RLOdYSmm5F4tkAPheThXoMtp4IGMP4TDhkAxS
         URci8y/MmqOCtYaeRCna+bBu1wqEASwiMGSrg4KtqmzzX9loKvCnGW2yf0Xb2X1JuVaU
         o4MTrLgyTYNd8FCRc3nzWEueVPLgNsgC5JvzjsOFdpZgm1PnLQhrhuYnabZnX+Nvjw3K
         S9VSa9VcPIdl5JI0Ih8kPFnKyZbjYVleOIMWbwEEoUtRweROkRSzY6W/DZXe1EsVcVf0
         wMHoqoMCxHM1T7Al9cmWIKfd/vnWhnR9RUKcWEKNRIdXKoifopLIyN9IS8prxMv1h4vz
         7ycA==
X-Gm-Message-State: AOAM5322lGk5VM40iHYQrWbz0ZmuxG/IZU3JoxxvO8MuDYkQdDfTbojk
        c2FlmCdRb4F9uCNBY+Pv3nMdOQ==
X-Google-Smtp-Source: ABdhPJyGUdSrugbndouHNjsZJUNAPPhiNS0lNKzUZWJGcnxfpVvlxYLjM1wO+Tx9kg3/QQbrtoxJSw==
X-Received: by 2002:a17:902:7c0a:b0:156:87e0:846 with SMTP id x10-20020a1709027c0a00b0015687e00846mr19983597pll.8.1649435070040;
        Fri, 08 Apr 2022 09:24:30 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q18-20020aa78432000000b004fb0a5aa2c7sm28007919pfn.183.2022.04.08.09.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 09:24:29 -0700 (PDT)
Date:   Fri, 8 Apr 2022 16:24:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 075/104] KVM: x86: Check for pending APICv
 interrupt in kvm_vcpu_has_events()
Message-ID: <YlBhuWElVRwYrrS+@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <d28f3b27c281e0c6a8f93c01bb4da78980d654c8.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d28f3b27c281e0c6a8f93c01bb4da78980d654c8.1646422845.git.isaku.yamahata@intel.com>
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

On Fri, Mar 04, 2022, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Return true for kvm_vcpu_has_events() if the vCPU has a pending APICv
> interrupt to support TDX's usage of APICv.  Unlike VMX, TDX doesn't have
> access to vmcs.GUEST_INTR_STATUS and so can't emulate posted interrupts,

Based on the discussion in the HLT patch, this is no longer true.

> i.e. needs to generate a posted interrupt and more importantly can't
> manually move requested interrupts into the vIRR (which it also doesn't
> have access to).
> 
> Because pi_has_pending_interrupt() is heavy operation which uses two atomic
> test bit operations and one atomic 256 bit bitmap check, introduce new
> callback for this check instead of reusing dy_apicv_has_pending_interrupt()
> callback to avoid affecting the exiting code.

...

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 89d04cd64cd0..314ae43e07bf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12111,7 +12111,10 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
>  
>  	if (kvm_arch_interrupt_allowed(vcpu) &&
>  	    (kvm_cpu_has_interrupt(vcpu) ||
> -	    kvm_guest_apic_has_interrupt(vcpu)))
> +	     kvm_guest_apic_has_interrupt(vcpu) ||
> +	     (vcpu->arch.apicv_active &&
> +	      kvm_x86_ops.apicv_has_pending_interrupt &&
> +	      kvm_x86_ops.apicv_has_pending_interrupt(vcpu))))

This is pretty gross (fully realizing that I wrote this patch).  It's also arguably
wrong as it really should be called from apic_has_interrupt_for_ppr().

  1. The hook implies it is valid for APICv in general, which is misleading.

  2. It's wasted effort for VMX.
 
  3. It does a poor job of conveying _why_ TDX is different.

  4. KVM is unnecessarily processing its useless "copy" of the PPR/IRR for TDX
     vCPUs.  It's functionally not an issue unless userspace stuffs garbage into
     KVM's vAPIC, but it's unnecessary work.

Rather than hook this path, I would rather we tag kvm_apic has having some of its
state protected.  Then kvm_cpu_has_interrupt() can invoke the alternative,
protected-apic-only hook when appropriate, and kvm_apic_has_interrupt() can bail
immediately instead of doing useless processing of stale vAPIC state.

Note, the below moves the !apic check from tdx_vcpu_reset() to tdx_vcpu_create().
That part should be hoisted earlier in the series, there's no reason to wait until
RESET to perform the check, and I suspect the WARN_ON() can be triggered by userespace.

Compile tested only...

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 8 Apr 2022 08:56:27 -0700
Subject: [PATCH] KVM: TDX: Add support for find pending IRQ in a protected
 local APIC

Add flag and hook to KVM's local APIC management to support determining
whether or not a TDX guest as a pending IRQ.  For TDX vCPUs, the virtual
APIC page is owned by the TDX module and cannot be accessed by KVM.  As a
result, registers that are virtualized by the CPU, e.g. PPR, cannot be
read or written by KVM.  To deliver interrupts for TDX guests, KVM must
send an IRQ to the CPU on the posted interrupt notification vector.  And
to determine if TDX vCPU has a pending interrupt, KVM must check if there
is an outstanding notification.

Return "no interrupt" in kvm_apic_has_interrupt() if the guest APIC is
protected to short-circuit the various other flows that try to pull an
IRQ out of the vAPIC, the only valid operation is querying _if_ an IRQ is
pending, KVM can't do anything based on _which_ IRQ is pending.

Intentionally omit sanity checks from other flows, e.g. PPR update, so as
not to degrade non-TDX guests with unecessary checks.  A well-behaved KVM
and userspace will never reach those flows for TDX guests, but reaching
them is not fatal if something does go awry.

Note, this doesn't handle interrupts that have been delivered to the vCPU
but not yet recognized by the core, i.e. interrupts that are sitting in
vmcs.GUEST_INTR_STATUS.  Querying that state requires a SEAMCALL and will
be supported in a future patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/irq.c                 |  3 +++
 arch/x86/kvm/lapic.c               |  3 +++
 arch/x86/kvm/lapic.h               |  2 ++
 arch/x86/kvm/vmx/main.c            | 11 +++++++++++
 arch/x86/kvm/vmx/tdx.c             |  9 ++++++---
 7 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 7e27b73d839f..ce705d0c6241 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -110,6 +110,7 @@ KVM_X86_OP_NULL(update_pi_irte)
 KVM_X86_OP_NULL(start_assignment)
 KVM_X86_OP_NULL(apicv_post_state_restore)
 KVM_X86_OP_NULL(dy_apicv_has_pending_interrupt)
+KVM_X86_OP_NULL(protected_apic_has_interrupt)
 KVM_X86_OP_NULL(set_hv_timer)
 KVM_X86_OP_NULL(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 489374a57b66..b3dcc0814461 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1491,6 +1491,7 @@ struct kvm_x86_ops {
 	void (*start_assignment)(struct kvm *kvm);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
+	bool (*protected_apic_has_interrupt)(struct kvm_vcpu *vcpu);

 	int (*set_hv_timer)(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			    bool *expired);
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 172b05343cfd..24f180c538b0 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -96,6 +96,9 @@ int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
 	if (kvm_cpu_has_extint(v))
 		return 1;

+	if (lapic_in_kernel(v) && v->arch.apic->guest_apic_protected)
+		return static_call(kvm_x86_protected_apic_has_interrupt)(v);
+
 	return kvm_apic_has_interrupt(v) != -1;	/* LAPIC */
 }
 EXPORT_SYMBOL_GPL(kvm_cpu_has_interrupt);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9322e6340a74..50a483abc0fe 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2503,6 +2503,9 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	if (!kvm_apic_present(vcpu))
 		return -1;

+	if (apic->guest_apic_protected)
+		return -1;
+
 	__apic_update_ppr(apic, &ppr);
 	return apic_has_interrupt_for_ppr(apic, ppr);
 }
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 2b44e533fc8d..7b62f1889a98 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -52,6 +52,8 @@ struct kvm_lapic {
 	bool sw_enabled;
 	bool irr_pending;
 	bool lvt0_in_nmi_mode;
+	/* Select registers in the vAPIC cannot be read/written. */
+	bool guest_apic_protected;
 	/* Number of bits set in ISR. */
 	s16 isr_count;
 	/* The highest vector set in ISR; if -1 - invalid, must scan ISR. */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 882358ac270b..31aab8add010 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -42,6 +42,9 @@ static __init int vt_hardware_setup(void)

 	tdx_hardware_setup(&vt_x86_ops);

+	if (!enable_tdx)
+		vt_x86_ops.protected_apic_has_interrupt = NULL;
+
 	if (enable_ept) {
 		const u64 init_value = enable_tdx ? VMX_EPT_SUPPRESS_VE_BIT : 0ull;
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
@@ -148,6 +151,13 @@ static void vt_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	return vmx_vcpu_load(vcpu, cpu);
 }

+static bool vt_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	KVM_BUG_ON(!is_td_vcpu(vcpu), vcpu->kvm);
+
+	return pi_has_pending_interrupt(vcpu);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -297,6 +307,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.sync_pir_to_irr = vmx_sync_pir_to_irr,
 	.deliver_interrupt = vmx_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
+	.protected_apic_has_interrupt = vt_protected_apic_has_interrupt,

 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3a0e826fbe0c..7b9370384ce4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -467,6 +467,12 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	int ret, i;

+	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
+	if (!vcpu->arch.apic)
+		return -EINVAL;
+
+	vcpu->arch.apic->guest_apic_protected = true;
+
 	ret = tdx_alloc_td_page(&tdx->tdvpr);
 	if (ret)
 		return ret;
@@ -602,9 +608,6 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	/* TDX doesn't support INIT event. */
 	if (WARN_ON(init_event))
 		goto td_bugged;
-	/* TDX supports only X2APIC enabled. */
-	if (WARN_ON(!vcpu->arch.apic))
-		goto td_bugged;
 	if (WARN_ON(is_td_vcpu_created(tdx)))
 		goto td_bugged;


base-commit: f88e9fa63cbd87cda9352ee9a86a6f815744be33
--

