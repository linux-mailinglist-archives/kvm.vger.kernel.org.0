Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1848F78F91F
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 09:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238793AbjIAHaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 03:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348500AbjIAHaK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 03:30:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCAC1724
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 00:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693553385; x=1725089385;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YPa75IoSHXcqVnGyb8+Uwwta16Yye+wwmIWExyWjphA=;
  b=KqDildXGMMtqD7pr1dde4l7zUhc2lxtI7t6CCSpuxBSxMDvgIXzTVNSX
   ls5QnpXJqyTuo/8Ly8lxdUDv+Fbb16Xj86Ek+EfLCsAMAqiN/HkxGSl+L
   jkYVuBOrpVbVyebGIOy7UAWiRZ/bhtCvvCJ/RDtuyP6VxyZdISCU5hIDH
   Ii9/pIbpqqAjOasVY+uDDhRXSmj7+zzZC5PvqOAStEImKbPcrnaoAiocm
   U8hf9vvkb8WuHHbgjV+rLAAKih3DorE6zq5ZPji8DjQniQzpHO54qCRR3
   Uxt8Uq3Myg94kdVkXF5xVaF8qgdwKI6ev3P9AiWrJx9nmFagHNbIcyr94
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="373550369"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="373550369"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10819"; a="716671365"
X-IronPort-AV: E=Sophos;i="6.02,219,1688454000"; 
   d="scan'208";a="716671365"
Received: from wangdere-mobl2.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.29.239])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2023 00:29:42 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        dapeng1.mi@linux.intel.com, Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH 8/9] KVM: x86/pmu: Upgrade pmu version to 5 on intel processor
Date:   Fri,  1 Sep 2023 15:28:08 +0800
Message-Id: <20230901072809.640175-9-xiong.y.zhang@intel.com>
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

Modern intel processors have supported Architectural Performance
Monitoring Version 5, this commit upgrade Intel vcpu's vPMU
version from 2 to 5.

Go through PMU features from version 3 to 5, the following
features are not supported:
1. AnyThread counting: it is added in v3, and deprecated in v5.
2. Streamed Freeze_PerfMon_On_PMI in v4, since legacy Freeze_PerMon_ON_PMI
isn't supported, the new one won't be supported neither.
3. IA32_PERF_GLOBAL_STATUS.ASCI[bit 60]: Related to SGX, and will be
emulated by SGX developer later.
4. Domain Separation in v5. When INV flag in IA32_PERFEVTSELx is used, a
counter stops counting when logical processor exits the C0 ACPI C-state.
First guest INV flag isn't supported, second guest ACPI C-state is vague.

When a guest enable unsupported features through WRMSR, KVM will inject
a #GP into the guest.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
---
 arch/x86/kvm/pmu.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 4bab4819ea6c..8e6bc9b1a747 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -215,7 +215,10 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 		return;
 	}
 
-	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
+	if (is_intel)
+		kvm_pmu_cap.version = min(kvm_pmu_cap.version, 5);
+	else
+		kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
 	kvm_pmu_cap.num_counters_gp = min(kvm_pmu_cap.num_counters_gp,
 					  pmu_ops->MAX_NR_GP_COUNTERS);
 	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
-- 
2.34.1

