Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF130732598
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 05:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239977AbjFPDEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 23:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241534AbjFPDEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 23:04:16 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06F02D60;
        Thu, 15 Jun 2023 20:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884653; x=1718420653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=BbhsWAIbuhRQ7z0GhXvz/jeDOJUZBkuqg3ejQ3AlksA=;
  b=ZN73HhKEUJ7uhNxX2fVuQgSYasuT2ipt5XCONxF1vCe5aPaDmDcck1/L
   xLdcVUcxQ+T/YMnDzCzsP81kHQj+6BrFiXovIcRXHvzofaIDQ6yLzVZeO
   QaT6cVdpeJhjQ7vb0igiL7mKDSxfNQmkW/O8hV1kFnsCAo7jKjVJQz88c
   n/tmBbLEms9XzrWc8mVJMyQVLFdpJuOrPIHeQWYzRCkWEFhLJ2lgJ6Wbl
   NT7i5qaYo+Cw9ahDfkk9Yrd6QZRmO2A4mmqNoxTacSHYXTo3N6OIlMtgG
   atCm3lC+My4w37+XNvIhCtH9VNc2YrFhiPqoCc1wximuzBVg1kpG8UkXQ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="445482463"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="445482463"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:04:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="690037834"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="690037834"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:04:08 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 08/11] KVM: x86: move vmx code to get EPT memtype when CR0.CD=1 to x86 common code
Date:   Fri, 16 Jun 2023 10:38:58 +0800
Message-Id: <20230616023858.7503-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230616023101.7019-1-yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move code in vmx.c to get cache disabled memtype when non-coherent DMA
present to x86 common code.

This is the preparation patch for later implementation of fine-grained gfn
zap for CR0.CD toggles when guest MTRRs are honored.

No functional change intended.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mtrr.c    | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c | 10 +++++-----
 arch/x86/kvm/x86.h     |  1 +
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 3ce58734ad22..b35dd0bc9cad 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -721,3 +721,22 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 
 	return type == mtrr_default_type(mtrr_state);
 }
+
+void kvm_mtrr_get_cd_memory_type(struct kvm_vcpu *vcpu, u8 *type, bool *ipat)
+{
+	/*
+	 * this routine is supposed to be called when guest mtrrs are honored
+	 */
+	if (unlikely(!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))) {
+		*type = MTRR_TYPE_WRBACK;
+		*ipat = true;
+	} else if (unlikely(!kvm_check_has_quirk(vcpu->kvm,
+			    KVM_X86_QUIRK_CD_NW_CLEARED))) {
+		*type = MTRR_TYPE_UNCACHABLE;
+		*ipat = true;
+	} else {
+		*type = MTRR_TYPE_WRBACK;
+		*ipat = false;
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_mtrr_get_cd_memory_type);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c1e93678cea4..6414c5a6e892 100644
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
+		kvm_mtrr_get_cd_memory_type(vcpu, &cache, &ipat);
+		return cache << VMX_EPT_MT_EPTE_SHIFT | (ipat ? VMX_EPT_IPAT_BIT : 0);
 	}
 
 	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 82e3dafc5453..9781b4b32d68 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -313,6 +313,7 @@ int kvm_mtrr_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
 bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 					  int page_num);
+void kvm_mtrr_get_cd_memory_type(struct kvm_vcpu *vcpu, u8 *type, bool *ipat);
 bool kvm_vector_hashing_enabled(void);
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
 int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
-- 
2.17.1

