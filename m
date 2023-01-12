Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FC3667B87
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240836AbjALQnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240215AbjALQie (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:34 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85661A810;
        Thu, 12 Jan 2023 08:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541244; x=1705077244;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CufvXO+RC7MHuNBEXtCQBcHtbf0F1WupRkdjSEBVM9A=;
  b=m6vyK3OHfN0E9mN+QZMg09kiOaobvpXxkZBOXe7I5WPm24DXtu73IXhQ
   CDCQvRFQqvDAeW/fPCOVlPVUoCQDaZblGOE0tz2AmHF7bwEvJO55InoYh
   wBskZsvp9ChNuq2AIMcsDOqoqAYBdSDfSVTJmB8grEqulOvGtuOqGs9lY
   QPMONETArFCfh18z1rABAdsxdq3MPRFUbfXvBdwlF4e4YyLX5BtCLbllW
   ypOoqdrDeEyZNQXj1tQbMm/zyrXE0kKXTOKthPX0tfpOjM7twH/F3xptk
   6yz5GwVGal93jKh1BbkwaA0+Vx27XCDgIn75NwBiZ8lGA0+y9CJLg/4c1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811906"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811906"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151814"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151814"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:28 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v11 052/113] KVM: VMX: Move setting of EPT MMU masks to common VT-x code
Date:   Thu, 12 Jan 2023 08:32:00 -0800
Message-Id: <0d3cf5d289a64caa375bef058dd6eff248c81310.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
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
index 23b3ffc3fe23..9f817f9a8c69 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -4,6 +4,7 @@
 #include "x86_ops.h"
 #include "vmx.h"
 #include "nested.h"
+#include "mmu.h"
 #include "pmu.h"
 #include "tdx.h"
 
@@ -26,6 +27,10 @@ static __init int vt_hardware_setup(void)
 
 	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
 
+	if (enable_ept)
+		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
+				      cpu_has_vmx_ept_execute_only());
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6394c1241374..2b0de8ba86b1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8394,10 +8394,6 @@ __init int vmx_hardware_setup(void)
 
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

