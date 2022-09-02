Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254B75AA5A5
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbiIBCSg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiIBCSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C966CF59;
        Thu,  1 Sep 2022 19:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085096; x=1693621096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SMjdWioevXsL9hkzrGjUoKydVmgpqxCcZj+UHebmQzs=;
  b=OrtC9xShCCBdYDiFXyuEt7kZnqrxbAe1aCKBpxvHrfUyvD+sf83gbedY
   ZuddY8/asvDRUt1ag6miIqvNOdeiGjjUGss7xek7MVGXEJps+AoPzS14/
   4sqPAZ49FhFjoTK6i+91S/5zU9tnNbm9wLbwOGZE6Mt7u1hR5VZDUFfsZ
   yh9C+f1r3sOPlIXwcWc0xl1LniAzwKYmp2lUywNrYW9FsuFPSmMDJpySf
   D4tUvFvNmjVDDrCxqpT3ZI7mMBbZqzPFmWVZRF3gP3T/ewt3nY5nPVBY9
   M5QxBMQ+I3LSZLAUBsP7JY/6bRTcPPSHNnJD2I624mkIPBMGvEqaJceBo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297157851"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297157851"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:16 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608835637"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:16 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v3 12/22] KVM: x86: Move TSC fixup logic to KVM arch resume callback
Date:   Thu,  1 Sep 2022 19:17:47 -0700
Message-Id: <52c8cafec868861963ceb182a9f5ae372b5d8204.1662084396.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662084396.git.isaku.yamahata@intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/x86.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 68def7ca224a..f5f4d8eed588 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11835,18 +11835,30 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
+
+	if (kvm_arch_hardware_enable())
+		return;
 
 	local_tsc = rdtsc();
 	stable = !kvm_check_tsc_unstable();
@@ -11921,13 +11933,6 @@ int kvm_arch_hardware_enable(void)
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

