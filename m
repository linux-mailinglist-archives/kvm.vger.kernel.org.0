Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57545F3BBD
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 23:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbfKGWuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 17:50:03 -0500
Received: from mail-vs1-f73.google.com ([209.85.217.73]:45170 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbfKGWuC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 17:50:02 -0500
Received: by mail-vs1-f73.google.com with SMTP id k6so1119257vsq.12
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2019 14:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YtBMF5qYIpUO2FuGmNquYzDsUQ1AdPczALfiEukGBvg=;
        b=fTQqN19xv9fMGnxv/rxUD0zSZrNfP5ToFyVF35lgBORzVJnmP2L222ETiZzhejx2x8
         n+Kah3BzbunS5IzyXPIIkqDo3RpTJ6lPJrY9a8524ZbxxWpnU2NeZHgSSFao2yZAHwZf
         5msdmCd5wzhkzrPLSyrQYDx5Q3dNt7GEleImDT0Z9BHcX6zGFtAvH3YTVwUQ22D2dEck
         8mOn3GsLwiFJ6rjnp3mu/OjwUUoeVq18MQAUUu6vkltiLN4huzy3VrOo8hC/uAZZEGA0
         HHNE5xqM4yyED5iWZKwmrsP978/Xmj6phY3/o6KyL6gw37/H4huLKZry2uWS2pRmIgWt
         /Bjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YtBMF5qYIpUO2FuGmNquYzDsUQ1AdPczALfiEukGBvg=;
        b=iuMuWo1upF08dYB6/rAAwoKeAjY4jFhkFrQcweaCdd9Px3hqCzV6MfZ0MSMFABUDY6
         Ttpx8L1RiJSev7cNeL+nrKCOQiSkfODWw3y/Pkg19m+ANcaHNBBeqMXL3+qxz6Tx/pMm
         9Tuh8CzYWBzcimvsYYWd6yw3RHXjQlbX3PmZudvxV3VnyPS0CX2tyavl6ncK7PxSLCUg
         EPX2sXUlFV48kKQPndWy6bkNsc/6OT0Z093w4UhLX6lDnpkIR5pOx79JpJjlKy0imO0f
         PPgnMGjEw0ZwpZO0rF36SHlDxiTKVwgVHrXNIYvSrsR9za5gcAggfg/YPTgd4j5/fKmu
         eFsQ==
X-Gm-Message-State: APjAAAXC4yPlMXiTt/QsKy2Hjhz/oVEU58Ons7ygFTHyInAEI7lr8Bgy
        IRxIgHluVOPN2woF/Jl/j7rv74jUBXDxfxMZjiI9zQmVHyt6VC8X+OOXGTgTFbp2IrZj+QxUpoJ
        uE7WGkVFNbTyn4l//gsQNzkwcD0WMcD2CjM7+poDk054Dn8fClR5rv0I2CGNtysNIObMj
X-Google-Smtp-Source: APXvYqxqikDI9lOKbMx/FSramKqt6h/hzpGRBiK0yd1SVQGV86oapxi3jd7OAat6yI4t4S/LAuh3YDwYj7LHCqYb
X-Received: by 2002:a05:6122:11af:: with SMTP id y15mr4756877vkn.68.1573167001652;
 Thu, 07 Nov 2019 14:50:01 -0800 (PST)
Date:   Thu,  7 Nov 2019 14:49:41 -0800
In-Reply-To: <20191107224941.60336-1-aaronlewis@google.com>
Message-Id: <20191107224941.60336-6-aaronlewis@google.com>
Mime-Version: 1.0
References: <20191107224941.60336-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v3 5/5] KVM: nVMX: Add support for capturing highest
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
 arch/x86/kvm/vmx/nested.c | 88 +++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c    |  2 +-
 arch/x86/kvm/vmx/vmx.h    |  1 +
 3 files changed, 83 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c249be43fff2..2055f15cb007 100644
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
@@ -982,12 +1010,58 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 	return 0;
 }
 
-static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu)
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
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmx_msrs *autostore = &vmx->msr_autostore.guest;
+	bool in_vmcs12_store_list;
+	int msr_autostore_index;
+	bool in_autostore_list;
+	int last;
 
-	autostore->nr = 0;
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
 }
 
 static bool nested_cr3_valid(struct kvm_vcpu *vcpu, unsigned long val)
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
index 2616f639cf50..673330e528e8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -338,6 +338,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
-- 
2.24.0.432.g9d3f5f5b63-goog

