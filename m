Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C457F5B2A5B
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiIHX2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiIHX1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:27:30 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D0512BFB6;
        Thu,  8 Sep 2022 16:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679596; x=1694215596;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uTlu+lHOAwTFFFIR0Z5wSVQO4elx9U+QQnE27PbJEgI=;
  b=fmDXdacA3LOgbxkfXNzvL34Zi04ynPF3nvJlalXApcstUup+IhxArG2L
   6ll1bf/hFXo2MDc3GXMhrIJ/lE4zhU+BQPBSTEPIJK6b0AZgwCWehYgdx
   JwFolvDcRv3WHoeXBBkTVwGXEXaNL24P7oUPSMhA777szxL4zx8QBb81w
   6XCKTL8GLLVcdSq4Rw6AaKNu5XTN+b2jYe1J9MO2cJJ97SFUswTOH436R
   t0Q/tJI3TQJDR8pPG92zmr0y/a+c0FxDPp3snLhEvBgNngkpA2Zw1XIRr
   mpqxeGAGJ++uM4i0ZmRnwCj9gc1dzUAC57LhlfHudi9PN/TpIRMbVtcWT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687060"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687060"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:17 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863298"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:17 -0700
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
Subject: [PATCH v4 26/26] RFC: KVM: Remove cpus_hardware_enabled and related sanity check
Date:   Thu,  8 Sep 2022 16:25:42 -0700
Message-Id: <76ddec4c5fa3d84d422d3b90739c6a09d13d4bbc.1662679124.git.isaku.yamahata@intel.com>
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

cpus_hardware_enabled mask seems incomplete protection against other kernel
component using CPU virtualization feature.  Because it's obscure and
incomplete, remove the check.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_arch.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 68fb679d71f2..383b0065ecb0 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -12,23 +12,16 @@
 
 #include <linux/kvm_host.h>
 
-static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
-
 static int __hardware_enable(void *caller_name)
 {
-	int cpu = raw_smp_processor_id();
 	int r;
 
 	WARN_ON_ONCE(preemptible());
 
-	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
-		return 0;
 	r = kvm_arch_hardware_enable();
 	if (r)
 		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
-			cpu, (const char *)caller_name);
-	else
-		cpumask_set_cpu(cpu, &cpus_hardware_enabled);
+			smp_processor_id(), (const char *)caller_name);
 	return r;
 }
 
@@ -42,13 +35,7 @@ static void hardware_enable(void *arg)
 
 static void hardware_disable(void *junk)
 {
-	int cpu = raw_smp_processor_id();
-
 	WARN_ON_ONCE(preemptible());
-
-	if (!cpumask_test_cpu(cpu, &cpus_hardware_enabled))
-		return;
-	cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
 	kvm_arch_hardware_disable();
 }
 
-- 
2.25.1

