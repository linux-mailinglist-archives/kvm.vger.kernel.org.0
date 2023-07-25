Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54553762669
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbjGYWWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjGYWV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:21:29 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2AA2270B;
        Tue, 25 Jul 2023 15:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323442; x=1721859442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+Yn2JKEs6mv69w6nkl5UeCBiJCVQ70hp7WXmBsy85ZM=;
  b=nkbBxHtZjBYEACKsaMyWZnvERmYuwOsrMHNgswwKGsNQ2m456wyPNCon
   0/nnuo0zIIqCPy4EBk3clny89hSvxDWqmC3HZlti4jVUgRtWjDhtsX8tP
   qa/CJrBUnnyiE9KNTDvILh/gIfYNkaH0EV504YmzZdLviP0Cz+oYX18Jr
   bPKutG/ZW1o6pA1mmWC73VKxt17Kg+A1V/ekCz7SFUMbx750ex1PfAv4T
   6Pk8Y9a45TIs+A70X+1fPaRdGBQ75z5/zsJWmgrQs9SsN5uUcIkwezLH3
   kmoRJEhM8TJJDOc7DecpukAy5dfWrwV0oSJgDyhsi/hjBduV1V6j4KfIx
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863322"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863322"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938963"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938963"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:42 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 054/115] KVM: TDX: Require TDP MMU and mmio caching for TDX
Date:   Tue, 25 Jul 2023 15:14:05 -0700
Message-Id: <3f9a65ef68973a718569230e958f631777ba0a0d.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

As TDP MMU is becoming main stream than the legacy MMU, the legacy MMU
support for TDX isn't implemented.  TDX requires KVM mmio caching.  Disable
TDX support when TDP MMU or mmio caching aren't supported.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c  |  1 +
 arch/x86/kvm/vmx/main.c | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5b48ac4a5fbc..4e9343e759f6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -103,6 +103,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  * If the hardware supports that we don't need to do shadow paging.
  */
 bool tdp_enabled = false;
+EXPORT_SYMBOL_GPL(tdp_enabled);
 
 static bool __ro_after_init tdp_mmu_allowed;
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index c4cf88987b00..debb48f19cfa 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -58,6 +58,17 @@ static __init int vt_hardware_setup(void)
 	if (enable_ept)
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
 				      cpu_has_vmx_ept_execute_only());
+	/* TDX requires KVM TDP MMU. */
+	if (enable_tdx && !tdp_enabled) {
+		enable_tdx = false;
+		pr_warn_ratelimited("TDX requires TDP MMU.  Please enable TDP MMU for TDX.\n");
+	}
+
+	/* TDX requires MMIO caching. */
+	if (enable_tdx && !enable_mmio_caching) {
+		enable_tdx = false;
+		pr_warn_ratelimited("TDX requires mmio caching.  Please enable mmio caching for TDX.\n");
+	}
 
 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
 
-- 
2.25.1

