Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF66C6127CB
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiJ3GYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiJ3GYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:04 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC35DB;
        Sat, 29 Oct 2022 23:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111044; x=1698647044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0nvz3WaeOypeXRr2ZlbIpcoCC53yXD/BSQQN4hsBa1E=;
  b=NbwUDwkaJbRpWat4C6Gi8xmv5iMdqaMcA9hcGIhAjgvdwh+2EvMCvu+X
   K6Qcs1dhCSxY/nJdfYuQ9RI+XSYG42f5lqkF9q/KYgfk6PFDxVimU+0LD
   OohSrXbNAO4/Qp2fbW+KFuwPcMh6BjRvyCYuI9J+xLWGXjHsrs0wJGez5
   g5P3UrOHiLp+qdYFCXW+H1QqkwzzHIQI5SO2RVI6augcG0nlUZ7eR8R0Z
   Q3Sgcr3qHA69F8StPGJjkeMEYfn0+0/oM1uPW2n/cKj6GMzaZx/QVamIe
   ZmWha5DYrCXSdzjpYFTc7SOFnWOB2cE36mfryr4VQ6fvm5IZE6PxtC3pU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037129"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037129"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:23:59 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392882"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392882"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:23:59 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 017/108] KVM: TDX: Refuse to unplug the last cpu on the package
Date:   Sat, 29 Oct 2022 23:22:18 -0700
Message-Id: <de6b69781a6ba1fe65535f48db2677eef3ec6a83.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 3a29a6b31ee8..0ceb8e58a6c0 100644
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
index 2870155ce6fb..50b39d0071ff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1466,6 +1466,7 @@ struct kvm_x86_ops {
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
+	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d01a946a18cf..0918d1e6d2f3 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -67,6 +67,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
 	.hardware_unsetup = vt_hardware_unsetup,
+	.offline_cpu = tdx_offline_cpu,
 	.check_processor_compatibility = vmx_check_processor_compatibility,
 
 	.hardware_enable = vmx_hardware_enable,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ec88dde0d300..64229c3b3c5a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -42,6 +42,7 @@ static struct tdx_capabilities tdx_caps;
  */
 static DEFINE_MUTEX(tdx_lock);
 static struct mutex *tdx_mng_key_config_lock;
+static atomic_t nr_configured_hkid;
 
 static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 {
@@ -222,7 +223,8 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 		pr_err("tdh_mng_key_freeid failed. HKID %d is leaked.\n",
 			kvm_tdx->hkid);
 		return;
-	}
+	} else
+		atomic_dec(&nr_configured_hkid);
 
 free_hkid:
 	tdx_hkid_free(kvm_tdx);
@@ -371,6 +373,8 @@ int tdx_vm_init(struct kvm *kvm)
 		if (ret)
 			break;
 	}
+	if (!ret)
+		atomic_inc(&nr_configured_hkid);
 	cpus_read_unlock();
 	free_cpumask_var(packages);
 	if (ret)
@@ -514,3 +518,37 @@ void tdx_hardware_unsetup(void)
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
index 95da978c9aa9..b2cb5786830a 100644
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
index 4b22196cb12c..25c30c8c2d9b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12337,16 +12337,23 @@ int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 
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

