Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B9D5B357B
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiIIKp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiIIKpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:45:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFBC4DB7E
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662720315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8Uwqb2u54NGuVgopEXAeF7Kt4xDeaUDYurd/mYS65U=;
        b=eEvAAQmNGHsQ+sBQvGtjlEvmMPO/r3B1jJzSnvEnZHOGa+evU/10MkpIkC7fHO2I1puUi3
        j1+tFGR/4fmDdoZ1sRW4QUcWkEogtWYkfupqPQLSPiFRfOlXFtYhEIs2Hi43OS2C9QmRSH
        NNNGAgmRxCvlE2YSylhB7gkU9y4hXJA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-YI5_BTabN4-gBYxsFpbhVA-1; Fri, 09 Sep 2022 06:45:11 -0400
X-MC-Unique: YI5_BTabN4-gBYxsFpbhVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 049063C0E210;
        Fri,  9 Sep 2022 10:45:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9645340D282E;
        Fri,  9 Sep 2022 10:45:10 +0000 (UTC)
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
Subject: [RFC PATCH 4/9] kvm_main.c: split logic in kvm_set_memslots
Date:   Fri,  9 Sep 2022 06:45:01 -0400
Message-Id: <20220909104506.738478-5-eesposit@redhat.com>
In-Reply-To: <20220909104506.738478-1-eesposit@redhat.com>
References: <20220909104506.738478-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At this point it is also just a split, but later will handle atomic
memslot updates (thus avoiding swapping the memslot list every time).

No functional change intended.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 virt/kvm/kvm_main.c | 37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e4fab15d0d4b..17f07546d591 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1790,12 +1790,15 @@ static void kvm_update_flags_memslot(struct kvm *kvm,
 	kvm_activate_memslot(kvm, old, new);
 }
 
-static int kvm_set_memslot(struct kvm *kvm,
-			   struct kvm_internal_memory_region_list *batch)
+/*
+ * Takes kvm->slots_arch_lock, and releases it only if
+ * invalid_slot allocation or kvm_prepare_memory_region failed.
+ */
+static int kvm_prepare_memslot(struct kvm *kvm,
+			       struct kvm_internal_memory_region_list *batch)
 {
 	struct kvm_memory_slot *invalid_slot;
 	struct kvm_memory_slot *old = batch->old;
-	struct kvm_memory_slot *new = batch->new;
 	enum kvm_mr_change change = batch->change;
 	int r;
 
@@ -1829,7 +1832,8 @@ static int kvm_set_memslot(struct kvm *kvm,
 	 * invalidation needs to be reverted.
 	 */
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-		invalid_slot = kzalloc(sizeof(*invalid_slot), GFP_KERNEL_ACCOUNT);
+		invalid_slot = kzalloc(sizeof(*invalid_slot),
+				       GFP_KERNEL_ACCOUNT);
 		if (!invalid_slot) {
 			mutex_unlock(&kvm->slots_arch_lock);
 			return -ENOMEM;
@@ -1847,13 +1851,24 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 * release slots_arch_lock.
 		 */
 		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+			/* kvm_activate_memslot releases kvm->slots_arch_lock */
 			kvm_activate_memslot(kvm, invalid_slot, old);
 			kfree(invalid_slot);
 		} else {
 			mutex_unlock(&kvm->slots_arch_lock);
 		}
-		return r;
 	}
+	return r;
+}
+
+/* Must be called with kvm->slots_arch_lock held, but releases it. */
+static void kvm_finish_memslot(struct kvm *kvm,
+			       struct kvm_internal_memory_region_list *batch)
+{
+	struct kvm_memory_slot *invalid_slot = batch->invalid;
+	struct kvm_memory_slot *old = batch->old;
+	struct kvm_memory_slot *new = batch->new;
+	enum kvm_mr_change change = batch->change;
 
 	/*
 	 * For DELETE and MOVE, the working slot is now active as the INVALID
@@ -1883,6 +1898,18 @@ static int kvm_set_memslot(struct kvm *kvm,
 	 * responsible for knowing that new->arch may be stale.
 	 */
 	kvm_commit_memory_region(kvm, batch);
+}
+
+static int kvm_set_memslot(struct kvm *kvm,
+			   struct kvm_internal_memory_region_list *batch)
+{
+	int r;
+
+	r = kvm_prepare_memslot(kvm, batch);
+	if (r)
+		return r;
+
+	kvm_finish_memslot(kvm, batch);
 
 	return 0;
 }
-- 
2.31.1

