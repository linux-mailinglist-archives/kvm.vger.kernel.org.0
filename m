Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFDA5B3572
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiIIKpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiIIKpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:45:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05214501A3
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662720317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ga0KXbfsZxBvniEYK+V0PLuE8LBCeWPj6GbvQKqhHp4=;
        b=KpbecsM0gQsNbDjufhUUFX2OudHHpQcAdlEW6ZnsRUfcUZ8e7AW5N6PvZJ++3zxhYz35h7
        DmlNEqsXUL8Jk0aQXojQyQunvIZaMAPtbplmsN9F9yzr/DYC6EnZRkVuVn4RbR/AU8j4+l
        +TUtY/fnw9LLFM42KiuswR6kl4ZkZw0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-up2WwOObMYGsMZmYRXOhfQ-1; Fri, 09 Sep 2022 06:45:12 -0400
X-MC-Unique: up2WwOObMYGsMZmYRXOhfQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7144A802E5D;
        Fri,  9 Sep 2022 10:45:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0DFA940D282E;
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
Subject: [RFC PATCH 5/9] kvm_main.c: split __kvm_set_memory_region logic in kvm_check_mem and kvm_prepare_batch
Date:   Fri,  9 Sep 2022 06:45:02 -0400
Message-Id: <20220909104506.738478-6-eesposit@redhat.com>
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

Just a function split. No functional change intended,
except for the fact that kvm_prepare_batch() does not
immediately call kvm_set_memslot() if batch->change is
KVM_MR_DELETE, but delegates the caller (__kvm_set_memory_region).

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 virt/kvm/kvm_main.c | 120 +++++++++++++++++++++++++++++---------------
 1 file changed, 79 insertions(+), 41 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 17f07546d591..9d917af30593 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1927,19 +1927,9 @@ static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
 	return false;
 }
 
-/*
- * Allocate some memory and give it an address in the guest physical address
- * space.
- *
- * Discontiguous memory is allowed, mostly for framebuffers.
- * This function takes also care of initializing batch->new/old/invalid/change
- * fields.
- *
- * Must be called holding kvm->slots_lock for write.
- */
-int __kvm_set_memory_region(struct kvm *kvm,
-			    const struct kvm_userspace_memory_region *mem,
-			    struct kvm_internal_memory_region_list *batch)
+static int kvm_prepare_batch(struct kvm *kvm,
+			     const struct kvm_userspace_memory_region *mem,
+			     struct kvm_internal_memory_region_list *batch)
 {
 	struct kvm_memory_slot *old, *new;
 	struct kvm_memslots *slots;
@@ -1947,34 +1937,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	unsigned long npages;
 	gfn_t base_gfn;
 	int as_id, id;
-	int r;
-
-	r = check_memory_region_flags(mem);
-	if (r)
-		return r;
 
 	as_id = mem->slot >> 16;
 	id = (u16)mem->slot;
 
-	/* General sanity checks */
-	if ((mem->memory_size & (PAGE_SIZE - 1)) ||
-	    (mem->memory_size != (unsigned long)mem->memory_size))
-		return -EINVAL;
-	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
-		return -EINVAL;
-	/* We can read the guest memory with __xxx_user() later on. */
-	if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
-	    (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
-	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
-			mem->memory_size))
-		return -EINVAL;
-	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_MEM_SLOTS_NUM)
-		return -EINVAL;
-	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
-		return -EINVAL;
-	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
-		return -EINVAL;
-
 	slots = __kvm_memslots(kvm, as_id);
 
 	/*
@@ -1993,7 +1959,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 		batch->change = KVM_MR_DELETE;
 		batch->new = NULL;
-		return kvm_set_memslot(kvm, batch);
+		return 0;
 	}
 
 	base_gfn = (mem->guest_phys_addr >> PAGE_SHIFT);
@@ -2020,7 +1986,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		else if (mem->flags != old->flags)
 			change = KVM_MR_FLAGS_ONLY;
 		else /* Nothing to change. */
-			return 0;
+			return 1;
 	}
 
 	if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
@@ -2041,12 +2007,81 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	batch->new = new;
 	batch->change = change;
+	return 0;
+}
+
+static int kvm_check_mem(const struct kvm_userspace_memory_region *mem)
+{
+	int as_id, id;
+
+	as_id = mem->slot >> 16;
+	id = (u16)mem->slot;
+
+	/* General sanity checks */
+	if ((mem->memory_size & (PAGE_SIZE - 1)) ||
+	    (mem->memory_size != (unsigned long)mem->memory_size))
+		return -EINVAL;
+	if (mem->guest_phys_addr & (PAGE_SIZE - 1))
+		return -EINVAL;
+	/* We can read the guest memory with __xxx_user() later on. */
+	if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
+	    (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
+	     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
+			mem->memory_size))
+		return -EINVAL;
+	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_MEM_SLOTS_NUM)
+		return -EINVAL;
+	if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
+		return -EINVAL;
+	if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int kvm_check_memory_region(struct kvm *kvm,
+				const struct kvm_userspace_memory_region *mem,
+				struct kvm_internal_memory_region_list *batch)
+{
+	int r;
+
+	r = check_memory_region_flags(mem);
+	if (r)
+		return r;
 
-	r = kvm_set_memslot(kvm, batch);
+	r = kvm_check_mem(mem);
 	if (r)
-		kfree(new);
+		return r;
+
+	r = kvm_prepare_batch(kvm, mem, batch);
+	if (r && batch->new)
+		kfree(batch->new);
+
 	return r;
 }
+
+/*
+ * Allocate some memory and give it an address in the guest physical address
+ * space.
+ *
+ * Discontiguous memory is allowed, mostly for framebuffers.
+ * This function takes also care of initializing batch->new/old/invalid/change
+ * fields.
+ *
+ * Must be called holding kvm->slots_lock for write.
+ */
+int __kvm_set_memory_region(struct kvm *kvm,
+			    const struct kvm_userspace_memory_region *mem,
+			    struct kvm_internal_memory_region_list *batch)
+{
+	int r;
+
+	r = kvm_check_memory_region(kvm, mem, batch);
+	if (r)
+		return r;
+
+	return kvm_set_memslot(kvm, batch);
+}
 EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
 
 static int kvm_set_memory_region(struct kvm *kvm,
@@ -2061,6 +2096,9 @@ static int kvm_set_memory_region(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);
 	r = __kvm_set_memory_region(kvm, mem, batch);
 	mutex_unlock(&kvm->slots_lock);
+	/* r == 1 means empty request, nothing to do but no error */
+	if (r == 1)
+		r = 0;
 	return r;
 }
 
-- 
2.31.1

