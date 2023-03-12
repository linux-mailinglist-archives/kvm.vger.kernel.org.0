Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A79E6B64A1
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjCLKAr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbjCLKAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 06:00:09 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32DD2D46
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615152; x=1710151152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1vmCp2EfW7I3sfRSBpW1Nt+lJ02lUoPytlufQTTSZbc=;
  b=nWuDL1zxnC7wgJjWI1ko+VNE3NqIiQAavp+Fxp/yL1hOkVWNQJ8DieSN
   AYyBmOS89t3D1ErcnFCQGcuG7bKPwcAA32joDh0U/za++fK7N9zl1c8Lx
   fbtKHJhYoBSIS9JM/H5ItxSmKazGg+dEViryWM6Zw+yrgJ8IlkxOJIyXA
   sZ6Xvq45pSvCu6OTLluj+LDFipKx63U8ja6curz2lsU9LEIXVBU2xe5Rm
   Ky3or4UkmM1MlhbJqLRZPq1DHNLYDCZ7uT1ZuQ/VuatQyZzqgonU2LMrc
   e50G3VSwALZAkCwMem18i0yarGfIzT9zA6bNXDMtawgmCeV4lLvX0vlSv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344725"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344725"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627377"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627377"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:57:04 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-6 12/13] pkvm: x86: Add INVEPT instruction emulation
Date:   Mon, 13 Mar 2023 02:03:44 +0800
Message-Id: <20230312180345.1778588-13-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180345.1778588-1-jason.cj.chen@intel.com>
References: <20230312180345.1778588-1-jason.cj.chen@intel.com>
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

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

For INVEPT with single context, look up the vCPU vmcs12 to find out
the corresponding shadow EPT to do the invalidation.

For INVEPT with global context, invalidate all the valid shadow EPTs.

TODO: current emulation may cause a lot of unnecessary shadow EPT
violation due to inappropriate EPT invalidation as all page table
entries are freed. Optimization shall be done in the future to do
PV INVEPT with specific range.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/nested.c   | 106 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/nested.h   |   1 +
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c     |  27 +++++++
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h |   3 +
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c   |   3 +
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h      |   5 ++
 6 files changed, 145 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index 8b9202ecafff..3a338f7f5a69 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -729,6 +729,56 @@ static void setup_guest_ept(struct shadow_vcpu_state *shadow_vcpu, u64 guest_ept
 		pkvm_invalidate_shadow_ept(&vm->sept_desc);
 }
 
