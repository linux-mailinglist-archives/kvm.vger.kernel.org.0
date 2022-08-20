Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD81159AB9A
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245387AbiHTGBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244589AbiHTGAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366BFA2628;
        Fri, 19 Aug 2022 23:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975253; x=1692511253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IHSa0WBYx0BgB2/RDKlw4uOS3JdT2/kSZliV76NwxJ8=;
  b=k3VcEZhkz9WFbeBZbbo9MnLW1HNtDZZoSrf11hfSqVdAa58Wa/qLbIVD
   z7Xaa0Z9NWalueumBGYAUISGDGUO6PpWN3vWlJcpc9N0r5Frfb//8Ey19
   grRzJY0+ePrfUngwGTAq9bGM3pu07pvh4itJqXgABMsAx3UPTRDNZP4i2
   Mn1p2XzqAwYCe3jrYpuv2ZDhiPM1FuqnmvoLH/AEKCKZhAjZ84umJ31uf
   WO2OU/B/FSx+trV84I+uo4PbZ9r1mQEx7YZJeqjtB2QczR+rMPKAO/HyP
   p7NuueULFHa1jP5q4qFylR+Np9NDfiY30/O3D2Pom2Ja8XA9OK35/pXxq
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448982"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448982"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:51 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857558"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 15/18] KVM: x86: Delete kvm_arch_hardware_enable/disable()
Date:   Fri, 19 Aug 2022 23:00:21 -0700
Message-Id: <49aa53f11283b826ccbca3755e2548464b7f8db7.1660974106.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660974106.git.isaku.yamahata@intel.com>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
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
index a1e8d15aa6b8..5aa6d5308ee8 100644
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
@@ -11968,7 +11958,7 @@ void kvm_arch_resume(int usage_count)
 
 	if (kvm_arch_check_processor_compat())
 		return;
-	if (kvm_arch_hardware_enable())
+	if (static_call(kvm_x86_hardware_enable)())
 		return;
 
 	local_tsc = rdtsc();
@@ -12109,6 +12099,8 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
+	on_each_cpu(hardware_disable, NULL, 1);
+
 	kvm_unregister_perf_callbacks();
 
 	static_call(kvm_x86_hardware_unsetup)();
-- 
2.25.1

