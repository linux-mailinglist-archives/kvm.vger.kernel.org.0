Return-Path: <kvm+bounces-66940-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C217CEEC39
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 15:30:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EBB273037501
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 14:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ECB0313294;
	Fri,  2 Jan 2026 14:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JyYpV6Mh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D82313E0F
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767363894; cv=none; b=TXhxJ2ONd5pZzxh4SxFUSPtXE3u+wSWxJDreUHei45GWQyn0SasgKEf4ZErb4omY8mmXu4D4OU8l37eA92q16T8xpmZrJacCdBFQzDINHIHlOKHpcdfV516qzQZjxNZpLDo7deswMRugXIhrCfkXaPa/NsgeZ/boYUmsoGP16wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767363894; c=relaxed/simple;
	bh=FoNbbJ9F0pyN5tqBx0h8/NgibhdggOQQVuoSB0kBTd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toeGCKlLtiaywAlU27L5dcMTqghPYRwECoZqnffJ/EGs0ynEECvC8rsOE+LscUAIWVGC79VF+HfbQqEX0JbIvlfI1W4TU1dMb2uZ8xDnwA34m12QCa7AicZRNIsAipmJ3UedfmmorEEzl3BnjiauwJoZOPnAiAKGruGKp0CAGBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JyYpV6Mh; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-477bf34f5f5so89246795e9.0
        for <kvm@vger.kernel.org>; Fri, 02 Jan 2026 06:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767363887; x=1767968687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XiUYMJfGEKC2ACeTET/oyVJd7iJ5Y/n6NYl5SeLTv2E=;
        b=JyYpV6MhK3sIqv2H+CRouj1ucklq6VXEOOBBOP4dDxL/TSio6MDQrp09OZpmNREQEr
         197ds8Ua6RRKXD4DvBCVG7qR+O51bvEQzmd/cYXFkNiEfH/LQDLzVvl/T2LM0AAaNd4Q
         ByVH9wWxb8pUBEgq5ef1cjWfGcfm3uST8Mx/S1jWA73EFOrCT/4iaZ6YqJnXXUzrlKfz
         q3HAdsAj7mstQ+A9/sdUF7ZI/zBxRMeYZylmoaWUlNstVLJa+Z3KXrJV9VGNTmxn4irG
         x4HhOaRpY9dmOGfALwIK+B2oMMF/d2oylpoM4np2RlESIp8gmKLQadEAtbp5m9qUGPyp
         9S1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767363887; x=1767968687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XiUYMJfGEKC2ACeTET/oyVJd7iJ5Y/n6NYl5SeLTv2E=;
        b=bTXL0kS9zC5FsWKKIxQ8ayCX+nvUlfVy4aAZVp5Xb6A0eDvHH/9/gbLf47YblepPQ0
         qV1GVKHqWHuMmhmlyzjHydmnyGbIsJ7YnN3qPH6Uk5vPupQjHfNI3HAyHlJUOmVs3fCk
         FX79Gb2iBThNtiTyle1tMTcVF7xFvbMBj/+MPBdZibGnTM20FecBq+SzyAz/JDa74OOr
         SalWP762/5mTvxkGxYZMYzfQ4A+N6l4lUTf3HxhDSrL3K1H9jaeMjpBpYxn8Ex6DksWf
         LXBQWhbWeG8Q1srGhkHhtsDx46WvgEC77pfrvcQ/MZ2ciu8S5+POn8c840CBRPXm1HKH
         EINg==
X-Gm-Message-State: AOJu0YxqLgbfCXFi6TFv0CnXx/cJpp19Z80j252gWRHLLTZws2aty38M
	8iCuPM8D0WSGmr24I+4NrMUDrMsaKDH+17xqIBUEK9aaPHvekga2XIS3J4PhPTLW+Js=
