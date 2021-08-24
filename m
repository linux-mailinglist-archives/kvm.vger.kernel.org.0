Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EBB3F5943
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 09:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbhHXHnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 03:43:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:63755 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235255AbhHXHnU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 03:43:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="217260197"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="217260197"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 00:41:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="473402204"
Received: from michael-optiplex-9020.sh.intel.com ([10.239.159.182])
  by orsmga008.jf.intel.com with ESMTP; 24 Aug 2021 00:41:12 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v8 13/15] KVM: x86/vmx: Clear Arch LBREn bit before inject #DB to guest
Date:   Tue, 24 Aug 2021 15:56:15 +0800
Message-Id: <1629791777-16430-14-git-send-email-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
References: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
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
index b8152b569e69..316403cb4038 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1601,6 +1601,27 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
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
@@ -1636,6 +1657,9 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 
 	vmx_clear_hlt(vcpu);
+
+	if (nr == DB_VECTOR)
+		flip_arch_lbr_ctl(vcpu, false);
 }
 
 static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
@@ -4572,6 +4596,9 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
 
 	vmx_clear_hlt(vcpu);
+
+	if (vcpu->arch.exception.nr == DB_VECTOR)
+		flip_arch_lbr_ctl(vcpu, false);
 }
 
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu)
-- 
2.25.1

