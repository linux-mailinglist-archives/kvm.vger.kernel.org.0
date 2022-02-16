Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410DD4B7EA6
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 04:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344161AbiBPDQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 22:16:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244696AbiBPDQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 22:16:45 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFCDA185;
        Tue, 15 Feb 2022 19:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644981393; x=1676517393;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CXIRvtzJsiu2gcoHHl+uHSkuWDGrmc7HzH3aUUMVke4=;
  b=B1KzLwfZuCE8wqQWezao27+0XWS8eCZSUvLe15iXDwp0gaUp1uhMtx6x
   gjRKcgwJXwYKHAsoKO9DsQWKUbP0W1LR+kIao3vJiCNBHmGVRp+pX1hl7
   1Z1n0d4z+1gavQpPc30O9M5SLsazni8xXixbQMAXtY9rab1h5rGV4wBcQ
   13ZjaOs1Q5IMHhT625rFomeSvrmxXsNc/vRSvg8oa01zfONss97O4Ph01
   XYddUtlZmHykcjs8g0pZjD3SdA8Yoel7u9HwXGRHotrJ018K26ZrgeDpx
   mms9sPN7m2quLh9gAAulpNy5Im/HSTLAyYU9s6HQWkYlw44T7kKTsrRHW
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="249344574"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="249344574"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:16:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="773798338"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:16:21 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     seanjc@google.com, maz@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/6] KVM: Do compatibility checks on hotplugged CPUs
Date:   Wed, 16 Feb 2022 11:15:21 +0800
Message-Id: <20220216031528.92558-7-chao.gao@intel.com>
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

Opportunistically, add a pr_err() for setup_vmcs_config() path in
vmx_check_processor_compatibility() so that each possible error path has
its own error message. Convert printk(KERN_ERR ... to pr_err to please
checkpatch.pl

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 ++++++----
 arch/x86/kvm/x86.c     | 11 +++++++++--
 virt/kvm/kvm_main.c    | 18 +++++++++++++++++-
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5e1b40e5ad87..9eb7e5dab46d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7122,20 +7122,22 @@ static int vmx_check_processor_compatibility(void)
 {
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
+	int cpu = smp_processor_id();
 
 	if (!this_cpu_has(X86_FEATURE_MSR_IA32_FEAT_CTL) ||
 	    !this_cpu_has(X86_FEATURE_VMX)) {
-		pr_err("kvm: VMX is disabled on CPU %d\n", smp_processor_id());
+		pr_err("kvm: VMX is disabled on CPU %d\n", cpu);
 		return -EIO;
 	}
 
-	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0)
+	if (setup_vmcs_config(&vmcs_conf, &vmx_cap) < 0) {
+		pr_err("kvm: failed to setup vmcs config on CPU %d\n", cpu);
 		return -EIO;
+	}
 	if (nested)
 		nested_vmx_setup_ctls_msrs(&vmcs_conf.nested, vmx_cap.ept);
 	if (memcmp(&vmcs_config, &vmcs_conf, sizeof(struct vmcs_config)) != 0) {
-		printk(KERN_ERR "kvm: CPU %d feature inconsistency!\n",
-				smp_processor_id());
+		pr_err("kvm: CPU %d feature inconsistency!\n", cpu);
 		return -EIO;
 	}
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ffb88f0b7265..c30e3cdb0a30 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11511,9 +11511,16 @@ void kvm_arch_hardware_unsetup(void)
 
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
index bd60f8278867..330a5a62f043 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4855,7 +4855,11 @@ static void hardware_enable_nolock(void *caller_name)
 
 static int kvm_online_cpu(unsigned int cpu)
 {
-	int ret = 0;
+	int ret;
+
+	ret = kvm_arch_check_processor_compat();
+	if (ret)
+		return ret;
 
 	raw_spin_lock(&kvm_count_lock);
 	/*
@@ -4915,6 +4919,17 @@ static int hardware_enable_all(void)
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
@@ -4929,6 +4944,7 @@ static int hardware_enable_all(void)
 	}
 
 	raw_spin_unlock(&kvm_count_lock);
+	cpus_read_unlock();
 
 	return r;
 }
-- 
2.25.1

