Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC3A5F085B
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiI3KTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiI3KS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:18:56 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6031664AC;
        Fri, 30 Sep 2022 03:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533135; x=1696069135;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9bbInB0ukaubXcuWCjnrDa7KuqBfgc8oZMafM3ru0lA=;
  b=CMzZvMvCTJQ70o89o73peP5HGPca8SZvlC9V9hrWn0aFnj/6Q/ajbwod
   nztGfsCnCmnHKzrMjIjjTExvNQZ82/DlJyz0os+ej68W/or4s6K/EtM6Y
   +CWMm9lTEgTjDcRONSeOnKQDsPv87Lri6BUbAFLSMj95nW94WPcAiJYFO
   cJOqiVHgck/vH2bPDqwL0xBq2M/Lzb3+0UwnhLrGdDHYugrTjJqgSEhao
   rVA9Cx5u4FDKUT5eDauwycL9IitUaDo3/UwhWLt8pS3F1ctP0Z8jVzzOB
   j/tQIyKZi+1NgBUZ0qAKaoeBh1MBL2HOZDmkeVLCp1sV6ZXv+enmItm90
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870067"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870067"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:54 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807559"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807559"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:18:54 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 017/105] KVM: TDX: Refuse to unplug the last cpu on the package
Date:   Fri, 30 Sep 2022 03:17:11 -0700
Message-Id: <3521fdb3fcf30043a0310ed226c06034d6b1cadd.1664530907.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

In order to reclaim TDX host key id, (i.e. when deleting guest TD), needs
to call TDH.PHYMEM.PAGE.WBINVD on all packages.  If we have used TDX host
key id, refuse to offline the last online cpu.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/tdx.c             | 40 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/x86_ops.h         |  2 ++
 arch/x86/kvm/x86.c                 | 27 ++++++++++++--------
 6 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 968e5ba1e4e6..cc7df6fccbb2 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -17,6 +17,7 @@ BUILD_BUG_ON(1)
 KVM_X86_OP(hardware_enable)
 KVM_X86_OP(hardware_disable)
 KVM_X86_OP(hardware_unsetup)
+KVM_X86_OP_OPTIONAL_RET0(offline_cpu)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f3d16e5730ac..7cd5e5917bab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1460,6 +1460,7 @@ struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
+	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 408afa691bad..43cc3af7d0ec 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -67,6 +67,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
 	.hardware_unsetup = vt_hardware_unsetup,
+	.offline_cpu = tdx_offline_cpu,
 	.check_processor_compatibility = vmx_check_processor_compatibility,
 
 	.hardware_enable = vmx_hardware_enable,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 93174b10e1ea..6b07451d6661 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -42,6 +42,7 @@ static struct tdx_capabilities tdx_caps;
  */
 static DEFINE_MUTEX(tdx_lock);
 static struct mutex *tdx_mng_key_config_lock;
+static atomic_t nr_configured_hkid;
 
 static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 {
@@ -210,7 +211,8 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		pr_err("tdh_mng_key_freeid failed. HKID %d is leaked.\n",
 			kvm_tdx->hkid);
 		return;
-	}
+	} else
+		atomic_dec(&nr_configured_hkid);
 
 free_hkid:
 	tdx_hkid_free(kvm_tdx);
@@ -362,6 +364,8 @@ int tdx_vm_init(struct kvm *kvm)
 		if (ret)
 			break;
 	}
+	if (!ret)
+		atomic_inc(&nr_configured_hkid);
 	cpus_read_unlock();
 	free_cpumask_var(packages);
 	if (ret)
@@ -512,3 +516,37 @@ void tdx_hardware_unsetup(void)
 	/* kfree accepts NULL. */
 	kfree(tdx_mng_key_config_lock);
 }
+
+int tdx_offline_cpu(void)
+{
+	int curr_cpu = smp_processor_id();
+	cpumask_var_t packages;
+	int ret = 0;
+	int i;
+
+	if (!atomic_read(&nr_configured_hkid))
+		return 0;
+
+	/*
+	 * To reclaim hkid, need to call TDH.PHYMEM.PAGE.WBINVD on all packages.
+	 * If this is the last online cpu on the package, refuse offline.
+	 */
+	if (!zalloc_cpumask_var(&packages, GFP_KERNEL))
+		return -ENOMEM;
+
+	for_each_online_cpu(i) {
+		if (i != curr_cpu)
+			cpumask_set_cpu(topology_physical_package_id(i), packages);
+	}
+	if (!cpumask_test_cpu(topology_physical_package_id(curr_cpu), packages))
+		ret = -EBUSY;
+	free_cpumask_var(packages);
+	if (ret)
+		/*
+		 * Because it's hard for human operator to understand the
+		 * reason, warn it.
+		 */
+		pr_warn("TDX requires all packages to have an online CPU.  "
+			"Delete all TDs in order to offline all CPUs of a package.\n");
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ce50ddef84bf..5ab78e044895 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -134,6 +134,7 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 bool tdx_is_vm_type_supported(unsigned long type);
 void tdx_hardware_unsetup(void);
+int tdx_offline_cpu(void);
 
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
@@ -142,6 +143,7 @@ void tdx_vm_free(struct kvm *kvm);
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline void tdx_hardware_unsetup(void) {}
+static inline int tdx_offline_cpu(void) { return 0; }
 
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 82e6f54b35fb..351803fdc944 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12062,16 +12062,23 @@ int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 
 int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
 {
-	if (usage_count) {
-		/*
-		 * arch callback kvm_arch_hardware_disable() assumes that
-		 * preemption is disabled for historical reason.  Disable
-		 * preemption until all arch callbacks are fixed.
-		 */
-		preempt_disable();
-		hardware_disable(NULL);
-		preempt_enable();
-	}
+	int ret;
+
+	if (!usage_count)
+		return 0;
+
+	ret = static_call(kvm_x86_offline_cpu)();
+	if (ret)
+		return ret;
+
+	/*
+	 * arch callback kvm_arch_hardware_disable() assumes that preemption is
+	 * disabled for historical reason.  Disable preemption until all arch
+	 * callbacks are fixed.
+	 */
+	preempt_disable();
+	hardware_disable(NULL);
+	preempt_enable();
 	return 0;
 }
 
-- 
2.25.1

