Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF392973CB
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 18:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1751662AbgJWQbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 12:31:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S465250AbgJWQau (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 12:30:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603470649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PRLR2t5qkZnuPafXbvSTkaseg+VDYzBpiYZonceNcWg=;
        b=V+kAgQ4ilRMA6/i29LXfE4E1ERZRS8sL+7xG4fCJsov02+K91VYcEg+7qpsmKv+EZ9Dwr5
        zcYq6knADbnwf2MpkAqLxbJVe9Zccg0qyRzdvGlK6eVdAhs2JNFflnTmmgJTG0Pwh3/hRK
        o4+gq1xNr3DCjYL4aNToXtvdvdm6LtY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-te4U0Yw5PE-7S5KmOB_C2Q-1; Fri, 23 Oct 2020 12:30:40 -0400
X-MC-Unique: te4U0Yw5PE-7S5KmOB_C2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C34E38463DE;
        Fri, 23 Oct 2020 16:30:39 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7111B59;
        Fri, 23 Oct 2020 16:30:39 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH 16/22] kvm: x86/mmu: Support changed pte notifier in tdp MMU
Date:   Fri, 23 Oct 2020 12:30:18 -0400
Message-Id: <20201023163024.2765558-17-pbonzini@redhat.com>
In-Reply-To: <20201023163024.2765558-1-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

In order to interoperate correctly with the rest of KVM and other Linux
subsystems, the TDP MMU must correctly handle various MMU notifiers. Add
a hook and handle the change_pte MMU notifier.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20201014182700.2888246-15-bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  9 +++++-
 arch/x86/kvm/mmu/tdp_mmu.c | 56 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
 3 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 33ec6c4c36d7..41f0354c7489 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1509,7 +1509,14 @@ int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 {
-	return kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
+	int r;
+
+	r = kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
+
+	if (kvm->arch.tdp_mmu_enabled)
+		r |= kvm_tdp_mmu_set_spte_hva(kvm, hva, &pte);
+
+	return r;
 }
 
 static int kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index dd6b8a8f1c93..64e640cfcff9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -671,3 +671,59 @@ int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva)
 	return kvm_tdp_mmu_handle_hva_range(kvm, hva, hva + 1, 0,
 					    test_age_gfn);
 }
+
+/*
+ * Handle the changed_pte MMU notifier for the TDP MMU.
+ * data is a pointer to the new pte_t mapping the HVA specified by the MMU
+ * notifier.
+ * Returns non-zero if a flush is needed before releasing the MMU lock.
+ */
+static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
+			struct kvm_mmu_page *root, gfn_t gfn, gfn_t unused,
+			unsigned long data)
+{
+	struct tdp_iter iter;
+	pte_t *ptep = (pte_t *)data;
+	kvm_pfn_t new_pfn;
+	u64 new_spte;
+	int need_flush = 0;
+
+	WARN_ON(pte_huge(*ptep));
+
+	new_pfn = pte_pfn(*ptep);
+
+	tdp_root_for_each_pte(iter, root, gfn, gfn + 1) {
+		if (iter.level != PG_LEVEL_4K)
+			continue;
+
+		if (!is_shadow_present_pte(iter.old_spte))
+			break;
+
+		tdp_mmu_set_spte(kvm, &iter, 0);
+
+		kvm_flush_remote_tlbs_with_address(kvm, iter.gfn, 1);
+
+		if (!pte_write(*ptep)) {
+			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
+					iter.old_spte, new_pfn);
+
+			tdp_mmu_set_spte(kvm, &iter, new_spte);
+		}
+
+		need_flush = 1;
+	}
+
+	if (need_flush)
+		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
+
+	return 0;
+}
+
+int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
+			     pte_t *host_ptep)
+{
+	return kvm_tdp_mmu_handle_hva_range(kvm, address, address + 1,
+					    (unsigned long)host_ptep,
+					    set_tdp_spte);
+}
+
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index ddc1bf12d0fc..aeee3ce7b3f4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -25,4 +25,7 @@ int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
 int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
 			      unsigned long end);
 int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva);
+
+int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
+			     pte_t *host_ptep);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.26.2


