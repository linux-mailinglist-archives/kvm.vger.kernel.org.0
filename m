Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7737A174283
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 23:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgB1Wwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 17:52:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:64083 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgB1Wwn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 17:52:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Feb 2020 14:52:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,497,1574150400"; 
   d="scan'208";a="439387489"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 28 Feb 2020 14:52:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86/mmu: Reuse the current root if possible for fast switch
Date:   Fri, 28 Feb 2020 14:52:40 -0800
Message-Id: <20200228225240.8646-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228225240.8646-1-sean.j.christopherson@intel.com>
References: <20200228225240.8646-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reuse the current root when possible instead of grabbing a different
root from the array of cached roots.  Doing so avoids unnecessary MMU
switches and also fixes a quirk where KVM can't reuse roots without
creating multiple roots since the cache is a victim cache, i.e. roots
are added to the cache when they're "evicted", not when they are
created.  The quirk could be fixed by adding roots to the cache on
creation, but that would reduce the effective size of the cache as one
of its entries would be burned to track the current root.

Reusing the current root is especially helpful for nested virt as the
current root is almost always usable for the "new" MMU on nested
VM-entry/VM-exit.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9d617b9dc78f..53b776dfc949 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4253,6 +4253,14 @@ static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 	context->nx = false;
 }
 
+static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t cr3,
+				  union kvm_mmu_page_role role)
+{
+	return (role.direct || cr3 == root->cr3) &&
+	       VALID_PAGE(root->hpa) && page_header(root->hpa) &&
+	       role.word == page_header(root->hpa)->role.word;
+}
+
 /*
  * Find out if a previously cached root matching the new CR3/role is available.
  * The current root is also inserted into the cache.
@@ -4271,12 +4279,13 @@ static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 	root.cr3 = mmu->root_cr3;
 	root.hpa = mmu->root_hpa;
 
+	if (is_root_usable(&root, new_cr3, new_role))
+		return true;
+
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		swap(root, mmu->prev_roots[i]);
 
-		if ((new_role.direct || new_cr3 == root.cr3) &&
-		    VALID_PAGE(root.hpa) && page_header(root.hpa) &&
-		    new_role.word == page_header(root.hpa)->role.word)
+		if (is_root_usable(&root, new_cr3, new_role))
 			break;
 	}
 
-- 
2.24.1