+static int __do_handle_invept(struct pkvm_shadow_vm *vm, void *data)
+{
+	if (data) {
+		/*
+		 * Single context invalidate with specific guest eptp
+		 */
+		u64 guest_eptp = *(u64 *)data;
+		struct shadow_vcpu_state *vcpu;
+		struct vmcs12 *vmcs12;
+		s64 shadow_vcpu_handle;
+		int i;
+
+		pkvm_spin_lock(&vm->lock);
+
+		for (i = 0; i < vm->created_vcpus; i++) {
+			shadow_vcpu_handle = to_shadow_vcpu_handle(vm->shadow_vm_handle, i);
+			vcpu = get_shadow_vcpu(shadow_vcpu_handle);
+			if (!vcpu)
+				continue;
+			vmcs12 = (struct vmcs12 *)vcpu->cached_vmcs12;
+			if (vmcs12->ept_pointer == guest_eptp) {
+				put_shadow_vcpu(shadow_vcpu_handle);
+				break;
+			}
+			put_shadow_vcpu(shadow_vcpu_handle);
+		}
+
+		pkvm_spin_unlock(&vm->lock);
+
+		/* No vCPU is using this guest eptp so no need invalidate */
+		if (i == vm->created_vcpus)
+			goto done;
+	}
+
+	/*
+	 * Gloable context invalidation directly went here.
+	 */
+	pkvm_invalidate_shadow_ept(&vm->sept_desc);
+done:
+	return data ? 1 : 0;
+}
+
+static void do_handle_invept(u64 *guest_eptp)
+{
+	if (guest_eptp && !is_valid_eptp(*guest_eptp))
+		return;
+
+	for_each_valid_shadow_vm(__do_handle_invept, guest_eptp);
+}
+
 int handle_vmxon(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -1019,6 +1069,62 @@ int handle_vmlaunch(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int handle_invept(struct kvm_vcpu *vcpu)
+{
+	struct vmx_capability *vmx_cap = &pkvm_hyp->vmx_cap;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 vmx_instruction_info, types;
+	unsigned long type;
+	int gpr_index;
+
+	if (!vmx_has_invept())
+		/* TODO: inject #UD */
+		return -EINVAL;
+
+	if (!check_vmx_permission(vcpu))
+		return 0;
+
+	vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	gpr_index = vmx_get_instr_info_reg2(vmx_instruction_info);
+	type = vcpu->arch.regs[gpr_index];
+	types = (vmx_cap->ept >> VMX_EPT_EXTENT_SHIFT) & 6;
+
+	if (type >= 32 || !(types & (1 << type))) {
+		nested_vmx_result(VMfailValid, VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
+		return 0;
+	}
+
+	switch (type) {
+	case VMX_EPT_EXTENT_CONTEXT: {
+		struct x86_exception e;
+		gva_t gva;
+		struct {
+			u64 eptp, gpa;
+		} operand;
+
+		if (get_vmx_mem_address(vcpu, vmx->exit_qualification,
+					vmx_instruction_info, &gva))
+			/* TODO: handle the decode failure */
+			return -EINVAL;
+
+		if (read_gva(vcpu, gva, &operand, sizeof(operand), &e) < 0)
+			/*TODO: handle memory failure exception */
+			return -EINVAL;
+
+		do_handle_invept(&operand.eptp);
+		break;
+	}
+	case VMX_EPT_EXTENT_GLOBAL:
+		do_handle_invept(NULL);
+		break;
+	default:
+		break;
+	}
+
+	nested_vmx_result(VMsucceed, 0);
+	return 0;
+}
+
 static bool nested_handle_ept_violation(struct shadow_vcpu_state *shadow_vcpu,
 					u64 l2_gpa, u64 exit_quali)
 {
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.h b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
index 24cf731e96dd..01a0e5761e5a 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
@@ -13,6 +13,7 @@ int handle_vmwrite(struct kvm_vcpu *vcpu);
 int handle_vmread(struct kvm_vcpu *vcpu);
 int handle_vmresume(struct kvm_vcpu *vcpu);
 int handle_vmlaunch(struct kvm_vcpu *vcpu);
+int handle_invept(struct kvm_vcpu *vcpu);
 int nested_vmexit(struct kvm_vcpu *vcpu);
 void pkvm_init_nest(void);
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
index 321df4dd2998..e18688b1a235 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
@@ -355,3 +355,30 @@ unsigned long __pkvm_teardown_shadow_vcpu(s64 shadow_vcpu_handle)
 	memset(shadow_vcpu, 0, sizeof(struct shadow_vcpu_state));
 	return pkvm_virt_to_phys(shadow_vcpu);
 }
+
+int for_each_valid_shadow_vm(int (*fn)(struct pkvm_shadow_vm *vm, void *data),
+			     void *data)
+{
+	struct pkvm_shadow_vm *vm;
+	int i, ret;
+
+	pkvm_spin_lock(&shadow_vms_lock);
+	for (i = HANDLE_OFFSET; i < MAX_SHADOW_VMS; i++) {
+		if (!test_bit(i, shadow_vms_bitmap))
+			continue;
+
+		vm = get_shadow_vm(i);
+		if (!vm)
+			continue;
+
+		ret = fn(vm, data);
+
+		put_shadow_vm(i);
+
+		if (ret)
+			break;
+	}
+	pkvm_spin_unlock(&shadow_vms_lock);
+
+	return ret < 0 ? ret : 0;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
index cc7ec8505a98..bf5719eefa0e 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
@@ -116,6 +116,9 @@ struct shadow_vcpu_state *get_shadow_vcpu(s64 shadow_vcpu_handle);
 void put_shadow_vcpu(s64 shadow_vcpu_handle);
 s64 find_shadow_vcpu_handle_by_vmcs(unsigned long vmcs12_pa);
 
+int for_each_valid_shadow_vm(int (*fn)(struct pkvm_shadow_vm *vm, void *data),
+			     void *data);
+
 extern struct pkvm_hyp *pkvm_hyp;
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index 307514f44ec9..e768118fd1f3 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -241,6 +241,9 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 				handle_irq_window(vcpu);
 				break;
 			case EXIT_REASON_INVEPT:
+				handle_invept(vcpu);
+				skip_instruction = true;
+				break;
 			case EXIT_REASON_INVVPID:
 				ept_sync_global();
 				skip_instruction = true;
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
index 463780776666..6b9ad304fe1d 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
@@ -15,6 +15,11 @@ static inline bool vmx_ept_capability_check(u32 bit)
 	return vmx_cap->ept & bit;
 }
 
+static inline bool vmx_has_invept(void)
+{
+	return vmx_ept_capability_check(VMX_EPT_INVEPT_BIT);
+}
+
 static inline bool vmx_ept_has_4levels(void)
 {
 	return vmx_ept_capability_check(VMX_EPT_PAGE_WALK_4_BIT);
-- 
2.25.1

