Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FADF58BDF1
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242394AbiHGWcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242183AbiHGWbl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:31:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40AF518372;
        Sun,  7 Aug 2022 15:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659910733; x=1691446733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YtV3gUfgaWbloXUiDdmU0LoSOosfztMOPHvLdoD+at8=;
  b=V6cKMrCaICq9HmZpFICxUm22nFRq70Me1RMcgSer606kjiOIVq5Tvm+5
   Au9OiKzoFrPm9diK7KX+Y+954ujIwttv/hjm8BlQoazm9EHCrqXnhqTE8
   gy+QX3A2Y1hALNJFyxxhT6uD2cCaJFq8PXOdGUzme51nxHgC01febvsRj
   tIMBBuKFQtVs+y0YeK018arMu/BfQZVCZVsHNNYplzOtiX2HHm0Am8MWB
   I7PKcjndgE5FJzZuNM1DEuypJnySCUt3FMevgbZQ0zLLL+84VFZUq3R93
   4LYYtP6YaIumAaO/9prCa9C02uW40Gtgg5MQ/b5fpHGfuIXLHJDnAP+Gj
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270852843"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="270852843"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="632642348"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:52 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH 13/13] KVM: x86: remove struct kvm_arch.tdp_max_page_level
Date:   Sun,  7 Aug 2022 15:18:46 -0700
Message-Id: <1469a0a4aabcaf51f67ed4b4e25155267e07bfd1.1659854957.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854957.git.isaku.yamahata@intel.com>
References: <cover.1659854957.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Now that everything is there to support large page for TD guest.  Remove
tdp_max_page_level from struct kvm_arch that limits the page size.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 -
 arch/x86/kvm/mmu/mmu.c          | 1 -
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 arch/x86/kvm/vmx/tdx.c          | 3 ---
 4 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a6bfcabcbbd7..80f2bc3fbf0c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1190,7 +1190,6 @@ struct kvm_arch {
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
-	int tdp_max_page_level;
 	u8 mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ba21503fa46f..0cbd52c476d7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6232,7 +6232,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
 
-	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index e5d5fea29bfa..82b220c4d1bd 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -395,7 +395,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			is_nx_huge_page_enabled(vcpu->kvm),
 		.is_private = kvm_is_private_gpa(vcpu->kvm, cr2_or_gpa),
 
-		.max_level = vcpu->kvm->arch.tdp_max_page_level,
+		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
 	};
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a340caeb9c62..72f21f5f78af 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -460,9 +460,6 @@ int tdx_vm_init(struct kvm *kvm)
 	 */
 	kvm_mmu_set_mmio_spte_mask(kvm, 0, VMX_EPT_RWX_MASK);
 
-	/* TODO: Enable 2mb and 1gb large page support. */
-	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
-
 	/* vCPUs can't be created until after KVM_TDX_INIT_VM. */
 	kvm->max_vcpus = 0;
 
-- 
2.25.1

