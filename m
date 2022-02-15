Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870FF4B8585
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 11:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbiBPK1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 05:27:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232893AbiBPK1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 05:27:12 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474552128BB;
        Wed, 16 Feb 2022 02:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645007216; x=1676543216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CGCjQKZaE1r0V1TsS5putV3Pf9NikbURFJykxvSAm0U=;
  b=klwW7RNIdAQBaLWdr9qBy3eKNsplbIRacZm4OK+A1LSBu6aCIGFli/oo
   v5ttbEI2OQAqdm+V7ZZUeFhbdCRqWCHkJZoUO7GGt2D8yDHpk5RoUZvb4
   XYm6pFxpkpmgcUs440zP4Qk/fDPQhjUasALnYlMBr1vHxdd0tumuqKnSA
   jp/4GG5KWjfr4gcWcJZCkKX8CWoAbM2lOSEAf36xKDIDJdGt8EzT7+U8b
   Wbh1VTKh17fnuO6RUtNRPGgveKoPbjw7s3IgNDtYKvH7lcsKIjytvJU5m
   9dR4qwkPpIUf5ccgo76j9AKlBm22d3p1uzJqz0AcDaju48ri2Ki9cxKgM
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="250312481"
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="250312481"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,373,1635231600"; 
   d="scan'208";a="498708629"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 02:26:51 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 15/17] KVM: x86/vmx: Flip Arch LBREn bit on guest state change
Date:   Tue, 15 Feb 2022 16:25:42 -0500
Message-Id: <20220215212544.51666-16-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220215212544.51666-1-weijiang.yang@intel.com>
References: <20220215212544.51666-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
index e7969884d90e..92bdb4101a08 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4603,6 +4603,8 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!init_event) {
 		if (static_cpu_has(X86_FEATURE_ARCH_LBR))
 			vmcs_write64(GUEST_IA32_LBR_CTL, 0);
+	} else {
+		flip_arch_lbr_ctl(vcpu, false);
 	}
 }
 
@@ -7694,6 +7696,7 @@ static int vmx_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	vmx->nested.smm.vmxon = vmx->nested.vmxon;
 	vmx->nested.vmxon = false;
 	vmx_clear_hlt(vcpu);
+	flip_arch_lbr_ctl(vcpu, false);
 	return 0;
 }
 
@@ -7715,6 +7718,7 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 		vmx->nested.nested_run_pending = 1;
 		vmx->nested.smm.guest_mode = false;
 	}
+	flip_arch_lbr_ctl(vcpu, true);
 	return 0;
 }
 
-- 
2.27.0

