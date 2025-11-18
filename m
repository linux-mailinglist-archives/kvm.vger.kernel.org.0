Return-Path: <kvm+bounces-63569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A498C6ADFF
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 18:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 19F682A96B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 17:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE118366DD8;
	Tue, 18 Nov 2025 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XC45YfDN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB505349B05
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763485897; cv=none; b=UKVc4WbDc8ENjjAOZ49xJscT4Yp3nPpPcvEy03gukDuCOTLMhsRLWgpAYR2DuChKCfRjQmfjh9TrbgjFi2RVUJMxvk6IQYXRm5Ci4QE6Nl5rvosiGa51o0gxxNAbhwnfw0GNuy6EqF4dciJP5NI1RSWMxVS5SzdCL2W6sC6vx2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763485897; c=relaxed/simple;
	bh=ANzdtJVSrGdNRyKpbr/S/liYzi4rKgftBTzHj+60VDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUJSFrmNDDgrZjNOiFkDU3NpSfJfew8s0COSxVUlzoSFRCZ4j8KH+baXjTwAjM4PdNy1soOupFhRzUK8Sb5IEMLNsYpOcdDmwJ2GW63NqtTepsGMsFq0mmjAP+0tZ5AKPqtKWg9jiLz3IBfQUQ5h5kVB1Ii3Y4pETHob5NOWKpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XC45YfDN; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477a1c28778so31807235e9.3
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 09:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763485893; x=1764090693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=byGUc9HGj/3i2CsHggKCaH358jeuqsufmI+XZ2QMAYA=;
        b=XC45YfDNtp1xhpgbYBIcRkpvrJBGtKnkzUCc1VKkQWsXP5sdC4uwEW36l4jrkJpWro
         c+0EzwfkJfwKC7XEF5wpzR6XV4TLrwz2xP7nJBqIgNoufFChf0/kzdUs5RGebyFjluj7
         XJhQpcEwKlRIxs0UzM7JIeI5USXyh8GcSE47o0CcviSgXcrLgaLyLAYGKvcm1gDwy5rG
         EBgWir0Q/fo5LZH/2Jx0PAmB66qUKs5MLNUXX4QS/PLySMnxt8jLEAnJ6uGKWRcc1lPa
         Ar6QxYL2hemBJpymqKDiSwWio9mCvzAn6MQyRcIInvfOjxsKbUNu3Krb8+CoMhuz171A
         yZEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763485893; x=1764090693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=byGUc9HGj/3i2CsHggKCaH358jeuqsufmI+XZ2QMAYA=;
        b=YYeeMgmRgolUuoOmQngqePZ7WPZgnRWN1kZTKy86M/6CYebuz8azzbtTD0VdzADVSP
         RTrEvlParijaow8DKddJNJYl8M9zvHKW/ubofUs3uMTafWcTYuW2JxaSRgYrbREM3NH0
         8b5KZ/kOrdaow55qMH4Ly/IGRE9bT+jEFxQnBFSwEr/fnYoVYAcNeaHn4J/NtdKMQLMn
         S7od55TKhsz9Kh++jUfdBeKHAWv7+QGokSsSt17Z3DoNKK3aIesIslQUcYTwb/Jes489
         OjHjvDKAeiUXeLHzMWJyuciuug68CoUagiWi/rKVbACJ9xB9Wj+UKiFd6TFEVB5gvxdh
         kc+g==
X-Gm-Message-State: AOJu0Yw80nkyhTsnNvjDRcJi3c3XFFzxtG4c1hX/sfn/8sPiybzYVNvM
	0XBKmPqsR053+87b5T33qkp88wRBd2lNV02pYw7ofXIQygPM5QeeTkqW5l8eG5mZqkf3Lg==
X-Gm-Gg: ASbGnctgyil+6pGiQOp0oWfmKRANTj1xjcnyrqzfc3l0t3W6IRYhEykgd4rSWbXV7yn
	fAaIQke3k+U417C4rCqIh2vnPLfuOIzXW6+wBaAkWk0LYepVxuoPZs2SFouGAwiHxM94B7pxrMn
	6lkYpve3NmgPRSRPM1YamozZ11Nz2k5HWStAbBMsVh7a3GzmXOsv1o2fLiZIFx9lhCuY9wlGym1
	EdjsF9vByMvXNMJ4Vo78jIfGLwrfKe2htGQhpEkpWB40IDpSBa6lByk0hQB35HwMxU/6o/byPp6
	UPqQd212oBDdzkWop0LZeYtAcGNC1NYdd1WyQypApn38wFn6486CC+DnHuUT2imkEY1jRKcMBaQ
	SEPljFHE/4+G8wtOHIhT3JyehnZI41Wqi7JyQzteTf6QbgB4HChMlIUenN00CHoWSLBRDJ7OZ/t
	jGlyaz0b/Eol4QOTTErWkWSArXsV2dBhZ79W1ak4l0egYrJ2zo2bUWjEC1Tl41d03TX4xIPc56s
	GUeWx6uC3ogABW053oZBw6XJHowXyL/
