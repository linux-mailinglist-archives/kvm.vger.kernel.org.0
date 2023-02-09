Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE5E68FD38
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 03:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbjBICl0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 21:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjBIClM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 21:41:12 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA0E298D3
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 18:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675910471; x=1707446471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f4c+4rbcLOuQBC1W2OrxmHCNgXQzMowUv3YVvBsFF88=;
  b=BCpjqpPwFPO8Z7hwlYgbdYCMch4du9fpWqpzd346zupCqmihI6tgtkgv
   RLRcQ2jO0q44d8G6V9hfV5fHJs4AX8gdHySBUqrrmmC1+HlQAvSqIhzse
   jP2NxwZsddK4WtQgC6tUFZ2niq4CtRc68s6WXdTajtNIHo4swj5gN61Qf
   NUncb9oDztX69Ec3S5cVSMiqAEKFuNu01AuU92QwLBUgrxT4aC61GhrGw
   Nnor1EYRNa9yge0dAkCHQdl7P/p+CRwdnWCdCBFNfpOXG4OQ9IQmEAQdS
   /QPF3QMYC+inycWcxD9MoGu7XJ58/Jk1KqcDfRCRVIRMGNFOQs9d1RS/x
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="394586643"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="394586643"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 18:41:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="645094415"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="645094415"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 08 Feb 2023 18:41:07 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v4 5/9] KVM: x86: Untag LAM bits when applicable
Date:   Thu,  9 Feb 2023 10:40:18 +0800
Message-Id: <20230209024022.3371768-6-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230209024022.3371768-1-robert.hu@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define kvm_untagged_addr() per LAM feature spec: Address high bits are sign
extended, from highest effective address bit.
Note that LAM_U48 and LA57 has some effective bits overlap. This patch
gives a WARN() on that case.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c |  3 +++
 arch/x86/kvm/x86.c     |  4 ++++
 arch/x86/kvm/x86.h     | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 66edd091f145..e4f14d1bdd2f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2163,6 +2163,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    (!msr_info->host_initiated &&
 		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
 			return 1;
+
+		data = kvm_untagged_addr(data, vcpu);
+
 		if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
 		    (data & MSR_IA32_BNDCFGS_RSVD))
 			return 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 312aea1854ae..1bdc8c0c80c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1809,6 +1809,10 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 	case MSR_KERNEL_GS_BASE:
 	case MSR_CSTAR:
 	case MSR_LSTAR:
+		/*
+		 * The strict canonical checking still applies to MSR
+		 * writing even LAM is enabled.
+		 */
 		if (is_noncanonical_address(data, vcpu))
 			return 1;
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 8ec5cc983062..7228895d4a6f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -201,6 +201,38 @@ static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
 	return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
 }
 
+#ifdef CONFIG_X86_64
+/* untag addr for guest, according to vCPU CR3 and CR4 settings */
+static inline u64 kvm_untagged_addr(u64 addr, struct kvm_vcpu *vcpu)
+{
+	if (addr >> 63 == 0) {
+		/* User pointers */
+		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
+			addr = __canonical_address(addr, 57);
+		else if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U48) {
+			/*
+			 * If guest enabled 5-level paging and LAM_U48,
+			 * bit 47 should be 0, bit 48:56 contains meta data
+			 * although bit 47:56 are valid 5-level address
+			 * bits.
+			 * If LAM_U48 and 4-level paging, bit47 is 0.
+			 */
+			WARN_ON(addr & _BITUL(47));
+			addr = __canonical_address(addr, 48);
+		}
+	} else if (kvm_read_cr4(vcpu) & X86_CR4_LAM_SUP) { /* Supervisor pointers */
+		if (kvm_read_cr4(vcpu) & X86_CR4_LA57)
+			addr = __canonical_address(addr, 57);
+		else
+			addr = __canonical_address(addr, 48);
+	}
+
+	return addr;
+}
+#else
+#define kvm_untagged_addr(addr, vcpu)	(addr)
+#endif
+
 static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
 					gva_t gva, gfn_t gfn, unsigned access)
 {
-- 
2.31.1

