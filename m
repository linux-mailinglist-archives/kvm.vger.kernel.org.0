Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CF147FAFA
	for <lists+kvm@lfdr.de>; Mon, 27 Dec 2021 09:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbhL0IRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Dec 2021 03:17:54 -0500
Received: from mga12.intel.com ([192.55.52.136]:31646 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235634AbhL0IRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Dec 2021 03:17:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640593072; x=1672129072;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UOZ+MZumdm6HooFdYpSt0SIJwnAaNRDO5N9HSkFbq7g=;
  b=ANRqu2tCnIi0bZqCgXEXrxBhbm4iUdZByuWgu/pOCtwLmVDlGRKBOYbt
   341lLRQ5Q81rYMHM2wjsXJEyX2lVXTptUqcwB/7CUn7SgxAgCGd1oPbYY
   uvm2NbN6e1CkqjWbbqpNVn7HiSTyfJhkHETsc7y2o+kWH+ScooXbHUEe4
   ifMsb4fCkohL7eMj8Mf63ZJfKwhaSKYEW6GGZmjL7/7/QuJyGH0ymZX8J
   DePIun9lnf6Nj4bGsvCNsETL4OTvwvMuchx6VzWg7XgRrVJG5IGqoZJbE
   d6gEL5a5uOUa+I0KvuAMMOqJi5f8EjZfUim7V501+25QEy/3240OVyRAc
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10209"; a="221182111"
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="221182111"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 00:17:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,239,1635231600"; 
   d="scan'208";a="523208194"
Received: from unknown (HELO hyperv-sh4.sh.intel.com) ([10.239.48.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 00:17:49 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, kevin.tian@intel.com,
        tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] KVM: Do compatibility checks on hotplugged CPUs
Date:   Mon, 27 Dec 2021 16:15:12 +0800
Message-Id: <20211227081515.2088920-7-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211227081515.2088920-1-chao.gao@intel.com>
References: <20211227081515.2088920-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At init time, KVM does compatibility checks to ensure that all online
CPUs support hardware virtualization and a common set of features. But
KVM uses hotplugged CPUs without such compatibility checks. On Intel
CPUs, this leads to #GP if the hotplugged CPU doesn't support VMX or
vmentry failure if the hotplugged CPU doesn't meet minimal feature
requirements.

Do compatibility checks when onlining a CPU. If any VM is running,
KVM hotplug callback returns an error to abort onlining incompatible
CPUs.

But if no VM is running, onlining incompatible CPUs is allowed. Instead,
KVM is prohibited from creating VMs similar to the policy for init-time
compatibility checks.

CPU hotplug is disabled during hardware_enable_all() to prevent the corner
case as shown below. A hotplugged CPU marks itself online in
cpu_online_mask (1) and enables interrupt (2) before invoking callbacks
registered in ONLINE section (3). So, if hardware_enable_all() is invoked
on another CPU right after (2), then on_each_cpu() in hardware_enable_all()
invokes hardware_enable_nolock() on the hotplugged CPU before
kvm_online_cpu() is called. This makes the CPU escape from compatibility
checks, which is risky.

	start_secondary { ...
		set_cpu_online(smp_processor_id(), true); <- 1
		...
		local_irq_enable();  <- 2
		...
		cpu_startup_entry(CPUHP_AP_ONLINE_IDLE); <- 3
	}

Keep compatibility checks at KVM init time. It can help to find
incompatibility issues earlier and refuse to load arch KVM module
(e.g., kvm-intel).

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 virt/kvm/kvm_main.c | 36 ++++++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c1054604d1e8..0ff80076d48d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -106,6 +106,8 @@ LIST_HEAD(vm_list);
 static cpumask_var_t cpus_hardware_enabled;
 static int kvm_usage_count;
 static atomic_t hardware_enable_failed;
+/* Set if hardware becomes incompatible after CPU hotplug */
+static bool hardware_incompatible;
 
 static struct kmem_cache *kvm_vcpu_cache;
 
@@ -4855,20 +4857,32 @@ static void hardware_enable_nolock(void *junk)
 
 static int kvm_online_cpu(unsigned int cpu)
 {
-	int ret = 0;
+	int ret;
 
+	ret = kvm_arch_check_processor_compat();
 	raw_spin_lock(&kvm_count_lock);
 	/*
 	 * Abort the CPU online process if hardware virtualization cannot
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
 	 * errors when scheduled to this CPU.
 	 */
-	if (kvm_usage_count) {
+	if (!ret && kvm_usage_count) {
 		hardware_enable_nolock(NULL);
 		if (atomic_read(&hardware_enable_failed)) {
 			ret = -EIO;
 			pr_info("kvm: abort onlining CPU%d", cpu);
 		}
+	} else if (ret && !kvm_usage_count) {
+		/*
+		 * Continue onlining an incompatible CPU if no VM is
+		 * running. KVM should reject creating any VM after this
+		 * point. Then this CPU can be still used to run non-VM
+		 * workload.
+		 */
+		ret = 0;
+		hardware_incompatible = true;
+		pr_info("kvm: prohibit VM creation due to incompatible CPU%d",
+			cpu);
 	}
 	raw_spin_unlock(&kvm_count_lock);
 	return ret;
@@ -4913,8 +4927,24 @@ static int hardware_enable_all(void)
 {
 	int r = 0;
 
+	/*
+	 * During onlining a CPU, cpu_online_mask is set before kvm_online_cpu()
+	 * is called. on_each_cpu() between them includes the CPU. As a result,
+	 * hardware_enable_nolock() may get invoked before kvm_online_cpu().
+	 * This would enable hardware virtualization on that cpu without
+	 * compatibility checks, which can potentially crash system or break
+	 * running VMs.
+	 *
+	 * Disable CPU hotplug to prevent this case from happening.
+	 */
+	cpus_read_lock();
 	raw_spin_lock(&kvm_count_lock);
 
+	if (hardware_incompatible) {
+		r = -EIO;
+		goto unlock;
+	}
+
 	kvm_usage_count++;
 	if (kvm_usage_count == 1) {
 		atomic_set(&hardware_enable_failed, 0);
@@ -4926,7 +4956,9 @@ static int hardware_enable_all(void)
 		}
 	}
 
+unlock:
 	raw_spin_unlock(&kvm_count_lock);
+	cpus_read_unlock();
 
 	return r;
 }
-- 
2.25.1

