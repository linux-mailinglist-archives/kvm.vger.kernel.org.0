Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF156B6462
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCLJz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjCLJzO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:55:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB905098E
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614904; x=1710150904;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J/6ItArFJTH9kmQzSk1YwxazVQTf5vUT89WXFSoC6jU=;
  b=fQjABmR8Dkqj5EBhqjpWgv98BjrVLkwEm2pT1e01/s4zLFFPBlWfQw+J
   c/TgUsFtR0LFt4R7H2k8LFCySl4DkMKspYmubLeI+Y74+97UeFyOLqx/t
   kF/aXjvt5fTQEU7/DAU0KxRJnLOVP7qpQFxaxDFhsLt17xbHwWP/xidGw
   4NXCEi29J+xnYek5a5A2cG9fhbzaUp/T6nsQAeV2c5ivvOSKHwMoifiqI
   IZ0h5Wtdan3Chjw5SRjeKIZzC5IB71SLlSlGw6DDc9jl4dFCGGOfr0WOx
   Tw2chsswDvFk/FEC06jv1j3uO2Q+gQg1ZLiObj89a/gKYMKNpZ5pypAzq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623012"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623012"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660778"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660778"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:59 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-3 01/22] pkvm: x86: Define hypervisor runtime VA/PA APIs
Date:   Mon, 13 Mar 2023 02:01:31 +0800
Message-Id: <20230312180152.1778338-2-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180152.1778338-1-jason.cj.chen@intel.com>
References: <20230312180152.1778338-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pKVM has its own MMU page table, to maintain the mapping between VA &
PA under hypervisor runtime (VMX root mode).

Setup the translation between VA & PA for hypervisor runtime:
keep same direct mapping as Linux kernel based on __page_base_offset.
also keep same pkvm symbol mapping as Linux kernel based on
__symbol_base_offset.

direct mapping translation:
- pkvm_phys_to_virt: phys + __page_base_offset
- pkvm_virt_to_phys: virt - __page_base_offset
symbol mapping translation:
- pkvm_virt_to_symbol_phys: virt - __symbol_base_offset

The following patches will setup pKVM's MMU page table based on above
translation.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/kvm_pkvm.h      | 18 ++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/Makefile   |  2 +-
 arch/x86/kvm/vmx/pkvm/hyp/memory.c   | 24 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/memory.h   | 13 +++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h  |  5 +++--
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |  5 +++++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    | 19 +++++++++++++++++++
 7 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_pkvm.h b/arch/x86/include/asm/kvm_pkvm.h
new file mode 100644
index 000000000000..224143567aaa
--- /dev/null
+++ b/arch/x86/include/asm/kvm_pkvm.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#ifndef _ASM_X86_KVM_PKVM_H
+#define _ASM_X86_KVM_PKVM_H
+
+#ifdef CONFIG_PKVM_INTEL
+
+void *pkvm_phys_to_virt(unsigned long phys);
+unsigned long pkvm_virt_to_phys(void *virt);
+
+#define __pkvm_pa(virt)	pkvm_virt_to_phys((void *)(virt))
+#define __pkvm_va(phys)	pkvm_phys_to_virt((unsigned long)(phys))
+#endif
+
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index 5a92067ab05a..970341ab63a3 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -8,7 +8,7 @@ ccflags-y += -D__PKVM_HYP__
 
 lib-dir		:= lib
 
