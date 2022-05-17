Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D6352A723
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 17:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350561AbiEQPmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 11:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350531AbiEQPll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 11:41:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C39E4130C;
        Tue, 17 May 2022 08:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652802100; x=1684338100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wK3Y+6EDmndUGmnTsDKzBkfbQjZW/GJsQXQdZFLCdc0=;
  b=iJYBIxvPraWXMR3dIik0YwPeedxJQVQvFjXGBjBZOastp0XJ1GcRU6oU
   zMnLucOwbJvLQJbamETYrLj4OE0f64dFMRQAM9PIalWCyvqtUw+C/rQQ8
   d/DjDGDKAZpOmg7Vg/w9Zh0Rfgha5kpZPA0Lst3MY2jX6VlViTkRWSR+O
   sGHiNbDazD0crEe0Yob0BRxmvY+y0JSExMzoUHtF2ZPsaqWC1STXQj7TU
   YWX37VQDQcTqjzsmuNm9E2j3KJIrhFDNX4TMtbxeupF9rbAVmCrY4KKYp
   R+fcfzr5dPPcD1hUUPWZfnrh1791D1Pwd0cpO706Hro24eD3Wc0IfLt/Y
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="357632115"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="357632115"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="626533603"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 08:41:35 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 13/16] KVM: x86/vmx: Clear Arch LBREn bit before inject #DB to guest
Date:   Tue, 17 May 2022 11:40:57 -0400
Message-Id: <20220517154100.29983-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220517154100.29983-1-weijiang.yang@intel.com>
References: <20220517154100.29983-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a debug breakpoint event (#DB), IA32_LBR_CTL.LBREn is cleared.
So need to clear the bit manually before inject #DB.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1b7194b9b6bc..7dfa961d6829 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1608,6 +1608,20 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
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
 static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1643,6 +1657,9 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 
 	vmx_clear_hlt(vcpu);
+
+	if (nr == DB_VECTOR)
+		disable_arch_lbr_ctl(vcpu);
 }
 
 static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
@@ -4733,6 +4750,9 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
 
 	vmx_clear_hlt(vcpu);
+
+	if (vcpu->arch.exception.nr == DB_VECTOR)
+		disable_arch_lbr_ctl(vcpu);
 }
 
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu)
-- 
2.27.0

