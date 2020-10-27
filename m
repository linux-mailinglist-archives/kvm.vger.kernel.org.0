Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3960A29CB66
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 22:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374274AbgJ0VnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 17:43:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:17169 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S374267AbgJ0VnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 17:43:03 -0400
IronPort-SDR: O3HV3Q4m08mtQ/3lKD0o5vGgLc8upGmq+uAR2u90izQNY7Bz/UhQ/CKxdcO+WUPtS2mHTfoPSh
 RG3Zw6SocnKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="164667232"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="164667232"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 14:43:02 -0700
IronPort-SDR: JSnMxvN6WM51AZ66M6eFz+jWKz4hNnEZDFYnWQm8VHbxebfIPk82XS/Oup3365CqfrPgYaAYYS
 4gih7hI/Z9yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="334537307"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga002.jf.intel.com with ESMTP; 27 Oct 2020 14:43:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Subject: [PATCH 2/3] KVM: x86/mmu: Open code GFN "rounding" in TDP MMU
Date:   Tue, 27 Oct 2020 14:42:59 -0700
Message-Id: <20201027214300.1342-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201027214300.1342-1-sean.j.christopherson@intel.com>
References: <20201027214300.1342-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop round_gfn_for_level() and directly use the recently introdocued
KVM_HPAGE_GFN_MASK() macro.  Hiding the masking in a "rounding" function
adds an extra "what does this do?" lookup, whereas the concept and usage
of PFN/GFN masks is common enough that it's easy to read the open coded
version without thinking too hard.

No functional change intended.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/tdp_iter.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index c6e914c96641..4175947dc401 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -15,11 +15,6 @@ static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 	iter->old_spte = READ_ONCE(*iter->sptep);
 }
 
-static gfn_t round_gfn_for_level(gfn_t gfn, int level)
-{
-	return gfn & KVM_HPAGE_GFN_MASK(level);
-}
-
 /*
  * Sets a TDP iterator to walk a pre-order traversal of the paging structure
  * rooted at root_pt, starting with the walk to translate goal_gfn.
@@ -36,7 +31,7 @@ void tdp_iter_start(struct tdp_iter *iter, u64 *root_pt, int root_level,
 	iter->level = root_level;
 	iter->pt_path[iter->level - 1] = root_pt;
 
-	iter->gfn = round_gfn_for_level(iter->goal_gfn, iter->level);
+	iter->gfn = iter->goal_gfn & KVM_HPAGE_GFN_MASK(iter->level);
 	tdp_iter_refresh_sptep(iter);
 
 	iter->valid = true;
@@ -82,7 +77,7 @@ static bool try_step_down(struct tdp_iter *iter)
 
 	iter->level--;
 	iter->pt_path[iter->level - 1] = child_pt;
-	iter->gfn = round_gfn_for_level(iter->goal_gfn, iter->level);
+	iter->gfn = iter->goal_gfn & KVM_HPAGE_GFN_MASK(iter->level);
 	tdp_iter_refresh_sptep(iter);
 
 	return true;
@@ -124,7 +119,7 @@ static bool try_step_up(struct tdp_iter *iter)
 		return false;
 
 	iter->level++;
-	iter->gfn = round_gfn_for_level(iter->gfn, iter->level);
+	iter->gfn &= KVM_HPAGE_GFN_MASK(iter->level);
 	tdp_iter_refresh_sptep(iter);
 
 	return true;
-- 
2.28.0

