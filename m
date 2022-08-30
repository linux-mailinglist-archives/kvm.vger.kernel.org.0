Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592085A62C3
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiH3MCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiH3MCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:02:13 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709CEEEC61;
        Tue, 30 Aug 2022 05:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860926; x=1693396926;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4GLX7fTifeZyrCGo7kfB6NRlR+GNm5ga5j3w/Xl68d0=;
  b=mUyFsNGLqPeMsXecwvwgYcEy9cEE00SxC7EtLO0WZgAIkEs3fPFquxCb
   ivKOmdacTCHPC2z6lbVsoZ++IGnAaIpBpCWE0xEwv8R91XqNWT0ReDb7C
   QSIDdt1ToarVbN+g1TNf3TeB+r7p+wfPswfWSAfxQ4GK1iBay7e9zKWpm
   NL37/ma/OuYvJTvMRtUyskVvDQ+bT303/NImaOQEHVQ8a+lQIdWzqO2hv
   ULKLwjM5+7Src6BNmhpNa15n5BUR5t2B03VRpJhHdeff6lnyoPmn4cyD1
   6RciqwxkEUBIp5V6kMekQouJCTcuOv/5RbU5LReGrzeIndZyp/wn+ZSI2
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870998"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870998"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:02:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469662"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:02:00 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 16/19] KVM: x86: Delete kvm_arch_hardware_enable/disable()
Date:   Tue, 30 Aug 2022 05:01:31 -0700
Message-Id: <d87320d8734edb830a207d4caae375d81e4b5f61.1661860550.git.isaku.yamahata@intel.com>
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

Now they're function call and there is no point to keep them.
Opportunistically make kvm_arch_pre_hardware_unsetup() empty.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5f066138ee9..14a464f7302b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -354,7 +354,7 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 
 	/*
 	 * Disabling irqs at this point since the following code could be
-	 * interrupted and executed through kvm_arch_hardware_disable()
+	 * interrupted and executed through hardware_disable()
 	 */
 	local_irq_save(flags);
 	if (msrs->registered) {
@@ -11830,17 +11830,6 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_deliver_sipi_vector);
 
-int kvm_arch_hardware_enable(void)
-{
-	return static_call(kvm_x86_hardware_enable)();
-}
-
-void kvm_arch_hardware_disable(void)
-{
-	static_call(kvm_x86_hardware_disable)();
-	drop_user_return_notifiers();
-}
-
 static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
 
 static int __hardware_enable(void)
@@ -11852,7 +11841,7 @@ static int __hardware_enable(void)
 
 	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
 		return 0;
-	r = kvm_arch_hardware_enable();
+	r = static_call(kvm_x86_hardware_enable)();
 	if (r)
 		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
 	else
@@ -11877,12 +11866,13 @@ static void hardware_disable(void *junk)
 	if (!cpumask_test_cpu(cpu, &cpus_hardware_enabled))
 		return;
 	cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
-	kvm_arch_hardware_disable();
+	static_call(kvm_x86_hardware_disable)();
+	drop_user_return_notifiers();
 }
 
 void kvm_arch_pre_hardware_unsetup(void)
 {
-	on_each_cpu(hardware_disable, NULL, 1);
+	/* TODO: eliminate this function */
 }
 
 /*
@@ -11974,7 +11964,7 @@ void kvm_arch_resume(int usage_count)
 
 	if (kvm_arch_check_processor_compat())
 		return;
-	if (kvm_arch_hardware_enable())
+	if (static_call(kvm_x86_hardware_enable)())
 		return;
 
 	local_tsc = rdtsc();
@@ -12115,6 +12105,8 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
+	on_each_cpu(hardware_disable, NULL, 1);
+
 	kvm_unregister_perf_callbacks();
 
 	static_call(kvm_x86_hardware_unsetup)();
-- 
2.25.1

