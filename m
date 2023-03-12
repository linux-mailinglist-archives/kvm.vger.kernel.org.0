Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADE46B695B
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjCLSCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjCLSBL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:01:11 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C580F42BDE;
        Sun, 12 Mar 2023 10:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643938; x=1710179938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9HOLL8WZRfKxWhJbVNUqUX4nsRBJ27tfTnkzK8b11us=;
  b=DPRyn/y5Sa+wl1jGbBiAFNCRdixea5FzTkQ87wZZaZOG9XUZoTwze3+m
   1hOubFiNGAJbaZTUEn0sFtvuMNdOZJXjm7qktksRtsTuCDWgUCdVTdA9K
   Z4Iq/P4jAFNuGW5qNjSihE9Ht5tL0Lv8yDClIxoqu/z8W2Fi/rpZdpyOd
   dOBCiWK7dZ2vGJ9Ld0NDnnpCqXQ7zGK0qa1uYo+e1lqWjJrXgCiQE5RT3
   I0Oaj8tSuLV18ZvM46HXHyD5mv5pB5H09Coj+OmCAb7JO9g+Y7yU0+k2P
   tpgDvqEbG1n7YltQTUiL6JjuZxsd25pScncMA5s3BxvyQM4c2vjU7SXTS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659899"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659899"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596651"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596651"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:06 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v13 051/113] KVM: VMX: Move setting of EPT MMU masks to common VT-x code
Date:   Sun, 12 Mar 2023 10:56:15 -0700
Message-Id: <ec73810dc0e82741cbe0e362ea84c952dbaa00e6.1678643052.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

EPT MMU masks are used commonly for VMX and TDX.  The value needs to be
initialized in common code before both VMX/TDX-specific initialization
code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 9 +++++++++
 arch/x86/kvm/vmx/vmx.c  | 4 ----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 57240d6ab97a..58cbdc5aa2a2 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -4,6 +4,7 @@
 #include "x86_ops.h"
 #include "vmx.h"
 #include "nested.h"
+#include "mmu.h"
 #include "pmu.h"
 #include "tdx.h"
 #include "tdx_arch.h"
@@ -49,6 +50,14 @@ static __init int vt_hardware_setup(void)
 	if (ret)
 		return ret;
 
+	/*
+	 * As kvm_mmu_set_ept_masks() updates enable_mmio_caching, call it
+	 * before checking enable_mmio_caching.
+	 */
+	if (enable_ept)
+		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
+				      cpu_has_vmx_ept_execute_only());
+
 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8f44b29d05e9..23321b2208ae 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8370,10 +8370,6 @@ __init int vmx_hardware_setup(void)
 
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
-	if (enable_ept)
-		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
-				      cpu_has_vmx_ept_execute_only());
-
 	/*
 	 * Setup shadow_me_value/shadow_me_mask to include MKTME KeyID
 	 * bits to shadow_zero_check.
-- 
2.25.1

