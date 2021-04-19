Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93006364D78
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 00:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240782AbhDSWFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 18:05:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229683AbhDSWFS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 18:05:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618869887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=V9TpAWTBookZJPskzjveTp1z8A/eSlwxzMp8BsONQuM=;
        b=YUMeyJzotH61wDzJR6dhKsd7tW38vuH6ibXAnT1GKKLdQyocktye62ElHm3qi1+EW+NBux
        UuGAtE6Txc8LYDGEgctqhbef9KRjRxlySxGiS/dECN1zfpp3mWeDiybI0qNHbkelIg8c5P
        IHJIsYeXVcIpktBRSYmaw2VlZOTCylk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-NHFpKugXOCePt0TeBuQHBA-1; Mon, 19 Apr 2021 18:04:45 -0400
X-MC-Unique: NHFpKugXOCePt0TeBuQHBA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94C5C1006C98;
        Mon, 19 Apr 2021 22:04:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3FFDA60C5C;
        Mon, 19 Apr 2021 22:04:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bgardon@google.com
Subject: [PATCH fixed] KVM: x86/mmu: Fast invalidation for TDP MMU
Date:   Mon, 19 Apr 2021 18:04:43 -0400
Message-Id: <20210419220443.673911-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ben Gardon <bgardon@google.com>

Provide a real mechanism for fast invalidation by marking roots as
invalid so that their reference count will quickly fall to zero
and they will be torn down.

One negative side affect of this approach is that a vCPU thread will
likely drop the last reference to a root and be saddled with the work of
tearing down an entire paging structure. This issue will be resolved in
a later commit.

Signed-off-by: Ben Gardon <bgardon@google.com>
Message-Id: <20210401233736.638171-13-bgardon@google.com>
[Move the loop to tdp_mmu.c, otherwise compilation fails on 32-bit. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     | 12 +++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c | 17 +++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  5 +++++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 61c0d1091fc5..3323ab281f34 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5421,6 +5421,15 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 */
 	kvm->arch.mmu_valid_gen = kvm->arch.mmu_valid_gen ? 0 : 1;
 
+	/* In order to ensure all threads see this change when
+	 * handling the MMU reload signal, this must happen in the
+	 * same critical section as kvm_reload_remote_mmus, and
+	 * before kvm_zap_obsolete_pages as kvm_zap_obsolete_pages
+	 * could drop the MMU lock and yield.
+	 */
+	if (is_tdp_mmu_enabled(kvm))
+		kvm_tdp_mmu_invalidate_all_roots(kvm);
+
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
 	 * Then all vcpus will switch to new shadow page table with the new
@@ -5433,9 +5442,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	kvm_zap_obsolete_pages(kvm);
 
-	if (is_tdp_mmu_enabled(kvm))
-		kvm_tdp_mmu_zap_all(kvm);
-
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 335c126d9860..bc9308a104b1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -797,6 +797,23 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 		kvm_flush_remote_tlbs(kvm);
 }
 
+/*
+ * Mark each TDP MMU root as invalid so that other threads
+ * will drop their references and allow the root count to
+ * go to 0.
+ *
+ * This has essentially the same effect for the TDP MMU
+ * as updating mmu_valid_gen does for the shadow MMU.
+ */
+void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
+{
+	struct kvm_mmu_page *root;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
+		root->role.invalid = true;
+}
+
 /*
  * Installs a last-level SPTE to handle a TDP page fault.
  * (NPT/EPT violation/misconfiguration)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 2e1913bbc0ba..25ec0173700e 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,6 +10,9 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
 						     struct kvm_mmu_page *root)
 {
+	if (root->role.invalid)
+		return false;
+
 	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
 
@@ -43,7 +46,9 @@ static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	return __kvm_tdp_mmu_zap_gfn_range(kvm, kvm_mmu_page_as_id(sp),
 					   sp->gfn, end, false, false, false);
 }
+
 void kvm_tdp_mmu_zap_all(struct kvm *kvm);
+void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		    int map_writable, int max_level, kvm_pfn_t pfn,
-- 
2.26.2