X-Google-Smtp-Source: AGHT+IGlhZ7PFpXe7fJ+Jl6QVx7ClQ5MKi5kL9cv9fTggXll4bf8AE62PIPwe8v3GCpikAO3RwTM7w==
X-Received: by 2002:a05:600c:8b43:b0:477:6e02:54a5 with SMTP id 5b1f17b1804b1-4778fe6098dmr164172415e9.18.1763485892645;
        Tue, 18 Nov 2025 09:11:32 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b103d312sm706385e9.13.2025.11.18.09.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 09:11:32 -0800 (PST)
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
Subject: [PATCH v2 09/10] KVM: nVMX: Use nested context for pfncache persistence
Date: Tue, 18 Nov 2025 17:11:12 +0000
Message-ID: <20251118171113.363528-10-griffoul@gmail.org>
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

Extend the nested context infrastructure to preserve gfn_to_pfn_cache
objects for nested VMX using kvm_nested_context_load() and
kvm_nested_context_clear() functions.

The VMX nested context stores gfn_to_pfn_cache structs for:
- MSR permission bitmaps
- APIC access page
- Virtual APIC page
- Posted interrupt descriptor
- Enlightened VMCS

For traditional nested VMX, those pfn caches are loaded upon 'vmptrld'
instruction emulation and the context is cleared upon 'vmclear'. This
follows the normal L2 vCPU migration sequence of
'vmclear/vmptrld/vmlaunch'.

For enlightened VMCS (eVMCS) support, both functions are called when
detecting a change in the eVMCS GPA, ensuring proper context management
for Hyper-V nested scenarios.

By preserving the gfn_to_pfn_cache objects across L2 context switches,
we avoid costly cache refresh operations, significantly improving nested
virtualization performance for workloads with frequent L2 vCPU
multiplexing on an L1 vCPU or L2 vCPUs migrations between L1 vCPUs.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 arch/x86/kvm/vmx/nested.c | 155 +++++++++++++++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.c    |   8 ++
 arch/x86/kvm/vmx/vmx.h    |  10 +--
 include/linux/kvm_host.h  |   2 +-
 4 files changed, 134 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d910508e3c22..69c3bcb325f1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -226,6 +226,93 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 	vmx->nested.need_vmcs12_to_shadow_sync = false;
 }
 
