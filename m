Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382742973D4
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751684AbgJWQbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:31:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48179 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S465256AbgJWQaq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ugyPXTBu7ubHFRwef311we4wj7/oWLsWnOkAFP245e8=;
        b=fbYR3aB3Md4KUDrb4dSQq8WF/+8+ryPQO89aHoaeINV7fetOzkxX9gVRO9BDa3yr3kzSAF
        PGnvIiPS9zP4xh8iKDBj5FSdYy7E/pqC5djc+7Y6gIaarOSgIR5TlS877dM/NoTqHhrVds
        sCDrxIGgygAShAvKo2yUM2236n6oKc0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-jSe8GX7zOCSsuElEZ1QGNg-1; Fri, 23 Oct 2020 12:30:43 -0400
X-MC-Unique: jSe8GX7zOCSsuElEZ1QGNg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 232DD10E2190;
        Fri, 23 Oct 2020 16:30:42 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BA6E9CBC8;
        Fri, 23 Oct 2020 16:30:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 20/22] kvm: x86/mmu: Support MMIO in the TDP MMU
Date:   Fri, 23 Oct 2020 12:30:22 -0400
Message-Id: <20201023163024.2765558-21-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

In order to support MMIO, KVM must be able to walk the TDP paging
structures to find mappings for a given GFN. Support this walk for
the TDP MMU.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

v2: Thanks to Dan Carpenter and kernel test robot for finding that root
was used uninitialized in get_mmio_spte.

Signed-off-by: Ben Gardon <bgardon@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Message-Id: <20201014182700.2888246-19-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     | 70 ++++++++++++++++++++++++++------------
 arch/x86/kvm/mmu/tdp_mmu.c | 21 ++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  2 ++
 3 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4c62ac8db169..6a0941ccac34 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3479,54 +3479,82 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	return vcpu_match_mmio_gva(vcpu, addr);
 }
 
-/* return true if reserved bit is detected on spte. */
-static bool
-walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
+/*
+ * Return the level of the lowest level SPTE added to sptes.
+ * That SPTE may be non-present.
+ */
+static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	u64 sptes[PT64_ROOT_MAX_LEVEL], spte = 0ull;
-	struct rsvd_bits_validate *rsvd_check;
-	int root, leaf;
-	bool reserved = false;
+	int leaf = vcpu->arch.mmu->root_level;
+	u64 spte;
 
-	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
 
 	walk_shadow_page_lockless_begin(vcpu);
 
-	for (shadow_walk_init(&iterator, vcpu, addr),
-		 leaf = root = iterator.level;
+	for (shadow_walk_init(&iterator, vcpu, addr);
 	     shadow_walk_okay(&iterator);
 	     __shadow_walk_next(&iterator, spte)) {
+		leaf = iterator.level;
 		spte = mmu_spte_get_lockless(iterator.sptep);
 
 		sptes[leaf - 1] = spte;
-		leaf--;
 
 		if (!is_shadow_present_pte(spte))
 			break;
 
+	}
+
+	walk_shadow_page_lockless_end(vcpu);
+
+	return leaf;
+}
+
+/* return true if reserved bit is detected on spte. */
+static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
+{
+	u64 sptes[PT64_ROOT_MAX_LEVEL];
+	struct rsvd_bits_validate *rsvd_check;
+	int root = vcpu->arch.mmu->root_level;
+	int leaf;
+	int level;
+	bool reserved = false;
+
+	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa)) {
+		*sptep = 0ull;
+		return reserved;
+	}
+
+	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes);
+	else
+		leaf = get_walk(vcpu, addr, sptes);
+
+	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
+
+	for (level = root; level >= leaf; level--) {
+		if (!is_shadow_present_pte(sptes[level - 1]))
+			break;
 		/*
 		 * Use a bitwise-OR instead of a logical-OR to aggregate the
 		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
 		 * adding a Jcc in the loop.
 		 */
-		reserved |= __is_bad_mt_xwr(rsvd_check, spte) |
-			    __is_rsvd_bits_set(rsvd_check, spte, iterator.level);
+		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level - 1]) |
+			    __is_rsvd_bits_set(rsvd_check, sptes[level - 1],
+					       level);
 	}
 
-	walk_shadow_page_lockless_end(vcpu);
-
 	if (reserved) {
 		pr_err("%s: detect reserved bits on spte, addr 0x%llx, dump hierarchy:\n",
 		       __func__, addr);
-		while (root > leaf) {
+		for (level = root; level >= leaf; level--)
 			pr_err("------ spte 0x%llx level %d.\n",
-			       sptes[root - 1], root);
-			root--;
-		}
+			       sptes[level - 1], level);
 	}
 
-	*sptep = spte;
+	*sptep = sptes[leaf - 1];
+
 	return reserved;
 }
 
@@ -3538,7 +3566,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	if (mmio_info_in_cache(vcpu, addr, direct))
 		return RET_PF_EMULATE;
 
-	reserved = walk_shadow_page_get_mmio_spte(vcpu, addr, &spte);
+	reserved = get_mmio_spte(vcpu, addr, &spte);
 	if (WARN_ON(reserved))
 		return -EINVAL;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1491e2f7a897..5158d02b8925 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -7,7 +7,10 @@
 #include "tdp_mmu.h"
 #include "spte.h"
 
+#ifdef CONFIG_X86_64
 static bool __read_mostly tdp_mmu_enabled = false;
+module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
+#endif
 
 static bool is_tdp_mmu_enabled(void)
 {
@@ -1128,3 +1131,21 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	return spte_set;
 }
 
+/*
+ * Return the level of the lowest level SPTE added to sptes.
+ * That SPTE may be non-present.
+ */
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
+{
+	struct tdp_iter iter;
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	int leaf = vcpu->arch.mmu->shadow_root_level;
+	gfn_t gfn = addr >> PAGE_SHIFT;
+
+	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+		leaf = iter.level;
+		sptes[leaf - 1] = iter.old_spte;
+	}
+
+	return leaf;
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 6501dd2ef8e4..556e065503f6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -43,4 +43,6 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn);
+
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.26.2


