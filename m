Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14DAF648FBE
	for <lists+kvm@lfdr.de>; Sat, 10 Dec 2022 17:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiLJQTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Dec 2022 11:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiLJQT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Dec 2022 11:19:28 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F87F1A3B8;
        Sat, 10 Dec 2022 08:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670689151; x=1702225151;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X4QhB3OLSQoeCPxb9auXE0M405Iu+KPZQCWwLNnsklY=;
  b=WnvsZCLpD0ycPTr5fe9JARbylMTM/EIPz79IEWZ2MQE9JPNjShbEwrR0
   5MKKFCx89mYNKKCgFjiYxSY2DkXm+AZPazZ+tVQtyRaf2jCbY2QhtiK4s
   XBxLe0LDmhDPGYPD08CdeygsFZBqPZ2cZBB8JDEypMnvTdnE+24tEBc5/
   uiPm/tRpEJ/nic54JG1GxNHnx/a3VhtCKbvqDvyqE5ni1mv4vW6sdF4S/
   Gl6zsldUxA+8iZ+93pbuG+AdkOnGHv8dlnYvWVqJHNi9o4pEjXC8R/CPV
   njC/D89cbnmxXS6U2wI/9OvbSaXeAbAVB4rixGklFZybErMREbcaiIlts
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="318780489"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="318780489"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:19:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10557"; a="711208689"
X-IronPort-AV: E=Sophos;i="5.96,234,1665471600"; 
   d="scan'208";a="711208689"
Received: from unknown (HELO localhost.localdomain) ([10.239.161.133])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2022 08:19:07 -0800
From:   Zhang Chen <chen.zhang@intel.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Zhang Chen <chen.zhang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 7/9] kvm/x86: Add MSR_VIRTUAL_MITIGATION_ENUM/CTRL emulation
Date:   Sun, 11 Dec 2022 00:00:44 +0800
Message-Id: <20221210160046.2608762-8-chen.zhang@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210160046.2608762-1-chen.zhang@intel.com>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce Intel virtual MSR_VIRTUAL_MITIGATION_ENUM(0x50000001)
and MSR_VIRTUAL_MITIGATION_CTRL(0x50000002).
The MSR_VIRTUAL_MITIGATION_ENUM to tell guest about supported
mitigations and enable the MSR_VIRTUAL_MITIGATION_CTRL virtual
MSRs for guest, VMM will help to setup virtual spec ctrl mask
for SPEC_CTRL_RRSBA_DIS_S, SPEC_CTRL_BHI_DIS_S as guest's needs.

Signed-off-by: Zhang Chen <chen.zhang@intel.com>
---
 arch/x86/kvm/vmx/vmx.h | 16 ++++++++++++++++
 arch/x86/kvm/x86.c     |  7 +++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index fc873cf45f70..6abda05cc426 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -29,6 +29,10 @@
 #endif
 
 #define MAX_NR_LOADSTORE_MSRS	8
+#define MITI_ENUM_SUPPORTED	(MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT |          \
+				MITI_ENUM_RETPOLINE_S_SUPPORT)
+#define MITI_CTRL_USED		(MITI_CTRL_BHB_CLEAR_SEQ_S_USED |                 \
+				MITI_CTRL_RETPOLINE_S_USED)
 
 struct vmx_msrs {
 	unsigned int		nr;
@@ -301,6 +305,18 @@ struct vcpu_vmx {
 	u64		      msr_virtual_enumeration;
 	u32		      msr_ia32_umwait_control;
 
+	/*
+	 * Guest read only, Only available if MITIGATION_CTRL_SUPPORT
+	 * is enumerated.
+	 */
+	u64		      msr_virtual_mitigation_enum;
+
+	/*
+	 * Read/Write, Only available if MITIGATION_CTRL_SUPPORT
+	 * is enumerated.
+	 */
+	u64		      msr_virtual_mitigation_ctrl;
+
 	/*
 	 * loaded_vmcs points to the VMCS currently used in this vcpu. For a
 	 * non-nested (L1) guest, it always points to vmcs01. For a nested
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6be0a3f1281f..f6c314def6a8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1533,6 +1533,8 @@ static const u32 emulated_msrs_all[] = {
 	MSR_IA32_VMX_VMFUNC,
 
 	MSR_VIRTUAL_ENUMERATION,
+	MSR_VIRTUAL_MITIGATION_ENUM,
+	MSR_VIRTUAL_MITIGATION_CTRL,
 
 	MSR_K7_HWCR,
 	MSR_KVM_POLL_CONTROL,
@@ -1570,6 +1572,7 @@ static const u32 msr_based_features_all[] = {
 	MSR_IA32_ARCH_CAPABILITIES,
 	MSR_IA32_PERF_CAPABILITIES,
 	MSR_VIRTUAL_ENUMERATION,
+	MSR_VIRTUAL_MITIGATION_ENUM,
 };
 
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
@@ -1671,6 +1674,10 @@ static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
 	case MSR_VIRTUAL_ENUMERATION:
 		msr->data = VIRT_ENUM_MITIGATION_CTRL_SUPPORT;
 		break;
+	case MSR_VIRTUAL_MITIGATION_ENUM:
+		msr->data = MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT |
+			    MITI_ENUM_RETPOLINE_S_SUPPORT;
+		break;
 	default:
 		return static_call(kvm_x86_get_msr_feature)(msr);
 	}
-- 
2.25.1

