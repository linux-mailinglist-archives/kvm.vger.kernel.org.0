Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B898E372EBB
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhEDRTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbhEDRTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:19:03 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF51C061343
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:18:04 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id x6-20020a0cda060000b02901c4b3f7d3d9so8169873qvj.0
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=rLxHu6ur1nnGAfhjZTDq/vOPrU25QwD4j6qC952iens=;
        b=XLTGauuasYQDrfDo0C+Tj+Gx4uHJ3NazgHV23+Kc3qBnAQcTkbb/mNSz0siFv0jp4d
         AKXvXaovhVqyrLLsFlq4XB0WIgTTcw6W4RwefPhbI9cSmxi9QuUxOtkiset6gQsi0Cly
         gmQf9quYOsxwPVCmeKfZHPI7r+W2XiOt4u+Yp9oyNvwtEZ6JxtlFvpiHR2HFjsyEFwAf
         kKatzGYF+mm/8caQJioDiIYpvERIFCRglo3986Y8naW/nYnw6KG+qHvRKle7nb/bqMvS
         Ir4TSNkEzIujxrI53+O2j7VlSh0kmH7ysLlmszmn8bxndd/Pu+24H9fZSxWIeg6JORIF
         l4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=rLxHu6ur1nnGAfhjZTDq/vOPrU25QwD4j6qC952iens=;
        b=Gpsf/R/hOI7Sm9Ksj31BZc7oW33E1qV/E/jSMovHPrjAiAj2i/Wy5zm4S7IPfc0gI3
         6x9h5tLtCQthMK3FrhEOI1+oYTMZ/0GRWwxlOjGXJ9s7tNDDAZQyo2lQtLnvtDE3CDu2
         +dNiQrtfEKp10Kle38D7GlcdjufGslwarcDISQ+J0AaKH2lXxSTgnTQfInLl1uUB0AOS
         9bUt1DOFdCvSuKXVHJnjSmJnBRaP92CiTXQlHPxTqMp6VevGoK/zvASpEv7IZc0dj25x
         Mxp2CCf+bYf0SEBfBx5LwlyBREw0CeKwgHNFR1RlJGzWqPe4f8ODoQ1msLxKki/XIy+J
         +duQ==
X-Gm-Message-State: AOAM532zLsbA2kCiL3C1DZz8nvcZWtKqSuo4BG2t3J3Br6+g1tSfLfCg
        aNBIHB2IAOaQFfkzDz8V+aDcrGKF4FM=
X-Google-Smtp-Source: ABdhPJyTEKiVJfglk9hr9Q5KTagcSToFUaeeof7MhHoT10+7kKLUl9DID6mdMDzkS9DwPiuPmiqvxYfHwNU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a0c:df08:: with SMTP id g8mr27360414qvl.12.1620148683932;
 Tue, 04 May 2021 10:18:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:28 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 09/15] KVM: VMX: Use flag to indicate "active" uret MSRs
 instead of sorting list
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly flag a uret MSR as needing to be loaded into hardware instead of
resorting the list of "active" MSRs and tracking how many MSRs in total
need to be loaded.  The only benefit to sorting the list is that the loop
to load MSRs during vmx_prepare_switch_to_guest() doesn't need to iterate
over all supported uret MRS, only those that are active.  But that is a
pointless optimization, as the most common case, running a 64-bit guest,
will load the vast majority of MSRs.  Not to mention that a single WRMSR is
far more expensive than iterating over the list.

Providing a stable list order obviates the need to track a given MSR's
"slot" in the per-CPU list of user return MSRs; all lists simply use the
same ordering.  Future patches will take advantage of the stable order to
further simplify the related code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 80 ++++++++++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 2 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 68454b0de2b1..6caabcd5037e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -458,8 +458,9 @@ static unsigned long host_idt_base;
  * Though SYSCALL is only supported in 64-bit mode on Intel CPUs, kvm
  * will emulate SYSCALL in legacy mode if the vendor string in guest
  * CPUID.0:{EBX,ECX,EDX} is "AuthenticAMD" or "AMDisbetter!" To
- * support this emulation, IA32_STAR must always be included in
- * vmx_uret_msrs_list[], even in i386 builds.
+ * support this emulation, MSR_STAR is included in the list for i386,
+ * but is never loaded into hardware.  MSR_CSTAR is also never loaded
+ * into hardware and is here purely for emulation purposes.
  */
 static u32 vmx_uret_msrs_list[] = {
 #ifdef CONFIG_X86_64
@@ -702,18 +703,12 @@ static bool is_valid_passthrough_msr(u32 msr)
 	return r;
 }
 
-static inline int __vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
+static inline int __vmx_find_uret_msr(u32 msr)
 {
 	int i;
 
-	/*
-	 * Note, vmx->guest_uret_msrs is the same size as vmx_uret_msrs_list,
-	 * but is ordered differently.  The MSR is matched against the list of
-	 * supported uret MSRs using "slot", but the index that is returned is
-	 * the index into guest_uret_msrs.
-	 */
 	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
-		if (vmx_uret_msrs_list[vmx->guest_uret_msrs[i].slot] == msr)
+		if (vmx_uret_msrs_list[i] == msr)
 			return i;
 	}
 	return -1;
