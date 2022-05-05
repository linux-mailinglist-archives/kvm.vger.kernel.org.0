Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8003151C76B
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383674AbiEESWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383229AbiEESTm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:42 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5453562CD;
        Thu,  5 May 2022 11:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774554; x=1683310554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r2/5ldw5pVUVlMl5ZifuzWjDJnhnIJbR7f7gWYsK9LU=;
  b=eeGXkpLOfpsQKkghs9OP1ULd2s3qnyTwynBe6Pgx2tfsxvKsq8UzzwZL
   q5WzZvfPZbpZ9k6DSu3zOir5UAsdj/RkKTacnsBrTKfVDqhRjnsddR8Rz
   vBmzigo1NoD87vfoVn1GfNcb+IcLmADUdg9c2jhjVb3u/JrsHxp7FMjmB
   r1i5oO3D4/z/x0/jlMgUESgPV4J28sADrhozoBNEGgNqDGIMOxgydj3Ez
   xwqaPcs0+6ekva0RSfl0hNRvHXVttukzageUtZU4dx9p4zcInoMNxD5UU
   2KRPMD7auPv70FrGKxV1Iknf0fFtWpUrFq21ItoFsAHpzOdPWj36oGa40
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="268354849"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="268354849"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:49 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083358"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:49 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 059/104] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
Date:   Thu,  5 May 2022 11:14:53 -0700
Message-Id: <8ef4dd02cdbdbee00064c35c22b753ef32a20c90.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index beff084d6cd3..6606f790ae0b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -254,6 +254,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return vcpu->arch.mmu->page_fault(vcpu, &fault);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level);
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 497e2b9e58cc..643b33c75ae9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4276,6 +4276,45 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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

