Return-Path: <kvm+bounces-63567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BD31CC6AEA7
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:22:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3EF384EBE59
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:15:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56722349B0F;
	Tue, 18 Nov 2025 17:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K1Yms5QS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9FA33C188
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485894; cv=none; b=GIxhJ2aXyQFEx5ik+kes80ubUDOg6eH42zkhmQ93hm0/jUm9TcBJK78Irwic7q9evDmgSRsqGuADWtnYMoK3jovBgtHmzewqc0zKjMDGNglnuLFtFqjfF5YewMOyjwQyUAbgTMQZwhLimjCjoK0N+tNsVGd0EFa3GnHtmEQe3R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485894; c=relaxed/simple;
	bh=BS5CpRycSSUp2I3eAz+w6E5e/8PiVRvCDmDV9p6rGjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAeWRCnttfDjCxsCrLAW6OsEDVYStGWEzSUMiL6qjZOhT+eavXVoP182PFKmAiwx/kKLJKSoUrkDM4ZJgvNMUK88wfDI/GOzFhgYhoGOebDYBesjSbDulgIVUr+bSeBPza0ExqiWkRfceOmkp5toE/GiFyNcO1lWUeSSwXtYOxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K1Yms5QS; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so27417935e9.2
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 09:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763485890; x=1764090690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iUBuCxz40AkXLTFxR3IE9cqbGYvT1tLCutNYkvjnIGs=;
        b=K1Yms5QSzUBOGQXqGq4S69nm0FnB3ZhDisnO5dtOTXwM7qCo5Y3HfRKHTRU+AGdD6X
         UCaGGH5k4Z2WONXlt0JYWh+EVu0pNdu5oQjcZKdAmvmLrYnwmm2EkhSRkGtbPnPrGgpE
         erMzOiPcK8aRWHzUHF3QCyuAVY63k4LvHi24/BnB/KLToqxnYACRr9NSTARgowGjHsRN
         xHzV8gha1NLagBqQgdkGL6fPiPflHUL30hpoExcrqxE6/vP3jDAyFuQrKAxybDpFe/lc
         nqYoKSWgm4b29GGANke22xlIehyp8wi0JTxD/XmHQtiqIX0/m81d/k7WfMfW5E8kJWVj
         L5LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763485890; x=1764090690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iUBuCxz40AkXLTFxR3IE9cqbGYvT1tLCutNYkvjnIGs=;
        b=wc9wkOwHZEjm8QDS+QJy3m1onvFbansB+26ePNUEbhDZzCAl7JFrgadqAVRYzVcLEV
         xo+CNT6w57Mfg5kJxNmXXgU3Bll17/YZit4UG455bdL0eSLkLcT7jtrZwu0E2Vs75bkv
         pY/+DZ080oYXR8ZYfG25URKWHOFGlUzDCBK2jVAG++7oTpyd81LkHzrI/bPRTAfr2qkG
         ZNTKQCDMO1k2yAGuhNMbm70EnPu+coF7CJ7DoSRjTvS4iYomEnJNTBmE1vZNsQ9yiW4o
         X23rvBBHShg6dUSKbSpyZ33OzG5RDCDOKgBn+jF4TdTfCtqj2JRbdI24SDAERTWEz2AX
         5g3Q==
X-Gm-Message-State: AOJu0YwCQ1KxcQYWuLpl7Hk9LQWRNdGfFUxMweN9wpbqnVs33ia1btTe
	UpRWkF3gd0SudCo/OUdOtTbNaTdEs4cPm6pIhPfbsd2JBUte29VY1dm9gufTT7U+5BPBmg==
