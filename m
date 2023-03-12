Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D92F6B6486
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjCLJ7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbjCLJ6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:42 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AB653DA2
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615064; x=1710151064;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WfVlsyeqiZLRjGPauPJDR5knUQSXXh2GYT/MJkvtWbw=;
  b=K+uOvYZ9UkX2ymIUDMruzhvqzvS1OGp/eFPoROVyz8fyxMZcUFl5101J
   SDRQgurR8EJtl3kDrahjYLNjaX0XZWbvwocxyeWlsumGWEkzNJkLEOuJ5
   9h0auGQ3+GklZ52zh4X6D8+7cIEW6b6WOqk46ffA7/n2BR3MI97AU+5Aw
   FFzmDmcCIbIuygbjkqT5PAjO8dd3q+Jef8kPUCz47tyw9aPfWPACJdAc1
   o0eoocxKEWkcrX892AXJV0R7ykQOPf9o2leNeBL2i/BuucPq4jNDOi9Qh
   JMulsHUQsXN0TPdm5DP+4uoRcc1kHwIaWCoj8OSpz46fD/I8ajyppr2ey
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998105"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998105"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677688"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677688"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:16 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-5 07/22] KVM: VMX: Add initialization/teardown for shadow vm/vcpu
Date:   Mon, 13 Mar 2023 02:02:48 +0800
Message-Id: <20230312180303.1778492-8-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add initialization/teardown for shadow vm & shadow vcpu from corresponding
kvm_x86_ops.

The initialization allocates shadow vm or shadow vcpu data structure
according to the size exposed from pkvm_constants, then hypercall to
send such data structure's address to pKVM.

The teardown hypercall to pKVM asking for the teardown of corresponding
shadow vm or shadow vcpu data structure in the hypervisor, then do finally
free of related memory.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/include/asm/kvm_host.h        |  4 ++
 arch/x86/include/asm/kvm_pkvm.h        | 10 ++++
 arch/x86/kvm/vmx/pkvm/pkvm_constants.c |  4 ++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c      | 76 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c                 | 14 ++++-
 include/linux/kvm_host.h               |  8 +++
 6 files changed, 114 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3dea471bfca4..74f0954c6899 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1750,6 +1750,10 @@ struct kvm_arch_async_pf {
 	bool direct_map;
 };
 
+struct kvm_protected_vm {
+	int shadow_vm_handle;
+};
+
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern u64 __read_mostly host_efer;
 extern bool __read_mostly allow_smaller_maxphyaddr;
diff --git a/arch/x86/include/asm/kvm_pkvm.h b/arch/x86/include/asm/kvm_pkvm.h
index 6e8fee717e5d..4e9531d88417 100644
--- a/arch/x86/include/asm/kvm_pkvm.h
+++ b/arch/x86/include/asm/kvm_pkvm.h
@@ -6,6 +6,8 @@
 #ifndef _ASM_X86_KVM_PKVM_H
 #define _ASM_X86_KVM_PKVM_H
 
+#include <linux/kvm_host.h>
+
 #ifdef CONFIG_PKVM_INTEL
 
 #include <linux/memblock.h>
@@ -131,8 +133,16 @@ static inline int hyp_pre_reserve_check(void)
 
 u64 hyp_total_reserve_pages(void);
 
+int pkvm_init_shadow_vm(struct kvm *kvm);
+void pkvm_teardown_shadow_vm(struct kvm *kvm);
+int pkvm_init_shadow_vcpu(struct kvm_vcpu *vcpu);
+void pkvm_teardown_shadow_vcpu(struct kvm_vcpu *vcpu);
 #else
 static inline void kvm_hyp_reserve(void) {}
+static inline int pkvm_init_shadow_vm(struct kvm *kvm) { return 0; }
+static inline void pkvm_teardown_shadow_vm(struct kvm *kvm) {}
+static inline int pkvm_init_shadow_vcpu(struct kvm_vcpu *vcpu) { return 0; }
+static inline void pkvm_teardown_shadow_vcpu(struct kvm_vcpu *vcpu) {}
 #endif
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_constants.c b/arch/x86/kvm/vmx/pkvm/pkvm_constants.c
index 729147e6b85f..c6dc35b52664 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_constants.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_constants.c
@@ -7,9 +7,13 @@
 #include <linux/bug.h>
 #include <vdso/limits.h>
 #include <buddy_memory.h>
+#include <vmx/vmx.h>
+#include "hyp/pkvm_hyp.h"
 
 int main(void)
 {
 	DEFINE(PKVM_VMEMMAP_ENTRY_SIZE, sizeof(struct hyp_page));
+	DEFINE(PKVM_SHADOW_VM_SIZE, sizeof(struct pkvm_shadow_vm) + pkvm_shadow_vcpu_array_size());
+	DEFINE(PKVM_SHADOW_VCPU_STATE_SIZE, sizeof(struct shadow_vcpu_state));
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 8ea2d64236d0..2dff1123b61f 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -869,6 +869,82 @@ static __init int pkvm_init_finalise(void)
 	return ret;
 }
 
