Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E69E5E6A9F
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbiIVSVg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiIVSVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:21:25 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A89C10AB17;
        Thu, 22 Sep 2022 11:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870884; x=1695406884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=48U9dCYj/WeMAxDcm+7eitcQw4Ht0b3752iS3YU0zk8=;
  b=O1Imqpgp+JYoateUNcb+NiVQ1dhXgU4tDEgdfZrpn8bDP76mr0RPmSc3
   jvHJyJGVEBUtsvqQCAJI0ceyj366yN+uFS351rJOk9CIm426SV2S4Wox6
   ddt0r2Q3ax2RMCkV6lIAfRPW43s8HhGspMcc9rP4V7PzMDd3z+XYVUdcs
   2Aq18wzRd8H8vHuTPcVG4PqqRHfdOux/XWJipwK8X+33UQWxZkBG2u4S3
   6lHDnPLuZQ/L+NhiF58zuKFkXJe1sxKd/vv0YI2O98nq/5mZi+5KM4QKg
   nXduQdiiJe8GsZTUh6ROpphDwp+ZtrpW6LqZus/Lm1c+vcd9dddjz5az0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="386675974"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="386675974"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:17 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086696"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:17 -0700
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
Subject: [PATCH v5 09/30] KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock
Date:   Thu, 22 Sep 2022 11:20:38 -0700
Message-Id: <92836b09c8e0f19f8e506008e45993881d22b6d1.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because kvm_count_lock unnecessarily complicates the KVM locking convention
Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock for
simplicity.  kvm_arch_hardware_enable/disable() callbacks depend on
non-preemptiblity with the spin lock.  Add preempt_disable/enable()
around hardware enable/disable callback to keep the assumption.

Because kvm_suspend() and kvm_resume() is called with interrupt disabled,
they don't need preempt_disable/enable() pair.

Opportunistically add some comments on locking.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/locking.rst | 14 +++-----
 virt/kvm/kvm_main.c                | 56 +++++++++++++++++++++++-------
 2 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 845a561629f1..55d6559ace2a 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -216,15 +216,11 @@ time it will be set using the Dirty tracking mechanism described above.
 :Type:		mutex
 :Arch:		any
 :Protects:	- vm_list
-
-``kvm_count_lock``
-^^^^^^^^^^^^^^^^^^
-
-:Type:		raw_spinlock_t
-:Arch:		any
-:Protects:	- hardware virtualization enable/disable
-:Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
-		migration.
+                - kvm_usage_count
+                - hardware virtualization enable/disable
+:Comment:	Use cpus_read_lock() for hardware virtualization enable/disable
+                because hardware enabling/disabling must be atomic /wrt
+                CPU hotplug.  The lock order is cpus lock => kvm_lock.
 
 ``kvm->mn_invalidate_lock``
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b1bf44af523c..c4b908553726 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -100,7 +100,6 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
  */
 
 DEFINE_MUTEX(kvm_lock);
-static DEFINE_RAW_SPINLOCK(kvm_count_lock);
 LIST_HEAD(vm_list);
 
 static cpumask_var_t cpus_hardware_enabled;
@@ -4996,6 +4995,8 @@ static void hardware_enable_nolock(void *junk)
 	int cpu = raw_smp_processor_id();
 	int r;
 
+	WARN_ON_ONCE(preemptible());
+
 	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
 		return;
 
@@ -5019,7 +5020,7 @@ static int kvm_online_cpu(unsigned int cpu)
 	if (ret)
 		return ret;
 
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 	/*
 	 * Abort the CPU online process if hardware virtualization cannot
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
@@ -5028,13 +5029,20 @@ static int kvm_online_cpu(unsigned int cpu)
 	if (kvm_usage_count) {
 		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
 
+		/*
+		 * arch callback kvm_arch_hardware_eanble() assumes that
+		 * preemption is disabled for historical reason.  Disable
+		 * preemption until all arch callbacks are fixed.
+		 */
+		preempt_disable();
 		hardware_enable_nolock(NULL);
+		preempt_enable();
 		if (atomic_read(&hardware_enable_failed)) {
 			atomic_set(&hardware_enable_failed, 0);
 			ret = -EIO;
 		}
 	}
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	return ret;
 }
 
@@ -5042,6 +5050,8 @@ static void hardware_disable_nolock(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 
+	WARN_ON_ONCE(preemptible());
+
 	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
 		return;
 	cpumask_clear_cpu(cpu, cpus_hardware_enabled);
@@ -5050,10 +5060,18 @@ static void hardware_disable_nolock(void *junk)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	raw_spin_lock(&kvm_count_lock);
-	if (kvm_usage_count)
+	mutex_lock(&kvm_lock);
+	if (kvm_usage_count) {
+		/*
+		 * arch callback kvm_arch_hardware_disable() assumes that
+		 * preemption is disabled for historical reason.  Disable
+		 * preemption until all arch callbacks are fixed.
+		 */
+		preempt_disable();
 		hardware_disable_nolock(NULL);
-	raw_spin_unlock(&kvm_count_lock);
+		preempt_enable();
+	}
+	mutex_unlock(&kvm_lock);
 	return 0;
 }
 
@@ -5068,9 +5086,11 @@ static void hardware_disable_all_nolock(void)
 
 static void hardware_disable_all(void)
 {
-	raw_spin_lock(&kvm_count_lock);
+	cpus_read_lock();
+	mutex_lock(&kvm_lock);
 	hardware_disable_all_nolock();
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
+	cpus_read_unlock();
 }
 
 static int hardware_enable_all(void)
@@ -5088,7 +5108,7 @@ static int hardware_enable_all(void)
 	 * Disable CPU hotplug to prevent this case from happening.
 	 */
 	cpus_read_lock();
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
@@ -5101,7 +5121,7 @@ static int hardware_enable_all(void)
 		}
 	}
 
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	cpus_read_unlock();
 
 	return r;
@@ -5708,15 +5728,27 @@ static void kvm_init_debug(void)
 
 static int kvm_suspend(void)
 {
-	if (kvm_usage_count)
+	/*
+	 * The caller ensures that CPU hotplug is disabled by
+	 * cpu_hotplug_disable() and other CPUs are offlined.  No need for
+	 * locking.
+	 */
+	lockdep_assert_not_held(&kvm_lock);
+
+	if (kvm_usage_count) {
+		/*
+		 * Because kvm_suspend() is called with interrupt disabled,  no
+		 * need to disable preemption.
+		 */
 		hardware_disable_nolock(NULL);
+	}
 	return 0;
 }
 
 static void kvm_resume(void)
 {
 	if (kvm_usage_count) {
-		lockdep_assert_not_held(&kvm_count_lock);
+		lockdep_assert_not_held(&kvm_lock);
 		hardware_enable_nolock(NULL);
 	}
 }
-- 
2.25.1

