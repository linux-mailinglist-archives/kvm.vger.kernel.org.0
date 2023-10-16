Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9205B7CAEFC
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbjJPQUD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbjJPQTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:19:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E491FE6;
        Mon, 16 Oct 2023 09:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473153; x=1729009153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/ayiIuFTfj+8avzZVaM7u+DM7LRJDLMFcgXrJZz/0uo=;
  b=Gn7FYNxFTM2VIl8djOlzuei2LG5k+E8cBuOhUQT5tdWVgh0emxnuxvsu
   btWYwtVkXpqae9MCIo7bNXo3IWHuXiVpNGFgVd66xEf8U6nf87ZKyKbpP
   O2947I8ZB5Pdsit/9q+u00QRiZnY+bBd6J/+T6nO/n7HMJKTGQ1uR1q/e
   HMswGGKP7NQcF+u2q3/fiS/l9VHmubapQ43Oa+9zFKUvRJLWCHz8uOBSX
   wsU4s51tj1q47j3fE4vKK757lUztfYeTi+y26dqK5+fMvfOEaU9ET+qUu
   eygGOGI+Dzb+IpmJ/5Y+uzA9xplj30cSw92r6taa/KlXFMBDCXekBmynX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364921950"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364921950"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448238"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448238"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:56 -0700
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
Subject: [PATCH v16 077/116] KVM: TDX: Implements vcpu request_immediate_exit
Date:   Mon, 16 Oct 2023 09:14:29 -0700
Message-Id: <2f3eab559dcc172665bacc1a54647c7e827824e0.1697471314.git.isaku.yamahata@intel.com>
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

Now we are able to inject interrupts into TDX vcpu, it's ready to block TDX
vcpu.  Wire up kvm x86 methods for blocking/unblocking vcpu for TDX.  To
unblock on pending events, request immediate exit methods is also needed.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 37d28ee08c79..0ce9578a1453 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -381,6 +381,16 @@ static void vt_enable_irq_window(struct kvm_vcpu *vcpu)
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
@@ -527,7 +537,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.request_immediate_exit = vmx_request_immediate_exit,
+	.request_immediate_exit = vt_request_immediate_exit,
 
 	.sched_in = vt_sched_in,
 
-- 
2.25.1

