Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0CE50C723
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 06:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbiDWDvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232789AbiDWDvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:21 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A4B1C45B8
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:23 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d6-20020aa78686000000b0050adc2b200cso4681017pfo.21
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RxFR1mf00mKdP3w8SqK2ejHHgn+MhCaTObKpuTFI/vM=;
        b=UcSm2gQUKYPN/4Eo6y24/YtvtXFOCcr1DyaMtZvO97RFpSFLFjwK2SCcIu1BmrBI5z
         ttapLMuLIA4u6/i1bT34VblsLeJtOEamEXThcL6LAnNy/Eumh9fBzBuxzdyrzJeR9DQ7
         YKEBMqH5ut9pN5xxZOH7/JAk1n6fwx5M41Z6f5Dke1d3lV7XanMzUS5aSIgCqUH+5+Od
         /1DW3jY7kV6VmmMEQuOciL7EPN23wt+px9kuAbykSX3P9CB5O5HVaiCSqX6sHiIKYlQk
         SB7b9gzhScOiDXAu5MlCrFgw2+mK3YUmDbkRfrrQbsv4QDfx1/9fz9sP62r/EQjXDdSi
         OMoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RxFR1mf00mKdP3w8SqK2ejHHgn+MhCaTObKpuTFI/vM=;
        b=XmOIdRa9IAvdjquxI3iqvBWZcVjXsACXDCA7K1KkleQC0mGuAQ74EB7M15+GO0Opp7
         CiWfqjKrLfaCRDdSq0wBfFM3dB0FErHxMuhepBJLewsrssjRD0cQccsKuE6JSskq5sy3
         HyTia6OG6X0tfZeu44JJPV2K7mUrfz+o8eglZh4MHwmMD3LG2gPRplERBtWFpf+vL7Mt
         O2kXaG+WvYfwO+Y+4Je1vpIHC05Gjwk6K8jOHRC5Qv/emx4K6gGxq7ooMj14Bg4S+G8l
         1Jr+Tx72K/8bztH5VHgatH36S3V08cmtxvsr2Amo5XNUu1uYWIRGLI/6H3WqqvI6hWZz
         TIWg==
X-Gm-Message-State: AOAM531NBFT5IR2T91haLzSO5DZ3eKM+6vBbeBO7raWOfr5LzADVCMOC
        QgxusRDo+cSXoPomhHkuSm4ofGJEfjk=
X-Google-Smtp-Source: ABdhPJyRCjyyImwCwDiw01HZ+aBCOjwSSC0m5TMVo9TJ7pzHs3IohmxUhdEjZO2jVVo5dc4WI5qw7nl2aOI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a62:b60f:0:b0:508:2a61:2c8b with SMTP id
 j15-20020a62b60f000000b005082a612c8bmr8280695pff.2.1650685702931; Fri, 22 Apr
 2022 20:48:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:47 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 07/12] KVM: x86/mmu: Make all page fault handlers internal to
 the MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move kvm_arch_async_page_ready() to mmu.c where it belongs, and move all
of the page fault handling collateral that was in mmu.h purely for the
async #PF handler into mmu_internal.h, where it belongs.  This will allow
kvm_mmu_do_page_fault() to act on the RET_PF_* return without having to
expose those enums outside of the MMU.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h              | 87 -------------------------------
 arch/x86/kvm/mmu/mmu.c          | 19 +++++++
 arch/x86/kvm/mmu/mmu_internal.h | 90 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              | 19 -------
 4 files changed, 108 insertions(+), 107 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 671cfeccf04e..461052bef896 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -117,93 +117,6 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 					  vcpu->arch.mmu->root_role.level);
 }
 
-struct kvm_page_fault {
-	/* arguments to kvm_mmu_do_page_fault.  */
-	const gpa_t addr;
-	const u32 error_code;
-	const bool prefetch;
-
-	/* Derived from error_code.  */
-	const bool exec;
-	const bool write;
-	const bool present;
-	const bool rsvd;
-	const bool user;
-
-	/* Derived from mmu and global state.  */
-	const bool is_tdp;
-	const bool nx_huge_page_workaround_enabled;
-
-	/*
-	 * Whether a >4KB mapping can be created or is forbidden due to NX
-	 * hugepages.
-	 */
-	bool huge_page_disallowed;
-
-	/*
-	 * Maximum page size that can be created for this fault; input to
-	 * FNAME(fetch), __direct_map and kvm_tdp_mmu_map.
-	 */
-	u8 max_level;
-
-	/*
-	 * Page size that can be created based on the max_level and the
-	 * page size used by the host mapping.
-	 */
-	u8 req_level;
-
-	/*
-	 * Page size that will be created based on the req_level and
-	 * huge_page_disallowed.
-	 */
-	u8 goal_level;
-
-	/* Shifted addr, or result of guest page table walk if addr is a gva.  */
-	gfn_t gfn;
-
-	/* The memslot containing gfn. May be NULL. */
-	struct kvm_memory_slot *slot;
-
-	/* Outputs of kvm_faultin_pfn.  */
-	kvm_pfn_t pfn;
-	hva_t hva;
-	bool map_writable;
-};
-
-int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
-
-extern int nx_huge_pages;
-static inline bool is_nx_huge_page_enabled(void)
-{
-	return READ_ONCE(nx_huge_pages);
-}
-
-static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch)
-{
-	struct kvm_page_fault fault = {
-		.addr = cr2_or_gpa,
-		.error_code = err,
-		.exec = err & PFERR_FETCH_MASK,
-		.write = err & PFERR_WRITE_MASK,
-		.present = err & PFERR_PRESENT_MASK,
-		.rsvd = err & PFERR_RSVD_MASK,
-		.user = err & PFERR_USER_MASK,
-		.prefetch = prefetch,
-		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
-		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
-
-		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
-		.req_level = PG_LEVEL_4K,
-		.goal_level = PG_LEVEL_4K,
-	};
-#ifdef CONFIG_RETPOLINE
-	if (fault.is_tdp)
-		return kvm_tdp_page_fault(vcpu, &fault);
-#endif
-	return vcpu->arch.mmu->page_fault(vcpu, &fault);
-}
-
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f1e8d71e6f7c..8b8b62d2a903 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3899,6 +3899,25 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
 }
 
