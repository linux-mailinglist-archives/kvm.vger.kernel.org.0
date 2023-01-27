Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006EA67DCF4
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 05:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjA0Epe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 23:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjA0Ep3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 23:45:29 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827D87377C
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 20:45:26 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id jm10so3831364plb.13
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 20:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gGw7veRvhdNX0oFsBRU1tw8SlWDf/IqfMO8eO5En504=;
        b=MepRbm4rcmFcgkoFp9nT02upnWcDX91x1NivyRGygNzVL4N+nhGBvANjTNk+jgshDs
         zYX4f3+E7jWkLxCZWwXjic9DFaTo+hJpUb0HMNJR8EvWA5Gl6QJ4iCmV04ZJBg/u/Okc
         nA1E/Z470z8oWt+dbPmVuiWKt5qFyY3VrEXVk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gGw7veRvhdNX0oFsBRU1tw8SlWDf/IqfMO8eO5En504=;
        b=qUfols8s8l12tR9SiM8QubAT5L9WEUmdTGGMzgf0m0RjmGhQI7OhEWhKnSLIAhJyDw
         bd3e1346gYsBhDZCkZCrJKp5m88Q22BUbWIU3lQOX0EzuP7pJ8Ku8wX+NpjUI3C8ff48
         xJIQ1QPKYE6KA3+P3sSDohSWyxptHJzL0iBOELmHQL0nvBtEHZQBtBs57DWkzDw/jFfp
         TR7RCM7JN3VaxcyCZ1yBt82uawiBJcK4802XQL0/NyElU2juc9z6Pn3R7tBjofstQIcC
         h0tvS0c4LGQqpIxK5Z7rBXZ2hT0ppEWkA1wlJ+pF92vPP1xDRiFjBL7feMWNoGZ+Vpfz
         GPZA==
X-Gm-Message-State: AFqh2kpmTcPqt08zsDaHeTs0xCdcwAffn04uoZhPun6Uy1YvLK8oqwQ5
        eT5+gDJntdrxVCtnfvdoLhR3PA==
X-Google-Smtp-Source: AMrXdXtn15TKuVburNppKgRS3ecaWIXDxqW5JaFqDRR1Hhq/WjjFF7IWEvxOVBB9NScbTSsCsBSvNA==
X-Received: by 2002:a17:903:543:b0:194:6110:9fe1 with SMTP id jo3-20020a170903054300b0019461109fe1mr34011797plb.4.1674794725930;
        Thu, 26 Jan 2023 20:45:25 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:24fb:4159:9391:441d])
        by smtp.gmail.com with UTF8SMTPSA id l8-20020a170902f68800b001960e64fc24sm1783885plg.119.2023.01.26.20.45.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 20:45:25 -0800 (PST)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
Subject: [PATCH 2/3] KVM: use gfn=>pfn cache in nested_get_vmcs12_pages
Date:   Fri, 27 Jan 2023 13:44:59 +0900
Message-Id: <20230127044500.680329-3-stevensd@google.com>
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

Use gfn_to_pfn_cache to access guest pages needed by
nested_get_vmcs12_pages. This replaces kvm_vcpu_map, which doesn't
properly handle updates to the HVA->GFN mapping.

The MSR bitmap is only accessed in nested_vmx_prepare_msr_bitmap, so it
could potentially be accessed directly through the HVA. However, using a
persistent gpc should be more efficient, and maintenance of the gpc can
be easily done alongside the other gpcs.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/x86/kvm/vmx/nested.c | 206 ++++++++++++++++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.c    |  38 ++++++-
 arch/x86/kvm/vmx/vmx.h    |  11 +-
 3 files changed, 204 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 557b9c468734..cb41113caa8a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -324,9 +324,10 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	 * page's backing page (yeah, confusing) shouldn't actually be accessed,
 	 * and if it is written, the contents are irrelevant.
 	 */
-	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	kvm_gpc_deactivate(&vmx->nested.apic_access_gpc);
+	kvm_gpc_deactivate(&vmx->nested.virtual_apic_gpc);
+	kvm_gpc_deactivate(&vmx->nested.pi_desc_gpc);
+	kvm_gpc_deactivate(&vmx->nested.msr_bitmap_gpc);
 	vmx->nested.pi_desc = NULL;
 
 	kvm_mmu_free_roots(vcpu->kvm, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
@@ -558,19 +559,22 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
 						   msr_bitmap_l0, msr);
 }
 
