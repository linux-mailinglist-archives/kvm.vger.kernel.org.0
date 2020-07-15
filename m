Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4FE2203EA
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgGOE1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:27:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:59540 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726873AbgGOE13 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:27:29 -0400
IronPort-SDR: 17ZcdRBIR41q3HAlSntD8iLvgqZK+vj4WcgP24+g6T3sa9oI7EDAE8VawU7Zt1dx7gnJJ1Fbgi
 REMnktyM65wA==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="233936298"
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="233936298"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:27:27 -0700
IronPort-SDR: eLDwK2HR7k12jV4xAJjo9SlR6U+K/v3g5GNr+vzN0F0id3gvClnJ7Ivrk1TADrSQnQGfUd6+kv
 YWSromu9/jqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,354,1589266800"; 
   d="scan'208";a="308118789"
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
Subject: [PATCH 5/8] KVM: x86/mmu: Account NX huge page disallowed iff huge page was requested
Date:   Tue, 14 Jul 2020 21:27:22 -0700
Message-Id: <20200715042725.10961-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715042725.10961-1-sean.j.christopherson@intel.com>
References: <20200715042725.10961-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Condition the accounting of a disallowed huge NX page on the original
requested level of the page being greater than the current iterator
level.  This does two things: accounts the page if and only if a huge
page was actually disallowed, and accounts the shadow page if and only
if it was the level at which the huge page was disallowed.  For the
latter case, the previous logic would account all shadow pages used to
create the translation for the forced small page, e.g. even PML4, which
can't be a huge page on current hardware, would be accounted as having
been a disallowed huge page when using 5-level EPT.

The overzealous accounting is purely a performance issue, i.e. the
recovery thread will spuriously zap shadow pages, but otherwise the bad
behavior is harmless.

Cc: Junaid Shahid <junaids@google.com>
Fixes: b8e8c8303ff28 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 3 ++-
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 974c9a89c2454..1b2ef2f61d997 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3354,7 +3354,8 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 					      it.level - 1, true, ACC_ALL);
 
 			link_shadow_page(vcpu, it.sptep, sp);
-			if (is_tdp && huge_page_disallowed)
+			if (is_tdp && huge_page_disallowed &&
+			    req_level >= it.level)
 				account_huge_nx_page(vcpu->kvm, sp);
 		}
 	}
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b92d936c0900d..39578a1839ca4 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -708,7 +708,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 			sp = kvm_mmu_get_page(vcpu, base_gfn, addr,
 					      it.level - 1, true, direct_access);
 			link_shadow_page(vcpu, it.sptep, sp);
-			if (huge_page_disallowed)
+			if (huge_page_disallowed && req_level >= it.level)
 				account_huge_nx_page(vcpu->kvm, sp);
 		}
 	}
-- 
2.26.0

