Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE587625BD
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjGYWPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjGYWPh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:15:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D97F5;
        Tue, 25 Jul 2023 15:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323335; x=1721859335;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pKZCqPO3oZUeDR6rPcORqpsgOwSf9m2DrMDdZUUZCs4=;
  b=PpqnQugjP62DkT/M7HKVRh2Oa1JTv6OYXBYbtJBD9bhijec1nJFHtmH2
   Z+qTw/aokptNSnXadTrOYXwECYg6tpvuo7d8gYHAj1And3/CL3x2KTDL0
   c5JEs0yTyGl8LEdBKoLMekswlqdO5HxXFu4tWHiVphQuMQrljG8odf2XD
   zSpXUz7Nr780t4jX+so8sNJ6DByHEPPvgOEpxQqn01MTxIzTHYPt9rBmk
   ai64JJNhRwxgiBjfs69xF+XI/jWUFPgdFDEzcuz/mTjumAySbiN3iRdWp
   z9YbHqUXq2X8Kk/YKI5kKFJMVg2bePv8bgeG4vQP4xYvLLMQWYkMgxc56
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863031"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863031"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938775"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938775"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:16 -0700
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
Subject: [PATCH v15 004/115] KVM: VMX: Reorder vmx initialization with kvm vendor initialization
Date:   Tue, 25 Jul 2023 15:13:15 -0700
Message-Id: <f08935a03e3e8ba29f94840471f06089e7a24147.1690322424.git.isaku.yamahata@intel.com>
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

To match vmx_exit cleanup.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 27bfd3fcea09..deaba44c6bdf 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -179,11 +179,11 @@ static int __init vt_init(void)
 	 */
 	hv_init_evmcs();
 
-	r = kvm_x86_vendor_init(&vt_init_ops);
+	r = vmx_init();
 	if (r)
-		return r;
+		goto err_vmx_init;
 
-	r = vmx_init();
+	r = kvm_x86_vendor_init(&vt_init_ops);
 	if (r)
 		goto err_vmx_init;
 
@@ -200,9 +200,9 @@ static int __init vt_init(void)
 	return 0;
 
 err_kvm_init:
-	vmx_exit();
-err_vmx_init:
 	kvm_x86_vendor_exit();
+err_vmx_init:
+	vmx_exit();
 	return r;
 }
 module_init(vt_init);
-- 
2.25.1

