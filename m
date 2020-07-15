Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078362203F6
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgGOE14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:27:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:59545 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726878AbgGOE1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:27:30 -0400
IronPort-SDR: jkN8i+RfbEU+ASdhB6fp57ZpTBu1nKVlD0fnmKnJ1reJ0jOcSTA3JZd8FCCaNKH3xLopwXMkhM
 YWrzM3g0NFGA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="233936299"
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="233936299"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:27:27 -0700
IronPort-SDR: 3e1NIAbU/Y0O7P6YeabD6WshsL5X1M2LcV4VTJkIvNVeSkEq56DTv1DaSuRqfxxvCpZS/uS5EQ
 u/XxGmjYuHNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="308118792"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jul 2020 21:27:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>
Subject: [PATCH 6/8] KVM: x86/mmu: Rename 'hlevel' to 'level' in FNAME(fetch)
Date:   Tue, 14 Jul 2020 21:27:23 -0700
Message-Id: <20200715042725.10961-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715042725.10961-1-sean.j.christopherson@intel.com>
References: <20200715042725.10961-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename 'hlevel', which presumably stands for 'host level', to simply
'level' in FNAME(fetch).  The variable hasn't tracked the host level for
quite some time.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 39578a1839ca4..35867a1a1ee89 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -636,7 +636,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
 	unsigned direct_access, access = gw->pt_access;
-	int top_level, hlevel, req_level, ret;
+	int top_level, level, req_level, ret;
 	gfn_t base_gfn = gw->gfn;
 
 	direct_access = gw->pte_access;
@@ -682,8 +682,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			link_shadow_page(vcpu, it.sptep, sp);
 	}
 
-	hlevel = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn,
-					 huge_page_disallowed, &req_level);
+	level = kvm_mmu_hugepage_adjust(vcpu, gw->gfn, max_level, &pfn,
+					huge_page_disallowed, &req_level);
 
 	trace_kvm_mmu_spte_requested(addr, gw->level, pfn);
 
@@ -694,10 +694,10 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		 * We cannot overwrite existing page tables with an NX
 		 * large page, as the leaf could be executable.
 		 */
-		disallowed_hugepage_adjust(it, gw->gfn, &pfn, &hlevel);
+		disallowed_hugepage_adjust(it, gw->gfn, &pfn, &level);
 
 		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
-		if (it.level == hlevel)
+		if (it.level == level)
 			break;
 
 		validate_direct_spte(vcpu, it.sptep, direct_access);
-- 
2.26.0

