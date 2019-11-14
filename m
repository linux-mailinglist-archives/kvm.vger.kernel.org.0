Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B33FBCF0
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 01:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKNARq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 19:17:46 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:41252 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfKNARp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 19:17:45 -0500
Received: by mail-pg1-f202.google.com with SMTP id e6so3141398pgc.8
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 16:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zesQxPiIvkAtnrmp9oG7z8sqiluhfRLnvHi8XcnkD4Q=;
        b=Hv1l8biwHccbTHqpCRNtUhFEp4Uhhc4aGSZq0c0q/q7iD1J/PAFcCIl9lJSWUrwRAz
         Zu3Kl01wp4mKRbLkQohsf73XFCkP/6rOFp/lFPzkj3rHQpi583Rn6dm0K9AJsgxCW7t8
         Bxh5x9VbVrQa8uNhdwujG/QPKpb8YjQnVDfkUVYnvPGuPwK3+/hYj+YQZ9e/awkPvgPi
         +T90Mih21rY8mNNfLYwpfKN3ZUuBwB0q4KFn/pCRyuMfcQ6mbfSSVTxcaCk/huAzXKEJ
         k3Icut3Zi25RQwwygK8/43ux1cAycIosUq2kB0oguTXFzNS56mLvG/msbWNtyZCZdBjJ
         Wgyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zesQxPiIvkAtnrmp9oG7z8sqiluhfRLnvHi8XcnkD4Q=;
        b=RZyOYnvG6AYEJev81NONLrGrZ64vO7ds+QjZR7tiPF5vAmvyarZw/ESZEXzNX/aYqX
         19FiV207cP44HeYFJGdS7jIxyHz0ANj5L/ZrUVqpHu4fDre/fRxsVl+jEUgWZPkCoFYj
         LYTmT2XjNC0q5V71uM7U5onITojN0dPQL0Lwjdz8LGIjo08v/qH3FMXV4ffUMlCeOXhZ
         LhVCH3pY+bz55FEeb7U17p480Zm02bwVFqcF7Uir5Sx2z/u4GnrUBUfdjmpH4hO0E/Ig
         3V5+5EVRQ94v54cmyzhgmB+e+0YBpqZjn1ReMfLqM0UXoGNrq8gXUHAe5g3mqXSd0Exj
         l7iQ==
X-Gm-Message-State: APjAAAXYOEb/67A5x3e0oghWsOUdWeIB+q+S9LdFN6o8JT0mIts6HttE
        jWazzNCmpb3h+EFcwz+ED4sKij1dVo/IQyBo7ENmMGlehyukiaxcXTx4oER+bfQJTN/1+HOuPlc
        R/1KXRfBKZtaVRespdfVqiWvoMJF3eW5BwVet+/oIhjPSwKz+Nza7+xXn+w==
X-Google-Smtp-Source: APXvYqwf/Z3Y1DBQUqLFRy5d2N3nIi8cUfY1a4zGPnpefN/nZ/BiP6RS1a1Ss+4+ps2ULvo6p7rx7P+eHuo=
X-Received: by 2002:a65:68d7:: with SMTP id k23mr6723623pgt.157.1573690665032;
 Wed, 13 Nov 2019 16:17:45 -0800 (PST)
Date:   Wed, 13 Nov 2019 16:17:20 -0800
In-Reply-To: <20191114001722.173836-1-oupton@google.com>
Message-Id: <20191114001722.173836-7-oupton@google.com>
Mime-Version: 1.0
References: <20191114001722.173836-1-oupton@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 6/8] KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL
 VM-{Entry,Exit} control
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "load IA32_PERF_GLOBAL_CTRL" bit for VM-entry and VM-exit should
only be exposed to the guest if IA32_PERF_GLOBAL_CTRL is a valid MSR.
Create a new helper to allow pmu_refresh() to update the VM-Entry and
VM-Exit controls to ensure PMU values are initialized when performing
the is_valid_msr() check.

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/vmx/nested.c    | 21 +++++++++++++++++++++
 arch/x86/kvm/vmx/nested.h    |  1 +
 arch/x86/kvm/vmx/pmu_intel.c |  3 +++
 3 files changed, 25 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 64e15c6f6944..cc5297d3310f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4345,6 +4345,27 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 	return 0;
 }
 
+void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx;
+
+	if (!nested_vmx_allowed(vcpu))
+		return;
+
+	vmx = to_vmx(vcpu);
+	if (kvm_x86_ops->pmu_ops->is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
+		vmx->nested.msrs.entry_ctls_high |=
+				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high |=
+				VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+	} else {
+		vmx->nested.msrs.entry_ctls_high &=
+				~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high &=
+				~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+	}
+}
+
 static int nested_vmx_get_vmptr(struct kvm_vcpu *vcpu, gpa_t *vmpointer)
 {
 	gva_t gva;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 187d39bf0bf1..440bc08e0a2f 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -22,6 +22,7 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
+void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
 
 static inline struct vmcs12 *get_vmcs12(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8cd2cc2fe986..b7b2fcdf97ff 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -15,6 +15,7 @@
 #include "x86.h"
 #include "cpuid.h"
 #include "lapic.h"
+#include "nested.h"
 #include "pmu.h"
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
@@ -317,6 +318,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
 	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
 		pmu->reserved_bits ^= HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;
+
+	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

