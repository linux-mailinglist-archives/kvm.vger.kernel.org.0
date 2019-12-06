Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8621159E5
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 00:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfLFX6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 18:58:19 -0500
Received: from mga07.intel.com ([134.134.136.100]:55584 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfLFX5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 18:57:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 15:57:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,286,1571727600"; 
   d="scan'208";a="219530351"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 06 Dec 2019 15:57:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/16] KVM: x86/mmu: Persist gfn_lpage_is_disallowed() to max_level
Date:   Fri,  6 Dec 2019 15:57:22 -0800
Message-Id: <20191206235729.29263-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191206235729.29263-1-sean.j.christopherson@intel.com>
References: <20191206235729.29263-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Persist the max page level calculated via gfn_lpage_is_disallowed() to
the max level "returned" by mapping_level() so that its naturally taken
into account by the max level check that conditions calling
transparent_hugepage_adjust().

Drop the gfn_lpage_is_disallowed() check in thp_adjust() as it's now
handled by mapping_level() and its callers.

Add a comment to document the behavior of host_mapping_level() and its
interaction with max level and transparent huge pages.

Note, transferring the gfn_lpage_is_disallowed() from thp_adjust() to
mapping_level() superficially affects how changes to a memslot's
disallow_lpage count will be handled due to thp_adjust() being run while
holding mmu_lock.

In the more common case where a different vCPU increments the count via
account_shadowed(), gfn_lpage_is_disallowed() is rechecked by set_spte()
to ensure a writable large page isn't created.

In the less common case where the count is decremented to zero due to
all shadow pages in the memslot being zapped, THP behavior now matches
hugetlbfs behavior in the sense that a small page will be created when a
large page could be used if the count reaches zero in the miniscule
window between mapping_level() and acquiring mmu_lock.

Lastly, the new THP behavior also follows hugetlbfs behavior in the
absurdly unlikely scenario of a memslot being moved such that the
memslot's compatibility with respect to large pages changes, but without
changing the validity of the gpf->pfn walk.  I.e. if a memslot is moved
between mapping_level() and snapshotting mmu_seq, it's theoretically
possible to consume a stale disallow_lpage count.  But, since KVM zaps
all shadow pages when moving a memslot and forces all vCPUs to reload a
new MMU, the inserted spte will always be thrown away prior to
completing the memslot move, i.e. whether or not the spte accurately
reflects disallow_lpage is irrelevant.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 877924cbb75b..8782a70abe78 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1326,7 +1326,7 @@ gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn,
 static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn,
 			 int *max_levelp)
 {
-	int host_level, max_level = *max_levelp;
+	int max_level = *max_levelp;
 	struct kvm_memory_slot *slot;
 
 	if (unlikely(max_level == PT_PAGE_TABLE_LEVEL))
@@ -1338,18 +1338,27 @@ static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn,
 		return PT_PAGE_TABLE_LEVEL;
 	}
 
-	host_level = host_mapping_level(vcpu->kvm, large_gfn);
-
-	if (host_level == PT_PAGE_TABLE_LEVEL)
-		return host_level;
-
-	max_level = min(kvm_x86_ops->get_lpage_level(), host_level);
+	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
 	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
 		if (!__mmu_gfn_lpage_is_disallowed(large_gfn, max_level, slot))
 			break;
 	}
 
-	return max_level;
+	*max_levelp = max_level;
+
+	if (max_level == PT_PAGE_TABLE_LEVEL)
+		return PT_PAGE_TABLE_LEVEL;
+
+	/*
+	 * Note, host_mapping_level() does *not* handle transparent huge pages.
+	 * As suggested by "mapping", it reflects the page size established by
+	 * the associated vma, if there is one, i.e. host_mapping_level() will
+	 * return a huge page level if and only if a vma exists and the backing
+	 * implementation for the vma uses huge pages, e.g. hugetlbfs and dax.
+	 * So, do not propagate host_mapping_level() to max_level as KVM can
+	 * still promote the guest mapping to a huge page in the THP case.
+	 */
+	return host_mapping_level(vcpu->kvm, large_gfn);
 }
 
 /*
@@ -3420,8 +3429,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	 */
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
 	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
-	    PageTransCompoundMap(pfn_to_page(pfn)) &&
-	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
+	    PageTransCompoundMap(pfn_to_page(pfn))) {
 		unsigned long mask;
 		/*
 		 * mmu_notifier_retry was successful and we hold the
-- 
2.24.0

