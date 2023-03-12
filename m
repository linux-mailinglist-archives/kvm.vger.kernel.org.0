Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9224C6B6493
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjCLJ7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCLJ7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DCD20694
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615091; x=1710151091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SC6u68zqcnNQtx+nVX/hc1HaSoeptuzkS+vl4S1U9oc=;
  b=QLs4iDCp+VlnVVsCjSCyOxdrcnoBb+pKPvKgdpNa1fnGUt6N71IoMJUS
   vsHe2dhYTOfyZOjZlu5yjoWg/jNLtIgGH6t98U5Jo+thXeCt0QVhLz34e
   3U/ANZha6B1O6q9MuXOiP7+q6RfaLa+s8hQvTIZUAzDc8oPhn0YPJtUFk
   RVaZi4/oS5t7C9cCqS4e5oyWF2VKWz53bh7o4jxAXgOKD+6oNfRn/i4qz
   /CNnhTxso3YZxLXpLuCm+UugQQfvItFZOHAbwoKcNSYWx7KLATPHbShja
   D+LJPgKk3K3jMY1J2RT5gT8b6ygvCUdEQ/5Ja453J6SBfyqnrtoJDrjBG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998128"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998128"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677759"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677759"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:29 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-5 18/22] pkvm: x86: Add VMREAD/VMWRITE emulation
Date:   Mon, 13 Mar 2023 02:02:59 +0800
Message-Id: <20230312180303.1778492-19-jason.cj.chen@intel.com>
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

Provide emulation for VMREAD and VMWRITE vmx instructions.

The VMREAD/VMWRITE of non-shadowing vmcs fields from host VM cause
vmexit. Add vmexit handlers to manage these non-shadowing vmcs fields,
mainly two different parts:
- emulated fields: record in cached_vmcs12 and set dirty_vmcs12 to
  indicate emulation needed before vmcs02 take effect.
- host state fields: record in cached_vmcs12 and restore as guest
  state for vmcs01 when return back to host VM.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/pkvm_image_vars.h |   3 +-
 arch/x86/kvm/vmx/pkvm/hyp/nested.c     | 138 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/nested.h     |   2 +
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c     |  10 ++
 4 files changed, 152 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pkvm_image_vars.h b/arch/x86/include/asm/pkvm_image_vars.h
index 598c60302bac..967ee323a5c0 100644
--- a/arch/x86/include/asm/pkvm_image_vars.h
+++ b/arch/x86/include/asm/pkvm_image_vars.h
@@ -16,7 +16,8 @@ PKVM_ALIAS(sme_me_mask);
 #endif
 
 PKVM_ALIAS(__default_kernel_pte_mask);
-
+PKVM_ALIAS(vmcs12_field_offsets);
+PKVM_ALIAS(nr_vmcs12_fields);
 #endif
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index dab002ff3c68..fd8755621cc8 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -229,6 +229,18 @@ static bool is_host_fields(unsigned long field)
 	return (((field) >> 10U) & 0x3U) == 3U;
 }
 
