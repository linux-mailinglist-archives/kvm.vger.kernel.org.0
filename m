Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640FD3D7C05
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 19:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhG0RSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 13:18:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26746 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229666AbhG0RSO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 13:18:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627406293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GItFTNdxoCOFqJnaC/RgM2WlI5Q/FndONkm0DD1Ya6k=;
        b=MLoCOxM188VQSmEfAO/GS3vPTkb+VZIbS+jieJc9a9Ttq7tJ4oc4x1XzUPyy99uekO4OF5
        R6gh5R/HgLD7Wj4YLvYVLvJ9tyk5p16db5YzF4HbAlBMID3EdN9PEjCfHUuppv8rUU7I/4
        DVNDKXQN6vh7z2vIkZ28ayc6FDBlDGc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-ZIIE8D6tMy-pUUKieNbxxw-1; Tue, 27 Jul 2021 13:18:11 -0400
X-MC-Unique: ZIIE8D6tMy-pUUKieNbxxw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C10BD192FDA2;
        Tue, 27 Jul 2021 17:18:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7182160243;
        Tue, 27 Jul 2021 17:18:10 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 2/2] KVM: Don't take mmu_lock for range invalidation unless necessary
Date:   Tue, 27 Jul 2021 13:18:08 -0400
Message-Id: <20210727171808.1645060-3-pbonzini@redhat.com>
In-Reply-To: <20210727171808.1645060-1-pbonzini@redhat.com>
References: <20210727171808.1645060-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Avoid taking mmu_lock for .invalidate_range_{start,end}() notifications
that are unrelated to KVM.  This is possible now that memslot updates are
blocked from range_start() to range_end(); that ensures that lock elision
happens in both or none, and therefore that mmu_notifier_count updates
(which must occur while holding mmu_lock for write) are always paired
across start->end.

Based on patches originally written by Ben Gardon.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c64a7de60846..a96cbe24c688 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -496,17 +496,6 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 
 	idx = srcu_read_lock(&kvm->srcu);
 
-	/* The on_lock() path does not yet support lock elision. */
-	if (!IS_KVM_NULL_FN(range->on_lock)) {
-		locked = true;
-		KVM_MMU_LOCK(kvm);
-
-		range->on_lock(kvm, range->start, range->end);
-
-		if (IS_KVM_NULL_FN(range->handler))
-			goto out_unlock;
-	}
-
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
 		kvm_for_each_memslot(slot, slots) {
@@ -538,6 +527,10 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			if (!locked) {
 				locked = true;
 				KVM_MMU_LOCK(kvm);
+				if (!IS_KVM_NULL_FN(range->on_lock))
+					range->on_lock(kvm, range->start, range->end);
+				if (IS_KVM_NULL_FN(range->handler))
+					break;
 			}
 			ret |= range->handler(kvm, &gfn_range);
 		}
@@ -546,7 +539,6 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && (ret || kvm->tlbs_dirty))
 		kvm_flush_remote_tlbs(kvm);
 
-out_unlock:
 	if (locked)
 		KVM_MMU_UNLOCK(kvm);
 
@@ -605,8 +597,13 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 
 	/*
 	 * .change_pte() must be surrounded by .invalidate_range_{start,end}(),
+	 * If mmu_notifier_count is zero, then start() didn't find a relevant
+	 * memslot and wasn't forced down the slow path; rechecking here is
+	 * unnecessary.
 	 */
 	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
+	if (!kvm->mmu_notifier_count)
+		return;
 
 	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
 }
@@ -1398,7 +1395,8 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 
 	/*
 	 * Do not store the new memslots while there are invalidations in
-	 * progress (preparatory change for the next commit).
+	 * progress, otherwise the locking in invalidate_range_start and
+	 * invalidate_range_end will be unbalanced.
 	 */
 	spin_lock(&kvm->mn_invalidate_lock);
 	prepare_to_rcuwait(&kvm->mn_memslots_update_rcuwait);
-- 
2.27.0

