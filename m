Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D7A3A7321
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 02:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhFOA72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 20:59:28 -0400
Received: from mga18.intel.com ([134.134.136.126]:18757 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhFOA72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 20:59:28 -0400
IronPort-SDR: 8S6h1WEI6aazdaS2W20GKV90XnqVe1nJIz7TndDzoa2M0i7w98msmhGBXKsXEf7mdlEhFLNeFH
 Y1zHO5jgPupA==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="193212085"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="193212085"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 17:57:24 -0700
IronPort-SDR: GrlJZabZseGRKjFB+al3cA6E+do/xn0No8RXivglTlXAxvrZEdV3x0NWu0/4FAVYA6ypgvrSsa
 BQjpOPEQbSIg==
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="442391837"
Received: from tmonfort-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.223.245])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 17:57:22 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 1/3] KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()
Date:   Tue, 15 Jun 2021 12:57:09 +1200
Message-Id: <f9e8956223a586cd28c090879a8ff40f5eb6d609.1623717884.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623717884.git.kai.huang@intel.com>
References: <cover.1623717884.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently tdp_mmu_map_handle_target_level() returns 0, which is
RET_PF_RETRY, when page fault is actually fixed.  This makes
kvm_tdp_mmu_map() also return RET_PF_RETRY in this case, instead of
RET_PF_FIXED.  Fix by initializing ret to RET_PF_FIXED.

Note that kvm_mmu_page_fault() resumes guest on both RET_PF_RETRY and
RET_PF_FIXED, which means in practice returning the two won't make
difference, so this fix alone won't be necessary for stable tree.

Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cc13e001f3de..6c9c6917925a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -914,7 +914,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 					  kvm_pfn_t pfn, bool prefault)
 {
 	u64 new_spte;
-	int ret = 0;
+	int ret = RET_PF_FIXED;
 	int make_spte_ret = 0;
 
 	if (unlikely(is_noslot_pfn(pfn)))
-- 
2.31.1