+static bool nested_vmcs12_gpc_check(struct gfn_to_pfn_cache *gpc,
+				    gpa_t gpa, unsigned long len, bool *try_refresh);
+
 /*
  * Merge L0's and L1's MSR bitmap, return false to indicate that
  * we do not use the hardware.
  */
 static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
-						 struct vmcs12 *vmcs12)
+						 struct vmcs12 *vmcs12,
+						 bool *try_refresh)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int msr;
 	unsigned long *msr_bitmap_l1;
 	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
 	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
-	struct kvm_host_map *map = &vmx->nested.msr_bitmap_map;
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
 	if (!cpu_has_vmx_msr_bitmap() ||
@@ -590,10 +594,11 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	    evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP)
 		return true;
 
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), map))
+	if (!nested_vmcs12_gpc_check(&vmx->nested.msr_bitmap_gpc,
+				     vmcs12->msr_bitmap, PAGE_SIZE, try_refresh))
 		return false;
 
-	msr_bitmap_l1 = (unsigned long *)map->hva;
+	msr_bitmap_l1 = vmx->nested.msr_bitmap_gpc.khva;
 
 	/*
 	 * To keep the control flow simple, pay eight 8-byte writes (sixteen
@@ -654,8 +659,6 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
 
-	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
-
 	vmx->nested.force_msr_bitmap_recalc = false;
 
 	return true;
@@ -3184,11 +3187,59 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 	return true;
 }
 
-static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
+static bool nested_vmcs12_gpc_check(struct gfn_to_pfn_cache *gpc,
+				    gpa_t gpa, unsigned long len, bool *try_refresh)
+{
+	bool check;
+
+	if (gpc->gpa != gpa || !gpc->active)
+		return false;
+	check = kvm_gpc_check(gpc, len);
+	if (!check)
+		*try_refresh = true;
+	return check;
+}
+
+static void nested_vmcs12_gpc_refresh(struct gfn_to_pfn_cache *gpc,
+				      gpa_t gpa, unsigned long len)
+{
+	if (gpc->gpa != gpa || !gpc->active) {
+		kvm_gpc_deactivate(gpc);
+
+		if (kvm_gpc_activate(gpc, gpa, len))
+			kvm_gpc_deactivate(gpc);
+	} else {
+		if (kvm_gpc_refresh(gpc, len))
+			kvm_gpc_deactivate(gpc);
+	}
+}
+
+static void nested_get_vmcs12_pages_refresh(struct kvm_vcpu *vcpu)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
+		nested_vmcs12_gpc_refresh(&vmx->nested.apic_access_gpc,
+					  vmcs12->apic_access_addr, PAGE_SIZE);
+
+	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
+		nested_vmcs12_gpc_refresh(&vmx->nested.virtual_apic_gpc,
+					  vmcs12->virtual_apic_page_addr, PAGE_SIZE);
+
+	if (nested_cpu_has_posted_intr(vmcs12))
+		nested_vmcs12_gpc_refresh(&vmx->nested.pi_desc_gpc,
+					  vmcs12->posted_intr_desc_addr, sizeof(struct pi_desc));
+
+	if (cpu_has_vmx_msr_bitmap() && nested_cpu_has(vmcs12, CPU_BASED_USE_MSR_BITMAPS))
+		nested_vmcs12_gpc_refresh(&vmx->nested.msr_bitmap_gpc,
+					  vmcs12->msr_bitmap, PAGE_SIZE);
+}
+
+static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu, bool *try_refresh)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct kvm_host_map *map;
 
 	if (!vcpu->arch.pdptrs_from_userspace &&
 	    !nested_cpu_has_ept(vmcs12) && is_pae_paging(vcpu)) {
@@ -3197,16 +3248,19 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 		 * the guest CR3 might be restored prior to setting the nested
 		 * state which can lead to a load of wrong PDPTRs.
 		 */
-		if (CC(!load_pdptrs(vcpu, vcpu->arch.cr3)))
+		if (CC(!load_pdptrs(vcpu, vcpu->arch.cr3))) {
+			*try_refresh = false;
 			return false;
+		}
 	}
 
-
 	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
-		map = &vmx->nested.apic_access_page_map;
-
-		if (!kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->apic_access_addr), map)) {
-			vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(map->pfn));
+		if (nested_vmcs12_gpc_check(&vmx->nested.apic_access_gpc,
+					    vmcs12->apic_access_addr, PAGE_SIZE, try_refresh)) {
+			vmcs_write64(APIC_ACCESS_ADDR,
+				     pfn_to_hpa(vmx->nested.apic_access_gpc.pfn));
+		} else if (*try_refresh) {
+			return false;
 		} else {
 			pr_debug_ratelimited("%s: no backing for APIC-access address in vmcs12\n",
 					     __func__);
@@ -3219,10 +3273,13 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	}
 
 	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