+int pkvm_init_shadow_vm(struct kvm *kvm)
+{
+	struct kvm_protected_vm *pkvm = &kvm->pkvm;
+	size_t shadow_sz;
+	void *shadow_addr;
+	int ret;
+
+	shadow_sz = PAGE_ALIGN(PKVM_SHADOW_VM_SIZE);
+	shadow_addr = alloc_pages_exact(shadow_sz, GFP_KERNEL_ACCOUNT);
+	if (!shadow_addr)
+		return -ENOMEM;
+
+	ret = kvm_hypercall3(PKVM_HC_INIT_SHADOW_VM, (unsigned long)kvm,
+					  (unsigned long)__pa(shadow_addr), shadow_sz);
+	if (ret < 0)
+		goto free_page;
+
+	pkvm->shadow_vm_handle = ret;
+
+	return 0;
+free_page:
+	free_pages_exact(shadow_addr, shadow_sz);
+	return ret;
+}
+
+void pkvm_teardown_shadow_vm(struct kvm *kvm)
+{
+	struct kvm_protected_vm *pkvm = &kvm->pkvm;
+	unsigned long pa;
+
+	pa = kvm_hypercall1(PKVM_HC_TEARDOWN_SHADOW_VM, pkvm->shadow_vm_handle);
+	if (!pa)
+		return;
+
+	free_pages_exact(__va(pa), PAGE_ALIGN(PKVM_SHADOW_VM_SIZE));
+}
+
+int pkvm_init_shadow_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct kvm_protected_vm *pkvm = &vcpu->kvm->pkvm;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	s64 shadow_vcpu_handle;
+	size_t shadow_sz;
+	void *shadow_addr;
+
+	shadow_sz = PAGE_ALIGN(PKVM_SHADOW_VCPU_STATE_SIZE);
+	shadow_addr = alloc_pages_exact(shadow_sz, GFP_KERNEL_ACCOUNT);
+	if (!shadow_addr)
+		return -ENOMEM;
+
+	shadow_vcpu_handle = kvm_hypercall4(PKVM_HC_INIT_SHADOW_VCPU,
+					    pkvm->shadow_vm_handle, (unsigned long)vmx,
+					    (unsigned long)__pa(shadow_addr), shadow_sz);
+	if (shadow_vcpu_handle < 0)
+		goto free_page;
+
+	vcpu->pkvm_shadow_vcpu_handle = shadow_vcpu_handle;
+
+	return 0;
+
+free_page:
+	free_pages_exact(shadow_addr, shadow_sz);
+	return -EINVAL;
+}
+
+void pkvm_teardown_shadow_vcpu(struct kvm_vcpu *vcpu)
+{
+	unsigned long pa = kvm_hypercall1(PKVM_HC_TEARDOWN_SHADOW_VCPU,
+					  vcpu->pkvm_shadow_vcpu_handle);
+
+	if (!pa)
+		return;
+
+	free_pages_exact(__va(pa), PAGE_ALIGN(PKVM_SHADOW_VCPU_STATE_SIZE));
+}
+
 __init int pkvm_init(void)
 {
 	int ret = 0, cpu;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6e9723306992..61ae4c1c713d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -48,6 +48,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
+#include <asm/kvm_pkvm.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
@@ -7329,6 +7330,8 @@ static void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 	free_vpid(vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
+
+	pkvm_teardown_shadow_vcpu(vcpu);
 }
 
 static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
@@ -7426,7 +7429,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 		WRITE_ONCE(to_kvm_vmx(vcpu->kvm)->pid_table[vcpu->vcpu_id],
 			   __pa(&vmx->pi_desc) | PID_TABLE_ENTRY_VALID);
 
-	return 0;
+	return pkvm_init_shadow_vcpu(vcpu);
 
 free_vmcs:
 	free_loaded_vmcs(vmx->loaded_vmcs);
@@ -7468,7 +7471,13 @@ static int vmx_vm_init(struct kvm *kvm)
 			break;
 		}
 	}
-	return 0;
+
+	return pkvm_init_shadow_vm(kvm);
+}
+
+static void vmx_vm_free(struct kvm *kvm)
+{
+	pkvm_teardown_shadow_vm(kvm);
 }
 
 static int __init vmx_check_processor_compat(void)
@@ -8104,6 +8113,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 	.vm_destroy = vmx_vm_destroy,
+	.vm_free = vmx_vm_free,
 
 	.vcpu_precreate = vmx_vcpu_precreate,
 	.vcpu_create = vmx_vcpu_create,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 4f26b244f6d0..faab9a30002f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -390,6 +390,12 @@ struct kvm_vcpu {
 	 */
 	struct kvm_memory_slot *last_used_slot;
 	u64 last_used_slot_gen;
+
+	/*
+	 * Save the handle returned from the pkvm when init a shadow vcpu. This
+	 * will be used when teardown this shadow vcpu.
+	 */
+	s64 pkvm_shadow_vcpu_handle;
 };
 
 /*
@@ -805,6 +811,8 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+
+	struct kvm_protected_vm pkvm;
 };
 
 #define kvm_err(fmt, ...) \
-- 
2.25.1

