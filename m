Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1E758BD06
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiHGWCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiHGWCb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:31 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21651647E;
        Sun,  7 Aug 2022 15:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909751; x=1691445751;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2BQ3Ohsy+Ucg9OoOp+mYj7DLgWdLG+h/d8XnsOmIsaw=;
  b=mam1Dlp4lluRT+fpb50l9Pn5IpmCSVFQ8hogCLYtBnEGWe4c9ktaRYgr
   xFxlpg1qdF8nmPytC7xplEfNExLGoF2eXA3JLqzPbBFMz3FD/mLf7w+cO
   mYMQ7ktUHx+l+JJF2bH1qcc3I/VtFvAKDq+lq/QRkaOFIBWjfUqFEea72
   9akvGPDHKaxDsCuqbjjPOt7TedTr5FyMvXAK/gGJeR0lLPZRKIMfZiB/y
   1dVUx61dgOV5n+ZYzxEV7nOFur/YvlRfd9rUduQGVjGb2p5oliwjH5ZXL
   yb2cCREQajUQEnGjT99WmVmECpDLUfMUnBC95mb/BeJB9ow3qrMzSRcAQ
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224045"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224045"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682444"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:28 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 003/103] KVM: Refactor CPU compatibility check on module initialization
Date:   Sun,  7 Aug 2022 15:00:48 -0700
Message-Id: <4092a37d18f377003c6aebd9ced1280b0536c529.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX module requires its initialization.  It requires VMX to be enabled.
Although there are several options of when to initialize it, the choice is
the initialization time of the KVM kernel module.  There is no usable
arch-specific hook for the TDX module to utilize during the KVM kernel module
initialization.  The code doesn't enable/disable hardware (VMX in TDX case)
during the kernel module initialization.  Add a hook for enabling hardware,
arch-specific initialization, and disabling hardware during KVM kernel
module initialization to make a room for TDX module initialization.  The
current KVM enables hardware when the first VM is created and disables
hardware when the last VM is destroyed.  When no VM is running, hardware is
disabled.  To follow these semantics, the kernel module initialization needs
to disable hardware. Opportunistically refactor the code to enable/disable
hardware.

Add hadware_enable_all() and hardware_disable_all() to kvm_init() and
introduce a new arch-specific callback function,
kvm_arch_post_hardware_enable_setup, for arch to do arch-specific
initialization that requires hardware_enable_all().  Opportunistically,
move kvm_arch_check_processor_compat() to to hardware_enabled_nolock().
TDX module initialization code will go into
kvm_arch_post_hardware_enable_setup().

This patch reorders some function calls as below from (*) (**) (A) and (B)
to (A) (B) and (*).  Here (A) and (B) depends on (*), but not (**).  By
code inspection, only mips and VMX has the code of (*).  No other
arch has empty (*).  So refactor mips and VMX and eliminate the
necessity hook for (*) instead of adding an unused hook.

Before this patch:
- Arch module initialization
  - kvm_init()
    - kvm_arch_init()
    - kvm_arch_check_processor_compat() on each CPUs
  - post-arch-specific initialization -- (*): (A) and (B) depends on this
  - post-arch-specific initialization -- (**): no dependency to (A) and (B)

- When creating/deleting the first/last VM
   - kvm_arch_hardware_enable() on each CPUs -- (A)
   - kvm_arch_hardware_disable() on each CPUs -- (B)

After this patch:
- Arch module initialization
  - kvm_init()
    - kvm_arch_init()
    - arch-specific initialization -- (*)
    - kvm_arch_check_processor_compat() on each CPUs
    - kvm_arch_hardware_enable() on each CPUs -- (A)
    - kvm_arch_hardware_disable() on each CPUs -- (B)
  - post-arch-specific initialization  -- (**)

- When creating/deleting the first/last VM (no logic change)
   - kvm_arch_hardware_enable() on each CPUs -- (A)
   - kvm_arch_hardware_disable() on each CPUs -- (B)

Code inspection result:
As long as I inspected, I found only mips and VMX have non-empty (*) or
non-empty (A) or (B).
x86: tested on a real machine
mips: compile test only
powerpc, s390, arm, riscv: code inspection only

- arch/mips/kvm/mips.c
  module init function, kvm_mips_init(), does some initialization after
  kvm_init().  Compile test only.

- arch/x86/kvm/x86.c
  - uses vm_list which is statically initialized.
  - static_call(kvm_x86_hardware_enable)();
    - SVM: (*) and (**) are empty.
    - VMX: initialize percpu variable loaded_vmcss_on_cpu that VMXON uses.

- arch/powerpc/kvm/powerpc.c
  kvm_arch_hardware_enable/disable() are nop

