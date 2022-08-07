Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E8858BD20
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbiHGWFC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235324AbiHGWDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:03:10 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B522B64F6;
        Sun,  7 Aug 2022 15:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909764; x=1691445764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZB5jllOGvlju3MAuaJoUn61WKZ/LX+iD2tVH/KhjmM0=;
  b=Gkxd5NBtbPAzOSXfsSYx+f+UG0dCEy2JUGPKpTPvMwWsTq2Z+V2ElAQ4
   G4cotVS6Wlup471R0Ib1TiJH6hZRdqqOb54+SijcB3ETc8xWxq4Ypdw59
   7Yk7T0ZIk6yXxXMpdjs2LwIdTbj7SbkzVA+2Z1sjMVd81LKbwqiSShZ+T
   883hEezCQgj9rFKrI+FHkYRqvoyv9bi9os/CYh9cRaOeZIj3fLMZ1G73G
   4dl8crNn0sE6oTIxjiRYIhCjcHmuMHRuyHhW+sZ6SWW/27jKuSIBxwqcG
   SOrsqIayFjQc9n65sihrkHzPUaTRedL6Y9hxVfWraT8tAyHfuAP4WjDgv
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="291695698"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="291695698"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:38 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682631"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:37 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 057/103] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
Date:   Sun,  7 Aug 2022 15:01:42 -0700
Message-Id: <b77b8c177b4c0593c573d87e40057905e1e17261.1659854790.git.isaku.yamahata@intel.com>
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
index dea9f2ed0177..14f795f6db3a 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -152,6 +152,9 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 					  vcpu->arch.mmu->root_role.level);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level);
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c9c27945ed44..00f797c83300 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4416,6 +4416,45 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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