+struct vmx_nested_context {
+	struct kvm_nested_context base;
+	struct gfn_to_pfn_cache msr_bitmap_cache;
+	struct gfn_to_pfn_cache apic_access_page_cache;
+	struct gfn_to_pfn_cache virtual_apic_cache;
+	struct gfn_to_pfn_cache pi_desc_cache;
+#ifdef CONFIG_KVM_HYPERV
+	struct gfn_to_pfn_cache evmcs_cache;
+#endif
+};
+
+static inline struct vmx_nested_context *to_vmx_nested_context(
+		struct kvm_nested_context *base)
+{
+	return base ? container_of(base, struct vmx_nested_context, base) : NULL;
+}
+
+static struct kvm_nested_context *vmx_nested_context_alloc(struct kvm_vcpu *vcpu)
+{
+	struct vmx_nested_context *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	if (!ctx)
+		return NULL;
+
+	kvm_gpc_init(&ctx->msr_bitmap_cache, vcpu->kvm);
+	kvm_gpc_init_for_vcpu(&ctx->apic_access_page_cache, vcpu);
+	kvm_gpc_init_for_vcpu(&ctx->virtual_apic_cache, vcpu);
+	kvm_gpc_init_for_vcpu(&ctx->pi_desc_cache, vcpu);
+#ifdef CONFIG_KVM_HYPERV
+	kvm_gpc_init(&ctx->evmcs_cache, vcpu->kvm);
+#endif
+	return &ctx->base;
+}
+
+static void vmx_nested_context_reset(struct kvm_nested_context *base)
+{
+	/*
+	 * Skip pfncache reinitialization: active ones will be refreshed on
+	 * access.
+	 */
+}
+
+static void vmx_nested_context_free(struct kvm_nested_context *base)
+{
+	struct vmx_nested_context *ctx = to_vmx_nested_context(base);
+
+	kvm_gpc_deactivate(&ctx->pi_desc_cache);
+	kvm_gpc_deactivate(&ctx->virtual_apic_cache);
+	kvm_gpc_deactivate(&ctx->apic_access_page_cache);
+	kvm_gpc_deactivate(&ctx->msr_bitmap_cache);
+#ifdef CONFIG_KVM_HYPERV
+	kvm_gpc_deactivate(&ctx->evmcs_cache);
+#endif
+	kfree(ctx);
+}
+
+static void vmx_nested_context_load(struct vcpu_vmx *vmx, gpa_t vmptr)
+{
+	struct vmx_nested_context *ctx;
+
+	ctx = to_vmx_nested_context(kvm_nested_context_load(&vmx->vcpu, vmptr));
+	if (!ctx) {
+		/*
+		 * The cache could not be allocated. In the unlikely case of no
+		 * available memory, an error will be returned to L1 when
+		 * mapping the vmcs12 pages. More likely the current pfncaches
+		 * will be reused (and refreshed since their GPAs do not
+		 * match).
+		 */
+		return;
+	}
+
+	vmx->nested.msr_bitmap_cache = &ctx->msr_bitmap_cache;
+	vmx->nested.apic_access_page_cache = &ctx->apic_access_page_cache;
+	vmx->nested.virtual_apic_cache = &ctx->virtual_apic_cache;
+	vmx->nested.pi_desc_cache = &ctx->pi_desc_cache;
+#ifdef CONFIG_KVM_HYPERV
+	vmx->nested.hv_evmcs_cache = &ctx->evmcs_cache;
+#endif
+}
+
+static void vmx_nested_context_clear(struct vcpu_vmx *vmx, gpa_t vmptr)
+{
+	kvm_nested_context_clear(&vmx->vcpu, vmptr);
+}
+
 static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_KVM_HYPERV
@@ -325,6 +412,9 @@ static int nested_gpc_lock(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
 
 	if (!PAGE_ALIGNED(gpa))
 		return -EINVAL;
+
+	if (WARN_ON_ONCE(!gpc))
+		return -ENOENT;
 retry:
 	read_lock(&gpc->lock);
 	if (!kvm_gpc_check(gpc, PAGE_SIZE) || (gpc->gpa != gpa)) {
@@ -387,14 +477,6 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	vmx->nested.smm.vmxon = false;
 	vmx->nested.vmxon_ptr = INVALID_GPA;
 
-	kvm_gpc_deactivate(&vmx->nested.pi_desc_cache);
-	kvm_gpc_deactivate(&vmx->nested.virtual_apic_cache);
-	kvm_gpc_deactivate(&vmx->nested.apic_access_page_cache);
-	kvm_gpc_deactivate(&vmx->nested.msr_bitmap_cache);
-#ifdef CONFIG_KVM_HYPERV
-	kvm_gpc_deactivate(&vmx->nested.hv_evmcs_cache);
-#endif
-
 	free_vpid(vmx->nested.vpid02);
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = INVALID_GPA;
@@ -697,7 +779,7 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 			return true;
 	}
 
-	gpc = &vmx->nested.msr_bitmap_cache;
+	gpc = vmx->nested.msr_bitmap_cache;
 	if (nested_gpc_lock(gpc, vmcs12->msr_bitmap))
 		return false;
 
@@ -2188,7 +2270,13 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 		return EVMPTRLD_DISABLED;
 	}
 
