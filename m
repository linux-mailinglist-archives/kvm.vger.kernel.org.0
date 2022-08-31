Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71235A8AEE
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 03:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiIABhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 21:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiIABhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 21:37:12 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995BB15C7A4;
        Wed, 31 Aug 2022 18:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661996230; x=1693532230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QQZXyrfCFB2SIU10xprMsEt/LgTiLGVOqV7GcDK0KV4=;
  b=WFE8nfPxTZWkirf/PLV6ZVtAmk+LXjxgMt5YuLaBjDvIRQDsT3krQh7v
   cFf6LbnY5bXU9SjYyrUFQQV2srxcj8P7XsVtHlEeQqtcCrGAAdATJSTuQ
   gsHGsr9wKJDG1f/tJa+9GDML032YQUCtYF2P9wP9ZU13Y34jD7qzzs8Yz
   p7AjUskYRrclPNIDQ/8FP1f3FBGo0ayEls4GeQmnWU7VH8/FuDNzOGO7T
   +Io1TAJYE9gcjBOj6qSu5fbzx6mS+zS841AtREk6YcfeSAs6Iah4Bmi9v
   FmVot9IY+oovj+qeCK8dNJcnTsdPGk3LNYOCq+fmDeLXC2RegrImwiLRg
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="321735100"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="321735100"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="754626038"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 18:37:02 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org
Cc:     like.xu.linux@gmail.com, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] KVM: x86/vmx: Clear Arch LBREn bit before inject #DB to guest
Date:   Wed, 31 Aug 2022 18:34:35 -0400
Message-Id: <20220831223438.413090-13-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220831223438.413090-1-weijiang.yang@intel.com>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On a debug breakpoint event (#DB), IA32_LBR_CTL.LBREn is cleared.
So need to clear the bit manually before inject #DB.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Message-Id: <20220517154100.29983-14-weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9d50e3703ea2..dddba2a48542 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1687,6 +1687,20 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
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
@@ -1722,6 +1736,9 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
 
 	vmx_clear_hlt(vcpu);
+
+	if (nr == DB_VECTOR)
+		disable_arch_lbr_ctl(vcpu);
 }
 
 static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
@@ -4886,6 +4903,9 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
 
 	vmx_clear_hlt(vcpu);
+
+	if (vcpu->arch.exception.nr == DB_VECTOR)
+		disable_arch_lbr_ctl(vcpu);
 }
 
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu)
-- 
2.27.0

