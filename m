Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785CA6E1CA6
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 08:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjDNG3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 02:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjDNG3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 02:29:16 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EDC7ECB;
        Thu, 13 Apr 2023 23:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681453726; x=1712989726;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yxXdxmEirAw6zmyoyfst+wvzy0+xFYrOs9/OP2pUIng=;
  b=YmxcJp97W9N9l3VB9Z5ZHiIRsJAlZsO5bG2oSky39hvNZirnoGsJ3Z2q
   pTCJGWhWnpqh6TEgynRLVyi68WQdIRm7VYGXsV/MbDtiR5NhrBwX+KS55
   EDV7yiR8kPAE/GvykKzH4WZaAjlhIOZEXqBmQPE1ipxcgYaB/hIog6aS/
   1QcEqHceraH9la6YRNvWUTDzLkHAjYnTN7syOZFQj6GREKPwGF3XeFWXF
   dBAT2Yp5T/tAzfzd3CHOegi4eFqb7FeAoB7826xqoULzdOvxdhi+6vAVc
   bzgXuxkRyM9RtBrKXdTSyCRDVN7T73nKDZZSojMZxDNo7cwwDhK8Yzx/4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="341892877"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="341892877"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="935885975"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="935885975"
Received: from spr.sh.intel.com ([10.239.53.106])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 23:26:40 -0700
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jiaan Lu <jiaan.lu@intel.com>, Zhang Chen <chen.zhang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 09/11] KVM: VMX: Advertise MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPORT
Date:   Fri, 14 Apr 2023 14:25:30 +0800
Message-Id: <20230414062545.270178-10-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230414062545.270178-1-chao.gao@intel.com>
References: <20230414062545.270178-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhang Chen <chen.zhang@intel.com>

Allow guest to query if the underying VMM understands BHB-clearing
sequence and report the statue of BHB-clearing sequence in suprevisor
mode i.e. CPL < 3 via MSR_VIRTUAL_MITIGATION_ENUM/CTRL.

Enable BHI_DIS_S for guest if guest is using BHI-clearing sequence and
the sequence isn't effective on the processor.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Jiaan Lu <jiaan.lu@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 25afb4c3e55e..abbbf8e66b53 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1944,8 +1944,10 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 }
 
 #define VIRTUAL_ENUMERATION_VALID_BITS	VIRT_ENUM_MITIGATION_CTRL_SUPPORT
-#define MITI_ENUM_VALID_BITS		MITI_ENUM_RETPOLINE_S_SUPPORT
-#define MITI_CTRL_VALID_BITS		MITI_CTRL_RETPOLINE_S_USED
+#define MITI_ENUM_VALID_BITS		(MITI_ENUM_RETPOLINE_S_SUPPORT | \
+					 MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT)
+#define MITI_CTRL_VALID_BITS		(MITI_CTRL_RETPOLINE_S_USED | \
+					 MITI_CTRL_BHB_CLEAR_SEQ_S_USED)
 
 static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 {
@@ -2496,6 +2498,11 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    arch_msr & ARCH_CAP_RRSBA)
 			spec_ctrl_mask |= SPEC_CTRL_RRSBA_DIS_S;
 
+		if (data & MITI_CTRL_BHB_CLEAR_SEQ_S_USED &&
+		    kvm_cpu_cap_has(X86_FEATURE_BHI_CTRL) &&
+		    !(arch_msr & ARCH_CAP_BHI_NO))
+			spec_ctrl_mask |= SPEC_CTRL_BHI_DIS_S;
+
 		/*
 		 * Intercept IA32_SPEC_CTRL to disallow guest from changing
 		 * certain bits.
-- 
2.40.0

