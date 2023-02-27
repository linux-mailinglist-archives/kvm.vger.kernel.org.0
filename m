Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D03C6A3CA2
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjB0I0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjB0IZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:25:15 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B701CF51;
        Mon, 27 Feb 2023 00:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486260; x=1709022260;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kiMrCiwWUYaEeugDN3MIePrm0EH5lDPG8Yp+BXFRlOE=;
  b=LnvY4nWQ5JQoDPYcjNkZFRrCL0kzFqS46Q06op03Da0wEFqEckDxZgAO
   S0pZka5ScyJ7trVOeKOVYMBxdQml+Bg96NfZo+HwIoOsh1+xqqrm3irQx
   4OCF38XU8yX4RcL0tUS9PkTKS1vIReYFayzl6ViZleeJX86sGCaZHx57I
   r2b9AX60+TgPvyHT0nfwpIExXYzvxZ9yx+ST1xvnBkpL8yLoWLzkccUZ9
   lUlqPh5U3ERHo5t21LFsdiqSopHUDCXYrIZKMUVkpROkFHCFx7mRYLV3W
   UwSAeIgsePchHbMhHNi4GiWnDkG2LxDywvevQa+RLLkxDVoJOQ5euwTgk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608808"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608808"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242165"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242165"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:06 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 034/106] KVM: x86/mmu: Require TDP MMU and mmio caching for TDX
Date:   Mon, 27 Feb 2023 00:22:33 -0800
Message-Id: <4bb83ed60289137bcc2ca72c56a88c2f935536af.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/mmu/mmu.c  | 1 +
 arch/x86/kvm/vmx/main.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 898f36f2d84a..a6b0b53634e8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -99,6 +99,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
  * If the hardware supports that we don't need to do shadow paging.
  */
 bool tdp_enabled = false;
+EXPORT_SYMBOL_GPL(tdp_enabled);
 
 bool __ro_after_init tdp_mmu_allowed;
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index fa0590e37ec1..0cd85c96ed84 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -2,6 +2,7 @@
 #include <linux/moduleparam.h>
 
 #include "x86_ops.h"
+#include "mmu.h"
 #include "vmx.h"
 #include "nested.h"
 #include "pmu.h"
@@ -38,6 +39,11 @@ static __init int vt_hardware_setup(void)
 
 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
 
+	/* TDX requires KVM TDP MMU and MMIO caching. */
+	if (enable_tdx && (!tdp_enabled || !enable_mmio_caching)) {
+		enable_tdx = false;
+		pr_warn_ratelimited("tdp mmu and mmio caching need to be enabled.\n");
+	}
 	return 0;
 }
 
-- 
2.25.1

