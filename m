Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33770433A81
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 17:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhJSPeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 11:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232993AbhJSPek (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 11:34:40 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF44FC06161C
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:32:27 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so156311pjb.1
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 08:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RQ5gPL9YBi9VpkmoB86UIefwYgY9AEoD4NTxlPGW5Po=;
        b=C4vo72T5POEw+H1P2o+dOlVB4S0DBthbiZkPKw7PAcPg1WktHOeaOfYYuy9BeUxwJL
         1Ri1/9A23hRNCJVeBmYA1doE92wDCool9nvueiRiJq3N9PjXGLMFA8tANfwv8n2s0xDM
         Za34yRGe7h8o48xz+6f+J+ku2thhIc8iYAdhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RQ5gPL9YBi9VpkmoB86UIefwYgY9AEoD4NTxlPGW5Po=;
        b=xAFZVskw9hENEF4U2rwgNgsiB5j4/v2h6/D05BAfOqnpP5UC5AerU8hhx6BqBGw/wm
         GUJb8BTqMdrUI4s2qv8woT3xPR8ZYA8qAY77M3fgXHqu73x7Aedso61spC2cvOLJ7OHW
         kIG7JwxeaGPAkSoxH6PdaA2w3Gpz7ZvXTE9cAXm49BCwkJECozmpxgyrw66dunKtGR6n
         6loEv9TvksC71aXEg+2nMpNGD1IWRBE6zPDTApiAf5lyeGRbfhFjDK9nf6bH74U4VjlY
         wvpTel6ZYqBPpiFpDWh/pORI6iR2gBKMqd8gqIFfrdVMC/j+ZvEeY8L+5+A1+XdW2QLv
         0XHQ==
X-Gm-Message-State: AOAM533mr65c1h622RKZzzyhuscd8RpfbeWgCWtfl9qZLdEJU8k+NODH
        J3CKjuDhIuXZML0p9Bl42QBmYw==
X-Google-Smtp-Source: ABdhPJxFKAFKZtkm2lV5E4kAQy5/TPdl5XJuZFh7JgaM2Z66BpMBwxKLPtwLkswI52R3QCVNoItFDQ==
X-Received: by 2002:a17:90b:4014:: with SMTP id ie20mr690360pjb.146.1634657547263;
        Tue, 19 Oct 2021 08:32:27 -0700 (PDT)
Received: from senozhatsky.flets-east.jp ([2409:10:2e40:5100:490f:f89:7449:e615])
        by smtp.gmail.com with ESMTPSA id v8sm3087474pjd.7.2021.10.19.08.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 08:32:26 -0700 (PDT)
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suleiman Souhlal <suleiman@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHV2 1/3] KVM: x86: introduce kvm_mmu_pte_prefetch structure
Date:   Wed, 20 Oct 2021 00:32:12 +0900
Message-Id: <20211019153214.109519-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211019153214.109519-1-senozhatsky@chromium.org>
References: <20211019153214.109519-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_mmu_pte_prefetch is a per-VCPU structure that holds a PTE
prefetch pages array, lock and the number of PTE to prefetch.

This is needed to turn PTE_PREFETCH_NUM into a tunable VM
parameter.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 arch/x86/include/asm/kvm_host.h | 12 +++++++
 arch/x86/kvm/mmu.h              |  4 +++
 arch/x86/kvm/mmu/mmu.c          | 57 ++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.c              |  9 +++++-
 4 files changed, 77 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5271fce6cd65..11400bc3c70d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -607,6 +607,16 @@ struct kvm_vcpu_xen {
 	u64 runstate_times[4];
 };
 
+struct kvm_mmu_pte_prefetch {
+	/*
+	 * This will be cast either to array of pointers to struct page,
+	 * or array of u64, or array of u32
+	 */
+	void *ents;
+	unsigned int num_ents;
+	spinlock_t lock;
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -682,6 +692,8 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
 
+	struct kvm_mmu_pte_prefetch mmu_pte_prefetch;
+
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
 	 * In vcpu_run, we switch between the user and guest FPU contexts.
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 75367af1a6d3..b953a3a4083a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -68,6 +68,10 @@ static __always_inline u64 rsvd_bits(int s, int e)
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
 
+int kvm_set_pte_prefetch(struct kvm_vcpu *vcpu, u64 num_ents);
+int kvm_init_pte_prefetch(struct kvm_vcpu *vcpu);
+void kvm_pte_prefetch_destroy(struct kvm_vcpu *vcpu);
+
 void kvm_init_mmu(struct kvm_vcpu *vcpu);
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 			     unsigned long cr4, u64 efer, gpa_t nested_cr3);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24a9f4c3f5e7..fed3a498a729 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -115,6 +115,7 @@ module_param(dbg, bool, 0644);
 #endif
 
 #define PTE_PREFETCH_NUM		8
