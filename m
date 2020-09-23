Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B1C276031
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgIWSnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:43:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:9838 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726762AbgIWSmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:42:39 -0400
IronPort-SDR: y2Blcv+j9pjbkGGC8re0Lk25dkrWY5xkHfp8p6dxKhFuczkft0wqsTbkdFj6M8IBa7DKdWtN1P
 YrthEANK/lYw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="160276867"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="160276867"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:37:38 -0700
IronPort-SDR: a0t6Vq27FtT/Gf2QFfwR1VVrUHIvKPqZ8FJ9C3S2dNowTYidYp2RX9vXpjMiShoAKyecOjP8xB
 JBchwtuQXKMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="486561630"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga005.jf.intel.com with ESMTP; 23 Sep 2020 11:37:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>
Subject: [PATCH v2 7/8] KVM: x86/mmu: Hoist ITLB multi-hit workaround check up a level
Date:   Wed, 23 Sep 2020 11:37:34 -0700
Message-Id: <20200923183735.584-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923183735.584-1-sean.j.christopherson@intel.com>
References: <20200923183735.584-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the "ITLB multi-hit workaround enabled" check into the callers of
disallowed_hugepage_adjust() to make it more obvious that the helper is
specific to the workaround, and to be consistent with the accounting,
i.e. account_huge_nx_page() is called if and only if the workaround is
enabled.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 4 ++--
 arch/x86/kvm/mmu/paging_tmpl.h | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0957795be384..fbee958927ce 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3302,7 +3302,6 @@ static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
 	u64 spte = *it.sptep;
 
 	if (it.level == level && level > PG_LEVEL_4K &&
-	    is_nx_huge_page_enabled() &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
 		/*
@@ -3344,7 +3343,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		 * We cannot overwrite existing page tables with an NX
 		 * large page, as the leaf could be executable.
 		 */
-		disallowed_hugepage_adjust(it, gfn, &pfn, &level);
+		if (nx_huge_page_workaround_enabled)
+			disallowed_hugepage_adjust(it, gfn, &pfn, &level);
 
 		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 26dde437abc0..84ea1094fbe2 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -694,7 +694,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		 * We cannot overwrite existing page tables with an NX
 		 * large page, as the leaf could be executable.
 		 */
-		disallowed_hugepage_adjust(it, gw->gfn, &pfn, &level);
+		if (nx_huge_page_workaround_enabled)
+			disallowed_hugepage_adjust(it, gw->gfn, &pfn, &level);
 
 		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
-- 
2.28.0

