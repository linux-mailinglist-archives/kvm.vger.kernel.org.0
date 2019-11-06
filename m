Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56D0F1C1D
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 18:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732296AbfKFRHa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 12:07:30 -0500
Received: from mga06.intel.com ([134.134.136.31]:58093 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732280AbfKFRHa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 12:07:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 09:07:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="192528000"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 06 Nov 2019 09:07:28 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 1/2] KVM: MMU: Do not treat ZONE_DEVICE pages as being reserved
Date:   Wed,  6 Nov 2019 09:07:26 -0800
Message-Id: <20191106170727.14457-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191106170727.14457-1-sean.j.christopherson@intel.com>
References: <20191106170727.14457-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly exempt ZONE_DEVICE pages from kvm_is_reserved_pfn() and
instead manually handle ZONE_DEVICE on a case-by-case basis.  For things
like page refcounts, KVM needs to treat ZONE_DEVICE pages like normal
pages, e.g. put pages grabbed via gup().  But KVM needs special handling
in other flows where ZONE_DEVICE pages lack the underlying machinery,
e.g. when setting accessed/dirty bits and shifting refcounts for
transparent huge pages.

This fixes a hang reported by Adam Borowski[*] in dev_pagemap_cleanup()
when running a KVM guest backed with /dev/dax memory, as KVM straight up
doesn't put any references to ZONE_DEVICE pages acquired by gup().

[*] http://lkml.kernel.org/r/20190919115547.GA17963@angband.pl

Reported-by: Adam Borowski <kilobyte@angband.pl>
Debugged-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c       |  8 ++++----
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 19 +++++++++++++++----
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24c23c66b226..bf82b1f2e834 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3306,7 +3306,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	 * here.
 	 */
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
-	    level == PT_PAGE_TABLE_LEVEL &&
+	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
 	    PageTransCompoundMap(pfn_to_page(pfn)) &&
 	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
 		unsigned long mask;
@@ -5914,9 +5914,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * the guest, and the guest page table is using 4K page size
 		 * mapping if the indirect sp has level = 1.
 		 */
-		if (sp->role.direct &&
-			!kvm_is_reserved_pfn(pfn) &&
-			PageTransCompoundMap(pfn_to_page(pfn))) {
+		if (sp->role.direct && !kvm_is_reserved_pfn(pfn) &&
+		    !kvm_is_zone_device_pfn(pfn) &&
+		    PageTransCompoundMap(pfn_to_page(pfn))) {
 			pte_list_remove(rmap_head, sptep);
 
 			if (kvm_available_flush_tlb_with_range())
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a817e446c9aa..4ad1cd7d2d4d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -966,6 +966,7 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 
 bool kvm_is_reserved_pfn(kvm_pfn_t pfn);
+bool kvm_is_zone_device_pfn(kvm_pfn_t pfn);
 
 struct kvm_irq_ack_notifier {
 	struct hlist_node link;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b8534c6b8cf6..0a781b1fb8f0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -151,12 +151,23 @@ __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 
 bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
 {
+	/*
+	 * ZONE_DEVICE pages currently set PG_reserved, but from a refcounting
+	 * perspective they are "normal" pages, albeit with slightly different
+	 * usage rules.
+	 */
 	if (pfn_valid(pfn))
-		return PageReserved(pfn_to_page(pfn));
+		return PageReserved(pfn_to_page(pfn)) &&
+		       !is_zone_device_page(pfn_to_page(pfn));
 
 	return true;
 }
 
+bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
+{
+	return pfn_valid(pfn) && is_zone_device_page(pfn_to_page(pfn));
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
  */
@@ -1865,7 +1876,7 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
 
 void kvm_set_pfn_dirty(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn)) {
+	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
 		struct page *page = pfn_to_page(pfn);
 
 		SetPageDirty(page);
@@ -1875,14 +1886,14 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
 void kvm_set_pfn_accessed(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn))
+	if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
 		mark_page_accessed(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
 
 void kvm_get_pfn(kvm_pfn_t pfn)
 {
-	if (!kvm_is_reserved_pfn(pfn))
+	if (!kvm_is_reserved_pfn(pfn) && !WARN_ON(kvm_is_zone_device_pfn(pfn)))
 		get_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_get_pfn);
-- 
2.24.0

