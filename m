Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3FE6127E4
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiJ3GZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiJ3GYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11212DB;
        Sat, 29 Oct 2022 23:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111049; x=1698647049;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pWNqZahEI5Xl8NsH6Eh4XLhAHK5yB8z2OVg0DU77Aqw=;
  b=P8OLk53LzvWe6iF5XhUREwfxw2+s3HLA2xP/FB2JsDaw5C+l3BDN0E/D
   ryS8fLvzuIw05nRckc3E8ULyHbKZpOVfcNKVGBeyHZ2k1IMRTpwZ6Kugq
   LnNtjduioVkzYhuuLo1hN5z0AQjBxQ92boYSWJBaBNlCffXBt54KXq9Sn
   vzAdH/Giw96Ctw1s2SqIniJgKXUHQsBSr7p1XtGFnauIwlzVIyrC9wEIb
   os55kL/pc/qxLM3eCKcGHI9NCoshAEScogpcUPRkToj3H2uZ3O1gxdlNf
   d4N2ZwLuj5bgkXNxdhiKLdFP3rgH2+4LXPAmh5gR+MtynybTnTbGfogBZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037148"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037148"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:03 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392961"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392961"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:02 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 036/108] KVM: TDX: Enable mmio spte caching always for TDX
Date:   Sat, 29 Oct 2022 23:22:37 -0700
Message-Id: <820bac8ce45b92d643630084096dcd7e71038a58.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 0d3fa29ccccc..9098f77cdaa4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3229,7 +3229,8 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fau
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
index e07f14351d14..3325633b1cb5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1875,6 +1875,13 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
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