@@ -723,7 +718,7 @@ struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
-	i = __vmx_find_uret_msr(vmx, msr);
+	i = __vmx_find_uret_msr(msr);
 	if (i >= 0)
 		return &vmx->guest_uret_msrs[i];
 	return NULL;
@@ -732,13 +727,14 @@ struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 				  struct vmx_uret_msr *msr, u64 data)
 {
+	unsigned int slot = msr - vmx->guest_uret_msrs;
 	int ret = 0;
 
 	u64 old_msr_data = msr->data;
 	msr->data = data;
-	if (msr - vmx->guest_uret_msrs < vmx->nr_active_uret_msrs) {
+	if (msr->load_into_hardware) {
 		preempt_disable();
-		ret = kvm_set_user_return_msr(msr->slot, msr->data, msr->mask);
+		ret = kvm_set_user_return_msr(slot, msr->data, msr->mask);
 		preempt_enable();
 		if (ret)
 			msr->data = old_msr_data;
@@ -1090,7 +1086,7 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
 		return false;
 	}
 
-	i = __vmx_find_uret_msr(vmx, MSR_EFER);
+	i = __vmx_find_uret_msr(MSR_EFER);
 	if (i < 0)
 		return false;
 
@@ -1252,11 +1248,14 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	 */
 	if (!vmx->guest_uret_msrs_loaded) {
 		vmx->guest_uret_msrs_loaded = true;
-		for (i = 0; i < vmx->nr_active_uret_msrs; ++i)
-			kvm_set_user_return_msr(vmx->guest_uret_msrs[i].slot,
+		for (i = 0; i < vmx_nr_uret_msrs; ++i) {
+			if (!vmx->guest_uret_msrs[i].load_into_hardware)
+				continue;
+
+			kvm_set_user_return_msr(i,
 						vmx->guest_uret_msrs[i].data,
 						vmx->guest_uret_msrs[i].mask);
-
+		}
 	}
 
     	if (vmx->nested.need_vmcs12_to_shadow_sync)
@@ -1763,19 +1762,16 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	vmx_clear_hlt(vcpu);
 }
 
-static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr)
+static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
+			       bool load_into_hardware)
 {
-	struct vmx_uret_msr tmp;
-	int from, to;
+	struct vmx_uret_msr *uret_msr;
 
-	from = __vmx_find_uret_msr(vmx, msr);
-	if (from < 0)
+	uret_msr = vmx_find_uret_msr(vmx, msr);
+	if (!uret_msr)
 		return;
-	to = vmx->nr_active_uret_msrs++;
 
-	tmp = vmx->guest_uret_msrs[to];
-	vmx->guest_uret_msrs[to] = vmx->guest_uret_msrs[from];
-	vmx->guest_uret_msrs[from] = tmp;
+	uret_msr->load_into_hardware = load_into_hardware;
 }
 
 /*
@@ -1785,30 +1781,36 @@ static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr)
  */
 static void setup_msrs(struct vcpu_vmx *vmx)
 {
-	vmx->guest_uret_msrs_loaded = false;
-	vmx->nr_active_uret_msrs = 0;
 #ifdef CONFIG_X86_64
+	bool load_syscall_msrs;
+
 	/*
 	 * The SYSCALL MSRs are only needed on long mode guests, and only
 	 * when EFER.SCE is set.
 	 */
-	if (is_long_mode(&vmx->vcpu) && (vmx->vcpu.arch.efer & EFER_SCE)) {
-		vmx_setup_uret_msr(vmx, MSR_STAR);
-		vmx_setup_uret_msr(vmx, MSR_LSTAR);
-		vmx_setup_uret_msr(vmx, MSR_SYSCALL_MASK);
-	}
+	load_syscall_msrs = is_long_mode(&vmx->vcpu) &&
+			    (vmx->vcpu.arch.efer & EFER_SCE);
+
+	vmx_setup_uret_msr(vmx, MSR_STAR, load_syscall_msrs);
+	vmx_setup_uret_msr(vmx, MSR_LSTAR, load_syscall_msrs);
+	vmx_setup_uret_msr(vmx, MSR_SYSCALL_MASK, load_syscall_msrs);
 #endif
-	if (update_transition_efer(vmx))
-		vmx_setup_uret_msr(vmx, MSR_EFER);
+	vmx_setup_uret_msr(vmx, MSR_EFER, update_transition_efer(vmx));
 
-	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)  ||
-	    guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID))
-		vmx_setup_uret_msr(vmx, MSR_TSC_AUX);
+	vmx_setup_uret_msr(vmx, MSR_TSC_AUX,
+			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP) ||
+			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID));
 
-	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL);
+	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL, true);
 
 	if (cpu_has_vmx_msr_bitmap())
 		vmx_update_msr_bitmap(&vmx->vcpu);
+
+	/*
+	 * The set of MSRs to load may have changed, reload MSRs before the
+	 * next VM-Enter.
+	 */
+	vmx->guest_uret_msrs_loaded = false;
 }
 
 static u64 vmx_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d71ed8b425c5..16e4e457ba23 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -36,7 +36,7 @@ struct vmx_msrs {
 };
 
 struct vmx_uret_msr {
-	unsigned int slot; /* The MSR's slot in kvm_user_return_msrs. */
+	bool load_into_hardware;
 	u64 data;
 	u64 mask;
 };
-- 
2.31.1.527.g47e6f16901-goog

