Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67702973D6
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751707AbgJWQbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:31:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751520AbgJWQaq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=thlib0qCjHCYjG/jLSNdoEPfPn2F8Jf6bA+VZkAfw38=;
        b=ei0+CVG95SXfcHkUmYrPWDtMG5p6EHoYiH/FB+kyO7WoawTnKSO21m+RlJeqwE2qlZXKbW
        Gej8QeMl5XrgRwTDzzJ2Xo0gY/+3zNMjPTVJYvon7610IumpTFHqLLCH20dNoYBN/L0BYB
        IXtqy/fy+ePTJmw8zXZjeZWnCmMPkR8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-5KaeB_KtNoCrGN6AO-gtMA-1; Fri, 23 Oct 2020 12:30:43 -0400
X-MC-Unique: 5KaeB_KtNoCrGN6AO-gtMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27C87835B77;
        Fri, 23 Oct 2020 16:30:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C955760FC2;
        Fri, 23 Oct 2020 16:30:40 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 19/22] kvm: x86/mmu: Support write protection for nesting in tdp MMU
Date:   Fri, 23 Oct 2020 12:30:21 -0400
Message-Id: <20201023163024.2765558-20-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

To support nested virtualization, KVM will sometimes need to write
protect pages which are part of a shadowed paging structure or are not
writable in the shadowed paging structure. Add a function to write
protect GFN mappings for this purpose.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-18-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  4 +++
 arch/x86/kvm/mmu/tdp_mmu.c | 50 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  3 +++
 3 files changed, 57 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cd1be200e2a3..4c62ac8db169 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1299,6 +1299,10 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
 	}
 
+	if (kvm->arch.tdp_mmu_enabled)
+		write_protected |=
+			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn);
+
 	return write_protected;
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0f181f324455..1491e2f7a897 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1078,3 +1078,53 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		kvm_mmu_put_root(kvm, root);
 	}
 }
+
+/*
+ * Removes write access on the last level SPTE mapping this GFN and unsets the
+ * SPTE_MMU_WRITABLE bit to ensure future writes continue to be intercepted.
+ * Returns true if an SPTE was set and a TLB flush is needed.
+ */
+static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
+			      gfn_t gfn)
+{
+	struct tdp_iter iter;
+	u64 new_spte;
+	bool spte_set = false;
+
+	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1) {
+		if (!is_writable_pte(iter.old_spte))
+			break;
+
+		new_spte = iter.old_spte &
+			~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
+
+		tdp_mmu_set_spte(kvm, &iter, new_spte);
+		spte_set = true;
+	}
+
+	return spte_set;
+}
+
+/*
+ * Removes write access on the last level SPTE mapping this GFN and unsets the
+ * SPTE_MMU_WRITABLE bit to ensure future writes continue to be intercepted.
+ * Returns true if an SPTE was set and a TLB flush is needed.
+ */
+bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	struct kvm_mmu_page *root;
+	int root_as_id;
+	bool spte_set = false;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	for_each_tdp_mmu_root(kvm, root) {
+		root_as_id = kvm_mmu_page_as_id(root);
+		if (root_as_id != slot->as_id)
+			continue;
+
+		spte_set |= write_protect_gfn(kvm, root, gfn);
+	}
+	return spte_set;
+}
+
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 8cc902b8b9f8..6501dd2ef8e4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -40,4 +40,7 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot);
+
+bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, gfn_t gfn);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.26.2


