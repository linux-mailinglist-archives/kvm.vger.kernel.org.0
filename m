Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4219775330B
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbjGNHVE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbjGNHUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:20:53 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828C33AA1;
        Fri, 14 Jul 2023 00:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319231; x=1720855231;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=1HwyvtI1AZxHBRdttaQhXcm1l9EvNjwuOZBpeJuX3yg=;
  b=bS3ASxC4++J+v0ACTGIQdW8A7KpwLmhnHudscuJA0FDsnkb8BbYMmNNH
   8Cx/aX0vyBLlevN3cWx2jzn/OTYMWHlBvGx5oYmirH5PSAQnN6y8/taia
   LT2gKeSugQnz9cp0O+7FqXl4VTIotqnc/THtNgYkmL77s3tNAjlg4YYUE
   zpj/dizHdCV34ws2EyRdKoPc2NRM1TLQbbePuVyrFmFl+pPmA3VqFyAcf
   ks4FqbWfcRKksSuNboA57MrpSZwtX4jz/1MBL+5UDkcs4GZVY+fHRrfY2
   KL+P3Pht2kKeHj/rM693iQ0ksmMhdl2GplmX+nqpTxwpGUa9O6xpko5UD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="396222339"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="396222339"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:20:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="1052956624"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="1052956624"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:20:29 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 08/12] KVM: x86: centralize code to get CD=1 memtype when guest MTRRs are honored
Date:   Fri, 14 Jul 2023 14:53:56 +0800
Message-Id: <20230714065356.20620-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230714064656.20147-1-yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Centralize the code to get cache disabled memtype when guest MTRRs are
honored. If a TDP honors guest MTRRs, it is required to call the provided
API to get the memtype for CR0.CD=1.

This is the preparation patch for later implementation of fine-grained gfn
zap for CR0.CD toggles when guest MTRRs are honored.

No functional change intended.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mtrr.c    | 16 ++++++++++++++++
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 arch/x86/kvm/x86.h     |  2 ++
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 3ce58734ad22..64c6daa659c8 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -721,3 +721,19 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 	return type == mtrr_default_type(mtrr_state);
 }
+
+/*
+ * this routine is supposed to be called when guest mtrrs are honored
+ */
+void kvm_honors_guest_mtrrs_get_cd_memtype(struct kvm_vcpu *vcpu,
+					   u8 *type, bool *ipat)
+{
+	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED)) {
+		*type = MTRR_TYPE_WRBACK;
+		*ipat = false;
+	} else {
+		*type = MTRR_TYPE_UNCACHABLE;
+		*ipat = true;
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_honors_guest_mtrrs_get_cd_memtype);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c1e93678cea4..7fec1ee23b54 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7573,11 +7573,11 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
 	if (kvm_read_cr0_bits(vcpu, X86_CR0_CD)) {
-		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-			return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
-		else
-			return (MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT) |
-				VMX_EPT_IPAT_BIT;
+		bool ipat;
+		u8 cache;
+
+		kvm_honors_guest_mtrrs_get_cd_memtype(vcpu, &cache, &ipat);
+		return cache << VMX_EPT_MT_EPTE_SHIFT | (ipat ? VMX_EPT_IPAT_BIT : 0);
 	}
 
 	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 82e3dafc5453..e7733dc4dccc 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -313,6 +313,8 @@ int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
 bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 					  int page_num);
+void kvm_honors_guest_mtrrs_get_cd_memtype(struct kvm_vcpu *vcpu,
+					   u8 *type, bool *ipat);
 bool kvm_vector_hashing_enabled(void);
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
 int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
-- 
2.17.1