+static bool is_emulated_fields(unsigned long field_encoding)
+{
+	int i;
+
+	for (i = 0; i < max_emulated_fields; i++) {
+		if ((unsigned long)emulated_fields[i].encoding == field_encoding)
+			return true;
+	}
+
+	return false;
+}
+
 static void nested_vmx_result(enum VMXResult result, int error_number)
 {
 	u64 rflags = vmcs_readl(GUEST_RFLAGS);
@@ -671,6 +683,132 @@ int handle_vmclear(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+int handle_vmwrite(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct pkvm_host_vcpu *pkvm_hvcpu = to_pkvm_hvcpu(vcpu);
+	struct shadow_vcpu_state *cur_shadow_vcpu = pkvm_hvcpu->current_shadow_vcpu;
+	struct vmcs12 *vmcs12 = (struct vmcs12 *)cur_shadow_vcpu->cached_vmcs12;
+	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct x86_exception e;
+	unsigned long field;
+	short offset;
+	gva_t gva;
+	int r, reg;
+	u64 value = 0;
+
+	if (check_vmx_permission(vcpu)) {
+		if (vmx->nested.current_vmptr == INVALID_GPA) {
+			nested_vmx_result(VMfailInvalid, 0);
+		} else {
+			if (instr_info & BIT(10)) {
+				reg = ((instr_info) >> 3) & 0xf;
+				value = vcpu->arch.regs[reg];
+			} else {
+				if (get_vmx_mem_address(vcpu, vmx->exit_qualification,
+							instr_info, &gva))
+					return 1;
+
+				r = read_gva(vcpu, gva, &value, 8, &e);
+				if (r < 0) {
+					/*TODO: handle memory failure exception */
+					return r;
+				}
+			}
+
+			reg = ((instr_info) >> 28) & 0xf;
+			field = vcpu->arch.regs[reg];
+
+			offset = get_vmcs12_field_offset(field);
+			if (offset < 0) {
+				nested_vmx_result(VMfailInvalid, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+				return 0;
+			}
+
+			/*TODO: check vcpu supports "VMWRITE to any supported field in the VMCS"*/
+			if (vmcs_field_readonly(field)) {
+				nested_vmx_result(VMfailInvalid, VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
+				return 0;
+			}
+
+			/*
+			 * Some Intel CPUs intentionally drop the reserved bits of the AR byte
+			 * fields on VMWRITE.  Emulate this behavior to ensure consistent KVM
+			 * behavior regardless of the underlying hardware, e.g. if an AR_BYTE
+			 * field is intercepted for VMWRITE but not VMREAD (in L1), then VMREAD
+			 * from L1 will return a different value than VMREAD from L2 (L1 sees
+			 * the stripped down value, L2 sees the full value as stored by KVM).
+			 */
+			if (field >= GUEST_ES_AR_BYTES && field <= GUEST_TR_AR_BYTES)
+				value &= 0x1f0ff;
+
+			vmcs12_write_any(vmcs12, field, offset, value);
+
+			if (is_emulated_fields(field)) {
+				vmx->nested.dirty_vmcs12 = true;
+				nested_vmx_result(VMsucceed, 0);
+			} else if (is_host_fields(field)) {
+				nested_vmx_result(VMsucceed, 0);
+			} else {
+				pkvm_err("%s: not include emulated fields 0x%lx, please add!\n",
+						__func__, field);
+				nested_vmx_result(VMfailInvalid, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+			}
+		}
+	}
+
+	return 0;
+}
+
+int handle_vmread(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct pkvm_host_vcpu *pkvm_hvcpu = to_pkvm_hvcpu(vcpu);
+	struct shadow_vcpu_state *cur_shadow_vcpu = pkvm_hvcpu->current_shadow_vcpu;
+	struct vmcs12 *vmcs12 = (struct vmcs12 *)cur_shadow_vcpu->cached_vmcs12;
+	u32 instr_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+	struct x86_exception e;
+	unsigned long field;
+	short offset;
+	gva_t gva = 0;
+	int r, reg;
+	u64 value;
+
+	if (check_vmx_permission(vcpu)) {
+		if (vmx->nested.current_vmptr == INVALID_GPA) {
+			nested_vmx_result(VMfailInvalid, 0);
+		} else {
+			/* Decode instruction info and find the field to read */
+			reg = ((instr_info) >> 28) & 0xf;
+			field = vcpu->arch.regs[reg];
+
+			offset = get_vmcs12_field_offset(field);
+			if (offset < 0) {
+				nested_vmx_result(VMfailInvalid, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+			} else {
+				value = vmcs12_read_any(vmcs12, field, offset);
+				if (instr_info & BIT(10)) {
+					reg = ((instr_info) >> 3) & 0xf;
+					vcpu->arch.regs[reg] = value;
+				} else {
+					if (get_vmx_mem_address(vcpu, vmx->exit_qualification,
+								instr_info, &gva))
+						return 1;
+
+					r = write_gva(vcpu, gva, &value, 8, &e);
+					if (r < 0) {
+						/*TODO: handle memory failure exception */
+						return r;
+					}
+				}
+				nested_vmx_result(VMsucceed, 0);
+			}
+		}
+	}
+
+	return 0;
+}
+
 void pkvm_init_nest(void)
 {
 	init_vmcs_shadow_fields();
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.h b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
index a228b0fdc15d..5fc76bdb135a 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.h
@@ -9,6 +9,8 @@ int handle_vmxon(struct kvm_vcpu *vcpu);
 int handle_vmxoff(struct kvm_vcpu *vcpu);
 int handle_vmptrld(struct kvm_vcpu *vcpu);
 int handle_vmclear(struct kvm_vcpu *vcpu);
+int handle_vmwrite(struct kvm_vcpu *vcpu);
+int handle_vmread(struct kvm_vcpu *vcpu);
 void pkvm_init_nest(void);
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index b2cfb87983a8..d4f2a408e6e9 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -216,6 +216,16 @@ int pkvm_main(struct kvm_vcpu *vcpu)
 			handle_vmclear(vcpu);
 			skip_instruction = true;
 			break;
+		case EXIT_REASON_VMREAD:
+			pkvm_dbg("CPU%d vmexit reason: WMREAD.\n", vcpu->cpu);
+			handle_vmread(vcpu);
+			skip_instruction = true;
+			break;
+		case EXIT_REASON_VMWRITE:
+			pkvm_dbg("CPU%d vmexit reason: VMWRITE.\n", vcpu->cpu);
+			handle_vmwrite(vcpu);
+			skip_instruction = true;
+			break;
 		case EXIT_REASON_XSETBV:
 			handle_xsetbv(vcpu);
 			skip_instruction = true;
-- 
2.25.1

