Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43DA4B7EC2
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 04:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244524AbiBPDQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 22:16:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbiBPDQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 22:16:44 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965AF6433;
        Tue, 15 Feb 2022 19:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644981392; x=1676517392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yrhdfFnt+IU2sldeSHzrHzJiU1+hSv0xsaODnQGVYi0=;
  b=VxCib6+aOWa/VHfeoKgey1Qo7THxmXufDmX4y21esClN2a41cq8N6WHr
   1yYR+VBcD9L9YLutaaTXncDFR9JkJcT19Lxh8jwGX7Q8lY4YbuwF+y4Oo
   UFjUZ5LIn7S89y22VRQP1CHbBB4Xs6K7boBNWnEZqrc/EpqiAwTPgUobw
   9pSgqUQWTmre99BQ26/e2I2lBgyvSzCrOr4Btzn35DEIX1505UXSQM/9R
   mOj3nosI3n9wDlV7G8CTSy6fxcJ7dThE66ubwiVGVMYtoS/cIN0n5QMS6
   Ef/e5xI6OpLMSkg3A17jC9OUjB/hCeAm1w5yzP/UntTJgTS5QSXi4N/KQ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="249344572"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="249344572"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:16:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="773798316"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:16:15 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     seanjc@google.com, maz@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Dave Chinner <dchinner@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/6] KVM: Rename and move CPUHP_AP_KVM_STARTING to ONLINE section
Date:   Wed, 16 Feb 2022 11:15:20 +0800
Message-Id: <20220216031528.92558-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216031528.92558-1-chao.gao@intel.com>
References: <20220216031528.92558-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 virt/kvm/kvm_main.c        | 30 ++++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 4345b8eafc03..2c88770d3681 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -182,7 +182,6 @@ enum cpuhp_state {
 	CPUHP_AP_CSKY_TIMER_STARTING,
 	CPUHP_AP_TI_GP_TIMER_STARTING,
 	CPUHP_AP_HYPERV_TIMER_STARTING,
-	CPUHP_AP_KVM_STARTING,
 	/* Must be the last timer callback */
 	CPUHP_AP_DUMMY_TIMER_STARTING,
 	CPUHP_AP_ARM_XEN_STARTING,
@@ -197,6 +196,7 @@ enum cpuhp_state {
 
 	/* Online section invoked on the hotplugged CPU from the hotplug thread */
 	CPUHP_AP_ONLINE_IDLE,
+	CPUHP_AP_KVM_ONLINE,
 	CPUHP_AP_SCHED_WAIT_EMPTY,
 	CPUHP_AP_SMPBOOT_THREADS,
 	CPUHP_AP_X86_VDSO_VMA_ONLINE,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c7229f5c9f66..bd60f8278867 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4853,13 +4853,27 @@ static void hardware_enable_nolock(void *caller_name)
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
 		hardware_enable_nolock((void *)__func__);
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
@@ -4872,7 +4886,7 @@ static void hardware_disable_nolock(void *junk)
 	kvm_arch_hardware_disable();
 }
 
-static int kvm_dying_cpu(unsigned int cpu)
+static int kvm_offline_cpu(unsigned int cpu)
 {
 	raw_spin_lock(&kvm_count_lock);
 	if (kvm_usage_count)
@@ -5685,8 +5699,8 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 			goto out_free_2;
 	}
 
-	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
-				      kvm_starting_cpu, kvm_dying_cpu);
+	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
+				      kvm_online_cpu, kvm_offline_cpu);
 	if (r)
 		goto out_free_2;
 	register_reboot_notifier(&kvm_reboot_notifier);
@@ -5749,7 +5763,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
-	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_STARTING);
+	cpuhp_remove_state_nocalls(CPUHP_AP_KVM_ONLINE);
 out_free_2:
 	kvm_arch_hardware_unsetup();
 out_free_1:
@@ -5775,7 +5789,7 @@ void kvm_exit(void)
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

