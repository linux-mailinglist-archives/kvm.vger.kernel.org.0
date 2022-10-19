Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE88605418
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 01:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbiJSXlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 19:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbiJSXlD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 19:41:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A95714706B
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:41:02 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-355ece59b6fso184725417b3.22
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 16:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zFH3G7LsSXeaC13FetE3TNq4DuchE1MnbnYjQT4HA7E=;
        b=YNsR91JctrtPdsguBr6NgBHhDdYnYDeP6HxmtsefOhJeAqHMIxPZ3axdeVFOqJIhxQ
         c2rH8QZE4x3io6GUnjLyO/T7z9trIHyphbkpp2T9fx4KLiqq364qJ/GFIziTtPHyGVHr
         J0jq9xom2PBwl7ggJ3PMfSXEwdQqko3L5r3tTHk/xA2ajx6xwF1nOLxtjt7jW7Zvyaa6
         Vh7yAxRWMi7jz9YwYOGDg+tGByJbciklEPYGQjKRx+ToSHexQ+haGxLTNHHwkKL62+OC
         mSaYp/O9K4PFbfDMv5f1+7mRDS6fYbfRbNpmdSpRTDJJWLhGkLaa8XaggbT9De3Lvqut
         Ka8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zFH3G7LsSXeaC13FetE3TNq4DuchE1MnbnYjQT4HA7E=;
        b=e3ARPE52vNCb/u7Itz21vA9EaFs/5Tol1jpXtKDyfnp7cKWHXB1ufTTWi88+NifHVa
         8wdY7Pz7UV8ueusabSuVhH2Tu01yJv/n2PkICB3vXSvdeR2GtNyqUr4DUZ3qwbWjbyd7
         Pdmz4s/JuDB53ump0GLWjHEOB6muETDy5bw9gfFXRNLbxPc0Z+6aEHCJ6T16q3A8Sxll
         Xrx1kmx37Fv4UyZCmgkkNY7pIh+BOoedQWQZVTCtyFoja5rN+hnnBHnIjSAOYbhojvEv
         rfAo6zXPq+0VG+H8jPV6tu4f1ryGQ9ZaxI1oUcrRaedmBikVr2cupni1bAsR1gl0nlIw
         peoQ==
X-Gm-Message-State: ACrzQf21tPzytsTLZdineo0m5tF5AQPT3jsgJBicj4gY2fzsStOMvJVT
        K0orfKhlGHaPtqTmtHVAKFaR1N6A6blRnA==
X-Google-Smtp-Source: AMsMyM6RwHZLehJEkuJ61NRKoZExZ/UgCPFJQWPEc13LGeZe5IQO9Qx608bTkYBQ5qM62oVF5lnac77yPAhVXA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:6e54:0:b0:6c2:645e:6d7b with SMTP id
 j81-20020a256e54000000b006c2645e6d7bmr8838555ybc.124.1666222861707; Wed, 19
 Oct 2022 16:41:01 -0700 (PDT)
Date:   Wed, 19 Oct 2022 16:40:50 -0700
In-Reply-To: <20221019234050.3919566-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221019234050.3919566-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221019234050.3919566-3-dmatlack@google.com>
Subject: [PATCH v2 2/2] KVM: x86/mmu: Split huge pages mapped by the TDP MMU
 on fault
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the TDP MMU has a mechanism to split huge pages, use it in the
fault path when a huge page needs to be replaced with a mapping at a
lower level.

This change reduces the negative performance impact of NX HugePages.
Prior to this change if a vCPU executed from a huge page and NX
HugePages was enabled, the vCPU would take a fault, zap the huge page,
and mapping the faulting address at 4KiB with execute permissions
enabled. The rest of the memory would be left *unmapped* and have to be
faulted back in by the guest upon access (read, write, or execute). If
guest is backed by 1GiB, a single execute instruction can zap an entire
GiB of its physical address space.

For example, it can take a VM longer to execute from its memory than to
populate that memory in the first place:

$ ./execute_perf_test -s anonymous_hugetlb_1gb -v96

Populating memory             : 2.748378795s
Executing from memory         : 2.899670885s

With this change, such faults split the huge page instead of zapping it,
which avoids the non-present faults on the rest of the huge page:

$ ./execute_perf_test -s anonymous_hugetlb_1gb -v96

Populating memory             : 2.729544474s
Executing from memory         : 0.111965688s   <---

This change also reduces the performance impact of dirty logging when
eager_page_split=N. eager_page_split=N (abbreviated "eps=N" below) can
be desirable for read-heavy workloads, as it avoids allocating memory to
split huge pages that are never written and avoids increasing the TLB
miss cost on reads of those pages.

             | Config: ept=Y, tdp_mmu=Y, 5% writes           |
             | Iteration 1 dirty memory time                 |
             | --------------------------------------------- |
