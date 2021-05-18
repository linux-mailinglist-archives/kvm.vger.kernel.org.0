Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB919387E7A
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 19:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351200AbhERRfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 13:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351175AbhERRfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 13:35:44 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7016DC061573
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 10:34:26 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id k12-20020a17090aaa0cb029015cf15dc26dso2182163pjq.8
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 10:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DNWDgFb1bZKAmr+FZ80H3e+f0Tx9YEcykENAEtVifrk=;
        b=uuhKJDuDF92PuqAkq4HG6tMh1+5JzmnjHdiz1IkBzi4FetdwRb8MpG9ZFKJdxUNSkg
         8gKLGBxhz2yWPq0us2cNl41YG0E6COApfXAoFj9TY/0MlMzJZTBnU55wM4rRJY4vR542
         80T3VE01qLHnw244NDbDIWZSMdTm6bQzBW2xpbJbRYB3pAlH+e2yhCz9IPBccM3b+ksF
         /gcO/lG480j3SNjdAqRmt+bPwr5weFwNz6Y5bn8vehxoMOnivxZ2dS+KSLuRiGjz4AT/
         /3pP6YEDrAqOlXoxNldaeEitujqwxwJTWRRXr/LTOY6q05Jep8Iozwi/bGJ6/iKyxFyo
         5qkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DNWDgFb1bZKAmr+FZ80H3e+f0Tx9YEcykENAEtVifrk=;
        b=ffmEZ6hdmtxawfmYsUTdh7qqcw5qNsuy4l5J7cX8dWgfyTkC0wDfJI0SljZJLCei/l
         Lhsl+kMNxUMSbFW25+LmMEeKLHDF+jlHz/iARCNfljc0r8E8NI29O6P7Tq0B/15V5lPI
         1axbba/c7MvQnEwDtRbw1YgN++qY0a4KQoGEMc9mmTZeQqalyVZIBMzdj2Xw3yO+vlcw
         k9MtMe7TDmojfAR9mENrk4r/YpLHpOGtfOZ1rhbidLfApOuYmQsah6r8Z8FQ7NT6V3hQ
         l6L4nQ01dPo+FlADSN9kxRYdNWqESPo4KM0vRGVh7B+KLhYnNAkSKNxnQDtrOfIKguYs
         2N3g==
X-Gm-Message-State: AOAM5320TA+i7AqlFI42EfW3bkNLSpwM24kN6ybm6bneBF0sWNIWih9A
        y7+aW+5pIpkqzaV+9rVtZs77bpCKMLXt
X-Google-Smtp-Source: ABdhPJwKV60c5LhTSvqCGb2D5j9zKfK6rFfpFAEkXQqenCAVbLENaCnNJ+BZ4O1sVIJ9YzUhjkG1l97tfLpx
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2715:2de:868e:9db7])
 (user=bgardon job=sendgmr) by 2002:a17:90a:7f83:: with SMTP id
 m3mr609514pjl.0.1621359265527; Tue, 18 May 2021 10:34:25 -0700 (PDT)
Date:   Tue, 18 May 2021 10:34:11 -0700
In-Reply-To: <20210518173414.450044-1-bgardon@google.com>
Message-Id: <20210518173414.450044-5-bgardon@google.com>
Mime-Version: 1.0
References: <20210518173414.450044-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v5 4/7] KVM: mmu: Add slots_arch_lock for memslot arch fields
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a new lock to protect the arch-specific fields of memslots if they
need to be modified in a kvm->srcu read critical section. A future
commit will use this lock to lazily allocate memslot rmaps for x86.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 include/linux/kvm_host.h |  9 +++++++
 virt/kvm/kvm_main.c      | 54 +++++++++++++++++++++++++++++++++++-----
 2 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2f34487e21f2..817aa5e8dbd5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -517,6 +517,15 @@ struct kvm {
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
 	struct mutex slots_lock;
+
+	/*
+	 * Protects the arch-specific fields of struct kvm_memory_slots in
+	 * use by the VM. To be used under the slots_lock (above) or in a
+	 * kvm->srcu critical section where acquiring the slots_lock would
+	 * lead to deadlock with the synchronize_srcu in
+	 * install_new_memslots.
+	 */
+	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4acd4722d729..41dfebde4680 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -908,6 +908,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
+	mutex_init(&kvm->slots_arch_lock);
 	INIT_LIST_HEAD(&kvm->devices);
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
@@ -1280,6 +1281,14 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
 
 	rcu_assign_pointer(kvm->memslots[as_id], slots);
+
+	/*
+	 * Acquired in kvm_set_memslot. Must be released before synchronize
+	 * SRCU below in order to avoid deadlock with another thread
+	 * acquiring the slots_arch_lock in an srcu critical section.
+	 */
+	mutex_unlock(&kvm->slots_arch_lock);
+
 	synchronize_srcu_expedited(&kvm->srcu);
 
 	/*
@@ -1351,9 +1360,27 @@ static int kvm_set_memslot(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	int r;
 
+	/*
+	 * Released in install_new_memslots.
+	 *
+	 * Must be held from before the current memslots are copied until
+	 * after the new memslots are installed with rcu_assign_pointer,
+	 * then released before the synchronize srcu in install_new_memslots.
+	 *
+	 * When modifying memslots outside of the slots_lock, must be held
+	 * before reading the pointer to the current memslots until after all
+	 * changes to those memslots are complete.
+	 *
+	 * These rules ensure that installing new memslots does not lose
+	 * changes made to the previous memslots.
+	 */
+	mutex_lock(&kvm->slots_arch_lock);
+
 	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
-	if (!slots)
+	if (!slots) {
+		mutex_unlock(&kvm->slots_arch_lock);
 		return -ENOMEM;
+	}
 
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
 		/*
@@ -1364,10 +1391,9 @@ static int kvm_set_memslot(struct kvm *kvm,
 		slot->flags |= KVM_MEMSLOT_INVALID;
 
 		/*
-		 * We can re-use the old memslots, the only difference from the
-		 * newly installed memslots is the invalid flag, which will get
-		 * dropped by update_memslots anyway.  We'll also revert to the
-		 * old memslots if preparing the new memory region fails.
+		 * We can re-use the memory from the old memslots.
+		 * It will be overwritten with a copy of the new memslots
+		 * after reacquiring the slots_arch_lock below.
 		 */
 		slots = install_new_memslots(kvm, as_id, slots);
 
@@ -1379,6 +1405,17 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 *	- kvm_is_visible_gfn (mmu_check_root)
 		 */
 		kvm_arch_flush_shadow_memslot(kvm, slot);
+
+		/* Released in install_new_memslots. */
+		mutex_lock(&kvm->slots_arch_lock);
+
+		/*
+		 * The arch-specific fields of the memslots could have changed
+		 * between releasing the slots_arch_lock in
+		 * install_new_memslots and here, so get a fresh copy of the
+		 * slots.
+		 */
+		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
@@ -1394,8 +1431,13 @@ static int kvm_set_memslot(struct kvm *kvm,
 	return 0;
 
 out_slots:
-	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+		slot = id_to_memslot(slots, old->id);
+		slot->flags &= ~KVM_MEMSLOT_INVALID;
 		slots = install_new_memslots(kvm, as_id, slots);
+	} else {
+		mutex_unlock(&kvm->slots_arch_lock);
+	}
 	kvfree(slots);
 	return r;
 }
-- 
2.31.1.751.gd2f1c929bd-goog

