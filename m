Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20A1A77C674
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 05:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbjHODlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 23:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbjHODiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 23:38:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D8F199E;
        Mon, 14 Aug 2023 20:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692069948; x=1723605948;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hYxRQBVIjQPWurYqWEgYetagwObrSeUZ9qM9B13jnXU=;
  b=G0fOQ28xKhatUKMMbzg6apAYGGP2rVtmop/5RpL/pP1RsZTQLUmK9y0p
   8nITOQrFGsoGr26Jlb8BgfyMGgawKUNUpsU+yxLebSWKcXgFxrL8Q/tkl
   bfSocHbxMWnmlke+sd/6ELTM6iAmOwapoAuIIq7NV5XnY0HnzBZG3+Tix
   MsZQJqHyL5poKPs+4iCKG6UxudrcJbf8M7/9PWNCzHJJeaSmIgJbBlXsc
   dZT/2B9Dn8Tcq68KWSADQXtvji4fDvFW8MYG/1Y79nfsutmjSV13uNh4x
   NlLaVdmPe08MsRc/04Cwqd7Embybl8g9jtOcIDM5grDlMpsfBCwFMyIME
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="362341461"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="362341461"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 20:25:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="799061073"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="799061073"
Received: from dmi-pnp-i7.sh.intel.com ([10.239.159.155])
  by fmsmga008.fm.intel.com with ESMTP; 14 Aug 2023 20:25:44 -0700
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>
Cc:     kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH v2] KVM: x86/pmu: Manipulate FIXED_CTR_CTRL MSR with macros
Date:   Tue, 15 Aug 2023 11:28:49 +0800
Message-Id: <20230815032849.2929788-1-dapeng1.mi@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Magic numbers are used to manipulate the bit fields of
FIXED_CTR_CTRL MSR. This is not read-friendly and use macros to replace
these magic numbers to increase the readability.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 10 +++++-----
 arch/x86/kvm/pmu.h |  6 ++++--
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index edb89b51b383..fb4ef2da3e32 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -420,11 +420,11 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 	if (pmc_is_fixed(pmc)) {
 		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
 						  pmc->idx - INTEL_PMC_IDX_FIXED);
-		if (fixed_ctr_ctrl & 0x1)
+		if (fixed_ctr_ctrl & INTEL_FIXED_0_KERNEL)
 			eventsel |= ARCH_PERFMON_EVENTSEL_OS;
-		if (fixed_ctr_ctrl & 0x2)
+		if (fixed_ctr_ctrl & INTEL_FIXED_0_USER)
 			eventsel |= ARCH_PERFMON_EVENTSEL_USR;
-		if (fixed_ctr_ctrl & 0x8)
+		if (fixed_ctr_ctrl & INTEL_FIXED_0_ENABLE_PMI)
 			eventsel |= ARCH_PERFMON_EVENTSEL_INT;
 		new_config = (u64)fixed_ctr_ctrl;
 	}
@@ -749,8 +749,8 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 	} else {
 		config = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
 					  pmc->idx - INTEL_PMC_IDX_FIXED);
-		select_os = config & 0x1;
-		select_user = config & 0x2;
+		select_os = config & INTEL_FIXED_0_KERNEL;
+		select_user = config & INTEL_FIXED_0_USER;
 	}
 
 	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7d9ba301c090..ffda2ecc3a22 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -12,7 +12,8 @@
 					  MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
 
 /* retrieve the 4 bits for EN and PMI out of IA32_FIXED_CTR_CTRL */
-#define fixed_ctrl_field(ctrl_reg, idx) (((ctrl_reg) >> ((idx)*4)) & 0xf)
+#define fixed_ctrl_field(ctrl_reg, idx) \
+	(((ctrl_reg) >> ((idx) * INTEL_FIXED_BITS_STRIDE)) & INTEL_FIXED_BITS_MASK)
 
 #define VMWARE_BACKDOOR_PMC_HOST_TSC		0x10000
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
@@ -165,7 +166,8 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 
 	if (pmc_is_fixed(pmc))
 		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+					pmc->idx - INTEL_PMC_IDX_FIXED) &
+					(INTEL_FIXED_0_KERNEL | INTEL_FIXED_0_USER);
 
 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }

base-commit: 240f736891887939571854bd6d734b6c9291f22e
-- 
2.34.1

