Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6278714317
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjE2E3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbjE2E2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:28:24 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F0B115;
        Sun, 28 May 2023 21:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334301; x=1716870301;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GAaxy0ul3F15FaxDa/X6ya0I67REoqhkaBgBuvSmG6c=;
  b=hhEptweChnQMM2cHfKEYSZ/ooe3FrAcm2cdKG7RCcNCNiiiIIPz4l2uh
   O1rasBPoJAX/vVRf4JsCZIY+YsKN9V4Q2d8HRJNLk4DuVUhzajp6nPQY2
   99nGL407kPayPlsNj4QLtJW7iVJi6MPdxXtn66to9JmE0u7ZbvW0+wDhp
   q7PwBX2tFACvlClcX8pHtJ4OQau7E1o0vDD/YUv7uWTs41jEPYZ5Bf6lS
   eme/QTAptN9HtcrjwBV/Z+lKsAl7BHOdXf01sgvszRvvC06XBjhl2q1uK
   9zM+jjoXaalmjDHXdPJiQ6ZvmteXM0gK4bY+91zOIFfLDBGGUd9RGa1tW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966165"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966165"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784446"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784446"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:28 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 071/113] KVM: TDX: restore debug store when TD exit
Date:   Sun, 28 May 2023 21:19:53 -0700
Message-Id: <fb3e3a827ae821cdf4daa93ac6e2d1d74140fdae.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index df88576d6b2a..71d0b95b80dc 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2423,3 +2423,4 @@ void perf_restore_debug_store(void)
 
 	wrmsrl(MSR_IA32_DS_AREA, (unsigned long)ds);
 }
+EXPORT_SYMBOL_GPL(perf_restore_debug_store);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3ca866d671df..cb29d9c946ce 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -563,6 +563,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
 	tdx_user_return_update_cache(vcpu);
+	perf_restore_debug_store();
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
-- 
2.25.1