-pkvm-hyp-y	:= vmx_asm.o vmexit.o
+pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o
 
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
 pkvm-hyp-$(CONFIG_DEBUG_LIST)	+= $(lib-dir)/list_debug.o
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.c b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
new file mode 100644
index 000000000000..62dd80947d8e
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <linux/types.h>
+
+unsigned long __page_base_offset;
+unsigned long __symbol_base_offset;
+
+void *pkvm_phys_to_virt(unsigned long phys)
+{
+	return (void *)__page_base_offset + phys;
+}
+
+unsigned long pkvm_virt_to_phys(void *virt)
+{
+	return (unsigned long)virt - __page_base_offset;
+}
+
+unsigned long pkvm_virt_to_symbol_phys(void *virt)
+{
+	return (unsigned long)virt - __symbol_base_offset;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.h b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
new file mode 100644
index 000000000000..c2eee487687a
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef _PKVM_MEMORY_H_
+#define _PKVM_MEMORY_H_
+
+#include <asm/kvm_pkvm.h>
+
+unsigned long pkvm_virt_to_symbol_phys(void *virt);
+#define __pkvm_pa_symbol(x) pkvm_virt_to_symbol_phys((void *)x)
+
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h b/arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h
index 1692870ee00c..5fc049e4b487 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx_ops.h
@@ -5,6 +5,7 @@
 #ifndef _PKVM_VMX_OPS_H_
 #define _PKVM_VMX_OPS_H_
 
+#include "memory.h"
 #include "debug.h"
 
 #ifdef asm_volatile_goto
@@ -170,14 +171,14 @@ static __always_inline void vmcs_set_bits(unsigned long field, u32 mask)
 
 static inline void vmcs_clear(struct vmcs *vmcs)
 {
-	u64 phys_addr = __pa(vmcs);
+	u64 phys_addr = __pkvm_pa(vmcs);
 
 	vmx_asm1(vmclear, "m"(phys_addr), vmcs, phys_addr);
 }
 
 static inline void vmcs_load(struct vmcs *vmcs)
 {
-	u64 phys_addr = __pa(vmcs);
+	u64 phys_addr = __pkvm_pa(vmcs);
 
 	vmx_asm1(vmptrld, "m"(phys_addr), vmcs, phys_addr);
 }
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 59ef09230700..b344165511f7 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -48,6 +48,11 @@ struct pkvm_hyp {
 #define PKVM_PCPU_PAGES (ALIGN(sizeof(struct pkvm_pcpu), PAGE_SIZE) >> PAGE_SHIFT)
 #define PKVM_HOST_VCPU_PAGES (ALIGN(sizeof(struct pkvm_host_vcpu), PAGE_SIZE) >> PAGE_SHIFT)
 
+extern char __pkvm_text_start[], __pkvm_text_end[];
+
+extern unsigned long pkvm_sym(__page_base_offset);
+extern unsigned long pkvm_sym(__symbol_base_offset);
+
 PKVM_DECLARE(void, __pkvm_vmx_vmexit(void));
 PKVM_DECLARE(int, pkvm_main(struct kvm_vcpu *vcpu));
 
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 1fa273396b9b..9705aebaab2e 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -440,6 +440,21 @@ static __init int pkvm_host_check_and_setup_vmx_cap(struct pkvm_hyp *pkvm)
 	return ret;
 }
 
+static __init int pkvm_init_mmu(void)
+{
+	/*
+	 * __page_base_offset stores the offset for pkvm
+	 * to translate VA to a PA.
+	 *
+	 * __symbol_base_offset stores the offset for pkvm
+	 * to translate its symbole's VA to a PA.
+	 */
+	pkvm_sym(__page_base_offset) = (unsigned long)__va(0);
+	pkvm_sym(__symbol_base_offset) = (unsigned long)__pkvm_text_start - __pa_symbol(__pkvm_text_start);
+
+	return 0;
+}
+
 static __init void init_gdt(struct pkvm_pcpu *pcpu)
 {
 	pcpu->gdt_page = pkvm_gdt_page;
@@ -693,6 +708,10 @@ __init int pkvm_init(void)
 	if (ret)
 		goto out_free_pkvm;
 
+	ret = pkvm_init_mmu();
+	if (ret)
+		goto out_free_pkvm;
+
 	for_each_possible_cpu(cpu) {
 		ret = pkvm_setup_pcpu(pkvm, cpu);
 		if (ret)
-- 
2.25.1