vCPU Count   | eps=N (Before) | eps=N (After) | eps=Y        |
------------ | -------------- | ------------- | ------------ |
2            | 0.332305091s   | 0.019615027s  | 0.006108211s |
4            | 0.353096020s   | 0.019452131s  | 0.006214670s |
8            | 0.453938562s   | 0.019748246s  | 0.006610997s |
16           | 0.719095024s   | 0.019972171s  | 0.007757889s |
32           | 1.698727124s   | 0.021361615s  | 0.012274432s |
64           | 2.630673582s   | 0.031122014s  | 0.016994683s |
96           | 3.016535213s   | 0.062608739s  | 0.044760838s |

Eager page splitting remains beneficial for write-heavy workloads, but
the gap is now reduced.

             | Config: ept=Y, tdp_mmu=Y, 100% writes         |
             | Iteration 1 dirty memory time                 |
             | --------------------------------------------- |
vCPU Count   | eps=N (Before) | eps=N (After) | eps=Y        |
------------ | -------------- | ------------- | ------------ |
2            | 0.317710329s   | 0.296204596s  | 0.058689782s |
4            | 0.337102375s   | 0.299841017s  | 0.060343076s |
8            | 0.386025681s   | 0.297274460s  | 0.060399702s |
16           | 0.791462524s   | 0.298942578s  | 0.062508699s |
32           | 1.719646014s   | 0.313101996s  | 0.075984855s |
64           | 2.527973150s   | 0.455779206s  | 0.079789363s |
96           | 2.681123208s   | 0.673778787s  | 0.165386739s |

Further study is needed to determine if the remaining gap is acceptable
for customer workloads or if eager_page_split=N still requires a-priori
knowledge of the VM workload, especially when considering these costs
extrapolated out to large VMs with e.g. 416 vCPUs and 12TB RAM.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 72 ++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4e5b3ae824c1..c53767104d5b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1146,6 +1146,9 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	return 0;
 }
 
+static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
+				   struct kvm_mmu_page *sp, bool shared);
+
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -1171,49 +1174,42 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (iter.level == fault->goal_level)
 			break;
 
-		/*
-		 * If there is an SPTE mapping a large page at a higher level
-		 * than the target, that SPTE must be cleared and replaced
-		 * with a non-leaf SPTE.
-		 */
+		/* Step down into the lower level page table if it exists. */
 		if (is_shadow_present_pte(iter.old_spte) &&
-		    is_large_pte(iter.old_spte)) {
-			if (tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
-				break;
+		    !is_large_pte(iter.old_spte))
+			continue;
 
-			/*
-			 * The iter must explicitly re-read the spte here
-			 * because the new value informs the !present
-			 * path below.
-			 */
-			iter.old_spte = kvm_tdp_mmu_read_spte(iter.sptep);
-		}
+		/*
+		 * If SPTE has been frozen by another thread, just give up and
+		 * retry, avoiding unnecessary page table allocation and free.
+		 */
+		if (is_removed_spte(iter.old_spte))
+			break;
 
-		if (!is_shadow_present_pte(iter.old_spte)) {
-			/*
-			 * If SPTE has been frozen by another thread, just
-			 * give up and retry, avoiding unnecessary page table
-			 * allocation and free.
-			 */
-			if (is_removed_spte(iter.old_spte))
-				break;
+		/*
+		 * The SPTE is either non-present or points to a huge page that
+		 * needs to be split.
+		 */
+		sp = tdp_mmu_alloc_sp(vcpu);
+		tdp_mmu_init_child_sp(sp, &iter);
 
-			sp = tdp_mmu_alloc_sp(vcpu);
-			tdp_mmu_init_child_sp(sp, &iter);
+		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
-			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
+		if (is_shadow_present_pte(iter.old_spte))
+			ret = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
+		else
+			ret = tdp_mmu_link_sp(kvm, &iter, sp, true);
 
-			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
-				tdp_mmu_free_sp(sp);
-				break;
-			}
+		if (ret) {
+			tdp_mmu_free_sp(sp);
+			break;
+		}
 
-			if (fault->huge_page_disallowed &&
-			    fault->req_level >= iter.level) {
-				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-				track_possible_nx_huge_page(kvm, sp);
-				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
-			}
+		if (fault->huge_page_disallowed &&
+		    fault->req_level >= iter.level) {
+			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
+			track_possible_nx_huge_page(kvm, sp);
+			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 		}
 	}
 
@@ -1484,8 +1480,6 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	const int level = iter->level;
 	int ret, i;
 
-	tdp_mmu_init_child_sp(sp, iter);
-
 	/*
 	 * No need for atomics when writing to sp->spt since the page table has
 	 * not been linked in yet and thus is not reachable from any other CPU.
@@ -1561,6 +1555,8 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 				continue;
 		}
 
+		tdp_mmu_init_child_sp(sp, &iter);
+
 		if (tdp_mmu_split_huge_page(kvm, &iter, sp, shared))
 			goto retry;
 
-- 
2.38.0.413.g74048e4d9e-goog

