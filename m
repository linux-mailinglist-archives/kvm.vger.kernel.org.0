Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966BF5B2A53
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbiIHX2G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiIHX1C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:27:02 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53723D5733;
        Thu,  8 Sep 2022 16:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679581; x=1694215581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PXL7ArSkr52FAXL2U6zZPaAJzjUWlibVnvn3LNa2quU=;
  b=XNYjFe6YdTqOvD3ibWqpzWaDPKGHq1kBZgxYiQNvH5U7PCZ9+jB9LNm1
   pjagHijfPBu/RDQBoNE2pjd7Qru84TqE1GSch8XZZ2/V7zjtariD9/AIq
   0WXrbwRx8hjuJ11Ti6dhIUHwBbpI5YGnQOotedpHijuFoVxgVIsd7+dEq
   ZvZVDSqRe0pNyjT1GntobxitOhjQjd/WwqftDKjh3ZwBAk4pAOhPK1TLP
   vi+eHS9uE8QcArRaHVke8UMDzP+CWTiefhMEp7n+K4VNA0Z//kP7ZYtVQ
   zzXDQ4+w4aMk5f/+01NProzBNaFBsgcy+22v3oNk7H3q6RByfSy+jzrki
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687034"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687034"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863271"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:14 -0700
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
Subject: [PATCH v4 21/26] KVM: x86: Delete kvm_arch_hardware_enable/disable()
Date:   Thu,  8 Sep 2022 16:25:37 -0700
Message-Id: <c7b28e898623e22f9732c038d93366ecc70e2d33.1662679124.git.isaku.yamahata@intel.com>
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

Now they're function call and there is no point to keep them.
Opportunistically make kvm_arch_pre_hardware_unsetup() empty.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c       | 27 +++++++--------------------
 include/linux/kvm_host.h |  6 ++++--
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6dcc6ed90421..0c9d965859c6 100644
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
@@ -11882,12 +11871,8 @@ static void hardware_disable(void *junk)
 	if (!cpumask_test_cpu(cpu, &cpus_hardware_enabled))
 		return;
 	cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
-	kvm_arch_hardware_disable();
-}
-
-void kvm_arch_pre_hardware_unsetup(void)
-{
-	on_each_cpu(hardware_disable, NULL, 1);
+	static_call(kvm_x86_hardware_disable)();
+	drop_user_return_notifiers();
 }
 
 /*
@@ -12019,7 +12004,7 @@ void kvm_arch_resume(int usage_count)
 		return;
 
 	preempt_disable();
-	if (kvm_arch_hardware_enable()) {
+	if (static_call(kvm_x86_hardware_enable)()) {
 		preempt_enable();
 		return;
 	}
@@ -12163,6 +12148,8 @@ int kvm_arch_hardware_setup(void *opaque)
 
 void kvm_arch_hardware_unsetup(void)
 {
+	on_each_cpu(hardware_disable, NULL, 1);
+
 	kvm_unregister_perf_callbacks();
 
 	static_call(kvm_x86_hardware_unsetup)();
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f538fc3356a9..5f4d6f641b03 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1434,13 +1434,15 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
-#ifndef CONFIG_HAVE_KVM_OVERRIDE_HARDWARE_ENABLE
+#ifdef CONFIG_HAVE_KVM_OVERRIDE_HARDWARE_ENABLE
+static inline void kvm_arch_pre_hardware_unsetup(void) {}
+#else
+void kvm_arch_pre_hardware_unsetup(void);
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 #endif
 
 int kvm_arch_hardware_setup(void *opaque);
-void kvm_arch_pre_hardware_unsetup(void);
 void kvm_arch_hardware_unsetup(void);
 int kvm_arch_check_processor_compat(void);
 int kvm_arch_check_processor_compat_all(void);
-- 
2.25.1

