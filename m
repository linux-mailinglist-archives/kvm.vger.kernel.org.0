Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1B85AA5A1
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbiIBCTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiIBCS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:29 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EABAB04B;
        Thu,  1 Sep 2022 19:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085101; x=1693621101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n2jr9DdfRbZsXaFA0LJya90JyQP+3BfsD0hNGT1Sqww=;
  b=ksyNIr5dmVGSsnno3StbWgY01nRAWKXmZeCbX1tyIHyPs6EDQW3l9xkC
   y3HSe4zbGbdf6X9aR7DVId38L3EoUHAZANyD48v2fOob35rsm7FNiQmmv
   rL9OYMw4lHbVDPcvf2LfBuQGxRAfjpUqH/NvwAjysSnbG7kp6I193gwAa
   Zaf0Htrm71va5E4O7un0LW5NwhAScmuaEBSeABYMo/I3T3gV1xQdzJEEj
   FhT6AuOhV6sX7mFRd1qpLnLinxRTpbLi6cqTNJ2WIhUA8N7q9F4nvpwpY
   MAgokRQ8mIXXPRwhHGGpszOr4e5RQfTpSZNjZ+xuV76yTerB89rCQN2Zs
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297157866"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297157866"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:20 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608835668"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:20 -0700
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
Subject: [PATCH v3 19/22] KVM: x86: Delete kvm_arch_hardware_enable/disable()
Date:   Thu,  1 Sep 2022 19:17:54 -0700
Message-Id: <ced5fb5b451d141dec5d8de3e3cadb4bf2a88f10.1662084396.git.isaku.yamahata@intel.com>
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

Now they're function call and there is no point to keep them.
Opportunistically make kvm_arch_pre_hardware_unsetup() empty.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fa68bea655f0..f0382f3d5baf 100644
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
@@ -11834,17 +11834,6 @@ void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
 
 static int __hardware_enable(void *caller_name)
@@ -11856,7 +11845,7 @@ static int __hardware_enable(void *caller_name)
 
 	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
 		return 0;
-	r = kvm_arch_hardware_enable();
+	r = static_call(kvm_x86_hardware_enable)();
 	if (r)
 		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
 			cpu, (const char *)caller_name);
@@ -11882,12 +11871,13 @@ static void hardware_disable(void *junk)
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
@@ -11978,7 +11968,7 @@ void kvm_arch_resume(int usage_count)
 
 	if (kvm_arch_check_processor_compat())
 		return;
-	if (kvm_arch_hardware_enable())
+	if (static_call(kvm_x86_hardware_enable)())
 		return;
 
 	local_tsc = rdtsc();
@@ -12119,6 +12109,8 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
+	on_each_cpu(hardware_disable, NULL, 1);
+
 	kvm_unregister_perf_callbacks();
 
 	static_call(kvm_x86_hardware_unsetup)();
-- 
2.25.1

