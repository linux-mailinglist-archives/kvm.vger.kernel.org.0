Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431AD35240F
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236397AbhDAXiR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbhDAXiJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:38:09 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA04C06178C
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:38:08 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id b18so4044122qte.21
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fVPoZK10rbW/sWCKlsGNCSQYscZnz2kgphabjqMmfzM=;
        b=ZDFK3UVlkGJWGHGbOLGMNIFNnlxM8sIyvZBjvKBxNU7Mh6KtoXihkXSL5rGaPfVVw+
         0au+OqbsD92YWKzPa6nTGeOWVSdm3X3JxaJsSxMGsKnRL0PfXUr4nXFbbBhkztjoaWvc
         QAicl/BQnTBZWaD0+6yhN+caM8P2JWjYe6MWOBj/m/nJ2/BtWWz7XY+iMBdIy30gk61Y
         A4DuG/a5t4CmtpgCHxTW1xxeTvzqH+VditXXRkxPW5kR3dq6IDcMr9S/i0A8FtGLAfZp
         EGDCO0uKO1WKAmaH1PC6wbNtr3Wh2jIsLs2T0dIjOFbBmrx/85n3Ja0B3LaecEl6Zuf+
         s5yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fVPoZK10rbW/sWCKlsGNCSQYscZnz2kgphabjqMmfzM=;
        b=GMsKIxbgV3k6tTnQJDo10D4fKA3uSUVHk+bZzxdaRlp86YNy9NooKjpUdhxnXDebBz
         POyE3vbLRFoh/YBlOzvWzVz6Ej8WmLAmIs6yhAVFi3950SPyxbTf37XfWE14MHCjGZJ9
         HCT3QrrzJFpm8SszCn9mkWK39B70vGUuxYzf+4idQ92JNZ9cnpNfsrjZ6Dr6wSuznnZV
         /Q79YEj900R9HCXgE37aXM7gJj2P5TtpV9M3ifKxi026HgibdorIa4si1MXL6VaiOt1D
         8QWSY3A2W8WY5l7RkT9StHu0Q+T0SuZXKcnLd4IY6Jf0waOjeV2pCaX57hfO+jH4sdTS
         wcrQ==
X-Gm-Message-State: AOAM530kftf98WASNA2VXQwC5Vl0rIZBH1H1JPtrvl+qbl3/iA4yfVlT
        TKjzDNZc7iBUz7rcQTIrnhFUa0kKp6e4
X-Google-Smtp-Source: ABdhPJy3DjSB6LnYpqcpR9OF0VpRbdFeYIra9rOadwaQyRGOaPToqSVvf5SQZ+7Nz08k44Y6MFnu9v+X/9n8
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a05:6214:122f:: with SMTP id
 p15mr10707612qvv.3.1617320288078; Thu, 01 Apr 2021 16:38:08 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:29 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-7-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 06/13] KVM: x86/mmu: Make TDP MMU root refcount atomic
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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

In order to parallelize more operations for the TDP MMU, make the
refcount on TDP MMU roots atomic, so that a future patch can allow
multiple threads to take a reference on the root concurrently, while
holding the MMU lock in read mode.

Signed-off-by: Ben Gardon <bgardon@google.com>
---

Changelog
v2:
--	Split failure handling for kvm_tdp_mmu_get_root out into a
	seperate commit.

 arch/x86/kvm/mmu/mmu_internal.h |  6 +++++-
 arch/x86/kvm/mmu/tdp_mmu.c      |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.h      | 10 +++++++---
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 9347d73996b5..f63d0fdb8567 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -50,7 +50,11 @@ struct kvm_mmu_page {
 	u64 *spt;
 	/* hold the gfn of each spte inside spt */
 	gfn_t *gfns;
-	int root_count;          /* Currently serving as active root */
+	/* Currently serving as active root */
+	union {
+		int root_count;
+		refcount_t tdp_mmu_root_count;
+	};
 	unsigned int unsync_children;
 	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 670c5e3ad80e..697ea882a3e4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -56,7 +56,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	if (--root->root_count)
+	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
 		return;
 
 	WARN_ON(!root->tdp_mmu_page);
@@ -168,7 +168,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	}
 
 	root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
-	root->root_count = 1;
+	refcount_set(&root->tdp_mmu_root_count, 1);
 
 	list_add(&root->link, &kvm->arch.tdp_mmu_roots);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index d4e32ac5f4c9..1ec7914ecff9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,10 +10,14 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 static inline void kvm_tdp_mmu_get_root(struct kvm *kvm,
 					struct kvm_mmu_page *root)
 {
-	BUG_ON(!root->root_count);
-	lockdep_assert_held(&kvm->mmu_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	++root->root_count;
+	/*
+	 * This should never fail since roots are removed from the roots
+	 * list under the MMU write lock when their reference count falls
+	 * to zero.
+	 */
+	refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
 
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root);
-- 
2.31.0.208.g409f899ff0-goog

