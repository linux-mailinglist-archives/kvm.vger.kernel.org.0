Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3493CC249
	for <lists+kvm@lfdr.de>; Sat, 17 Jul 2021 11:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhGQJ71 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Jul 2021 05:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232783AbhGQJ7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 17 Jul 2021 05:59:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74FA2613E7;
        Sat, 17 Jul 2021 09:56:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m4h3J-00DvkH-QE; Sat, 17 Jul 2021 10:56:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 3/5] KVM: Remove kvm_is_transparent_hugepage() and PageTransCompoundMap()
Date:   Sat, 17 Jul 2021 10:55:39 +0100
Message-Id: <20210717095541.1486210-4-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210717095541.1486210-1-maz@kernel.org>
References: <20210717095541.1486210-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org, seanjc@google.com, willy@infradead.org, pbonzini@redhat.com, will@kernel.org, qperret@google.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that arm64 has stopped using kvm_is_transparent_hugepage(),
we can remove it, as well as PageTransCompoundMap() which was
only used by the former.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 include/linux/page-flags.h | 37 -------------------------------------
 virt/kvm/kvm_main.c        | 10 ----------
 2 files changed, 47 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 5922031ffab6..1ace27c4a8e0 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -632,43 +632,6 @@ static inline int PageTransCompound(struct page *page)
 	return PageCompound(page);
 }
 
-/*
- * PageTransCompoundMap is the same as PageTransCompound, but it also
- * guarantees the primary MMU has the entire compound page mapped
- * through pmd_trans_huge, which in turn guarantees the secondary MMUs
- * can also map the entire compound page. This allows the secondary
- * MMUs to call get_user_pages() only once for each compound page and
- * to immediately map the entire compound page with a single secondary
- * MMU fault. If there will be a pmd split later, the secondary MMUs
- * will get an update through the MMU notifier invalidation through
- * split_huge_pmd().
- *
- * Unlike PageTransCompound, this is safe to be called only while
- * split_huge_pmd() cannot run from under us, like if protected by the
- * MMU notifier, otherwise it may result in page->_mapcount check false
- * positives.
- *
- * We have to treat page cache THP differently since every subpage of it
- * would get _mapcount inc'ed once it is PMD mapped.  But, it may be PTE
- * mapped in the current process so comparing subpage's _mapcount to
- * compound_mapcount to filter out PTE mapped case.
- */
-static inline int PageTransCompoundMap(struct page *page)
-{
-	struct page *head;
-
-	if (!PageTransCompound(page))
-		return 0;
-
-	if (PageAnon(page))
-		return atomic_read(&page->_mapcount) < 0;
-
-	head = compound_head(page);
-	/* File THP is PMD mapped and not PTE mapped */
-	return atomic_read(&page->_mapcount) ==
-	       atomic_read(compound_mapcount_ptr(head));
-}
-
 /*
  * PageTransTail returns true for both transparent huge pages
  * and hugetlbfs pages, so it should only be called when it's known
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7d95126cda9e..2e410a8a6a67 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -189,16 +189,6 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 	return true;
 }
 
-bool kvm_is_transparent_hugepage(kvm_pfn_t pfn)
-{
-	struct page *page = pfn_to_page(pfn);
-
-	if (!PageTransCompoundMap(page))
-		return false;
-
-	return is_transparent_hugepage(compound_head(page));
-}
-
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
  */
-- 
2.30.2

