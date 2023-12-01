Return-Path: <kvm+bounces-3147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 019C88010A0
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:57:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B19B2281B0A
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:57:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E87C64D110;
	Fri,  1 Dec 2023 16:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aANx9KPk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D560D133
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 08:57:35 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d10f5bf5d9so39855667b3.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 08:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701449855; x=1702054655; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y4vWDcSleVuAcWWSVJ6UWPxa/+VR6wh4u65BESDtab8=;
        b=aANx9KPk1pJtn96ycXmYA35ffAcJ8SWGumgDAuIx+BTXGfCuMt9YiiKxNyiT7rJRsh
         m7mc8JXfYujVcL6CdFCuqMB3R91oBn1HvFwUpvb/mE3aI+fDVqY4RUlIxZmLzrOcaXIq
         VM4hmGrrurgaG40Dc4VIbTk+AWorCMdJJ4CqQ1o53DkXzw9Y7nekaT+mqdykCz/uSGV6
         q702yAc5D6Wa4knclim45ZYV3GV27CMftIbK22JzBc/KJ7lYIN1E5TvIcfIV2vr0vNzb
         /G6JNFCjWa/pruiyKwTx7XR8TKT1tXZYrxiyZ/fkPYbSgqfRuzUMJEjyNGhrJsrapE7M
         /nNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701449855; x=1702054655;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y4vWDcSleVuAcWWSVJ6UWPxa/+VR6wh4u65BESDtab8=;
        b=SCNhqChUqelCUh8nDWC1MQKFpVFdmqvMo5ANeDuIyqXLcnz231UMCc7s/AlGBrOMHH
         khZVOmHISwkIQyrt5LQZenqn3GBQV01BNmAiZNCRb6Qmio8Hv5v2m13i7bLpdtKMZgm8
         4OnjGML33SOOwNmij09AOhXeQMRJKzQpIoAZd4ebjSKQuKsRqglDrv1fkJHxLGhbxMZl
         NSUPqXEJcIs0prZ9vVjBFvbk139WuT+i6v0cm6ohbcmjLpJWl10qWqvYuaO9bpD9FLhl
         44i2307+ki1ebDgwcWxx4rt0epNgKnVdXiFKtqFHWtrvkLYhfYHBBSI4BbVlc3VPQH5D
         oi8g==
X-Gm-Message-State: AOJu0YzZJWaSwrQbEgDrWBaMY2rLIxYvAYoJqj5q1vunReUOhU71jE/K
	pBIV5qKvt0z3uAtmRCCHi0t5PKsrltI=
X-Google-Smtp-Source: AGHT+IE/RC2L17dLQQZPC7cr5oM/68maBfbYmwu2j63jta6vQs8pehJjrr3Dz6SNdp/rN4yrUhCMwlyuhMc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:be17:0:b0:5d0:a744:7197 with SMTP id
 i23-20020a81be17000000b005d0a7447197mr588779ywn.3.1701449855131; Fri, 01 Dec
 2023 08:57:35 -0800 (PST)
Date: Fri, 1 Dec 2023 08:57:33 -0800
In-Reply-To: <20231123010424.10274-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231123010424.10274-1-lirongqing@baidu.com>
Message-ID: <ZWoQfVxynCVv2_CB@google.com>
Subject: Re: [PATCH v2] KVM: x86: fix kvm_has_noapic_vcpu updates when fail to
 create vcpu
From: Sean Christopherson <seanjc@google.com>
To: Li RongQing <lirongqing@baidu.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, mlevitsk@redhat.com, 
	yilun.xu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 23, 2023, Li RongQing wrote:
> Static key kvm_has_noapic_vcpu should be reduced when fail to create
> vcpu, opportunistically change to call kvm_free_lapic only when LAPIC
> is in kernel in kvm_arch_vcpu_destroy

Heh, this has been on my todo list for a comically long time.

> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> diff v1: call kvm_free_lapic conditionally in kvm_arch_vcpu_destroy
> 
>  arch/x86/kvm/x86.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 2c92407..3cadf28 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12079,7 +12079,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	kfree(vcpu->arch.mci_ctl2_banks);
>  	free_page((unsigned long)vcpu->arch.pio_data);
>  fail_free_lapic:
> -	kvm_free_lapic(vcpu);
> +	if (lapic_in_kernel(vcpu))
> +		kvm_free_lapic(vcpu);
> +	else
> +		static_branch_dec(&kvm_has_noapic_vcpu);
>  fail_mmu_destroy:
>  	kvm_mmu_destroy(vcpu);
>  	return r;
> @@ -12122,14 +12125,17 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	kvm_pmu_destroy(vcpu);
>  	kfree(vcpu->arch.mce_banks);
>  	kfree(vcpu->arch.mci_ctl2_banks);
> -	kvm_free_lapic(vcpu);
> +
> +	if (lapic_in_kernel(vcpu))
> +		kvm_free_lapic(vcpu);
> +	else
> +		static_branch_dec(&kvm_has_noapic_vcpu);

Rather than split code like this, what if we let the APIC code deal with bumping
the static branch?  The effect of this bug is purely just loss of an optimization
that has *very* dubious value to begin with, i.e. having a minimal diff isn't a
priority.  lapic.h already declares kvm_has_noapic_vcpu, so this would make lapic.*
the sole owner of the code.

E.g. (untested)

---
 arch/x86/kvm/lapic.c | 27 ++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c   | 29 +++--------------------------
 2 files changed, 29 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f5fab29c827f..45ffc7d1e49e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -124,6 +124,9 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
 	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
 }
 
+__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
+EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
+
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);
 
@@ -2467,8 +2470,10 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!vcpu->arch.apic)
+	if (!vcpu->arch.apic) {
+		static_branch_dec(&kvm_has_noapic_vcpu);
 		return;
+	}
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
 
@@ -2810,6 +2815,11 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 
 	ASSERT(vcpu != NULL);
 
+	if (!irqchip_in_kernel(vcpu->kvm)) {
+		static_branch_inc(&kvm_has_noapic_vcpu);
+		return 0;
+	}
+
 	apic = kzalloc(sizeof(*apic), GFP_KERNEL_ACCOUNT);
 	if (!apic)
 		goto nomem;
@@ -2845,6 +2855,21 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
 	static_branch_inc(&apic_sw_disabled.key); /* sw disabled at reset */
 	kvm_iodevice_init(&apic->dev, &apic_mmio_ops);
 
+	/*
+	 * Defer evaluating inhibits until the vCPU is first run, as this vCPU
+	 * will not get notified of any changes until this vCPU is visible to
+	 * other vCPUs (marked online and added to the set of vCPUs).
+	 *
+	 * Opportunistically mark APICv active as VMX in particularly is highly
+	 * unlikely to have inhibits.  Ignore the current per-VM APICv state so
+	 * that vCPU creation is guaranteed to run with a deterministic value,
+	 * the request will ensure the vCPU gets the correct state before VM-Entry.
+	 */
+	if (enable_apicv) {
+		apic->apicv_active = true;
+		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+	}
+
 	return 0;
 nomem_free_apic:
 	kfree(apic);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0572172f2e94..7d7d65c60276 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12014,27 +12014,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (r < 0)
 		return r;
 
-	if (irqchip_in_kernel(vcpu->kvm)) {
-		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
-		if (r < 0)
-			goto fail_mmu_destroy;
-
-		/*
-		 * Defer evaluating inhibits until the vCPU is first run, as
-		 * this vCPU will not get notified of any changes until this
-		 * vCPU is visible to other vCPUs (marked online and added to
-		 * the set of vCPUs).  Opportunistically mark APICv active as
-		 * VMX in particularly is highly unlikely to have inhibits.
-		 * Ignore the current per-VM APICv state so that vCPU creation
-		 * is guaranteed to run with a deterministic value, the request
-		 * will ensure the vCPU gets the correct state before VM-Entry.
-		 */
-		if (enable_apicv) {
-			vcpu->arch.apic->apicv_active = true;
-			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
-		}
-	} else
-		static_branch_inc(&kvm_has_noapic_vcpu);
+	r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
+	if (r < 0)
+		goto fail_mmu_destroy;
 
 	r = -ENOMEM;
 
@@ -12155,8 +12137,6 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	free_page((unsigned long)vcpu->arch.pio_data);
 	kvfree(vcpu->arch.cpuid_entries);
-	if (!lapic_in_kernel(vcpu))
-		static_branch_dec(&kvm_has_noapic_vcpu);
 }
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
@@ -12433,9 +12413,6 @@ bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.apic_base & MSR_IA32_APICBASE_BSP) != 0;
 }
 
-__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
-EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
-
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);

base-commit: 1d4405b36808dc8c2d9b65b627c2af4b62fe017e
-- 


