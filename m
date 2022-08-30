Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC235A62B0
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiH3MCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiH3MB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:01:58 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC203E58B1;
        Tue, 30 Aug 2022 05:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860917; x=1693396917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4lQQM3YEKOljyNg3+Qt8aEy+mGfQLUEBdfFaUdsEnJU=;
  b=QygY3acMhLh+6hYcFzQU7X2J1Cx1GslcLVg6/OR3bfuEyO7J2VsTa99R
   75RauTihyzNBYand4a9Bpl7c8ZBDqGSpACPzsVXaTOHlivJ4XmDOh8q52
   vwbxnOfFP0G/+UPBtYWkT3Sg3xpSqYa6rjMG0bUh3zCJcfNXwwC0iDrqs
   o522sdb3C0BzF8baU19rDdYh4svvcN4IbWjzZCc/V72u5nOlH0kNYGy2y
   rt2IwXrvfOOpJ2wHlszYmyNehGTWOZ5e5V/87YmM8pGRq/4re/txtv8Ig
   LU6SMc/1UfCzgbi04oO13XsMnya7Yk6nvGRG/fHlp0gDq0qM0HOQFkymV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870962"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870962"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:56 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469623"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:55 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 05/19] KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
Date:   Tue, 30 Aug 2022 05:01:20 -0700
Message-Id: <d2c8815a56be1712e189ddcbea16c8b6cbc53e4a.1661860550.git.isaku.yamahata@intel.com>
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

From: Chao Gao <chao.gao@intel.com>

The CPU STARTING section doesn't allow callbacks to fail. Move KVM's
hotplug callback to ONLINE section so that it can abort onlining a CPU in
certain cases to avoid potentially breaking VMs running on existing CPUs.
For example, when kvm fails to enable hardware virtualization on the
hotplugged CPU.

Place KVM's hotplug state before CPUHP_AP_SCHED_WAIT_EMPTY as it ensures
when offlining a CPU, all user tasks and non-pinned kernel tasks have left
the CPU, i.e. there cannot be a vCPU task around. So, it is safe for KVM's
CPU offline callback to disable hardware virtualization at that point.
Likewise, KVM's online callback can enable hardware virtualization before
any vCPU task gets a chance to run on hotplugged CPUs.

KVM's CPU hotplug callbacks are renamed as well.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Link: https://lore.kernel.org/r/20220216031528.92558-6-chao.gao@intel.com
---
 include/linux/cpuhotplug.h |  2 +-
 virt/kvm/kvm_main.c        | 30 ++++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index f61447913db9..7972bd63e0cb 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -185,7 +185,6 @@ enum cpuhp_state {
 	CPUHP_AP_CSKY_TIMER_STARTING,
 	CPUHP_AP_TI_GP_TIMER_STARTING,
 	CPUHP_AP_HYPERV_TIMER_STARTING,
-	CPUHP_AP_KVM_STARTING,
 	CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
 	CPUHP_AP_KVM_ARM_VGIC_STARTING,
 	CPUHP_AP_KVM_ARM_TIMER_STARTING,
@@ -203,6 +202,7 @@ enum cpuhp_state {
 
 	/* Online section invoked on the hotplugged CPU from the hotplug thread */
 	CPUHP_AP_ONLINE_IDLE,
+	CPUHP_AP_KVM_ONLINE,
 	CPUHP_AP_SCHED_WAIT_EMPTY,
 	CPUHP_AP_SMPBOOT_THREADS,
 	CPUHP_AP_X86_VDSO_VMA_ONLINE,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4243a9541543..6ce6f27f2934 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5010,13 +5010,27 @@ static void hardware_enable_nolock(void *junk)
 	}
 }
 
-static int kvm_starting_cpu(unsigned int cpu)
+static int kvm_online_cpu(unsigned int cpu)
 {
+	int ret = 0;
+
 	raw_spin_lock(&kvm_count_lock);
-	if (kvm_usage_count)
+	/*
+	 * Abort the CPU online process if hardware virtualization cannot
+	 * be enabled. Otherwise running VMs would encounter unrecoverable
+	 * errors when scheduled to this CPU.
+	 */
+	if (kvm_usage_count) {
+		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
+
 		hardware_enable_nolock(NULL);
+		if (atomic_read(&hardware_enable_failed)) {
+			atomic_set(&hardware_enable_failed, 0);
+			ret = -EIO;
+		}
+	}
 	raw_spin_unlock(&kvm_count_lock);
-	return 0;
+	return ret;
 }
 
 static void hardware_disable_nolock(void *junk)
@@ -5029,7 +5043,7 @@ static void hardware_disable_nolock(void *junk)
 	kvm_arch_hardware_disable();
 }
 
-static int kvm_dying_cpu(unsigned int cpu)
+static int kvm_offline_cpu(unsigned int cpu)
 {
 	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
@@ -5840,8 +5854,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 			goto out_free_2;
 	}
 
-	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
-				      kvm_starting_cpu, kvm_dying_cpu);
+	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
+				      kvm_online_cpu, kvm_offline_cpu);
 	if (r)
 		goto out_free_2;
 	register_reboot_notifier(&kvm_reboot_notifier);
@@ -5902,7 +5916,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
+	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 out_free_2:
 	kvm_arch_hardware_unsetup();
 out_free_1:
@@ -5928,7 +5942,7 @@ void kvm_exit(void)
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
+	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
 	kvm_arch_hardware_unsetup();
 	kvm_arch_exit();
-- 
2.25.1

