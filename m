Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E473737AA
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 11:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhEEJjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 05:39:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:56202 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232373AbhEEJjR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 05:39:17 -0400
IronPort-SDR: n1zgX4xpHm1FehKJu2rQUY+aVGhDswvUcpxsA0o2eyOmIZsGWvs2yBFUaIU89M4nkCMesAmtZG
 ZuDRDVd2u1Og==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="177724159"
X-IronPort-AV: E=Sophos;i="5.82,274,1613462400"; 
   d="scan'208";a="177724159"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 02:38:21 -0700
IronPort-SDR: IGGb1xObqLIsp6kXdhGmMPFkpWMisOA4GMLUU0+ZmDz4BTmgU3rlEUmV2IM2/MoAhow34NcSoY
 FAbcWCFxgR7g==
X-IronPort-AV: E=Sophos;i="5.82,274,1613462400"; 
   d="scan'208";a="433728469"
Received: from smorlan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.190.185])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 02:38:19 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 2/3] KVM: x86/mmu: Fix pf_fixed count in tdp_mmu_map_handle_target_level()
Date:   Wed,  5 May 2021 21:37:58 +1200
Message-Id: <23b565dd3b3dfa20aea1c13bce01163f9427a237.1620200410.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620200410.git.kai.huang@intel.com>
References: <cover.1620200410.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently pf_fixed is increased even when page fault requires emulation,
or fault is spurious.  Fix by only increasing it when return value is
RET_PF_FIXED.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1cad4c9f7c34..debe8c3ec844 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -942,7 +942,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 				       rcu_dereference(iter->sptep));
 	}
 
-	if (!prefault)
+	if (!prefault && ret == RET_PF_FIXED)
 		vcpu->stat.pf_fixed++;
 
 	return ret;
-- 
2.31.1