X-Gm-Gg: AY/fxX5xGQjwD6yuwEoZubTe8m+3jAw/R2Ky1kRajv53tvRY+CoZHzpWOHXWrNcrzmq
	Xv+xD15PKtW4CWee7zae7oJKJ/yocEhS4aHgJ0dsZ/kV2Hnow2Om9gve+o+OfpkgOWodlTDJgwd
	gRvgcnwRByaymuoWdjLR9V02WH/D8YYpEIDueG/pORBbNGH5P3g4k7xQjHY4JYW9ZLxG6F2nMXX
	SO++jXCYXAtK2ia4igSAxQWrTjAkEnmy8i0X5+uoHzfq9tV55I8U/rnkLJAh4hFUfMH1l2Ztm5K
	DZYlKRBYy5XPh8xdpwExH6FZ9cTnwASjriHHyMaWamZZ6IEPxuTRtu+XsXNrIyEZzAN0+Hg+9GD
	78kIrwctUXIBE10q1hG6X1kaAkiifkjqBmg7ABsZpeuchH0qhykwPPe1oG4dksve33OoAY4rH8W
	SUoutImVjC4P1exziwGK6uVWRu5abaQuk9D5N/7rKQOno+TuBQ8zK8W0LeZCh4aR6KFNaRPzkEn
	Y4Wdel778qS92lyEz/iR5MIhsVXs7w+/m8/Xbuk+oo=
X-Google-Smtp-Source: AGHT+IFIlnd8jb489tgvwZ43xt85NzKaT5sPQjDNt7EYNjor6K+UlgjxmqV1LMTRBhb958/bkQNgQw==
X-Received: by 2002:a05:600c:a012:b0:47a:940a:c972 with SMTP id 5b1f17b1804b1-47d1955b72emr564528905e9.4.1767363887342;
        Fri, 02 Jan 2026 06:24:47 -0800 (PST)
