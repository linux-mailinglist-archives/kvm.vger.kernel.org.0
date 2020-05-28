Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BC71E5366
	for <lists+kvm@lfdr.de>; Thu, 28 May 2020 03:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgE1ByT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 21:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgE1ByT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 May 2020 21:54:19 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C515BC05BD1E;
        Wed, 27 May 2020 18:54:18 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 49XW2v42BNz9sSJ; Thu, 28 May 2020 11:54:15 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1590630855; bh=DOgMK8VCRcBCDfvcSWAbMi3HJx7pIBfkzj01lRn5oNE=;
        h=Date:From:To:Cc:Subject:From;
        b=tP6o7VvBFMax6KXJ1rUfHjl6HurJZN1gR+n7JqVp4o4IyFqVExhStTIVeE66LG+Py
         sxoDluYp/GK6/uX+qdb4XIuZK9TMKAYnROd0emEg9QW42u9B/s/iA4jYSDm3HiQH7s
         APNVTuO7HIoqlIkGQ/MLEFygB+u83Ah/ZWyrYmYfd6RMJJBfzoG8ah83VCrYNrHpAl
         XwRfzI/4/inzobX2+4E3jm44MiVBbnX1EGOMrxYNuhNqQxSVEth9K7ZJto9gHHfzJj
         dOO7GgwP5jPO1kCrpIix43usTpim6omC4DGJi7qZ0j17W5Z0z+RKJbf+WWRCzTGtG0
         nGAJjYci8QjmQ==
Date:   Thu, 28 May 2020 11:53:31 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Nick Piggin <npiggin@au1.ibm.com>
Subject: [PATCH 1/2] KVM: PPC: Book3S HV: Remove user-triggerable WARN_ON
Message-ID: <20200528015331.GD307798@thinks.paulus.ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although in general we do not expect valid PTEs to be found in
kvmppc_create_pte when we are inserting a large page mapping, there
is one situation where this can occur.  That is when dirty page
logging is turned off for a memslot while the VM is running.
Because the new memslots are installed before the old memslot is
flushed in kvmppc_core_commit_memory_region_hv(), there is a
window where a hypervisor page fault can try to install a 2MB
(or 1GB) page where there are already small page mappings which
were installed while dirty page logging was enabled and which
have not yet been flushed.

Since we have a situation where valid PTEs can legitimately be
found by kvmppc_unmap_free_pte, and which can be triggered by
userspace, just remove the WARN_ON_ONCE, since it is undesirable
to have userspace able to trigger a kernel warning.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 97b45ea..bc3f795 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -429,9 +429,13 @@ void kvmppc_unmap_pte(struct kvm *kvm, pte_t *pte, unsigned long gpa,
  * Callers are responsible for flushing the PWC.
  *
  * When page tables are being unmapped/freed as part of page fault path
- * (full == false), ptes are not expected. There is code to unmap them
- * and emit a warning if encountered, but there may already be data
- * corruption due to the unexpected mappings.
+ * (full == false), valid ptes are generally not expected; however, there
+ * is one situation where they arise, which is when dirty page logging is
+ * turned off for a memslot while the VM is running.  The new memslot
+ * becomes visible to page faults before the memslot commit function
+ * gets to flush the memslot, which can lead to a 2MB page mapping being
+ * installed for a guest physical address where there are already 64kB
+ * (or 4kB) mappings (of sub-pages of the same 2MB page).
  */
 static void kvmppc_unmap_free_pte(struct kvm *kvm, pte_t *pte, bool full,
 				  unsigned int lpid)
@@ -445,7 +449,6 @@ static void kvmppc_unmap_free_pte(struct kvm *kvm, pte_t *pte, bool full,
 		for (it = 0; it < PTRS_PER_PTE; ++it, ++p) {
 			if (pte_val(*p) == 0)
 				continue;
-			WARN_ON_ONCE(1);
 			kvmppc_unmap_pte(kvm, p,
 					 pte_pfn(*p) << PAGE_SHIFT,
 					 PAGE_SHIFT, NULL, lpid);
-- 
2.7.4

