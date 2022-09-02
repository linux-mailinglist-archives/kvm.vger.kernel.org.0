Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398B35AA599
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235106AbiIBCSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiIBCSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:16 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5312AA3EA;
        Thu,  1 Sep 2022 19:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085095; x=1693621095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gFAtLr34ysA/aw7FXhfNAobiH3GISmSUXQkg/JKR0jI=;
  b=ja/tChZ50sfjsZ3lipW3jgOKgHA8uBK3yTv3RZNkt6EIJ/SH+HztzP0j
   3+hw3dkS4hHrUwCuIe0MsYXU7KMaFtUrFFG1ZVUBfXOo1hDq2pgchpLAR
   8qNAWdEGeXR5zAfyso5suwEp7dhNmMpuYf1/AkNCiASU9blBurYo7nZc8
   6HJIjeDdj6XxPY9HUtFehtvP9b5D6kruAyGhC47ugKgt2hxwFHQogkrbN
   ryC+N3+KtvswaXv15J1HaCIr25kp/OE4z3OcxoqUBFsflWQw4kbfbiS2K
   EYDY3/GiPWBRPWZ2lR5F2NsiMIedv2rJN8Jrp0A4rD8FtXP+rUzfs7Awe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297157847"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297157847"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:15 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608835628"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:15 -0700
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
Subject: [PATCH v3 10/22] KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock
Date:   Thu,  1 Sep 2022 19:17:45 -0700
Message-Id: <20212af31729ba27e29c3856b78975c199b5365c.1662084396.git.isaku.yamahata@intel.com>
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

Because kvm_count_lock unnecessarily complicates the KVM locking convention
Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock for
simplicity.

Opportunistically add some comments on locking.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 Documentation/virt/kvm/locking.rst | 14 +++++-------
 virt/kvm/kvm_main.c                | 34 ++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 20 deletions(-)

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
index fc55447c4dba..082d5dbc8d7f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -100,7 +100,6 @@ EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);
  */
 
 DEFINE_MUTEX(kvm_lock);
-static DEFINE_RAW_SPINLOCK(kvm_count_lock);
 LIST_HEAD(vm_list);
 
 static cpumask_var_t cpus_hardware_enabled;
@@ -4996,6 +4995,8 @@ static void hardware_enable_nolock(void *caller_name)
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
@@ -5034,7 +5035,7 @@ static int kvm_online_cpu(unsigned int cpu)
 			ret = -EIO;
 		}
 	}
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	return ret;
 }
 
@@ -5042,6 +5043,8 @@ static void hardware_disable_nolock(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 
+	WARN_ON_ONCE(preemptible());
+
 	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
 		return;
 	cpumask_clear_cpu(cpu, cpus_hardware_enabled);
@@ -5050,10 +5053,10 @@ static void hardware_disable_nolock(void *junk)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 	if (kvm_usage_count)
 		hardware_disable_nolock(NULL);
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	return 0;
 }
 
@@ -5068,9 +5071,11 @@ static void hardware_disable_all_nolock(void)
 
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
@@ -5088,7 +5093,7 @@ static int hardware_enable_all(void)
 	 * Disable CPU hotplug to prevent this case from happening.
 	 */
 	cpus_read_lock();
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
@@ -5101,7 +5106,7 @@ static int hardware_enable_all(void)
 		}
 	}
 
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	cpus_read_unlock();
 
 	return r;
@@ -5708,8 +5713,15 @@ static void kvm_init_debug(void)
 
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
 
@@ -5723,7 +5735,7 @@ static void kvm_resume(void)
 		return; /* FIXME: disable KVM */
 
 	if (kvm_usage_count) {
-		lockdep_assert_not_held(&kvm_count_lock);
+		lockdep_assert_not_held(&kvm_lock);
 		hardware_enable_nolock((void *)__func__);
 	}
 }
-- 
2.25.1