-		map = &vmx->nested.virtual_apic_map;
-
-		if (!kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->virtual_apic_page_addr), map)) {
-			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, pfn_to_hpa(map->pfn));
+		if (nested_vmcs12_gpc_check(&vmx->nested.virtual_apic_gpc,
+					    vmcs12->virtual_apic_page_addr, PAGE_SIZE,
+					    try_refresh)) {
+			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
+				     pfn_to_hpa(vmx->nested.virtual_apic_gpc.pfn));
+		} else if (*try_refresh) {
+			return false;
 		} else if (nested_cpu_has(vmcs12, CPU_BASED_CR8_LOAD_EXITING) &&
 		           nested_cpu_has(vmcs12, CPU_BASED_CR8_STORE_EXITING) &&
 			   !nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
@@ -3245,14 +3302,16 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	}
 
 	if (nested_cpu_has_posted_intr(vmcs12)) {
-		map = &vmx->nested.pi_desc_map;
-
-		if (!kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->posted_intr_desc_addr), map)) {
+		if (nested_vmcs12_gpc_check(&vmx->nested.pi_desc_gpc,
+					    vmcs12->posted_intr_desc_addr,
+					    sizeof(struct pi_desc), try_refresh)) {
 			vmx->nested.pi_desc =
-				(struct pi_desc *)(((void *)map->hva) +
-				offset_in_page(vmcs12->posted_intr_desc_addr));
+				(struct pi_desc *)vmx->nested.pi_desc_gpc.khva;
 			vmcs_write64(POSTED_INTR_DESC_ADDR,
-				     pfn_to_hpa(map->pfn) + offset_in_page(vmcs12->posted_intr_desc_addr));
+				     pfn_to_hpa(vmx->nested.pi_desc_gpc.pfn) +
+				     offset_in_page(vmx->nested.pi_desc_gpc.gpa));
+		} else if (*try_refresh) {
+			return false;
 		} else {
 			/*
 			 * Defer the KVM_INTERNAL_EXIT until KVM tries to
@@ -3264,16 +3323,22 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 			pin_controls_clearbit(vmx, PIN_BASED_POSTED_INTR);
 		}
 	}
-	if (nested_vmx_prepare_msr_bitmap(vcpu, vmcs12))
+	if (nested_vmx_prepare_msr_bitmap(vcpu, vmcs12, try_refresh)) {
 		exec_controls_setbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
-	else
+	} else {
+		if (*try_refresh)
+			return false;
 		exec_controls_clearbit(vmx, CPU_BASED_USE_MSR_BITMAPS);
+	}
 
 	return true;
 }
 
 static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 {
+	bool success, try_refresh;
+	int idx;
+
 	/*
 	 * Note: nested_get_evmcs_page() also updates 'vp_assist_page' copy
 	 * in 'struct kvm_vcpu_hv' in case eVMCS is in use, this is mandatory
@@ -3291,8 +3356,24 @@ static bool vmx_get_nested_state_pages(struct kvm_vcpu *vcpu)
 		return false;
 	}
 
-	if (is_guest_mode(vcpu) && !nested_get_vmcs12_pages(vcpu))
-		return false;
+	if (!is_guest_mode(vcpu))
+		return true;
+
+	try_refresh = true;
+retry:
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	success = nested_get_vmcs12_pages(vcpu, &try_refresh);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+	if (!success) {
+		if (try_refresh) {
+			nested_get_vmcs12_pages_refresh(vcpu);
+			try_refresh = false;
+			goto retry;
+		} else {
+			return false;
+		}
+	}
 
 	return true;
 }
@@ -3389,6 +3470,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 		.failed_vmentry = 1,
 	};
 	u32 failed_index;
+	bool success, try_refresh;
+	unsigned long flags;
 
 	trace_kvm_nested_vmenter(kvm_rip_read(vcpu),
 				 vmx->nested.current_vmptr,
@@ -3441,13 +3524,26 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	prepare_vmcs02_early(vmx, &vmx->vmcs01, vmcs12);
 
 	if (from_vmentry) {
-		if (unlikely(!nested_get_vmcs12_pages(vcpu))) {
-			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
-			return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
+		try_refresh = true;
+retry:
+		read_lock_irqsave(vmx->nested.apic_access_gpc.lock, flags);
+		success = nested_get_vmcs12_pages(vcpu, &try_refresh);
+
+		if (unlikely(!success)) {
+			read_unlock_irqrestore(vmx->nested.apic_access_gpc.lock, flags);
+			if (try_refresh) {
+				nested_get_vmcs12_pages_refresh(vcpu);
+				try_refresh = false;
+				goto retry;
+			} else {
+				vmx_switch_vmcs(vcpu, &vmx->vmcs01);
+				return NVMX_VMENTRY_KVM_INTERNAL_ERROR;
+			}
 		}
 
 		if (nested_vmx_check_vmentry_hw(vcpu)) {
 			vmx_switch_vmcs(vcpu, &vmx->vmcs01);
+			read_unlock_irqrestore(vmx->nested.apic_access_gpc.lock, flags);
 			return NVMX_VMENTRY_VMFAIL;
 		}
 
@@ -3455,12 +3551,16 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 						 &entry_failure_code)) {
 			exit_reason.basic = EXIT_REASON_INVALID_STATE;
 			vmcs12->exit_qualification = entry_failure_code;
+			read_unlock_irqrestore(vmx->nested.apic_access_gpc.lock, flags);
 			goto vmentry_fail_vmexit;
 		}
 	}
 
 	enter_guest_mode(vcpu);
 
+	if (from_vmentry)
+		read_unlock_irqrestore(vmx->nested.apic_access_gpc.lock, flags);
+
 	if (prepare_vmcs02(vcpu, vmcs12, from_vmentry, &entry_failure_code)) {
 		exit_reason.basic = EXIT_REASON_INVALID_STATE;
 		vmcs12->exit_qualification = entry_failure_code;
@@ -3810,9 +3910,10 @@ void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
 static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	int max_irr;
+	int max_irr, idx;
 	void *vapic_page;
 	u16 status;
+	bool success;
 
 	if (!vmx->nested.pi_pending)
 		return 0;
@@ -3827,7 +3928,17 @@ static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
 
 	max_irr = find_last_bit((unsigned long *)vmx->nested.pi_desc->pir, 256);
 	if (max_irr != 256) {
-		vapic_page = vmx->nested.virtual_apic_map.hva;
+retry:
+		idx = srcu_read_lock(&vcpu->kvm->srcu);
+		success = kvm_gpc_check(&vmx->nested.virtual_apic_gpc, PAGE_SIZE);
+		srcu_read_unlock(&vcpu->kvm->srcu, idx);
+
+		if (!success) {
+			if (kvm_gpc_refresh(&vmx->nested.virtual_apic_gpc, PAGE_SIZE))
+				goto mmio_needed;
+			goto retry;
+		}
+		vapic_page = vmx->nested.virtual_apic_gpc.khva;
 		if (!vapic_page)
 			goto mmio_needed;
 
@@ -4827,12 +4938,6 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 		vmx_update_cpu_dirty_logging(vcpu);
 	}
 
-	/* Unpin physical memory we referred to in vmcs02 */
-	kvm_vcpu_unmap(vcpu, &vmx->nested.apic_access_page_map, false);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
-	vmx->nested.pi_desc = NULL;
-
 	if (vmx->nested.reload_vmcs01_apic_access_page) {
 		vmx->nested.reload_vmcs01_apic_access_page = false;
 		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
@@ -5246,6 +5351,12 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_roots(vcpu->kvm, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
 
 	vmx->nested.current_vmptr = INVALID_GPA;
+
+	kvm_gpc_deactivate(&vmx->nested.apic_access_gpc);
+	kvm_gpc_deactivate(&vmx->nested.virtual_apic_gpc);
+	kvm_gpc_deactivate(&vmx->nested.pi_desc_gpc);
+	kvm_gpc_deactivate(&vmx->nested.msr_bitmap_gpc);
+	vmx->nested.pi_desc = NULL;
 }
 
 /* Emulate the VMXOFF instruction */
@@ -5620,6 +5731,17 @@ static int handle_vmptrld(struct kvm_vcpu *vcpu)
 				VMXERR_VMPTRLD_INCORRECT_VMCS_REVISION_ID);
 		}
 
