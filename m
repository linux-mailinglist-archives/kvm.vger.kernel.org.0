Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75CB3A7322
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 02:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFOA7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 20:59:33 -0400
Received: from mga18.intel.com ([134.134.136.126]:18757 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhFOA7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 20:59:32 -0400
IronPort-SDR: SgrXtrE9thUlehKZg22kKjBdXOOFuHkEvyCIcJwgpBQCxtYdJwEwSkNanmIx2yQ8yZho/SO77i
 RwRBNkBSBt/A==
X-IronPort-AV: E=McAfee;i="6200,9189,10015"; a="193212086"
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="193212086"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 17:57:27 -0700
IronPort-SDR: Yf28RVjNqCJafF4pZHNTLG0xFA6TNEyunsz/KXhZWrxKdSivzJLVKqGbYUS9zXugvo058YCeD3
 yaU+YATBA96A==
X-IronPort-AV: E=Sophos;i="5.83,273,1616482800"; 
   d="scan'208";a="442391850"
Received: from tmonfort-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.223.245])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2021 17:57:24 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 2/3] KVM: x86/mmu: Fix pf_fixed count in tdp_mmu_map_handle_target_level()
Date:   Tue, 15 Jun 2021 12:57:10 +1200
Message-Id: <2ea8b7f5d4f03c99b32bc56fc982e1e4e3d3fc6b.1623717884.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623717884.git.kai.huang@intel.com>
References: <cover.1623717884.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently pf_fixed is not increased when prefault is true.  This is not
correct, since prefault here really means "async page fault completed".
In that case, the original page fault from the guest was morphed into as
async page fault and pf_fixed was not increased.  So when prefault
indicates async page fault is completed, pf_fixed should be increased.

Additionally, currently pf_fixed is also increased even when page fault
is spurious, while legacy MMU increases pf_fixed when page fault returns
RET_PF_EMULATE or RET_PF_FIXED.

To fix above two issues, change to increase pf_fixed when return value
is not RET_PF_SPURIOUS (RET_PF_RETRY has already been ruled out by
reaching here).

More information:
https://lore.kernel.org/kvm/cover.1620200410.git.kai.huang@intel.com/T/#mbb5f8083e58a2cd262231512b9211cbe70fc3bd5

Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6c9c6917925a..efb7503ed4d5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -951,7 +951,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 				       rcu_dereference(iter->sptep));
 	}
 
-	if (!prefault)
+	/*
+	 * Increase pf_fixed in both RET_PF_EMULATE and RET_PF_FIXED to be
+	 * consistent with legacy MMU behavior.
+	 */
+	if (ret != RET_PF_SPURIOUS)
 		vcpu->stat.pf_fixed++;
 
 	return ret;
-- 
2.31.1

