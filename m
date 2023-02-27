Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF2D6A3CFD
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbjB0I3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230416AbjB0I22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:28:28 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34CF1E9FD;
        Mon, 27 Feb 2023 00:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486333; x=1709022333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uKZ4svGjPpiJO1WLmPzwP6IW1GALh7NR89xaq8uPvtc=;
  b=ZeSlOD3tvh5yphkkoPzfh9XRPmFZLK3KM5BFBQjXDTLGNXWH+SW7HcLo
   JnAM3LLdCPoZE0FttOZFRly3mA1NjPbcDgA4nRtwcXUVG58SBaWrfPmlX
   GBI5AATBYTy7EZAdzyRYpbhYDDEw5shxVQkL870vTASdHtoo/mz2lCbrL
   G73xKPGe4QvEJPREVQMg6dD+VHkGg8IQiQY3HLN0rcuDfDMqzKNN/XPY8
   0whYQ8nVj0KFhyGSssurXJa8mzgvYux+tXcI7CeR8dzb5dExAUJDr9uho
   92f+ukLMVywB+Twt/xffJqVx9HAjt7oS9wev4/UeYBsi5WATpDkR6HTin
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608973"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608973"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242332"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242332"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:15 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 071/106] KVM: TDX: Implements vcpu request_immediate_exit
Date:   Mon, 27 Feb 2023 00:23:10 -0800
Message-Id: <645e278b405ced7d0ba5f7fd60564f37ecd1cd5a.1677484918.git.isaku.yamahata@intel.com>
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

Now we are able to inject interrupts into TDX vcpu, it's ready to block TDX
vcpu.  Wire up kvm x86 methods for blocking/unblocking vcpu for TDX.  To
unblock on pending events, request immediate exit methods is also needed.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5fe87253668a..cfcd5818f8cb 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -360,6 +360,16 @@ static void vt_enable_irq_window(struct kvm_vcpu *vcpu)
 	vmx_enable_irq_window(vcpu);
 }
 
+static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		__kvm_request_immediate_exit(vcpu);
+		return;
+	}
+
+	vmx_request_immediate_exit(vcpu);
+}
+
 static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	if (is_td_vcpu(vcpu))
@@ -507,7 +517,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.request_immediate_exit = vmx_request_immediate_exit,
+	.request_immediate_exit = vt_request_immediate_exit,
 
 	.sched_in = vt_sched_in,
 
-- 
2.25.1

