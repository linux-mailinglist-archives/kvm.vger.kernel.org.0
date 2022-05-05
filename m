Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3D251C6E3
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383090AbiEEST3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383031AbiEESTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:22 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6B611C24;
        Thu,  5 May 2022 11:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774541; x=1683310541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HdCdcuH/OgY0jKRJKLCVg2pYtJ+xgxTLIcUG8pswVLU=;
  b=Vs2olW7w2m+WZAa3kBRAdkic9nkqzg5Te0N1ZcTdMyweNwFUEx2+82ff
   Vl6E39HiUFjLWQBa/bx/27rNPN+IbttbWdFatR3YIILDxUAbaDQ1XNSpN
   ef92/a8Fu7UP1T64m0RV5LygWTfutPYf+lhQKob1F26EjZobgjqikmbYQ
   C5herDOpVfk65H5Qp5MsNihzjUVxYHeM9u+dDs4lc1G6pZkB417K2I8LN
   ssnMNiNk3eZT3JYVodqnlMPdYBfC+OIJZaWNXDH/UTQluijy/2AbYo9N5
   sBmWl7gQDvA6Cl+WCX0JFO2FvLymhq77cGBj7R6dNigTxkA6knCiYHUCa
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328746221"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="328746221"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:39 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083135"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:39 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 003/104] KVM: Refactor CPU compatibility check on module initialiization
Date:   Thu,  5 May 2022 11:13:57 -0700
Message-Id: <75912816e498ddf62e7efb6a187d763c89e72f45.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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
 arch/mips/kvm/mips.c   | 12 +++++++-----
 arch/x86/kvm/vmx/vmx.c | 15 +++++++++++----
 virt/kvm/kvm_main.c    | 20 ++++++++++----------
 3 files changed, 28 insertions(+), 19 deletions(-)

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
index e30493fe4553..9bc46c1e64d9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8254,6 +8254,15 @@ static void vmx_exit(void)
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
@@ -8291,6 +8300,7 @@ static int __init vmx_init(void)
 	}
 #endif
 
+	vmx_init_early();
 	r = kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
 		     __alignof__(struct vcpu_vmx), THIS_MODULE);
 	if (r)
@@ -8309,11 +8319,8 @@ static int __init vmx_init(void)
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
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ec365291c625..0ff03889aa5d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4883,8 +4883,13 @@ static void hardware_enable_nolock(void *junk)
 
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
@@ -5681,11 +5686,6 @@ void kvm_unregister_perf_callbacks(void)
 }
 #endif
 
-static void check_processor_compat(void *rtn)
-{
-	*(int *)rtn = kvm_arch_check_processor_compat();
-}
-
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		  struct module *module)
 {
@@ -5716,11 +5716,11 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
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
+	hardware_disable_all();
 
 	r = cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:starting",
 				      kvm_starting_cpu, kvm_dying_cpu);
-- 
2.25.1

