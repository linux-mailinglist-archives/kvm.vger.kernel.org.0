Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD336CEA3
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 00:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239195AbhD0Whi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 18:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239118AbhD0Whg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 18:37:36 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BAFC061574
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:51 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id lk6-20020a17090b33c6b029015542757d77so7438078pjb.3
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IwwNOUpk3ODt0Lpl9liH9pYZxU/VRIgyeYGkiNpqM5w=;
        b=quk1wa4rWp3dK12YcQjVsfLL4dyW+yOEEHY2AkcN8Th/bxv3sbWM1lvSvRwKnfLOxa
         /moY5aE6K+FxsgqjgVKMNKpnjPr21k/yCKTrP7CDPSKW9orDE2OCEU6qQn6uMhVmWbCo
         CNq75iQGnqGEbsRa9VW9xKjU3b+t2mUmNoGwuGwJLdk4Tkq2QxoFF5w0Vb98nHBB+EqI
         NUKEgqems7QkfFNFE5BVWibioB0nQ96IYP9IZPcXgTFrjuWVdvGHCvxh5owl3y9A9/+4
         9IwuW0asFBNSrTA5RIsLFienCUhU0z3PR9HkYWyI6GLHFYc9AwJidTs/z/pb/e34vVVU
         wJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IwwNOUpk3ODt0Lpl9liH9pYZxU/VRIgyeYGkiNpqM5w=;
        b=T+tY5rztK2xb+/gJ/mB29pX4cKRYPKfOSvhkXaXlGPZpViz7xinAICM9ikZiVGqXKY
         CiqV9ZBRiW8xzcdl/G79n3Ven4UER9MEVbs2bZWjRKBED82SHQY3lCVELrwWE8WuOQRo
         e31mBbiA7pfxD2jc0189kytVsY+3lP2HJQH6bCC1IRMW/e5CfljDt2Lrk+R3tYAwHMK4
         aNLQIQ6d4Cmc0SofiQwh+lRzRcpMDyAS7O4ty3FOkPEKOtAIXOV3lp65Fk54Q751Mr3f
         JzkGFKz+xRRWW9DRWlGaNOir0iayoTIKIVowOwTjopQ+q4FmQWBMtjuO2ij4JOPBjk55
         l5pA==
X-Gm-Message-State: AOAM533HnnnsI5noVyo5p1W3RwssqFpDfBsSvJCRTRS2Jh+7ZK+Pu8oj
        60u6+8KGSzmHagoVS5WiCntPReIEy50P
X-Google-Smtp-Source: ABdhPJyMHAuPSNTcfcChXZ0AEdBIMZGH8gDHz8umzXTm5wXnsKIryUAQ15jVdQlGkvBM9jddFf3/ZyLKcP+X
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:d0b5:c590:c6b:bd9c])
 (user=bgardon job=sendgmr) by 2002:aa7:9571:0:b029:259:1f95:27db with SMTP id
 x17-20020aa795710000b02902591f9527dbmr25833597pfq.54.1619563011250; Tue, 27
 Apr 2021 15:36:51 -0700 (PDT)
Date:   Tue, 27 Apr 2021 15:36:34 -0700
In-Reply-To: <20210427223635.2711774-1-bgardon@google.com>
Message-Id: <20210427223635.2711774-6-bgardon@google.com>
Mime-Version: 1.0
References: <20210427223635.2711774-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 5/6] KVM: x86/mmu: Protect kvm->memslots with a mutex
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

Adds a lock around memslots changes. Currently this lock does not have
any effect on the syncronization model, but it will be used in a future
commit to facilitate lazy rmap allocation.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/x86.c              | 11 +++++++++++
 include/linux/kvm_host.h        |  2 ++
 virt/kvm/kvm_main.c             |  9 ++++++++-
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3900dcf2439e..bce7fa152473 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1124,6 +1124,11 @@ struct kvm_arch {
 #endif /* CONFIG_X86_64 */
 
 	bool shadow_mmu_active;
+
+	/*
+	 * Protects kvm->memslots.
+	 */
+	struct mutex memslot_assignment_lock;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fc32a7dbe4c4..30234fe96f48 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10649,6 +10649,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	raw_spin_lock_init(&kvm->arch.tsc_write_lock);
 	mutex_init(&kvm->arch.apic_map_lock);
 	spin_lock_init(&kvm->arch.pvclock_gtod_sync_lock);
+	mutex_init(&kvm->arch.memslot_assignment_lock);
 
 	kvm->arch.kvmclock_offset = -get_kvmclock_base_ns();
 	pvclock_update_vm_gtod_copy(kvm);
@@ -10868,6 +10869,16 @@ static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
 	return -ENOMEM;
 }
 
+
+void kvm_arch_assign_memslots(struct kvm *kvm, int as_id,
+			     struct kvm_memslots *slots)
+{
+	mutex_lock(&kvm->arch.memslot_assignment_lock);
+	rcu_assign_pointer(kvm->memslots[as_id], slots);
+	mutex_unlock(&kvm->arch.memslot_assignment_lock);
+}
+
+
 static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 				      unsigned long npages)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8895b95b6a22..146bb839c754 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -720,6 +720,8 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				struct kvm_memory_slot *memslot,
 				const struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change);
+void kvm_arch_assign_memslots(struct kvm *kvm, int as_id,
+			     struct kvm_memslots *slots);
 void kvm_arch_commit_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				struct kvm_memory_slot *old,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2799c6660cce..e62a37bc5b90 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1270,6 +1270,12 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	return 0;
 }
 
+__weak void kvm_arch_assign_memslots(struct kvm *kvm, int as_id,
+				    struct kvm_memslots *slots)
+{
+	rcu_assign_pointer(kvm->memslots[as_id], slots);
+}
+
 static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 		int as_id, struct kvm_memslots *slots)
 {
@@ -1279,7 +1285,8 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
 	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
 
-	rcu_assign_pointer(kvm->memslots[as_id], slots);
+	kvm_arch_assign_memslots(kvm, as_id, slots);
+
 	synchronize_srcu_expedited(&kvm->srcu);
 
 	/*
-- 
2.31.1.498.g6c1eba8ee3d-goog

