Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BEB45B356B
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiIIKpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiIIKpR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:45:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72764C620
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662720314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E7/IU2R6um6C8tfOW4fXuw4iFHpygm2D4d5AJXUUCVc=;
        b=DoGW1O/qcc6RH4Exo1sJqHN3p00WLkegSbcy6Kg5LnKpHX0RIoa1soQp5t/cc2Avg+EOQB
        k11OR616BSDps9t9wYKgDwRpJ5t5GE5tPh3kND/l02EoCNmglHBOlj2pDLTva8CQja+C0R
        9Wu8Oj72kh8zNMhdfoBzpsimRoCYbTA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-tBzAaOcGPbmx8yJxhzsLMg-1; Fri, 09 Sep 2022 06:45:11 -0400
X-MC-Unique: tBzAaOcGPbmx8yJxhzsLMg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D91A80029D;
        Fri,  9 Sep 2022 10:45:10 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2548D40D282E;
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
Subject: [RFC PATCH 3/9] kvm_main.c: introduce kvm_internal_memory_region_list
Date:   Fri,  9 Sep 2022 06:45:00 -0400
Message-Id: <20220909104506.738478-4-eesposit@redhat.com>
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

For now this struct is only used to pass new,old and change
variable in a single parameter instead of three.

In future, it will be used to also carry additional information
and handle atomic memslot updates.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 arch/x86/kvm/x86.c       |  3 ++-
 include/linux/kvm_host.h | 15 +++++++++++-
 virt/kvm/kvm_main.c      | 52 +++++++++++++++++++++++++++-------------
 3 files changed, 51 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 567d13405445..da5a5dd3d4bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12155,13 +12155,14 @@ void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		struct kvm_userspace_memory_region m;
+		struct kvm_internal_memory_region_list b = { 0 };
 
 		m.slot = id | (i << 16);
 		m.flags = 0;
 		m.guest_phys_addr = gpa;
 		m.userspace_addr = hva;
 		m.memory_size = size;
-		r = __kvm_set_memory_region(kvm, &m);
+		r = __kvm_set_memory_region(kvm, &m, &b);
 		if (r < 0)
 			return ERR_PTR_USR(r);
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1c5b7b2e35dd..69af94472b39 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1108,8 +1108,21 @@ enum kvm_mr_change {
 	KVM_MR_FLAGS_ONLY,
 };
 
+/*
+ * Internally used to atomically update multiple memslots.
+ * Must be always zeroed by the caller.
+ */
+struct kvm_internal_memory_region_list {
+	/* Fields initialized in __kvm_set_memory_region() */
+	struct kvm_memory_slot *old;
+	struct kvm_memory_slot *new;
+	struct kvm_memory_slot *invalid;
+	enum kvm_mr_change change;
+};
+
 int __kvm_set_memory_region(struct kvm *kvm,
-			    const struct kvm_userspace_memory_region *mem);
+			    const struct kvm_userspace_memory_region *mem,
+			    struct kvm_internal_memory_region_list *batch);
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen);
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 339de0ed4557..e4fab15d0d4b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1583,10 +1583,11 @@ static void kvm_swap_active_memslots(struct kvm *kvm, int as_id)
 }
 
 static int kvm_prepare_memory_region(struct kvm *kvm,
-				     const struct kvm_memory_slot *old,
-				     struct kvm_memory_slot *new,
-				     enum kvm_mr_change change)
+				     struct kvm_internal_memory_region_list *batch)
 {
+	struct kvm_memory_slot *old = batch->old;
+	struct kvm_memory_slot *new = batch->new;
+	enum kvm_mr_change change = batch->change;
 	int r;
 
 	/*
@@ -1621,10 +1622,12 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 }
 
 static void kvm_commit_memory_region(struct kvm *kvm,
-				     struct kvm_memory_slot *old,
-				     const struct kvm_memory_slot *new,
-				     enum kvm_mr_change change)
+				     struct kvm_internal_memory_region_list *batch)
 {
+	struct kvm_memory_slot *old = batch->old;
+	struct kvm_memory_slot *new = batch->new;
+	enum kvm_mr_change change = batch->change;
+
 	/*
 	 * Update the total number of memslot pages before calling the arch
 	 * hook so that architectures can consume the result directly.
@@ -1788,11 +1791,12 @@ static void kvm_update_flags_memslot(struct kvm *kvm,
 }
 
 static int kvm_set_memslot(struct kvm *kvm,
-			   struct kvm_memory_slot *old,
-			   struct kvm_memory_slot *new,
-			   enum kvm_mr_change change)
+			   struct kvm_internal_memory_region_list *batch)
 {
 	struct kvm_memory_slot *invalid_slot;
+	struct kvm_memory_slot *old = batch->old;
+	struct kvm_memory_slot *new = batch->new;
+	enum kvm_mr_change change = batch->change;
 	int r;
 
 	/*
@@ -1830,10 +1834,11 @@ static int kvm_set_memslot(struct kvm *kvm,
 			mutex_unlock(&kvm->slots_arch_lock);
 			return -ENOMEM;
 		}
+		batch->invalid = invalid_slot;
 		kvm_invalidate_memslot(kvm, old, invalid_slot);
 	}
 
-	r = kvm_prepare_memory_region(kvm, old, new, change);
+	r = kvm_prepare_memory_region(kvm, batch);
 	if (r) {
 		/*
 		 * For DELETE/MOVE, revert the above INVALID change.  No
@@ -1877,7 +1882,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 	 * will directly hit the final, active memslot.  Architectures are
 	 * responsible for knowing that new->arch may be stale.
 	 */
-	kvm_commit_memory_region(kvm, old, new, change);
+	kvm_commit_memory_region(kvm, batch);
 
 	return 0;
 }
