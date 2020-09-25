Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E38B279346
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbgIYVYI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729332AbgIYVXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:48 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305CBC0613CE
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:48 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id b54so3214933qtk.17
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2W93x0wFn2B/eR702ln689L1xVXpVcuv86awhcY5u5k=;
        b=nvM6eY4KZEPy35TPI8xHdc7ZzfhV6Kb46revIGLZhhGe9x5mRrUVR7yZ6jj6o2KjH4
         NCjnvx5lB0E3i2qbJXNY3sepzWBiNhwDJ8belpU0xTLK7AKrUAt30z1pUAEYqaCJE5Uz
         eTvV/43+HCt4c75LPF0+W88mAICuVNgNulf4YiAY6DVEJkRB9WhiHghQMT9LXLTxp+XB
         rhP7T+KcaUtVFUhNvutqmSYX5MR0aPKWVrsKtpaS9tD0IZIHB7UJMLElmIFjUgne+imK
         pViwBVMUq1JD0Zol8LW6J/Jqf6G8gmm+/1IDvAnzd5OXOZpDQhtV7QJ7X308Gg/i/tfN
         H0Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2W93x0wFn2B/eR702ln689L1xVXpVcuv86awhcY5u5k=;
        b=lXeTrMY/5jA0y7sbrhRUtQA0PHPbJQkmk3xF+2U2rNnKIk3O6z3B/Ojiy1T1fjxwmg
         N+D4OtOzxJYY44+sTN06udmCTbEbhaHApMYTlvLTpzsIPhKdlIWJ2lmh32d99EQGxadF
         HbyOaoVtJu+xTDIjKQ3pJ+33B0cFusB+vwdoVzOjt4jA6EUgWlelpuDmC0WaYXoO90fl
         9p9V6VHfMH9Jxej9Iyr/iGqJ51XWUBy/86Mk48FFZ9elT5QiiP1b//8/2H/5/FmMIhC/
         +4CSyJAu5nAlGrAT99RKzGD9NMw/hE8xM67mshFimFsIajjgOZagWj8su2IS3YCMKB+O
         +Lpg==
X-Gm-Message-State: AOAM532PI0cpQDQB3JxGUTv7GC0LARQc71AjFVW56Tjownx+KnpPNmv6
        tbQMIHJ/QUsxZEDt4adYAQkMrgLV4ATS
X-Google-Smtp-Source: ABdhPJyPxktLMKlNwgUfxRN5VMY8IyHJsoD87PwWyG6SLsXUtbeLR58Fk2FQL55dVOR4gMQji3fS54cG+zfF
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a0c:a4c5:: with SMTP id
 x63mr655836qvx.58.1601069027271; Fri, 25 Sep 2020 14:23:47 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:23:01 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-22-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 21/22] kvm: mmu: Support MMIO in the TDP MMU
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
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

In order to support MMIO, KVM must be able to walk the TDP paging
structures to find mappings for a given GFN. Support this walk for
the TDP MMU.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 70 ++++++++++++++++++++++++++------------
 arch/x86/kvm/mmu/tdp_mmu.c | 17 +++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  2 ++
 3 files changed, 68 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6101c696e92d3..0ce7720a72d4e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3939,54 +3939,82 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	return vcpu_match_mmio_gva(vcpu, addr);
 }
 
-/* return true if reserved bit is detected on spte. */
-static bool
-walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
+/*
+ * Return the level of the lowest level SPTE added to sptes.
+ * That SPTE may be non-present.
+ */
+static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	u64 sptes[PT64_ROOT_MAX_LEVEL], spte = 0ull;
-	struct rsvd_bits_validate *rsvd_check;
-	int root, leaf;
-	bool reserved = false;
+	int leaf = vcpu->arch.mmu->root_level;
+	u64 spte;
 
-	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
 
 	walk_shadow_page_lockless_begin(vcpu);
 
-	for (shadow_walk_init(&iterator, vcpu, addr),
-		 leaf = root = iterator.level;
+	for (shadow_walk_init(&iterator, vcpu, addr);
 	     shadow_walk_okay(&iterator);
 	     __shadow_walk_next(&iterator, spte)) {
+		leaf = iterator.level;
 		spte = mmu_spte_get_lockless(iterator.sptep);
 
 		sptes[leaf - 1] = spte;
-		leaf--;
 
 		if (!is_shadow_present_pte(spte))
 			break;
 
+	}
+
+	walk_shadow_page_lockless_end(vcpu);
+
+	return leaf;
+}
+
+/* return true if reserved bit is detected on spte. */
+static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
+{
+	u64 sptes[PT64_ROOT_MAX_LEVEL];
+	struct rsvd_bits_validate *rsvd_check;
+	int root;
+	int leaf;
+	int level;
+	bool reserved = false;
+
+	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa)) {
+		*sptep = 0ull;
+		return reserved;
+	}
+
+	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes);
+	else
+		leaf = get_walk(vcpu, addr, sptes);
+
+	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
+
+	for (level = root; level >= leaf; level--) {
+		if (!is_shadow_present_pte(sptes[level - 1]))
+			break;
 		/*
 		 * Use a bitwise-OR instead of a logical-OR to aggregate the
 		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
 		 * adding a Jcc in the loop.
 		 */
-		reserved |= __is_bad_mt_xwr(rsvd_check, spte) |
-			    __is_rsvd_bits_set(rsvd_check, spte, iterator.level);
+		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level - 1]) |
+			    __is_rsvd_bits_set(rsvd_check, sptes[level - 1],
+					       level);
 	}
 
-	walk_shadow_page_lockless_end(vcpu);
-
 	if (reserved) {
 		pr_err("%s: detect reserved bits on spte, addr 0x%llx, dump hierarchy:\n",
 		       __func__, addr);
-		while (root > leaf) {
+		for (level = root; level >= leaf; level--)
 			pr_err("------ spte 0x%llx level %d.\n",
-			       sptes[root - 1], root);
-			root--;
-		}
+			       sptes[level - 1], level);
 	}
 
-	*sptep = spte;
+	*sptep = sptes[leaf - 1];
+
 	return reserved;
 }
 
@@ -3998,7 +4026,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	if (mmio_info_in_cache(vcpu, addr, direct))
 		return RET_PF_EMULATE;
 
-	reserved = walk_shadow_page_get_mmio_spte(vcpu, addr, &spte);
+	reserved = get_mmio_spte(vcpu, addr, &spte);
 	if (WARN_ON(reserved))
 		return -EINVAL;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b83c18e29f9c6..42dde27decd75 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1284,3 +1284,20 @@ void kvm_tdp_mmu_recover_nx_lpages(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
 }
 
+/*
+ * Return the level of the lowest level SPTE added to sptes.
+ * That SPTE may be non-present.
+ */
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
+{
+	struct tdp_iter iter;
+	int leaf = vcpu->arch.mmu->shadow_root_level;
+	gfn_t gfn = addr >> PAGE_SHIFT;
+
+	for_each_tdp_pte_vcpu(iter, vcpu, gfn, gfn + 1) {
+		leaf = iter.level;
+		sptes[leaf - 1] = iter.old_spte;
+	}
+
+	return leaf;
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 45ea2d44545db..cc0b7241975aa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -45,4 +45,6 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn);
 
 void kvm_tdp_mmu_recover_nx_lpages(struct kvm *kvm);
+
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.709.gb0816b6eb0-goog

