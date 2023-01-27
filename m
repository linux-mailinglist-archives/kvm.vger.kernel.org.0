Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D3067DCF5
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 05:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbjA0Epj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 23:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjA0Epe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 23:45:34 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573BE751A4
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 20:45:30 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z9-20020a17090a468900b00226b6e7aeeaso3812693pjf.1
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 20:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYPKVkwOWU9zgZqtWQtEW3K1C52xSLWToQaOfT5mUKo=;
        b=fN5wswRSpZgPTVOajp+lH+nj12h6tglpxMvxaffLIpgBV6krk3rycGKrq0kNjEM8lX
         D8nklQb9wARX9gqIrc9Q0KEDdj+60NApl5Ml8HhnL7rNKCA83aIfdiNXJUnn1KkAcL02
         itzWTS2B6bAWvTsf8X1OCjLMoAk8TgfLg053E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYPKVkwOWU9zgZqtWQtEW3K1C52xSLWToQaOfT5mUKo=;
        b=WtneJ70xqT8ZYtp5AYeXbn0z2OHYhNXeLSOlZnUsMZn2qkDHRxtqv8UeCUcTWTKcz4
         bF9dRHxHEPbPrSdsgI+rOfK59DM4+7riuIxZj3Kf27xUWS5TGU/1narePzYYBBaEOIgP
         SmUMjKlJAwEsEuNwlSmqbF0kNfRXbpOrKBfbcUVGHbqmVYQWRq+tRZDGlNtR1b3xM0Vl
         8fAmyBMxxf6C7KIc+E8Ql0XCFfI3wH9Btx2Ty7khpwagTBlzbxznfleTpITvvTtlw9JN
         h0wE9RjRq2Z8dMS7hW+LkfRgbd0RW6NTpLp5Fuuh/d3qc6+Ebbb7TxpHkUku6u9WJ57V
         M3og==
X-Gm-Message-State: AO0yUKVkbj+2IqYvouuezEzHuhNWK4uq4ZXw557NnqBWWBvRCBMt7UWn
        eSULc3a3C3RjdS9Cpm52zOGCsQ==
X-Google-Smtp-Source: AK7set8Z6DZ/jip7rjxDxZYJxAy2wVXRBGW7lLubdnMKQBgyZm5hTKDJI/nBhUdTL+EF9lRV9KBKXA==
X-Received: by 2002:a17:902:d48d:b0:196:4f0d:c31f with SMTP id c13-20020a170902d48d00b001964f0dc31fmr2507526plg.12.1674794729484;
        Thu, 26 Jan 2023 20:45:29 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:24fb:4159:9391:441d])
        by smtp.gmail.com with UTF8SMTPSA id 13-20020a170902c14d00b00194706d3f25sm1804857plj.144.2023.01.26.20.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 20:45:28 -0800 (PST)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH 3/3] KVM: use gfn=>pfn cache for evmcs
Date:   Fri, 27 Jan 2023 13:45:00 +0900
Message-Id: <20230127044500.680329-4-stevensd@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230127044500.680329-1-stevensd@google.com>
References: <20230127044500.680329-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Use gfn_to_pfn_cache to access evmcs. This replaces kvm_vcpu_map, which
doesn't properly handle updates to the HVA->GFN mapping.

This change introduces a number of new failure cases, since refreshing a
gpc can fail. Since the evmcs is sometimes accessed alongside vmcs12
pages, the evmcs gpc is initialized to share the vmcs12 pages' gpc lock
for simplicity. This is coarser locking than necessary, but taking the
lock outside of the vcpu thread should be rare, so the impact should be
minimal.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/vmx/hyperv.c |  41 ++++++++++-
 arch/x86/kvm/vmx/hyperv.h |   2 +
 arch/x86/kvm/vmx/nested.c | 151 +++++++++++++++++++++++++++-----------
 arch/x86/kvm/vmx/vmx.c    |  10 +++
 arch/x86/kvm/vmx/vmx.h    |   3 +-
 5 files changed, 158 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index 22daca752797..1b140ef1d4db 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -554,12 +554,21 @@ bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *evmcs;