X-Gm-Gg: ASbGncsOU4PJ7j2oPvMQvVAkcN/meVkfGZiFtT+2du2hzOHP4P0JHqqEmSSdeuE3fdz
	E0uisKSGTKgHghQwc5cgtDDLKjLM8rfzP1LbmD7Ovlm2jv3KYYnx9s3OjhxfXOkFquYUS6UXpgn
	doS6XpndXXHblJAv/J6qvOMpZXalOllbmQpvTc2iXn+AXkZCJFIq/4WbxEw5ViNKQoQ1y+1AFBT
	6cSvEYccjEpDDkigELIE+tU+gUzJBkH9Ul/acunQ0q6pBdtrN3buKYO/Lsox87KsYe5TakBcE0A
	e4vzbJuWSJWIRxCnD89jX+Bje1lz4JBeC94n5fsDBIt7Hw8cjI7g7dahD9NK9/Ok6qj5H8mDWH7
	BhvMUbuiusIjLjzyacXKhxovxRPkuXX8B0U5CFkkV9qMeTmDIBapGT7WLuclspeEZKfoXFz9iGS
	B6Xw0LObIknpBkhW0rsFK5d7jxd34bi9/Xq0dp6jxSFbeWNc3ROAQLBOvsfOqXfxN38GQVhQ3g6
	2Gqb2U7bjqPdEboEQ3fqwEVwueurMXLxfgax4V0L7Y=
X-Google-Smtp-Source: AGHT+IGmXpmNvUKyuXvAh+rU1gW8toHrRANOPzYgKuN2/PQp2zLb0b5mWo2XSsoBOPKyGfGOWKZv5A==
X-Received: by 2002:a05:600c:8b21:b0:477:7bca:8b3c with SMTP id 5b1f17b1804b1-4778fea84f0mr154702925e9.19.1763485889465;
        Tue, 18 Nov 2025 09:11:29 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b103d312sm706385e9.13.2025.11.18.09.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:11:28 -0800 (PST)
From: griffoul@gmail.com
X-Google-Original-From: griffoul@gmail.org
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	shuah@kernel.org,
	dwmw@amazon.co.uk,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH v2 07/10] KVM: nVMX: Replace evmcs kvm_host_map with pfncache
Date: Tue, 18 Nov 2025 17:11:10 +0000
Message-ID: <20251118171113.363528-8-griffoul@gmail.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251118171113.363528-1-griffoul@gmail.org>
References: <20251118171113.363528-1-griffoul@gmail.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fred Griffoul <fgriffo@amazon.co.uk>

Replace the eVMCS kvm_host_map with a gfn_to_pfn_cache to properly
handle memslot changes and unify with other pfncaches in nVMX.

The change introduces proper locking/unlocking semantics for eVMCS
access through nested_lock_evmcs() and nested_unlock_evmcs() helpers.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/kvm/vmx/hyperv.h |  21 ++++----
 arch/x86/kvm/vmx/nested.c | 109 ++++++++++++++++++++++++++------------
 arch/x86/kvm/vmx/vmx.h    |   3 +-
 3 files changed, 88 insertions(+), 45 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 3c7fea501ca5..3b6fcf8dff64 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -37,11 +37,6 @@ static inline bool nested_vmx_is_evmptr12_set(struct vcpu_vmx *vmx)
 	return evmptr_is_set(vmx->nested.hv_evmcs_vmptr);
 }
 
