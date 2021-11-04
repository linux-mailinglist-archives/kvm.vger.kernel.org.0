Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82384444C1B
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 01:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhKDA3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 20:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbhKDA2i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 20:28:38 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B84C06127A
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 17:26:01 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id g20-20020a170902869400b0014002b0f5bcso1912228plo.18
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 17:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+lV0XpIZU6tw19BsegMK11Am0XrNm95tEDZ+cjWdUrM=;
        b=jbtShP55MKCx20McDFEhvtwsoRH1khB6gzD/3j56rgiZ3zt1jHh02awL7RkCEzV3OS
         juVR4kJgynHQLk53v8qOxVTOjp/cr1Axpeb38StAvaM6K/Esi65OU9b5Xxj4BlHERFw/
         20Ros746PIesTfL4lqUBcYH1DmBdILCibzAzE0JyxJqshteAL/za33QXIkiltJhs6fgG
         bVtI7QJVCXpF8HJS0rKZ95KbFtPX72tTwq3ga0tOCYx8FS5o3uLhWSoZiizq/DCYGBRC
         nP9YYyqmezSHN3kgANHiJKtWGLbMgy/F9P8mC6PT1O/nqJH2RcSpIBmpTyxPG6DF1Hbi
         bVTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+lV0XpIZU6tw19BsegMK11Am0XrNm95tEDZ+cjWdUrM=;
        b=J5NxWyq79EVGmpvEuKLAtj+GIIEJxFZMXMN0vtknK0DYd+ZiNndE43iwsEOYdCbdAl
         YHpUEWox4rFnRr2Xbr5GEI4vqC1LskcbEMWtYl5t1Oj1kYepwrcnHauaNTqS+EqLVWAY
         9Dd+Pkim4kGJHEyhE5+yRjTlJrWR8/zmXECHF3Dd+ut3sR3dgpEw89xDiLwpicC71SAl
         Qn7QMwcTD8IfjWjwM6BOzjEsnyh/i+tGvWdYx3s7a8SPKBo6vLVmaLgTVBfXj9zL7T7q
         Ktj7qAe2vySofEvk2qllehlvTQIwOdymCrUBTv3kVusEuCgdXsZJzU2M1khQmj3+7N0e
         2y7w==
X-Gm-Message-State: AOAM532a0MWX8NHEanCOa9kQqBJK8C3wqArC1w7YU2W1SYIrkE4qdBBj
        X7jBQ+HXinUO09HYR6zBuDTL9vHWQ5g=
X-Google-Smtp-Source: ABdhPJxPA9GZBaEM5Ul3kt/1JljrZJu3YLRnIzyzQ/7OAn8VgQo/7agz4e2n8dYIb/fDnOKKBTJDQWAH1V8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:c3:: with SMTP id
 v3mr252263pjd.0.1635985559868; Wed, 03 Nov 2021 17:25:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Nov 2021 00:25:02 +0000
In-Reply-To: <20211104002531.1176691-1-seanjc@google.com>
Message-Id: <20211104002531.1176691-2-seanjc@google.com>
Mime-Version: 1.0
References: <20211104002531.1176691-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v5.5 01/30] KVM: Ensure local memslot copies operate on
 up-to-date arch-specific data
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When modifying memslots, snapshot the "old" memslot and copy it to the
"new" memslot's arch data after (re)acquiring slots_arch_lock.  x86 can
change a memslot's arch data while memslot updates are in-progress so
long as it holds slots_arch_lock, thus snapshotting a memslot without
holding the lock can result in the consumption of stale data.

