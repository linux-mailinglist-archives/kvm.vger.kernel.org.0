Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6044CC641
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbiCCTjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbiCCTjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:39:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D3C382D0D
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FU2TNl+3xBaGjkvkfbgLDEJUGF/LH7xpGKP4dCKQmL0=;
        b=EkWey92GXjSU/aIeZ99wWJ9//Z67cFh3oAYPB1hchlhjnMmNnVtsJbzPnUeBJNqNFnnPD/
        FBGCLimlZqQ2A4CISp/lpVaiKXzdEZuqRx3GtavdZizt4/f9UCki1fmXrlQJHPKqpR/QQT
        dPye7xPpe/KSbTNObqHDzSvLxRTtmiE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-73Dxh2VkPuK1dE8JEXYYaw-1; Thu, 03 Mar 2022 14:38:47 -0500
X-MC-Unique: 73Dxh2VkPuK1dE8JEXYYaw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 407C9824FA8;
        Thu,  3 Mar 2022 19:38:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DFD05DF2E;
        Thu,  3 Mar 2022 19:38:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 02/30] KVM: x86/mmu: Fix wrong/misleading comments in TDP MMU fast zap
Date:   Thu,  3 Mar 2022 14:38:14 -0500
Message-Id: <20220303193842.370645-3-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Fix misleading and arguably wrong comments in the TDP MMU's fast zap
flow.  The comments, and the fact that actually zapping invalid roots was
added separately, strongly suggests that zapping invalid roots is an
optimization and not required for correctness.  That is a lie.

KVM _must_ zap invalid roots before returning from kvm_mmu_zap_all_fast(),
because when it's called from kvm_mmu_invalidate_zap_pages_in_memslot(),
KVM is relying on it to fully remove all references to the memslot.  Once
the memslot is gone, KVM's mmu_notifier hooks will be unable to find the
stale references as the hva=>gfn translation is done via the memslots.
If KVM doesn't immediately zap SPTEs and userspace unmaps a range after
deleting a memslot, KVM will fail to zap in response to the mmu_notifier
due to not finding a memslot corresponding to the notifier's range, which
leads to a variation of use-after-free.

The other misleading comment (and code) explicitly states that roots
without a reference should be skipped.  While that's technically true,
it's also extremely misleading as it should be impossible for KVM to
encounter a defunct root on the list while holding mmu_lock for write.
Opportunistically add a WARN to enforce that invariant.

Fixes: b7cccd397f31 ("KVM: x86/mmu: Fast invalidation for TDP MMU")
Fixes: 4c6654bd160d ("KVM: x86/mmu: Tear down roots before kvm_mmu_zap_all_fast returns")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Message-Id: <20220226001546.360188-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c     |  8 +++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 46 +++++++++++++++++++++-----------------
 2 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3e7c8ad5bed9..32c041ed65cb 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5721,6 +5721,14 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	write_unlock(&kvm->mmu_lock);
 
+	/*
+	 * Zap the invalidated TDP MMU roots, all SPTEs must be dropped before
+	 * returning to the caller, e.g. if the zap is in response to a memslot
+	 * deletion, mmu_notifier callbacks will be unable to reach the SPTEs
+	 * associated with the deleted memslot once the update completes, and
+	 * Deferring the zap until the final reference to the root is put would
+	 * lead to use-after-free.
+	 */
 	if (is_tdp_mmu_enabled(kvm)) {
 		read_lock(&kvm->mmu_lock);
 		kvm_tdp_mmu_zap_invalidated_roots(kvm);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4cf0cc04b2a0..b97a4125feac 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -833,12 +833,11 @@ static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
 }
 
 /*
- * Since kvm_tdp_mmu_zap_all_fast has acquired a reference to each
- * invalidated root, they will not be freed until this function drops the
- * reference. Before dropping that reference, tear down the paging
- * structure so that whichever thread does drop the last reference
- * only has to do a trivial amount of work. Since the roots are invalid,
- * no new SPTEs should be created under them.
+ * Zap all invalidated roots to ensure all SPTEs are dropped before the "fast
+ * zap" completes.  Since kvm_tdp_mmu_invalidate_all_roots() has acquired a
+ * reference to each invalidated root, roots will not be freed until after this
+ * function drops the gifted reference, e.g. so that vCPUs don't get stuck with
+ * tearing down paging structures.
  */
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
@@ -877,21 +876,25 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 }
 
 /*
- * Mark each TDP MMU root as invalid so that other threads
- * will drop their references and allow the root count to
- * go to 0.
+ * Mark each TDP MMU root as invalid to prevent vCPUs from reusing a root that
+ * is about to be zapped, e.g. in response to a memslots update.  The caller is
+ * responsible for invoking kvm_tdp_mmu_zap_invalidated_roots() to do the actual
+ * zapping.
  *
- * Also take a reference on all roots so that this thread
- * can do the bulk of the work required to free the roots
- * once they are invalidated. Without this reference, a
- * vCPU thread might drop the last reference to a root and
- * get stuck with tearing down the entire paging structure.
+ * Take a reference on all roots to prevent the root from being freed before it
+ * is zapped by this thread.  Freeing a root is not a correctness issue, but if
+ * a vCPU drops the last reference to a root prior to the root being zapped, it
+ * will get stuck with tearing down the entire paging structure.
  *
- * Roots which have a zero refcount should be skipped as
- * they're already being torn down.
- * Already invalid roots should be referenced again so that
- * they aren't freed before kvm_tdp_mmu_zap_all_fast is
- * done with them.
+ * Get a reference even if the root is already invalid,
+ * kvm_tdp_mmu_zap_invalidated_roots() assumes it was gifted a reference to all
+ * invalid roots, e.g. there's no epoch to identify roots that were invalidated
+ * by a previous call.  Roots stay on the list until the last reference is
+ * dropped, so even though all invalid roots are zapped, a root may not go away
+ * for quite some time, e.g. if a vCPU blocks across multiple memslot updates.
+ *
+ * Because mmu_lock is held for write, it should be impossible to observe a
+ * root with zero refcount, i.e. the list of roots cannot be stale.
  *
  * This has essentially the same effect for the TDP MMU
  * as updating mmu_valid_gen does for the shadow MMU.
@@ -901,9 +904,10 @@ void kvm_tdp_mmu_invalidate_all_roots(struct kvm *kvm)
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
-	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
-		if (refcount_inc_not_zero(&root->tdp_mmu_root_count))
+	list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link) {
+		if (!WARN_ON_ONCE(!kvm_tdp_mmu_get_root(root)))
 			root->role.invalid = true;
+	}
 }
 
 /*
-- 
2.31.1


