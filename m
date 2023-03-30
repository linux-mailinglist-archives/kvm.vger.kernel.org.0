Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C006CFFB8
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 11:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjC3JWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 05:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjC3JWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 05:22:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC6A2102;
        Thu, 30 Mar 2023 02:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680168126; x=1711704126;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RUTz1yJpoX4WIqOuTOq56h0tpzn+Urdd3s0X6SoOXjE=;
  b=A/JI9iSkri1NMOjqFCkjhRxTI1e2yeb/ODZxHqIB+0uqAARzr8QXJH+u
   geXnS7Zkmcb0x8PVdyDpiDdxUB7FDEWchFrPgFApy7iJQIGY+39oks2rI
   pYC2Uzu5YNvcUeNN7OAJ3Fki2BIXTzkDCFWE42kwdSuffiokamlxjTwwO
   pXIUWvKROEZxpwm42Xk65AkSgAVZFWuZPv9aW8aOJo9n4jhLQr+QQx9yC
   c+JU77vRgPl0546qljUayWItoANZmvfo3Y5wmdevsmX9fdROOEXjp/v4G
   13W7Un0AQHWdYnfH6KZhukj91zH+j5/UmT6Obq+sxMtBlz45dOJVSlyUM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="339841741"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="339841741"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 02:22:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="684628845"
X-IronPort-AV: E=Sophos;i="5.98,303,1673942400"; 
   d="scan'208";a="684628845"
Received: from eamaya-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.132.15])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2023 02:22:04 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH] KVM: VMX: Get rid of hard-coded value around IA32_VMX_BASIC
Date:   Thu, 30 Mar 2023 22:21:49 +1300
Message-Id: <20230330092149.101047-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, setup_vmcs_config() uses hard-coded values when performing
sanity check on the value of IA32_VMX_BASIC MSR and setting up the three
members of 'vmcs_config': size, revison_id and basic_cap.  However, the
kernel actually already has macro definitions for those relevant bits in
asm/msr-index.h and functions to get revision_id and size in asm/vmx.h.

Add the missing helper function to get the basic_cap, and use those
macros and helper functions in setup_vmcs_config() to get rid of those
hard-coded values.

No functional change intended.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/vmx.h |  5 +++++
 arch/x86/kvm/vmx/vmx.c     | 17 +++++++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 498dc600bd5c..2b488895fe0e 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -141,6 +141,11 @@ static inline u32 vmx_basic_vmcs_size(u64 vmx_basic)
 	return (vmx_basic & GENMASK_ULL(44, 32)) >> 32;
 }
 
+static inline u32 vmx_basic_cap(u64 vmx_basic)
+{
+	return (vmx_basic & ~GENMASK_ULL(44, 32)) >> 32;
+}
+
 static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
 {
 	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c3ef74562158..8f4982ec3c8c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2597,13 +2597,13 @@ static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			     struct vmx_capability *vmx_cap)
 {
-	u32 vmx_msr_low, vmx_msr_high;
 	u32 _pin_based_exec_control = 0;
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
 	u64 _cpu_based_3rd_exec_control = 0;
 	u32 _vmexit_control = 0;
 	u32 _vmentry_control = 0;
+	u64 basic_msr;
 	u64 misc_msr;
 	int i;
 
@@ -2722,28 +2722,29 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		_vmexit_control &= ~x_ctrl;
 	}
 
-	rdmsr(MSR_IA32_VMX_BASIC, vmx_msr_low, vmx_msr_high);
+	rdmsrl(MSR_IA32_VMX_BASIC, basic_msr);
 
 	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
-	if ((vmx_msr_high & 0x1fff) > PAGE_SIZE)
+	if (vmx_basic_vmcs_size(basic_msr) > PAGE_SIZE)
 		return -EIO;
 
 #ifdef CONFIG_X86_64
 	/* IA-32 SDM Vol 3B: 64-bit CPUs always have VMX_BASIC_MSR[48]==0. */
-	if (vmx_msr_high & (1u<<16))
+	if (basic_msr & VMX_BASIC_64)
 		return -EIO;
 #endif
 
 	/* Require Write-Back (WB) memory type for VMCS accesses. */
-	if (((vmx_msr_high >> 18) & 15) != 6)
+	if (((basic_msr & VMX_BASIC_MEM_TYPE_MASK) >> VMX_BASIC_MEM_TYPE_SHIFT)
+			!= VMX_BASIC_MEM_TYPE_WB)
 		return -EIO;
 
 	rdmsrl(MSR_IA32_VMX_MISC, misc_msr);
 
-	vmcs_conf->size = vmx_msr_high & 0x1fff;
-	vmcs_conf->basic_cap = vmx_msr_high & ~0x1fff;
+	vmcs_conf->size = vmx_basic_vmcs_size(basic_msr);
+	vmcs_conf->basic_cap = vmx_basic_cap(basic_msr);
 
-	vmcs_conf->revision_id = vmx_msr_low;
+	vmcs_conf->revision_id = vmx_basic_vmcs_revision_id(basic_msr);
 
 	vmcs_conf->pin_based_exec_ctrl = _pin_based_exec_control;
 	vmcs_conf->cpu_based_exec_ctrl = _cpu_based_exec_control;

base-commit: 99b30869804ea59d9596cdbefa5cc3aabd588521
-- 
2.39.2

