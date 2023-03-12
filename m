Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E5F6B647C
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjCLJ6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCLJ5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:57:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27DBE50992
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615033; x=1710151033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bUG923mPxlNDkxy5HKfPlHsECeDht2ntyTuSGMVFCx4=;
  b=VShLeS+gTSx5St3a1Ed2VUGgukGW2o8IlRp6aZklOpBuTuqz1mORqwTw
   +uNFRsnqTbY01EVOW71uBE524fBp1+WvOL/6usFmHNEUfg8wmIIkDBpBv
   YxY79IneYWJKxKu6VDT9P0CgUCy1V54oz4nbjfym2obrsOv00m1UVgI7Y
   6AUd9rMWDt1EhbL4lVsezlA0+Xm8Ni+ALLlByA7cu3VzEj+dPwHLKekD2
   sgprVRqUyrEksGo84XZIE9bS5IKebfaqjLIx9BGD/BjePDyDdBJCcp8ba
   m6myBk5LZUuepHQufDbD+OChbrWnEvLHOfr2CLfieJN40A7vDTFEpplgP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998076"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998076"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677542"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677542"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:52 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-4 3/4] pkvm: x86: Support get_pcpu_id
Date:   Mon, 13 Mar 2023 02:02:43 +0800
Message-Id: <20230312180244.1778422-4-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180244.1778422-1-jason.cj.chen@intel.com>
References: <20230312180244.1778422-1-jason.cj.chen@intel.com>
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

There is use case to get pcpu id during pKVM runtime, especially
within exception/irq context when it cannot get such information from
current host vcpu.

Use MSR_GS_BASE to record pcpu_id, and enable pKVM to get pcpu_id
during its runtime.

It is prepared for nmi handler, as when CPU is running in pKVM
hypervisor, nmi is not able to block, so pKVM need to appropriately
inject it back to host vcpu to avoid nmi lost. When nmi happen, its
handler doesn't have context which host vcpu it shall do the following
injection. get_pcpu_id() here can help the nmi handler get
corresponding host vcpu.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/cpu.h   | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c | 12 +++++++-----
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/cpu.h b/arch/x86/kvm/vmx/pkvm/hyp/cpu.h
new file mode 100644
index 000000000000..c49074292f7c
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/cpu.h
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef _PKVM_CPU_H_
+#define _PKVM_CPU_H_
+
+static inline u64 pkvm_msr_read(u32 reg)
+{
+	u32 msrl, msrh;
+
+	asm volatile (" rdmsr ":"=a"(msrl), "=d"(msrh) : "c" (reg));
+	return (((u64)msrh << 32U) | msrl);
+}
+
+#ifdef CONFIG_PKVM_INTEL_DEBUG
+#include <linux/smp.h>
+static inline u64 get_pcpu_id(void)
+{
+	return raw_smp_processor_id();
+}
+#else
+/* this function shall only be used during pkvm runtime */
+static inline u64 get_pcpu_id(void)
+{
+	return pkvm_msr_read(MSR_GS_BASE);
+}
+#endif
+
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index c7768ee22e57..77cd7b654168 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -240,14 +240,13 @@ static __init void init_guest_state_area(struct pkvm_host_vcpu *vcpu, int cpu)
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
 }
 
-static __init void _init_host_state_area(struct pkvm_pcpu *pcpu)
+static __init void _init_host_state_area(struct pkvm_pcpu *pcpu, int cpu)
 {
 	unsigned long a;
 #ifdef CONFIG_PKVM_INTEL_DEBUG
 	u32 high, low;
 	struct desc_ptr dt;
 	u16 selector;
-	int cpu = raw_smp_processor_id();
 #endif
 
 	vmcs_writel(HOST_CR0, read_cr0() & ~X86_CR0_TS);
@@ -302,6 +301,9 @@ static __init void _init_host_state_area(struct pkvm_pcpu *pcpu)
 	vmcs_writel(HOST_TR_BASE, (unsigned long)&pcpu->tss);
 	vmcs_writel(HOST_GDTR_BASE, (unsigned long)(&pcpu->gdt_page));
 	vmcs_writel(HOST_IDTR_BASE, (unsigned long)(&pcpu->idt_page));
+
+	vmcs_write16(HOST_GS_SELECTOR, __KERNEL_DS);
+	vmcs_writel(HOST_GS_BASE, cpu);
 #endif
 
 	/* MSR area */
@@ -312,11 +314,11 @@ static __init void _init_host_state_area(struct pkvm_pcpu *pcpu)
 	vmcs_write64(HOST_IA32_PAT, a);
 }
 
-static __init void init_host_state_area(struct pkvm_host_vcpu *vcpu)
+static __init void init_host_state_area(struct pkvm_host_vcpu *vcpu, int cpu)
 {
 	struct pkvm_pcpu *pcpu = vcpu->pcpu;
 
-	_init_host_state_area(pcpu);
+	_init_host_state_area(pcpu, cpu);
 
 	/*host RIP*/
 	vmcs_writel(HOST_RIP, (unsigned long)pkvm_sym(__pkvm_vmx_vmexit));
@@ -403,7 +405,7 @@ static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu, int cpu)
 	vmcs_load(vmx->loaded_vmcs->vmcs);
 
 	init_guest_state_area(vcpu, cpu);
-	init_host_state_area(vcpu);
+	init_host_state_area(vcpu, cpu);
 	init_execution_control(vmx, &pkvm->vmcs_config, &pkvm->vmx_cap);
 	init_vmexit_control(vmx, &pkvm->vmcs_config);
 	init_vmentry_control(vmx, &pkvm->vmcs_config);
-- 
2.25.1

