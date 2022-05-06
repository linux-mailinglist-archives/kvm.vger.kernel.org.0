Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123C951CFB8
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 05:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388733AbiEFDhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 23:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388672AbiEFDhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 23:37:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B49664719;
        Thu,  5 May 2022 20:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651808016; x=1683344016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tNs4PXFwFPgfCub0YOsbyMeXEVpdoiIrPI5PideJQQs=;
  b=Wv2MjTQVmBYaL4AL1Pje3VG7FPBXGU6YVLMxeD37akckxXvdwg299RAB
   AOq+MG8y8ZWFoWedPptJkkbKfU4kEKYtlRkE6JQpaICmBSulx3yEaY/OW
   M1WF0KAEBXB5fWN9wXajb9/iOBEfRVBFpkPPWoz5JrZjEWg7gVpzlq4eP
   0k/HymBWPrWEsWAzid/1/4O+W5laYKYiBF6NV+iKxm3IRTPlg5aGvg8bW
   OB1MzttJ34F4aeBHR8uXMoEiXZV/ivnUeUhjgyutyK0Yb7JjnQC2FbtnD
   vlLjrFXCQ37pz92ozWfcobXnkdHPe91CqI5s/e6eZ43RkjV3iRxCvfH2P
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248241445"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248241445"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:35 -0700
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="632745204"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 20:33:35 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        kan.liang@linux.intel.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v11 13/16] KVM: x86/vmx: Clear Arch LBREn bit before inject #DB to guest
Date:   Thu,  5 May 2022 23:33:02 -0400
Message-Id: <20220506033305.5135-14-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220506033305.5135-1-weijiang.yang@intel.com>
References: <20220506033305.5135-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index e6384ef1d115..6d6ee9cf82f5 100644
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
@@ -4645,6 +4669,9 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
 
 	vmx_clear_hlt(vcpu);
+
+	if (vcpu->arch.exception.nr == DB_VECTOR)
+		flip_arch_lbr_ctl(vcpu, false);
 }
 
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu)
-- 
2.27.0

