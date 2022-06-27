Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F3E55D630
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241622AbiF0V4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241371AbiF0Vy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5AE62C7;
        Mon, 27 Jun 2022 14:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366896; x=1687902896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TDas0SY5LGuB3YFSoxWratEBm3xzPtHTIHsSA08WIYE=;
  b=JQuVX8Ode8nRGb8SxjO/ndr4g/XzIpZSwPzkXdtbE3sVtQ6KmvHm3anF
   M7lIFv3I4uWlmLc3VOjBh1Yj6AfjgWduBz+V9KCNVpkVne3fDCsMb7Kbs
   HW6jp2t8JDa+ygb1isipPw2VXBiLAfbSTr1TA41VWgwjmRCJnCriTvsVB
   PiwnjMu/IAiJknGJDOWq8qYpyloqyT0/InlvBZDbfbUtX4XFAOBjbSrhN
   D5sA97CFzdMPHQt8rqBWtQOjKjjAeAbzr8ngw+4CS+JNsYkjXehXBp9yT
   DsRPC7ejP9CAEWBkvP2zgOu566wJZW7HK9rZWscpDI33w7yzzgSsZeUAf
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279116096"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="279116096"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:56 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863624"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:56 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v7 058/102] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
Date:   Mon, 27 Jun 2022 14:53:50 -0700
Message-Id: <5b00a098e4f7d0c6af1f5c0f3a8ee8c2af703485.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/mmu.c | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index f5edf2e58dba..ee592348ace1 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -163,6 +163,9 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 					  vcpu->arch.mmu->root_role.level);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level);
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a777a1d4278c..599c81504bea 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4278,6 +4278,45 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
+		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
+		.is_private = kvm_is_private_gpa(vcpu->kvm, gpa),
+	};
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

