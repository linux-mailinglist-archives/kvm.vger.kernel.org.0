Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD236B6470
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjCLJ4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjCLJ4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253A34E5F7
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614967; x=1710150967;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rIoYKmU9w0gpuix+Txi+j6pMdZsr4myC79fiQ1v/MZc=;
  b=H+pIrvpCJ7x2LsOJLD5jeSLW1s2PIIoGfchNkh1ch0Oj7CYRFh/OV9mJ
   m8PjF/98E7HomK//BZoUerGCk240oXC2lF3Mr/DREajJNKBWYE2CyAhHP
   8ipvNhbhk/EVTxd/CFo+xYCo/Yo5jNy+RmMO/d4KzUCicQJCB1jMH0+KK
   lcOC0UQYofyiaQuDmTeQcvZx5xOsrim/S7Ft8tpEUDWoOxngksX0BS96W
   Wilbd3I0fXoeodvvAuDXXesjFY4Yhvw2E2ShO0h3B49a6Nw2Mcbs1yYS9
   dtk7jBUd+JueiizqXVqR1M4QED0Qa1Jq8XjKeJIkea0EPDg2VeY3jJDeq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623054"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623054"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660832"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660832"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:20 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-3 15/22] pkvm: x86: Add init-finalise hypercall
Date:   Mon, 13 Mar 2023 02:01:45 +0800
Message-Id: <20230312180152.1778338-16-jason.cj.chen@intel.com>
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

Currently, pKVM use host cr3 and disabling EPT to do the
deprivilege. After deprivilege, the pKVM runtime shall create its
own MMU/EPT pgtable to ensure the isolation. This shall be done in
VMX root mode, through a hypercall from the host vcpu.

The MMU/EPT pgtable creation is done by the first vcpu triggered such
hypercall, the pKVM memory section information is passed as the
hypercall parameter to help the pgtable creation. Other vcpus only need
to switch their CR3 and set their EPTP to the one first vcpu created
through the same hypercall.

Due to the memory section parameter from host hypercall may locate in
VMAP_STACK, which could be invalid after pKVM switch to its own CR3
(as no such virtual memory mapping), uses a tmp section array in the
pKVM stack to save such parameter.

This patch introduces the init-finalise hypercall, the following patches
will create MMU/EPT pgtable within this hypercall's handler.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/kvm_pkvm.h           |   3 +
 arch/x86/kvm/vmx/pkvm/hyp/Makefile        |   3 +-
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c |  53 +++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c        |  31 +++++++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h      |  13 +++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c         | 102 ++++++++++++++++++++++
 6 files changed, 204 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_pkvm.h b/arch/x86/include/asm/kvm_pkvm.h
index 3c750f1a3a2d..0142b3dc3c01 100644
--- a/arch/x86/include/asm/kvm_pkvm.h
+++ b/arch/x86/include/asm/kvm_pkvm.h
@@ -14,6 +14,9 @@
 #define HYP_MEMBLOCK_REGIONS   128
 #define PKVM_PGTABLE_MAX_LEVELS		5U
 
