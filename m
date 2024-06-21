Return-Path: <kvm+bounces-20286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA2AA91279D
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 16:26:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE9521C25E7B
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 878BF3AC1F;
	Fri, 21 Jun 2024 14:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h3U1zP0m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9244383A5
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 14:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718979920; cv=none; b=B0uifWixQ/3cw0KsDAWAOEYNbcQqLM+gwWkfBK6DiGPdZTCQnbwc781A1yET74U10F5A+/Nki1SyrQobFP25nnXfujrlw+2Zrbz6ADNA6HClEcIas091Fpu5rsYxGWv0a4w7pGOEREaOTtPicgRZTwDyPQH0bVfAryQo6UaHh4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718979920; c=relaxed/simple;
	bh=ARxQXTuoo2oZGe8F14hSzMvMkV1cj+qV2fEARS445Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2n+hecQbDlxxYhh9HJoUHu6CCZ19p3UA0UvINNd9xro3qgCfgDDe0203qtvIBsrvIx3CKwB0HEq9PmhYexUrXJl8QnIG12rYmhsLyZCXAfV3helQINbX0vTTDLAIElZJPkeZ+AfvBF7tla+BW86GydcI8K30X2+aWncx6deK8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h3U1zP0m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718979915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VpPwnVRxGccST937wjacfAT3ndiJzOREHKlh4Jm8zSE=;
	b=h3U1zP0mfZdpLhQAidigZKkt6UPyqw+cVSXb3Q15r/aEAB98XZlv9rTZz2UcnmCi2KZqIf
	Er0wo/Q9OzzC5QkRIhaj/Qen9w7PgjJhXpEJFw8PLMGDJQLFKqrwj4NmhBOa0NXoEbaP7R
	mHj02PCJmFsrY6tqi2brynpLf32sTaQ=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-LY4Mko7jMlKDLIBFLikqsw-1; Fri, 21 Jun 2024 10:25:14 -0400
X-MC-Unique: LY4Mko7jMlKDLIBFLikqsw-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-5bd28928c4bso241793eaf.3
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 07:25:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718979913; x=1719584713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VpPwnVRxGccST937wjacfAT3ndiJzOREHKlh4Jm8zSE=;
        b=MWD/UmVb+hKOjKx/bzkb/yiDA+ksiAoJmMDkDNqEL2Rhd0PHEY0YfO1Mr8V2DPIfXs
         0rnkVgmeiLslCxSwVwRvYhj87U8f+ezSLJD8SAS0gfvQcjsn5dMGvdter1IYYdZe3Px+
         ZdiI/x8xtJcJxn0CiRcNywmUqKAkvMhvzvUqTnW5aemQWh3F1mat5dfrtsw5soxWN0MA
         YUd63hnopTqBC/dI3q6nKUD1AF5pvmSImIiLVNNMx+7qo5bt0gUq+CO3r/A5SeO7XaHh
         cR+1sJw/ITMqSwwXf0HEbfrbSsaiAStl1r1neBT2+5Pl5YRDJ6WFAYlV+Bv5e6eI/BMV
         rQLg==
X-Forwarded-Encrypted: i=1; AJvYcCWeNkiCV+ToRcD0Mu5RZu4sr/aHY6V961zqNYwXQIx6ss4HftEETGarC4cOtVZe4Q9UOSEhMICP4t6a1K+XuLFsBFFc
X-Gm-Message-State: AOJu0Yyd3nqEseYwm0ntkPNcjn63pKo0hStzLmTcUaITBr6FMwO3LS+Q
	8Xv6FqQQYjwrCzYL5RiiobUr1lG0l/sJe+u+DFvW8Y8nGRANCmKiBZS7rqlYOwRGc/hN1LWZaCV
	xHIZCU4jcHFL5N0On+s+pG5HxVtauMzho24ES/DfSEaMOkqpLTg==
X-Received: by 2002:a4a:c60f:0:b0:5bd:af39:c9d9 with SMTP id 006d021491bc7-5c1ad9093ebmr9601676eaf.0.1718979913416;
        Fri, 21 Jun 2024 07:25:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFna6HwoEVcDVzacrmJp70i2Ye9mZl03svl3PALStAHNV8VRqUBmNMnAivUzvRTiL6Q97gHJQ==
X-Received: by 2002:a4a:c60f:0:b0:5bd:af39:c9d9 with SMTP id 006d021491bc7-5c1ad9093ebmr9601627eaf.0.1718979912731;
        Fri, 21 Jun 2024 07:25:12 -0700 (PDT)
