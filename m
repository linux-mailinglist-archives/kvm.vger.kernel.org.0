Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8070576260B
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjGYWR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjGYWQO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:16:14 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB43430EA;
        Tue, 25 Jul 2023 15:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323351; x=1721859351;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wvj0sNH9JtePwrau64elH2rCIjd14dw+JkGIDo/IbFM=;
  b=Qyx0cowZ3xtSX3QO0zhDTKnQotr9aki1CNjId3JEKoUUMArM0RO65jf+
   YXI3LG6HarqQDw8YE6P0cBOdPzSGDhyW/XM9whv88l2ydLtNF4e7bHHxi
   tgWeikVh9QwStZDpWt88uuUMjKKZcfofRBGiEMmVoO+a4OvqbaSyHF78v
   D2VW0p6QfYbpomBQjU7uZ4Ie6kmHsC0W5eEiYtepse7ID48B0nBC+Tp+P
   ZpCevIqyt3MDYsf6beMikhHnCl9mCqTtlkbXlN9xTuChK4CoOBpXvQ10/
   gbYwWfJxgBQeSPp1z3BmFgvxeItknJ9rrQJoxOuB73SExwPCLKj5eNmQr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882511"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882511"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001771"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001771"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:49 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v15 058/115] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
Date:   Tue, 25 Jul 2023 15:14:09 -0700
Message-Id: <6a4c029af70d41b63bcee3d6a1f0c2377f6eb4bd.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
v14 -> v15:
- Remove loop in kvm_mmu_map_tdp_page() and return error code based on
  RET_FP_xxx value to avoid potential infinite loop.  The caller should
  loop on -EAGAIN instead now.
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 58 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 801e3d6b572d..1bca16217da3 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -174,6 +174,9 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
 	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
 }
 
+int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+			 int max_level);
+
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e9343e759f6..7ef66d8a785b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4673,6 +4673,64 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
+int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
+			 int max_level)
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
+		.is_private = error_code & PFERR_GUEST_ENC_MASK,
+		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
+	};
+
+	WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
+	fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
+	fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
+
+	r = mmu_topup_memory_caches(vcpu, false);
+	if (r)
+		return r;
+
+	fault.max_level = max_level;
+	fault.req_level = PG_LEVEL_4K;
+	fault.goal_level = PG_LEVEL_4K;
+
+#ifdef CONFIG_X86_64
+	if (tdp_mmu_enabled)
+		r = kvm_tdp_mmu_page_fault(vcpu, &fault);
+	else
+#endif
+		r = direct_page_fault(vcpu, &fault);
+
+	if (is_error_noslot_pfn(fault.pfn) || vcpu->kvm->vm_bugged)
+		return -EFAULT;
+
+	switch (r) {
+	case RET_PF_RETRY:
+		return -EAGAIN;
+
+	case RET_PF_FIXED:
+	case RET_PF_SPURIOUS:
+		return 0;
+
+	case RET_PF_CONTINUE:
+	case RET_PF_EMULATE:
+	case RET_PF_INVALID:
+	case RET_PF_USER:
+	default:
+		return -EIO;
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
-- 
2.25.1

