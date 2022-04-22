Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC61B50B26D
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 09:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445312AbiDVH7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 03:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445241AbiDVH6a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 03:58:30 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6993837A95;
        Fri, 22 Apr 2022 00:55:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650614138; x=1682150138;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QPQZgN76ZKwxqlnIKAFB0K/Rb6aYGDThbRFdYJP8k+c=;
  b=gZfmKymWlkdmIfxsiSzkJrvNBCO5B0CzhZB6NBNMSogab7r/gE0uXMIG
   jQ6mTJCP+unJ0tc+Bh6jBvgTuiXcXYdSjos8QkN3zBqFCL/B4MJEgRfHk
   f4HwVgHsPxn/9HpVX+BTkrhdlIpoFX7nMl7CLKOxWGARLOjI0V1H5QbCT
   l5/4y8XEoK5jLYOqAHso7ykQwgGsSNErXjbt0DS6H0QBY2vS0mmu+1hCo
   C1shTkGeRlxFp+uK1aoJ3QUpOVM4D1Ruy2heO1Uv2FewmWwQTMwJgfDKB
   JW1vZGiOuFNP9cKXp+71imrjWLnwmRDg94vljOkUZ06fLGuGo86C5hD35
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="264384837"
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="264384837"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
X-IronPort-AV: E=Sophos;i="5.90,281,1643702400"; 
   d="scan'208";a="577741367"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 00:55:30 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v10 14/16] KVM: x86/vmx: Flip Arch LBREn bit on guest state change
Date:   Fri, 22 Apr 2022 03:55:07 -0400
Message-Id: <20220422075509.353942-15-weijiang.yang@intel.com>
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

Per spec:"IA32_LBR_CTL.LBREn is saved and cleared on #SMI, and restored
on RSM. On a warm reset, all LBR MSRs, including IA32_LBR_DEPTH, have their
values preserved. However, IA32_LBR_CTL.LBREn is cleared to 0, disabling
LBRs." So clear Arch LBREn bit on #SMI and restore it on RSM manully, also
clear the bit when guest does warm reset.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8c2a4c6923a2..d58d50730efa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4588,6 +4588,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!init_event) {
 		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
 			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
+	} else {
+		flip_arch_lbr_ctl(vcpu, false);
 	}
 }
 
@@ -7699,6 +7701,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	vmx->nested.smm.vmxon = vmx->nested.vmxon;
 	vmx->nested.vmxon = false;
 	vmx_clear_hlt(vcpu);
+	flip_arch_lbr_ctl(vcpu, false);
 	return 0;
 }
 
@@ -7720,6 +7723,7 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 		vmx->nested.nested_run_pending = 1;
 		vmx->nested.smm.guest_mode = false;
 	}
+	flip_arch_lbr_ctl(vcpu, true);
 	return 0;
 }
 
-- 
2.27.0

