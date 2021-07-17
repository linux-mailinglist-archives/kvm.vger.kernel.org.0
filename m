Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804DA3CC248
	for <lists+kvm@lfdr.de>; Sat, 17 Jul 2021 11:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhGQJ70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jul 2021 05:59:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231716AbhGQJ7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jul 2021 05:59:07 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4CB7613D9;
        Sat, 17 Jul 2021 09:56:10 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m4h3J-00DvkH-6F; Sat, 17 Jul 2021 10:56:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 1/5] KVM: arm64: Walk userspace page tables to compute the THP mapping size
Date:   Sat, 17 Jul 2021 10:55:37 +0100
Message-Id: <20210717095541.1486210-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210717095541.1486210-1-maz@kernel.org>
References: <20210717095541.1486210-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org, seanjc@google.com, willy@infradead.org, pbonzini@redhat.com, will@kernel.org, qperret@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We currently rely on the kvm_is_transparent_hugepage() helper to
discover whether a given page has the potential to be mapped as
a block mapping.

However, this API doesn't really give un everything we want:
- we don't get the size: this is not crucial today as we only
  support PMD-sized THPs, but we'd like to have larger sizes
  in the future
- we're the only user left of the API, and there is a will
  to remove it altogether

To address the above, implement a simple walker using the existing
page table infrastructure, and plumb it into transparent_hugepage_adjust().
No new page sizes are supported in the process.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 46 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3155c9e778f0..db6314b93e99 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -433,6 +433,44 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
 	return 0;
 }
 
+static struct kvm_pgtable_mm_ops kvm_user_mm_ops = {
+	/* We shouldn't need any other callback to walk the PT */
+	.phys_to_virt		= kvm_host_va,
+};
+
+struct user_walk_data {
+	u32	level;
+};
+
+static int user_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+		       enum kvm_pgtable_walk_flags flag, void * const arg)
+{
+	struct user_walk_data *data = arg;
+
+	data->level = level;
+	return 0;
+}
+
+static int get_user_mapping_size(struct kvm *kvm, u64 addr)
+{
+	struct user_walk_data data;
+	struct kvm_pgtable pgt = {
+		.pgd		= (kvm_pte_t *)kvm->mm->pgd,
+		.ia_bits	= VA_BITS,
+		.start_level	= 4 - CONFIG_PGTABLE_LEVELS,
+		.mm_ops		= &kvm_user_mm_ops,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb		= user_walker,
+		.flags		= KVM_PGTABLE_WALK_LEAF,
+		.arg		= &data,
+	};
+
+	kvm_pgtable_walk(&pgt, ALIGN_DOWN(addr, PAGE_SIZE), PAGE_SIZE, &walker);
+
+	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(data.level));
+}
+
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
 	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
@@ -780,7 +818,7 @@ static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
  * Returns the size of the mapping.
  */
 static unsigned long
-transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
+transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			    unsigned long hva, kvm_pfn_t *pfnp,
 			    phys_addr_t *ipap)
 {
@@ -791,8 +829,8 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
 	 * sure that the HVA and IPA are sufficiently aligned and that the
 	 * block map is contained within the memslot.
 	 */
-	if (kvm_is_transparent_hugepage(pfn) &&
-	    fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
+	if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE) &&
+	    get_user_mapping_size(kvm, hva) >= PMD_SIZE) {
 		/*
 		 * The address we faulted on is backed by a transparent huge
 		 * page.  However, because we map the compound huge page and
@@ -1051,7 +1089,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * backed by a THP and thus use block mapping if possible.
 	 */
 	if (vma_pagesize == PAGE_SIZE && !(force_pte || device))
-		vma_pagesize = transparent_hugepage_adjust(memslot, hva,
+		vma_pagesize = transparent_hugepage_adjust(kvm, memslot, hva,
 							   &pfn, &fault_ipa);
 
 	if (fault_status != FSC_PERM && !device && kvm_has_mte(kvm)) {
-- 
2.30.2