+	unsigned long flags;
+	bool nested_flush_hypercall;
 
-	if (!hv_vcpu || !evmcs)
+	if (!hv_vcpu || !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
 		return false;
 
-	if (!evmcs->hv_enlightenments_control.nested_flush_hypercall)
+	evmcs = nested_evmcs_lock_and_acquire(vcpu, &flags);
+	if (!evmcs)
+		return false;
+
+	nested_flush_hypercall = evmcs->hv_enlightenments_control.nested_flush_hypercall;
+	read_unlock_irqrestore(vmx->nested.hv_evmcs_gpc.lock, flags);
+
+	if (!nested_flush_hypercall)
 		return false;
 
 	return hv_vcpu->vp_assist_page.nested_control.features.directhypercall;
@@ -569,3 +578,29 @@ void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu)
 {
 	nested_vmx_vmexit(vcpu, HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH, 0, 0);
 }
+
+struct hv_enlightened_vmcs *nested_evmcs_lock_and_acquire(struct kvm_vcpu *vcpu,
+							  unsigned long *flags_out)
+{
+	unsigned long flags;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+retry:
+	read_lock_irqsave(vmx->nested.hv_evmcs_gpc.lock, flags);
+	if (!kvm_gpc_check(&vmx->nested.hv_evmcs_gpc, sizeof(struct hv_enlightened_vmcs))) {
+		read_unlock_irqrestore(vmx->nested.hv_evmcs_gpc.lock, flags);
+		if (!vmx->nested.hv_evmcs_gpc.active)
+			return NULL;
+
+		if (kvm_gpc_refresh(&vmx->nested.hv_evmcs_gpc,
+				    sizeof(struct hv_enlightened_vmcs))) {
+			kvm_gpc_deactivate(&vmx->nested.hv_evmcs_gpc);
+			return NULL;
+		}
+
+		goto retry;
+	}
+
+	*flags_out = flags;
+	return vmx->nested.hv_evmcs_gpc.khva;
+}
diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index ab08a9b9ab7d..43a9488f9a38 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -306,5 +306,7 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
 bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
 void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
+struct hv_enlightened_vmcs *nested_evmcs_lock_and_acquire(struct kvm_vcpu *vcpu,
+							  unsigned long *flags_out);
 
 #endif /* __KVM_X86_VMX_HYPERV_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cb41113caa8a..b8fff71583c9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -229,10 +229,8 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
-		kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map, true);
-		vmx->nested.hv_evmcs = NULL;
-	}
+	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+		kvm_gpc_deactivate(&vmx->nested.hv_evmcs_gpc);
 
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
 
@@ -574,7 +572,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	int msr;
 	unsigned long *msr_bitmap_l1;
 	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *evmcs;
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -589,10 +587,18 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	 * - Nested hypervisor (L1) has enabled 'Enlightened MSR Bitmap' feature
 	 *   and tells KVM (L0) there were no changes in MSR bitmap for L2.
 	 */
-	if (!vmx->nested.force_msr_bitmap_recalc && evmcs &&
-	    evmcs->hv_enlightenments_control.msr_bitmap &&
-	    evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP)
-		return true;
+	if (!vmx->nested.force_msr_bitmap_recalc && vmx->nested.hv_evmcs_gpc.active) {
+		if (!kvm_gpc_check(&vmx->nested.hv_evmcs_gpc,
+				   sizeof(struct hv_enlightened_vmcs))) {
+			*try_refresh = true;
+			return false;
+		}
+
+		evmcs = vmx->nested.hv_evmcs_gpc.khva;
+		if (evmcs->hv_enlightenments_control.msr_bitmap &&
+		    evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP)
+			return true;
+	}
 
 	if (!nested_vmcs12_gpc_check(&vmx->nested.msr_bitmap_gpc,
 				     vmcs12->msr_bitmap, PAGE_SIZE, try_refresh))
@@ -1573,11 +1579,18 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 	vmcs_load(vmx->loaded_vmcs->vmcs);
 }
 
