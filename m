Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C460728E652
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 20:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389292AbgJNS1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Oct 2020 14:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389380AbgJNS1q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Oct 2020 14:27:46 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D552C0613DC
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:35 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id w13so54868plq.20
        for <kvm@vger.kernel.org>; Wed, 14 Oct 2020 11:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=NfhHIv01r/iE20pouU33Lbt4LnC3KxWGgnbW83wgNA4=;
        b=b37+flGVdYc9pMf69O6wTflTQ0F23977EsCnDucMNS2a/nbjlnWlMyF2a7QyV9jcTH
         yKPRrJcQNLnWU7fQgXg9qz5jDCgwDx8YvqgFI4WqCZHKhnPvd8QueGefDAYtL0x7LUHC
         38NHii5LekFJL+HhAfxerFLEDaVDwD8OxL4ilLR4rLNGRgX3Cz4qDy+56R7hQOpJLnn1
         zj/Rsz8c5lDdBBN35eGshLjX5mWgp8MELqwI+Beqho3sPOOE0QA/dxvIeWJmmYf3xuYx
         swmPZnCQXCcaFHreu7dFdsq+lyq+fxMuldXyYaSUbVZxAyaWDIazrdMxis1X8kH/xoYK
         ViWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NfhHIv01r/iE20pouU33Lbt4LnC3KxWGgnbW83wgNA4=;
        b=XOFIz4vK4W0qkyFntpRhPSFsi0krTxyE9r379mnw4OwPIzOxpAjRPsqVt0+uopvXvd
         NVZvBPpfDfuCyvZKYo3GcHZ0G6KzP6mB/ZUPCSsTjvg112okVinYaUQcUW8oyGVRfIj8
         ZqDzZD83rD9Z5dIbgImYRCz+m4gRKKJ7/rAuNi5PvSzlVhFz9Nqcx4swieql5bXtDVoU
         bT0LkvCY30WcJQteJEK3Qdrh5bUqpYvvKqaA2BHZhtubdepRz3q0do3BlJyeQpJBNO0N
         q1e0U+87JP259DJHx8jDKr8jk5uU1FAMVnoF6oGU1LzTgRN7Hv7aI8Sm6KJ2KXTEhqsP
         nJYA==
X-Gm-Message-State: AOAM531h/S0UchMbm318amecYUZGFwEQQTDAx6gGE3V974eIXHso9nj2
        gNZtWJmjl+cFjTySQPqsGdh3J8l2SNJ7
X-Google-Smtp-Source: ABdhPJwh+4pXkt1KDW+/VoCNIzHgIyI4NOVovjSw8yRkOVMMgj+zgajSBgIoPeCREGWWy0ljrAsA/FfWvD7z
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a63:570d:: with SMTP id
 l13mr242121pgb.172.1602700055147; Wed, 14 Oct 2020 11:27:35 -0700 (PDT)
Date:   Wed, 14 Oct 2020 11:26:57 -0700
In-Reply-To: <20201014182700.2888246-1-bgardon@google.com>
Message-Id: <20201014182700.2888246-18-bgardon@google.com>
Mime-Version: 1.0
References: <20201014182700.2888246-1-bgardon@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v2 17/20] kvm: x86/mmu: Support write protection for nesting
 in tdp MMU
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
 arch/x86/kvm/mmu/mmu.c     |  4 +++
 arch/x86/kvm/mmu/tdp_mmu.c | 50 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.h |  3 +++
 3 files changed, 57 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8fcf5e955c475..58d2412817c87 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1553,6 +1553,10 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
 	}
 
+	if (kvm->arch.tdp_mmu_enabled)
+		write_protected |=
+			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn);
+
 	return write_protected;
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 94624cc1df84c..c471f2e977d11 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1078,3 +1078,53 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
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
+
+	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1) {
+		if (!is_writable_pte(iter.old_spte))
+			break;
+
+		new_spte = iter.old_spte &
+			~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
+
+		tdp_mmu_set_spte(kvm, &iter, new_spte);
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
index dc4cdc5cc29f5..b66283db43221 100644
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
2.28.0.1011.ga647a8990f-goog

