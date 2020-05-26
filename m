Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE25C1AB713
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 07:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405166AbgDPFDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 01:03:42 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59787 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404633AbgDPFDk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 01:03:40 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 492nDp3Rfhz9sSG; Thu, 16 Apr 2020 15:03:38 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1587013418; bh=ezMMwkByK2qZyRKxM4BFNkkLAWHC+jA69OSNgaQhgbc=;
        h=Date:From:To:Cc:Subject:From;
        b=CMjVIBuASwAcDOMMj7oJiM3jwgXLZge7hHE1uCcAlkF9v6v2mv20mbE8W5cKSaZV9
         ouc+wKbBOOZuAtIhol8gUN6iROYWWiNFtkAILfyEXCJclcYVJ26fyUQMeSz8/8bzjF
         HsrwEbMFAZTjuCI3urNFQTUaWIqBm0t9YZZTWP6LaN4/eAMrstp0pbEU7K9YhCjLez
         nnSAJRdiX5njMqBAvkSHmr/Df3u7eFKEjDwsb3T1AW41iVgiCn9STeyQCdDb1gXT03
         OxLpDiwb8mJPTxc6fMbZnmDuwaa96fKPA2DnLDq4uCINbQiIhP33idhnnwhaq+viwD
         y7KRNUKE4cFXQ==
Date:   Thu, 16 Apr 2020 15:03:35 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        groug@kaod.org, clg@kaod.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] KVM: PPC: Book3S HV: Handle non-present PTEs in page fault
 functions
Message-ID: <20200416050335.GB10545@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since cd758a9b57ee "KVM: PPC: Book3S HV: Use __gfn_to_pfn_memslot in HPT
page fault handler", it's been possible in fairly rare circumstances to
load a non-present PTE in kvmppc_book3s_hv_page_fault() when running a
guest on a POWER8 host.

Because that case wasn't checked for, we could misinterpret the non-present
PTE as being a cache-inhibited PTE.  That could mismatch with the
corresponding hash PTE, which would cause the function to fail with -EFAULT
a little further down.  That would propagate up to the KVM_RUN ioctl()
generally causing the KVM userspace (usually qemu) to fall over.

This addresses the problem by catching that case and returning to the guest
instead, letting it fault again, and retrying the whole page fault from
the beginning.

For completeness, this fixes the radix page fault handler in the same
way.  For radix this didn't cause any obvious misbehaviour, because we
ended up putting the non-present PTE into the guest's partition-scoped
page tables, leading immediately to another hypervisor data/instruction
storage interrupt, which would go through the page fault path again
and fix things up.

Fixes: cd758a9b57ee "KVM: PPC: Book3S HV: Use __gfn_to_pfn_memslot in HPT page fault handler"
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1820402
Reported-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
This is a reworked version of the patch David Gibson sent recently,
with the fix applied to the radix case as well. The commit message
is mostly stolen from David's patch.

 arch/powerpc/kvm/book3s_64_mmu_hv.c    | 9 +++++----
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 3aecec8..20b7dce 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -604,18 +604,19 @@ int kvmppc_book3s_hv_page_fault(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	 */
 	local_irq_disable();
 	ptep = __find_linux_pte(vcpu->arch.pgdir, hva, NULL, &shift);
+	pte = __pte(0);
+	if (ptep)
+		pte = *ptep;
+	local_irq_enable();
 	/*
 	 * If the PTE disappeared temporarily due to a THP
 	 * collapse, just return and let the guest try again.
 	 */
-	if (!ptep) {
-		local_irq_enable();
+	if (!pte_present(pte)) {
 		if (page)
 			put_page(page);
 		return RESUME_GUEST;
 	}
-	pte = *ptep;
-	local_irq_enable();
 	hpa = pte_pfn(pte) << PAGE_SHIFT;
 	pte_size = PAGE_SIZE;
 	if (shift)
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 134fbc1..7bf94ba 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -815,18 +815,19 @@ int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 	 */
 	local_irq_disable();
 	ptep = __find_linux_pte(vcpu->arch.pgdir, hva, NULL, &shift);
+	pte = __pte(0);
+	if (ptep)
+		pte = *ptep;
+	local_irq_enable();
 	/*
 	 * If the PTE disappeared temporarily due to a THP
 	 * collapse, just return and let the guest try again.
 	 */
-	if (!ptep) {
-		local_irq_enable();
+	if (!pte_present(pte)) {
 		if (page)
 			put_page(page);
 		return RESUME_GUEST;
 	}
-	pte = *ptep;
-	local_irq_enable();
 
 	/* If we're logging dirty pages, always map single pages */
 	large_enable = !(memslot->flags & KVM_MEM_LOG_DIRTY_PAGES);
-- 
2.7.4

