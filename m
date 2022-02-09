Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C874AF777
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbiBIRBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbiBIRBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:01:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 271BCC05CB95
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:01:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9h2kopg+//QvhPwKzfjAfT60rLQ7JGTbMd+9FyXI5k=;
        b=HzmWoKX4+aUTaubtfMiUdFR6fvfB86If9p3ioPiZdsba37EaNS1WKOojfIXdud12xyCCcp
        JSpEvmNfo+fFM+4Yhx9sLK01bCt4n9F7Va+3FY0TbznrACmXmbOltRRH0Jevavrvd1a0HF
        pRBURQZCQwWSa0SLl955LXEz/bVSfkc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-466-99PD-VGPP3C1-fXmnX7zuQ-1; Wed, 09 Feb 2022 12:00:59 -0500
X-MC-Unique: 99PD-VGPP3C1-fXmnX7zuQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93570101F7A4;
        Wed,  9 Feb 2022 17:00:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 178EE7CD6F;
        Wed,  9 Feb 2022 17:00:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com,
        seanjc@google.com
Subject: [PATCH 09/12] KVM: MMU: look for a cached PGD when going from 32-bit to 64-bit
Date:   Wed,  9 Feb 2022 12:00:17 -0500
Message-Id: <20220209170020.1775368-10-pbonzini@redhat.com>
In-Reply-To: <20220209170020.1775368-1-pbonzini@redhat.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now, PGD caching avoids placing a PAE root in the cache by using the
old value of mmu->root_level and mmu->shadow_root_level; it does not look
for a cached PGD if the old root is a PAE one, and then frees it using
kvm_mmu_free_roots.

Change the logic instead to free the uncacheable root early.
This way, __kvm_new_mmu_pgd is able to look up the cache when going from
32-bit to 64-bit (if there is a hit, the invalid root becomes the least
recently used).  An example of this is nested virtualization with shadow
paging, when a 64-bit L1 runs a 32-bit L2.

As a side effect (which is actually the reason why this patch was
written), PGD caching does not use the old value of mmu->root_level
and mmu->shadow_root_level anymore.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 71 ++++++++++++++++++++++++++++++++----------
 1 file changed, 54 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 95d0fa0bb876..f61208ccce43 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4087,20 +4087,20 @@ static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
 				  union kvm_mmu_page_role role)
 {
 	return (role.direct || pgd == root->pgd) &&
-	       VALID_PAGE(root->hpa) && to_shadow_page(root->hpa) &&
+	       VALID_PAGE(root->hpa) &&
 	       role.word == to_shadow_page(root->hpa)->role.word;
 }
 
 /*
  * Find out if a previously cached root matching the new pgd/role is available.
- * The current root is also inserted into the cache.
- * If a matching root was found, it is assigned to kvm_mmu->root.hpa and true is
- * returned.
- * Otherwise, the LRU root from the cache is assigned to kvm_mmu->root.hpa and
- * false is returned. This root should now be freed by the caller.
+ * If a matching root is found, it is assigned to kvm_mmu->root and
+ * true is returned.
+ * If no match is found, the current root becomes the MRU of the cache
+ * if valid (thus evicting the LRU root), kvm_mmu->root is left invalid,
+ * and false is returned.
  */
-static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_pgd,
-				  union kvm_mmu_page_role new_role)
+static bool cached_root_find_and_promote(struct kvm_vcpu *vcpu, gpa_t new_pgd,
+					 union kvm_mmu_page_role new_role)
 {
 	uint i;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -4109,13 +4109,48 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 		return true;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+		/*
+		 * The swaps end up rotating the cache like this:
+		 *   C   0 1 2 3   (on entry to the function)
+		 *   0   C 1 2 3
+		 *   1   C 0 2 3
+		 *   2   C 0 1 3
+		 *   3   C 0 1 2   (on exit from the loop)
+		 */
 		swap(mmu->root, mmu->prev_roots[i]);
-
 		if (is_root_usable(&mmu->root, new_pgd, new_role))
-			break;
+			return true;
 	}
 
-	return i < KVM_MMU_NUM_PREV_ROOTS;
+	kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
+	return false;
+}
+
+/*
+ * Find out if a previously cached root matching the new pgd/role is available.
+ * If a matching root is found, it is assigned to kvm_mmu->root and true
+ * is returned.  The current, invalid root goes to the bottom of the cache.
+ * If no match is found, kvm_mmu->root is left invalid and false is returned.
+ */
+static bool cached_root_find_and_replace(struct kvm_vcpu *vcpu, gpa_t new_pgd,
+					 union kvm_mmu_page_role new_role)
+{
+	uint i;
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+		if (is_root_usable(&mmu->prev_roots[i], new_pgd, new_role))
+			goto hit;
+
+	return false;
+
+hit:
+	swap(mmu->root, mmu->prev_roots[i]);
+	/* Bubble up the remaining roots.  */
+	for (; i < KVM_MMU_NUM_PREV_ROOTS - 1; i++)
+		mmu->prev_roots[i] = mmu->prev_roots[i + 1];
+	mmu->prev_roots[i].hpa = INVALID_PAGE;
+	return true;
 }
 
 static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
@@ -4124,22 +4159,24 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 
 	/*
-	 * For now, limit the fast switch to 64-bit hosts+VMs in order to avoid
+	 * For now, limit the caching to 64-bit hosts+VMs in order to avoid
 	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
 	 * later if necessary.
 	 */
-	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
-	    mmu->root_level >= PT64_ROOT_4LEVEL)
-		return cached_root_available(vcpu, new_pgd, new_role);
+	if (VALID_PAGE(mmu->root.hpa) && !to_shadow_page(mmu->root.hpa))
+		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
 
-	return false;
+	if (VALID_PAGE(mmu->root.hpa))
+		return cached_root_find_and_promote(vcpu, new_pgd, new_role);
+	else
+		return cached_root_find_and_replace(vcpu, new_pgd, new_role);
 }
 
 static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 			      union kvm_mmu_page_role new_role)
 {
 	if (!fast_pgd_switch(vcpu, new_pgd, new_role)) {
-		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
+		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */
 		return;
 	}
 
-- 
2.31.1