-static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
+static bool copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, bool full_copy)
 {
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *evmcs;
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
+	unsigned long flags;
+	u32 hv_clean_fields;
+
+	evmcs = nested_evmcs_lock_and_acquire(&vmx->vcpu, &flags);
+	if (!evmcs)
+		return false;
+	hv_clean_fields = full_copy ? 0 : evmcs->hv_clean_fields;
 
 	/* HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE */
 	vmcs12->tpr_threshold = evmcs->tpr_threshold;
@@ -1814,13 +1827,25 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 	 * vmcs12->exit_io_instruction_eip = evmcs->exit_io_instruction_eip;
 	 */
 
-	return;
+	read_unlock_irqrestore(vmx->nested.hv_evmcs_gpc.lock, flags);
+	return true;
 }
 
 static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 {
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *evmcs;
+	unsigned long flags;
+
+	evmcs = nested_evmcs_lock_and_acquire(&vmx->vcpu, &flags);
+	if (WARN_ON_ONCE(!evmcs)) {
+		/*
+		 * We can't sync, so the state is now invalid. This isn't an immediate
+		 * problem, but further accesses will be errors. Failing to acquire the
+		 * evmcs gpc deactivates it, so any subsequent attempts will also fail.
+		 */
+		return;
+	}
 
 	/*
 	 * Should not be changed by KVM:
@@ -1988,6 +2013,8 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 
 	evmcs->guest_bndcfgs = vmcs12->guest_bndcfgs;
 
+	read_unlock_irqrestore(vmx->nested.hv_evmcs_gpc.lock, flags);
+
 	return;
 }
 
@@ -2001,6 +2028,8 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool evmcs_gpa_changed = false;
 	u64 evmcs_gpa;
+	struct hv_enlightened_vmcs *hv_evmcs;
+	unsigned long flags;
 
 	if (likely(!guest_cpuid_has_evmcs(vcpu)))
 		return EVMPTRLD_DISABLED;
@@ -2016,11 +2045,14 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 
 		nested_release_evmcs(vcpu);
 
-		if (kvm_vcpu_map(vcpu, gpa_to_gfn(evmcs_gpa),
-				 &vmx->nested.hv_evmcs_map))
+		if (kvm_gpc_activate(&vmx->nested.hv_evmcs_gpc, evmcs_gpa, PAGE_SIZE)) {
+			kvm_gpc_deactivate(&vmx->nested.hv_evmcs_gpc);
 			return EVMPTRLD_ERROR;
+		}
 
-		vmx->nested.hv_evmcs = vmx->nested.hv_evmcs_map.hva;
+		hv_evmcs = nested_evmcs_lock_and_acquire(&vmx->vcpu, &flags);
+		if (!hv_evmcs)
+			return EVMPTRLD_ERROR;
 
 		/*
 		 * Currently, KVM only supports eVMCS version 1
@@ -2044,9 +2076,10 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 		 * eVMCS version or VMCS12 revision_id as valid values for first
 		 * u32 field of eVMCS.
 		 */
-		if ((vmx->nested.hv_evmcs->revision_id != KVM_EVMCS_VERSION) &&
-		    (vmx->nested.hv_evmcs->revision_id != VMCS12_REVISION)) {
+		if (hv_evmcs->revision_id != KVM_EVMCS_VERSION &&
+		    hv_evmcs->revision_id != VMCS12_REVISION) {
 			nested_release_evmcs(vcpu);
+			read_unlock_irqrestore(vmx->nested.hv_evmcs_gpc.lock, flags);
 			return EVMPTRLD_VMFAIL;
 		}
 
@@ -2072,8 +2105,15 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
 	 */
 	if (from_launch || evmcs_gpa_changed) {
-		vmx->nested.hv_evmcs->hv_clean_fields &=
-			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
+		if (!evmcs_gpa_changed) {
+			hv_evmcs = nested_evmcs_lock_and_acquire(&vmx->vcpu, &flags);
+			if (!hv_evmcs)
+				return EVMPTRLD_ERROR;
+		}
+
+		hv_evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
+
+		read_unlock_irqrestore(vmx->nested.hv_evmcs_gpc.lock, flags);
 
 		vmx->nested.force_msr_bitmap_recalc = true;
 	}
@@ -2399,9 +2439,10 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	}
 }
 