-static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
-{
-	return vmx->nested.hv_evmcs;
-}
-
 static inline bool guest_cpu_cap_has_evmcs(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -70,6 +65,8 @@ void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *
 int nested_evmcs_check_controls(struct vmcs12 *vmcs12);
 bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
 void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
+struct hv_enlightened_vmcs *nested_lock_evmcs(struct vcpu_vmx *vmx);
+void nested_unlock_evmcs(struct vcpu_vmx *vmx);
 #else
 static inline bool evmptr_is_valid(u64 evmptr)
 {
@@ -91,11 +88,6 @@ static inline bool nested_vmx_is_evmptr12_set(struct vcpu_vmx *vmx)
 	return false;
 }
 
-static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
-{
-	return NULL;
-}
-
 static inline u32 nested_evmcs_clean_fields(struct vcpu_vmx *vmx)
 {
 	return 0;
@@ -105,6 +97,15 @@ static inline bool nested_evmcs_msr_bitmap(struct vcpu_vmx *vmx)
 {
 	return false;
 }
+
+static inline struct hv_enlightened_vmcs *nested_lock_evmcs(struct vcpu_vmx *vmx)
+{
+	return NULL;
+}
+
+static inline void nested_unlock_evmcs(struct vcpu_vmx *vmx)
+{
+}
 #endif
 
 #endif /* __KVM_X86_VMX_HYPERV_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index aec150612818..d910508e3c22 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -232,8 +232,6 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	kvm_vcpu_unmap(vcpu, &vmx->nested.hv_evmcs_map);
-	vmx->nested.hv_evmcs = NULL;
 	vmx->nested.hv_evmcs_vmptr = EVMPTR_INVALID;
 	vmx->nested.hv_clean_fields = 0;
 	vmx->nested.hv_msr_bitmap = false;
@@ -265,7 +263,7 @@ static bool nested_evmcs_handle_vmclear(struct kvm_vcpu *vcpu, gpa_t vmptr)
 	    !evmptr_is_valid(nested_get_evmptr(vcpu)))
 		return false;
 
-	if (nested_vmx_evmcs(vmx) && vmptr == vmx->nested.hv_evmcs_vmptr)
+	if (vmptr == vmx->nested.hv_evmcs_vmptr)
 		nested_release_evmcs(vcpu);
 
 	return true;
@@ -393,6 +391,9 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	kvm_gpc_deactivate(&vmx->nested.virtual_apic_cache);
 	kvm_gpc_deactivate(&vmx->nested.apic_access_page_cache);
 	kvm_gpc_deactivate(&vmx->nested.msr_bitmap_cache);
+#ifdef CONFIG_KVM_HYPERV
+	kvm_gpc_deactivate(&vmx->nested.hv_evmcs_cache);
+#endif
 
 	free_vpid(vmx->nested.vpid02);
 	vmx->nested.posted_intr_nv = -1;
@@ -1735,11 +1736,12 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 	vmcs_load(vmx->loaded_vmcs->vmcs);
 }
 
