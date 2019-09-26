Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13558BFBD3
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbfIZXTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:03 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:34947 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729020AbfIZXTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:03 -0400
Received: by mail-pl1-f201.google.com with SMTP id o12so481117pll.2
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jOKwZN3XEhzdi2oUrC3zhPSHel7/C8L4AM2NV+iLdm8=;
        b=XpQjmlV4NN0PNUXJ9uWgfEqDa42W8EQEQUC99DPTihxftPgFebsAFBM7/pK6hQ63Er
         9o6gTAF4jRM2weCgsxsb2NaraUJ9b6Rg5VPcUUl3H6IF7QdT7oKEFv6vhlq278x+46cI
         5WzXv67hbLUHF2rd6/YsNQtEa3mfOGsmRYN3iHxH0+jb3eLMDmzEiPYRkZWFOTq5K+LX
         5KObRlmFhjR2/B7VUzxxIJaqHXjBSp7jtqpV9fSzdRdzH/bxpnXUNXx/f4opflQURDhK
         wf+S+2djRkDr9QACyRmMPOAnbnlpku+98P2JaDte37JF/xlfsGEmLBhqe51Gm0oD9Q3n
         saGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jOKwZN3XEhzdi2oUrC3zhPSHel7/C8L4AM2NV+iLdm8=;
        b=Z+i+MIjhdAVxiJSUvo1FmCQkiOslar4yOmtqGHQ4xlgNcgzHa2syAGcSlVfmEfEyvn
         tTw0vtzVH9YnDu2eFr/H2svubzzjNB0tWnDcNEIJem9OYVmit1WN8sS7SdOZcBOowQ+Q
         BNwWSh8W1WWOYH5RZ3Zi6J4KelgxQOVx4tAQ6fPueHs2scxxrIHTRVqjjHVwThhVjjdC
         EnbThHQZvlOWyWCywF0gLXmQVSmMY+8snU+4+OpojIEDPAZwyFlmFEJZGRHPA0taePI/
         ihoWJzpccWb0G/AmOewWnDF2N9t5WPRgrC0GFrclV6pOz4Z9Mc+yCPnDfwV9JPsZv3ru
         asBg==
X-Gm-Message-State: APjAAAWIiscwCdQp62LSdvfI68ky5oZFJhRHGbuqle2992PgOvv5f5N6
        VQKpbGZAqzJ7oaONdaIN0qo8ExXyrnhIUYG0hFX0fIeW6NlHjN0pOhh8zsL79m61keBYIqSYJXR
        nOKfuqkRWmguQzr7bcpUa3DS80yT2HVCRe7XctQVNZJaLtslsG7gxJYlr1yPg
X-Google-Smtp-Source: APXvYqxuL271toK8U8WGwGmj4KV/b8ktfcX5u08/t3ZVQnvxQ3tYLhIErb8VmQ4MHV/wCDzUGYosm6xkA83t
X-Received: by 2002:a65:6557:: with SMTP id a23mr6036986pgw.439.1569539942167;
 Thu, 26 Sep 2019 16:19:02 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:11 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-16-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 15/28] kvm: mmu: Support invalidate_zap_all_pages
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

Adds a function for zapping ranges of GFNs in an address space which
uses the paging structure iterator and uses the function to support
invalidate_zap_all_pages for the direct MMU.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 69 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 234db5f4246a4..f0696658b527c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2120,7 +2120,6 @@ static void direct_walk_iterator_reset_traversal(
  * range, so the last gfn to be interated over would be the largest possible
  * GFN, in this scenario.)
  */
-__attribute__((unused))
 static void direct_walk_iterator_setup_walk(struct direct_walk_iterator *iter,
 	struct kvm *kvm, int as_id, gfn_t start, gfn_t end,
 	enum mmu_lock_mode lock_mode)
@@ -2151,7 +2150,6 @@ static void direct_walk_iterator_setup_walk(struct direct_walk_iterator *iter,
 	direct_walk_iterator_start_traversal(iter);
 }
 
