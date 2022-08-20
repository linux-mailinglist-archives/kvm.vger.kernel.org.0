Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B422F59AB9D
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244674AbiHTGA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244217AbiHTGAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DBBA260A;
        Fri, 19 Aug 2022 23:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975249; x=1692511249;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0AYhMY6fJqrli/t5ys1IPzbYaiXeLEr/7lceDSDM3tw=;
  b=FMFKAOJX+8eiMsYlL5ED4+LvG1wf1iZI2/QkTFtYsejdBIaXlefKTAO/
   CCfhIpRM7PkLChoOzdQ75avpV4PBHi4jplpPP17W1VNHINkfJciBw36DJ
   gPa56ruf2mHwTvEhQ66eRvJdglJWtz6lqpQjNng3n0ichMrcnHdSNtRYT
   qvcWnn3cxb6FQ+RK9HE3Cvd7K9JrGVBMArmIyxJKo4B86WvaZLq8SzW7C
   Bt2shy0JQ/lHlpjrROsb04GliTklxbDR+7nFhfsKRZFi7h8skHWp56E7f
   vNXGCznFsShm3ZBYkU0Z1XaP+UAYmgb4ANzUrTasmpehAZ4VC+6DevXIT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448969"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448969"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857517"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 03/18] KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock
Date:   Fri, 19 Aug 2022 23:00:09 -0700
Message-Id: <6b07c02dd361f834fea442eb8dae53f23618f983.1660974106.git.isaku.yamahata@intel.com>
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

Because kvm_count_lock unnecessarily complicates the KVM locking convention
Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock for
simplicity.

Opportunistically add some comments on locking.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/locking.rst | 14 +++++-------
 virt/kvm/kvm_main.c                | 36 +++++++++++++++++++++---------
 2 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 845a561629f1..8957e32aa724 100644
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
+                migration.  The lock order is cpus lock => kvm_lock.
 
 ``kvm->mn_invalidate_lock``
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 515dfe9d3bcf..c6781fa30461 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -100,7 +100,6 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
  */
 
 DEFINE_MUTEX(kvm_lock);
-static DEFINE_RAW_SPINLOCK(kvm_count_lock);
 LIST_HEAD(vm_list);
 
 static cpumask_var_t cpus_hardware_enabled;
@@ -4999,6 +4998,8 @@ static void hardware_enable_nolock(void *junk)
 	int cpu = raw_smp_processor_id();
 	int r;
 
+	WARN_ON_ONCE(preemptible());
+
 	if (cpumask_test_cpu(cpu, cpus_hardware_enabled))
 		return;
 
@@ -5015,10 +5016,10 @@ static void hardware_enable_nolock(void *junk)
 
 static int kvm_starting_cpu(unsigned int cpu)
 {
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 	if (kvm_usage_count)
 		hardware_enable_nolock(NULL);
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	return 0;
 }
 
@@ -5026,6 +5027,8 @@ static void hardware_disable_nolock(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 
+	WARN_ON_ONCE(preemptible());
+
 	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
 		return;
 	cpumask_clear_cpu(cpu, cpus_hardware_enabled);
@@ -5034,10 +5037,10 @@ static void hardware_disable_nolock(void *junk)
 
 static int kvm_dying_cpu(unsigned int cpu)
 {
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	return 0;
 }
 
@@ -5052,16 +5055,19 @@ static void hardware_disable_all_nolock(void)
 
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
 {
 	int r = 0;
 
-	raw_spin_lock(&kvm_count_lock);
+	cpus_read_lock();
+	mutex_lock(&kvm_lock);
 
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
@@ -5074,7 +5080,8 @@ static int hardware_enable_all(void)
 		}
 	}
 
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
+	cpus_read_unlock();
 
 	return r;
 }
@@ -5680,15 +5687,22 @@ static void kvm_init_debug(void)
 
 static int kvm_suspend(void)
 {
-	if (kvm_usage_count)
+	/*
+	 * The caller ensures that CPU hotlug is disabled by
+	 * cpu_hotplug_disable() and other CPUs are offlined.  No need for
+	 * locking.
+	 */
+	if (kvm_usage_count) {
+		lockdep_assert_not_held(&kvm_lock);
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

