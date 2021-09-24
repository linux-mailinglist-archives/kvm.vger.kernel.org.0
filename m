Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41124178AD
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347728AbhIXQeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347562AbhIXQdo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iM8RwW4DuJD/gTDxpnUKn09Mj0cXhEPEhrCBKhqSA4M=;
        b=ftX3Cc2NPj3kvckBsuAqB8KfZ81Nk5mZH/By4AotYtw7cDKmi+ngBe+CV3Ki7FrHgr0Ex3
        tvJM5wvUHBZavbbEBWlqwerVrJ3JSW6iJBUKPIbgZzJryjQQT826XSY8Fc6ZgKVBpyjDrn
        eUaYZSbHN4sNMdhKOBvwIxfPYWRbX2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-MbgS6LCRNH-j2-OYfPUF6A-1; Fri, 24 Sep 2021 12:32:06 -0400
X-MC-Unique: MbgS6LCRNH-j2-OYfPUF6A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D078991275;
        Fri, 24 Sep 2021 16:32:05 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CFC75C1CF;
        Fri, 24 Sep 2021 16:32:05 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 21/31] KVM: x86/mmu: Avoid memslot lookup in page_fault_handle_page_track
Date:   Fri, 24 Sep 2021 12:31:42 -0400
Message-Id: <20210924163152.289027-22-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Matlack <dmatlack@google.com>

Now that kvm_page_fault has a pointer to the memslot it can be passed
down to the page tracking code to avoid a redundant slot lookup.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20210813203504.2742757-5-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_page_track.h |  2 ++
 arch/x86/kvm/mmu/mmu.c                |  2 +-
 arch/x86/kvm/mmu/page_track.c         | 20 +++++++++++++-------
 3 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 6a5f3acf2b33..9cd9230e5cc8 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -61,6 +61,8 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     enum kvm_page_track_mode mode);
 bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 			      enum kvm_page_track_mode mode);
+bool kvm_slot_page_track_is_active(struct kvm_memory_slot *slot, gfn_t gfn,
+				   enum kvm_page_track_mode mode);
 
 void
 kvm_page_track_register_notifier(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 754578458cb7..d63fe7b10bd1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3819,7 +3819,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_page_track_is_active(vcpu, fault->gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
 		return true;
 
 	return false;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 21427e84a82e..859800f7bb95 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -136,19 +136,14 @@ void kvm_slot_page_track_remove_page(struct kvm *kvm,
 }
 EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
 
-/*
- * check if the corresponding access on the specified guest page is tracked.
- */
-bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
-			      enum kvm_page_track_mode mode)
+bool kvm_slot_page_track_is_active(struct kvm_memory_slot *slot, gfn_t gfn,
+				   enum kvm_page_track_mode mode)
 {
-	struct kvm_memory_slot *slot;
 	int index;
 
 	if (WARN_ON(!page_track_mode_is_valid(mode)))
 		return false;
 
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	if (!slot)
 		return false;
 
@@ -156,6 +151,17 @@ bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return !!READ_ONCE(slot->arch.gfn_track[mode][index]);
 }
 
+/*
+ * check if the corresponding access on the specified guest page is tracked.
+ */
+bool kvm_page_track_is_active(struct kvm_vcpu *vcpu, gfn_t gfn,
+			      enum kvm_page_track_mode mode)
+{
+	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+
+	return kvm_slot_page_track_is_active(slot, gfn, mode);
+}
+
 void kvm_page_track_cleanup(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_head *head;
-- 
2.27.0


