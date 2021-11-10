Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7097644CCC5
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhKJWdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbhKJWd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:27 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12F7C061767
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:39 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id jx2-20020a17090b46c200b001a62e9db321so1803894pjb.7
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=H/hrjKdAmnuRrFMgl5Un/XSJex+ZkUQ49X9d7368gt8=;
        b=CM75Xt0UbPSnEvDj7QGIpqerK2dVIwF+BTCLhc+zNB5qz635kbUa+ymQal6lN5FSlG
         Y+8b2Qh9X9h6ndsLsRsPWysbEMxJ8p48i2KfYTwkem2iJtvo/N436BbyHq5c2LFGiZaU
         9XdLcZ/JKlMaiWMRei0pYq7xgccdC+VKq3bJoE5/bUd+BxGFAEWXiPhO+Enkz5UrmG3F
         V13V0uEPZyOufRjUs/qDZjYBcX/P/gDlBrCCezUFn1qMmjIW02noaj48croBilvz61wL
         V4T9g7FiKnlyQ/3KiS26/DcRW2YCrgK98PFWWWKgplSustRgYM1Ww2iRCYOBD9yFVMTk
         /AEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=H/hrjKdAmnuRrFMgl5Un/XSJex+ZkUQ49X9d7368gt8=;
        b=QbYm4s9shXPwZ8ZLv4ZIqaoaGM3DftUSAeMhlVs0e/040Tiu021yn2FKbyi0H9jmNp
         KwRYfUVRezywdkGQhjyXtpsLciqcNpOL4tNmHGMyz2X+LRC/MXquuMPI2uku7R3CN73c
         QA1DaMSYzot+CgkBMcs4Rp4TYt6YrDpMZh+A1s9e2EG3hE1HKe/n+vzztu8KudGW69fY
         ERi/HZBx6Lh6uXMeCNdZLUfbAz1o65601+4uO72LGDk8tAiP6XjM9foCojHTvGuRNsLG
         vD4wjYRniPlytJGUkW9fhWVWSlFS7/s7PK/4UqVHHqrTpon5W4d0SkDvqyqQSiKM9ZC/
         d3Bw==
X-Gm-Message-State: AOAM530+ljlxHzsSQvQHkuHvX9R8UTF5dqbNliTggTSDMPSO7BWajWiB
        LOGMUtLHMGP+wl9KqAhICt5f/jWLN+73
X-Google-Smtp-Source: ABdhPJzvpchAFkdO6Ltc3OqLhz49Vv4vJURrfktF1X47fDD4EErNeXPCFqjdVBDd7YVzY5cy3IEgk4EAc8lK
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:aa7:9101:0:b0:49f:af85:b72c with SMTP id
 1-20020aa79101000000b0049faf85b72cmr2297562pfh.53.1636583439486; Wed, 10 Nov
 2021 14:30:39 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:29:57 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-7-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 06/19] KVM: x86/mmu: Introduce vcpu_make_spte
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
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

Add a wrapper around make_spte which conveys the vCPU-specific context of
the function. This will facilitate factoring out all uses of the vCPU
pointer from make_spte in subsequent commits.

No functional change intended.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c         |  2 +-
 arch/x86/kvm/mmu/paging_tmpl.h |  6 +++---
 arch/x86/kvm/mmu/spte.c        | 17 +++++++++++++----
 arch/x86/kvm/mmu/spte.h        | 12 ++++++++----
 arch/x86/kvm/mmu/tdp_mmu.c     |  7 ++++---
 5 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index baa94acab516..2ada6dee920a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2723,7 +2723,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			was_rmapped = 1;
 	}
 
-	wrprot = make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
+	wrprot = vcpu_make_spte(vcpu, sp, slot, pte_access, gfn, pfn, *sptep, prefetch,
 			   true, host_writable, &spte);
 
 	if (*sptep == spte) {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f87d36898c44..edb8ebd1a775 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1129,9 +1129,9 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		spte = *sptep;
 		host_writable = spte & shadow_host_writable_mask;
 		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-		make_spte(vcpu, sp, slot, pte_access, gfn,
-			  spte_to_pfn(spte), spte, true, false,
-			  host_writable, &spte);
+		vcpu_make_spte(vcpu, sp, slot, pte_access, gfn,
+			       spte_to_pfn(spte), spte, true, false,
+			       host_writable, &spte);
 
 		flush |= mmu_spte_update(sptep, spte);
 	}
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 0c76c45fdb68..04d26e913941 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -90,10 +90,9 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 }
 
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-	       struct kvm_memory_slot *slot,
-	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-	       u64 old_spte, bool prefetch, bool can_unsync,
-	       bool host_writable, u64 *new_spte)
+	       struct kvm_memory_slot *slot, unsigned int pte_access,
+	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
+	       bool can_unsync, bool host_writable, u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
@@ -191,6 +190,16 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return wrprot;
 }
 
+bool vcpu_make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+		    struct kvm_memory_slot *slot, unsigned int pte_access,
+		    gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
+		    bool can_unsync, bool host_writable, u64 *new_spte)
+{
+	return make_spte(vcpu, sp, slot, pte_access, gfn, pfn, old_spte,
+			 prefetch, can_unsync, host_writable, new_spte);
+
+}
+
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled)
 {
 	u64 spte = SPTE_MMU_PRESENT_MASK;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index cc432f9a966b..14f18082d505 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -330,10 +330,14 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 }
 
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-	       struct kvm_memory_slot *slot,
-	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-	       u64 old_spte, bool prefetch, bool can_unsync,
-	       bool host_writable, u64 *new_spte);
+	       struct kvm_memory_slot *slot, unsigned int pte_access,
+	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
+	       bool can_unsync, bool host_writable, u64 *new_spte);
+bool vcpu_make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+		    struct kvm_memory_slot *slot,
+		    unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
+		    u64 old_spte, bool prefetch, bool can_unsync,
+		    bool host_writable, u64 *new_spte);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1ece645e737f..836eadd4e73a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -980,9 +980,10 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
 	else
-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
-					 fault->pfn, iter->old_spte, fault->prefetch, true,
-					 fault->map_writable, &new_spte);
+		wrprot = vcpu_make_spte(vcpu, sp, fault->slot, ACC_ALL,
+					iter->gfn, fault->pfn, iter->old_spte,
+					fault->prefetch, true,
+					fault->map_writable, &new_spte);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-- 
2.34.0.rc0.344.g81b53c2807-goog

