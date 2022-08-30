Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76BE5A62CE
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiH3MCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiH3MCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:02:36 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4B2EF9D8;
        Tue, 30 Aug 2022 05:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860928; x=1693396928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eeD6WJYKHUyfZ/PXC4poyF6VyKFe0V4LAqKVsAEhnLI=;
  b=CSqQfYURJd8rkqxNgLXcQ2YySp2cJZ49YZsXvGQmTFM47UqF307o167C
   M2AIfIJ/pzLxJek3sDX3iPRlkxmtgL+sIM9BEPH64jl9u5ceeAs/ASjxg
   EkqHM6eyfxM0cGi2PHkgZhD4tyb86Ncd4AmetbaeheQWTnEn3Kea/wJkl
   cCRUjXbpCocUB7kZEcz3VwxhptAomNQillKi/ZEw/wsR/dGITbodYYnup
   tBJcCOj2zchOhjndqlsFXQZM8eDzqC9S1hQLsXr1jDeuaR+wGTb+u7YcB
   wp3o83Y4AZjiNJp0Mnkkl06v0GnvaI0mO3fkPRXB9GViL0tIbGaxjSxNz
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356871006"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356871006"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:02:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469680"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:02:01 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 19/19] RFC: KVM: Remove cpus_hardware_enabled and related sanity check
Date:   Tue, 30 Aug 2022 05:01:34 -0700
Message-Id: <21b2efeb4b43605a8c1a327a3656650d96be0968.1661860550.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661860550.git.isaku.yamahata@intel.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
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

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_arch.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 8f2d920a2a8f..cbad0181c177 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -12,22 +12,16 @@
 
 #include <linux/kvm_host.h>
 
-static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
-
 static int __hardware_enable(void)
 {
-	int cpu = raw_smp_processor_id();
 	int r;
 
 	WARN_ON_ONCE(preemptible());
 
-	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
-		return 0;
 	r = kvm_arch_hardware_enable();
 	if (r)
-		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
-	else
-		cpumask_set_cpu(cpu, &cpus_hardware_enabled);
+		pr_info("kvm: enabling virtualization on CPU%d failed\n",
+			smp_processor_id());
 	return r;
 }
 
@@ -41,13 +35,7 @@ static void hardware_enable(void *arg)
 
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

