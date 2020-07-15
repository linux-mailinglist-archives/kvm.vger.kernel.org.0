Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228A82203F2
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgGOE1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:27:46 -0400
Received: from mga05.intel.com ([192.55.52.43]:59540 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726936AbgGOE1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:27:30 -0400
IronPort-SDR: Nu5thcu46LDUxqxIltCQXsnnbB8Du0zwD+p3wNHKmIHEQHIA3n6Kuym94qzta9fg6GC9+fd+Ou
 ItNvnxiJNe1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="233936300"
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="233936300"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:27:27 -0700
IronPort-SDR: OgRE+dfGvD6j+aPbMPG8UbKnKZo8UJL2vLJ2CVUGW5PVZl63WuM/spQhG0mNcSg1vWvvNu5QNm
 ybLkUtNue4GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="308118796"
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
Subject: [PATCH 7/8] KVM: x86/mmu: Hoist ITLB multi-hit workaround check up a level
Date:   Tue, 14 Jul 2020 21:27:24 -0700
Message-Id: <20200715042725.10961-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715042725.10961-1-sean.j.christopherson@intel.com>
References: <20200715042725.10961-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 1b2ef2f61d997..135bdf6ef8ca9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3300,7 +3300,6 @@ static void disallowed_hugepage_adjust(struct kvm_shadow_walk_iterator it,
 	u64 spte = *it.sptep;
 
 	if (it.level == level && level > PG_LEVEL_4K &&
-	    is_nx_huge_page_enabled() &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
 		/*
@@ -3342,7 +3341,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		 * We cannot overwrite existing page tables with an NX
 		 * large page, as the leaf could be executable.
 		 */
-		disallowed_hugepage_adjust(it, gfn, &pfn, &level);
+		if (nx_huge_page_workaround_enabled)
+			disallowed_hugepage_adjust(it, gfn, &pfn, &level);
 
 		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
 		if (it.level == level)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 35867a1a1ee89..db5734d7c80b6 100644
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
2.26.0

