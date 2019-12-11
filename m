Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 893CC11BF40
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 22:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfLKVcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 16:32:25 -0500
Received: from mail-qk1-f202.google.com ([209.85.222.202]:39507 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfLKVcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 16:32:25 -0500
Received: by mail-qk1-f202.google.com with SMTP id g28so45346qkl.6
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 13:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sDaCcLT3BcQJ23kfy/HaXZtjLV54Z/X5vMBQ4m0F9ws=;
        b=EsxnNiRNv8If11+vloXSQ7nwWN1lItAewnF+sLDaSlmolmYksUpNvpwBYaM7L41HUd
         uWxT5Uu6Hic1c/J1Y90egmD8MQQddHSFtNUFiZ5CgltHtE64rJa9kd7xChSG2D/6uEYH
         tso9FlUjwcWCykQdNsAPbyh3GEyMbxk8q6nPIK6Itca/A4kuMsDUiiPT4l8tKvAc7+4P
         TfcrFl85CPUmcmMtw5eYhoZX333AYEy6qoWY13yAKMWwOQP/bqViTLN5LEzAoWkVYn4+
         9YSHcl3zD7aKQyQ02OdDsUczHpKePD6qPvej9G3oRirDEbrbz7oIgSvbjWHtU4syo/ie
         grnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sDaCcLT3BcQJ23kfy/HaXZtjLV54Z/X5vMBQ4m0F9ws=;
        b=E+uMiPa/rj05aKB9RygGePA0ZcLnZVXk8SfJeWkdj9PJjzeHi7TwTdSk8Iccj6yTiB
         l8ZtfI7eQWIMdWbXzDlfqi4bJFdIhGebPWX/qgKQK2V8rklk7c6Z2R6FjcLVpthzRtDY
         YmeH31lJaIO9D8nE8V+JRl6G4X48ehUNL9aGh5XwOsLYS+TUzRBzlrfX3XThBnc/oe6L
         b/GNFYVtw0PsujPSamSBxrBKktEKlORxH4Gcls7TIfODEDcekdeCZ3YANR+38BvczEjt
         AjQ0hWa0l33jgI/vYsy8UtyYSHHnMn6Sod9FdILnG4cBYJHBhOhHcbp3zbQPfmKbPhJj
         kpoQ==
X-Gm-Message-State: APjAAAXK1WbIiLVTqrPCGWe+vW4j6ZIq2geYYy8Dk8cixGs1E2IAuNDA
        qmsGrpDrv4Ryv7At6JhqCGp8rCQa
X-Google-Smtp-Source: APXvYqymtB08I22rTfCyFtgWxWJ8AqN73LVOvZo61CMncBXCwtep0KelAX9VW18l1EiAV26YFXB+Df9C
X-Received: by 2002:a05:6214:209:: with SMTP id i9mr5144868qvt.54.1576099944237;
 Wed, 11 Dec 2019 13:32:24 -0800 (PST)
Date:   Wed, 11 Dec 2019 16:32:06 -0500
In-Reply-To: <20191211213207.215936-1-brho@google.com>
Message-Id: <20191211213207.215936-2-brho@google.com>
Mime-Version: 1.0
References: <20191211213207.215936-1-brho@google.com>
X-Mailer: git-send-email 2.24.0.525.g8f36a354ae-goog
Subject: [PATCH v4 1/2] mm: make dev_pagemap_mapping_shift() externally visible
From:   Barret Rhoden <brho@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM has a use case for determining the size of a dax mapping.  The KVM
code has easy access to the address and the mm; hence the change in
parameters.

Signed-off-by: Barret Rhoden <brho@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/mm.h  |  3 +++
 mm/memory-failure.c | 38 +++-----------------------------------
 mm/util.c           | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8b0ef04b6d15..f88bcc6a3bd1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -998,6 +998,9 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
 #define page_ref_zero_or_close_to_overflow(page) \
 	((unsigned int) page_ref_count(page) + 127u <= 127u)
 
+unsigned long dev_pagemap_mapping_shift(unsigned long address,
+					struct mm_struct *mm);
+
 static inline void get_page(struct page *page)
 {
 	page = compound_head(page);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 41c634f45d45..9dc487e73d9b 100644
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
@@ -318,7 +284,9 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
 
 	tk->addr = page_address_in_vma(p, vma);
 	if (is_zone_device_page(p))
-		tk->size_shift = dev_pagemap_mapping_shift(p, vma);
+		tk->size_shift =
+			dev_pagemap_mapping_shift(vma_address(page, vma),
+						  vma->vm_mm);
 	else
 		tk->size_shift = page_shift(compound_head(p));
 
diff --git a/mm/util.c b/mm/util.c
index 988d11e6c17c..553fbe1692ed 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -911,3 +911,37 @@ int memcmp_pages(struct page *page1, struct page *page2)
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