+/* PKVM Hypercalls */
+#define PKVM_HC_INIT_FINALISE		1
+
 extern struct memblock_region pkvm_sym(hyp_memory)[];
 extern unsigned int pkvm_sym(hyp_memblock_nr);
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index bea43d22a2a3..383ddf75f50e 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -12,7 +12,8 @@ ccflags-y += -D__PKVM_HYP__
 lib-dir		:= lib
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
-pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o
+pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o \
+		   init_finalise.o
 
 pkvm-hyp-y	+= $(lib-dir)/memset_64.o
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
new file mode 100644
index 000000000000..c62049728621
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <pkvm.h>
+#include "debug.h"
+
+#define TMP_SECTION_SZ	16UL
+int __pkvm_init_finalise(struct kvm_vcpu *vcpu, struct pkvm_section sections[],
+			 int section_sz)
+{
+	int i, ret = 0;
+	static bool pkvm_init;
+	struct pkvm_section tmp_sections[TMP_SECTION_SZ];
+	phys_addr_t hyp_mem_base;
+	unsigned long hyp_mem_size = 0;
+
+	if (pkvm_init)
+		goto switch_pgt;
+
+	if (section_sz > TMP_SECTION_SZ) {
+		pkvm_err("pkvm: no enough space to save sections[] array parameters!");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* kernel may use VMAP_STACK, which could make the parameter's vaddr
+	 * not-valid after we switch new CR3 later, so copy parameter sections
+	 * array from host space to pkvm space
+	 */
+	for (i = 0; i < section_sz; i++) {
+		tmp_sections[i] = sections[i];
+		if (sections[i].type == PKVM_RESERVED_MEMORY) {
+			hyp_mem_base = sections[i].addr;
+			hyp_mem_size = sections[i].size;
+		}
+	}
+	if (hyp_mem_size == 0) {
+		pkvm_err("pkvm: no pkvm reserve memory!");
+		ret = -ENOTSUPP;
+	}
+
+	/* TODO: setup MMU & host EPT page tables */
+
+	pkvm_init = true;
+
+switch_pgt:
+	/* TODO: switch MMU & EPT */
+
+out:
+	return ret;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index 19be7ce201df..c9f522f5b064 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2022 Intel Corporation
  */
 
+#include <linux/memblock.h>
+#include <asm/kvm_pkvm.h>
 #include <pkvm.h>
 #include "vmexit.h"
 #include "debug.h"
@@ -11,6 +13,9 @@
 
 #define MOV_TO_CR		0
 
+extern int __pkvm_init_finalise(struct kvm_vcpu *vcpu,
+		phys_addr_t phys, unsigned long size);
+
 static void skip_emulated_instruction(void)
 {
 	unsigned long rip;
@@ -67,6 +72,28 @@ static void handle_cr(struct kvm_vcpu *vcpu)
 	}
 }
 
+static unsigned long handle_vmcall(struct kvm_vcpu *vcpu)
+{
+	u64 nr, a0, a1, a2, a3;
+	unsigned long ret = 0;
+
+	nr = vcpu->arch.regs[VCPU_REGS_RAX];
+	a0 = vcpu->arch.regs[VCPU_REGS_RBX];
+	a1 = vcpu->arch.regs[VCPU_REGS_RCX];
+	a2 = vcpu->arch.regs[VCPU_REGS_RDX];
+	a3 = vcpu->arch.regs[VCPU_REGS_RSI];
+
+	switch (nr) {
+	case PKVM_HC_INIT_FINALISE:
+		__pkvm_init_finalise(vcpu, a0, a1);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
 static void handle_read_msr(struct kvm_vcpu *vcpu)
 {
 	/* simply return 0 for non-supported MSRs */
@@ -135,6 +162,10 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 			handle_xsetbv(vcpu);
 			skip_instruction = true;
 			break;
+		case EXIT_REASON_VMCALL:
+			vcpu->arch.regs[VCPU_REGS_RAX] = handle_vmcall(vcpu);
+			skip_instruction = true;
+			break;
 		default:
 			pkvm_dbg("CPU%d: Unsupported vmexit reason 0x%x.\n", vcpu->cpu, vmx->exit_reason.full);
 			skip_instruction = true;
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 18ec51965936..42dc76d37c02 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -53,6 +53,16 @@ struct pkvm_hyp {
 	struct pkvm_host_vm host_vm;
 };
 
+struct pkvm_section {
+	unsigned long type;
+#define PKVM_RESERVED_MEMORY		0UL
+#define PKVM_CODE_DATA_SECTIONS		1UL
+#define KERNEL_DATA_SECTIONS		2UL
+	unsigned long addr;
+	unsigned long size;
+	u64 prot;
+};
+
 #define PKVM_PAGES (ALIGN(sizeof(struct pkvm_hyp), PAGE_SIZE) >> PAGE_SHIFT)
 #define PKVM_PCPU_PAGES (ALIGN(sizeof(struct pkvm_pcpu), PAGE_SIZE) >> PAGE_SHIFT)
 #define PKVM_HOST_VCPU_PAGES (ALIGN(sizeof(struct pkvm_host_vcpu), PAGE_SIZE) >> PAGE_SHIFT)
@@ -60,6 +70,9 @@ struct pkvm_hyp {
 #define PKVM_PERCPU_PAGES (PKVM_PCPU_PAGES + PKVM_HOST_VCPU_PAGES + PKVM_VMCS_PAGES)
 
 extern char __pkvm_text_start[], __pkvm_text_end[];
+extern char __pkvm_rodata_start[], __pkvm_rodata_end[];
+extern char __pkvm_data_start[], __pkvm_data_end[];
+extern char __pkvm_bss_start[], __pkvm_bss_end[];
 
 extern unsigned long pkvm_sym(__page_base_offset);
 extern unsigned long pkvm_sym(__symbol_base_offset);
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 36ed9df1c7ab..101b7b190662 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -704,6 +704,108 @@ static __init int pkvm_host_deprivilege_cpus(struct pkvm_hyp *pkvm)
 	return p.ret;
 }
 
+static __init void do_pkvm_finalise(void *data)
+{
+	kvm_hypercall2(PKVM_HC_INIT_FINALISE, 0, 0);
+}
+
+static __init int pkvm_init_finalise(void)
+{
+	int ret, cpu;
+	int self = get_cpu();
+	struct pkvm_section sections[] = {
+		/*
+		 * NOTE: please ensure kernel section is put at the beginning,
+		 * as we do section mapping by the order, while kernel data
+		 * sections have overlap with pkvm ones, put the kernel section
+		 * after pkvm one will make pkvm section readonly!
+		 */
+		{
+			/*
+			 * Kernel section: addr is virtual, needed
+			 * for pkvm to access kernel alias symbol
+			 */
+			.type = KERNEL_DATA_SECTIONS,
+			.addr = (unsigned long)_sdata,
+			.size = (unsigned long)(_edata - _sdata),
+			.prot = (u64)pgprot_val(PAGE_KERNEL_RO),
+		},
+		{
+			/*
+			 * Kernel section: addr is virtual, needed
+			 * for pkvm to access kernel alias symbol
+			 */
+			.type = KERNEL_DATA_SECTIONS,
+			.addr = (unsigned long)__start_rodata,
+			.size = (unsigned long)(__end_rodata - __start_rodata),
+			.prot = (u64)pgprot_val(PAGE_KERNEL_RO),
+		},
+		{
+			/* PKVM reserved memory: addr is physical */
+			.type = PKVM_RESERVED_MEMORY,
+			.addr = (unsigned long)hyp_mem_base,
+			.size = (unsigned long)hyp_mem_size,
+			.prot = (u64)pgprot_val(PAGE_KERNEL),
+		},
+		{
+			/* PKVM section: addr is virtual */
+			.type = PKVM_CODE_DATA_SECTIONS,
+			.addr = (unsigned long)__pkvm_text_start,
+			.size = (unsigned long)(__pkvm_text_end - __pkvm_text_start),
+			.prot = (u64)pgprot_val(PAGE_KERNEL_EXEC),
+		},
+		{
+			/* PKVM section: addr is virtual */
+			.type = PKVM_CODE_DATA_SECTIONS,
+			.addr = (unsigned long)__pkvm_rodata_start,
+			.size = (unsigned long)(__pkvm_rodata_end - __pkvm_rodata_start),
+			.prot = (u64)pgprot_val(PAGE_KERNEL_RO),
+		},
+		{
+			/* PKVM section: addr is virtual */
+			.type = PKVM_CODE_DATA_SECTIONS,
+			.addr = (unsigned long)__pkvm_data_start,
+			.size = (unsigned long)(__pkvm_data_end - __pkvm_data_start),
+			.prot = (u64)pgprot_val(PAGE_KERNEL),
+		},
+		{
+			/* PKVM section: addr is virtual */
+			.type = PKVM_CODE_DATA_SECTIONS,
+			.addr = (unsigned long)__pkvm_bss_start,
+			.size = (unsigned long)(__pkvm_bss_end - __pkvm_bss_start),
+			.prot = (u64)pgprot_val(PAGE_KERNEL),
+		},
+	};
+
+	/*
+	 * First hypercall to recreate the pgtable for pkvm, and init
+	 * memory pool for later use.
+	 * Input parameters are only needed for first hypercall.
+	 */
+	ret = kvm_hypercall2(PKVM_HC_INIT_FINALISE,
+			(unsigned long)sections, ARRAY_SIZE(sections));
+
+	if (ret) {
+		pr_err("%s: pkvm finalise failed!\n", __func__);
+		goto out;
+	}
+
+	for_each_possible_cpu(cpu) {
+		if (cpu == self)
+			continue;
+
+		/*
+		 * Second hypercall to switch the mmu and ept pgtable.
+		 */
+		ret = smp_call_function_single(cpu, do_pkvm_finalise,
+					       NULL, true);
+	}
+out:
+	put_cpu();
+
+	return ret;
+}
+
 __init int pkvm_init(void)
 {
 	int ret = 0, cpu;
-- 
2.25.1

