Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59467CAFE1
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbjJPQjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233737AbjJPQh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:37:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00236FB8;
        Mon, 16 Oct 2023 09:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473355; x=1729009355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2snvj39E4RUSDydFJqJQfs08KpJHZVOl5jak2xY1TOs=;
  b=MIomptm4+4k2hdvAlDGhKzZs9p43nani7WtY/a/ba+kxEoLhgsb0bpwN
   asmVrawaH2FAMBc/fReU6UjBiACVXA+FAxBUQo8jWjmm3JtfE9nTJt/dT
   6nL44CG1W5H1zKDtDUH6AG95Ar4xy5EbXDDbS+zxvSbMld5/+5kzwjeR/
   Jd2vd33UFGjp9AfJQ4Reif50j46/CjQEjLVPrDh3YioVWcg/xnDYQRVB5
   zNbLcYvSU8elIIPrMNuW5SUp+3NqiaQDnn+znljOY9U38U6SZJ4vG/ZxY
   nKxmLRIU/0zBJz12Q+biX4tG6WyVULE0YGpd+sGxKglbCowtDzAGFvUC+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922127"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922127"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1003006469"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1003006469"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:10 -0700
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
Subject: [PATCH v16 105/116] KVM: TDX: Add methods to ignore VMX preemption timer
Date:   Mon, 16 Oct 2023 09:14:57 -0700
Message-Id: <6cbbe56a22774bd24bf25673e350f1f036b1f757.1697471314.git.isaku.yamahata@intel.com>
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

TDX doesn't support VMX preemption timer.  Implement access methods for VMM
to ignore VMX preemption timer.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 06eb0896a87a..eb02a73f3bb0 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -851,6 +851,27 @@ static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 	vmx_update_cpu_dirty_logging(vcpu);
 }
 
+#ifdef CONFIG_X86_64
+static int vt_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
+			      bool *expired)
+{
+	/* VMX-preemption timer isn't available for TDX. */
+	if (is_td_vcpu(vcpu))
+		return -EINVAL;
+
+	return vmx_set_hv_timer(vcpu, guest_deadline_tsc, expired);
+}
+
+static void vt_cancel_hv_timer(struct kvm_vcpu *vcpu)
+{
+	/* VMX-preemption timer can't be set.  See vt_set_hv_timer(). */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
+	vmx_cancel_hv_timer(vcpu);
+}
+#endif
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -1002,8 +1023,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.pi_start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
-	.set_hv_timer = vmx_set_hv_timer,
-	.cancel_hv_timer = vmx_cancel_hv_timer,
+	.set_hv_timer = vt_set_hv_timer,
+	.cancel_hv_timer = vt_cancel_hv_timer,
 #endif
 
 	.setup_mce = vmx_setup_mce,
-- 
2.25.1

