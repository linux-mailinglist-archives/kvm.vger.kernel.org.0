Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E755375A51
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbhEFSoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbhEFSoD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 14:44:03 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AC4BC061763
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 11:43:04 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id b3-20020a05620a0cc3b02902e9d5ca06f2so4132023qkj.19
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 11:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U7Vi41v0OSiHL19URZ52LjF0y68Q7hNWE3W5ECoMlug=;
        b=YP5S8XEMA4PG47qIBKcMDaF73wfH7QsIb512ozUiq+FU9ouR44k4gXEtaFeJhH7Sd4
         Hw0LS/K3GFWR+hqvpiFq+yEz/+D2QoJHXwotlj2Pmn5sfS0KoG6HjYLnZZCZ/pBUQK12
         hLwDKi3teSV8EBblAJd6IIRU35HQPqDf513gZOsgOnhK9ekkChl6OCLIrtXo13GyBhK6
         1HU/lmJw7rxN27n1ru8Fi69bQFJSEzRcFZemTPi2x+eZQYa2ly0jXM8Zl7x7bGAp2JBP
         IY2ZQ75fW34DsH2M24DSaA2zTdtfLmKBPysLlVQjfhOnwWFamujYNyhPCYTd+m36M081
         ZGsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U7Vi41v0OSiHL19URZ52LjF0y68Q7hNWE3W5ECoMlug=;
        b=UtzxDM3dnTro9NHHV8SdDZHUqtUViJb1jhk2E7+i5ABR029yC7fFQyC6wBF+Ym38QL
         +8z5tfPEMbJFoolFSIXgcNynSw6+6owckhakPIwWxiu0nc3DBvTxgJ7Z81QCdd0nhYla
         vzUzbrnKQWVL1zodNMi01+z1xXwEx1iU7fCHTt4KcupW9K1OZ8Kj033MmYm4nemK+ChC
         n9aVoYK+WdrhL5e7QqfzoH6ba0CA3VlFIPAjy8NJZQTkjyaXF5S2f6gON2+8I3ZNPXYj
         YAJ/wRnrNZ4SYYTkvyAbbljsZdVIqmndFMlEQqgHYQorBr7sTkZs8iVJE4gwidB/mDQL
         sLhA==
X-Gm-Message-State: AOAM533O6nZqbzjn0GiBCxqGdLYBiiSlL5QtjLVe8s1rZ5wrzv/zcAZK
        FlfOwEiy1UYgU74Pma8bTu3HWLO/vqfa
X-Google-Smtp-Source: ABdhPJyl8LUp6giVGjSFn82PuuUj26gvcp/GqmNC7tVwg4f7NfZTlAvBRgAgIX7Lqlka88QDS0ttQ7DgGvoj
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9258:9474:54ca:4500])
 (user=bgardon job=sendgmr) by 2002:a05:6214:408:: with SMTP id
 z8mr6158950qvx.54.1620326583566; Thu, 06 May 2021 11:43:03 -0700 (PDT)
Date:   Thu,  6 May 2021 11:42:37 -0700
In-Reply-To: <20210506184241.618958-1-bgardon@google.com>
Message-Id: <20210506184241.618958-5-bgardon@google.com>
Mime-Version: 1.0
References: <20210506184241.618958-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 4/8] KVM: mmu: Add slots_arch_lock for memslot arch fields
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
 include/linux/kvm_host.h |  9 +++++++++
 virt/kvm/kvm_main.c      | 31 ++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8895b95b6a22..2d5e797fbb08 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -472,6 +472,15 @@ struct kvm {
 #endif /* KVM_HAVE_MMU_RWLOCK */
 
 	struct mutex slots_lock;
+
+	/*
+	 * Protects the arch-specific fields of struct kvm_memory_slots in
+	 * use by the VM. To be used under the slots_lock (above) or in a
+	 * kvm->srcu read cirtical section where acquiring the slots_lock
+	 * would lead to deadlock with the synchronize_srcu in
+	 * install_new_memslots.
+	 */
+	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c8010f55e368..97b03fa2d0c8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -908,6 +908,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->lock);
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
+	mutex_init(&kvm->slots_arch_lock);
 	INIT_LIST_HEAD(&kvm->devices);
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
@@ -1280,6 +1281,10 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
 
 	rcu_assign_pointer(kvm->memslots[as_id], slots);
+
+	/* Acquired in kvm_set_memslot. */
+	mutex_unlock(&kvm->slots_arch_lock);
+
 	synchronize_srcu_expedited(&kvm->srcu);
 
 	/*
@@ -1351,6 +1356,9 @@ static int kvm_set_memslot(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	int r;
 
+	/* Released in install_new_memslots. */
+	mutex_lock(&kvm->slots_arch_lock);
+
 	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
 	if (!slots)
 		return -ENOMEM;
@@ -1364,10 +1372,9 @@ static int kvm_set_memslot(struct kvm *kvm,
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
 
@@ -1379,6 +1386,17 @@ static int kvm_set_memslot(struct kvm *kvm,
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
+		kvm_copy_memslots(__kvm_memslots(kvm, as_id), slots);
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
@@ -1394,8 +1412,11 @@ static int kvm_set_memslot(struct kvm *kvm,
 	return 0;
 
 out_slots:
-	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+		slot = id_to_memslot(slots, old->id);
+		slot->flags &= ~KVM_MEMSLOT_INVALID;
 		slots = install_new_memslots(kvm, as_id, slots);
+	}
 	kvfree(slots);
 	return r;
 }
-- 
2.31.1.607.g51e8a6a459-goog

