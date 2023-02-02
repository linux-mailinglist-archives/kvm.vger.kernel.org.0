Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C179668866C
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 19:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjBBS32 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 13:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbjBBS2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 13:28:48 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F8B4522B
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 10:28:27 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i17-20020a25be91000000b0082663f3eecbso2505916ybk.2
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 10:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Leen11Z2EIFQsH+NN7hqdICZGapTSqx3IkQSdi85rv4=;
        b=swDomma/Ao/1AjVGqZhc77Ly1aJmaYi96lJ6fEnLjho/yWLYjCbG87uCRLZVXzLq1M
         LScVQt+pZ9knZ5XD8RVoKRxLT1q+fEpmj2L2LXViaHSf7ilAayTs/eQh/Rwtvr2Vs3eW
         TtDm8cGugXeffCt23ir1w6zNFfj7yik+sgpFjM9V9BSjPfEoc9GUBKMV6qBA74fyHAWP
         +dsl0anfnGpkYnWUciMVIuHcfYl7QH02zwFv0QlTgGrXln7suPDF2xX5Qqk8Hsk0ZjyP
         jBboZOjT/qXiq8k9yfGUjmpOpA/fkbxmaAzM0uqiIkU6UwAe9vuKWKkQTF0m1+TCwBM8
         dJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Leen11Z2EIFQsH+NN7hqdICZGapTSqx3IkQSdi85rv4=;
        b=ySFIE51YE/4H59QM79u1QqxbcJk0w+8a/7n8tM8xLtQXIPZNtwZTHVhuFz7WUCfFA8
         6B69EYzSNJear3MFKuNP5QEA4hJZ+NGuQQD1u1OA/Tjg69UPABpv/aUMjTTa4VLghgpO
         6D1QyWnR0Z23Rk4T0S4LW8e+6VJMEm7rJqU+vUCnhV4W6y7Ui5W02MeVIY1B2h6wgAWT
         FxxYWMRMFgftJUv8EfDfDMGC/cfhdZktqx22HvWC8xktqtGkpJaWGjbQ/Fd/dWY/6oQ4
         sRH6xIA3Zs9Z0B5W/cQd7hPXJhxIMvBTUIwchuijWlRwXiQ+yM17Pp/kMKJnScpe4S4j
         /U2Q==
X-Gm-Message-State: AO0yUKX/j+9WLy5/tHhg2p4O1uG4wRUzTZ+aSnZjds9rZgpeNnjF52j8
        j2ZRXjTtf9B5hO4gwvx/Skzsr7E3yqg=
X-Google-Smtp-Source: AK7set+v8zDs6XnzjllU8ur/f0MIRCkHIofH+Wt+ThfPgIot1Um67e13cWqpbQBNYlMCc88CYLX3y0XmC3I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d095:0:b0:857:8f9c:7b87 with SMTP id
 h143-20020a25d095000000b008578f9c7b87mr368794ybg.558.1675362505413; Thu, 02
 Feb 2023 10:28:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  2 Feb 2023 18:28:17 +0000
In-Reply-To: <20230202182817.407394-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230202182817.407394-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230202182817.407394-4-seanjc@google.com>
Subject: [PATCH v2 3/3] KVM: x86/mmu: Remove FNAME(is_self_change_mapping)
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huang Hang <hhuang@linux.alibaba.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Drop FNAME(is_self_change_mapping) and instead rely on
kvm_mmu_hugepage_adjust() to adjust the hugepage accordingly.  Prior to
commit 4cd071d13c5c ("KVM: x86/mmu: Move calls to thp_adjust() down a
level"), the hugepage adjustment was done before allocating new shadow
pages, i.e. failed to restrict the hugepage sizes if a new shadow page
resulted in account_shadowed() changing the disallowed hugepage tracking.

Removing FNAME(is_self_change_mapping) fixes a bug reported by Huang Hang
where KVM unnecessarily forces a 4KiB page.  FNAME(is_self_change_mapping)
has a defect in that it blindly disables _all_ hugepage mappings rather
than trying to reduce the size of the hugepage.  If the guest is writing
to a 1GiB page and the 1GiB is self-referential but a 2MiB page is not,
then KVM can and should create a 2MiB mapping.

Add a comment above the call to kvm_mmu_hugepage_adjust() to call out the
new dependency on adjusting the hugepage size after walking indirect PTEs.

Reported-by: Huang Hang <hhuang@linux.alibaba.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Link: https://lore.kernel.org/r/20221213125538.81209-1-jiangshanlai@gmail.com
[sean: rework changelog after separating out the emulator change]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 51 +++++-----------------------------
 1 file changed, 7 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f57d9074fb9b..a056f2773dd9 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -690,6 +690,12 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 			fault->write_fault_to_shadow_pgtable = true;
 	}
 
+	/*
+	 * Adjust the hugepage size _after_ resolving indirect shadow pages.
+	 * KVM doesn't support mapping hugepages into the guest for gfns that
+	 * are being shadowed by KVM, i.e. allocating a new shadow page may
+	 * affect the allowed hugepage size.
+	 */
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
 	trace_kvm_mmu_spte_requested(fault);
@@ -734,41 +740,6 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	return RET_PF_RETRY;
 }
 
- /*
- * To see whether the mapped gfn can write its page table in the current
- * mapping.
- *
- * It is the helper function of FNAME(page_fault). When guest uses large page
- * size to map the writable gfn which is used as current page table, we should
- * force kvm to use small page size to map it because new shadow page will be
- * created when kvm establishes shadow page table that stop kvm using large
- * page size. Do it early can avoid unnecessary #PF and emulation.
- *
- * Note: the PDPT page table is not checked for PAE-32 bit guest. It is ok
- * since the PDPT is always shadowed, that means, we can not use large page
- * size to map the gfn which is used as PDPT.
- */
-static bool
-FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
-			      struct guest_walker *walker, bool user_fault)
-{
-	int level;
-	gfn_t mask = ~(KVM_PAGES_PER_HPAGE(walker->level) - 1);
-	bool self_changed = false;
-
-	if (!(walker->pte_access & ACC_WRITE_MASK ||
-	    (!is_cr0_wp(vcpu->arch.mmu) && !user_fault)))
-		return false;
-
-	for (level = walker->level; level <= walker->max_level; level++) {
-		gfn_t gfn = walker->gfn ^ walker->table_gfn[level - 1];
-
-		self_changed |= !(gfn & mask);
-	}
-
-	return self_changed;
-}
-
 /*
  * Page fault handler.  There are several causes for a page fault:
  *   - there is no shadow pte for the guest pte
@@ -787,7 +758,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 {
 	struct guest_walker walker;
 	int r;
-	bool is_self_change_mapping;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
 	WARN_ON_ONCE(fault->is_tdp);
@@ -812,6 +782,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	fault->gfn = walker.gfn;
+	fault->max_level = walker.level;
 	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
 
 	if (page_fault_handle_page_track(vcpu, fault)) {
@@ -823,14 +794,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
-	      &walker, fault->user);
-
-	if (is_self_change_mapping)
-		fault->max_level = PG_LEVEL_4K;
-	else
-		fault->max_level = walker.level;
-
 	r = kvm_faultin_pfn(vcpu, fault, walker.pte_access);
 	if (r != RET_PF_CONTINUE)
 		return r;
-- 
2.39.1.519.gcb327c4b5f-goog

