Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6304F667B8F
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240865AbjALQni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240290AbjALQip (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:45 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2B51CB06;
        Thu, 12 Jan 2023 08:34:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541246; x=1705077246;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=62mQ8fLHlhIAeSorZdWTNSoO6Sps+++OvegPqPcNnAo=;
  b=fbyfyPdUBuSGcew12cFmyjBYhyttWUjz/jtuyltIWovN6xuPRrFt3rnW
   YXLNd08Qz6tvoR9ioOK2O0OLc91YMNT7UfpTXcER/1xP0HYQnNr2x1iEm
   uZ/OVCyFhQqftkS3v86ZQPQ9LYBMk2E70U2wQOXCTsHavsWFRhg+JY4vj
   ohqKQlQsQYyvH2wU65K0T+JNaIQePA6fxckYycvvBfDz+HzvZmNzQMQ/6
   4XiQ5qn7rdguet6nLZCCVHYYy7Kel055uiSIAQFKs6PdjFCph2epWhsqj
   8CpO0kte2H3MzDrdj2ZbzZQB5lBaBtyU+DhiAfRSOOvgfyvg7kSOywyko
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811946"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811946"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151843"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151843"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:30 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v11 060/113] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
Date:   Thu, 12 Jan 2023 08:32:08 -0800
Message-Id: <88705015ec8c4fbdc20d4a4518db8f8fb63ab109.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Introduce a helper to directly (pun intended) fault-in a TDP page
without having to go through the full page fault path.  This allows
TDX to get the resulting pfn and also allows the RET_PF_* enums to
stay in mmu.c where they belong.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 44 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 50d240d52697..e2a0dfbee56d 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -154,6 +154,9 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 					  vcpu->arch.mmu->root_role.level);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level);
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4f3f4cdc67ed..4058545a4851 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4524,6 +4524,50 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level)
+{
+	int r;
+	struct kvm_page_fault fault = (struct kvm_page_fault) {
+		.addr = gpa,
+		.error_code = error_code,
+		.exec = error_code & PFERR_FETCH_MASK,
+		.write = error_code & PFERR_WRITE_MASK,
+		.present = error_code & PFERR_PRESENT_MASK,
+		.rsvd = error_code & PFERR_RSVD_MASK,
+		.user = error_code & PFERR_USER_MASK,
+		.prefetch = false,
+		.is_tdp = true,
+		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
+		.is_private = kvm_is_private_gpa(vcpu->kvm, gpa),
+	};
+
+	WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
+	fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
+	fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
+
+	if (mmu_topup_memory_caches(vcpu, false))
+		return KVM_PFN_ERR_FAULT;
+
+	/*
+	 * Loop on the page fault path to handle the case where an mmu_notifier
+	 * invalidation triggers RET_PF_RETRY.  In the normal page fault path,
+	 * KVM needs to resume the guest in case the invalidation changed any
+	 * of the page fault properties, i.e. the gpa or error code.  For this
+	 * path, the gpa and error code are fixed by the caller, and the caller
+	 * expects failure if and only if the page fault can't be fixed.
+	 */
+	do {
+		fault.max_level = max_level;
+		fault.req_level = PG_LEVEL_4K;
+		fault.goal_level = PG_LEVEL_4K;
+
+		r = direct_page_fault(vcpu, &fault);
+	} while (r == RET_PF_RETRY && !is_error_noslot_pfn(fault.pfn));
+	return fault.pfn;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
-- 
2.25.1

