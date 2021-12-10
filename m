Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5136A4705DA
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243671AbhLJQkY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243659AbhLJQkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:40:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21692C061746
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dq6kCfTobkJAf9urX0UZuHspNC1NMoB5EfP9wWTBNzw=; b=kQ247fqZ0qEzHQWiwCe7gUNMt9
        1dV51vfwVzhk54FRiZtGesRAqlkpfr13lQzqz7xB9c8g3zq82M6uMFnMhFuthf83KqzKYGAMRvBiE
        OtSJK5KqhYLfi4rOaPpVZ8PUZuUpk0EBzHWWerCFe9j/Ax8cSn6ePorS1dDogK92H77lz3aFNN0QJ
        JToEHa2DcEet1YLNGNqov5XhkC3PVKYbuh66qkCEa7iaEbi+6bVmLuPT/AeIXtV6b6/hYvUDVsewd
        WKDDMZLLldUpEVhLOtB2Cn2BM/Cfd1EToWv/8NhUyBLDgQz6T1BWqKLg6TssQR6dewZI/6TCKWyYN
        Af4G/stw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvisk-00AUQu-Nb; Fri, 10 Dec 2021 16:36:27 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvisl-0000lX-0J; Fri, 10 Dec 2021 16:36:27 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
Subject: [PATCH v6 1/6] KVM: Warn if mark_page_dirty() is called without an active vCPU
Date:   Fri, 10 Dec 2021 16:36:20 +0000
Message-Id: <20211210163625.2886-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211210163625.2886-1-dwmw2@infradead.org>
References: <20211210163625.2886-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The various kvm_write_guest() and mark_page_dirty() functions must only
ever be called in the context of an active vCPU, because if dirty ring
tracking is enabled it may simply oops when kvm_get_running_vcpu()
returns NULL for the vcpu and then kvm_dirty_ring_get() dereferences it.

This oops was reported by "butt3rflyh4ck" <butterflyhuangxx@gmail.com> in
https://lore.kernel.org/kvm/CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com/

That actual bug will be fixed under separate cover but this warning
should help to prevent new ones from being added.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/kvm_dirty_ring.h | 6 ------
 virt/kvm/dirty_ring.c          | 9 ---------
 virt/kvm/kvm_main.c            | 7 ++++++-
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
index 4da8d4a4140b..906f899813dc 100644
--- a/include/linux/kvm_dirty_ring.h
+++ b/include/linux/kvm_dirty_ring.h
@@ -43,11 +43,6 @@ static inline int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring,
 	return 0;
 }
 
-static inline struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm)
-{
-	return NULL;
-}
-
 static inline int kvm_dirty_ring_reset(struct kvm *kvm,
 				       struct kvm_dirty_ring *ring)
 {
@@ -78,7 +73,6 @@ static inline bool kvm_dirty_ring_soft_full(struct kvm_dirty_ring *ring)
 
 u32 kvm_dirty_ring_get_rsvd_entries(void);
 int kvm_dirty_ring_alloc(struct kvm_dirty_ring *ring, int index, u32 size);
-struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm);
 
 /*
  * called with kvm->slots_lock held, returns the number of
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 88f4683198ea..8e9874760fb3 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -36,15 +36,6 @@ static bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring)
 	return kvm_dirty_ring_used(ring) >= ring->size;
 }
 
-struct kvm_dirty_ring *kvm_dirty_ring_get(struct kvm *kvm)
-{
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
-
-	WARN_ON_ONCE(vcpu->kvm != kvm);
-
-	return &vcpu->dirty_ring;
-}
-
 static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 {
 	struct kvm_memory_slot *memslot;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b0f7e6eb00ff..af5b4427b139 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3155,12 +3155,17 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 			     const struct kvm_memory_slot *memslot,
 		 	     gfn_t gfn)
 {
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
+		return;
+
 	if (memslot && kvm_slot_dirty_track_enabled(memslot)) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
 		if (kvm->dirty_ring_size)
-			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
+			kvm_dirty_ring_push(&vcpu->dirty_ring,
 					    slot, rel_gfn);
 		else
 			set_bit_le(rel_gfn, memslot->dirty_bitmap);
-- 
2.31.1

