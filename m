Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFF96A3D41
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbjB0IcH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbjB0IaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:30:15 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B041D925;
        Mon, 27 Feb 2023 00:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486421; x=1709022421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RlLLDqsjdsWGZZGnbwmWrW/7AkVVVP9WsV72zRvKFMk=;
  b=S11P3KjvOEVOWJEVCd6zcoNFF1bBXRZj9l36BhYOnm5eSmfgvTKpXGED
   munJP6u+L5I2Uwr6/XqcXKjVAqNqQHnbnGBP7TS4KvQiGk0iePwVstM3N
   IbbODhjN4His3BkVprt9kWDvwTl2+gcjI4Ez5MqWKjkbj9bkKUh4hMxA1
   l9M0XlpdnuDQNUUzSi2BUU6aOsobzt3szpt6+LEKSL2ocV6JgI/zxv9ez
   C0pF3MUQz8oIz6wOd56fLVx1a/3O7KrEV68PLwCvAkgdXj1z1OQvqVb0Y
   nGJPHyjqvWLZ7pQGtQZmjJ1QrsIMUWdwZ3FF1j8ri+3fudA37sF8VrjyA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317609109"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317609109"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:21 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242444"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242444"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:20 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 100/106] KVM: TDX: Ignore setting up mce
Date:   Mon, 27 Feb 2023 00:23:39 -0800
Message-Id: <4e6af93ad7f1970dc058bca1ffbedf5cd6b936f4.1677484918.git.isaku.yamahata@intel.com>
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

Because vmx_set_mce function is VMX specific and it cannot be used for TDX.
Add vt stub to ignore setting up mce for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 340e76e1b59e..73ea15754102 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -871,6 +871,14 @@ static void vt_cancel_hv_timer(struct kvm_vcpu *vcpu)
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
@@ -1027,7 +1035,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.cancel_hv_timer = vt_cancel_hv_timer,
 #endif
 
-	.setup_mce = vmx_setup_mce,
+	.setup_mce = vt_setup_mce,
 
 #ifdef CONFIG_KVM_SMM
 	.smi_allowed = vt_smi_allowed,
-- 
2.25.1

