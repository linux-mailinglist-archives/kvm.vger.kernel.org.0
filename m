Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABBA36F1E3
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 23:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbhD2VT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 17:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237510AbhD2VTv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 17:19:51 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912ADC06138E
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 14:19:04 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v7-20020a05620a0a87b02902e02f31812fso28847415qkg.6
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 14:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IXgrcu6fpr/f6DU3zcjv8Lr+SP1VIhyvQbBITAXnt70=;
        b=uFdeOtrnJ/E5UdVBYv6JOGZ37SBAXdfJGQVxQMpubPDNCJ8+IzNmupd/lPzTTkOXi8
         WfSjXnIwkdi941dxgyJ+Bx4AYe2zw0hbz/JkxajApbjOajeMVhqQVFx6pkort1WPafaT
         ichw0tOOVFdiLfh2EcLejztdrgeg5Xv3klQUCF12znnq1LhDPsmhdfq0nRsuKP0B1jj0
         AmCyjde7POqS41yFvfcWL+Mu53UW+OBN+hiJA2P/dk6/1UeeJiyzWQHbUEoNfHkP8X6u
         LbWKs18J4vJ/D9K77ysXQXRdRJ2KXJxgeTDT3VIHiaJEFwjPnWmBLQnSv9MH3on/GfVu
         4DDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IXgrcu6fpr/f6DU3zcjv8Lr+SP1VIhyvQbBITAXnt70=;
        b=Ocyu2CKho8JulK351Aoy14nIWSw0I63SwzUrdls35lmzSj1rpwjui0ULwGl4d/c/3M
         mL8a/Vq2CDgSr/1uqOaTHLNj/4Zdl4OJ9xKJPUx8RAskBOJ9k1XmnpLGWBVM/mSWgncr
         VTLyF48M+UizjGSDmSQL3CJWiEHm1ID8Ybs1un+Zjn1KrGvisg7sWShHbZjwEIHkJVx+
         wkVMX6HErRbuW9jfQMCvPJ8i0AzfAxrRoWdDqLl4hrc0sIuToyzYReeGhthg5D+bDfvq
         beqDGukAQvJIHjhw30KeuxkK5VqLKwh0VP7qlsEhZxRxOmSn5CnEzHw29VFoQuEFVbWS
         mZqw==
X-Gm-Message-State: AOAM533i+YaXhu7up+l3PPWdv60MVi1KFDonCfW4rsgAUNuRGM5hnw4l
        D2p2ho9wMpO7jGXUqnikd/Tiw1N/QiI4
X-Google-Smtp-Source: ABdhPJzPevB4xMaP83Cr8Q4/TkfQvL42SaHJ+4twJtZWyFXdRCpCp9cyChJTiEG3idsHA98deC5QRpI2qbuR
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:1a18:9719:a02:56fb])
 (user=bgardon job=sendgmr) by 2002:a05:6214:1bca:: with SMTP id
 m10mr1868439qvc.56.1619731143719; Thu, 29 Apr 2021 14:19:03 -0700 (PDT)
Date:   Thu, 29 Apr 2021 14:18:32 -0700
In-Reply-To: <20210429211833.3361994-1-bgardon@google.com>
Message-Id: <20210429211833.3361994-7-bgardon@google.com>
Mime-Version: 1.0
References: <20210429211833.3361994-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 6/7] KVM: mmu: Add slots_arch_lock for memslot arch fields
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
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
2.31.1.527.g47e6f16901-goog

