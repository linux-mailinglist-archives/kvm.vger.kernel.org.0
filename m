Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9645F0885
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiI3KUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiI3KTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:19:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38814166F2D;
        Fri, 30 Sep 2022 03:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533142; x=1696069142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=egSdmBDWUZIcewFDKHSSDYx6qc0YZSUEykKZr8M2EK4=;
  b=fb+syh55GvAKKxqwqeD61sa2ZikpXmh/Zg34gCuVZrH/sZ6S4hnCtmHU
   viyd7rRGg+hBZrt38mzKP0ssyc7aA4ocGdp/Mz52BaN+Z1PFWzLpoQiMc
   tLzc+//c6THSTA2J8kk1XjBrBSqz95b12HkGhB/2uenVqYgsy3dYejFru
   NDHN1zLs3XgazphscCnaqdbBNnUGzzhZ4WtiIhe+sByV9HChC+YlqPDCj
   x2szuyfzRs5lcThcWb7A2dG3Py4aDdhP2LK267xH5a5CbRg98AocLpdcZ
   X63wILTxFp1j+i0zVoEePK4fWMN8pBOBPadctIbIbqRDKXv0hCmLbA48S
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870091"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870091"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:57 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807616"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807616"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 035/105] KVM: TDX: Enable mmio spte caching always for TDX
Date:   Fri, 30 Sep 2022 03:17:29 -0700
Message-Id: <8eac5ca057eb23b851dadcbae39f267edf50d8d3.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX needs to set shared spte for MMIO GFN to !SUPPRES_VE_BIT | !RWX so that
guest TD can get #VE and then issue TDG.VP.VMCALL<MMIO>.  Enable mmio
caching always for TDX irrelevant the module parameter enable_mmio_caching.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c     | 3 ++-
 arch/x86/kvm/mmu/spte.h    | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 7 +++++++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fdd773ef9400..f4d7432cd9fc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3216,7 +3216,8 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fau
 		 * and only if L1's MAXPHYADDR is inaccurate with respect to
 		 * the hardware's).
 		 */
-		if (unlikely(!enable_mmio_caching) ||
+		if (unlikely(!enable_mmio_caching &&
+			     !kvm_gfn_shared_mask(vcpu->kvm)) ||
 		    unlikely(fault->gfn > kvm_mmu_max_gfn()))
 			return RET_PF_EMULATE;
 	}
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 82f0d5c08b77..fecfdcb5f321 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -244,7 +244,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
 static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
 {
 	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
-	       likely(enable_mmio_caching);
+	       likely(enable_mmio_caching || kvm_gfn_shared_mask(kvm));
 }
 
 static inline bool is_shadow_present_pte(u64 pte)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b80422ea798d..5ecb976ed954 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1863,6 +1863,13 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	*root_level = vcpu->arch.mmu->root_role.level;
 
+	/*
+	 * mmio page fault isn't supported for protected guest because
+	 * instructions in protected guest memory can't be parsed by VMM.
+	 */
+	if (WARN_ON_ONCE(kvm_gfn_shared_mask(vcpu->kvm)))
+		return leaf;
+
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
-- 
2.25.1

