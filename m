Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536215B3578
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiIIKph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiIIKpU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:45:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBB14A830
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662720318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n4cgIksUzFB9SvsBadLEVot1eDVS36LvXAqIPpUHUGo=;
        b=JH+y4iIAzJ1CLiHaXSlYmWbisNj9m08oyK3h+we3TlXd/YEYZ1Rf89VRansSPD9Bv94Fpk
        GyJtMLW36Df4J3n+DVO75TsoPiNiDn9unLlT/YoGw0Ld2y+5pWB1UiY1clIzMQSviOULxo
        3lzveYxjrNA0RYoGUEqpcCrxZzm6ZbE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-400-UN6rHOoxM_C2zLMtMkJXMA-1; Fri, 09 Sep 2022 06:45:14 -0400
X-MC-Unique: UN6rHOoxM_C2zLMtMkJXMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6A77980418F;
        Fri,  9 Sep 2022 10:45:13 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0422A40D282E;
        Fri,  9 Sep 2022 10:45:12 +0000 (UTC)
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
Subject: [RFC PATCH 9/9] kvm_main.c: handle atomic memslot update
Date:   Fri,  9 Sep 2022 06:45:06 -0400
Message-Id: <20220909104506.738478-10-eesposit@redhat.com>
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

When kvm_vm_ioctl_set_memory_region_list() is invoked, we need
to make sure that all memslots are updated in the inactive list
and then swap (preferreably only once) the lists, so that all
changes are visible immediately.

The only issue is that DELETE and MOVE need to perform 2 swaps:
firstly replace old memslot with invalid, and then remove invalid.

Therefore we need to perform two passes in the memslot list provided
by the ioctl: first handle only the DELETE and MOVE memslots, by
replacing the old node with an invalid one. This implies a swap for
each memslot (they could also be grouped in a single one, but for
simplicity we are not going to do it).
Userspace already marks the DELETE and MOVE requests with the flag
invalid_slot == 1.

Then, scan again the list and update the inactive memslot list.
Once the inactive memslot list is ready, swap it only once per
address space, and conclude the memslot handling.

Regarding kvm->slots_arch_lock, it is always taken in
kvm_prepare_memslot but depending on the batch->change and loop (first,
second, conclusion) in kvm_vm_ioctl_set_memory_region_list,
we release in different places:

- change = DELETE or MOVE. In the first pass, we release after creating
the invalid memslot and swapping.

- Second loop in kvm_vm_ioctl_set_memory_region_list.
We release it in kvm_set_memslot since batch->batch is true.

- Third loop in kvm_vm_ioctl_set_memory_region_list.
We take and release it for each swap.

