Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADAD4CDF14
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiCDUcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiCDUcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:32:20 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4920B1EE260;
        Fri,  4 Mar 2022 12:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646425888; x=1677961888;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JN/QmgwHHgOhVkALs0KxzUApbbVjylIiYKcWhfxJUeE=;
  b=IwfV0R+uo368ekZvHfTpv6rOKRgjOY0BJp3JaZqEwL7tv/UXGRN329zr
   GrspQpGFDWz7DeGcVMPKJ5aTKLoOQfnDYfQVJqyWsle7Z7ihEnpfEOaAh
   eLzEO2bFnYecpZM1CD5kMP/mTIMvEqobuV7YmGIzS6pmOu6h+OhpMjbGR
   w6538oi6IFWv0psnNn9n9LEPYkKJ15JNUR6eb8cATebUdHDAko4eogV65
   JTFX3U/BxkmRRZrNEslZiePjvcBUbVP8AItvtl2VhJ/BHZEykfnWcO9Gi
   6o9RLN3RRpmrhd5L/cBSSBd+NlyIb4etH+cHUmkA8C/ECDJdmEjj9xPdx
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="251624224"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="251624224"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:27 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344403"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:27 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 055/104] KVM: x86/tdp_mmu: prevent private/shared map based on PRIVATE_PROHIBIT
Date:   Fri,  4 Mar 2022 11:49:11 -0800
Message-Id: <273543bac1c40c869a68d3f72eb2abc03106e8d9.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Use the bit SPTE_PRIVATE_PROHIBIT in shared and private EPT to determine
which mapping, shared or private, is allowed.  If requested mapping isn't
allowed, return RET_PF_RETRY to wait for other vcpu to change it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/spte.h    |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++++++++++++++---
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 25dffdb488d1..9c37381a6762 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -223,7 +223,7 @@ extern u64 __read_mostly shadow_init_value;
 
 static inline bool is_removed_spte(u64 spte)
 {
-	return spte == SHADOW_REMOVED_SPTE;
+	return (spte & ~SPTE_PRIVATE_PROHIBIT) == SHADOW_REMOVED_SPTE;
 }
 
 static inline bool is_private_prohibit_spte(u64 spte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6d750563824d..f6bd35831e32 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1038,9 +1038,25 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 
 	WARN_ON(sp->role.level != fault->goal_level);
 
-	/* TDX shared GPAs are no executable, enforce this for the SDV. */
-	if (!kvm_is_private_gfn(vcpu->kvm, iter->gfn))
-		pte_access &= ~ACC_EXEC_MASK;
+	if (kvm_gfn_stolen_mask(vcpu->kvm)) {
+		if (is_private_spte(iter->sptep)) {
+			/*
+			 * This GPA is not allowed to map as private.  Let
+			 * vcpu loop in page fault until other vcpu change it
+			 * by MapGPA hypercall.
+			 */
+			if (fault->slot &&
+				is_private_prohibit_spte(iter->old_spte))
+				return RET_PF_RETRY;
+		} else {
+			/* This GPA is not allowed to map as shared. */
+			if (fault->slot &&
+				!is_private_prohibit_spte(iter->old_spte))
+				return RET_PF_RETRY;
+			/* TDX shared GPAs are no executable, enforce this. */
+			pte_access &= ~ACC_EXEC_MASK;
+		}
+	}
 
 	if (unlikely(!fault->slot))
 		new_spte = make_mmio_spte(vcpu,
-- 
2.25.1

