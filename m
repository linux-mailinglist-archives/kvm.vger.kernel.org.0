Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6965A62B4
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiH3MCJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiH3MB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:01:59 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC17E396B;
        Tue, 30 Aug 2022 05:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860918; x=1693396918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pKFno8pgV7d1CtggUlggw1t/wDDYPlISODZCprE0zvU=;
  b=n1sWkEExpFKMW8SWJkY9+0OuLNHI7+XwdGPztG3+AQitjowlnLnxzfbG
   CCIkHFq0NEEBh2oD+2ij4wpfGJUKTJtNfa3QqL7QZ/OexkfylrNGpOMLj
   RtFjL2iWLkcaxsmoSVpbGNxOufl0/lcnMKrfA3Z5GytZ/at2QEvCN2GAq
   sDvA4ilnjviIbLXHb/ESN+2FJIx9LdXFmkY4M/o/gxN4IYHoDlIzuMOWF
   gQVcncOe6j41Tce3Bx10/3PASLHEomMVi/ctoZ2hgU4ineMewjdaye9xM
   uzKRYY5GIHXK9bWF3fIvg0yMtyl9gM2bXWOaxM1WBACz/+vF7E21d+qEi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870965"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870965"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469626"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:56 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 06/19] KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock
Date:   Tue, 30 Aug 2022 05:01:21 -0700
Message-Id: <66d17ce63c4a71655d174c664bca8398ee1a060f.1661860550.git.isaku.yamahata@intel.com>
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
index 6ce6f27f2934..606ac6bb67d0 100644
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
 
@@ -5014,7 +5015,7 @@ static int kvm_online_cpu(unsigned int cpu)
 {
 	int ret = 0;
 
-	raw_spin_lock(&kvm_count_lock);
+	mutex_lock(&kvm_lock);
 	/*
 	 * Abort the CPU online process if hardware virtualization cannot
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
@@ -5029,7 +5030,7 @@ static int kvm_online_cpu(unsigned int cpu)
 			ret = -EIO;
 		}
 	}
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
 	return ret;
 }
 
@@ -5037,6 +5038,8 @@ static void hardware_disable_nolock(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 
+	WARN_ON_ONCE(preemptible());
+
 	if (!cpumask_test_cpu(cpu, cpus_hardware_enabled))
 		return;
 	cpumask_clear_cpu(cpu, cpus_hardware_enabled);
@@ -5045,10 +5048,10 @@ static void hardware_disable_nolock(void *junk)
 
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
 
@@ -5063,16 +5066,19 @@ static void hardware_disable_all_nolock(void)
 
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
@@ -5085,7 +5091,8 @@ static int hardware_enable_all(void)
 		}
 	}
 
-	raw_spin_unlock(&kvm_count_lock);
+	mutex_unlock(&kvm_lock);
+	cpus_read_unlock();
 
 	return r;
 }
@@ -5691,15 +5698,22 @@ static void kvm_init_debug(void)
 
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

