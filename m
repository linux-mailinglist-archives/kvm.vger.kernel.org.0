Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18C26383DF
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 07:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiKYGKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 01:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiKYGKU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 01:10:20 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA9E22B1C;
        Thu, 24 Nov 2022 22:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669356613; x=1700892613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B/nXKs95F6cYlY8EdEbdbW8W7+97emyxpTHZVVLBCto=;
  b=nLcoIkm0rcAFXHqueAmyZzoi8L60l7Cm70dS/10EctVGC18pY4JvFWJ1
   0xCrcSKyAbgcaacAw8KF0xIfOBOo3fMzJZxewvi6/Y4ofKaXFuRl7dIib
   dSGX2NbC/0bzoF7uGEIVef0IIF1INCnubbsl1smr9Lm1CsTEbvm+XKwR6
   zmgEy0aEI92E9IaAJqfnRBjv3gancxGNLqp9dkvHjylyZ/HZFNQZIuyWg
   bdkuVPKfTDwQDlGIqUP23eIdKvS3phGy0x6VUUdPjHwNMN28N94h/j+dk
   DwA1aU8CFiTSiIloH4vp1nuIQa3t78L5aH//cmR7NNoJ24KW3fY1wZ0pl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="313116833"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="313116833"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10541"; a="784838505"
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="784838505"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 22:10:08 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, weijiang.yang@intel.com
Subject: [PATCH v2 12/15] KVM: x86/vmx: Disable Arch LBREn bit in #DB and warm reset
Date:   Thu, 24 Nov 2022 23:06:01 -0500
Message-Id: <20221125040604.5051-13-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221125040604.5051-1-weijiang.yang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Per SDM 3B, Chapter 18:
“On a debug breakpoint event (#DB), IA32_LBR_CTL.LBREn is cleared.”
and "On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
LBRs.", clear the bit manually before inject #DB or when vCPU is in warm
reset.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3bc892e8cf7a..6ad765ea4059 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1695,6 +1695,20 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 }
 
+static void disable_arch_lbr_ctl(struct kvm_vcpu *vcpu)
+{
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+	    test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
+	    lbr_desc->event) {
+		u64 ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
+
+		vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ~ARCH_LBR_CTL_LBREN);
+	}
+}
+
 static void vmx_inject_exception(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
@@ -1738,6 +1752,9 @@ static void vmx_inject_exception(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 
 	vmx_clear_hlt(vcpu);
+
+	if (ex->vector == DB_VECTOR)
+		disable_arch_lbr_ctl(vcpu);
 }
 
 static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
@@ -4796,7 +4813,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx_update_fb_clear_dis(vcpu, vmx);
 
-	if (!init_event && cpu_has_vmx_arch_lbr())
+	if (init_event)
+		disable_arch_lbr_ctl(vcpu);
+	else if (cpu_has_vmx_arch_lbr())
 		vmcs_write64(GUEST_IA32_LBR_CTL, 0);
 }
 
@@ -4873,6 +4892,9 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
 
 	vmx_clear_hlt(vcpu);
+
+	if (vcpu->arch.exception.vector == DB_VECTOR)
+		disable_arch_lbr_ctl(vcpu);
 }
 
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu)
-- 
2.27.0

