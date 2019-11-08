Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F7BF3F89
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 06:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfKHFO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 00:14:59 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:54297 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfKHFO6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 00:14:58 -0500
Received: by mail-pl1-f202.google.com with SMTP id a11so3426899plp.21
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 21:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1ZDZaljAr+J9pCFCLmqq2EbZTKuXklrA+SPyJole690=;
        b=D3o1bVvJ6GIIeOFPdsKW46bYp3cNd7Xp5CRbRgvNYDrIMM4MvfGlmxXBghGjvewH12
         Jz3LNdw4r67xrjw/kVQX6DL1K/wNGZBvYfBLZaP1LGvtJ2TEDBItbmBYvhwBckgoEF+1
         BSqcUI2X48y8l5R/J4eAC8qDp350K3STss84mOzepFzjMt14VJTtsSdJPTjkDflHxMPY
         SrURzyFFJIEB4d2i64Z5EYq0e9bx48OoFy0rrawqyqJ/M7QrAAjXJ8Si4gSclswlZHrc
         iGjDkL1CPH9d/iprsIZoWN6A6mXVw6XYhVjdvlWtWizqjwHiuoRUzCY8WGXKcX0SUtmD
         C90A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1ZDZaljAr+J9pCFCLmqq2EbZTKuXklrA+SPyJole690=;
        b=CC8jjq1GqR1Tzwxp2zNT+CqUhNIzoq6LO96TnOPYc6Vpg/KGP+KQ1cOwqVkeXM2Xrw
         PLf1xE56wymfKdB7AY8qRilW4BaeGSa945N+lE+DKpYCHtLTlCvAc5pqMboazxzWGUUa
         kaj6efwbexQ4q79JvjFD8gTOhmrygiVIhJprFmVaZWd7VZee09yrODWTJwWD2VL3FCYf
         nKpKdQjMudxXxysB71lUpXpLtMhbDkjnNbvtxd2qP/vLGm0gQy78nfs56jfwWCUPLsyH
         JUC9Sn0YngYN+Y/mE6CdGS/lYsR5ndReag+WPMjaghRRuo/a8yrIA1s2R5s8mLrBUq+l
         22cg==
X-Gm-Message-State: APjAAAXD9Al9WMwbuXPVXZGaA5sTy4P38B0lJWj9MNhBekKWQfPulPPx
        L9QzPlR6/LPXIcND8I6sXAcl3JwQqQ8XW8FRwyuPjt/HOlkDKnFV5GXklraxltMnsLwSvwk1zgg
        Uthr3607Shlyri7lL73QTJx/L982IOrk4tcKIW7vsu0xpHxYQOuOzBBMVBuHOd9fSmxRJ
X-Google-Smtp-Source: APXvYqwOJZ44fodsxvEK74ybIB2A55WutrHeTLbg55HZaMaAWqRJoFD8s2+3ybMDQOWbN5m7oeM3PVXx+Zc/ySk7
X-Received: by 2002:a63:e148:: with SMTP id h8mr9119825pgk.297.1573190097241;
 Thu, 07 Nov 2019 21:14:57 -0800 (PST)
Date:   Thu,  7 Nov 2019 21:14:39 -0800
In-Reply-To: <20191108051439.185635-1-aaronlewis@google.com>
Message-Id: <20191108051439.185635-5-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191108051439.185635-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v4 4/4] KVM: nVMX: Add support for capturing highest
 observable L2 TSC
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The L1 hypervisor may include the IA32_TIME_STAMP_COUNTER MSR in the
vmcs12 MSR VM-exit MSR-store area as a way of determining the highest
TSC value that might have been observed by L2 prior to VM-exit. The
current implementation does not capture a very tight bound on this
value.  To tighten the bound, add the IA32_TIME_STAMP_COUNTER MSR to the
vmcs02 VM-exit MSR-store area whenever it appears in the vmcs12 VM-exit
MSR-store area.  When L0 processes the vmcs12 VM-exit MSR-store area
during the emulation of an L2->L1 VM-exit, special-case the
IA32_TIME_STAMP_COUNTER MSR, using the value stored in the vmcs02
VM-exit MSR-store area to derive the value to be stored in the vmcs12
VM-exit MSR-store area.

Reviewed-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/vmx/nested.c | 101 +++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.c    |   2 +-
 arch/x86/kvm/vmx/vmx.h    |   5 ++
 3 files changed, 101 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7b058d7b9fcc..2055f15cb007 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -929,6 +929,37 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	return i + 1;
 }
 
