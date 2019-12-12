Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9CDE11D53D
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 19:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbfLLSW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 13:22:58 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:55779 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730357AbfLLSW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 13:22:58 -0500
Received: by mail-pj1-f73.google.com with SMTP id e7so1569542pjt.22
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 10:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IvHeRx1oBCh9J6TLvVWdv2Gb1z0rpMzGcWyY+BXVgxo=;
        b=MAdkof8C2KW30AALfnNJO3vr9VoF0vmBXanMXL/vR51qGyvIZkGihOmBNe+C0or/8I
         NpO/KCC3oEKNcwp7NIyw7WnD6H+rCsDvTI30S8NWdXPxMl0MDaFljsm9JXiaxGx8tZCO
         d4KLSyqgiZeCGiJqkepl0hPb47CUKa9ToIY3jibKjBu4kZUmg7uhITO9RyP7k+b0KyoU
         zEcEs3lkMbzHsbNJ2xA4Mv3lS6SzC0mJbsHZ2qOxVL621b4e0Gt/qvA+mGVTzX9rJKB5
         /8rQMuMbnVTaGER/Xvhr4PwqP6nQELiDlJ6qv20w9iVMpmIsQeJffxIkfXKhEXwrX/ah
         Gvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IvHeRx1oBCh9J6TLvVWdv2Gb1z0rpMzGcWyY+BXVgxo=;
        b=CRlcwjzyuxnYTKBv8V5C5V/Dm50ScEglei+cW1LSsvvpDu4602Xuj9V+JiyEnMRMCT
         x74OQK20tsd0iEpMiIpZxkL4ki1V3ae71+COeXav9XzLKR49XwpdDHrVbzmy+C9YsrjL
         +rjGMEd7J5nU+mSmLIV2E3qH384Gt1E3V2uYI4bWoo32lwWk/wyvSB0/OHTbcgTkmfvr
         rpDfiXG/Aii4sUp4UGTrknCRH5vzmIOi1LpGMm1080Fjo6KHuEb3yaJdkBCTu+uKfhHe
         XWrbfEGpeGtM9VVNjQ37M++gq7YYEL/RmCVsBBjzyb91VayI99vLARRWu4vc68L3SMV8
         rvqw==
X-Gm-Message-State: APjAAAWluXfFFUI2C8d8d0imH+XlZ5IEzxjECwTds0aJ/Yzqudgvw35R
        v6cVWmDkcHkMq+IdPpBR7G4b6orY
X-Google-Smtp-Source: APXvYqwVXoFFdqVc4oFKrnkNNIY1YlbI3lRBL8mXjnVcsOoBTjQ2NnV0mup2jeDoJ+6bSYWUQLoZOkJ/
X-Received: by 2002:a63:a508:: with SMTP id n8mr11683668pgf.278.1576174977297;
 Thu, 12 Dec 2019 10:22:57 -0800 (PST)
Date:   Thu, 12 Dec 2019 13:22:37 -0500
In-Reply-To: <20191212182238.46535-1-brho@google.com>
Message-Id: <20191212182238.46535-2-brho@google.com>
Mime-Version: 1.0
References: <20191212182238.46535-1-brho@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v5 1/2] mm: make dev_pagemap_mapping_shift() externally visible
From:   Barret Rhoden <brho@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM has a use case for determining the size of a dax mapping.

The KVM code has easy access to the address and the mm, and
dev_pagemap_mapping_shift() needs only those parameters.  It was
deriving them from page and vma.  This commit changes those parameters
from (page, vma) to (address, mm).

Signed-off-by: Barret Rhoden <brho@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mm.h  |  3 +++
 mm/memory-failure.c | 38 +++-----------------------------------
 mm/util.c           | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a2adf95b3f9c..bfd1882dd5c6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1013,6 +1013,9 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
 #define page_ref_zero_or_close_to_overflow(page) \
 	((unsigned int) page_ref_count(page) + 127u <= 127u)
 
+unsigned long dev_pagemap_mapping_shift(unsigned long address,
+					struct mm_struct *mm);
+
 static inline void get_page(struct page *page)
 {
 	page = compound_head(page);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3151c87dff73..bafa464c8290 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -261,40 +261,6 @@ void shake_page(struct page *p, int access)
 }
 EXPORT_SYMBOL_GPL(shake_page);
 
-static unsigned long dev_pagemap_mapping_shift(struct page *page,
-		struct vm_area_struct *vma)
-{
-	unsigned long address = vma_address(page, vma);
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	pgd = pgd_offset(vma->vm_mm, address);
-	if (!pgd_present(*pgd))
-		return 0;
-	p4d = p4d_offset(pgd, address);
-	if (!p4d_present(*p4d))
-		return 0;
-	pud = pud_offset(p4d, address);
-	if (!pud_present(*pud))
-		return 0;
-	if (pud_devmap(*pud))
-		return PUD_SHIFT;
-	pmd = pmd_offset(pud, address);
-	if (!pmd_present(*pmd))
-		return 0;
-	if (pmd_devmap(*pmd))
-		return PMD_SHIFT;
-	pte = pte_offset_map(pmd, address);
-	if (!pte_present(*pte))
-		return 0;
-	if (pte_devmap(*pte))
-		return PAGE_SHIFT;
-	return 0;
-}
-
 /*
  * Failure handling: if we can't find or can't kill a process there's
  * not much we can do.	We just print a message and ignore otherwise.
@@ -324,7 +290,9 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
 	}
 	tk->addr = page_address_in_vma(p, vma);
 	if (is_zone_device_page(p))
-		tk->size_shift = dev_pagemap_mapping_shift(p, vma);
+		tk->size_shift =
+			dev_pagemap_mapping_shift(vma_address(page, vma),
+						  vma->vm_mm);
 	else
 		tk->size_shift = compound_order(compound_head(p)) + PAGE_SHIFT;
 
diff --git a/mm/util.c b/mm/util.c
index 3ad6db9a722e..59984e6b40ab 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -901,3 +901,37 @@ int memcmp_pages(struct page *page1, struct page *page2)
 	kunmap_atomic(addr1);
 	return ret;
 }
+
+unsigned long dev_pagemap_mapping_shift(unsigned long address,
+					struct mm_struct *mm)
+{
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		return 0;
+	p4d = p4d_offset(pgd, address);
+	if (!p4d_present(*p4d))
+		return 0;
+	pud = pud_offset(p4d, address);
+	if (!pud_present(*pud))
+		return 0;
+	if (pud_devmap(*pud))
+		return PUD_SHIFT;
+	pmd = pmd_offset(pud, address);
+	if (!pmd_present(*pmd))
+		return 0;
+	if (pmd_devmap(*pmd))
+		return PMD_SHIFT;
+	pte = pte_offset_map(pmd, address);
+	if (!pte_present(*pte))
+		return 0;
+	if (pte_devmap(*pte))
+		return PAGE_SHIFT;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dev_pagemap_mapping_shift);
-- 
2.24.0.525.g8f36a354ae-goog

