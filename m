Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46A06B6964
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbjCLSCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjCLSBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:01:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6845BDE4;
        Sun, 12 Mar 2023 10:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643943; x=1710179943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sih2jVfz+0BUkC4Xcbm1JirIIKTRgrBSLmWFNj6MD20=;
  b=UZRkqScSzMisznP/+hqYkbbgXVW2yJfQDGkGIYdxAf7NVy24UfGBzFQU
   k0x8SLXfj4ERr3AThZiHZldSzDBEpWPa5EE41X6I4YCHdyQEPjbL2ivPm
   IE1wQiXjK1+o6w06tCrqsaWk/I5u/Su/JZo2AKvEX0wQw//Q6vWgQvkQQ
   RIXucNwr+F+R0HrwfBB8IRqTdxc2zu/4qpNkD7FD2kQtdt0zt8xvL1Fd3
   Y/xqNaPiH2liOTY/5KHqjL9mU7F+9HuNvzMU3jQbkXu3E1kzkkVzZHtCL
   OdRG5VfzDYLxerht94Boz/qnNhvpG6P8bp5C5YVCHomuwaRjVf+SOrKsT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659916"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659916"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596665"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596665"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:07 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 055/113] KVM: TDX: Require TDP MMU and mmio caching for TDX
Date:   Sun, 12 Mar 2023 10:56:19 -0700
Message-Id: <c3e66ab2d578b697e0a7999b78b5c4b704513e8e.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/main.c | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1f250fa8ce36..6074aa09cd87 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -100,6 +100,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  * If the hardware supports that we don't need to do shadow paging.
  */
 bool tdp_enabled = false;
+EXPORT_SYMBOL_GPL(tdp_enabled);
 
 static bool __ro_after_init tdp_mmu_allowed;
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 60fc4dfb22fd..a2065cfab50a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -2,6 +2,7 @@
 #include <linux/moduleparam.h>
 
 #include "x86_ops.h"
+#include "mmu.h"
 #include "vmx.h"
 #include "nested.h"
 #include "mmu.h"
@@ -57,6 +58,17 @@ static __init int vt_hardware_setup(void)
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

