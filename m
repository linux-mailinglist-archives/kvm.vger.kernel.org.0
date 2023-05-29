Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E940714362
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjE2Eeu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbjE2E3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:29:09 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8D71994;
        Sun, 28 May 2023 21:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334328; x=1716870328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TwRh/qBYWtdzY0K5rpEp1XOxoWVON5CiOdjF1fV85Fw=;
  b=gsV/5yeMOl18vZJFQ3avU8AUHzXqgui/ITxu4Gn2HdBCCAzzY6K5tXH0
   rMc9Mga3ulNwY3h2fNKgBxWurbY4YrBTJFEBwP/ROlItxHNG6rqtJmNAL
   9ykN65kErPfVsb3HKP6znmPio50ESAtNdy06b3motXELmPmD6AlXGuJ9B
   k4+DLSYkaUtDGi5lxuFxeKPbJRvA7pjvTShcdcQULET/8vnGUNmD2ggGy
   ywDGV5mE1ImNa+VhAsC2loKY2jy5s3/dJ+AbWoyxgZ2A8m6/q7jZHvlDy
   9oyHFHU/RwhZPxQVW9yFURJc24calwl003yyElTfHZUkhZ/UMv+9s088t
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="356993528"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="356993528"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="830223591"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="830223591"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:52 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 106/113] KVM: TDX: Ignore setting up mce
Date:   Sun, 28 May 2023 21:20:28 -0700
Message-Id: <6f78609a8ef4314fcf4786a29fb581a1ce6b6d81.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because vmx_set_mce function is VMX specific and it cannot be used for TDX.
Add vt stub to ignore setting up mce for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 166bf274e597..23e6caaa4cfc 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -892,6 +892,14 @@ static void vt_cancel_hv_timer(struct kvm_vcpu *vcpu)
 }
 #endif
 
+static void vt_setup_mce(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_setup_mce(vcpu);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -1048,7 +1056,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cancel_hv_timer = vt_cancel_hv_timer,
 #endif
 
-	.setup_mce = vmx_setup_mce,
+	.setup_mce = vt_setup_mce,
 
 #ifdef CONFIG_KVM_SMM
 	.smi_allowed = vt_smi_allowed,
-- 
2.25.1

