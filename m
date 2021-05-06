Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A11375D7B
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 01:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhEFXfV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 19:35:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:63204 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230387AbhEFXfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 19:35:20 -0400
IronPort-SDR: 9HkbwDo60Sk2EVTEtzWH1pw54CPey0aqLU9SIlmUAbRahJRCnws36IBIR/Rlt9XDawYJbME7I/
 ufT9wohigaUA==
X-IronPort-AV: E=McAfee;i="6200,9189,9976"; a="186066164"
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="186066164"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 16:34:22 -0700
IronPort-SDR: 1+yCQz0TNSC61q3M1lSSpbvANrCCr8jiQTYDfjTJ+OfyCKBmwCobg6dYCQnXOj87kx//7U/0EI
 9/3Q28QaeReA==
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="608004643"
Received: from jasonbai-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.141.48])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 16:34:19 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 2/3] KVM: x86/mmu: Fix pf_fixed count in tdp_mmu_map_handle_target_level()
Date:   Fri,  7 May 2021 11:34:01 +1200
Message-Id: <76406bd7aad0cec458e832639c7a2de963e70990.1620343751.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620343751.git.kai.huang@intel.com>
References: <cover.1620343751.git.kai.huang@intel.com>
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
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ed85b09f0119..c389d20418e3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -942,7 +942,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
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

