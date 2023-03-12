Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A666B645A
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjCLJzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjCLJyv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:51 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E5F38EBE
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614890; x=1710150890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nLg5vH5GiiicTMj1az4W0+wKowGXKdfTVI7TNRHETik=;
  b=ZZuKmXRRgs1IqLGp2OOqMKAB3Om1Xvd9koRTxj+nWqCAM+RB3fbXg8AV
   GhzzI8qiivmmQqM4J3I4WpMZz2zqcuwgUaRl9O6JYlIbiQpjjDLVjBJ+O
   W6b8KxNc3Vjwfw/3caZ7IfxJeYyXhvUMrMW/HEv3YHG0jmniGe+o6rhg3
   WZJKcQqSO6yCODVm4wkhhx0omXlZgLPJY4YefvXWyc0+SSwAPe8NaidEG
   btP3E7o02dqwAwHsukOWrTZfvPbq+86UluNhfbISvIh1r7sJ4FXjfpNEH
   iJ6QyMpAQGGHa3xtN3EE0aaMejTrfcCAthQPlxZMlzMssW8JwzT/lwfWo
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622926"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622926"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852409010"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852409010"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:31 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-2 10/17] pkvm: x86: Initialize vmcs control fields for host vcpu
Date:   Mon, 13 Mar 2023 02:01:05 +0800
Message-Id: <20230312180112.1778254-11-jason.cj.chen@intel.com>
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

Do vmx execution/vmexit/vmetry control fields initialization based on
vmcs_config (setup by __setup_vmcs_config) for host vcpu.

CPU_BASED_CR3_LOAD_EXITING & CPU_BASED_CR3_STORE_EXITING are always set
from __setup_vmcs_config but pKVM does not want them, so clear them
from cpu_based_exec_ctrl.

CPU_BASED_INTR_WINDOW_EXITING is toggled dynamically (for later nmi
handling), so clear it first from cpu_based_exec_ctrl.

SECONDARY_EXEC_ENABLE_EPT & SECONDARY_EXEC_ENABLE_VPID in
cpu_based_2nd_exec_ctrl are disabled before EPT page table created for
host VM in pKVM.

The control field configuration in this patch also makes host VM handle
its interrupt & exception directly, and fully own CR0 & CR3, for CR4,
only VMXE bit is intercepted by pKVM, and the MSR intercept setting
need updating to pre-allocated msr_bitmap.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/pkvm_host.c | 60 +++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 9634bbccfbdd..810e7421f644 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -280,6 +280,63 @@ static __init void init_host_state_area(struct pkvm_host_vcpu *vcpu)
 	/*TODO: add HOST_RIP */
 }
 
+static __init void init_execution_control(struct vcpu_vmx *vmx,
+			    struct vmcs_config *vmcs_config_ptr,
+			    struct vmx_capability *vmx_cap)
+{
+	u32 cpu_based_exec_ctrl = vmcs_config_ptr->cpu_based_exec_ctrl;
+	u32 cpu_based_2nd_exec_ctrl = vmcs_config_ptr->cpu_based_2nd_exec_ctrl;
+
+	pin_controls_set(vmx, vmcs_config_ptr->pin_based_exec_ctrl);
+
+	/*
+	 * CR3 LOAD/STORE EXITING are not used by pkvm
+	 * INTR/NMI WINDOW EXITING are toggled dynamically
+	 */
+	cpu_based_exec_ctrl &= ~(CPU_BASED_CR3_LOAD_EXITING |
+				CPU_BASED_CR3_STORE_EXITING |
+				CPU_BASED_INTR_WINDOW_EXITING |
+				CPU_BASED_NMI_WINDOW_EXITING);
+	exec_controls_set(vmx, cpu_based_exec_ctrl);
+
+	/* disable EPT/VPID first, enable after EPT pgtable created */
+	cpu_based_2nd_exec_ctrl &= ~(SECONDARY_EXEC_ENABLE_EPT |
+				SECONDARY_EXEC_ENABLE_VPID);
+	secondary_exec_controls_set(vmx, cpu_based_2nd_exec_ctrl);
+
+	/* guest owns cr3 */
+	vmcs_write32(CR3_TARGET_COUNT, 0);
+
+	/* guest handles exception directly */
+	vmcs_write32(EXCEPTION_BITMAP, 0);
+
+	vmcs_write64(MSR_BITMAP, __pa(vmx->vmcs01.msr_bitmap));
+
+	/*
+	 * guest owns cr0, and owns cr4 except VMXE bit.
+	 * does not care about IA32_VMX_CRx_FIXED0/1 setting, so if guest modify
+	 * cr0/cr4 conflicting with FIXED0/1, just let #GP happen.
+	 * For example, as pKVM does not enable unrestricted guest, cr0.PE/PG
+	 * must keep as 1 in guest.
+	 */
+	vmcs_writel(CR0_GUEST_HOST_MASK, 0);
+	vmcs_writel(CR4_GUEST_HOST_MASK, X86_CR4_VMXE);
+}
+
+static __init void init_vmexit_control(struct vcpu_vmx *vmx, struct vmcs_config *vmcs_config_ptr)
+{
+	vm_exit_controls_set(vmx, vmcs_config_ptr->vmexit_ctrl);
+	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
+}
+
+static __init void init_vmentry_control(struct vcpu_vmx *vmx, struct vmcs_config *vmcs_config_ptr)
+{
+	vm_entry_controls_set(vmx, vmcs_config_ptr->vmentry_ctrl);
+	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
+	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 0);
+	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
+}
+
 static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = &vcpu->vmx;
@@ -305,6 +362,9 @@ static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu, int cpu)
 
 	init_guest_state_area(vcpu, cpu);
 	init_host_state_area(vcpu);
+	init_execution_control(vmx, &pkvm->vmcs_config, &pkvm->vmx_cap);
+	init_vmexit_control(vmx, &pkvm->vmcs_config);
+	init_vmentry_control(vmx, &pkvm->vmcs_config);
 
 	return ret;
 }
-- 
2.25.1

