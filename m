Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5B4166E7
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 17:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfEGPgc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 11:36:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:51035 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEGPgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 11:36:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 08:36:31 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2019 08:36:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 1/7] KVM: nVMX: Intercept VMWRITEs to read-only shadow VMCS fields
Date:   Tue,  7 May 2019 08:36:23 -0700
Message-Id: <20190507153629.3681-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507153629.3681-1-sean.j.christopherson@intel.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allowing L1 to VMWRITE read-only fields is only beneficial in a double
nesting scenario, e.g. no sane VMM will VMWRITE VM_EXIT_REASON in normal
non-nested operation.  Intercepting RO fields means KVM doesn't need to
sync them from the shadow VMCS to vmcs12 when running L2.  The obvious
downside is that L1 will VM-Exit more often when running L3, but it's
likely safe to assume most folks would happily sacrifice a bit of L3
performance, which may not even be noticeable in the grande scheme, to
improve L2 performance across the board.

Not intercepting fields tagged read-only also allows for additional
optimizations, e.g. marking GUEST_{CS,SS}_AR_BYTES as SHADOW_FIELD_RO
since those fields are rarely written by a VMMs, but read frequently.

When utilizing a shadow VMCS with asymmetric R/W and R/O bitmaps, fields
that cause VM-Exit on VMWRITE but not VMREAD need to be propagated to
the shadow VMCS during VMWRITE emulation, otherwise a subsequence VMREAD
from L1 will consume a stale value.

Note, KVM currently utilizes asymmetric bitmaps when "VMWRITE any field"
is not exposed to L1, but only so that it can reject the VMWRITE, i.e.
propagating the VMWRITE to the shadow VMCS is a new requirement, not a
bug fix.

Eliminating the copying of RO fields reduces the latency of nested
VM-Entry (copy_shadow_to_vmcs12()) by ~100 cycles (plus 40-50 cycles
if/when the AR_BYTES fields are exposed RO).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 72 +++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 04b40a98f60b..1f7c4af70903 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1102,14 +1102,6 @@ static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
 	vmx->nested.msrs.misc_low = data;
 	vmx->nested.msrs.misc_high = data >> 32;
 
-	/*
-	 * If L1 has read-only VM-exit information fields, use the
-	 * less permissive vmx_vmwrite_bitmap to specify write
-	 * permissions for the shadow VMCS.
-	 */
-	if (enable_shadow_vmcs && !nested_cpu_has_vmwrite_any_field(&vmx->vcpu))
-		vmcs_write64(VMWRITE_BITMAP, __pa(vmx_vmwrite_bitmap));
-
 	return 0;
 }
 
@@ -1298,41 +1290,27 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
 }
 
 /*
- * Copy the writable VMCS shadow fields back to the VMCS12, in case
- * they have been modified by the L1 guest. Note that the "read-only"
- * VM-exit information fields are actually writable if the vCPU is
- * configured to support "VMWRITE to any supported field in the VMCS."
+ * Copy the writable VMCS shadow fields back to the VMCS12, in case they have
+ * been modified by the L1 guest.  Note, "writable" in this context means
+ * "writable by the guest", i.e. tagged SHADOW_FIELD_RW.  Note #2, the set of
+ * fields tagged SHADOW_FIELD_RO may or may not align with the "read-only"
+ * VM-exit information fields (which are actually writable if the vCPU is
+ * configured to support "VMWRITE to any supported field in the VMCS").
  */
 static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
 {
-	const u16 *fields[] = {
-		shadow_read_write_fields,
-		shadow_read_only_fields
-	};
-	const int max_fields[] = {
-		max_shadow_read_write_fields,
-		max_shadow_read_only_fields
-	};
-	int i, q;
-	unsigned long field;
-	u64 field_value;
 	struct vmcs *shadow_vmcs = vmx->vmcs01.shadow_vmcs;
+	struct vmcs12 *vmcs12 = get_vmcs12(&vmx->vcpu);
+	unsigned long field;
+	int i;
 
 	preempt_disable();
 
 	vmcs_load(shadow_vmcs);
 
-	for (q = 0; q < ARRAY_SIZE(fields); q++) {
-		for (i = 0; i < max_fields[q]; i++) {
-			field = fields[q][i];
-			field_value = __vmcs_readl(field);
-			vmcs12_write_any(get_vmcs12(&vmx->vcpu), field, field_value);
-		}
-		/*
-		 * Skip the VM-exit information fields if they are read-only.
-		 */
-		if (!nested_cpu_has_vmwrite_any_field(&vmx->vcpu))
-			break;
+	for (i = 0; i < max_shadow_read_write_fields; i++) {
+		field = shadow_read_write_fields[i];
+		vmcs12_write_any(vmcs12, field, __vmcs_readl(field));
 	}
 
 	vmcs_clear(shadow_vmcs);
@@ -4511,6 +4489,24 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 			 * path of prepare_vmcs02.
 			 */
 			break;
+
+#define SHADOW_FIELD_RO(x) case x:
+#include "vmcs_shadow_fields.h"
+			/*
+			 * L1 can read these fields without exiting, ensure the
+			 * shadow VMCS is up-to-date.
+			 */
+			if (enable_shadow_vmcs) {
+				preempt_disable();
+				vmcs_load(vmx->vmcs01.shadow_vmcs);
+
+				__vmcs_writel(field, field_value);
+
+				vmcs_clear(vmx->vmcs01.shadow_vmcs);
+				vmcs_load(vmx->loaded_vmcs->vmcs);
+				preempt_enable();
+			}
+			/* fall through */
 		default:
 			vmx->nested.dirty_vmcs12 = true;
 			break;
@@ -5456,14 +5452,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 void nested_vmx_vcpu_setup(void)
 {
 	if (enable_shadow_vmcs) {
-		/*
-		 * At vCPU creation, "VMWRITE to any supported field
-		 * in the VMCS" is supported, so use the more
-		 * permissive vmx_vmread_bitmap to specify both read
-		 * and write permissions for the shadow VMCS.
-		 */
 		vmcs_write64(VMREAD_BITMAP, __pa(vmx_vmread_bitmap));
-		vmcs_write64(VMWRITE_BITMAP, __pa(vmx_vmread_bitmap));
+		vmcs_write64(VMWRITE_BITMAP, __pa(vmx_vmwrite_bitmap));
 	}
 }
 
-- 
2.21.0