+static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
+					    u32 msr_index,
+					    u64 *data)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	/*
+	 * If the L0 hypervisor stored a more accurate value for the TSC that
+	 * does not include the time taken for emulation of the L2->L1
+	 * VM-exit in L0, use the more accurate value.
+	 */
+	if (msr_index == MSR_IA32_TSC) {
+		int index = vmx_find_msr_index(&vmx->msr_autostore.guest,
+					       MSR_IA32_TSC);
+
+		if (index >= 0) {
+			u64 val = vmx->msr_autostore.guest.val[index].value;
+
+			*data = kvm_read_l1_tsc(vcpu, val);
+			return true;
+		}
+	}
+
+	if (kvm_get_msr(vcpu, msr_index, data)) {
+		pr_debug_ratelimited("%s cannot read MSR (0x%x)\n", __func__,
+			msr_index);
+		return false;
+	}
+	return true;
+}
+
 static bool read_and_check_msr_entry(struct kvm_vcpu *vcpu, u64 gpa, int i,
 				     struct vmx_msr_entry *e)
 {
@@ -963,12 +994,9 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 		if (!read_and_check_msr_entry(vcpu, gpa, i, &e))
 			return -EINVAL;
 
-		if (kvm_get_msr(vcpu, e.index, &data)) {
-			pr_debug_ratelimited(
-				"%s cannot read MSR (%u, 0x%x)\n",
-				__func__, i, e.index);
+		if (!nested_vmx_get_vmexit_msr_value(vcpu, e.index, &data))
 			return -EINVAL;
-		}
+
 		if (kvm_vcpu_write_guest(vcpu,
 					 gpa + i * sizeof(e) +
 					     offsetof(struct vmx_msr_entry, value),
@@ -982,6 +1010,60 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	return 0;
 }
 
+static bool nested_msr_store_list_has_msr(struct kvm_vcpu *vcpu, u32 msr_index)
+{
+	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	u32 count = vmcs12->vm_exit_msr_store_count;
+	u64 gpa = vmcs12->vm_exit_msr_store_addr;
+	struct vmx_msr_entry e;
+	u32 i;
+
+	for (i = 0; i < count; i++) {
+		if (!read_and_check_msr_entry(vcpu, gpa, i, &e))
+			return false;
+
+		if (e.index == msr_index)
+			return true;
+	}
+	return false;
+}
+
+static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
+					   u32 msr_index)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vmx_msrs *autostore = &vmx->msr_autostore.guest;
+	bool in_vmcs12_store_list;
+	int msr_autostore_index;
+	bool in_autostore_list;
+	int last;
+
+	msr_autostore_index = vmx_find_msr_index(autostore, msr_index);
+	in_autostore_list = msr_autostore_index >= 0;
+	in_vmcs12_store_list = nested_msr_store_list_has_msr(vcpu, msr_index);
+
+	if (in_vmcs12_store_list && !in_autostore_list) {
+		if (autostore->nr == NR_LOADSTORE_MSRS) {
+			/*
+			 * Emulated VMEntry does not fail here.  Instead a less
+			 * accurate value will be returned by
+			 * nested_vmx_get_vmexit_msr_value() using kvm_get_msr()
+			 * instead of reading the value from the vmcs02 VMExit
+			 * MSR-store area.
+			 */
+			pr_warn_ratelimited(
+				"Not enough msr entries in msr_autostore.  Can't add msr %x\n",
+				msr_index);
+			return;
+		}
+		last = autostore->nr++;
+		autostore->val[last].index = msr_index;
+	} else if (!in_vmcs12_store_list && in_autostore_list) {
+		last = --autostore->nr;
+		autostore->val[msr_autostore_index] = autostore->val[last];
+	}
+}
+
 static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
 {
 	unsigned long invalid_mask;
@@ -2027,7 +2109,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 	 * addresses are constant (for vmcs02), the counts can change based
 	 * on L2's behavior, e.g. switching to/from long mode.
 	 */
-	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
+	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.guest.val));
 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
 	vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.guest.val));
 
@@ -2294,6 +2376,13 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_write64(EOI_EXIT_BITMAP3, vmcs12->eoi_exit_bitmap3);
 	}
 
+	/*
+	 * Make sure the msr_autostore list is up to date before we set the
+	 * count in the vmcs02.
+	 */
+	prepare_vmx_msr_autostore_list(&vmx->vcpu, MSR_IA32_TSC);
+
+	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.guest.nr);
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
 	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3fa836a5569a..a7fd70db0b1e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -835,7 +835,7 @@ static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 	vm_exit_controls_clearbit(vmx, exit);
 }
 
-static int vmx_find_msr_index(struct vmx_msrs *m, u32 msr)
+int vmx_find_msr_index(struct vmx_msrs *m, u32 msr)
 {
 	unsigned int i;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1dad8e5c8f86..673330e528e8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -230,6 +230,10 @@ struct vcpu_vmx {
 		struct vmx_msrs host;
 	} msr_autoload;
 
+	struct msr_autostore {
+		struct vmx_msrs guest;
+	} msr_autostore;
+
 	struct {
 		int vm86_active;
 		ulong save_rflags;
@@ -334,6 +338,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
-- 
2.24.0.432.g9d3f5f5b63-goog

