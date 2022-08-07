Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AEF58BD30
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237323AbiHGWFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235929AbiHGWDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:03:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2EAB1F2;
        Sun,  7 Aug 2022 15:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909769; x=1691445769;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xSgPSoDmIlmEh6BZbSNc729hGT8Gqev9J1l5dGaRsWQ=;
  b=IaR6VFh08e9VeZrA1399LLlAyyYvCsOqfeDHvXg7R7ZdF2GKNbgp0lbD
   Eb/9UB1nD1FdZXed0K5vdMYccFeEBF/GSL9qsjHH2zPhyAzHskdHU2WSt
   rhUzJ4V4U9jwVK650lT3lnWHM5QezAOMDgqmhKNMq+Iym0kaGQKTMrUEu
   PxnrJTOzJ0OkMsJfY9abfi6ckPwuYuU1eUlH0Y3+Ks+zspj7GOJkNatb3
   cLvR4T0mNTvNJAlv0AKOqyEWVFT/QANSEeG5tygcifmeHVbQrGa4N+Xxd
   6bFYC3FXuW2Lh0NuOF5qDEZrDs5JqwDKLNle67lSZKlZy/PIT9PJZ2y8m
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224116"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224116"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682548"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:34 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 035/103] KVM: x86/mmu: Allow per-VM override of the TDP max page level
Date:   Sun,  7 Aug 2022 15:01:20 -0700
Message-Id: <af2b2a8b708f352ccd269f805c743f6c04ccda37.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX requires special handling to support large private page.  For
simplicity, only support 4K page for TD guest for now.  Add per-VM maximum
page level support to support different maximum page sizes for TD guest and
conventional VMX guest.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/mmu/mmu.c          | 1 +
 arch/x86/kvm/mmu/mmu_internal.h | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3c4051d4512b..e07294fc2219 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1142,6 +1142,7 @@ struct kvm_arch {
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
+	int tdp_max_page_level;
 	u8 mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1f7f61e04b94..0e5a6dcc4966 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6063,6 +6063,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	kvm->arch.split_desc_cache.kmem_cache = pte_list_desc_cache;
 	kvm->arch.split_desc_cache.gfp_zero = __GFP_ZERO;
 
+	kvm->arch.tdp_max_page_level = KVM_MAX_HUGEPAGE_LEVEL;
 	return 0;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 582def531d4d..e1b2e84c16b5 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -272,7 +272,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.nx_huge_page_workaround_enabled =
 			is_nx_huge_page_enabled(vcpu->kvm),
 
-		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
+		.max_level = vcpu->kvm->arch.tdp_max_page_level,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
 	};
-- 
2.25.1

