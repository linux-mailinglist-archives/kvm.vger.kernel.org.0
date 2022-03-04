Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188034CDE36
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiCDUHo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiCDUHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:34 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7CE2D3C81;
        Fri,  4 Mar 2022 12:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424134; x=1677960134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jhRol7GK7Pro/lhZst5qHkbc2tFnfk5xyikTLCTZnMs=;
  b=HR+1WJkrB4W8nsKXKB3hY/lryxELWZRLIBiEtNgbJnlC8sgJVY0ssrBw
   umtfWitA9t2XEaTtCfBw9FEwxTrDVuiEzgvukIDkf28ffBpcl3q1jB7Z8
   FTMT7JnQcVyH6ltP/g68O3Q4odazw9t9OIpIlKmd900Do8JsxTcRbqk7L
   JphpQj2qKt+jDu6zPUhjK6y3M7wZrZniLn3atWksW7PRMyrzcfkTc00qZ
   1MJC+5TV4VZ3AY1Pr7rCipQ/6qXRir0DwCG1MK5+ujZ4OibQeuOCUgdzQ
   eIJsQ26OpNQgZbWS2I1DyA2RsgmnZTA/ZTw37N+XbvwBlKrhsKElpUzL4
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983480"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983480"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:21 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344330"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:21 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 041/104] KVM: VMX: Move setting of EPT MMU masks to common VT-x code
Date:   Fri,  4 Mar 2022 11:48:57 -0800
Message-Id: <4dbe2defb66835ac414cdb2dc5974fa4a6820101.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/main.c | 5 +++++
 arch/x86/kvm/vmx/vmx.c  | 4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 3eb9db6d83ac..51aaafe6b432 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -4,6 +4,7 @@
 #include "x86_ops.h"
 #include "vmx.h"
 #include "nested.h"
+#include "mmu.h"
 #include "pmu.h"
 #include "tdx.h"
 
@@ -22,6 +23,10 @@ static __init int vt_hardware_setup(void)
 
 	tdx_hardware_setup(&vt_x86_ops);
 
+	if (enable_ept)
+		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
+				      cpu_has_vmx_ept_execute_only());
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0edeeed0b4c8..07fd892768be 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7817,10 +7817,6 @@ __init int vmx_hardware_setup(void)
 
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
-	if (enable_ept)
-		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
-				      cpu_has_vmx_ept_execute_only());
-
 	kvm_configure_mmu(enable_ept, 0, vmx_get_max_tdp_level(),
 			  ept_caps_to_lpage_level(vmx_capability.ept));
 
-- 
2.25.1

