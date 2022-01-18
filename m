Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E816491F86
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 07:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243306AbiARGtw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 01:49:52 -0500
Received: from mga07.intel.com ([134.134.136.100]:32573 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243178AbiARGtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 01:49:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642488590; x=1674024590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sukS5IeWozjhaGOQaV7YpNhdc/rV9F4bsauJImDN94o=;
  b=AV1LrNYOz7PARzX1SBU4+5FZ3Ing5SJIJfan5GC7yTf311/Pll9yJrWm
   t/7KExtcHmdS7Ht/14iuzRyzWQog53kyJunuSMRwF0G59YuDDq0oPDPG9
   DlRglAIv33ekI5NuOpN9a4/KDFDh1OoBXMgx/kHgzLY6GYA7g6nxv+/y8
   y8xipmfWLMvoAA2DflMgvUYTLyWPcwH5FcuHKuevX9gvHEWE/83K/0EXI
   PpYKJ2uMK1OOyrSpVjXVOAdFLRsUP28jhi0oRxAPEvTc2vcmVmwVK+77e
   2y1m13p6KHyqMDndmjamrX+Za62yfNklDpB7FMG9EGyLaU7xqNcepzPYP
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="308090444"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="308090444"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 22:49:50 -0800
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="531648655"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 22:49:47 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kevin.tian@intel.com, tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
Date:   Tue, 18 Jan 2022 14:44:26 +0800
Message-Id: <20220118064430.3882337-4-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118064430.3882337-1-chao.gao@intel.com>
References: <20220118064430.3882337-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
---
 include/linux/cpuhotplug.h |  2 +-
 virt/kvm/kvm_main.c        | 28 ++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 773c83730906..14d354c8ce35 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -182,7 +182,6 @@ enum cpuhp_state {
 	CPUHP_AP_CSKY_TIMER_STARTING,
 	CPUHP_AP_TI_GP_TIMER_STARTING,
 	CPUHP_AP_HYPERV_TIMER_STARTING,
-	CPUHP_AP_KVM_STARTING,
 	CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
 	CPUHP_AP_KVM_ARM_VGIC_STARTING,
 	CPUHP_AP_KVM_ARM_TIMER_STARTING,
@@ -200,6 +199,7 @@ enum cpuhp_state {
 
 	/* Online section invoked on the hotplugged CPU from the hotplug thread */
 	CPUHP_AP_ONLINE_IDLE,
+	CPUHP_AP_KVM_ONLINE,
 	CPUHP_AP_SCHED_WAIT_EMPTY,
 	CPUHP_AP_SMPBOOT_THREADS,
 	CPUHP_AP_X86_VDSO_VMA_ONLINE,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 148f7169b431..528741601122 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4856,13 +4856,25 @@ static void hardware_enable_nolock(void *junk)
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
 		hardware_enable_nolock(NULL);
+		if (atomic_read(&hardware_enable_failed)) {
+			ret = -EIO;
+			pr_warn("kvm: abort onlining CPU%d", cpu);
+		}
+	}
 	raw_spin_unlock(&kvm_count_lock);
-	return 0;
+	return ret;
 }
 
 static void hardware_disable_nolock(void *junk)
@@ -4875,7 +4887,7 @@ static void hardware_disable_nolock(void *junk)
 	kvm_arch_hardware_disable();
 }
 
-static int kvm_dying_cpu(unsigned int cpu)
+static int kvm_offline_cpu(unsigned int cpu)
 {
 	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
@@ -5644,8 +5656,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 			goto out_free_2;
 	}
 
-	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
-				      kvm_starting_cpu, kvm_dying_cpu);
+	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
+				      kvm_online_cpu, kvm_offline_cpu);
 	if (r)
 		goto out_free_2;
 	register_reboot_notifier(&kvm_reboot_notifier);
@@ -5708,7 +5720,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
+	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 out_free_2:
 	kvm_arch_hardware_unsetup();
 out_free_1:
@@ -5734,7 +5746,7 @@ void kvm_exit(void)
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

