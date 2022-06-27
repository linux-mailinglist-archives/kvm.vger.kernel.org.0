Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E512F55CB5D
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241933AbiF0V51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241369AbiF0Vza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:30 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCCA765D;
        Mon, 27 Jun 2022 14:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366901; x=1687902901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C5qnexNPI65FMQzXiabhoNYeDhLbZoID6UTYoyLFD0w=;
  b=dLIam9CNo++Y2QfHyWqoPekbRodQI+mweoMw8/J/I8+ffj2/5ux4hIrU
   f6qCt9soPgx7EQTjurZrmUcwLfgn1/UA+AYy29D8D9NAQeVh91llh3t9W
   HIcJZvNPXYp19y1OdqMSArVQrZcOxAqAnV4Fzf9u7gjC1qdhuGCZa+fZA
   L87oI9cYz9jM3ah9QBXQUqNDh+kw8iO47DW0ogyH3wcnBgegxV272Ver0
   UlMjw/RfjmTPPOEEiVTp31Qre6JVS2cHlcrmeeTRzCF5XOyLuWt9L8Bt/
   5H2WgyV0fR6oflP1AtLILJy0ImEY16sciGXaXgdZFlIf2rrTZYNl+Xgt+
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609577"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609577"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:55 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863601"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:55 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v7 051/102] KVM: VMX: Move setting of EPT MMU masks to common VT-x code
Date:   Mon, 27 Jun 2022 14:53:43 -0700
Message-Id: <28893d81287bb7ca7367b8b7e16c2c9bf911abce.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index ce12cc8276ef..9f4c3a0bcc12 100644
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
index 2f1dc06aec3c..3f231159fe3d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8139,10 +8139,6 @@ __init int vmx_hardware_setup(void)
 
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

