Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BD36B6452
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjCLJyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjCLJyr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6313803C
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614871; x=1710150871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wESeFDsWKKpxD5r9zzM1LH1GKAFscJ3dwPokdLwC19A=;
  b=MgcXDB5pA55Fa1Fg0J7Z2jmTNmgMyRh1oqonnJ31ZWzjKwp5jMgGV0OQ
   T4SMeGt+zhVu9zKjJuhVtKu4u2q8uoFsinSVjOZE/mmS0Ma/98jkO2fkH
   CFSKHAqxmEDjKvt6/kX9lX58CzAPw+Yd1Y++VTOMtH0I2F0JSIvGJva2Y
   iHQOgOEMPTl58MWYXbpphHm2wQlHxi1Achch8DE8EPXCP08SswpGbQlHv
   PP/MOBW8sGLUZPDlpG67BGz4Xivxk5adTVBCscHu29+GeuqcKB2/OA+/Z
   u6ex5nF65/tlhs4Zhgnv98vfVyTP7veJFlRFEoOvgmBW8q+GJ4UAbDw3P
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622894"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622894"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408957"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408957"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:21 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-2 03/17] pkvm: x86: Add vmx capability check and vmx config setup
Date:   Mon, 13 Mar 2023 02:00:58 +0800
Message-Id: <20230312180112.1778254-4-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180112.1778254-1-jason.cj.chen@intel.com>
References: <20230312180112.1778254-1-jason.cj.chen@intel.com>
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

Check minimal vmx capabilities requirement for pKVM on Intel platform.
Setup vmcs config and vmx cap for later run VCPUs of deprivileged
host VM.

The vmx capabilities are checked through setup_vmcs_config_common,
the same API as KVM. pKVM tries to pass-thru resource to host VM as
much as possible, so it does not need to do a lot of emulations;
but some capabilities are still required for pKVM's emulations
(e.g. EPT, SHADOW_VMCS, MSR_BITMAP etc.), so pKVM has its own
different check-set from KVM.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/Makefile       |  1 +
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |  5 +++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    | 66 ++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/Makefile b/arch/x86/kvm/vmx/pkvm/Makefile
index 493bec8501c9..1795d5f9b4b0 100644
--- a/arch/x86/kvm/vmx/pkvm/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
+ccflags-y += -I $(srctree)/arch/x86/kvm
 ccflags-y += -I $(srctree)/arch/x86/kvm/vmx/pkvm/include
 
 pkvm-obj		:= pkvm_host.o
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 3fb76665e785..cda599194588 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -6,8 +6,13 @@
 #ifndef _PKVM_H_
 #define _PKVM_H_
 
+#include <vmx/vmx.h>
+
 struct pkvm_hyp {
 	int num_cpus;
+
+	struct vmx_capability vmx_cap;
+	struct vmcs_config vmcs_config;
 };
 
 #define PKVM_PAGES (ALIGN(sizeof(struct pkvm_hyp), PAGE_SIZE) >> PAGE_SHIFT)
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 7677df6a2b34..8fd31360faf8 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -17,6 +17,64 @@ static void *pkvm_early_alloc_contig(int pages)
 	return alloc_pages_exact(pages << PAGE_SHIFT, GFP_KERNEL | __GFP_ZERO);
 }
 
+static void pkvm_early_free(void *ptr, int pages)
+{
+	free_pages_exact(ptr, pages << PAGE_SHIFT);
+}
+
+static __init int pkvm_host_check_and_setup_vmx_cap(struct pkvm_hyp *pkvm)
+{
+	struct vmcs_config *vmcs_config = &pkvm->vmcs_config;
+	struct vmx_capability *vmx_cap = &pkvm->vmx_cap;
+	int ret = 0;
+	struct vmcs_config_setting setting = {
+		.cpu_based_vm_exec_ctrl_req =
+			CPU_BASED_INTR_WINDOW_EXITING |
+			CPU_BASED_USE_MSR_BITMAPS |
+			CPU_BASED_ACTIVATE_SECONDARY_CONTROLS,
+		.cpu_based_vm_exec_ctrl_opt = 0,
+		.secondary_vm_exec_ctrl_req =
+			SECONDARY_EXEC_ENABLE_EPT |
+			SECONDARY_EXEC_SHADOW_VMCS,
+		.secondary_vm_exec_ctrl_opt =
+			SECONDARY_EXEC_ENABLE_VPID |
+			SECONDARY_EXEC_ENABLE_INVPCID |
+			SECONDARY_EXEC_XSAVES |
+			SECONDARY_EXEC_ENABLE_RDTSCP |
+			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE,
+		.tertiary_vm_exec_ctrl_opt = 0,
+		.pin_based_vm_exec_ctrl_req = 0,
+		.pin_based_vm_exec_ctrl_opt = 0,
+		.vmexit_ctrl_req =
+			VM_EXIT_HOST_ADDR_SPACE_SIZE |
+			VM_EXIT_LOAD_IA32_PAT |
+			VM_EXIT_LOAD_IA32_EFER |
+			VM_EXIT_SAVE_IA32_PAT |
+			VM_EXIT_SAVE_IA32_EFER |
+			VM_EXIT_SAVE_DEBUG_CONTROLS,
+		.vmexit_ctrl_opt = 0,
+		.vmentry_ctrl_req =
+			VM_ENTRY_LOAD_DEBUG_CONTROLS |
+			VM_ENTRY_IA32E_MODE |
+			VM_ENTRY_LOAD_IA32_EFER |
+			VM_ENTRY_LOAD_IA32_PAT,
+		.vmentry_ctrl_opt = 0,
+	};
+
+	ret = setup_vmcs_config_common(vmcs_config, vmx_cap, &setting);
+	if (ret) {
+		pr_err("%s: fail with ret %d\n", __func__, ret);
+	} else {
+		pr_info("pin_based_exec_ctrl 0x%x\n", vmcs_config->pin_based_exec_ctrl);
+		pr_info("cpu_based_exec_ctrl 0x%x\n", vmcs_config->cpu_based_exec_ctrl);
+		pr_info("cpu_based_2nd_exec_ctrl 0x%x\n", vmcs_config->cpu_based_2nd_exec_ctrl);
+		pr_info("vmexit_ctrl 0x%x\n", vmcs_config->vmexit_ctrl);
+		pr_info("vmentry_ctrl 0x%x\n", vmcs_config->vmentry_ctrl);
+	}
+
+	return ret;
+}
+
 __init int pkvm_init(void)
 {
 	int ret = 0;
@@ -27,8 +85,16 @@ __init int pkvm_init(void)
 		goto out;
 	}
 
+	ret = pkvm_host_check_and_setup_vmx_cap(pkvm);
+	if (ret)
+		goto out_free_pkvm;
+
 	pkvm->num_cpus = num_possible_cpus();
 
+	return 0;
+
+out_free_pkvm:
+	pkvm_early_free(pkvm, PKVM_PAGES);
 out:
 	return ret;
 }
-- 
2.25.1

