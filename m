Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E34E7142EE
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbjE2E0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbjE2EZx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:25:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11AE1BE;
        Sun, 28 May 2023 21:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334215; x=1716870215;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bWa3AvpEC6jbEznd1Ji20ghakwuyyQ9ZcKDMuaV5Dds=;
  b=com+pTqhJC9g/GIsg21tna50WCxUWwYXGpgUj/zhfK+ea6YyFQPQCW2T
   YNWBSLRvjk23ZHzDsohmcHSN6SFyEmU2FufLtD9B1Hthwpr9zhzzZky9u
   kqLvhJ3a8kDveFlDKbfoh+CnZ/2q/dCYMcnUcSBH1VeBcTEs43f9AuAeb
   noI3+/21b+QbmEgHwZdKmt5O13kXr9mkybsK2VydkNXEzpye1lp/vFoJB
   gTJgIp0gxPmPmIaMvNoD3hIMPSY+xRdvO52CmUjFOsqUH3gEr2skYn4gz
   tz7hgG359gEMHC/UatcTfcCvDqE1PGLrW25slwFxS6W8i8zay80cQaJeX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966015"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966015"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784334"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784334"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:17 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v14 050/113] KVM: VMX: Move setting of EPT MMU masks to common VT-x code
Date:   Sun, 28 May 2023 21:19:32 -0700
Message-Id: <ecd6af0b055e1cd1baaece131edc14c70c601324.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/kvm/vmx/main.c | 9 +++++++++
 arch/x86/kvm/vmx/vmx.c  | 4 ----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a04d575ec50e..87003343627b 100644
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
@@ -50,6 +51,14 @@ static __init int vt_hardware_setup(void)
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
index a4ef08dfb5e8..e1d7c6d01e83 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8331,10 +8331,6 @@ __init int vmx_hardware_setup(void)
 
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

