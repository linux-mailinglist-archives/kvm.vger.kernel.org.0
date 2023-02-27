Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992DA6A3CC0
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjB0I07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:26:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbjB0I0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:26:07 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391CB1DBA1;
        Mon, 27 Feb 2023 00:24:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486279; x=1709022279;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wPBml+MMAV/1PWip7l5RqLNhMgjPjuoG7zHBpGXgJGg=;
  b=nzPZOb9RLyafWsO2QMHyN3tXl4/VpcZlA9lVgbuL+hXVQDIAifxxwZZf
   5s48JTACiEtyiIpXA31Bw2yvBjppEgugAXGQnJWfHj41kaF7iU6jx8CP+
   t3J3bwFkIQe3myG5N8Q2gWfIki3tpiMhcQ6fLTyDHtB1JMKv9Jf0jnexu
   1qS3P5LzmJwxRsq4x4mQWtC38weO0JwMhCSGubKRw+HFm8SuBKN+Jgsuu
   J7gULa5vyzDNDvddoLBTDyrz6sz7PxXo64v5GJH3URdftJcb7h0qxlgQw
   wO8MgKBYnoUJnP3qnp9BSEXF/H0ZkXYKsAjAg8xnjTvL/QrOGhg0bXzAr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608859"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608859"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242206"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242206"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:09 -0800
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
Subject: [PATCH v12 045/106] KVM: VMX: Move setting of EPT MMU masks to common VT-x code
Date:   Mon, 27 Feb 2023 00:22:44 -0800
Message-Id: <e7ba11d8e404096f22238947e0850ba294e0c61d.1677484918.git.isaku.yamahata@intel.com>
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
index 0cd85c96ed84..71fa6d27c0ef 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -5,6 +5,7 @@
 #include "mmu.h"
 #include "vmx.h"
 #include "nested.h"
+#include "mmu.h"
 #include "pmu.h"
 #include "tdx.h"
 #include "tdx_arch.h"
@@ -39,6 +40,14 @@ static __init int vt_hardware_setup(void)
 
 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
 
+	/*
+	 * As kvm_mmu_set_ept_masks() updates enable_mmio_caching, call it
+	 * before checking enable_mmio_caching.
+	 */
+	if (enable_ept)
+		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
+				      cpu_has_vmx_ept_execute_only());
+
 	/* TDX requires KVM TDP MMU and MMIO caching. */
 	if (enable_tdx && (!tdp_enabled || !enable_mmio_caching)) {
 		enable_tdx = false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2f4d76f7902..3ff3b33fe9af 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8351,10 +8351,6 @@ __init int vmx_hardware_setup(void)
 
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

