Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6FA7A9BD0
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 21:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbjIUTEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 15:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjIUTEG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 15:04:06 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DE04E5F5
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695318601; x=1726854601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PnYyz1ivEBWn1+J3Aq3LJfdHtekQpCKjYAwRui0RndI=;
  b=IvAgzJTyKkClhqY2sF6yKA0iDq79kOcwhc7T5kiHXQ9Ps4eAJaE9jz/i
   pdwtcIQqeGZ3WTWYwmn18qpTUVVBoW/OHgwC/iZ4wO6FNiD1YSnB9qI5S
   3RbfwV9PyhflaYR/SaM2mumLNX097rrdBr81uJc842iRUME9mVJsbvVUo
   /UyZ1Kvg1dbLCICGMi8NESQmODUvxeGxNPYrOJvyUaxrxqxiIVK3kF5jT
   TBI5BIDHsUEQZQX2hOeVDrNmkqPAc7fg/ApO7dghjyPRXz7LkxqivjBaP
   QKTqJHIS3yWo51x4ZZnOQErXUPMnAbo13YQsBQPX5fll45QNFHAo2DUJO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="359841382"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="359841382"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="747001182"
X-IronPort-AV: E=Sophos;i="6.03,164,1694761200"; 
   d="scan'208";a="747001182"
Received: from dorasunx-mobl1.ccr.corp.intel.com (HELO xiongzha-desk1.ccr.corp.intel.com) ([10.255.30.47])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2023 01:31:21 -0700
From:   Xiong Zhang <xiong.y.zhang@intel.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, like.xu.linux@gmail.com,
        dapeng1.mi@linux.intel.com, zhiyuan.lv@intel.com,
        zhenyu.z.wang@intel.com, kan.liang@intel.com,
        Xiong Zhang <xiong.y.zhang@intel.com>
Subject: [PATCH v2 8/9] KVM: x86/pmu: Upgrade pmu version to 5 on intel processor
Date:   Thu, 21 Sep 2023 16:29:56 +0800
Message-Id: <20230921082957.44628-9-xiong.y.zhang@intel.com>
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
KVM has little information about guest ACPI C-state.

When guest enable unsupported features through WRMSR, KVM will inject
a #GP into guest.

Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>

---
Changelog:
v1->v2: kvm_pmu_cap.version will not exceed 2 for AMD, no need to
differentiate between Intel and AMD.
---
 arch/x86/kvm/pmu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 4bab4819ea6c..b416094917fd 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -215,7 +215,7 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 		return;
 	}
 
-	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 2);
+	kvm_pmu_cap.version = min(kvm_pmu_cap.version, 5);
 	kvm_pmu_cap.num_counters_gp = min(kvm_pmu_cap.num_counters_gp,
 					  pmu_ops->MAX_NR_GP_COUNTERS);
 	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
-- 
2.34.1