Fixes: b10a038e84d1 ("KVM: mmu: Add slots_arch_lock for memslot arch fields")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/kvm_main.c | 47 ++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3f6d450355f0..99e69375c4c9 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1531,11 +1531,10 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
 
 static int kvm_set_memslot(struct kvm *kvm,
 			   const struct kvm_userspace_memory_region *mem,
-			   struct kvm_memory_slot *old,
 			   struct kvm_memory_slot *new, int as_id,
 			   enum kvm_mr_change change)
 {
-	struct kvm_memory_slot *slot;
+	struct kvm_memory_slot *slot, old;
 	struct kvm_memslots *slots;
 	int r;
 
@@ -1566,7 +1565,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 * Note, the INVALID flag needs to be in the appropriate entry
 		 * in the freshly allocated memslots, not in @old or @new.
 		 */
-		slot = id_to_memslot(slots, old->id);
+		slot = id_to_memslot(slots, new->id);
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
 		/*
@@ -1597,6 +1596,26 @@ static int kvm_set_memslot(struct kvm *kvm,
 		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
 	}
 
+	/*
+	 * Make a full copy of the old memslot, the pointer will become stale
+	 * when the memslots are re-sorted by update_memslots(), and the old
+	 * memslot needs to be referenced after calling update_memslots(), e.g.
+	 * to free its resources and for arch specific behavior.  This needs to
+	 * happen *after* (re)acquiring slots_arch_lock.
+	 */
+	slot = id_to_memslot(slots, new->id);
+	if (slot) {
+		old = *slot;
+	} else {
+		WARN_ON_ONCE(change != KVM_MR_CREATE);
+		memset(&old, 0, sizeof(old));
+		old.id = new->id;
+		old.as_id = as_id;
+	}
+
+	/* Copy the arch-specific data, again after (re)acquiring slots_arch_lock. */
+	memcpy(&new->arch, &old.arch, sizeof(old.arch));
+
 	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
 	if (r)
 		goto out_slots;
@@ -1604,14 +1623,18 @@ static int kvm_set_memslot(struct kvm *kvm,
 	update_memslots(slots, new, change);
 	slots = install_new_memslots(kvm, as_id, slots);
 
-	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
+	kvm_arch_commit_memory_region(kvm, mem, &old, new, change);
+
+	/* Free the old memslot's metadata.  Note, this is the full copy!!! */
+	if (change == KVM_MR_DELETE)
+		kvm_free_memslot(kvm, &old);
 
 	kvfree(slots);
 	return 0;
 
 out_slots:
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-		slot = id_to_memslot(slots, old->id);
+		slot = id_to_memslot(slots, new->id);
 		slot->flags &= ~KVM_MEMSLOT_INVALID;
 		slots = install_new_memslots(kvm, as_id, slots);
 	} else {
@@ -1626,7 +1649,6 @@ static int kvm_delete_memslot(struct kvm *kvm,
 			      struct kvm_memory_slot *old, int as_id)
 {
 	struct kvm_memory_slot new;
-	int r;
 
 	if (!old->npages)
 		return -EINVAL;
@@ -1639,12 +1661,7 @@ static int kvm_delete_memslot(struct kvm *kvm,
 	 */
 	new.as_id = as_id;
 
-	r = kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
-	if (r)
-		return r;
-
-	kvm_free_memslot(kvm, old);
-	return 0;
+	return kvm_set_memslot(kvm, mem, &new, as_id, KVM_MR_DELETE);
 }
 
 /*
@@ -1718,7 +1735,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (!old.npages) {
 		change = KVM_MR_CREATE;
 		new.dirty_bitmap = NULL;
-		memset(&new.arch, 0, sizeof(new.arch));
 	} else { /* Modify an existing slot. */
 		if ((new.userspace_addr != old.userspace_addr) ||
 		    (new.npages != old.npages) ||
@@ -1732,9 +1748,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		else /* Nothing to change. */
 			return 0;
 
-		/* Copy dirty_bitmap and arch from the current memslot. */
+		/* Copy dirty_bitmap from the current memslot. */
 		new.dirty_bitmap = old.dirty_bitmap;
-		memcpy(&new.arch, &old.arch, sizeof(new.arch));
 	}
 
 	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
@@ -1760,7 +1775,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			bitmap_set(new.dirty_bitmap, 0, new.npages);
 	}
 
-	r = kvm_set_memslot(kvm, mem, &old, &new, as_id, change);
+	r = kvm_set_memslot(kvm, mem, &new, as_id, change);
 	if (r)
 		goto out_bitmap;
 
-- 
2.33.1.1089.g2158813163f-goog