+		kvm_gpc_activate(&vmx->nested.apic_access_gpc,
+				 vmx->nested.cached_vmcs12->apic_access_addr, PAGE_SIZE);
+		kvm_gpc_activate(&vmx->nested.virtual_apic_gpc,
+				 vmx->nested.cached_vmcs12->virtual_apic_page_addr,
+				 PAGE_SIZE);
+		kvm_gpc_activate(&vmx->nested.pi_desc_gpc,
+				 vmx->nested.cached_vmcs12->posted_intr_desc_addr,
+				 sizeof(struct pi_desc));
+		kvm_gpc_activate(&vmx->nested.msr_bitmap_gpc,
+				 vmx->nested.cached_vmcs12->msr_bitmap, PAGE_SIZE);
+
 		set_current_vmptr(vmx, vmptr);
 	}
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c788aa382611..1bb8252d40aa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4097,16 +4097,27 @@ static bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	void *vapic_page;
 	u32 vppr;
-	int rvi;
+	int rvi, idx;
+	bool success;
 
 	if (WARN_ON_ONCE(!is_guest_mode(vcpu)) ||
 		!nested_cpu_has_vid(get_vmcs12(vcpu)) ||
-		WARN_ON_ONCE(!vmx->nested.virtual_apic_map.gfn))
+		WARN_ON_ONCE(!vmx->nested.virtual_apic_gpc.gpa))
 		return false;
 
 	rvi = vmx_get_rvi();
