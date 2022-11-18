Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E880362FA2E
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 17:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241525AbiKRQZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 11:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235244AbiKRQZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 11:25:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBDC4E419
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 08:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668788694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VIFXzISWDSZ2SY1WXY+cKR0iv8RpxMgZFg1w+6NDDOo=;
        b=jFK0fFrndDrtamTNXWEBQj7EG4cIcJLeGg8S8DtAykRW1XEYigxFKNOv+IUU16Wg+CrJ+d
        WQCPYFrbznaPrGB+btR36BGuUlY2MCDz/Zi/BLymyOBW857DAsMsVvA2M1JMZCR2Z2OQpT
        aoKoA79xX1IiPBezhcSpXoKC89xt3M4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-xJe7JrFvOkukbvsG6v2QJA-1; Fri, 18 Nov 2022 11:24:48 -0500
X-MC-Unique: xJe7JrFvOkukbvsG6v2QJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EA1C3C0DDAC;
        Fri, 18 Nov 2022 16:24:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B7B4C06218;
        Fri, 18 Nov 2022 16:24:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2] KVM: x86: avoid memslot check in NX hugepage recovery if it cannot succeed
Date:   Fri, 18 Nov 2022 11:24:47 -0500
Message-Id: <20221118162447.3185950-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since gfn_to_memslot() is relatively expensive, it helps to
skip it if it the memslot cannot possibly have dirty logging
enabled.  In order to do this, add to struct kvm a counter
of the number of log-page memslots.  While the correct value
can only be read with slots_lock taken, the NX recovery thread
is content with using an approximate value.  Therefore, the
counter is an atomic_t.

Based on https://lore.kernel.org/kvm/20221027200316.2221027-2-dmatlack@google.com/
by David Matlack.

Supersedes: <20221117173109.3126912-1-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: actually works, using ideas from David's v1

 arch/x86/kvm/mmu/mmu.c   | 22 +++++++++++++++++++---
 include/linux/kvm_host.h |  5 +++++
 virt/kvm/kvm_main.c      |  7 +++++++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cfff74685a25..4736d7849c60 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6878,16 +6878,32 @@ static void kvm_recover_nx_huge_pages(struct kvm *kvm)
 		WARN_ON_ONCE(!sp->nx_huge_page_disallowed);
 		WARN_ON_ONCE(!sp->role.direct);
 
-		slot = gfn_to_memslot(kvm, sp->gfn);
-		WARN_ON_ONCE(!slot);
-
 		/*
 		 * Unaccount and do not attempt to recover any NX Huge Pages
 		 * that are being dirty tracked, as they would just be faulted
 		 * back in as 4KiB pages. The NX Huge Pages in this slot will be
 		 * recovered, along with all the other huge pages in the slot,
 		 * when dirty logging is disabled.
+		 *
+		 * Since gfn_to_memslot() is relatively expensive, it helps to
+		 * skip it if it the test cannot possibly return true.  On the
+		 * other hand, if any memslot has logging enabled, chances are
+		 * good that all of them do, in which case unaccount_nx_huge_page()
+		 * is much cheaper than zapping the page.
+		 *
+		 * If a memslot update is in progress, reading an incorrect value
+		 * of kvm->nr_memslots_dirty_logging is not a problem: if it is
+		 * becoming zero, gfn_to_memslot() will be done unnecessarily; if
+		 * it is becoming nonzero, the page will be zapped unnecessarily.
+		 * Either way, this only affects efficiency in racy situations,
+		 * and not correctness.
 		 */
+		slot = NULL;
+		if (atomic_read(&kvm->nr_memslots_dirty_logging)) {
+			slot = gfn_to_memslot(kvm, sp->gfn);
+			WARN_ON_ONCE(!slot);
+		}
+
 		if (slot && kvm_slot_dirty_track_enabled(slot))
 			unaccount_nx_huge_page(kvm, sp);
 		else if (is_tdp_mmu_page(sp))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e6e66c5e56f2..6f0f389f5f9c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -722,6 +722,11 @@ struct kvm {
 	/* The current active memslot set for each address space */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct xarray vcpu_array;
+	/*
+	 * Protected by slots_lock, but can be read outside if an
+	 * incorrect answer is acceptable.
+	 */
+	atomic_t nr_memslots_dirty_logging;
 
 	/* Used to wait for completion of MMU notifiers.  */
 	spinlock_t mn_invalidate_lock;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 43bbe4fde078..5d85f1a61793 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1603,6 +1603,8 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 				     struct kvm_memory_slot *new,
 				     enum kvm_mr_change change)
 {
+	int old_flags = old ? old->flags : 0;
+	int new_flags = new ? new->flags : 0;
 	int r;
 
 	/*
@@ -1627,6 +1629,11 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 		}
 	}
 
+	if ((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES) {
+		int change = (new_flags & KVM_MEM_LOG_DIRTY_PAGES) ? 1 : -1;
+		atomic_set(&kvm->nr_memslots_dirty_logging,
+			   atomic_read(&kvm->nr_memslots_dirty_logging) + change);
+	}
 	r = kvm_arch_prepare_memory_region(kvm, old, new, change);
 
 	/* Free the bitmap on failure if it was allocated above. */
-- 
2.31.1

