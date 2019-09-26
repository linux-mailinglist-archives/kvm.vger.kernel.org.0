Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33047BFBE1
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729078AbfIZXTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:34 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:51111 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729000AbfIZXTc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:32 -0400
Received: by mail-pl1-f202.google.com with SMTP id y13so462789plr.17
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JUGraIaLqmijv4F/Vbw+p3xiRS5LLRdChqSbaFpw9Zc=;
        b=N8BmjKUDW4mTWxF4ImTP9YCNv7HkPOoZFL1d36GmZId8glcLuKTlpmGGWU0IGRJ6yd
         TsmbcM9cELfIQ7ycXdigaJbMfkNzuAjnnSQtJOmbDammr7KZAHE83wDvdGyGu1bLPVl6
         qIuwhp4somevfLty1G5JgMAAdKE8De8CqXdBbUENoyP+zDGGv49+5bWN8eCqV+HZIZM/
         q7DyPYkd3jQtrantXPx+l/jvR1hjs92FHUJKJILBwc+CogynF/LrbB5aX4bR53sRGDeJ
         8aD9NrcWYuFVIkbCwkFhUH9sqjJO84FvMwKHw3LwdNXCOqW63ZQPt8mA9ynLhozgBV5t
         /Usg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JUGraIaLqmijv4F/Vbw+p3xiRS5LLRdChqSbaFpw9Zc=;
        b=fdsdpeewkJBMjKKjJG22/n/44/FYl8CheKJOC00raTx65RDL6gWP5cJQLfo0vSGS2J
         PpTssoPPeS7bbu+8hgcO13KqEiHtTKgiWj3bHQJbgMBldGycW6PB9cekQBmku0SK74+V
         BSBFiiZkA2cgPTXxa6iTad6J7P3aZKPI7rhdIMOO9GrULyrHY6H8kcdDzpnQj8Ua8bhd
         gITiqN2yKUt5uCO9EQPmfxcDZmUiNjacxEnNIertmHmAB5VA1h6sb+2uqMQw1Oa08jsS
         2tHBI9EnbLqHn/FeHyPTAvqFn+cUDfR6gZOZ9dFtHMeyP3zr0isJ8FOdFMyumM4V5kjr
         E3rg==
X-Gm-Message-State: APjAAAVnh0PixBHUB3rReCqJbkbq7P/zU3LBpuY/oC1lW7eHrliIuQZi
        NI7AE2/+jkQk1W33KSpjvsunxqEPT5o5BjCwE+aKPnOJ6JhcgsRIIoM3Us9Li1Dt2Hxm6tqsPV9
        JWXDdjlVVsxn5cvwCxJCvZg6A/+99GcEg1wbghxNqKQQfgsMTqp4781czajpA
X-Google-Smtp-Source: APXvYqxNgqUKLM/jFdgIhbiE8U/C18awddqHW2XEsmiwqTv95FMcPzfMPl8aeVfthvboeyuxCeBSa7mLI+4d
X-Received: by 2002:a63:2062:: with SMTP id r34mr6122824pgm.48.1569539971754;
 Thu, 26 Sep 2019 16:19:31 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:24 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-29-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 28/28] kvm: mmu: Support MMIO in the direct MMU
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add direct MMU handlers to the functions required to support MMIO

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 91 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 68 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 72c2289132c43..0a23daea0df50 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5464,49 +5464,94 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	return vcpu_match_mmio_gva(vcpu, addr);
 }
 
-/* return true if reserved bit is detected on spte. */
-static bool
-walk_shadow_page_get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
+/*
+ * Return the level of the lowest level pte added to ptes.
+ * That pte may be non-present.
+ */
+static int direct_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *ptes)
 {
-	struct kvm_shadow_walk_iterator iterator;
-	u64 sptes[PT64_ROOT_MAX_LEVEL], spte = 0ull;
-	int root, leaf;
-	bool reserved = false;
+	struct direct_walk_iterator iter;
+	int leaf = vcpu->arch.mmu->root_level;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
-		goto exit;
+	direct_walk_iterator_setup_walk(&iter, vcpu->kvm,
+			kvm_arch_vcpu_memslots_id(vcpu), addr >> PAGE_SHIFT,
+			(addr >> PAGE_SHIFT) + 1, MMU_NO_LOCK);
+	while (direct_walk_iterator_next_pte(&iter)) {
+		leaf = iter.level;
+		ptes[leaf - 1] = iter.old_pte;
+		if (!is_shadow_present_pte(iter.old_pte))
+			break;
+	}
+	direct_walk_iterator_end_traversal(&iter);
+
+	return leaf;
+}
+
+/*
+ * Return the level of the lowest level spte added to sptes.
+ * That spte may be non-present.
+ */
+static int shadow_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
+{
+	struct kvm_shadow_walk_iterator iterator;
+	int leaf = vcpu->arch.mmu->root_level;
+	u64 spte;
 
 	walk_shadow_page_lockless_begin(vcpu);
 
-	for (shadow_walk_init(&iterator, vcpu, addr),
-		 leaf = root = iterator.level;
+	for (shadow_walk_init(&iterator, vcpu, addr);
 	     shadow_walk_okay(&iterator);
 	     __shadow_walk_next(&iterator, spte)) {
+		leaf = iterator.level;
 		spte = mmu_spte_get_lockless(iterator.sptep);
-
 		sptes[leaf - 1] = spte;
-		leaf--;
 
 		if (!is_shadow_present_pte(spte))
 			break;
-
-		reserved |= is_shadow_zero_bits_set(vcpu->arch.mmu, spte,
-						    iterator.level);
 	}
 
 	walk_shadow_page_lockless_end(vcpu);
 
+	return leaf;
+}
+
+/* return true if reserved bit is detected on spte. */
+static bool get_mmio_pte(struct kvm_vcpu *vcpu, u64 addr, bool direct,
+			 u64 *ptep)
+{
+	u64 ptes[PT64_ROOT_MAX_LEVEL];
+	int root = vcpu->arch.mmu->root_level;
+	int leaf;
+	int level;
+	bool reserved = false;
+
+
+	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa)) {
+		*ptep = 0ull;
+		return reserved;
+	}
+
+	if (direct && vcpu->kvm->arch.direct_mmu_enabled)
+		leaf = direct_mmu_get_walk(vcpu, addr, ptes);
+	else
+		leaf = shadow_mmu_get_walk(vcpu, addr, ptes);
+
+	for (level = root; level >= leaf; level--) {
+		if (!is_shadow_present_pte(ptes[level - 1]))
+			break;
+		reserved |= is_shadow_zero_bits_set(vcpu->arch.mmu,
+				ptes[level - 1], level);
+	}
+
 	if (reserved) {
 		pr_err("%s: detect reserved bits on spte, addr 0x%llx, dump hierarchy:\n",
 		       __func__, addr);
-		while (root > leaf) {
+		for (level = root; level >= leaf; level--)
 			pr_err("------ spte 0x%llx level %d.\n",
-			       sptes[root - 1], root);
-			root--;
-		}
+			       ptes[level - 1], level);
 	}
-exit:
-	*sptep = spte;
+
+	*ptep = ptes[leaf - 1];
 	return reserved;
 }
 
@@ -5518,7 +5563,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	if (mmio_info_in_cache(vcpu, addr, direct))
 		return RET_PF_EMULATE;
 
-	reserved = walk_shadow_page_get_mmio_spte(vcpu, addr, &spte);
+	reserved = get_mmio_pte(vcpu, addr, direct, &spte);
 	if (WARN_ON(reserved))
 		return -EINVAL;
 
-- 
2.23.0.444.g18eeb5a265-goog