Received: from x1n.redhat.com (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79bce944cb2sm90564785a.125.2024.06.21.07.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 07:25:12 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Dave Jiang <dave.jiang@intel.com>,
	"Kirill A . Shutemov" <kirill@shutemov.name>,
	Ingo Molnar <mingo@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	peterx@redhat.com,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linuxppc-dev@lists.ozlabs.org,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Rik van Riel <riel@surriel.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Huang Ying <ying.huang@intel.com>,
	kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Rientjes <rientjes@google.com>
Subject: [PATCH 3/7] mm/mprotect: Push mmu notifier to PUDs
Date: Fri, 21 Jun 2024 10:25:00 -0400
Message-ID: <20240621142504.1940209-4-peterx@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240621142504.1940209-1-peterx@redhat.com>
References: <20240621142504.1940209-1-peterx@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mprotect() does mmu notifiers in PMD levels.  It's there since 2014 of
commit a5338093bfb4 ("mm: move mmu notifier call from change_protection to
change_pmd_range").

At that time, the issue was that NUMA balancing can be applied on a huge
range of VM memory, even if nothing was populated.  The notification can be
avoided in this case if no valid pmd detected, which includes either THP or
a PTE pgtable page.

Now to pave way for PUD handling, this isn't enough.  We need to generate
mmu notifications even on PUD entries properly.  mprotect() is currently
broken on PUD (e.g., one can easily trigger kernel error with dax 1G
mappings already), this is the start to fix it.

To fix that, this patch proposes to push such notifications to the PUD
layers.

There is risk on regressing the problem Rik wanted to resolve before, but I
think it shouldn't really happen, and I still chose this solution because
of a few reasons:

  1) Consider a large VM that should definitely contain more than GBs of
  memory, it's highly likely that PUDs are also none.  In this case there
  will have no regression.

  2) KVM has evolved a lot over the years to get rid of rmap walks, which
  might be the major cause of the previous soft-lockup.  At least TDP MMU
  already got rid of rmap as long as not nested (which should be the major
  use case, IIUC), then the TDP MMU pgtable walker will simply see empty VM
  pgtable (e.g. EPT on x86), the invalidation of a full empty region in
  most cases could be pretty fast now, comparing to 2014.

  3) KVM has explicit code paths now to even give way for mmu notifiers
  just like this one, e.g. in commit d02c357e5bfa ("KVM: x86/mmu: Retry
  fault before acquiring mmu_lock if mapping is changing").  It'll also
  avoid contentions that may also contribute to a soft-lockup.

  4) Stick with PMD layer simply don't work when PUD is there...  We need
  one way or another to fix PUD mappings on mprotect().

Pushing it to PUD should be the safest approach as of now, e.g. there's yet
no sign of huge P4D coming on any known archs.

Cc: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/mprotect.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 21172272695e..fb8bf3ff7cd9 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -363,9 +363,6 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 	pmd_t *pmd;
 	unsigned long next;
 	long pages = 0;
-	struct mmu_notifier_range range;
-
-	range.start = 0;
 
 	pmd = pmd_offset(pud, addr);
 	do {
@@ -383,14 +380,6 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 		if (pmd_none(*pmd))
 			goto next;
 
-		/* invoke the mmu notifier if the pmd is populated */
-		if (!range.start) {
-			mmu_notifier_range_init(&range,
-				MMU_NOTIFY_PROTECTION_VMA, 0,
-				vma->vm_mm, addr, end);
-			mmu_notifier_invalidate_range_start(&range);
-		}
-
 		_pmd = pmdp_get_lockless(pmd);
 		if (is_swap_pmd(_pmd) || pmd_trans_huge(_pmd) || pmd_devmap(_pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
@@ -428,9 +417,6 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 		cond_resched();
 	} while (pmd++, addr = next, addr != end);
 
-	if (range.start)
-		mmu_notifier_invalidate_range_end(&range);
-
 	return pages;
 }
 
@@ -438,10 +424,13 @@ static inline long change_pud_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
 {
+	struct mmu_notifier_range range;
 	pud_t *pud;
 	unsigned long next;
 	long pages = 0, ret;
 
+	range.start = 0;
+
 	pud = pud_offset(p4d, addr);
 	do {
 		next = pud_addr_end(addr, end);
@@ -450,10 +439,19 @@ static inline long change_pud_range(struct mmu_gather *tlb,
 			return ret;
 		if (pud_none_or_clear_bad(pud))
 			continue;
+		if (!range.start) {
+			mmu_notifier_range_init(&range,
+						MMU_NOTIFY_PROTECTION_VMA, 0,
+						vma->vm_mm, addr, end);
+			mmu_notifier_invalidate_range_start(&range);
+		}
 		pages += change_pmd_range(tlb, vma, pud, addr, next, newprot,
 					  cp_flags);
 	} while (pud++, addr = next, addr != end);
 
+	if (range.start)
+		mmu_notifier_invalidate_range_end(&range);
+
 	return pages;
 }
 
-- 
2.45.0


