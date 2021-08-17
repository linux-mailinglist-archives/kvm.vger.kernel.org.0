Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5283EE9E5
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 11:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239377AbhHQJcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 05:32:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:49582 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237640AbhHQJcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 05:32:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="238111520"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="238111520"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 02:31:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="449200718"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga007.fm.intel.com with ESMTP; 17 Aug 2021 02:31:35 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write respects field existence bitmap
Date:   Tue, 17 Aug 2021 17:31:11 +0800
Message-Id: <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In vmcs12_{read,write}_any(), check the field exist or not. If not, return
failure. Hence their function prototype changed a little accordingly.
In handle_vm{read,write}(), above function's caller, check return value, if
failed, emulate nested vmx fail with instruction error of
VMXERR_UNSUPPORTED_VMCS_COMPONENT.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/nested.c | 20 ++++++++++++------
 arch/x86/kvm/vmx/vmcs12.h | 43 ++++++++++++++++++++++++++++++---------
 2 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b8121f8f6d96..9a35953ede22 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1547,7 +1547,8 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 	for (i = 0; i < max_shadow_read_write_fields; i++) {
 		field = shadow_read_write_fields[i];
 		val = __vmcs_readl(field.encoding);
-		vmcs12_write_any(vmcs12, field.encoding, field.offset, val);
+		vmcs12_write_any(vmcs12, field.encoding, field.offset, val,
+				 vmx->nested.vmcs12_field_existence_bitmap);
 	}
 
 	vmcs_clear(shadow_vmcs);
@@ -1580,8 +1581,9 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 	for (q = 0; q < ARRAY_SIZE(fields); q++) {
 		for (i = 0; i < max_fields[q]; i++) {
 			field = fields[q][i];
-			val = vmcs12_read_any(vmcs12, field.encoding,
-					      field.offset);
+			vmcs12_read_any(vmcs12, field.encoding,
+					      field.offset, &val,
+					      vmx->nested.vmcs12_field_existence_bitmap);
 			__vmcs_writel(field.encoding, val);
 		}
 	}
@@ -5070,7 +5072,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct x86_exception e;
 	unsigned long field;
-	u64 value;
+	unsigned long value;
 	gva_t gva = 0;
 	short offset;
 	int len, r;
@@ -5098,7 +5100,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 
 	/* Read the field, zero-extended to a u64 value */
-	value = vmcs12_read_any(vmcs12, field, offset);
+	r = vmcs12_read_any(vmcs12, field, offset, &value,
+				vmx->nested.vmcs12_field_existence_bitmap);
+	if (r < 0)
+		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
 	/*
 	 * Now copy part of this value to register or memory, as requested.
@@ -5223,7 +5228,10 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	if (field >= GUEST_ES_AR_BYTES && field <= GUEST_TR_AR_BYTES)
 		value &= 0x1f0ff;
 
-	vmcs12_write_any(vmcs12, field, offset, value);
+	r = vmcs12_write_any(vmcs12, field, offset, value,
+			 vmx->nested.vmcs12_field_existence_bitmap);
+	if (r < 0)
+		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
 	/*
 	 * Do not track vmcs12 dirty-state if in guest-mode as we actually
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 5c39370dff3c..9ac3d6ac1b6b 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -413,31 +413,51 @@ static inline short vmcs_field_to_offset(unsigned long field)
 
 #undef ROL16
 
-static inline u64 vmcs12_read_any(struct vmcs12 *vmcs12, unsigned long field,
-				  u16 offset)
+static inline int vmcs12_read_any(struct vmcs12 *vmcs12, unsigned long field,
+				  u16 offset, unsigned long *value, unsigned long *bitmap)
 {
 	char *p = (char *)vmcs12 + offset;
 
+	if (unlikely(bitmap == NULL)) {
+		pr_err_once("vmcs12 read: NULL bitmap");
+		return -EINVAL;
+	}
+	if (!test_bit(offset / sizeof(u16), bitmap))
+		return -ENOENT;
+
 	switch (vmcs_field_width(field)) {
 	case VMCS_FIELD_WIDTH_NATURAL_WIDTH:
-		return *((natural_width *)p);
+		*value = *((natural_width *)p);
+		break;
 	case VMCS_FIELD_WIDTH_U16:
-		return *((u16 *)p);
+		*value = *((u16 *)p);
+		break;
 	case VMCS_FIELD_WIDTH_U32:
-		return *((u32 *)p);
+		*value = *((u32 *)p);
+		break;
 	case VMCS_FIELD_WIDTH_U64:
-		return *((u64 *)p);
+		*value = *((u64 *)p);
+		break;
 	default:
 		WARN_ON_ONCE(1);
-		return -1;
+		return -ENOENT;
 	}
+
+	return 0;
 }
 
-static inline void vmcs12_write_any(struct vmcs12 *vmcs12, unsigned long field,
-				    u16 offset, u64 field_value)
+static inline int vmcs12_write_any(struct vmcs12 *vmcs12, unsigned long field,
+				    u16 offset, u64 field_value, unsigned long *bitmap)
 {
 	char *p = (char *)vmcs12 + offset;
 
+	if (unlikely(bitmap == NULL)) {
+		pr_err_once("%s: NULL bitmap", __func__);
+		return -EINVAL;
+	}
+	if (!test_bit(offset / sizeof(u16), bitmap))
+		return -ENOENT;
+
 	switch (vmcs_field_width(field)) {
 	case VMCS_FIELD_WIDTH_U16:
 		*(u16 *)p = field_value;
@@ -453,8 +473,11 @@ static inline void vmcs12_write_any(struct vmcs12 *vmcs12, unsigned long field,
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		break;
+		return -ENOENT;
 	}
+
+	return 0;
 }
 
+
 #endif /* __KVM_X86_VMX_VMCS12_H */
-- 
2.27.0

