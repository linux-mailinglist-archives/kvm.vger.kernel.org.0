Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A7027934A
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbgIYVYQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729312AbgIYVXo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 17:23:44 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC019C0613CE
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:44 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id b39so3275706qta.0
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wGRaKZqepjfqHu8EAcgDimD+fkRsdcPXOcl2oXcLVLw=;
        b=tAJy0i4VTSVjyS7q2KkOmQHelTLbYCm/7l3p0QD0QKcCbL/jJKy3KcSb0AiykDcVPg
         q+Ir25YzqwwJR8isTg9v6pVwrLyYA6IGTLKlOjfBt6hu4KGuO3eyMgMinGyLOzik/jRL
         cqGHpN2Y9V3DsjS8kEQK7VHIDA4y7qfZDSlXNm7TqGoomvY5l7cNR75hyIsQA0yhV5NB
         Q62xqjjwH8gq1bhPyJHSuaydyRFNGcAlaCKnXJitGDSCdRjOMA+nizYntreGmKR1N4Kc
         6OLtsV/mj8Ow+UX8WBLM6j22Q/kuyoU6QMj6Gran4+mEwWcxQ8HBOxZUMn2o085UXsUb
         Oc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wGRaKZqepjfqHu8EAcgDimD+fkRsdcPXOcl2oXcLVLw=;
        b=oUuHvWdYOkEefJv2g8G/GJLnK0eMDCPP1U5WHtasl5LV+QEN8cccc+URshSOvugcMJ
         zDBh3EAK9jeJRuoa4ipnprrvzcYDwzkIdWcY4peMIX3WtP4t/1UxQNZFx9epH5EmnFGe
         JprWMqs5L3ov+AYwsy4rVXMzafccWv5wq7GiOmCrYNF0i+/8JLDULxtkStLw9IAnG/st
         qAdSU0RhjF05gOq1quRM1r9VtytgudKdCAezpubmkyXFHNxTHB4MD4PcNcxjnvO7tPbn
         bY+AV7/lWmKPqBSGke7nwx10d2er39CZPo/KphJs9UDzYpoEwLkv8579f4HDCqkX4WAw
         2P9w==
X-Gm-Message-State: AOAM531y+fnmB8/Kcp2XEGI5gHMpuUuy4vn7BHdm2vrA9lsrl+QJqRKv
        V7ptyw7X6cvKZjf86bvKg7wYPUixuiKg
X-Google-Smtp-Source: ABdhPJx4y/if82KtvkXENISsfx8NKmDmAhvA8WY15xvjNvUppkQAPg+tX2rELyCptq23jwCVN1Mw1E/1wkrr
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a0c:e04e:: with SMTP id
 y14mr674676qvk.38.1601069022744; Fri, 25 Sep 2020 14:23:42 -0700 (PDT)
Date:   Fri, 25 Sep 2020 14:22:59 -0700
In-Reply-To: <20200925212302.3979661-1-bgardon@google.com>
Message-Id: <20200925212302.3979661-20-bgardon@google.com>
Mime-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH 19/22] kvm: mmu: Support write protection for nesting in tdp MMU
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

To support nested virtualization, KVM will sometimes need to write
protect pages which are part of a shadowed paging structure or are not
writable in the shadowed paging structure. Add a function to write
protect GFN mappings for this purpose.

Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
machine. This series introduced no new failures.

This series can be viewed in Gerrit at:
	https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c     |  5 ++++
 arch/x86/kvm/mmu/tdp_mmu.c | 57 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
 3 files changed, 65 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 12892fc4f146d..e6f5093ba8f6f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1667,6 +1667,11 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
 	}
 
+	if (kvm->arch.tdp_mmu_enabled)
+		write_protected =
+			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn) ||
+			write_protected;
+
 	return write_protected;
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a2895119655ac..931cb469b1f2f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1161,3 +1161,60 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		put_tdp_mmu_root(kvm, root);
 	}
 }
+
+/*
+ * Removes write access on the last level SPTE mapping this GFN and unsets the
+ * SPTE_MMU_WRITABLE bit to ensure future writes continue to be intercepted.
+ * Returns true if an SPTE was set and a TLB flush is needed.
+ */
+static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
+			      gfn_t gfn)
+{
+	struct tdp_iter iter;
+	u64 new_spte;
+	bool spte_set = false;
+	int as_id = kvm_mmu_page_as_id(root);
+
+	for_each_tdp_pte_root(iter, root, gfn, gfn + 1) {
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level))
+			continue;
+
+		if (!is_writable_pte(iter.old_spte))
+			break;
+
+		new_spte = iter.old_spte &
+			~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
+
+		*iter.sptep = new_spte;
+		handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
+				    new_spte, iter.level);
+		spte_set = true;
+	}
+
+	return spte_set;
+}
+
+/*
+ * Removes write access on the last level SPTE mapping this GFN and unsets the
+ * SPTE_MMU_WRITABLE bit to ensure future writes continue to be intercepted.
+ * Returns true if an SPTE was set and a TLB flush is needed.
+ */
+bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	struct kvm_mmu_page *root;
+	int root_as_id;
+	bool spte_set = false;
+
+	lockdep_assert_held(&kvm->mmu_lock);
+	for_each_tdp_mmu_root(kvm, root) {
+		root_as_id = kvm_mmu_page_as_id(root);
+		if (root_as_id != slot->as_id)
+			continue;
+
+		spte_set = write_protect_gfn(kvm, root, gfn) || spte_set;
+	}
+	return spte_set;
+}
+
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 10e70699c5372..2ecb047211a6d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -40,4 +40,7 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 bool kvm_tdp_mmu_slot_set_dirty(struct kvm *kvm, struct kvm_memory_slot *slot);
 void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       const struct kvm_memory_slot *slot);
+
+bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
+				   struct kvm_memory_slot *slot, gfn_t gfn);
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.28.0.709.gb0816b6eb0-goog

