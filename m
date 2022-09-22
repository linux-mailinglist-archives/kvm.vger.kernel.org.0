Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012EB5E6AD0
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbiIVSYo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbiIVSXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:23:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F7810D66B;
        Thu, 22 Sep 2022 11:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870954; x=1695406954;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0GvMWbVPXwgA7CdFobND5PDqeVhAEZxtFBVTWjqYWSY=;
  b=DKH4f+sthQUZKp0X5/i9XD8Mt6YsivATG3eWmp0eGebXJFZDyS1lvVos
   dCQHfjQsCpVWhEEEFxyvO+b34z6MmG12J0IS6GK/Y674+foTBbrhgT/+n
   8KpEzJBua7pX2maic5FYMka0WTmrOEKZvwVwqje8it09HrUVzqedrRP+c
   a1m2z/KI6aIokujfLf9DtGfgwmQaroNdHKK6jThb0ve1qKklr0/y78F78
   YUbGFc3BQ2d1UMtZRLdNf7hTbd4JR//+S1ErGaJRmO+GBe2fZtRPNrLa1
   H7q1akRzk8M4FP4dUnTzLUboNrojx1xBrydA8nqw1/NPIfFlIm/cRlble
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712948"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712948"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:30 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086946"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:29 -0700
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
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 29/30] RFC: KVM: x86: Remove cpus_hardware_enabled and related sanity check
Date:   Thu, 22 Sep 2022 11:20:58 -0700
Message-Id: <ee82358bc9b1235f46a141b5ded1e869779cf005.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

cpus_hardware_enabled mask seems incomplete protection against other kernel
component using CPU virtualization feature.  Because it's obscure and
incomplete, remove the check.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1f791c93391b..7505dd4ae695 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11958,23 +11958,16 @@ void kvm_arch_resume(int usage_count)
 	}
 }
 
-static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
-
 static int __hardware_enable(void)
 {
-	int cpu = raw_smp_processor_id();
 	int r;
 
 	WARN_ON_ONCE(preemptible());
 
-	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
-		return 0;
 	r = static_call(kvm_x86_hardware_enable)();
 	if (r)
 		pr_warn("kvm: enabling virtualization on CPU%d failed during %pSb\n",
-			cpu, __builtin_return_address(0));
-	else
-		cpumask_set_cpu(cpu, &cpus_hardware_enabled);
+			smp_processor_id(), __builtin_return_address(0));
 	return r;
 }
 
@@ -11988,13 +11981,7 @@ static void hardware_enable(void *arg)
 
 static void hardware_disable(void *junk)
 {
-	int cpu = raw_smp_processor_id();
-
 	WARN_ON_ONCE(preemptible());
-
-	if (!cpumask_test_cpu(cpu, &cpus_hardware_enabled))
-		return;
-	cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
 	static_call(kvm_x86_hardware_disable)();
 	drop_user_return_notifiers();
 }
-- 
2.25.1