-static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
+static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx,
+				       struct hv_enlightened_vmcs *evmcs,
+				       u32 hv_clean_fields)
 {
 #ifdef CONFIG_KVM_HYPERV
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
-	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
 
 	/* HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE */
@@ -1987,7 +1989,7 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 {
 #ifdef CONFIG_KVM_HYPERV
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
-	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
+	struct hv_enlightened_vmcs *evmcs = nested_lock_evmcs(vmx);
 
 	/*
 	 * Should not be changed by KVM:
@@ -2155,6 +2157,7 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 
 	evmcs->guest_bndcfgs = vmcs12->guest_bndcfgs;
 
+	nested_unlock_evmcs(vmx);
 	return;
 #else /* CONFIG_KVM_HYPERV */
 	KVM_BUG_ON(1, vmx->vcpu.kvm);
@@ -2171,6 +2174,8 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 #ifdef CONFIG_KVM_HYPERV
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct hv_enlightened_vmcs *evmcs;
+	struct gfn_to_pfn_cache *gpc;
+	enum nested_evmptrld_status status = EVMPTRLD_SUCCEEDED;
 	bool evmcs_gpa_changed = false;
 	u64 evmcs_gpa;
 
@@ -2183,17 +2188,19 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 		return EVMPTRLD_DISABLED;
 	}
 
+	gpc = &vmx->nested.hv_evmcs_cache;
+	if (nested_gpc_lock(gpc, evmcs_gpa)) {
+		nested_release_evmcs(vcpu);
+		return EVMPTRLD_ERROR;
+	}
+
+	evmcs = gpc->khva;
+
 	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
 		vmx->nested.current_vmptr = INVALID_GPA;
 
 		nested_release_evmcs(vcpu);
 
-		if (kvm_vcpu_map(vcpu, gpa_to_gfn(evmcs_gpa),
-				 &vmx->nested.hv_evmcs_map))
-			return EVMPTRLD_ERROR;
-
-		vmx->nested.hv_evmcs = vmx->nested.hv_evmcs_map.hva;
-
 		/*
 		 * Currently, KVM only supports eVMCS version 1
 		 * (== KVM_EVMCS_VERSION) and thus we expect guest to set this
@@ -2216,10 +2223,11 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 		 * eVMCS version or VMCS12 revision_id as valid values for first
 		 * u32 field of eVMCS.
 		 */
-		if ((vmx->nested.hv_evmcs->revision_id != KVM_EVMCS_VERSION) &&
-		    (vmx->nested.hv_evmcs->revision_id != VMCS12_REVISION)) {
+		if ((evmcs->revision_id != KVM_EVMCS_VERSION) &&
+		    (evmcs->revision_id != VMCS12_REVISION)) {
 			nested_release_evmcs(vcpu);
-			return EVMPTRLD_VMFAIL;
+			status = EVMPTRLD_VMFAIL;
+			goto unlock;
 		}
 
 		vmx->nested.hv_evmcs_vmptr = evmcs_gpa;
@@ -2244,14 +2252,11 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	 * between different L2 guests as KVM keeps a single VMCS12 per L1.
 	 */
 	if (from_launch || evmcs_gpa_changed) {
-		vmx->nested.hv_evmcs->hv_clean_fields &=
-			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
-
+		evmcs->hv_clean_fields &= ~HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 		vmx->nested.force_msr_bitmap_recalc = true;
 	}
 
 	/* Cache evmcs fields to avoid reading evmcs after copy to vmcs12 */
-	evmcs = vmx->nested.hv_evmcs;
 	vmx->nested.hv_clean_fields = evmcs->hv_clean_fields;
 	vmx->nested.hv_flush_hypercall = evmcs->hv_enlightenments_control.nested_flush_hypercall;
 	vmx->nested.hv_msr_bitmap = evmcs->hv_enlightenments_control.msr_bitmap;
@@ -2260,13 +2265,15 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 		struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
 		if (likely(!vmcs12->hdr.shadow_vmcs)) {
-			copy_enlightened_to_vmcs12(vmx, vmx->nested.hv_clean_fields);
+			copy_enlightened_to_vmcs12(vmx, evmcs, vmx->nested.hv_clean_fields);
 			/* Enlightened VMCS doesn't have launch state */
 			vmcs12->launch_state = !from_launch;
 		}
 	}
 
-	return EVMPTRLD_SUCCEEDED;
+unlock:
+	nested_gpc_unlock(gpc);
+	return status;
 #else
 	return EVMPTRLD_DISABLED;
 #endif
@@ -2771,7 +2778,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			  enum vm_entry_failure_code *entry_failure_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct hv_enlightened_vmcs *evmcs;
 	bool load_guest_pdptrs_vmcs12 = false;
 
 	if (vmx->nested.dirty_vmcs12 || nested_vmx_is_evmptr12_valid(vmx)) {
@@ -2909,9 +2915,13 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * bits when it changes a field in eVMCS. Mark all fields as clean
 	 * here.
 	 */
-	evmcs = nested_vmx_evmcs(vmx);
-	if (evmcs)
+	if (nested_vmx_is_evmptr12_valid(vmx)) {
+		struct hv_enlightened_vmcs *evmcs;
+
+		evmcs = nested_lock_evmcs(vmx);
 		evmcs->hv_clean_fields |= HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
+		nested_unlock_evmcs(vmx);
+	}
 
 	return 0;
 }
@@ -4147,6 +4157,18 @@ static void *nested_gpc_lock_if_active(struct gfn_to_pfn_cache *gpc)
 	return gpc->khva;
 }
 