-static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
+static void prepare_vmcs02_rare(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
+				struct hv_enlightened_vmcs *hv_evmcs)
 {
-	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
 			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
@@ -2534,13 +2575,17 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	bool load_guest_pdptrs_vmcs12 = false;
+	struct hv_enlightened_vmcs *hv_evmcs = NULL;
+
+	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+		hv_evmcs = vmx->nested.hv_evmcs_gpc.khva;
 
 	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
-		prepare_vmcs02_rare(vmx, vmcs12);
+		prepare_vmcs02_rare(vcpu, vmcs12, hv_evmcs);
 		vmx->nested.dirty_vmcs12 = false;
 
 		load_guest_pdptrs_vmcs12 = !evmptr_is_valid(vmx->nested.hv_evmcs_vmptr) ||
-			!(vmx->nested.hv_evmcs->hv_clean_fields &
+			!(hv_evmcs->hv_clean_fields &
 			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
 	}
 
@@ -2663,8 +2708,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * here.
 	 */
 	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
-		vmx->nested.hv_evmcs->hv_clean_fields |=
-			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
+		hv_evmcs->hv_clean_fields |= HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
 	return 0;
 }
@@ -3214,7 +3258,7 @@ static void nested_vmcs12_gpc_refresh(struct gfn_to_pfn_cache *gpc,
 	}
 }
 
-static void nested_get_vmcs12_pages_refresh(struct kvm_vcpu *vcpu)
+static bool nested_get_vmcs12_pages_refresh(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3231,9 +3275,24 @@ static void nested_get_vmcs12_pages_refresh(struct kvm_vcpu *vcpu)
 		nested_vmcs12_gpc_refresh(&vmx->nested.pi_desc_gpc,
 					  vmcs12->posted_intr_desc_addr, sizeof(struct pi_desc));
 
-	if (cpu_has_vmx_msr_bitmap() && nested_cpu_has(vmcs12, CPU_BASED_USE_MSR_BITMAPS))
+	if (cpu_has_vmx_msr_bitmap() && nested_cpu_has(vmcs12, CPU_BASED_USE_MSR_BITMAPS)) {
+		if (vmx->nested.hv_evmcs_gpc.active) {
+			if (kvm_gpc_refresh(&vmx->nested.hv_evmcs_gpc, PAGE_SIZE)) {
+				kvm_gpc_deactivate(&vmx->nested.hv_evmcs_gpc);
+				pr_debug_ratelimited("%s: no backing for evmcs\n", __func__);
+				vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+				vcpu->run->internal.suberror =
+					KVM_INTERNAL_ERROR_EMULATION;
+				vcpu->run->internal.ndata = 0;
+				return false;
+			}
+		}
+
 		nested_vmcs12_gpc_refresh(&vmx->nested.msr_bitmap_gpc,
 					  vmcs12->msr_bitmap, PAGE_SIZE);
+	}
+
+	return true;
 }
 
 static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu, bool *try_refresh)
