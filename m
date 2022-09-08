Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3995B2A3A
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbiIHX0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiIHX03 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C233EB86B;
        Thu,  8 Sep 2022 16:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679571; x=1694215571;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eur7y1TP4jtJja2EWabGmkXbvuvmmXATztvuUODFrLI=;
  b=k2SMx2mHMicYKuB5K++kgYLoqIHX2PtE3wbizs1NyzwKNq6U9HyG46WU
   5qwrugBIStCqYs//sQktCOUeAuVNu5NHbHFsKfouyfKOL2dSkwMj6TEWV
   28wuZuysWyTw/+IRRqgUU/Ili9U8ivCgDsrS5eb+DEHkONPnZCntqfLFS
   7W3TrVkPLaRL17ArP4CArvFZ48Gv7TH1HUlknntRMpkaq8HGdFVkKXWS/
   tR0FDcwQMS3yy5hK1ccCXgdRR3trzLp1HpfBs/NPGgk3oFCJ9fEYfzDRN
   F6NKBfnrxIy3d2QhLz87uQnWTBYBlpfHBTvVFd0vGZca+9JdkTocabZpX
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687004"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687004"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:09 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863208"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:09 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v4 12/26] KVM: x86: Move TSC fixup logic to KVM arch resume callback
Date:   Thu,  8 Sep 2022 16:25:28 -0700
Message-Id: <a01d2507055525529b1a9c116aa1eb81f4e20b2a.1662679124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662679124.git.isaku.yamahata@intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

commit 0dd6a6edb012 ("KVM: Dont mark TSC unstable due to S4 suspend") made
use of kvm_arch_hardware_enable() callback to detect that TSC goes backward
due to S4 suspend.  It has to check it only when resuming from S4. Not
every time virtualization hardware ennoblement.  Move the logic to
kvm_arch_resume() callback.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ab8db07fa0e..c733f65aaf3c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11835,18 +11835,27 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
 int kvm_arch_hardware_enable(void)
+{
+	return static_call(kvm_x86_hardware_enable)();
+}
+
+void kvm_arch_hardware_disable(void)
+{
+	static_call(kvm_x86_hardware_disable)();
+	drop_user_return_notifiers();
+}
+
+void kvm_arch_resume(int usage_count)
 {
 	struct kvm *kvm;
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
-	int ret;
 	u64 local_tsc;
 	u64 max_tsc = 0;
 	bool stable, backwards_tsc = false;
 
-	ret = static_call(kvm_x86_hardware_enable)();
-	if (ret != 0)
-		return ret;
+	if (!usage_count)
+		return;
 
 	local_tsc = rdtsc();
 	stable = !kvm_check_tsc_unstable();
@@ -11921,13 +11930,6 @@ int kvm_arch_hardware_enable(void)
 		}
 
 	}
-	return 0;
-}
-
-void kvm_arch_hardware_disable(void)
-{
-	static_call(kvm_x86_hardware_disable)();
-	drop_user_return_notifiers();
 }
 
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
-- 
2.25.1