-	gpc = &vmx->nested.hv_evmcs_cache;
+	if (evmcs_gpa != vmx->nested.hv_evmcs_vmptr) {
+		vmx_nested_context_clear(vmx, vmx->nested.hv_evmcs_vmptr);
+		vmx_nested_context_load(vmx, evmcs_gpa);
+		evmcs_gpa_changed = true;
+	}
+
+	gpc = vmx->nested.hv_evmcs_cache;
 	if (nested_gpc_lock(gpc, evmcs_gpa)) {
 		nested_release_evmcs(vcpu);
 		return EVMPTRLD_ERROR;
@@ -2196,9 +2284,8 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 
 	evmcs = gpc->khva;
 
-	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
+	if (evmcs_gpa_changed) {
 		vmx->nested.current_vmptr = INVALID_GPA;
-
 		nested_release_evmcs(vcpu);
 
 		/*
@@ -2232,7 +2319,6 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 
 		vmx->nested.hv_evmcs_vmptr = evmcs_gpa;
 
-		evmcs_gpa_changed = true;
 		/*
 		 * Unlike normal vmcs12, enlightened vmcs12 is not fully
 		 * reloaded from guest's memory (read only fields, fields not
@@ -3540,7 +3626,7 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 
 
 	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
-		gpc = &vmx->nested.apic_access_page_cache;
+		gpc = vmx->nested.apic_access_page_cache;
 
 		if (!nested_gpc_hpa(gpc, vmcs12->apic_access_addr, &hpa)) {
 			vmcs_write64(APIC_ACCESS_ADDR, hpa);
@@ -3556,7 +3642,7 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	}
 
 	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
-		gpc = &vmx->nested.virtual_apic_cache;
+		gpc = vmx->nested.virtual_apic_cache;
 
 		if (!nested_gpc_hpa(gpc, vmcs12->virtual_apic_page_addr, &hpa)) {
 			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, hpa);
@@ -3582,7 +3668,7 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	}
 
 	if (nested_cpu_has_posted_intr(vmcs12)) {
-		gpc = &vmx->nested.pi_desc_cache;
+		gpc = vmx->nested.pi_desc_cache;
 
 		if (!nested_gpc_hpa(gpc, vmcs12->posted_intr_desc_addr & PAGE_MASK, &hpa)) {
 			vmx->nested.pi_desc_offset = offset_in_page(vmcs12->posted_intr_desc_addr);
@@ -3642,9 +3728,9 @@ static bool vmx_is_nested_state_invalid(struct kvm_vcpu *vcpu)
 	 * locks. Since kvm_gpc_invalid() doesn't verify gpc memslot
 	 * generation, we can also skip acquiring the srcu lock.
 	 */
-	return kvm_gpc_invalid(&vmx->nested.apic_access_page_cache) ||
-		kvm_gpc_invalid(&vmx->nested.virtual_apic_cache) ||
-		kvm_gpc_invalid(&vmx->nested.pi_desc_cache);
+	return kvm_gpc_invalid(vmx->nested.apic_access_page_cache) ||
+		kvm_gpc_invalid(vmx->nested.virtual_apic_cache) ||
+		kvm_gpc_invalid(vmx->nested.pi_desc_cache);
 }
 
 static int nested_vmx_write_pml_buffer(struct kvm_vcpu *vcpu, gpa_t gpa)
@@ -4140,6 +4226,8 @@ void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
 
 static void *nested_gpc_lock_if_active(struct gfn_to_pfn_cache *gpc)
 {
+	if (!gpc)
+		return NULL;
 retry:
 	read_lock(&gpc->lock);
 	if (!gpc->active) {
@@ -4160,12 +4248,12 @@ static void *nested_gpc_lock_if_active(struct gfn_to_pfn_cache *gpc)
 #ifdef CONFIG_KVM_HYPERV
 struct hv_enlightened_vmcs *nested_lock_evmcs(struct vcpu_vmx *vmx)
 {
-	return nested_gpc_lock_if_active(&vmx->nested.hv_evmcs_cache);
+	return nested_gpc_lock_if_active(vmx->nested.hv_evmcs_cache);
 }
 
 void nested_unlock_evmcs(struct vcpu_vmx *vmx)
 {
-	nested_gpc_unlock(&vmx->nested.hv_evmcs_cache);
+	nested_gpc_unlock(vmx->nested.hv_evmcs_cache);
 }
 #endif
 
@@ -4173,7 +4261,7 @@ static struct pi_desc *nested_lock_pi_desc(struct vcpu_vmx *vmx)
 {
 	u8 *pi_desc_page;
 
-	pi_desc_page = nested_gpc_lock_if_active(&vmx->nested.pi_desc_cache);
+	pi_desc_page = nested_gpc_lock_if_active(vmx->nested.pi_desc_cache);
 	if (!pi_desc_page)
 		return NULL;
 
@@ -4182,17 +4270,17 @@ static struct pi_desc *nested_lock_pi_desc(struct vcpu_vmx *vmx)
 
 static void nested_unlock_pi_desc(struct vcpu_vmx *vmx)
 {
-	nested_gpc_unlock(&vmx->nested.pi_desc_cache);
+	nested_gpc_unlock(vmx->nested.pi_desc_cache);
 }
 
 static void *nested_lock_vapic(struct vcpu_vmx *vmx)
 {
-	return nested_gpc_lock_if_active(&vmx->nested.virtual_apic_cache);
+	return nested_gpc_lock_if_active(vmx->nested.virtual_apic_cache);
 }
 
 static void nested_unlock_vapic(struct vcpu_vmx *vmx)
 {
-	nested_gpc_unlock(&vmx->nested.virtual_apic_cache);
+	nested_gpc_unlock(vmx->nested.virtual_apic_cache);
 }
 
 static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
@@ -5651,16 +5739,6 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 		      HRTIMER_MODE_ABS_PINNED);
 
 	vmx->nested.vpid02 = allocate_vpid();
-
-	kvm_gpc_init(&vmx->nested.msr_bitmap_cache, vcpu->kvm);
-
-	kvm_gpc_init_for_vcpu(&vmx->nested.apic_access_page_cache, vcpu);
-	kvm_gpc_init_for_vcpu(&vmx->nested.virtual_apic_cache, vcpu);
-	kvm_gpc_init_for_vcpu(&vmx->nested.pi_desc_cache, vcpu);
-
-#ifdef CONFIG_KVM_HYPERV
-	kvm_gpc_init(&vmx->nested.hv_evmcs_cache, vcpu->kvm);
-#endif
 	vmx->nested.vmcs02_initialized = false;
 	vmx->nested.vmxon = true;
 
@@ -5856,6 +5934,8 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 					   &zero, sizeof(zero));
 	}
 
+	vmx_nested_context_clear(vmx, vmptr);
+
 	return nested_vmx_succeed(vcpu);
 }
 