- arch/s390/kvm/kvm-s390.c
  kvm_arch_hardware_enable/disable() are nop

- arch/arm64/kvm/arm.c
  module init function, arm_init(), calls only kvm_init().
  (*) and (**) are empty

- arch/riscv/kvm/main.c
  module init function, riscv_kvm_init(), calls only kvm_init().
  (*) and (**) are empty

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/mips/kvm/mips.c     | 16 +++++++++++-----
 arch/x86/kvm/vmx/vmx.c   | 23 +++++++++++++++++++----
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 31 ++++++++++++++++++++++++-------
 4 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 092d09fb6a7e..fd7339cff57c 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1642,12 +1642,11 @@ static int __init kvm_mips_init(void)
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * kvm_init() calls kvm_arch_hardware_enable/disable().  The early
+	 * initialization is needed before calling kvm_init().
+	 */
 	ret = kvm_mips_entry_setup();
-	if (ret)
-		return ret;
-
-	ret = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
-
 	if (ret)
 		return ret;
 
@@ -1656,6 +1655,13 @@ static int __init kvm_mips_init(void)
 
 	register_die_notifier(&kvm_mips_csr_die_notifier);
 
+	ret = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+
+	if (ret) {
+		unregister_die_notifier(&kvm_mips_csr_die_notifier);
+		return ret;
+	}
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c5637a4c1c43..4d7e1073984d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8433,6 +8433,23 @@ static void vmx_exit(void)
 }
 module_exit(vmx_exit);
 
+/*
+ * Early initialization before kvm_init() so that vmx_hardware_enable/disable()
+ * can work.
+ */
+static void __init vmx_init_early(void)
+{
+	int cpu;
+
+	/*
+	 * vmx_hardware_disable() accesses loaded_vmcss_on_cpu list.
+	 * Initialize the variable before kvm_init() that calls
+	 * vmx_hardware_enable/disable().
+	 */
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+}
+
 static int __init vmx_init(void)
 {
 	int r, cpu;
@@ -8470,6 +8487,7 @@ static int __init vmx_init(void)
 	}
 #endif
 
+	vmx_init_early();
 	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
 		     __alignof__(struct vcpu_vmx), THIS_MODULE);
 	if (r)
@@ -8490,11 +8508,8 @@ static int __init vmx_init(void)
 
 	vmx_setup_fb_clear_ctrl();
 
-	for_each_possible_cpu(cpu) {
-		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
-
+	for_each_possible_cpu(cpu)
 		pi_init_cpu(cpu);
-	}
 
 #ifdef CONFIG_KEXEC_CORE
 	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9643b8eadefe..63d4e3ce3e53 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1437,6 +1437,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
+int kvm_arch_post_hardware_enable_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
 int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0f5767e5ae45..a43fdbfaede2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4995,8 +4995,13 @@ static void hardware_enable_nolock(void *junk)
 
 	cpumask_set_cpu(cpu, cpus_hardware_enabled);
 
+	r = kvm_arch_check_processor_compat();
+	if (r)
+		goto out;
+
 	r = kvm_arch_hardware_enable();
 
+out:
 	if (r) {
 		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
 		atomic_inc(&hardware_enable_failed);
@@ -5793,9 +5798,9 @@ void kvm_unregister_perf_callbacks(void)
 }
 #endif
 
-static void check_processor_compat(void *rtn)
+__weak int kvm_arch_post_hardware_enable_setup(void *opaque)
 {
-	*(int *)rtn = kvm_arch_check_processor_compat();
+	return 0;
 }
 
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
@@ -5828,11 +5833,23 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	if (r < 0)
 		goto out_free_1;
 
-	for_each_online_cpu(cpu) {
-		smp_call_function_single(cpu, check_processor_compat, &r, 1);
-		if (r < 0)
-			goto out_free_2;
-	}
+	/* hardware_enable_nolock() checks CPU compatibility on each CPUs. */
+	r = hardware_enable_all();
+	if (r)
+		goto out_free_2;
+	/*
+	 * Arch specific initialization that requires to enable virtualization
+	 * feature.  e.g. TDX module initialization requires VMXON on all
+	 * present CPUs.
+	 */
+	kvm_arch_post_hardware_enable_setup(opaque);
+	/*
+	 * Make hardware disabled after the KVM module initialization.  KVM
+	 * enables hardware when the first KVM VM is created and disables
+	 * hardware when the last KVM VM is destroyed.  When no KVM VM is
+	 * running, hardware is disabled.  Keep that semantics.
+	 */
+	hardware_disable_all();
 
 	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
 				      kvm_starting_cpu, kvm_dying_cpu);
-- 
2.25.1