+retry:
+	idx = srcu_read_lock(&vcpu->kvm->srcu);
+	success = kvm_gpc_check(&vmx->nested.virtual_apic_gpc, PAGE_SIZE);
+	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
-	vapic_page = vmx->nested.virtual_apic_map.hva;
+	if (!success) {
+		if (kvm_gpc_refresh(&vmx->nested.virtual_apic_gpc, PAGE_SIZE))
+			return false;
+		goto retry;
+	}
+
+	vapic_page = vmx->nested.virtual_apic_gpc.khva;
 	vppr = *((u32 *)(vapic_page + APIC_PROCPRI));
 
 	return ((rvi & 0xf0) > (vppr & 0xf0));
@@ -4804,6 +4815,27 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	}
 
 	vmx_setup_uret_msrs(vmx);
+
+	if (nested) {
+		memset(&vmx->nested.apic_access_gpc, 0, sizeof(vmx->nested.apic_access_gpc));
+		kvm_gpc_init(&vmx->nested.apic_access_gpc, kvm, &vmx->vcpu,
+			     KVM_GUEST_USES_PFN);
+
+		memset(&vmx->nested.virtual_apic_gpc, 0, sizeof(vmx->nested.virtual_apic_gpc));
+		kvm_gpc_init_with_lock(&vmx->nested.virtual_apic_gpc, kvm, &vmx->vcpu,
+				       KVM_GUEST_AND_HOST_USE_PFN,
+				       vmx->nested.apic_access_gpc.lock);
+
+		memset(&vmx->nested.pi_desc_gpc, 0, sizeof(vmx->nested.pi_desc_gpc));
+		kvm_gpc_init_with_lock(&vmx->nested.pi_desc_gpc, kvm, &vmx->vcpu,
+				       KVM_GUEST_AND_HOST_USE_PFN,
+				       vmx->nested.apic_access_gpc.lock);
+
+		memset(&vmx->nested.msr_bitmap_gpc, 0, sizeof(vmx->nested.msr_bitmap_gpc));
+		kvm_gpc_init_with_lock(&vmx->nested.msr_bitmap_gpc, kvm, &vmx->vcpu,
+				       KVM_HOST_USES_PFN,
+				       vmx->nested.apic_access_gpc.lock);
+	}
 }
 
 static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a3da84f4ea45..e067730a0222 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -207,13 +207,12 @@ struct nested_vmx {
 
 	/*
 	 * Guest pages referred to in the vmcs02 with host-physical
-	 * pointers, so we must keep them pinned while L2 runs.
+	 * pointers.
 	 */
-	struct kvm_host_map apic_access_page_map;
-	struct kvm_host_map virtual_apic_map;
-	struct kvm_host_map pi_desc_map;
-
-	struct kvm_host_map msr_bitmap_map;
+	struct gfn_to_pfn_cache apic_access_gpc;
+	struct gfn_to_pfn_cache virtual_apic_gpc;
+	struct gfn_to_pfn_cache pi_desc_gpc;
+	struct gfn_to_pfn_cache msr_bitmap_gpc;
 
 	struct pi_desc *pi_desc;
 	bool pi_pending;
-- 
2.39.1.456.gfc5497dd1b-goog

