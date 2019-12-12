Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF6EC11D53E
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 19:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbfLLSXC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 13:23:02 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:43686 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730210AbfLLSXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 13:23:01 -0500
Received: by mail-pj1-f74.google.com with SMTP id b23so1581356pjz.10
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 10:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QJzS5cf1va+nrqwiPMy+1/CZ1shjgAqUeBFnOuHAc2s=;
        b=Ba0ZrxLur6jY5/yOkxJ3TztRuqj4f0wSiJ88PrOZrz6TKvyfeg1L/B0CGclVQMSKMS
         fKntKcN+MxF41ny/fjJJQzA/TxZnRfVwqE4Abw4zWB1eEXysAMU83K8rIwXbt5IfGWXL
         rTV7A36Z09p7odDbSD00a4mbTY0Lvu0IyNj4tT49mjw31Q5L9IhFdG8cXyX4r40FjVEo
         hjq3LR16hnJ3NKy94C2uwvo9okl0CTJT0ZPXdKG5OjVbxKPM8y7IX0CWAy14neVt1hO7
         4Os1UMSWnkdTVnbXe37U4lvvoG1ujSbhU8yfBrGa1meSA02y74bsiSjr7iBssE0ojlWA
         XmTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QJzS5cf1va+nrqwiPMy+1/CZ1shjgAqUeBFnOuHAc2s=;
        b=Z3dUoHwY35ohFoQ6bbxPx6sZZ6yPOna6lAKc8GmW3ZPd2uWx3UkeThRBHx4p6Tp8DP
         kd8CC3VH2qt+/HloW0TBaqc1pW5EANYS+br3v3Vo56qIMmkrSbgrt+tB13kGOv4WafuQ
         tytvOOVV7HT6Q51rT4uLSOQE6rsvnOTkTxHOyy6JHpGI4xXnJAw5izgmggghTAl+46mH
         2O4DryzwMbO67bPP/38kswas0bfAKTYeDDGudsWNH0FfbCvEdDQPfrH1uT5yPnR5+uHz
         7VLkH0/b6Aqw+n0dvjcyZWBdN8496CY6BukaXsComI5SJrQTaA5Zm5hr6namcy/8Wmm2
         0wZg==
X-Gm-Message-State: APjAAAVvuSzsPJKbHwLz1aVLvWiWMnWAP4CdQERVjMbjrujWATeJ8tAo
        V+QqfTRtz2qU3VbAZr7An/w1jQj8
X-Google-Smtp-Source: APXvYqx3OSYyAEpeU1hpMzeLCwi0nWCUbjiyweJI73Oot2AiHdC93XItct57lFn8p5M9ukNOGXwyBoTV
X-Received: by 2002:a65:5a4d:: with SMTP id z13mr11986210pgs.21.1576174981140;
 Thu, 12 Dec 2019 10:23:01 -0800 (PST)
Date:   Thu, 12 Dec 2019 13:22:38 -0500
In-Reply-To: <20191212182238.46535-1-brho@google.com>
Message-Id: <20191212182238.46535-3-brho@google.com>
Mime-Version: 1.0
References: <20191212182238.46535-1-brho@google.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v5 2/2] kvm: Use huge pages for DAX-backed files
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

This change allows KVM to map DAX-backed files made of huge pages with
huge mappings in the EPT/TDP.

DAX pages are not PageTransCompound.  The existing check is trying to
determine if the mapping for the pfn is a huge mapping or not.  For
non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.
For DAX, we can check the page table itself.

Note that KVM already faulted in the page (or huge page) in the host's
page table, and we hold the KVM mmu spinlock.  We grabbed that lock in
kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.

Signed-off-by: Barret Rhoden <brho@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7269130ea5e2..ea8f6951398b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3328,6 +3328,30 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
+static bool pfn_is_huge_mapped(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+	unsigned long hva;
+
+	if (!is_zone_device_page(page))
+		return PageTransCompoundMap(page);
+
+	/*
+	 * DAX pages do not use compound pages.  The page should have already
+	 * been mapped into the host-side page table during try_async_pf(), so
+	 * we can check the page tables directly.
+	 */
+	hva = gfn_to_hva(kvm, gfn);
+	if (kvm_is_error_hva(hva))
+		return false;
+
+	/*
+	 * Our caller grabbed the KVM mmu_lock with a successful
+	 * mmu_notifier_retry, so we're safe to walk the page table.
+	 */
+	return dev_pagemap_mapping_shift(hva, current->mm) > PAGE_SHIFT;
+}
+
 static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 					gfn_t gfn, kvm_pfn_t *pfnp,
 					int *levelp)
@@ -3342,8 +3366,8 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	 * here.
 	 */
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
-	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
-	    PageTransCompoundMap(pfn_to_page(pfn))) {
+	    level == PT_PAGE_TABLE_LEVEL &&
+	    pfn_is_huge_mapped(vcpu->kvm, gfn, pfn)) {
 		unsigned long mask;
 
 		/*
@@ -5957,8 +5981,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * mapping if the indirect sp has level = 1.
 		 */
 		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
-		    !kvm_is_zone_device_pfn(pfn) &&
-		    PageTransCompoundMap(pfn_to_page(pfn))) {
+		    pfn_is_huge_mapped(kvm, sp->gfn, pfn)) {
 			pte_list_remove(rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
-- 
2.24.0.525.g8f36a354ae-goog

