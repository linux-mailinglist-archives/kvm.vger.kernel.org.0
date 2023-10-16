Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896CA7CAF74
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbjJPQdq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbjJPQc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:32:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC076FA9;
        Mon, 16 Oct 2023 09:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473349; x=1729009349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+/vtrN2qIqpj8iGnK5I8dTPlQxj06iJOkKyNTPVE38I=;
  b=NrS91KvE+XrSCvu/2qwf3cSwNZ2RATKGFoC4wt626ADbx9/qwFJLvutL
   8Ji25iAaog2v3wQ45MhgS5xhHj1EO5gf+rir32pv6dkr2uXQZPNTG9e2v
   /Sefuv9Sg3Hksass8oyrqGLVYk1+Wee1YmOOvp6eSN52eHj2OirjApJGl
   fXcNjitEtZsWXUVMq7ipRZE3Tm6eLTM0jcDiuS0OczCSP2Tv4fmY+7Uo6
   4ZZYu3QdLidZUsvjaJgByRusf/Zausw4spNbEJXUJqJdCTwEF5O/WZriu
   z5uyAHnVM91FxLpyoSYlPAU/clIU9IIGE3d9ZS1aXOBwXjjYBXWUXa3KK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922123"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922123"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1003006466"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="1003006466"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:09 -0700
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
Subject: [PATCH v16 104/116] KVM: TDX: Add a method to ignore dirty logging
Date:   Mon, 16 Oct 2023 09:14:56 -0700
Message-Id: <52f1c63c3891afb42ebe1641e72b1e5057ce24fa.1697471314.git.isaku.yamahata@intel.com>
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

Currently TDX KVM doesn't support tracking dirty pages (yet).  Implement a
method to ignore it.  Because the flag for kvm memory slot to enable dirty
logging isn't accepted for TDX, warn on the method is called for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5e4091dbf1e8..06eb0896a87a 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -843,6 +843,14 @@ static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
 }
 
+static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
+{
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
+	vmx_update_cpu_dirty_logging(vcpu);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -986,7 +994,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.sched_in = vt_sched_in,
 
 	.cpu_dirty_log_size = PML_ENTITY_NUM,
-	.update_cpu_dirty_logging = vmx_update_cpu_dirty_logging,
+	.update_cpu_dirty_logging = vt_update_cpu_dirty_logging,
 
 	.nested_ops = &vmx_nested_ops,
 
-- 
2.25.1

