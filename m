Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BCF3737A8
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 11:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhEEJjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 05:39:16 -0400
Received: from mga12.intel.com ([192.55.52.136]:56202 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231494AbhEEJjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 05:39:15 -0400
IronPort-SDR: bV6di5pOY2huMfh0nL7iclGGxzVZeR3LTEZrXxznpvRWEUOQ1LuY78iDhwGJkJ8LBz0c9v0+eI
 d4KabCtfxByQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9974"; a="177724143"
X-IronPort-AV: E=Sophos;i="5.82,274,1613462400"; 
   d="scan'208";a="177724143"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 02:38:19 -0700
IronPort-SDR: jqUUlVS1MbiRYMSZ4cmaSasKPLj5lDy8AaILmWrM5taSPSQZZaaTQTb215REkfHuC8qz8Xgux/
 58qh2qhQmRtg==
X-IronPort-AV: E=Sophos;i="5.82,274,1613462400"; 
   d="scan'208";a="433728455"
Received: from smorlan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.190.185])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 02:38:16 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 1/3] KVM: x86/mmu: Fix return value in tdp_mmu_map_handle_target_level()
Date:   Wed,  5 May 2021 21:37:57 +1200
Message-Id: <00875eb37d6b5cc9d19bb19e31db3130ac1d8730.1620200410.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620200410.git.kai.huang@intel.com>
References: <cover.1620200410.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently tdp_mmu_map_handle_target_level() returns 0, which is
RET_PF_RETRY, when page fault is actually fixed.  This makes
kvm_tdp_mmu_map() also return RET_PF_RETRY in this case, instead of
RET_PF_FIXED.  Fix by initializing ret to RET_PF_FIXED.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ff0ae030004d..1cad4c9f7c34 100644
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

