Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B265A62C8
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiH3MCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiH3MCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:02:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5BCE830A;
        Tue, 30 Aug 2022 05:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860921; x=1693396921;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tGT6aN2J7OkyrHuSTFcMkwLGe6Avk3mojHwqe3QkYZQ=;
  b=f4ylNustuQ8RJJdGNZY1dGRnZigmahv1TpRC28RHtwRNfmfoDtxg/XQr
   FLdo+7lWq3UNEgPepevrepRt8AL5cvcSmtSw6ID15c1tUjQgX0+3VQ7M0
   dTDG37Z1TNz+QIPv1jw5c8c1hXqtHfbjNVAx3OTgnegm9E/spzSjwbXRU
   fo3JFABFKb7XHytgcNfzJoNIK/r7r4KlWhN5nLtJVDja5IP5m45M2gdLO
   z0V/AO+48r1OVKYqvySoYNjjlrkZBMMXf1/KDrdBG9RZRJqUl9AIk5mur
   cItWYcp7U2WXmv5S10Nxsqm8cmcjxExsjuggubdTyqJDn3KTlfqKrMKIZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870985"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870985"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:58 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469647"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:58 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 12/19] KVM: kvm_arch.c: Remove a global variable, hardware_enable_failed
Date:   Tue, 30 Aug 2022 05:01:27 -0700
Message-Id: <078f2c056134ffe867c5ce72a1e7608fa4064779.1661860550.git.isaku.yamahata@intel.com>
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

A global variable hardware_enable_failed in kvm_arch.c is used only by
kvm_arch_add_vm() and hardware_enable().  It doesn't have to be a global
variable.  Make it function local.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_arch.c | 56 +++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 491e92ef9e3d..3990f85edab3 100644
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
 
-static void hardware_enable(void *junk)
+static int __hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
 	int r;
@@ -28,17 +27,21 @@ static void hardware_enable(void *junk)
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
 		pr_info("kvm: enabling virtualization on CPU%d failed\n", cpu);
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
@@ -64,15 +67,16 @@ __weak void kvm_arch_pre_hardware_unsetup(void)
  */
 __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 {
+	atomic_t failed;
 	int r = 0;
 
 	if (usage_count != 1)
 		return 0;
 
-	atomic_set(&hardware_enable_failed, 0);
-	on_each_cpu(hardware_enable, NULL, 1);
+	atomic_set(&failed, 0);
+	on_each_cpu(hardware_enable, &failed, 1);
 
-	if (atomic_read(&hardware_enable_failed)) {
+	if (atomic_read(&failed)) {
 		r = -EBUSY;
 		goto err;
 	}
@@ -95,23 +99,15 @@ __weak int kvm_arch_del_vm(int usage_count)
 
 __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
-	int ret = 0;
-
-	/*
-	 * Abort the CPU online process if hardware virtualization cannot
-	 * be enabled. Otherwise running VMs would encounter unrecoverable
-	 * errors when scheduled to this CPU.
-	 */
 	if (usage_count) {
-		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
-
-		hardware_enable(NULL);
-		if (atomic_read(&hardware_enable_failed)) {
-			atomic_set(&hardware_enable_failed, 0);
-			ret = -EIO;
-		}
+		/*
+		 * Abort the CPU online process if hardware virtualization cannot
+		 * be enabled. Otherwise running VMs would encounter unrecoverable
+		 * errors when scheduled to this CPU.
+		 */
+		return __hardware_enable();
 	}
-	return ret;
+	return 0;
 }
 
 __weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
@@ -137,5 +133,5 @@ __weak int kvm_arch_suspend(int usage_count)
 __weak void kvm_arch_resume(int usage_count)
 {
 	if (usage_count)
-		hardware_enable(NULL);
+		(void)__hardware_enable();
 }
-- 
2.25.1