+#define MAX_PTE_PREFETCH_NUM		128
 
 #define PT32_LEVEL_BITS 10
 
@@ -732,7 +733,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 
 	/* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
+				       1 + PT64_ROOT_MAX_LEVEL + MAX_PTE_PREFETCH_NUM);
 	if (r)
 		return r;
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
@@ -2753,12 +2754,13 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp,
 				    u64 *start, u64 *end)
 {
-	struct page *pages[PTE_PREFETCH_NUM];
+	struct page **pages;
 	struct kvm_memory_slot *slot;
 	unsigned int access = sp->role.access;
 	int i, ret;
 	gfn_t gfn;
 
+	pages = (struct page **)vcpu->arch.mmu_pte_prefetch.ents;
 	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
 	if (!slot)
@@ -2781,14 +2783,17 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp, u64 *sptep)
 {
 	u64 *spte, *start = NULL;
+	unsigned int pte_prefetch_num;
 	int i;
 
 	WARN_ON(!sp->role.direct);
 
-	i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
+	spin_lock(&vcpu->arch.mmu_pte_prefetch.lock);
+	pte_prefetch_num = vcpu->arch.mmu_pte_prefetch.num_ents;
+	i = (sptep - sp->spt) & ~(pte_prefetch_num - 1);
 	spte = sp->spt + i;
 
-	for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
+	for (i = 0; i < pte_prefetch_num; i++, spte++) {
 		if (is_shadow_present_pte(*spte) || spte == sptep) {
 			if (!start)
 				continue;
@@ -2800,6 +2805,7 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 	}
 	if (start)
 		direct_pte_prefetch_many(vcpu, sp, start, spte);
+	spin_unlock(&vcpu->arch.mmu_pte_prefetch.lock);
 }
 
 static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
@@ -4914,6 +4920,49 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_init_mmu);
 
+int kvm_set_pte_prefetch(struct kvm_vcpu *vcpu, u64 num_ents)
+{
+	u64 *ents;
+
+	if (!num_ents)
+		return -EINVAL;
+
+	if (!is_power_of_2(num_ents))
+		return -EINVAL;
+
+	if (num_ents > MAX_PTE_PREFETCH_NUM)
+		return -EINVAL;
+
+	ents = kmalloc_array(num_ents, sizeof(u64), GFP_KERNEL);
+	if (!ents)
+		return -ENOMEM;
+
+	spin_lock(&vcpu->arch.mmu_pte_prefetch.lock);
+	kfree(vcpu->arch.mmu_pte_prefetch.ents);
+	vcpu->arch.mmu_pte_prefetch.ents = ents;
+	vcpu->arch.mmu_pte_prefetch.num_ents = num_ents;
+	spin_unlock(&vcpu->arch.mmu_pte_prefetch.lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_set_pte_prefetch);
+
+int kvm_init_pte_prefetch(struct kvm_vcpu *vcpu)
+{
+	spin_lock_init(&vcpu->arch.mmu_pte_prefetch.lock);
+
+	return kvm_set_pte_prefetch(vcpu, PTE_PREFETCH_NUM);
+}
+EXPORT_SYMBOL_GPL(kvm_init_pte_prefetch);
+
+void kvm_pte_prefetch_destroy(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.mmu_pte_prefetch.num_ents = 0;
+	kfree(vcpu->arch.mmu_pte_prefetch.ents);
+	vcpu->arch.mmu_pte_prefetch.ents = NULL;
+}
+EXPORT_SYMBOL_GPL(kvm_pte_prefetch_destroy);
+
 static union kvm_mmu_page_role
 kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0f99132d7d1..4805960a89e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10707,10 +10707,14 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
 #endif
 
-	r = static_call(kvm_x86_vcpu_create)(vcpu);
+	r = kvm_init_pte_prefetch(vcpu);
 	if (r)
 		goto free_guest_fpu;
 
+	r = static_call(kvm_x86_vcpu_create)(vcpu);
+	if (r)
+		goto free_pte_prefetch;
+
 	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
 	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
 	kvm_vcpu_mtrr_init(vcpu);
@@ -10721,6 +10725,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 	return 0;
 
+free_pte_prefetch:
+	kvm_pte_prefetch_destroy(vcpu);
 free_guest_fpu:
 	kvm_free_guest_fpu(vcpu);
 free_user_fpu:
@@ -10782,6 +10788,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_free_lapic(vcpu);
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	kvm_mmu_destroy(vcpu);
+	kvm_pte_prefetch_destroy(vcpu);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 	free_page((unsigned long)vcpu->arch.pio_data);
 	kvfree(vcpu->arch.cpuid_entries);
-- 
2.33.0.1079.g6e70778dc9-goog

