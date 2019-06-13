Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9134489B
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393554AbfFMRJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:09:33 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39756 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393285AbfFMRDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so18926861wrt.6;
        Thu, 13 Jun 2019 10:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tibVk00ck1sOgrGyADS0c5Fw3LAPQxfbwDP+CCSfgLE=;
        b=Cvslm3PvSwfB+9hcoV73uuN1/1dqmwAOO+XcddTDV6/N9BN6tCcHz5VpOuLMKrz90y
         r8vKy4tErpf3+hcQgrl8KgOr5AD2WYVs7xo+LDMp4q7rX0iQfY7sVLXG68do4E/qcWrb
         XNnHPbQ6I9LWZjm9EculSjN8fxrpqJKXD3ICUdzrhpmX0esLHUXum2ew2NX0ESaphjuf
         OHr92FZynLDCi+XPnluxWFM6crp6HkB3qPId1p7QMshpwa7yV7TAc8wR/emImK/ndcLU
         OJPvgh2eDCAmVGhMUi52CcVcHHT/Xbuykm2WJh3H1qGnj9B+oltjyg9yi982VAA7psEq
         5prQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=tibVk00ck1sOgrGyADS0c5Fw3LAPQxfbwDP+CCSfgLE=;
        b=tYxEfH1FeRzokHd6aJMNx/aPBHiuBURnz54r6V08axSWN4avMULg3iyH7YbMvIhuR2
         QlJ1EJOI3+0GPTGRbISTKTNNaW/LJUhUGaojIG2+X8lxheVVG3GAPh5iGDvoZymAP+9M
         isaf7nnoaLJoLNa92p5axH6jSysQLibLtaBK9dESfecqs6CnkUv+BYaRNeXgTFCDPcMD
         TCFhgyxNs1zFE0HLAzaBtCHz8p38XDO0o8nenavQY/ZxSMJN8wNCAyWloD9wDpnkn7of
         M8t+UeFluHeOpwqKPgGrVyQ/lnRgL9C2ZHNo6cxqrh1xetqDOfcDkItWEs315yhAseM9
         cVIA==
X-Gm-Message-State: APjAAAXJyK4gS6Wc1YEOHG4d3jJkqp5MaDwmgqvlCcgwRRPjYwXk2EkE
        GB9WJtrxq/IkAvfr58QTCzvasTqg
X-Google-Smtp-Source: APXvYqwQ6N9NirCxtWCIyUOL7IrRxHH+i9ANmE7Ya5pxLZ8BluwDHuIgZEt8fs5i4lDe1ka+fEgCBQ==
X-Received: by 2002:a05:6000:128f:: with SMTP id f15mr7053585wrx.196.1560445417594;
        Thu, 13 Jun 2019 10:03:37 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:36 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 07/43] KVM: nVMX: Intercept VMWRITEs to read-only shadow VMCS fields
Date:   Thu, 13 Jun 2019 19:02:53 +0200
Message-Id: <1560445409-17363-8-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 72 ++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 41 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c92349e2f621..0dc9505ae9a2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1105,14 +1105,6 @@ static int vmx_restore_vmx_misc(struct vcpu_vmx *vmx, u64 data)
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
 
@@ -1301,41 +1293,27 @@ int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
 }
 
 /*
- * Copy the writable VMCS shadow fields back to the VMCS12, in case
- * they have been modified by the L1 guest. Note that the "read-only"
- * VM-exit information fields are actually writable if the vCPU is
- * configured to support "VMWRITE to any supported field in the VMCS."
+ * Copy the writable VMCS shadow fields back to the VMCS12, in case they have
+ * been modified by the L1 guest.  Note, "writable" in this context means
+ * "writable by the guest", i.e. tagged SHADOW_FIELD_RW; the set of
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
@@ -4517,6 +4495,24 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
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
@@ -5470,14 +5466,8 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
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
1.8.3.1


