Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BE555C672
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241282AbiF0Vyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241215AbiF0Vyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:50 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223FA55BA;
        Mon, 27 Jun 2022 14:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366889; x=1687902889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=igm+Zj6Vaj2XEEdi/VyZQvhvio7Iy7kYwXFz4ulIGdw=;
  b=dLi/BhABqOgBrH/xeijexlWVhe9n7jbxmf0rlXgHyQnuA77hSl4HcoX3
   62owJK+KzvT/u4v72P5roK0UJ96v80a+ujDEBooTVo73yVbTjL7JdhWXF
   BxQR1Y/vMCJlos4uYghF+yM7CW7Izw5rYGIuXw2Tg+nw13XcipxH1ks9r
   8PDZfCMY1HrVEj39+S6DaTKxiDQkPmPWaGnrW3dnGtJGhBLn8Q77/ekHN
   /zUD+lLMFE/jJ7e0Q87c5JXpAzmND22nKK9KKPICIc6sav5QaMFC/AgN6
   etlzGvXDcCuudbLzYIGobTtAZnUzgmGRUi4H5eURuJKoz8j8xX7M4Ikrz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282662711"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="282662711"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:47 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863436"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:47 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH v7 003/102] KVM: Refactor CPU compatibility check on module initialiization
Date:   Mon, 27 Jun 2022 14:52:55 -0700
Message-Id: <e1f72040effd7b4ed31f9941e009f959d6345129.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Although non-x86 arch doesn't break as long as I inspected code, it's by
code inspection.  This should be reviewed by each arch maintainers.

kvm_init() checks CPU compatibility by calling
kvm_arch_check_processor_compat() on all online CPUs.  Move the callback
to hardware_enable_nolock() and add hardware_enable_all() and
hardware_disable_all().
Add arch specific callback kvm_arch_post_hardware_enable_setup() for arch
to do arch specific initialization that required hardware_enable_all().
This makes a room for TDX module to initialize on kvm module loading.  TDX
module requires all online cpu to enable VMX by VMXON.

If kvm_arch_hardware_enable/disable() depend on (*) part, such dependency
must be called before kvm_init().  In fact kvm_intel() does.  Although
other arch doesn't as long as I checked as follows, it should be reviewed
by each arch maintainers.

Before this patch:
- Arch module initialization
  - kvm_init()
    - kvm_arch_init()
    - kvm_arch_check_processor_compat() on each CPUs
  - post arch specific initialization ---- (*)

- when creating/deleting first/last VM
   - kvm_arch_hardware_enable() on each CPUs --- (A)
   - kvm_arch_hardware_disable() on each CPUs --- (B)

After this patch:
- Arch module initialization
  - kvm_init()
    - kvm_arch_init()
    - kvm_arch_hardware_enable() on each CPUs  (A)
    - kvm_arch_check_processor_compat() on each CPUs
    - kvm_arch_hardware_disable() on each CPUs (B)
  - post arch specific initialization  --- (*)

Code inspection result:
(A)/(B) can depend on (*) before this patch.  If there is dependency, such
initialization must be moved before kvm_init() with this patch.  VMX does
in fact.  As long as I inspected other archs and find only mips has it.

- arch/mips/kvm/mips.c
  module init function, kvm_mips_init(), does some initialization after
  kvm_init().  Compile test only.  Needs review.

- arch/x86/kvm/x86.c
  - uses vm_list which is statically initialized.
  - static_call(kvm_x86_hardware_enable)();
    - SVM: (*) is empty.
    - VMX: needs fix

- arch/powerpc/kvm/powerpc.c
  kvm_arch_hardware_enable/disable() are nop

- arch/s390/kvm/kvm-s390.c
  kvm_arch_hardware_enable/disable() are nop

- arch/arm64/kvm/arm.c
  module init function, arm_init(), calls only kvm_init().
  (*) is empty

- arch/riscv/kvm/main.c
  module init function, riscv_kvm_init(), calls only kvm_init().
  (*) is empty

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/mips/kvm/mips.c     | 12 +++++++-----
 arch/x86/kvm/vmx/vmx.c   | 15 +++++++++++----
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 25 ++++++++++++++++++-------
 4 files changed, 37 insertions(+), 16 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 092d09fb6a7e..17228584485d 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1643,11 +1643,6 @@ static int __init kvm_mips_init(void)
 	}
 
 	ret = kvm_mips_entry_setup();
-	if (ret)
-		return ret;
-
-	ret = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
-
 	if (ret)
 		return ret;
 
@@ -1656,6 +1651,13 @@ static int __init kvm_mips_init(void)
 
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
index 31e7630203fd..d3b68a6dec48 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8372,6 +8372,15 @@ static void vmx_exit(void)
 }
 module_exit(vmx_exit);
 
+/* initialize before kvm_init() so that hardware_enable/disable() can work. */
+static void __init vmx_init_early(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+}
+
 static int __init vmx_init(void)
 {
 	int r, cpu;
@@ -8409,6 +8418,7 @@ static int __init vmx_init(void)
 	}
 #endif
 
+	vmx_init_early();
 	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
 		     __alignof__(struct vcpu_vmx), THIS_MODULE);
 	if (r)
@@ -8427,11 +8437,8 @@ static int __init vmx_init(void)
 		return r;
 	}
 
-	for_each_possible_cpu(cpu) {
-		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
-
+	for_each_possible_cpu(cpu)
 		pi_init_cpu(cpu);
-	}
 
 #ifdef CONFIG_KEXEC_CORE
 	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d4f130a9f5c8..79a4988fd51f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1441,6 +1441,7 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 int kvm_arch_hardware_enable(void);
 void kvm_arch_hardware_disable(void);
 int kvm_arch_hardware_setup(void *opaque);
+int kvm_arch_post_hardware_enable_setup(void *opaque);
 void kvm_arch_hardware_unsetup(void);
 int kvm_arch_check_processor_compat(void);
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a5bada53f1fe..cee799265ce6 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4899,8 +4899,13 @@ static void hardware_enable_nolock(void *junk)
 
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
@@ -5697,9 +5702,9 @@ void kvm_unregister_perf_callbacks(void)
 }
 #endif
 
-static void check_processor_compat(void *rtn)
+__weak int kvm_arch_post_hardware_enable_setup(void *opaque)
 {
-	*(int *)rtn = kvm_arch_check_processor_compat();
+	return 0;
 }
 
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
@@ -5732,11 +5737,17 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
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
+	hardware_disable_all();
 
 	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
 				      kvm_starting_cpu, kvm_dying_cpu);
-- 
2.25.1

