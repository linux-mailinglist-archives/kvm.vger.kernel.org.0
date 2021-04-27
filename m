Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9776836CE9C
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 00:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbhD0Wh2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 18:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237070AbhD0Wh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 18:37:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737B6C061760
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:41 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c1-20020a5b0bc10000b02904e7c6399b20so39456037ybr.12
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 15:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hHwlLUDiyb5KZWQJivPUqbRlaxgxwy3BBJV8Ity3Kbo=;
        b=otlddGc/Vgp5GvUSMNcJTh8thjsLeNZa2+H0rpxyB2THPXRytUVAU/kVjwWQcB31l/
         +cHc9GCRnMX9FQdZMldUXENz/gkNNeJFSYobkrbLLAt8LA7C/VFJ/EmXPXrMSryfOZsw
         BB8SpdcCBMO2jSPQoDzsReBH2cZjGgx5Hc0PqfyBSQ/gW16xMTQkqx2U4ZkVJ80viWXh
         1qSweEBrnpVOCheuABaVrMshGTfAkupn9JVVTN234ddDv2ekSNWLNJ1NhRShqonPy5ea
         g9PW9noDnMdvxKNt3ZQRHkHuoVshsa5ITP5sD121l5t7Qw+vrxjPjPmjOacBrZ7IjZdj
         /uCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hHwlLUDiyb5KZWQJivPUqbRlaxgxwy3BBJV8Ity3Kbo=;
        b=BZO0dcrvWvRhyC5yEhct98zXEeB2mh/G9rf5mSgwfiYazjNKFjk7+1cXV9vRfdCauj
         UPUTSjj1cRRrLHMc9C8VgLwr7zR/dk83crYFfSvMJ3+qFOu2J4l9fK9UqYOnJwsY9Svu
         9z9nLDlErnNKRZ3Itbwk6+KGGzQAZKMTuTv/fK7BOpmMRCG5mr0ALXWTXpU1CHrJjukk
         0RzwSm28uVgP8Vrit3dLH0QMoIGZ7oarDrZcUMnZXHureLJEkNpXiZTbGLVXts1UTKRK
         CWYkrc1gf0fQ/IesoUJkOhUCeJp8LNBnHpkrG/UepCEwIiWyVVlXkOxBvdLgaNzXuwJE
         JFNw==
X-Gm-Message-State: AOAM533iortId5kbsm+0CL1Ez/Bb6bgandPvF+oxvfywgKmODSOfK9Cz
        mQ2Zxic1koVjSF/piBLcZZLLE6ZvmYEJ
X-Google-Smtp-Source: ABdhPJxz5xOYP7MEBqOp+wqGfgfhga68bYGbJL5xGkLN3JunTQIxF+Yh/jbsJ4izS0k4xTwMTQdvpUF+tnPr
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:d0b5:c590:c6b:bd9c])
 (user=bgardon job=sendgmr) by 2002:a25:3bd7:: with SMTP id
 i206mr5225144yba.150.1619563000673; Tue, 27 Apr 2021 15:36:40 -0700 (PDT)
Date:   Tue, 27 Apr 2021 15:36:30 -0700
In-Reply-To: <20210427223635.2711774-1-bgardon@google.com>
Message-Id: <20210427223635.2711774-2-bgardon@google.com>
Mime-Version: 1.0
References: <20210427223635.2711774-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 1/6] KVM: x86/mmu: Track if shadow MMU active
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

Add a field to each VM to track if the shadow / legacy MMU is actually
in use. If the shadow MMU is not in use, then that knowledge opens the
door to other optimizations which will be added in future patches.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu/mmu.c          | 10 +++++++++-
 arch/x86/kvm/mmu/mmu_internal.h |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.h      |  4 ++--
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad22d4839bcc..3900dcf2439e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1122,6 +1122,8 @@ struct kvm_arch {
 	 */
 	spinlock_t tdp_mmu_pages_lock;
 #endif /* CONFIG_X86_64 */
+
+	bool shadow_mmu_active;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 930ac8a7e7c9..3975272321d0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3110,6 +3110,11 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return ret;
 }
 
+void activate_shadow_mmu(struct kvm *kvm)
+{
+	kvm->arch.shadow_mmu_active = true;
+}
+
 static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 			       struct list_head *invalid_list)
 {
@@ -3280,6 +3285,8 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	activate_shadow_mmu(vcpu->kvm);
+
 	write_lock(&vcpu->kvm->mmu_lock);
 	r = make_mmu_pages_available(vcpu);
 	if (r < 0)
@@ -5467,7 +5474,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 
-	kvm_mmu_init_tdp_mmu(kvm);
+	if (!kvm_mmu_init_tdp_mmu(kvm))
+		activate_shadow_mmu(kvm);
 
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index f2546d6d390c..297a911c018c 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -165,4 +165,6 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+void activate_shadow_mmu(struct kvm *kvm);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 83cbdbe5de5a..5342aca2c8e0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -14,10 +14,10 @@ static bool __read_mostly tdp_mmu_enabled = false;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
 
 /* Initializes the TDP MMU for the VM, if enabled. */
-void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
+bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
-		return;
+		return false;
 
 	/* This should not be changed for the lifetime of the VM. */
 	kvm->arch.tdp_mmu_enabled = true;
@@ -25,6 +25,8 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
+
+	return true;
 }
 
 static __always_inline void kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5fdf63090451..b046ab5137a1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -80,12 +80,12 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level);
 
 #ifdef CONFIG_X86_64
-void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
+bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
 #else
-static inline void kvm_mmu_init_tdp_mmu(struct kvm *kvm) {}
+static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
 static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
 static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
-- 
2.31.1.498.g6c1eba8ee3d-goog