Received: from ip-10-0-150-200.eu-west-1.compute.internal (ec2-52-49-196-232.eu-west-1.compute.amazonaws.com. [52.49.196.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be27b0d5asm806409235e9.13.2026.01.02.06.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 06:24:46 -0800 (PST)
From: Fred Griffoul <griffoul@gmail.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	vkuznets@redhat.com,
	shuah@kernel.org,
	dwmw@amazon.co.uk,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fred Griffoul <fgriffo@amazon.co.uk>
Subject: [PATCH v4 09/10] KVM: nVMX: Use nested context for pfncache persistence
Date: Fri,  2 Jan 2026 14:24:28 +0000
Message-ID: <20260102142429.896101-10-griffoul@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260102142429.896101-1-griffoul@gmail.com>
References: <20260102142429.896101-1-griffoul@gmail.com>
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
 arch/x86/kvm/vmx/nested.c | 176 ++++++++++++++++++++++++++++++--------
 arch/x86/kvm/vmx/vmx.c    |   8 ++
 arch/x86/kvm/vmx/vmx.h    |  10 +--
 include/linux/kvm_host.h  |   2 +-
 4 files changed, 152 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 491472ca825b..6895efecb4fc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -227,6 +227,93 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
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
@@ -320,14 +407,23 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 /*
  * Maps a single guest page starting at @gpa and lock the cache for access.
  */
-static int nested_gpc_lock(struct gfn_to_pfn_cache *gpc, gpa_t gpa)
+static int nested_gpc_lock(struct kvm_vcpu *vcpu, struct gfn_to_pfn_cache *gpc,
+			   gpa_t gpa)
 {
 	int err;
 
 	if (!PAGE_ALIGNED(gpa))
 		return -EINVAL;
+
+	if (WARN_ON_ONCE(!gpc))
+		return -ENOENT;
 retry:
 	read_lock(&gpc->lock);
+
+	/* Update vcpu if gpc was recycled */
+	if (gpc->vcpu && gpc->vcpu != vcpu)
+		gpc->vcpu = vcpu;
+
 	if (!kvm_gpc_check(gpc, PAGE_SIZE) || (gpc->gpa != gpa)) {
 		read_unlock(&gpc->lock);
 		err = kvm_gpc_activate(gpc, gpa, PAGE_SIZE);
@@ -355,11 +451,12 @@ static void nested_gpc_unlock(struct gfn_to_pfn_cache *gpc)
 	read_unlock(&gpc->lock);
 }
 
-static int nested_gpc_hpa(struct gfn_to_pfn_cache *gpc, gpa_t gpa, hpa_t *hpa)
+static int nested_gpc_hpa(struct kvm_vcpu *vcpu, struct gfn_to_pfn_cache *gpc,
+			  gpa_t gpa, hpa_t *hpa)
 {
 	int err;
 
-	err = nested_gpc_lock(gpc, gpa);
+	err = nested_gpc_lock(vcpu, gpc, gpa);
 	if (err)
 		return err;
 
@@ -427,6 +524,15 @@ static void nested_unlock_vapic(struct vcpu_vmx *vmx)
 	nested_gpc_unlock(vmx->nested.virtual_apic_cache);
 }
 
+static u64 nested_vmptr(struct vcpu_vmx *vmx)
+{
+#ifdef CONFIG_KVM_HYPERV
+	if (nested_vmx_is_evmptr12_valid(vmx))
+		return vmx->nested.hv_evmcs_vmptr;
+#endif
+	return vmx->nested.current_vmptr;
+}
+
 /*
  * Free whatever needs to be freed from vmx->nested when L1 goes down, or
  * just stops using VMX.
@@ -443,18 +549,12 @@ static void free_nested(struct kvm_vcpu *vcpu)
 
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
+	vmx_nested_context_clear(vmx, nested_vmptr(vmx));
+
 	vmx->nested.vmxon = false;
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
@@ -760,8 +860,8 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 			return true;
 	}
 
-	gpc = &vmx->nested.msr_bitmap_cache;
-	if (nested_gpc_lock(gpc, vmcs12->msr_bitmap))
+	gpc = vmx->nested.msr_bitmap_cache;
+	if (nested_gpc_lock(vcpu, gpc, vmcs12->msr_bitmap))
 		return false;
 
 	msr_bitmap_l1 = (unsigned long *)gpc->khva;
@@ -2249,17 +2349,22 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 		return EVMPTRLD_DISABLED;
 	}
 
-	gpc = &vmx->nested.hv_evmcs_cache;
-	if (nested_gpc_lock(gpc, evmcs_gpa)) {
+	if (evmcs_gpa != vmx->nested.hv_evmcs_vmptr) {
+		vmx_nested_context_clear(vmx, vmx->nested.hv_evmcs_vmptr);
+		vmx_nested_context_load(vmx, evmcs_gpa);
+		evmcs_gpa_changed = true;
+	}
+
+	gpc = vmx->nested.hv_evmcs_cache;
+	if (nested_gpc_lock(vcpu, gpc, evmcs_gpa)) {
 		nested_release_evmcs(vcpu);
 		return EVMPTRLD_ERROR;
 	}
 
 	evmcs = gpc->khva;
 
-	if (unlikely(evmcs_gpa != vmx->nested.hv_evmcs_vmptr)) {
+	if (evmcs_gpa_changed) {
 		vmx->nested.current_vmptr = INVALID_GPA;
-
 		nested_release_evmcs(vcpu);
 
 		/*
@@ -2293,7 +2398,6 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 
 		vmx->nested.hv_evmcs_vmptr = evmcs_gpa;
 
-		evmcs_gpa_changed = true;
 		/*
 		 * Unlike normal vmcs12, enlightened vmcs12 is not fully
 		 * reloaded from guest's memory (read only fields, fields not
@@ -3557,9 +3661,9 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 
 
 	if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES)) {
-		gpc = &vmx->nested.apic_access_page_cache;
+		gpc = vmx->nested.apic_access_page_cache;
 
-		if (!nested_gpc_hpa(gpc, vmcs12->apic_access_addr, &hpa)) {
+		if (!nested_gpc_hpa(vcpu, gpc, vmcs12->apic_access_addr, &hpa)) {
 			vmcs_write64(APIC_ACCESS_ADDR, hpa);
 		} else {
 			pr_debug_ratelimited("%s: no backing for APIC-access address in vmcs12\n",
@@ -3573,9 +3677,9 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	}
 
 	if (nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW)) {
-		gpc = &vmx->nested.virtual_apic_cache;
+		gpc = vmx->nested.virtual_apic_cache;
 
-		if (!nested_gpc_hpa(gpc, vmcs12->virtual_apic_page_addr, &hpa)) {
+		if (!nested_gpc_hpa(vcpu, gpc, vmcs12->virtual_apic_page_addr, &hpa)) {
 			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, hpa);
 		} else if (nested_cpu_has(vmcs12, CPU_BASED_CR8_LOAD_EXITING) &&
 		           nested_cpu_has(vmcs12, CPU_BASED_CR8_STORE_EXITING) &&
@@ -3599,9 +3703,9 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 	}
 
 	if (nested_cpu_has_posted_intr(vmcs12)) {
-		gpc = &vmx->nested.pi_desc_cache;
+		gpc = vmx->nested.pi_desc_cache;
 
-		if (!nested_gpc_hpa(gpc, vmcs12->posted_intr_desc_addr & PAGE_MASK, &hpa)) {
+		if (!nested_gpc_hpa(vcpu, gpc, vmcs12->posted_intr_desc_addr & PAGE_MASK, &hpa)) {
 			vmx->nested.pi_desc_offset = offset_in_page(vmcs12->posted_intr_desc_addr);
 			vmcs_write64(POSTED_INTR_DESC_ADDR,
 				     hpa + offset_in_page(vmcs12->posted_intr_desc_addr));
@@ -3659,9 +3763,9 @@ static bool vmx_is_nested_state_invalid(struct kvm_vcpu *vcpu)
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
@@ -4129,7 +4233,6 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 	}
 }
 
-
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -5608,16 +5711,6 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
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
 
@@ -5813,6 +5906,8 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 					   &zero, sizeof(zero));
 	}
 
+	vmx_nested_context_clear(vmx, vmptr);
+
 	return nested_vmx_succeed(vcpu);
 }
 
@@ -6057,6 +6152,8 @@ static void set_current_vmptr(struct vcpu_vmx *vmx, gpa_t vmptr)
 	}
 	vmx->nested.dirty_vmcs12 = true;
 	vmx->nested.force_msr_bitmap_recalc = true;
+
+	vmx_nested_context_load(vmx, vmptr);
 }
 
 /* Emulate the VMPTRLD instruction */
@@ -7654,4 +7751,7 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.get_evmcs_version = nested_get_evmcs_version,
 	.hv_inject_synthetic_vmexit_post_tlb_flush = vmx_hv_inject_synthetic_vmexit_post_tlb_flush,
 #endif
+	.alloc_context = vmx_nested_context_alloc,
+	.free_context = vmx_nested_context_free,
+	.reset_context = vmx_nested_context_reset,
 };
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6b96f7aea20b..7f8ebfd478e1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7709,6 +7709,14 @@ int vmx_vm_init(struct kvm *kvm)
 
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
index 5517d68872f0..7c983c610613 100644
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
index c0c0dcedb59c..d612180febb8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1543,7 +1543,7 @@ static inline bool kvm_gpc_is_hva_active(struct gfn_to_pfn_cache *gpc)
 
 static inline bool kvm_gpc_invalid(struct gfn_to_pfn_cache *gpc)
 {
-	return gpc->active && !gpc->valid;
+	return gpc && gpc->active && !gpc->valid;
 }
 
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
-- 
2.43.0


