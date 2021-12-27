Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB8B47FAF6
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 09:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235624AbhL0IRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 03:17:45 -0500
Received: from mga12.intel.com ([192.55.52.136]:31646 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235622AbhL0IRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 03:17:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640593064; x=1672129064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xYCm7W/GNTT8b6GR0Dno3E5gHGMz2WSp3wyshjf+qAM=;
  b=L5vYuEQNkjK00IQdp9VysCY7ENQmYxmlXieqKcm9d0VLNshlP4ehHKK5
   5mp/3elMOwdTju1B5DanlY941Y3viMfaaHI7jsoqDAHcfR78VRcExhW0q
   /zBgDloQ80FAessN//IDWF/wxFLmFKvvBC9UmiysM5Tr6YNx3/BvirbaZ
   to7xbwMUfjQ/UyHGNZrqtdPaoDVQsAW1/R2dYGQC2pEkkq7ubXg1EaMXw
   90hSc5k/ByCMqlhKPPPQ7aL3wEYAtx/Ww35M8HMqn4ja5CN93C2r3iSxh
   MVmnBjeX6R3SWxZpBkDT23hJq19QiW29sM4T1/c1MdxZMD4e2irIxWaxs
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10209"; a="221182097"
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="221182097"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 00:17:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="523208147"
Received: from unknown (HELO hyperv-sh4.sh.intel.com) ([10.239.48.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 00:17:39 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>, Joerg Roedel <jroedel@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Huang Ying <ying.huang@intel.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
Date:   Mon, 27 Dec 2021 16:15:10 +0800
Message-Id: <20211227081515.2088920-5-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211227081515.2088920-1-chao.gao@intel.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
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
index 4e1e7770e984..c1054604d1e8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4853,13 +4853,25 @@ static void hardware_enable_nolock(void *junk)
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
+			pr_info("kvm: abort onlining CPU%d", cpu);
+		}
+	}
 	raw_spin_unlock(&kvm_count_lock);
-	return 0;
+	return ret;
 }
 
 static void hardware_disable_nolock(void *junk)
@@ -4872,7 +4884,7 @@ static void hardware_disable_nolock(void *junk)
 	kvm_arch_hardware_disable();
 }
 
-static int kvm_dying_cpu(unsigned int cpu)
+static int kvm_offline_cpu(unsigned int cpu)
 {
 	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
@@ -5641,8 +5653,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 			goto out_free_2;
 	}
 
-	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
-				      kvm_starting_cpu, kvm_dying_cpu);
+	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
+				      kvm_online_cpu, kvm_offline_cpu);
 	if (r)
 		goto out_free_2;
 	register_reboot_notifier(&kvm_reboot_notifier);
@@ -5705,7 +5717,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
+	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 out_free_2:
 	kvm_arch_hardware_unsetup();
 out_free_1:
@@ -5731,7 +5743,7 @@ void kvm_exit(void)
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

