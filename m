Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC8D37ACE5
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhEKRRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbhEKRRh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:17:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5BCC06138D
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:26 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id u13-20020a17090a3fcdb0290155c6507e67so1955189pjm.6
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IdCnT3mwXKxIR7ttAX9zjPlOQ4dQIFQz+o3rZcTM8aM=;
        b=msBLlEe3ot3nuWD55J4v5ThYMPxXlTGy02yfyoeqs9WfCCuy/bSxG8SzV6/TB0bRuJ
         XytlUCjPKKAXs4z+OBU16G4+rcjtfCJfrBNRczzoKBvgG5EKErlP+ZWFOzdgBhToLu7H
         DeLjftQV4oaa3uWU4TV05YbB9GV0QgEg3hmebAxrF1pHKCKqTu4nJugrK01WUKprew4t
         ApSo71s0c0MwwMTwcuvFuSH3ymgcXaSsQNCvcGKdgvFWkoRl8XHCDjO2ge3A8zxRGyyz
         6DtCebMt/2dMp6nQQu0KA34ZpIf1QC0KaNPOu1xNX28OS1DYKBZDBKhPsYqKYDT4y0Ti
         NzCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IdCnT3mwXKxIR7ttAX9zjPlOQ4dQIFQz+o3rZcTM8aM=;
        b=HDH/acO/Uvbbl7d5suH6JPvcjRC+62qMcxeCvK6h4d60D2CfcAEdNKrnzMFgfnPMgL
         86WEyVJlgzarcCHvvDUiJ9iuS3dcM2fRnekfb4cDyTLXR/wHUcBZMrO0Jplkhn05guFz
         stLNPB+Q3gRIMMGxlDzO8wf5geScMsoUGP+k6u8p+jdOSA5s5pMGqASHzvRWRbvzWIHf
         ModMFXS+QCcON17IbuWooVlFZhdJRRZUw0rKYpe3T9Ni/M/8vY9skzFWPyAn9hin47Ga
         qHDw5WeXcQl/VPf+A+lj1qjayNplkRx8XzgG3XWCzxwBHniT3lpK4qcfxKtaA5f66MdE
         XyMw==
X-Gm-Message-State: AOAM530xMut/SNQ3sGDXzJTn2kuVx0UUxSOjC8nva5jMrgC5h6D6CzP5
        DHZfBNS2dsNSnjcl3YjX7V5Rnq4Bd7Xi
X-Google-Smtp-Source: ABdhPJzHcbiko1rAzB6jsrTQRRvDl0nOmsvzH4iOdOFRUENcfoDQr0r0ygIjy2HCG43+8/ShVxfNxnfZ74Qv
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e050:3342:9ea6:6859])
 (user=bgardon job=sendgmr) by 2002:a62:60c2:0:b029:2cb:70a7:a8ce with SMTP id
 u185-20020a6260c20000b02902cb70a7a8cemr2673602pfb.77.1620753385750; Tue, 11
 May 2021 10:16:25 -0700 (PDT)
Date:   Tue, 11 May 2021 10:16:07 -0700
In-Reply-To: <20210511171610.170160-1-bgardon@google.com>
Message-Id: <20210511171610.170160-5-bgardon@google.com>
Mime-Version: 1.0
References: <20210511171610.170160-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v4 4/7] KVM: mmu: Add slots_arch_lock for memslot arch fields
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
index 9e106742b388..5c40d83754b1 100644
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