- Call from kvm_vm_ioctl_set_memory_region: as before this patch,
acquire in kvm_prepare_memslot and release in kvm_swap_active_memslots.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 include/linux/kvm_host.h |   4 +
 virt/kvm/kvm_main.c      | 185 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 179 insertions(+), 10 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 69af94472b39..753650145836 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1118,6 +1118,10 @@ struct kvm_internal_memory_region_list {
 	struct kvm_memory_slot *new;
 	struct kvm_memory_slot *invalid;
 	enum kvm_mr_change change;
+
+	/* Fields that need to be set by the caller */
+	bool batch;
+	bool is_move_delete;
 };
 
 int __kvm_set_memory_region(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ecd43560281c..85ba05924f0c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1782,7 +1782,8 @@ static void kvm_update_flags_memslot(struct kvm *kvm,
 
 /*
  * Takes kvm->slots_arch_lock, and releases it only if
- * invalid_slot allocation or kvm_prepare_memory_region failed.
+ * invalid_slot allocation, kvm_prepare_memory_region failed
+ * or batch->is_move_delete is true.
  */
 static int kvm_prepare_memslot(struct kvm *kvm,
 			       struct kvm_internal_memory_region_list *batch)
@@ -1822,15 +1823,26 @@ static int kvm_prepare_memslot(struct kvm *kvm,
 	 * invalidation needs to be reverted.
 	 */
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-		invalid_slot = kzalloc(sizeof(*invalid_slot),
+		if (!batch->invalid) {
+			invalid_slot = kzalloc(sizeof(*invalid_slot),
 				       GFP_KERNEL_ACCOUNT);
-		if (!invalid_slot) {
+			if (!invalid_slot) {
+				mutex_unlock(&kvm->slots_arch_lock);
+				return -ENOMEM;
+			}
+			batch->invalid = invalid_slot;
+			kvm_invalidate_memslot(kvm, old, invalid_slot);
+			kvm_replace_memslot(kvm, old, invalid_slot);
+		}
+
+		/*
+		 * We are in first pass of kvm_vm_ioctl_set_memory_region_list()
+		 * just take care of making the old slot invalid and visible.
+		 */
+		if (batch->is_move_delete) {
 			mutex_unlock(&kvm->slots_arch_lock);
-			return -ENOMEM;
+			return 0;
 		}
-		batch->invalid = invalid_slot;
-		kvm_invalidate_memslot(kvm, old, invalid_slot);
-		kvm_replace_memslot(kvm, old, invalid_slot);
 	}
 
 	r = kvm_prepare_memory_region(kvm, batch);
@@ -1896,6 +1908,13 @@ static int kvm_set_memslot(struct kvm *kvm,
 {
 	int r, as_id;
 
+	/*
+	 * First, prepare memslot. If DELETE and MOVE, take care of creating
+	 * the invalid slot and use it to replace the old one.
+	 * In order to keep things simple, allow each single update
+	 * to be immediately visibile by swapping the active and inactive
+	 * memory slot arrays.
+	 */
 	r = kvm_prepare_memslot(kvm, batch);
 	if (r)
 		return r;
@@ -1910,6 +1929,12 @@ static int kvm_set_memslot(struct kvm *kvm,
 	else
 		kvm_replace_memslot(kvm, batch->old, batch->new);
 
+	/* Caller has to manually commit changes afterwards */
+	if (batch->batch) {
+		mutex_unlock(&kvm->slots_arch_lock);
+		return r;
+	}
+
 	/* either old or invalid is the same, since invalid is old's copy */
 	as_id = kvm_memslots_get_as_id(batch->old, batch->new);
 
@@ -2083,9 +2108,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
 {
 	int r;
 
-	r = kvm_check_memory_region(kvm, mem, batch);
-	if (r)
-		return r;
+	if (!batch->old && !batch->new && !batch->invalid) {
+		r = kvm_check_memory_region(kvm, mem, batch);
+		if (r)
+			return r;
+	}
 
 	return kvm_set_memslot(kvm, batch);
 }
@@ -2117,6 +2144,133 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	return kvm_set_memory_region(kvm, mem, &batch);
 }
 
+static int kvm_vm_ioctl_set_memory_region_list(struct kvm *kvm,
+		       struct kvm_userspace_memory_region_list *list,
+		       struct kvm_userspace_memory_region_entry __user *mem_arg)
+{
+	struct kvm_userspace_memory_region_entry *mem, *m_iter;
+	struct kvm_userspace_memory_region *mem_region;
+	struct kvm_internal_memory_region_list *batch, *b_iter;
+	int i, r = 0;
+	bool *as_to_swap;
+
+	/* TODO: limit the number of mem to a max? */
+
+	if (!list->nent)
+		return r;
+
+	mem = vmemdup_user(mem_arg, array_size(sizeof(*mem), list->nent));
+	if (IS_ERR(mem)) {
+		r = PTR_ERR(mem);
+		goto out;
+	}
+
+	batch = kcalloc(list->nent, sizeof(*batch), GFP_KERNEL_ACCOUNT);
+	if (IS_ERR(batch)) {
+		r = PTR_ERR(batch);
+		goto out2;
+	}
+
+	as_to_swap = kcalloc(KVM_ADDRESS_SPACE_NUM, sizeof(bool),
+			     GFP_KERNEL_ACCOUNT);
+	if (IS_ERR(as_to_swap)) {
+		r = PTR_ERR(as_to_swap);
+		goto out3;
+	}
+
+	m_iter = mem;
+	b_iter = batch;
+	/*
+	 * First pass: handle all DELETE and MOVE requests
+	 * (since they swap active and inactive memslots)
+	 * by switching old memslot in invalid.
+	 */
+	mutex_lock(&kvm->slots_lock);
+	for (i = 0; i < list->nent; i++) {
+
+		if ((u16)m_iter->slot >= KVM_USER_MEM_SLOTS) {
+			r = -EINVAL;
+			goto out4;
+		}
+
+		if (!m_iter->invalidate_slot) {
+			m_iter++;
+			b_iter++;
+			continue;
+		}
+
+		mem_region = (struct kvm_userspace_memory_region *) m_iter;
+		r = kvm_check_memory_region(kvm, mem_region, b_iter);
+		if (r) {
+			mutex_unlock(&kvm->slots_lock);
+			goto out4;
+		}
+
+		WARN_ON(b_iter->change != KVM_MR_DELETE &&
+			b_iter->change != KVM_MR_MOVE);
+
+		b_iter->is_move_delete = true;
+		r = kvm_prepare_memslot(kvm, b_iter);
+		b_iter->is_move_delete = false;
+		if (r < 0) {
+			mutex_unlock(&kvm->slots_lock);
+			goto out4;
+		}
+		m_iter++;
+		b_iter++;
+	}
+	mutex_unlock(&kvm->slots_lock);
+
+
+	m_iter = mem;
+	b_iter = batch;
+	/*
+	 * Second pass: handle all other request types
+	 * but do not swap the memslots array yet.
+	 */
+	for (i = 0; i < list->nent; i++) {
+		b_iter->batch = true;
+		as_to_swap[m_iter->slot >> 16] = true;
+		mem_region = (struct kvm_userspace_memory_region *) m_iter;
+		r = kvm_set_memory_region(kvm, mem_region, b_iter);
+		if (r < 0)
+			goto out4;
+		m_iter++;
+		b_iter++;
+	}
+
+	/*
+	 * Conclude by swapping the memslot lists and updating the inactive set too.
+	 */
+	b_iter = batch;
+	mutex_lock(&kvm->slots_lock);
+	mutex_lock(&kvm->slots_arch_lock);
+	for (i = 0; i < list->nent; i++) {
+		int as_id;
+
+		as_id = kvm_memslots_get_as_id(b_iter->old, b_iter->new);
+		if (as_to_swap[as_id]) {
+			kvm_swap_active_memslots(kvm, as_id);
+			mutex_lock(&kvm->slots_arch_lock);
+			as_to_swap[as_id] = false;
+		}
+
+		kvm_finish_memslot(kvm, b_iter);
+		b_iter++;
+	}
+	mutex_unlock(&kvm->slots_arch_lock);
+	mutex_unlock(&kvm->slots_lock);
+
+out4:
+	kfree(as_to_swap);
+out3:
+	kfree(batch);
+out2:
+	kvfree(mem);
+out:
+	return r;
+}
+
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 /**
  * kvm_get_dirty_log - get a snapshot of dirty pages
@@ -4732,6 +4886,17 @@ static long kvm_vm_ioctl(struct file *filp,
 		r = kvm_vm_ioctl_set_memory_region(kvm, &kvm_userspace_mem);
 		break;
 	}
+	case KVM_SET_USER_MEMORY_REGION_LIST: {
+		struct kvm_userspace_memory_region_list __user *mem_arg = argp;
+		struct kvm_userspace_memory_region_list mem;
+
+		r = -EFAULT;
+		if (copy_from_user(&mem, mem_arg, sizeof(mem)))
+			goto out;
+
+		r = kvm_vm_ioctl_set_memory_region_list(kvm, &mem, mem_arg->entries);
+		break;
+	}
 	case KVM_GET_DIRTY_LOG: {
 		struct kvm_dirty_log log;
 
-- 
2.31.1

