Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F165B3570
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbiIIKpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiIIKpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:45:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80174F66E
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662720316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DkIOa4ss6n0l+Uwq2rxErjUkkNwBYbVflsNmqJrnW0=;
        b=YY6k29Nz9jbW9VAXx0bcEVoIe2pXj94S+cDqUEISUbtL6H08UiPbcm2FRn5rF9B39llhSq
        Jsf2QcFcIiOtGg337UHKOZ2GtDUT9EYDpTlRBXe38xbpo0WiIaZk0okks+RpZvfRFBmVuC
        2eEyupiziv9vC13UXGFd3Ev4h8IPx4w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-65-mP8g3QoaPCyRCIhg2g8B6A-1; Fri, 09 Sep 2022 06:45:12 -0400
X-MC-Unique: mP8g3QoaPCyRCIhg2g8B6A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DC66B80029D;
        Fri,  9 Sep 2022 10:45:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A63D40D282E;
        Fri,  9 Sep 2022 10:45:11 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Subject: [RFC PATCH 6/9] kvm_main.c: simplify change-specific callbacks
Date:   Fri,  9 Sep 2022 06:45:03 -0400
Message-Id: <20220909104506.738478-7-eesposit@redhat.com>
In-Reply-To: <20220909104506.738478-1-eesposit@redhat.com>
References: <20220909104506.738478-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of replacing the memslot in the inactive slots and
activate for each "change" specific function (NEW, MOVE, DELETE, ...),
make kvm_set_memslot() replace the memslot in current inactive list
and swap the lists, and then kvm_finish_memslot just takes care of
updating the new inactive list (was active).

We can generalize here the pre-swap replacement with
replace(old, new) because even if in a DELETE or MOVE operation,
old will always stay in the inactive list (used by kvm_replace_memslot).

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 virt/kvm/kvm_main.c | 44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9d917af30593..6b73615891f0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1747,34 +1747,26 @@ static void kvm_invalidate_memslot(struct kvm *kvm,
 static void kvm_create_memslot(struct kvm *kvm,
 			       struct kvm_memory_slot *new)
 {
-	/* Add the new memslot to the inactive set and activate. */
+	/* Update inactive slot (was active) by adding the new slot */
 	kvm_replace_memslot(kvm, NULL, new);
-	kvm_activate_memslot(kvm, NULL, new);
 }
 
 static void kvm_delete_memslot(struct kvm *kvm,
-			       struct kvm_memory_slot *old,
 			       struct kvm_memory_slot *invalid_slot)
 {
-	/*
-	 * Remove the old memslot (in the inactive memslots) by passing NULL as
-	 * the "new" slot, and for the invalid version in the active slots.
-	 */
-	kvm_replace_memslot(kvm, old, NULL);
-	kvm_activate_memslot(kvm, invalid_slot, NULL);
+	/* Update inactive slot (was active) by removing the invalid slot */
+	kvm_replace_memslot(kvm, invalid_slot, NULL);
 }
 
 static void kvm_move_memslot(struct kvm *kvm,
-			     struct kvm_memory_slot *old,
 			     struct kvm_memory_slot *new,
 			     struct kvm_memory_slot *invalid_slot)
 {
 	/*
-	 * Replace the old memslot in the inactive slots, and then swap slots
-	 * and replace the current INVALID with the new as well.
+	 * Update inactive slot (was active) by removing the invalid slot
+	 * and adding the new one.
 	 */
-	kvm_replace_memslot(kvm, old, new);
-	kvm_activate_memslot(kvm, invalid_slot, new);
+	kvm_replace_memslot(kvm, invalid_slot, new);
 }
 
 static void kvm_update_flags_memslot(struct kvm *kvm,
@@ -1782,12 +1774,10 @@ static void kvm_update_flags_memslot(struct kvm *kvm,
 				     struct kvm_memory_slot *new)
 {
 	/*
-	 * Similar to the MOVE case, but the slot doesn't need to be zapped as
-	 * an intermediate step. Instead, the old memslot is simply replaced
-	 * with a new, updated copy in both memslot sets.
+	 * Update inactive slot (was active) by removing the old slot
+	 * and adding the new one.
 	 */
 	kvm_replace_memslot(kvm, old, new);
-	kvm_activate_memslot(kvm, old, new);
 }
 
 /*
@@ -1880,9 +1870,9 @@ static void kvm_finish_memslot(struct kvm *kvm,
 	if (change == KVM_MR_CREATE)
 		kvm_create_memslot(kvm, new);
 	else if (change == KVM_MR_DELETE)
-		kvm_delete_memslot(kvm, old, invalid_slot);
+		kvm_delete_memslot(kvm, invalid_slot);
 	else if (change == KVM_MR_MOVE)
-		kvm_move_memslot(kvm, old, new, invalid_slot);
+		kvm_move_memslot(kvm, new, invalid_slot);
 	else if (change == KVM_MR_FLAGS_ONLY)
 		kvm_update_flags_memslot(kvm, old, new);
 	else
@@ -1903,12 +1893,24 @@ static void kvm_finish_memslot(struct kvm *kvm,
 static int kvm_set_memslot(struct kvm *kvm,
 			   struct kvm_internal_memory_region_list *batch)
 {
-	int r;
+	int r, as_id;
 
 	r = kvm_prepare_memslot(kvm, batch);
 	if (r)
 		return r;
 
+	/*
+	 * if change is DELETE or MOVE, invalid is in active memslots
+	 * and old in inactive, so replace old with new.
+	 */
+	kvm_replace_memslot(kvm, batch->old, batch->new);
+
+	/* either old or invalid is the same, since invalid is old's copy */
+	as_id = kvm_memslots_get_as_id(batch->old, batch->new);
+
+	/* releases kvm->slots_arch_lock */
+	kvm_swap_active_memslots(kvm, as_id);
+
 	kvm_finish_memslot(kvm, batch);
 
 	return 0;
-- 
2.31.1

