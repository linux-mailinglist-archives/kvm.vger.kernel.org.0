Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 224D362E31B
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240343AbiKQRcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240223AbiKQRcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:32:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4D478D58
        for <kvm@vger.kernel.org>; Thu, 17 Nov 2022 09:31:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668706273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=p1GI2VNoPaGQyRAAXXiY/Ulwq6xE6NBmpOnV6mOfH+A=;
        b=JdAYxJwFeopzPxKIsutLoZyfrm8qAIaBrHg0P3xt5ZowmUi+9bgjncq5kuqh4cNO+KP+OL
        1MFwUa5CHGffQ7HIk/ycOBAlEglu9tee4wILvnFsoV1IKIyMl2nbPU+7AaGS8yh2BZJPvl
        sHhJu/nxxiuPx8SO+iTszP9TQO3ojY0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-582-x2IkZqB3MMqHY2Up3EMaLw-1; Thu, 17 Nov 2022 12:31:10 -0500
X-MC-Unique: x2IkZqB3MMqHY2Up3EMaLw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5A11811E67;
        Thu, 17 Nov 2022 17:31:09 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2CEE112C062;
        Thu, 17 Nov 2022 17:31:09 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH] KVM: x86: avoid memslot check in NX hugepage recovery if it cannot be true
Date:   Thu, 17 Nov 2022 12:31:09 -0500
Message-Id: <20221117173109.3126912-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c   | 22 +++++++++++++++++++---
 include/linux/kvm_host.h |  5 +++++
 virt/kvm/kvm_main.c      |  5 +++++
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cfff74685a25..d4ec9491d468 100644
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
+		 * of kvm->nr_logpage_memslots is not a problem: if it is becoming
+		 * zero, gfn_to_memslot() will be done unnecessarily; if it is
+		 * becoming nonzero, the page will be zapped unnecessarily.
+		 * Either way, this only affects efficiency in racy situations,
+		 * and not correctness.
 		 */
+		slot = NULL;
+		if (atomic_read(&kvm->nr_logpage_memslots)) {
+			slot = gfn_to_memslot(kvm, sp->gfn);
+			WARN_ON_ONCE(!slot);
+		}
+
 		if (slot && kvm_slot_dirty_track_enabled(slot))
 			unaccount_nx_huge_page(kvm, sp);
 		else if (is_tdp_mmu_page(sp))
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e6e66c5e56f2..b3c2b975e737 100644
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
+	atomic_t nr_logpage_memslots;
 
 	/* Used to wait for completion of MMU notifiers.  */
 	spinlock_t mn_invalidate_lock;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 43bbe4fde078..7670ebd29bcf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1627,6 +1627,11 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 		}
 	}
 
+	atomic_set(&kvm->nr_logpage_memslots,
+		   atomic_read(&kvm->nr_logpage_memslots)
+		   + !!(new->flags & KVM_MEM_LOG_DIRTY_PAGES)
+		   - !!(old->flags & KVM_MEM_LOG_DIRTY_PAGES));
+
 	r = kvm_arch_prepare_memory_region(kvm, old, new, change);
 
 	/* Free the bitmap on failure if it was allocated above. */
-- 
2.31.1

