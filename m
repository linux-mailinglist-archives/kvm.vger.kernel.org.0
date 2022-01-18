Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41697491F88
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 07:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243972AbiARGtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 01:49:55 -0500
Received: from mga07.intel.com ([134.134.136.100]:32573 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243988AbiARGtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 01:49:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642488595; x=1674024595;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MRlNCZ1rQT5dO9BKVcb4/9RCOl9rnCzSJkTuTsJPPF4=;
  b=PQVsXh2SIhAuVOxJ0TruaeSgXsh3Zwdmr+cITJW81QpVgw2FBfcpg1hV
   wBLpybfmMbr7/6jeQuMt2iVU9sHsWALbX0To1tQWmgmb3pevtQYZWzceT
   V7atTS9oN80joOgNRVrmQ98sCUp9J3siFaRSP0cQJFxpPVrtJ/E8JHWJ0
   6IEPty0pGbjzofH1zX38wiyB2EH+MGxVo0XSkWfTTF05L2TE4lcxKEmNR
   ZeTqW0DI0rQc+T88wY5X7SE0Tpyl5jtq1bCKfuzt/MIdRG+CrimZkreOI
   SLDyIzuUiqZG3FqLsorobgs/PXlUGd4r33rl68AYZ4r5CYLeo/R6If9nf
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="308090449"
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="308090449"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 22:49:55 -0800
X-IronPort-AV: E=Sophos;i="5.88,296,1635231600"; 
   d="scan'208";a="531648675"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2022 22:49:51 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        kevin.tian@intel.com, tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: Do compatibility checks on hotplugged CPUs
Date:   Tue, 18 Jan 2022 14:44:27 +0800
Message-Id: <20220118064430.3882337-5-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118064430.3882337-1-chao.gao@intel.com>
References: <20220118064430.3882337-1-chao.gao@intel.com>
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

Do compatibility checks when onlining a CPU and abort the online process
if the hotplugged CPU is incompatible with online CPUs.

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

Loosen the WARN_ON in kvm_arch_check_processor_compat so that it
can be invoked from KVM's CPU hotplug callback (i.e., kvm_online_cpu).

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c  | 11 +++++++++--
 virt/kvm/kvm_main.c | 20 +++++++++++++++++++-
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f3bf78afb29..21bdb5783f71 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11472,9 +11472,16 @@ void kvm_arch_hardware_unsetup(void)
 
 int kvm_arch_check_processor_compat(void)
 {
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+	int cpu = smp_processor_id();
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	WARN_ON(!irqs_disabled());
+	/*
+	 * Compatibility checks are done when loading KVM or in KVM's CPU
+	 * hotplug callback. It ensures all online CPUs are compatible to run
+	 * vCPUs. For other cases, compatibility checks are unnecessary or
+	 * even problematic. Try to detect improper usages here.
+	 */
+	WARN_ON(!irqs_disabled() && cpu_active(cpu));
 
 	if (__cr4_reserved_bits(cpu_has, c) !=
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 528741601122..83f87fb1fa0a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4858,7 +4858,13 @@ static void hardware_enable_nolock(void *junk)
 
 static int kvm_online_cpu(unsigned int cpu)
 {
-	int ret = 0;
+	int ret;
+
+	ret = kvm_arch_check_processor_compat();
+	if (ret) {
+		pr_warn("kvm: CPU%d is incompatible with online CPUs", cpu);
+		return ret;
+	}
 
 	raw_spin_lock(&kvm_count_lock);
 	/*
@@ -4916,6 +4922,17 @@ static int hardware_enable_all(void)
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
 
 	kvm_usage_count++;
@@ -4930,6 +4947,7 @@ static int hardware_enable_all(void)
 	}
 
 	raw_spin_unlock(&kvm_count_lock);
+	cpus_read_unlock();
 
 	return r;
 }
-- 
2.25.1

