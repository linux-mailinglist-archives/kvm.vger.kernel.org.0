Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512882973D7
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751705AbgJWQbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:31:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47272 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751599AbgJWQaq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xoFoyI0UOBmcSkHg4sN9F23WXOe7mZHvkeYZynLEWfc=;
        b=GVXxOwNLSfp1XtDbklR4YDv8cxZx+iiwjqHsKtg/4qPkgsqCQyLGBaVIQEOfzrSRrzVpct
        WBH8N9OFjTan6oRhh/zePV+dHlOvZbNU5nGdsOgqVntRz+qXhPMyNkF6l0CRmx3q2SZFj+
        YIiOLkpqMy9MnKQw3jpTRGxOl0cZlgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-knX5gA7lOXOP0IX8byS5RQ-1; Fri, 23 Oct 2020 12:30:42 -0400
X-MC-Unique: knX5gA7lOXOP0IX8byS5RQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD662EC10F;
        Fri, 23 Oct 2020 16:30:40 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B3E260FC2;
        Fri, 23 Oct 2020 16:30:40 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 18/22] kvm: x86/mmu: Support disabling dirty logging for the tdp MMU
Date:   Fri, 23 Oct 2020 12:30:20 -0400
Message-Id: <20201023163024.2765558-19-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

Dirty logging ultimately breaks down MMU mappings to 4k granularity.
When dirty logging is no longer needed, these granaular mappings
represent a useless performance penalty. When dirty logging is disabled,
search the paging structure for mappings that could be re-constituted
into a large page mapping. Zap those mappings so that they can be
faulted in again at a higher mapping level.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-17-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  3 ++
 arch/x86/kvm/mmu/tdp_mmu.c | 58 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  2 ++
 3 files changed, 63 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0c64643819b9..cd1be200e2a3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5544,6 +5544,9 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	spin_lock(&kvm->mmu_lock);
 	slot_handle_leaf(kvm, (struct kvm_memory_slot *)memslot,
 			 kvm_mmu_zap_collapsible_spte, true);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		kvm_tdp_mmu_zap_collapsible_sptes(kvm, memslot);
 	spin_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7181b4ab54d0..0f181f324455 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1020,3 +1020,61 @@ bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot)
 	return spte_set;
 }
 
+/*
+ * Clear non-leaf entries (and free associated page tables) which could
+ * be replaced by large mappings, for GFNs within the slot.
+ */
+static void zap_collapsible_spte_range(struct kvm *kvm,
+				       struct kvm_mmu_page *root,
+				       gfn_t start, gfn_t end)
+{
+	struct tdp_iter iter;
+	kvm_pfn_t pfn;
+	bool spte_set = false;
+
+	tdp_root_for_each_pte(iter, root, start, end) {
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    is_last_spte(iter.old_spte, iter.level))
+			continue;
+
+		pfn = spte_to_pfn(iter.old_spte);
+		if (kvm_is_reserved_pfn(pfn) ||
+		    !PageTransCompoundMap(pfn_to_page(pfn)))
+			continue;
+
+		tdp_mmu_set_spte(kvm, &iter, 0);
+
+		spte_set = tdp_mmu_iter_flush_cond_resched(kvm, &iter);
+	}
+
+	if (spte_set)
+		kvm_flush_remote_tlbs(kvm);
+}
+
+/*
+ * Clear non-leaf entries (and free associated page tables) which could
+ * be replaced by large mappings, for GFNs within the slot.
+ */
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot)
+{
+	struct kvm_mmu_page *root;
+	int root_as_id;
+
+	for_each_tdp_mmu_root(kvm, root) {
+		root_as_id = kvm_mmu_page_as_id(root);
+		if (root_as_id != slot->as_id)
+			continue;
+
+		/*
+		 * Take a reference on the root so that it cannot be freed if
+		 * this thread releases the MMU lock and yields in this loop.
+		 */
+		kvm_mmu_get_root(kvm, root);
+
+		zap_collapsible_spte_range(kvm, root, slot->base_gfn,
+					   slot->base_gfn + slot->npages);
+
+		kvm_mmu_put_root(kvm, root);
+	}
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index ece66f10d85f..8cc902b8b9f8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -38,4 +38,6 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 				       gfn_t gfn, unsigned long mask,
 				       bool wrprot);
 bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot);
+void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
+				       const struct kvm_memory_slot *slot);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.26.2