@@ -6100,6 +6180,8 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
 	}
 	vmx->nested.dirty_vmcs12 = true;
 	vmx->nested.force_msr_bitmap_recalc = true;
+
+	vmx_nested_context_load(vmx, vmptr);
 }
 
 /* Emulate the VMPTRLD instruction */
@@ -7689,4 +7771,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.get_evmcs_version = nested_get_evmcs_version,
 	.hv_inject_synthetic_vmexit_post_tlb_flush = vmx_hv_inject_synthetic_vmexit_post_tlb_flush,
 #endif
+	.alloc_context = vmx_nested_context_alloc,
+	.free_context = vmx_nested_context_free,
+	.reset_context = vmx_nested_context_reset,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 546272a5d34d..30b13241ae45 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7666,6 +7666,14 @@ int vmx_vm_init(struct kvm *kvm)
 
 	if (enable_pml)
 		kvm->arch.cpu_dirty_log_size = PML_LOG_NR_ENTRIES;
+
+	if (nested) {
+		int err;
+
+		err = kvm_nested_context_table_init(kvm);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4da5a42b0c60..56b96e50290f 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -152,15 +152,15 @@ struct nested_vmx {
 
 	struct loaded_vmcs vmcs02;
 
-	struct gfn_to_pfn_cache msr_bitmap_cache;
+	struct gfn_to_pfn_cache *msr_bitmap_cache;
 
 	/*
 	 * Guest pages referred to in the vmcs02 with host-physical
 	 * pointers, so we must keep them pinned while L2 runs.
 	 */
-	struct gfn_to_pfn_cache apic_access_page_cache;
-	struct gfn_to_pfn_cache virtual_apic_cache;
-	struct gfn_to_pfn_cache pi_desc_cache;
+	struct gfn_to_pfn_cache *apic_access_page_cache;
+	struct gfn_to_pfn_cache *virtual_apic_cache;
+	struct gfn_to_pfn_cache *pi_desc_cache;
 
 	u64 pi_desc_offset;
 	bool pi_pending;
@@ -208,7 +208,7 @@ struct nested_vmx {
 	u32 hv_clean_fields;
 	bool hv_msr_bitmap;
 	bool hv_flush_hypercall;
-	struct gfn_to_pfn_cache hv_evmcs_cache;
+	struct gfn_to_pfn_cache *hv_evmcs_cache;
 #endif
 };
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b05aace9e295..97e0b949e412 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1533,7 +1533,7 @@ static inline bool kvm_gpc_is_hva_active(struct gfn_to_pfn_cache *gpc)
 
 static inline bool kvm_gpc_invalid(struct gfn_to_pfn_cache *gpc)
 {
-	return gpc->active && !gpc->valid;
+	return gpc && gpc->active && !gpc->valid;
 }
 
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
-- 
2.43.0


