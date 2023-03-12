Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E456B6498
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjCLKA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjCLJ7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:25 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039B129437
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615104; x=1710151104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ueWmb2hKuM+rv4/A50rSuSFIDkhUgnf6+9Z8UAgUNBI=;
  b=lubkTZ4kHCRJW9kEis/bSHA1bBr939+1f3jEbPiPzuyfe/cK9jRVc1Is
   OIS33kd12hvmLrpktYq37R6GbXBMvKYUDU563cfxUg8U7NColSHL63/XY
   Iro2pmUmFKRsgxGZy8ZLnC+qp8Ujdqm3ws/ZGFxlhARa/ITj6QAM4RMYA
   V3jIZJu9LkTyxF6TNpUDWxuhS2HLoc1d8KsUKFRHpoQfFvqCZoN/zbvdr
   kjEqrSe1tR0VzA4h6zdeNkWuVX60bHsM7qSBlyyUUKFl8uPCH3fyM//lM
   kR67IjS8QRAbhc68EN2mMNXAT6BJ0YG5mVFRn7PR//m02lGnsWSkpBRCJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998132"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998132"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677797"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677797"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:32 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-5 21/22] pkvm: x86: Initialize msr_bitmap for vmsr
Date:   Mon, 13 Mar 2023 02:03:02 +0800
Message-Id: <20230312180303.1778492-22-jason.cj.chen@intel.com>
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

Introduce enable_msr_interception API to init msr_bitmap, based on it
pKVM can setup the virtual MSR list which need to be trapped and
emulated in the hypervisor.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile   |  2 +-
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c   | 13 +----
 arch/x86/kvm/vmx/pkvm/hyp/vmsr.c     | 73 ++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmsr.h     | 11 +++++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |  2 +
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    |  1 +
 6 files changed, 89 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index ca6d43509ddc..fc75cdd9fc79 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -12,7 +12,7 @@ ccflags-y += -D__PKVM_HYP__
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
 pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o \
-		   init_finalise.o ept.o idt.o irq.o nested.o vmx.o
+		   init_finalise.o ept.o idt.o irq.o nested.o vmx.o vmsr.o
 
 ifndef CONFIG_PKVM_INTEL_DEBUG
 lib-dir		:= lib
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index 8e7392010887..307514f44ec9 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -9,6 +9,7 @@
 #include "vmexit.h"
 #include "ept.h"
 #include "pkvm_hyp.h"
+#include "vmsr.h"
 #include "nested.h"
 #include "debug.h"
 
@@ -109,18 +110,6 @@ static unsigned long handle_vmcall(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void handle_read_msr(struct kvm_vcpu *vcpu)
-{
-	/* simply return 0 for non-supported MSRs */
-	vcpu->arch.regs[VCPU_REGS_RAX] = 0;
-	vcpu->arch.regs[VCPU_REGS_RDX] = 0;
-}
-
-static void handle_write_msr(struct kvm_vcpu *vcpu)
-{
-	/*No emulation for msr write now*/
-}
-
 static void handle_xsetbv(struct kvm_vcpu *vcpu)
 {
 	u32 eax = (u32)(vcpu->arch.regs[VCPU_REGS_RAX] & -1u);
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmsr.c b/arch/x86/kvm/vmx/pkvm/hyp/vmsr.c
new file mode 100644
index 000000000000..360b0333b84f
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmsr.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/*
+ * Copyright (C) 2018-2022 Intel Corporation
+ */
+
+#include <pkvm.h>
+#include "cpu.h"
+#include "debug.h"
+
+#define INTERCEPT_DISABLE		(0U)
+#define INTERCEPT_READ			(1U << 0U)
+#define INTERCEPT_WRITE			(1U << 1U)
+#define INTERCEPT_READ_WRITE		(INTERCEPT_READ | INTERCEPT_WRITE)
+
+static unsigned int emulated_ro_guest_msrs[] = {
+	/* DUMMY */
+};
+
+static void enable_msr_interception(u8 *bitmap, unsigned int msr_arg, unsigned int mode)
+{
+	unsigned int read_offset = 0U;
+	unsigned int write_offset = 2048U;
+	unsigned int msr = msr_arg;
+	u8 msr_bit;
+	unsigned int msr_index;
+
+	if ((msr <= 0x1FFFU) || ((msr >= 0xc0000000U) && (msr <= 0xc0001fffU))) {
+		if ((msr & 0xc0000000U) != 0U) {
+			read_offset = read_offset + 1024U;
+			write_offset = write_offset + 1024U;
+		}
+
+		msr &= 0x1FFFU;
+		msr_bit = (u8)(1U << (msr & 0x7U));
+		msr_index = msr >> 3U;
+
+		if ((mode & INTERCEPT_READ) == INTERCEPT_READ)
+			bitmap[read_offset + msr_index] |= msr_bit;
+		else
+			bitmap[read_offset + msr_index] &= ~msr_bit;
+
+		if ((mode & INTERCEPT_WRITE) == INTERCEPT_WRITE)
+			bitmap[write_offset + msr_index] |= msr_bit;
+		else
+			bitmap[write_offset + msr_index] &= ~msr_bit;
+	} else {
+		pkvm_err("%s, Invalid MSR: 0x%x", __func__, msr);
+	}
+}
+
+int handle_read_msr(struct kvm_vcpu *vcpu)
+{
+	/* simply return 0 for non-supported MSRs */
+	vcpu->arch.regs[VCPU_REGS_RAX] = 0;
+	vcpu->arch.regs[VCPU_REGS_RDX] = 0;
+
+	return 0;
+}
+
+int handle_write_msr(struct kvm_vcpu *vcpu)
+{
+	/*No emulation for msr write now*/
+	return 0;
+}
+
+void init_msr_emulation(struct vcpu_vmx *vmx)
+{
+	int i;
+	u8 *bitmap = (u8 *)vmx->loaded_vmcs->msr_bitmap;
+
+	for (i = 0; i < ARRAY_SIZE(emulated_ro_guest_msrs); i++)
+		enable_msr_interception(bitmap, emulated_ro_guest_msrs[i], INTERCEPT_READ);
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmsr.h b/arch/x86/kvm/vmx/pkvm/hyp/vmsr.h
new file mode 100644
index 000000000000..1f39a37996f4
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmsr.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef _PKVM_VMSR_H_
+#define _PKVM_VMSR_H_
+
+int handle_read_msr(struct kvm_vcpu *vcpu);
+int handle_write_msr(struct kvm_vcpu *vcpu);
+
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 9b45627853b3..59bbe645baaa 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -106,6 +106,8 @@ PKVM_DECLARE(void *, pkvm_early_alloc_contig(unsigned int nr_pages));
 PKVM_DECLARE(void *, pkvm_early_alloc_page(void));
 PKVM_DECLARE(void, pkvm_early_alloc_init(void *virt, unsigned long size));
 
+PKVM_DECLARE(void, init_msr_emulation(struct vcpu_vmx *vmx));
+
 PKVM_DECLARE(void, noop_handler(void));
 PKVM_DECLARE(void, nmi_handler(void));
 
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index cbba3033ba63..90d7cddde9ef 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -280,6 +280,7 @@ static __init void init_execution_control(struct vcpu_vmx *vmx,
 	/* guest handles exception directly */
 	vmcs_write32(EXCEPTION_BITMAP, 0);
 
+	pkvm_sym(init_msr_emulation(vmx));
 	vmcs_write64(MSR_BITMAP, __pa(vmx->vmcs01.msr_bitmap));
 
 	/*
-- 
2.25.1