+void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
+{
+	int r;
+
+	if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
+	      work->wakeup_all)
+		return;
+
+	r = kvm_mmu_reload(vcpu);
+	if (unlikely(r))
+		return;
+
+	if (!vcpu->arch.mmu->root_role.direct &&
+	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
+		return;
+
+	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
+}
+
 static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	struct kvm_memory_slot *slot = fault->slot;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index c0e502b17ef7..c0c85cbfa159 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -140,8 +140,70 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 					u64 start_gfn, u64 pages);
 unsigned int pte_list_count(struct kvm_rmap_head *rmap_head);
 
+extern int nx_huge_pages;
+static inline bool is_nx_huge_page_enabled(void)
+{
+	return READ_ONCE(nx_huge_pages);
+}
+
+struct kvm_page_fault {
+	/* arguments to kvm_mmu_do_page_fault.  */
+	const gpa_t addr;
+	const u32 error_code;
+	const bool prefetch;
+
+	/* Derived from error_code.  */
+	const bool exec;
+	const bool write;
+	const bool present;
+	const bool rsvd;
+	const bool user;
+
+	/* Derived from mmu and global state.  */
+	const bool is_tdp;
+	const bool nx_huge_page_workaround_enabled;
+
+	/*
+	 * Whether a >4KB mapping can be created or is forbidden due to NX
+	 * hugepages.
+	 */
+	bool huge_page_disallowed;
+
+	/*
+	 * Maximum page size that can be created for this fault; input to
+	 * FNAME(fetch), __direct_map and kvm_tdp_mmu_map.
+	 */
+	u8 max_level;
+
+	/*
+	 * Page size that can be created based on the max_level and the
+	 * page size used by the host mapping.
+	 */
+	u8 req_level;
+
+	/*
+	 * Page size that will be created based on the req_level and
+	 * huge_page_disallowed.
+	 */
+	u8 goal_level;
+
+	/* Shifted addr, or result of guest page table walk if addr is a gva.  */
+	gfn_t gfn;
+
+	/* The memslot containing gfn. May be NULL. */
+	struct kvm_memory_slot *slot;
+
+	/* Outputs of kvm_faultin_pfn.  */
+	kvm_pfn_t pfn;
+	hva_t hva;
+	bool map_writable;
+};
+
+int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
+
 /*
- * Return values of handle_mmio_page_fault, mmu.page_fault, and fast_page_fault().
+ * Return values of handle_mmio_page_fault(), mmu.page_fault(), fast_page_fault(),
+ * and of course kvm_mmu_do_page_fault().
  *
  * RET_PF_CONTINUE: So far, so good, keep handling the page fault.
  * RET_PF_RETRY: let CPU fault again on the address.
@@ -167,6 +229,32 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
+static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+					u32 err, bool prefetch)
+{
+	struct kvm_page_fault fault = {
+		.addr = cr2_or_gpa,
+		.error_code = err,
+		.exec = err & PFERR_FETCH_MASK,
+		.write = err & PFERR_WRITE_MASK,
+		.present = err & PFERR_PRESENT_MASK,
+		.rsvd = err & PFERR_RSVD_MASK,
+		.user = err & PFERR_USER_MASK,
+		.prefetch = prefetch,
+		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
+		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
+
+		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
+		.req_level = PG_LEVEL_4K,
+		.goal_level = PG_LEVEL_4K,
+	};
+#ifdef CONFIG_RETPOLINE
+	if (fault.is_tdp)
+		return kvm_tdp_page_fault(vcpu, &fault);
+#endif
+	return vcpu->arch.mmu->page_fault(vcpu, &fault);
+}
+
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
 			      const struct kvm_memory_slot *slot, gfn_t gfn,
 			      kvm_pfn_t pfn, int max_level);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 951d0a78ccda..7663c35a5c70 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12356,25 +12356,6 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 }
 EXPORT_SYMBOL_GPL(kvm_set_rflags);
 
-void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
-{
-	int r;
-
-	if ((vcpu->arch.mmu->root_role.direct != work->arch.direct_map) ||
-	      work->wakeup_all)
-		return;
-
-	r = kvm_mmu_reload(vcpu);
-	if (unlikely(r))
-		return;
-
-	if (!vcpu->arch.mmu->root_role.direct &&
-	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
-		return;
-
-	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
-}
-
 static inline u32 kvm_async_pf_hash_fn(gfn_t gfn)
 {
 	BUILD_BUG_ON(!is_power_of_2(ASYNC_PF_PER_VCPU));
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

