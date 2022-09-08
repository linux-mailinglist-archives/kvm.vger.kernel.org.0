Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5CD5B2A40
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiIHX0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiIHX0b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:31 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61005108722;
        Thu,  8 Sep 2022 16:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679574; x=1694215574;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N9V8aeLBeDyUCKjwvv3vkqyPtF2+WfmFX4Ug1U3Osmg=;
  b=HnIznXfiQs5okBhy8EWZxhIb+1oQmqqDS495TPsYv1dlKAyUzZ0Bcedx
   sa7tU2esSaypJIZ3K9ZY5pK8Iii+2AL3EykpNKX5GqZ1k20TWCBDUYU4I
   FleJYFAawzAL3QgoXmTmx868x/To5VRV86HNRpXXIEtuHx/JXEeAfkd3t
   yV5056RRP9m08lJ0dMEBMxAsKwJjlhGNh84O+w59Fh+220buT1p96cwX7
   4qDW/6FdJeDXyz25TZAuYkn/s0SFiriygVAZNh8bDI/zWJLY5P0DlpaVx
   Fg/l3pQQtwGH2fwg4EFNYsPwcueHD4EXH0tQ54uY93p06FmNmAvXsdtiH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687017"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687017"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863245"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:11 -0700
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
Subject: [PATCH v4 16/26] KVM: kvm_arch.c: Remove a global variable, hardware_enable_failed
Date:   Thu,  8 Sep 2022 16:25:32 -0700
Message-Id: <60ca73d7d931ec8046ac50b20f05723a97ef643b.1662679124.git.isaku.yamahata@intel.com>
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

A global variable hardware_enable_failed in kvm_arch.c is used only by
kvm_arch_add_vm() and hardware_enable().  It doesn't have to be a global
variable.  Make it function local.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_arch.c | 62 ++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 4fe16e8ef2e5..ad23537ebe3b 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -13,14 +13,13 @@
 #include <linux/kvm_host.h>
 
 static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
-static atomic_t hardware_enable_failed;
 
 __weak int kvm_arch_post_init_vm(struct kvm *kvm)
 {
 	return 0;
 }
 
-static void hardware_enable(void *caller_name)
+static int __hardware_enable(void *caller_name)
 {
 	int cpu = raw_smp_processor_id();
 	int r;
@@ -28,18 +27,22 @@ static void hardware_enable(void *caller_name)
 	WARN_ON_ONCE(preemptible());
 
 	if (cpumask_test_cpu(cpu, &cpus_hardware_enabled))
-		return;
-
-	cpumask_set_cpu(cpu, &cpus_hardware_enabled);
-
+		return 0;
 	r = kvm_arch_hardware_enable();
-
-	if (r) {
-		cpumask_clear_cpu(cpu, &cpus_hardware_enabled);
-		atomic_inc(&hardware_enable_failed);
+	if (r)
 		pr_warn("kvm: enabling virtualization on CPU%d failed during %s()\n",
 			cpu, (const char *)caller_name);
-	}
+	else
+		cpumask_set_cpu(cpu, &cpus_hardware_enabled);
+	return r;
+}
+
+static void hardware_enable(void *arg)
+{
+	atomic_t *failed = arg;
+
+	if (__hardware_enable((void *)__func__))
+		atomic_inc(failed);
 }
 
 static void hardware_disable(void *junk)
@@ -65,15 +68,16 @@ __weak void kvm_arch_pre_hardware_unsetup(void)
  */
 __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 {
+	atomic_t failed;
 	int r = 0;
 
 	if (usage_count != 1)
 		return 0;
 
-	atomic_set(&hardware_enable_failed, 0);
-	on_each_cpu(hardware_enable, (void *)__func__, 1);
+	atomic_set(&failed, 0);
+	on_each_cpu(hardware_enable, &failed, 1);
 
-	if (atomic_read(&hardware_enable_failed)) {
+	if (atomic_read(&failed)) {
 		r = -EBUSY;
 		goto err;
 	}
@@ -96,33 +100,29 @@ __weak int kvm_arch_del_vm(int usage_count)
 
 __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
-	int ret = 0;
+	int ret;
 
 	ret = kvm_arch_check_processor_compat();
 	if (ret)
 		return ret;
 
+	if (!usage_count)
+		return 0;
+
+	/*
+	 * arch callback kvm_arch_hardware_eanble() assumes that
+	 * preemption is disabled for historical reason.  Disable
+	 * preemption until all arch callbacks are fixed.
+	 */
+	preempt_disable();
 	/*
 	 * Abort the CPU online process if hardware virtualization cannot
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
 	 * errors when scheduled to this CPU.
 	 */
-	if (usage_count) {
-		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
+	ret = __hardware_enable((void *)__func__);
+	preempt_enable();
 
-		/*
-		 * arch callback kvm_arch_hardware_eanble() assumes that
-		 * preemption is disabled for historical reason.  Disable
-		 * preemption until all arch callbacks are fixed.
-		 */
-		preempt_disable();
-		hardware_enable((void *)__func__);
-		preempt_enable();
-		if (atomic_read(&hardware_enable_failed)) {
-			atomic_set(&hardware_enable_failed, 0);
-			ret = -EIO;
-		}
-	}
 	return ret;
 }
 
@@ -168,7 +168,7 @@ __weak void kvm_arch_resume(int usage_count)
 
 	if (usage_count) {
 		preempt_disable();
-		hardware_enable((void *)__func__);
+		(void)__hardware_enable((void *)__func__);
 		preempt_enable();
 	}
 }
-- 
2.25.1

