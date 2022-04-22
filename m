Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C5150B24E
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 09:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445300AbiDVH7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 03:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445234AbiDVH63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 03:58:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CDC35AAE;
        Fri, 22 Apr 2022 00:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650614137; x=1682150137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gUp44i8Naki5lDt9tOj9xLEvcVPgAwywj1dvc2SS7n8=;
  b=UKBCPuABQKORC4z8GHYurvs/GM9eNminLEjJNQShvEIKyZF6jbYejqy+
   /MUxSX0ESLXxMTEgeFxQ/a6JtdLHvzOXKmbb8CNErik/lhCTJ1KDQVED6
   TnhRtjCuQYacam4gSfsGTPORNpDAQilrMg39z+aNGw38bzwXAC40vq/Jg
   mjFeqIcGgyK9zOc73btkul9TzxWmKFi8SG765RxYEXS5NeJW3yEI5PnQ4
   Aupq7C4jXBGdEi3ejCet3WnPGvRPwUMT4tpKkbPSO6j96RUBluasFiDpY
   ociHoaRh671MGafm6Ia5LKRY5eH3HJu1U+QskjVWNfrncKLu2cpbX9rqz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264384836"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="264384836"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="577741364"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 13/16] KVM: x86/vmx: Clear Arch LBREn bit before inject #DB to guest
Date:   Fri, 22 Apr 2022 03:55:06 -0400
Message-Id: <20220422075509.353942-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220422075509.353942-1-weijiang.yang@intel.com>
References: <20220422075509.353942-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a debug breakpoint event (#DB), IA32_LBR_CTL.LBREn is cleared.
So need to clear the bit manually before inject #DB.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8962a8bab5eb..8c2a4c6923a2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1605,6 +1605,27 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 }
 
+static void flip_arch_lbr_ctl(struct kvm_vcpu *vcpu, bool on)
+{
+	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
+	    test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
+	    lbr_desc->event) {
+		u64 old = vmcs_read64(GUEST_IA32_LBR_CTL);
+		u64 new;
+
+		if (on)
+			new = old | ARCH_LBR_CTL_LBREN;
+		else
+			new = old & ~ARCH_LBR_CTL_LBREN;
+
+		if (old != new)
+			vmcs_write64(GUEST_IA32_LBR_CTL, new);
+	}
+}
+
 static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1640,6 +1661,9 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 
 	vmx_clear_hlt(vcpu);
+
+	if (nr == DB_VECTOR)
+		flip_arch_lbr_ctl(vcpu, false);
 }
 
 static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
@@ -4640,6 +4664,9 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
 
 	vmx_clear_hlt(vcpu);
+
+	if (vcpu->arch.exception.nr == DB_VECTOR)
+		flip_arch_lbr_ctl(vcpu, false);
 }
 
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu)
-- 
2.27.0

