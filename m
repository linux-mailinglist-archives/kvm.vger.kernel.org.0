Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7865F4059E0
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 17:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbhIIPBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 11:01:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238518AbhIIPBY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 11:01:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631199614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CXYx4PBPhyr//nnxVyWDEhFGhefMQs4G8dUTWMufJQI=;
        b=NQmDzNzSFHlOKRM6Hv7gH7nywlc+uj1MeaKauWbSpR2Bl2h4mIkBNngTwMSs+Z4kBorAcQ
        Sk8GEAR7UYsgjNJvzLF+jGOVKZL8FTLkqfHIcfUWs8edOqVvOoH3K+VdtnPZzxLadctpEq
        paC7EZI/PY3rTH17+6S6nuDsh/idT3Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-N7Vm1IKvNp6OEXRXPHJQeQ-1; Thu, 09 Sep 2021 11:00:13 -0400
X-MC-Unique: N7Vm1IKvNp6OEXRXPHJQeQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 622388145E5;
        Thu,  9 Sep 2021 15:00:12 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5580C6F7EF;
        Thu,  9 Sep 2021 15:00:00 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, David Hildenbrand <david@redhat.com>
Subject: [PATCH RFC 4/9] s390/mm: fix VMA and page table handling code in storage key handling functions
Date:   Thu,  9 Sep 2021 16:59:40 +0200
Message-Id: <20210909145945.12192-5-david@redhat.com>
In-Reply-To: <20210909145945.12192-1-david@redhat.com>
References: <20210909145945.12192-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are multiple things broken about our storage key handling
functions:

1. We should not walk/touch page tables outside of VMA boundaries when
   holding only the mmap sem in read mode. Evil user space can modify the
   VMA layout just before this function runs and e.g., trigger races with
   page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
   with read mmap_sem in munmap"). gfn_to_hva() will only translate using
   KVM memory regions, but won't validate the VMA.

2. We should not allocate page tables outside of VMA boundaries: if
   evil user space decides to map hugetlbfs to these ranges, bad things
   will happen because we suddenly have PTE or PMD page tables where we
   shouldn't have them.

3. We don't handle large PUDs that might suddenly appeared inside our page
   table hierarchy.

Don't manually allocate page tables, properly validate that we have VMA and
bail out on pud_large().

All callers of page table handling functions, except
get_guest_storage_key(), call fixup_user_fault() in case they
receive an -EFAULT and retry; this will allocate the necessary page tables
if required.

To keep get_guest_storage_key() working as expected and not requiring
kvm_s390_get_skeys() to call fixup_user_fault() distinguish between
"there is simply no page table or huge page yet and the key is assumed
to be 0" and "this is a fault to be reported".

Although commit 637ff9efe5ea ("s390/mm: Add huge pmd storage key handling")
introduced most of the affected code, it was actually already broken
before when using get_locked_pte() without any VMA checks.

Note: Ever since commit 637ff9efe5ea ("s390/mm: Add huge pmd storage key
handling") we can no longer set a guest storage key (for example from
QEMU during VM live migration) without actually resolving a fault.
Although we would have created most page tables, we would choke on the
!pmd_present(), requiring a call to fixup_user_fault(). I would
have thought that this is problematic in combination with postcopy life
migration ... but nobody noticed and this patch doesn't change the
situation. So maybe it's just fine.

Fixes: 9fcf93b5de06 ("KVM: S390: Create helper function get_guest_storage_key")
Fixes: 24d5dd0208ed ("s390/kvm: Provide function for setting the guest storage key")
Fixes: a7e19ab55ffd ("KVM: s390: handle missing storage-key facility")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/mm/pgtable.c | 57 +++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 18 deletions(-)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 54969e0f3a94..5fb409ff7842 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -429,22 +429,36 @@ static inline pmd_t pmdp_flush_lazy(struct mm_struct *mm,
 }
 
 #ifdef CONFIG_PGSTE
-static pmd_t *pmd_alloc_map(struct mm_struct *mm, unsigned long addr)
+static int pmd_lookup(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
 {
+	struct vm_area_struct *vma;
 	pgd_t *pgd;
 	p4d_t *p4d;
 	pud_t *pud;
-	pmd_t *pmd;
+
+	/* We need a valid VMA, otherwise this is clearly a fault. */
+	vma = vma_lookup(mm, addr);
+	if (!vma)
+		return -EFAULT;
 
 	pgd = pgd_offset(mm, addr);
-	p4d = p4d_alloc(mm, pgd, addr);
-	if (!p4d)
-		return NULL;
-	pud = pud_alloc(mm, p4d, addr);
-	if (!pud)
-		return NULL;
-	pmd = pmd_alloc(mm, pud, addr);
-	return pmd;
+	if (!pgd_present(*pgd))
+		return -ENOENT;
+
+	p4d = p4d_offset(pgd, addr);
+	if (!p4d_present(*p4d))
+		return -ENOENT;
+
+	pud = pud_offset(p4d, addr);
+	if (!pud_present(*pud))
+		return -ENOENT;
+
+	/* Large PUDs are not supported yet. */
+	if (pud_large(*pud))
+		return -EFAULT;
+
+	*pmdp = pmd_offset(pud, addr);
+	return 0;
 }
 #endif
 
@@ -778,8 +792,7 @@ int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 	pmd_t *pmdp;
 	pte_t *ptep;
 
-	pmdp = pmd_alloc_map(mm, addr);
-	if (unlikely(!pmdp))
+	if (pmd_lookup(mm, addr, &pmdp))
 		return -EFAULT;
 
 	ptl = pmd_lock(mm, pmdp);
@@ -881,8 +894,7 @@ int reset_guest_reference_bit(struct mm_struct *mm, unsigned long addr)
 	pte_t *ptep;
 	int cc = 0;
 
-	pmdp = pmd_alloc_map(mm, addr);
-	if (unlikely(!pmdp))
+	if (pmd_lookup(mm, addr, &pmdp))
 		return -EFAULT;
 
 	ptl = pmd_lock(mm, pmdp);
@@ -935,15 +947,24 @@ int get_guest_storage_key(struct mm_struct *mm, unsigned long addr,
 	pmd_t *pmdp;
 	pte_t *ptep;
 
-	pmdp = pmd_alloc_map(mm, addr);
-	if (unlikely(!pmdp))
+	/*
+	 * If we don't have a PTE table and if there is no huge page mapped,
+	 * the storage key is 0.
+	 */
+	*key = 0;
+
+	switch (pmd_lookup(mm, addr, &pmdp)) {
+	case -ENOENT:
+		return 0;
+	case 0:
+		break;
+	default:
 		return -EFAULT;
+	}
 
 	ptl = pmd_lock(mm, pmdp);
 	if (!pmd_present(*pmdp)) {
-		/* Not yet mapped memory has a zero key */
 		spin_unlock(ptl);
-		*key = 0;
 		return 0;
 	}
 
-- 
2.31.1