-__attribute__((unused))
 static void direct_walk_iterator_retry_pte(struct direct_walk_iterator *iter)
 {
 	BUG_ON(!iter->walk_in_progress);
@@ -2397,7 +2395,6 @@ static bool cmpxchg_pte(u64 *ptep, u64 old_pte, u64 new_pte, int level, u64 gfn)
 	return r == old_pte;
 }
 
-__attribute__((unused))
 static bool direct_walk_iterator_set_pte(struct direct_walk_iterator *iter,
 					 u64 new_pte)
 {
@@ -2725,6 +2722,44 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 	return ret;
 }
 
+/*
+ * Marks the range of gfns, [start, end), non-present.
+ */
+static bool zap_direct_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
+				gfn_t end, enum mmu_lock_mode lock_mode)
+{
+	struct direct_walk_iterator iter;
+
+	direct_walk_iterator_setup_walk(&iter, kvm, as_id, start, end,
+					lock_mode);
+	while (direct_walk_iterator_next_present_pte(&iter)) {
+		/*
+		 * The gfn range should be handled at the largest granularity
+		 * possible, however since the functions which handle changed
+		 * PTEs (and freeing child PTs) will not yield, zapping an
+		 * entry with too many child PTEs can lead to scheduler
+		 * problems. In order to avoid scheduler problems, only zap
+		 * PTEs at PDPE level and lower. The root level entries will be
+		 * zapped and the high level page table pages freed on VM
+		 * teardown.
+		 */
+		if ((iter.pte_gfn_start < start ||
+		     iter.pte_gfn_end > end ||
+		     iter.level > PT_PDPE_LEVEL) &&
+		    !is_last_spte(iter.old_pte, iter.level))
+			continue;
+
+		/*
+		 * If the compare / exchange succeeds, then we will continue on
+		 * to the next pte. If it fails, the next iteration will repeat
+		 * the current pte. We'll handle both cases in the same way, so
+		 * we don't need to check the result here.
+		 */
+		direct_walk_iterator_set_pte(&iter, 0);
+	}
+	return direct_walk_iterator_end_traversal(&iter);
+}
+
 static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 			  unsigned long data,
 			  int (*handler)(struct kvm *kvm,
@@ -6645,11 +6680,26 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
  */
 static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 {
+	int i;
+
 	lockdep_assert_held(&kvm->slots_lock);
 
 	write_lock(&kvm->mmu_lock);
 	trace_kvm_mmu_zap_all_fast(kvm);
 
+	/* Zap all direct MMU PTEs slowly */
+	if (kvm->arch.direct_mmu_enabled) {
+		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
+			zap_direct_gfn_range(kvm, i, 0, ~0ULL,
+					MMU_WRITE_LOCK | MMU_LOCK_MAY_RESCHED);
+	}
+
+	if (kvm->arch.pure_direct_mmu) {
+		kvm_flush_remote_tlbs(kvm);
+		write_unlock(&kvm->mmu_lock);
+		return;
+	}
+
 	/*
 	 * Toggle mmu_valid_gen between '0' and '1'.  Because slots_lock is
 	 * held for the entire duration of zapping obsolete pages, it's
@@ -6888,8 +6938,21 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
 	int ign;
+	int i;
 
 	write_lock(&kvm->mmu_lock);
+	if (kvm->arch.direct_mmu_enabled) {
+		for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
+			zap_direct_gfn_range(kvm, i, 0, ~0ULL,
+					MMU_WRITE_LOCK | MMU_LOCK_MAY_RESCHED);
+		kvm_flush_remote_tlbs(kvm);
+	}
+
+	if (kvm->arch.pure_direct_mmu) {
+		write_unlock(&kvm->mmu_lock);
+		return;
+	}
+
 restart:
 	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
 		if (sp->role.invalid && sp->root_count)
-- 
2.23.0.444.g18eeb5a265-goog

