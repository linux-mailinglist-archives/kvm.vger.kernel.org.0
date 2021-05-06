Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71D5375D7A
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 01:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhEFXfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 19:35:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:63204 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230387AbhEFXfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 19:35:18 -0400
IronPort-SDR: 0A+nyLyOAl+elxik7MQECC7wUnQdnVpeIByGT2LDzMZ1lQTynsdqfeNtnoq5L/CIni0F3Ed7hZ
 P6WT9Nu6bYzA==
X-IronPort-AV: E=McAfee;i="6200,9189,9976"; a="186066160"
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="186066160"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 16:34:19 -0700
IronPort-SDR: 93LAXJ4JpZKj0wAd8HQMgJt0sLyM+pKa1M1V921oO/pxJFLj73/n4fmdIQ5mF6cLSiBT7a48s0
 as85127RFFSg==
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="608004617"
Received: from jasonbai-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.141.48])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 16:34:17 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 1/3] KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()
Date:   Fri,  7 May 2021 11:34:00 +1200
Message-Id: <fefeaadc0e3c5ef914eeaa53a1d7fe9276c49441.1620343751.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620343751.git.kai.huang@intel.com>
References: <cover.1620343751.git.kai.huang@intel.com>
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
index 83cbdbe5de5a..ed85b09f0119 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -905,7 +905,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 					  kvm_pfn_t pfn, bool prefault)
 {
 	u64 new_spte;
-	int ret = 0;
+	int ret = RET_PF_FIXED;
 	int make_spte_ret = 0;
 
 	if (unlikely(is_noslot_pfn(pfn)))
-- 
2.31.1