+#ifdef CONFIG_KVM_HYPERV
+struct hv_enlightened_vmcs *nested_lock_evmcs(struct vcpu_vmx *vmx)
+{
+	return nested_gpc_lock_if_active(&vmx->nested.hv_evmcs_cache);
+}
+
+void nested_unlock_evmcs(struct vcpu_vmx *vmx)
+{
+	nested_gpc_unlock(&vmx->nested.hv_evmcs_cache);
+}
+#endif
+
 static struct pi_desc *nested_lock_pi_desc(struct vcpu_vmx *vmx)
 {
 	u8 *pi_desc_page;
@@ -5636,6 +5658,9 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 	kvm_gpc_init_for_vcpu(&vmx->nested.virtual_apic_cache, vcpu);
 	kvm_gpc_init_for_vcpu(&vmx->nested.pi_desc_cache, vcpu);
 
+#ifdef CONFIG_KVM_HYPERV
+	kvm_gpc_init(&vmx->nested.hv_evmcs_cache, vcpu->kvm);
+#endif
 	vmx->nested.vmcs02_initialized = false;
 	vmx->nested.vmxon = true;
 
@@ -5887,6 +5912,8 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		/* Read the field, zero-extended to a u64 value */
 		value = vmcs12_read_any(vmcs12, field, offset);
 	} else {
+		struct hv_enlightened_vmcs *evmcs;
+
 		/*
 		 * Hyper-V TLFS (as of 6.0b) explicitly states, that while an
 		 * enlightened VMCS is active VMREAD/VMWRITE instructions are
@@ -5905,7 +5932,9 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
 		/* Read the field, zero-extended to a u64 value */
-		value = evmcs_read_any(nested_vmx_evmcs(vmx), field, offset);
+		evmcs = nested_lock_evmcs(vmx);
+		value = evmcs_read_any(evmcs, field, offset);
+		nested_unlock_evmcs(vmx);
 	}
 
 	/*
@@ -6935,6 +6964,27 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+static void vmx_get_enlightened_to_vmcs12(struct vcpu_vmx *vmx)
+{
+#ifdef CONFIG_KVM_HYPERV
+	struct hv_enlightened_vmcs *evmcs;
+	struct kvm_vcpu *vcpu = &vmx->vcpu;
+
+	kvm_vcpu_srcu_read_lock(vcpu);
+	evmcs = nested_lock_evmcs(vmx);
+	/*
+	 * L1 hypervisor is not obliged to keep eVMCS
+	 * clean fields data always up-to-date while
+	 * not in guest mode, 'hv_clean_fields' is only
+	 * supposed to be actual upon vmentry so we need
+	 * to ignore it here and do full copy.
+	 */
+	copy_enlightened_to_vmcs12(vmx, evmcs, 0);
+	nested_unlock_evmcs(vmx);
+	kvm_vcpu_srcu_read_unlock(vcpu);
+#endif /* CONFIG_KVM_HYPERV */
+}
+
 static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
 				u32 user_data_size)
@@ -7025,14 +7075,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
 		if (!vmx->nested.need_vmcs12_to_shadow_sync) {
 			if (nested_vmx_is_evmptr12_valid(vmx))
-				/*
-				 * L1 hypervisor is not obliged to keep eVMCS
-				 * clean fields data always up-to-date while
-				 * not in guest mode, 'hv_clean_fields' is only
-				 * supposed to be actual upon vmentry so we need
-				 * to ignore it here and do full copy.
-				 */
-				copy_enlightened_to_vmcs12(vmx, 0);
+				vmx_get_enlightened_to_vmcs12(vmx);
 			else if (enable_shadow_vmcs)
 				copy_shadow_to_vmcs12(vmx);
 		}
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 87708af502f3..4da5a42b0c60 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -208,8 +208,7 @@ struct nested_vmx {
 	u32 hv_clean_fields;
 	bool hv_msr_bitmap;
 	bool hv_flush_hypercall;
-	struct hv_enlightened_vmcs *hv_evmcs;
-	struct kvm_host_map hv_evmcs_map;
+	struct gfn_to_pfn_cache hv_evmcs_cache;
 #endif
 };
 
-- 
2.43.0


