Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7997CAEFF
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234001AbjJPQVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbjJPQUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:20:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911BE181;
        Mon, 16 Oct 2023 09:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473171; x=1729009171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6YA1OeaB9jXBevULWVmASnb1nuq2QXXn0wVVpTdL3r8=;
  b=filbB1kQQIStiTUz1wU4pM4k12j3LPOXRye1Uwo9yDp6uT1u0GPxY4F7
   9KyivqE8kosan+yM/UDY2O0cgy3ebNLi+3Jsf333wZ91eMBOj9vSMjI/F
   euzLE9+NOvrP6m53olsrwiiSV7lG1j81tJrhR1d/JcqbXgVPf8R4Gm8MU
   rLQM33H4fYRDtglFVPOfcXZLcYDUVExtRYF883qlsqAEG94qMFqNL5+tZ
   LAOpqrypW2t8ahwtKMCTPGvcm/GFZgA4Q0WnCqrreoL66/fcfqH+Pgrch
   yP/0Zfy4OFz+6aXoQx1bCMQ21HM1yEcl6+diRgEU61xmqO6DQP1JYNklK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="365825871"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365825871"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087125965"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1087125965"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:22 -0700
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
Subject: [PATCH v16 004/116] KVM: VMX: Reorder vmx initialization with kvm vendor initialization
Date:   Mon, 16 Oct 2023 09:13:16 -0700
Message-Id: <01c4d7938ee7e5915b82b2249dc999378c183322.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 4059364fc5e0..2e8a0de2c96a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -180,11 +180,11 @@ static int __init vt_init(void)
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
 
@@ -201,9 +201,9 @@ static int __init vt_init(void)
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

