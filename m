Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B793928E656
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389384AbgJNS2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389386AbgJNS1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:46 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76990C0613E0
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:37 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id r9so67629plo.13
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=FFBzQPOjostuVzGT0bgr6TgN0SRwyWzgmeRr5iYkwnQ=;
        b=mkUcMghCvfrUqEuyEm6x7qZcLWh9Ix40Wu5iZpadYLZt7PjkLYJzlDP/SaU+7Jn0+y
         2X5YqavG/fKCI5ScTplhCy1hh+T+jpS4bQS3Yav8aUkFV/nl8obM6grgsgLiULLB4oRW
         XVFXUiBtVBEFOMDeRFuNqZwyNeDgBC3YFhWLMyrgK0N2+TW4XzJs797KdZ23h/uDKX6T
         1WvmN9+gGo1nf8offO7nBCRcV6Ueqf2tOEAJQaiq5fFonxVm/Sqazq91ERUN6Akg0LQP
         qqXEB3LgfKtm78vqSWy7IeqW9jmMonLlHSlEah64HxTFfLUHeV/fAcAz0YFBTci05QQ7
         Zclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FFBzQPOjostuVzGT0bgr6TgN0SRwyWzgmeRr5iYkwnQ=;
        b=NY4I+ytsbJfEMCLCEN/pwFvlzr+DXb0DUQwiZnuiRFd2QvVvubQEjXhk7uLq5JecZF
         bOr4s4zFIM4oPyPf7ljatnynGTNui/OQWzQ7zLBzj8m/PgVKlmMc4dmb7KasZWu0O9a6
         +8DlyHziVqQMG5AC1uILXYCu/Qn7ZQ2CRy2Y32RryWkK9R9TI2vugnpfeqAxNevh6u+V
         cuwdreaFAjbmAPOkQWInS83xZiQ/C7jle9y1qDXD7IbJpNlhutaz+nhRjvLn57VhLgGJ
         brJL3jTFRyYth1hm5RVQReJF2QjQYTK/Y4pumYOpY540nb973bl0AfO3bjZKVIHVAKa8
         qgRw==
X-Gm-Message-State: AOAM532sPy4BZ4YVF9KBiNgsWYOmKuOcG3pTh+oeAe8+VQ1dg1lboGrW
        tSM717pvMu2mOI9+J5jYeoBADyYlsflW
X-Google-Smtp-Source: ABdhPJyjOmUPlOarDzqS9oyS9DKD2dl3s55+Hd1qG5PogxJspVRQF1+CbOBRSo9z4JKIQHsixeoQRbroRqiR
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:902:fe86:b029:d4:d451:eb56 with SMTP
 id x6-20020a170902fe86b02900d4d451eb56mr602760plm.79.1602700056977; Wed, 14
 Oct 2020 11:27:36 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:58 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-19-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 18/20] kvm: x86/mmu: Support MMIO in the TDP MMU
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
        Ben Gardon <bgardon@google.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
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

v2: Thanks to Dan Carpenter and kernel test robot for finding that root
was used uninitialized in get_mmio_spte.

Signed-off-by: Ben Gardon <bgardon@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 arch/x86/kvm/mmu/mmu.c     | 70 ++++++++++++++++++++++++++------------
 arch/x86/kvm/mmu/tdp_mmu.c | 18 ++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  2 ++
 3 files changed, 69 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 58d2412817c87..2e8bf8d19c35a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3853,54 +3853,82 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
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
+	int root = vcpu->arch.mmu->root_level;
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
 
@@ -3912,7 +3940,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	if (mmio_info_in_cache(vcpu, addr, direct))
 		return RET_PF_EMULATE;
 
-	reserved = walk_shadow_page_get_mmio_spte(vcpu, addr, &spte);
+	reserved = get_mmio_spte(vcpu, addr, &spte);
 	if (WARN_ON(reserved))
 		return -EINVAL;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c471f2e977d11..b1515b89606e1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1128,3 +1128,21 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	return spte_set;
 }
 
+/*
+ * Return the level of the lowest level SPTE added to sptes.
+ * That SPTE may be non-present.
+ */
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
+{
+	struct tdp_iter iter;
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	int leaf = vcpu->arch.mmu->shadow_root_level;
+	gfn_t gfn = addr >> PAGE_SHIFT;
+
+	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
+		leaf = iter.level;
+		sptes[leaf - 1] = iter.old_spte;
+	}
+
+	return leaf;
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index b66283db43221..f890048dfcba5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -43,4 +43,6 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn);
+
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.1011.ga647a8990f-goog