@@ -1900,11 +1905,14 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
  * space.
  *
  * Discontiguous memory is allowed, mostly for framebuffers.
+ * This function takes also care of initializing batch->new/old/invalid/change
+ * fields.
  *
  * Must be called holding kvm->slots_lock for write.
  */
 int __kvm_set_memory_region(struct kvm *kvm,
-			    const struct kvm_userspace_memory_region *mem)
+			    const struct kvm_userspace_memory_region *mem,
+			    struct kvm_internal_memory_region_list *batch)
 {
 	struct kvm_memory_slot *old, *new;
 	struct kvm_memslots *slots;
@@ -1947,6 +1955,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	 * and/or destroyed by kvm_set_memslot().
 	 */
 	old = id_to_memslot(slots, id);
+	batch->old = old;
 
 	if (!mem->memory_size) {
 		if (!old || !old->npages)
@@ -1955,7 +1964,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
 			return -EIO;
 
-		return kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE);
+		batch->change = KVM_MR_DELETE;
+		batch->new = NULL;
+		return kvm_set_memslot(kvm, batch);
 	}
 
 	base_gfn = (mem->guest_phys_addr >> PAGE_SHIFT);
@@ -1963,6 +1974,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	if (!old || !old->npages) {
 		change = KVM_MR_CREATE;
+		batch->old = NULL;
 
 		/*
 		 * To simplify KVM internals, the total number of pages across
@@ -2000,7 +2012,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
 
-	r = kvm_set_memslot(kvm, old, new, change);
+	batch->new = new;
+	batch->change = change;
+
+	r = kvm_set_memslot(kvm, batch);
 	if (r)
 		kfree(new);
 	return r;
@@ -2008,7 +2023,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
 
 static int kvm_set_memory_region(struct kvm *kvm,
-				 const struct kvm_userspace_memory_region *mem)
+				 const struct kvm_userspace_memory_region *mem,
+				 struct kvm_internal_memory_region_list *batch)
 {
 	int r;
 
@@ -2016,7 +2032,7 @@ static int kvm_set_memory_region(struct kvm *kvm,
 		return -EINVAL;
 
 	mutex_lock(&kvm->slots_lock);
-	r = __kvm_set_memory_region(kvm, mem);
+	r = __kvm_set_memory_region(kvm, mem, batch);
 	mutex_unlock(&kvm->slots_lock);
 	return r;
 }
@@ -2024,7 +2040,9 @@ static int kvm_set_memory_region(struct kvm *kvm,
 static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 					  struct kvm_userspace_memory_region *mem)
 {
-	return kvm_set_memory_region(kvm, mem);
+	struct kvm_internal_memory_region_list batch = { 0 };
+
+	return kvm_set_memory_region(kvm, mem, &batch);
 }
 
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
-- 
2.31.1

