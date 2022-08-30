Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D84C5A62C9
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiH3MCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiH3MCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:02:15 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B2AEEF03;
        Tue, 30 Aug 2022 05:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860926; x=1693396926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DKukNtisSOiD+eagzRE30K2nu8p0CySa/kXhW91x3mY=;
  b=TJtyW0zvQccpI3+wUx8aXF7K3yPlxLhge+Drf7iP9M015vuzHkrysB5z
   K/gaY1Jn4IFiOVi0KGTM/SfBg45yo3GFpjsf1sSdmF7qo6J8ef/6BNh41
   +oeK8ajK7+92jjvmxPV/q0yCKLpQt0KC86uWR7hstOkT5ZDiKpjgSOn8t
   cCmu6Lq5ShYL5AVbqlWGGEXToWGKzImLTgbqzD9caeeBJNMbWmcUeN6WI
   9LFECkyLitUdk/wZ1yvcXaBwWM6Y235C8Npy5NPQNXVp3m5RQhfu5Tfln
   EZKex8od5r2HoB7Q5Ri7tRH2YVpS4QSgbnDrJCNUksTKvZcQ3IpZ8d1hb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356871005"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356871005"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:02:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469675"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:02:01 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 18/19] RFC: KVM: x86: Remove cpus_hardware_enabled and related sanity check
Date:   Tue, 30 Aug 2022 05:01:33 -0700
Message-Id: <e87b04d4eae5c14b8f410085b549311113fa8a53.1661860550.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/x86.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 14a464f7302b..10b83cbb29ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11830,22 +11830,15 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
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
-		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
-	else
-		cpumask_set_cpu(cpu, &cpus_hardware_enabled);
+		pr_info("kvm: enabling virtualization on CPU%d failed\n", smp_processor_id());
 	return r;
 }
 
@@ -11859,13 +11852,7 @@ static void hardware_enable(void *arg)
 
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

