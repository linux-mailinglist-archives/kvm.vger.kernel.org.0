Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18EDF7A9C0B
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjIUTF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbjIUTFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:05:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998D5E083
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318599; x=1726854599;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dovjjs6Cwd613M4DckYtJynCmnyAMU353Nvw3+PCAK4=;
  b=Pl5+QQfY7dSYvItWfeNxpz7ii5GgpV7YEeSvEYQGZu6RqIsLp6ZYrycK
   dTyxJPBAazowIoEQZsNnVrBjweBF5Z1gDGMlAQUTfzs9VrPlcTqqqL9ZC
   2zgpkrlI8BLfHvH2ds9haIXmwuuo/65FaNGOXCJjmONdIfjCcIBLfxj52
   +WqRG4Fa/LYFS0Vx4ikAIFnGtltiprHLZ6PHMequymsuCH9wNFzVmNSAd
   nxurrBbG0eBNvZFTxx4NPyVstj49U/FzW5GVR8NrNYcAeLkn0IS4ssUZC
   MaDjX2xMqyIaik0AQW2zNL0MqcdO20XIz689imvTHaIhfVN8GUAA0R7Mj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="359841347"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="359841347"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="747001098"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="747001098"
Received: from dorasunx-mobl1.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.30.47])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:01 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH v2 4/9] KVM: x86/pmu: Add PERF_GLOBAL_STATUS_SET MSR emulation
Date:   Thu, 21 Sep 2023 16:29:52 +0800
Message-Id: <20230921082957.44628-5-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230921082957.44628-1-xiong.y.zhang@intel.com>
References: <20230921082957.44628-1-xiong.y.zhang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The IA32_PERF_GLOBAL_STATUS_SET MSR is introduced with arch PMU
version 4. It allows software to set individual bits in
IA32_PERF_GLOBAL_STATUS MSR. It can be used by a VMM to virtualize the
state of IA32_PERF_GLOBAL_STATUS across VMS.

If the running VM owns the whole PMU, different VM will have different
perf global status, VMM needs to restore IA32_PERF_GLOBAL_STATUS MSR at
VM switch, but IA32_PERF_GLOBAL_STATUS MSR is read only, so VMM can use
IA32_PERF_GLOBAL_STATUS_SET MSR to restore PERF_GLOBAL_STATUS MSR.

This commit adds this MSR emulation, so that L1 VMM could use it. As it
is mainly used by VMM to restore VM's PERF_GLOBAL_STATUS MSR during VM
switch, it doesn't need to inject PMI or FREEZE_LBR when VMM write it.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>

---
Changelog:
v1-v2: Add it into msrs_to_save_pmu[]
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c     | 16 ++++++++++++++++
 arch/x86/kvm/x86.c               |  1 +
 3 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index badc2f729a8e..50d231f76003 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1048,6 +1048,7 @@
 #define MSR_CORE_PERF_GLOBAL_STATUS	0x0000038e
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
+#define MSR_CORE_PERF_GLOBAL_STATUS_SET 0x00000391
 
 #define MSR_PERF_METRICS		0x00000329
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6e3bbe777bf5..957663b403f2 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -206,6 +206,8 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		return kvm_pmu_has_perf_global_ctrl(pmu);
+	case MSR_CORE_PERF_GLOBAL_STATUS_SET:
+		return vcpu_to_pmu(vcpu)->version >= 4;
 	case MSR_IA32_PEBS_ENABLE:
 		ret = vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PEBS_FORMAT;
 		break;
@@ -355,6 +357,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
 		msr_info->data = pmu->fixed_ctr_ctrl;
 		break;
+	case MSR_CORE_PERF_GLOBAL_STATUS_SET:
+		msr_info->data = 0;
+		break;
 	case MSR_IA32_PEBS_ENABLE:
 		msr_info->data = pmu->pebs_enable;
 		break;
@@ -454,6 +459,17 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!msr_info->host_initiated)
 			pmu->global_status &= ~data;
 		break;
+	case MSR_CORE_PERF_GLOBAL_STATUS_SET:
+		/*
+		 * GLOBAL STATUS_SET, sets bits in GLOBAL_STATUS, so the
+		 * set of reserved bits are the same.
+		 */
+		if (data & pmu->global_status_mask)
+			return 1;
+
+		if (!msr_info->host_initiated)
+			pmu->global_status |= data;
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c9c81e82e65..aae60461d0d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1471,6 +1471,7 @@ static const u32 msrs_to_save_pmu[] = {
 	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+	MSR_CORE_PERF_GLOBAL_STATUS_SET,
 	MSR_IA32_PEBS_ENABLE, MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG,
 
 	/* This part of MSRs should match KVM_INTEL_PMC_MAX_GENERIC. */
-- 
2.34.1

