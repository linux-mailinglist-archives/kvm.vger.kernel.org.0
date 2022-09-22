Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6712A5E6ABD
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbiIVSX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiIVSWq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:22:46 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0DC109608;
        Thu, 22 Sep 2022 11:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870919; x=1695406919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e6y3hm3ayzpDm9GqLzCdSOZ8vwYZDKw7HR+mXt4ONKk=;
  b=JdKoPH4gn0x+Waseq6+mHA1t/BQ16eTmtMy4bIVsc5n/JtLY+aLsOcTp
   zqBSs3VO8cZ2dSfjpzDVUqX1nos3wT6v/ojmoSMBvP+M1+08NmDJiiXBx
   OeHoy82E8f2AdNVmrJ89z0+GZddsvpapUuA5zmglfBHCOR5I7gI3G2bTB
   pwHehQZEmbkXtCyUBRk1zOAhLsFOUcMlwQvaVN0vU0s4ZWjCHqR+YWrVa
   7C8apRa7hckKxux1J+emhLQoI8usm7WeAQBk3l5ASTBQJ45vQMhpQO75D
   PPQbMCIksIhDxei+bw4F8KQLel3SmewH6GL6bdyw8GJ7nr12EkV8mUkff
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712904"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712904"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:23 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086790"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:23 -0700
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
Subject: [PATCH v5 19/30] KVM: kvm_arch.c: Remove a global variable, hardware_enable_failed
Date:   Thu, 22 Sep 2022 11:20:48 -0700
Message-Id: <7f85a41f7aaad91c062eef37669c1eda2632ba45.1663869838.git.isaku.yamahata@intel.com>
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

A global variable hardware_enable_failed in kvm_arch.c is used only by
kvm_arch_add_vm() and hardware_enable().  It doesn't have to be a global
variable.  Make it function local.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_arch.c | 61 ++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index e6bf9de18cba..10fd29bdd6e1 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -13,7 +13,6 @@
 #include <linux/kvm_host.h>
 
 static cpumask_t cpus_hardware_enabled = CPU_MASK_NONE;
-static atomic_t hardware_enable_failed;
 
 /*
  * Called after the VM is otherwise initialized, but just before adding it to
@@ -24,7 +23,7 @@ int __weak kvm_arch_post_init_vm(struct kvm *kvm)
 	return 0;
 }
 
-static void hardware_enable(void *junk)
+static int __hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
 	int r;
@@ -32,18 +31,22 @@ static void hardware_enable(void *junk)
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
 		pr_warn("kvm: enabling virtualization on CPU%d failed during %pSb\n",
 			cpu, __builtin_return_address(0));
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
+	if (__hardware_enable())
+		atomic_inc(failed);
 }
 
 static void hardware_disable(void *junk)
@@ -64,15 +67,15 @@ static void hardware_disable(void *junk)
  */
 int __weak kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 {
+	atomic_t failed = ATOMIC_INIT(0);
 	int r = 0;
 
 	if (usage_count != 1)
 		return 0;
 
-	atomic_set(&hardware_enable_failed, 0);
-	on_each_cpu(hardware_enable, NULL, 1);
+	on_each_cpu(hardware_enable, &failed, 1);
 
-	if (atomic_read(&hardware_enable_failed)) {
+	if (atomic_read(&failed)) {
 		r = -EBUSY;
 		goto err;
 	}
@@ -95,33 +98,29 @@ int __weak kvm_arch_del_vm(int usage_count)
 
 int __weak kvm_arch_online_cpu(unsigned int cpu, int usage_count)
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
+	 * arch callback kvm_arch_hardware_enable() assumes that
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
+	ret = __hardware_enable();
+	preempt_enable();
 
-		/*
-		 * arch callback kvm_arch_hardware_eanble() assumes that
-		 * preemption is disabled for historical reason.  Disable
-		 * preemption until all arch callbacks are fixed.
-		 */
-		preempt_disable();
-		hardware_enable(NULL);
-		preempt_enable();
-		if (atomic_read(&hardware_enable_failed)) {
-			atomic_set(&hardware_enable_failed, 0);
-			ret = -EIO;
-		}
-	}
 	return ret;
 }
 
@@ -160,5 +159,5 @@ int __weak kvm_arch_suspend(int usage_count)
 void __weak kvm_arch_resume(int usage_count)
 {
 	if (usage_count)
-		hardware_enable(NULL);
+		(void)__hardware_enable();
 }
-- 
2.25.1

