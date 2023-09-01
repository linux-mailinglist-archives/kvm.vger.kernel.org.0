Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAB178F91A
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348489AbjIAH3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345419AbjIAH32 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:29:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DF210D2
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693553364; x=1725089364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gB/YX0LD6k+ooMHcDDKKsOdkMRRWbYYzCUtvYTA4lTI=;
  b=ANDnCdi1JbLe7sHbTAEcc/H6MeAtyG8xaL21M7rJPTzrYL4H9veFTOJv
   S8JWT/46xCMGYgYauuHU4RJX5mZRxGpEiAA1tCyLGtD90m9iTYPf3Vvhw
   u96wtIUXZ9MMvtHPPgS+2DWWkbyrzV9auSiBNz4StNXseCMAWTZzNAacF
   rAARNXOETo9f2cAqX/9CNt3vHzwWwhttqaTr3CgKuKg4N7dfF5QUl5XqF
   mhdtcDjuthVUOAGikyQiZrbn2qXwazF2AtF3Nun52G64PLiQOw1pWnSdj
   JwkOxYVLylUiJ7m4vwO9BL9uGFXcs6uFbJg1AmCnMPLvxIuQIQSKdiX7Q
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="373550315"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="373550315"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="716671275"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="716671275"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:21 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 3/9] KVM: x86/pmu: Add PERF_GLOBAL_STATUS_SET MSR emulation
Date:   Fri,  1 Sep 2023 15:28:03 +0800
Message-Id: <20230901072809.640175-4-xiong.y.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230901072809.640175-1-xiong.y.zhang@intel.com>
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
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

The IA32_PERF_GLOBAL_STATUS_SET MSR is introduced with arch PMU
version 4. It allows software to set individual bits in
IA32_PERF_GLOBAL_STATUS MSR. It can be used by a VMM to virtualize the
state of IA32_PERF_GLOBAL_STATUS across VMS.

If the running VM owns the whole PMU, different VM will have different
perf global status, VMM needs to restore IA32_PERF_GLOBAL_STATUS MSR at
VM switch, but IA32_PERF_GLOBAL_STATUS MSR is read only, so VMM can use
IA32_PERF_GLOBAL_STATUS_SET MSR to restore VM's PERF_GLOBAL_STATUS MSR.

This commit adds this MSR emulation, so that L1 VMM could use it. As it
is mainly used by VMM to restore VM's PERF_GLOBAL_STATUS MSR during VM
switch, it doesn't need to inject PMI or FREEZE_LBR when VMM write it.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c     | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4fce37ae5a90..7c8cf6b53a76 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1035,6 +1035,7 @@
 #define MSR_CORE_PERF_GLOBAL_STATUS	0x0000038e
 #define MSR_CORE_PERF_GLOBAL_CTRL	0x0000038f
 #define MSR_CORE_PERF_GLOBAL_OVF_CTRL	0x00000390
+#define MSR_CORE_PERF_GLOBAL_STATUS_SET 0x00000391
 
 #define MSR_PERF_METRICS		0x00000329
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ba7695a64ff1..b25df421cd75 100644
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
@@ -449,6 +454,17 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
-- 
2.34.1