@@ -3366,13 +3425,11 @@ static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	if (!success) {
-		if (try_refresh) {
-			nested_get_vmcs12_pages_refresh(vcpu);
+		if (try_refresh && nested_get_vmcs12_pages_refresh(vcpu)) {
 			try_refresh = false;
 			goto retry;
-		} else {
-			return false;
 		}
+		return false;
 	}
 
 	return true;
@@ -3531,14 +3588,12 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 		if (unlikely(!success)) {
 			read_unlock_irqrestore(vmx->nested.apic_access_gpc.lock, flags);
-			if (try_refresh) {
-				nested_get_vmcs12_pages_refresh(vcpu);
+			if (try_refresh && nested_get_vmcs12_pages_refresh(vcpu)) {
 				try_refresh = false;
 				goto retry;
-			} else {
-				vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-				return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
 			}
+			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
+			return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
 		}
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
@@ -3680,7 +3735,8 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return nested_vmx_failInvalid(vcpu);
 
 	if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
-		copy_enlightened_to_vmcs12(vmx, vmx->nested.hv_evmcs->hv_clean_fields);
+		if (!copy_enlightened_to_vmcs12(vmx, false))
+			return nested_vmx_fail(vcpu, VMXERR_VMPTRLD_INVALID_ADDRESS);
 		/* Enlightened VMCS doesn't have launch state */
 		vmcs12->launch_state = !launch;
 	} else if (enable_shadow_vmcs) {
@@ -5421,7 +5477,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 					   vmptr + offsetof(struct vmcs12,
 							    launch_state),
 					   &zero, sizeof(zero));
-	} else if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr) {
+	} else if (vmx->nested.hv_evmcs_gpc.active && vmptr == vmx->nested.hv_evmcs_vmptr) {
 		nested_release_evmcs(vcpu);
 	}
 
@@ -5448,8 +5504,9 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
 	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct hv_enlightened_vmcs *evmcs;
 	struct x86_exception e;
-	unsigned long field;
+	unsigned long field, flags;
 	u64 value;
 	gva_t gva = 0;
 	short offset;
@@ -5498,8 +5555,13 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		if (offset < 0)
 			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
+		evmcs = nested_evmcs_lock_and_acquire(&vmx->vcpu, &flags);
+		if (!evmcs)
+			return nested_vmx_fail(vcpu, VMXERR_VMPTRLD_INVALID_ADDRESS);
+
 		/* Read the field, zero-extended to a u64 value */
-		value = evmcs_read_any(vmx->nested.hv_evmcs, field, offset);
+		value = evmcs_read_any(evmcs, field, offset);
+		read_unlock_irqrestore(vmx->nested.hv_evmcs_gpc.lock, flags);
 	}
 
 	/*
@@ -6604,7 +6666,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	} else  {
 		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
 		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
-			if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr))
+			if (evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)) {
 				/*
 				 * L1 hypervisor is not obliged to keep eVMCS
 				 * clean fields data always up-to-date while
@@ -6612,8 +6674,9 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 				 * supposed to be actual upon vmentry so we need
 				 * to ignore it here and do full copy.
 				 */
-				copy_enlightened_to_vmcs12(vmx, 0);
-			else if (enable_shadow_vmcs)
+				if (!copy_enlightened_to_vmcs12(vmx, true))
+					return -EFAULT;
+			} else if (enable_shadow_vmcs)
 				copy_shadow_to_vmcs12(vmx);
 		}
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1bb8252d40aa..1c13fc1b7b5e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4835,6 +4835,16 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		kvm_gpc_init_with_lock(&vmx->nested.msr_bitmap_gpc, kvm, &vmx->vcpu,
 				       KVM_HOST_USES_PFN,
 				       vmx->nested.apic_access_gpc.lock);
+
+		memset(&vmx->nested.hv_evmcs_gpc, 0, sizeof(vmx->nested.hv_evmcs_gpc));
+		/*
+		 * Share the same lock for simpler locking. Taking the lock
+		 * outside of the vcpu thread should be rare, so the cost of
+		 * the coarser locking should be minimal
+		 */
+		kvm_gpc_init_with_lock(&vmx->nested.hv_evmcs_gpc, kvm, &vmx->vcpu,
+				       KVM_GUEST_AND_HOST_USE_PFN,
+				       vmx->nested.apic_access_gpc.lock);
 	}
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e067730a0222..71e52daf60af 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -252,9 +252,8 @@ struct nested_vmx {
 		bool guest_mode;
 	} smm;
 
+	struct gfn_to_pfn_cache hv_evmcs_gpc;
 	gpa_t hv_evmcs_vmptr;
-	struct kvm_host_map hv_evmcs_map;
-	struct hv_enlightened_vmcs *hv_evmcs;
 };
 
 struct vcpu_vmx {
-- 
2.39.1.456.gfc5497dd1b-goog

