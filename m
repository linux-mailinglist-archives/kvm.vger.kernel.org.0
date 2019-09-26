Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F40BFBDA
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbfIZXTS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:18 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:38234 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728923AbfIZXTS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:18 -0400
Received: by mail-pf1-f202.google.com with SMTP id o73so506139pfg.5
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F99sLOt6ycqNpVSwRazWYbJGaaY9sNjDqxSMusz0x3Q=;
        b=iXWnTMR7sovsTNb7RwuU1sO/9obsyk5x2c2g8W9SWQLW5CMgjoQ99yNcU9qR8qCVlK
         aogC9AjD8eGueFb6ve4S/u8IFwUDAWSzaTBLC/3Vb8+x9MvLk/thfUlQZ8gbitCNF89H
         WpvCPJ0UInLXUaWLRRFMVZZXfAz4eoLaZWYpWmkBEzOumY9RmaZpa6+ID5MquLpp14ry
         3CuCYiu9nqpXcu4r2svqE1gwd3KVihlU4RDjT3mQUNxnIgc1iKdhIO/VBoAVjCUhmdot
         EJ/79gZEQdYIKC78FPBOxmCQ8+/nRvt05ivM+xFuzpJkNVmAH/6WtGZ1qX4B24p7nvmQ
         aiKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F99sLOt6ycqNpVSwRazWYbJGaaY9sNjDqxSMusz0x3Q=;
        b=meq2vgkw63N2AZSlUWHZJXcJGQuWqnefgYeKOYPA9VCVzfuYgC+m+/dUsrAOmJAJf2
         bXr1Ob178GWEiwq1/lxwMKP7xZxj3IydhQYI1griYJe0lmohUmr/Q+n/z9MI0GXZzPgq
         7YoqzwrBJk+owNLFOrY1M4FNdUwWMMXNxvaXvd/u8k/N0GGBL/PgA0hfSuPfEHU457CE
         FJIZjgzOsSlEyCHtBbyZF9AdhMUnyNqS61ZiYwv02keszchrQ+jPU2Zxyx18GtSvwYB5
         nf2j9vOYBNRMlNrjMIrw8rjBL1Z6rwYEJ974N1dyICvqOYwCBgWWqRAQP8L+B/bLIVRo
         NhZw==
X-Gm-Message-State: APjAAAU8s0gH270N2j0ZjirXVK3KIdRkTIAPyU0/ZuqaQLGxsERyU9yj
        XEyFvWrejM3iNb+sV5TcMYaJAnj4T8Ud1eruGQxWgTBHfVUOf/wG9UR7mXAk2U2Ok4PKu3B44LP
        LOo6Rjlbcw0JRtOA1nRRdqPWZMD2jpSaRtEvhy8KsnyoG3oEb21ojmoReegPg
X-Google-Smtp-Source: APXvYqxy4rEPW7fSq0jEXq3PQ3dro8OT2SKGdp0doBqa2qiOp3znwJyslw+3RPUpUKvQvBBrmk0rzSd8U74y
X-Received: by 2002:a63:78cf:: with SMTP id t198mr6065109pgc.227.1569539955863;
 Thu, 26 Sep 2019 16:19:15 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:17 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-22-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 21/28] kvm: mmu: Integrate the direct mmu with the changed
 pte notifier
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

Implements arch specific handler functions for the changed pte MMU
notifier. This handler uses the paging structure walk iterator and is
needed to allow the main MM to update page permissions safely on pages
backing guest memory.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 53 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ca9b3f574f401..b144c803c36d2 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2386,7 +2386,6 @@ static bool direct_walk_iterator_next_present_pte(
 /*
  * As direct_walk_iterator_next_present_pte but skips over non-leaf ptes.
  */
-__attribute__((unused))
 static bool direct_walk_iterator_next_present_leaf_pte(
 		struct direct_walk_iterator *iter)
 {
@@ -2867,9 +2866,59 @@ int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
 	return r;
 }
 
+static int set_direct_pte_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
+			      gfn_t start, gfn_t end, unsigned long pte)
+{
+	struct direct_walk_iterator iter;
+	pte_t host_pte;
+	kvm_pfn_t new_pfn;
+	u64 new_pte;
+
+	host_pte.pte = pte;
+	new_pfn = pte_pfn(host_pte);
+
+	direct_walk_iterator_setup_walk(&iter, kvm, slot->as_id, start, end,
+					MMU_WRITE_LOCK);
+	while (direct_walk_iterator_next_present_leaf_pte(&iter)) {
+		BUG_ON(iter.level != PT_PAGE_TABLE_LEVEL);
+
+		if (pte_write(host_pte))
+			new_pte = 0;
+		else {
+			new_pte = iter.old_pte & ~PT64_BASE_ADDR_MASK;
+			new_pte |= new_pfn << PAGE_SHIFT;
+			new_pte &= ~PT_WRITABLE_MASK;
+			new_pte &= ~SPTE_HOST_WRITEABLE;
+			new_pte &= ~shadow_dirty_mask;
+			new_pte &= ~shadow_accessed_mask;
+			new_pte = mark_spte_for_access_track(new_pte);
+		}
+
+		if (!direct_walk_iterator_set_pte(&iter, new_pte))
+			continue;
+	}
+	return direct_walk_iterator_end_traversal(&iter);
+}
+
+static int set_direct_pte_hva(struct kvm *kvm, unsigned long address,
+			    pte_t host_pte)
+{
+	return kvm_handle_direct_hva_range(kvm, address, address + 1,
+					   host_pte.pte, set_direct_pte_gfn);
+}
+
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 {
-	return kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
+	int need_flush = 0;
+
+	WARN_ON(pte_huge(pte));
+
+	if (kvm->arch.direct_mmu_enabled)
+		need_flush |= set_direct_pte_hva(kvm, hva, pte);
+	if (!kvm->arch.pure_direct_mmu)
+		need_flush |= kvm_handle_hva(kvm, hva, (unsigned long)&pte,
+					     kvm_set_pte_rmapp);
+	return need_flush;
 }
 
 static int kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-- 
2.23.0.444.g18eeb5a265-goog

