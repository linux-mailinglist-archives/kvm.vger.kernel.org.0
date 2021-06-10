Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4EB3A2B0A
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 14:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhFJMIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 08:08:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230329AbhFJMIR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 08:08:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623326780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jCEz8RgLSF0ncN4Sv60FkG386Ouly8dnvDH4i1L6AKo=;
        b=jPgpp62MnzCao4CCHcCGRKUGgouX8SZtCI0JgReMErQi7DnJwCpPk0XBQdiBVG/GVaOxaw
        m5r1nuOKzou9MmfeSjbFbJVNj2UfWTdKxEsV5CJ58NTlJIq/vqYshv1U1KBv0ZStPCxO0p
        rTVoFOKTPRmx0ALrpeb1DZA5KKb25T0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-fepzxj1tNIyBtnw4HYxziw-1; Thu, 10 Jun 2021 08:06:18 -0400
X-MC-Unique: fepzxj1tNIyBtnw4HYxziw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF9768015F8;
        Thu, 10 Jun 2021 12:06:17 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FE3D19C45;
        Thu, 10 Jun 2021 12:06:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, bgardon@google.com
Subject: [PATCH 2/2] KVM: Don't take mmu_lock for range invalidation unless necessary
Date:   Thu, 10 Jun 2021 08:06:15 -0400
Message-Id: <20210610120615.172224-3-pbonzini@redhat.com>
In-Reply-To: <20210610120615.172224-1-pbonzini@redhat.com>
References: <20210610120615.172224-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
 virt/kvm/kvm_main.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0dc0726c8d18..2e73edfcc8db 100644
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
@@ -546,7 +540,6 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && (ret || kvm->tlbs_dirty))
 		kvm_flush_remote_tlbs(kvm);
 
-out_unlock:
 	if (locked)
 		KVM_MMU_UNLOCK(kvm);
 
@@ -1324,7 +1317,8 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 
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

