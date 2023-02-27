Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED5F6A3CEB
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbjB0I2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbjB0I2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:28:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDBF1EBED;
        Mon, 27 Feb 2023 00:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486322; x=1709022322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wQRsBjUiBMYTpgEwJyYgRZtvi4+wq6LFWeS2Z3xRVmY=;
  b=C1sTnLac6mNQkfujHWOQA7UINP7ODCu9M/QQtL5gyD6iGOpd2JQ9/ZIs
   huXlWQWp9y7+EO2JKBP4xLvLDbeWz7qCHA5QWVyqKO1ipqaOzuuaBkMpW
   yabTpHAhmW8AOAzYDAeqBw7IMmwnHZdJtvb9Nb4LLBBRMip7ojEMCV37d
   XYeAfNRvtJoibsOE5h5z0g5JWHv11aaadO5DYfyplIa6jqB8KcIQU5H23
   GQAN6NYJ9me8l00LWW/lNFQe6kRaW7HjhHZpfxscQslKzHLTRuDuoiBU8
   u2kGO9cQ7yzm361ATgUuyBsqmmRgWnAQGK67G+fpa+rZlQf1o9StLTQ7W
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608954"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608954"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:15 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242299"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242299"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:14 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 064/106] KVM: TDX: restore debug store when TD exit
Date:   Mon, 27 Feb 2023 00:23:03 -0800
Message-Id: <b3e9c1901160d665c0607e217915872e4f39c63a.1677484918.git.isaku.yamahata@intel.com>
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

Because debug store is clobbered, restore it on TD exit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/events/intel/ds.c | 1 +
 arch/x86/kvm/vmx/tdx.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 88e58b6ee73c..4989b35161b6 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2350,3 +2350,4 @@ void perf_restore_debug_store(void)
 
 	wrmsrl(MSR_IA32_DS_AREA, (unsigned long)ds);
 }
+EXPORT_SYMBOL_GPL(perf_restore_debug_store);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0e07fd13ec66..30eae42b071d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -576,6 +576,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
 	tdx_user_return_update_cache();
+	perf_restore_debug_store();
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
-- 
2.25.1

