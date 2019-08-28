Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2CCA0E5A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 01:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfH1Xlz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 19:41:55 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:45182 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbfH1Xly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 19:41:54 -0400
Received: by mail-pg1-f202.google.com with SMTP id 141so827334pgh.12
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 16:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=nZSQMYezfrL5l3vMPN8DFnMV2sGzJgt28y/hqUYR/9g=;
        b=Wf0p0k7QUTC/9p52jy3FZkw4XYI39Sed1HtxKXPF2I59p03qGDXujR4hrpWyXWOkNI
         vUYeyGtt1P7h87ciV11cWJ67yi+adduGAAmM0fEh7CDNLlDv846jn8kRIX8WckRk7icn
         nHVY0GjU58QuxVqbczKpv9JR0SPVKgfqWpsI3sqQCuKP+oAzh36RdvT5dVAQYB1MbSbY
         rjwCAlw3UcntN7gR2n3LmhH7l3uJBIyyoFWynzHB50DcpsA52LxakIr1yPNnsgyFahRP
         B/OihLIY1d46yEQvS04PALg32fDAEi8F4o+KerQZFnUBy1vfHR9XnJ8swAN4y9eRcOGX
         sBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=nZSQMYezfrL5l3vMPN8DFnMV2sGzJgt28y/hqUYR/9g=;
        b=T4RRGx6JTl5h4jF7aFlmfHMysKRPIPWQ+Y0puJ1YXSPaID2OrFWAVNxHnPlY4kTu9X
         OG6VhISMBCwCBEFog3dKKmFVEvc3wvolwUevkce9nQ3o6HvnRM34VfhXfY7EEQNvEpBL
         WTwKiFA+gXDEt1EX6rHRACeikmgrxqXm0/fpxF0SCRJnpJ2yVI5n7Jvk+fGgE9T2erPZ
         79GXEZtxRxF/ELfLQbaBTYdwx80w9r1ZAYNofU43mN2XMDjUJATXGIv7jQkq863JzZxN
         rCNQ1SZ+xsgTXFrq20aTQ32VOF5LYO0NnWjK1RZXn7hj+tw2hRvenr3qB2PzGELUN93T
         dUXw==
X-Gm-Message-State: APjAAAWWG7rSbHsrfhnZKF5uWx8fMwGmvElTdp+vxH6O7/eO3AdhPiBa
        tCzUaH1BS1bH/MoX+zyorNXbge1JfF3P47/XU5Cu5hXjJHNon8oD9l8zNONzWk7+OSEX/Cq3UoF
        tmJOKALk8rq2V7bTdNxMUTcNoK75cL3VKWh9CLYBIH/0wSmCxAz6MTta+UQ==
X-Google-Smtp-Source: APXvYqzEqmYDNMjGKjhsZM4ZivkkHeF5cylmxge7zPVl/xcup95CfxknvN5ww0tvDwaYJnuu0ShmUDMRd1w=
X-Received: by 2002:a65:64ce:: with SMTP id t14mr5614869pgv.137.1567035713217;
 Wed, 28 Aug 2019 16:41:53 -0700 (PDT)
Date:   Wed, 28 Aug 2019 16:41:33 -0700
In-Reply-To: <20190828234134.132704-1-oupton@google.com>
Message-Id: <20190828234134.132704-7-oupton@google.com>
Mime-Version: 1.0
References: <20190828234134.132704-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH 6/7] KVM: nVMX: Enable load IA32_PERF_GLOBAL_CTRL vm control
 if supported
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "load IA32_PERF_GLOBAL_CTRL" high bit for VM-entry and VM-exit should only
be set and made available to the guest iff IA32_PERF_GLOBAL_CTRL is a valid
MSR. Otherwise, the high bit should be cleared.

Creating a new helper function in vmx.c to allow the pmu_refresh code to
update the VM-entry and VM-exit controls. This was done instead of
adding to 'nested_vmx_entry_exit_ctls_update' as the PMU isn't yet
initialized with its values at the time it is called, causing the
'is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)' check to fail
unconditionally.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c |  3 +++
 arch/x86/kvm/vmx/vmx.c       | 21 +++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  1 +
 3 files changed, 25 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4dea0e0e7e39..6d42d9b41ddc 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -16,6 +16,7 @@
 #include "cpuid.h"
 #include "lapic.h"
 #include "pmu.h"
+#include "vmx.h"
 
 static struct kvm_event_hw_type_mapping intel_arch_events[] = {
 	/* Index must match CPUID 0x0A.EBX bit vector */
@@ -314,6 +315,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
 	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
 		pmu->reserved_bits ^= HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;
+
+	nested_vmx_pmu_entry_exit_ctls_update(vcpu);
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42ed3faa6af8..2cad761c913c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6407,6 +6407,27 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 	}
 }
 
+void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx;
+
+	if (!nested_vmx_allowed(vcpu))
+		return;
+
+	vmx = to_vmx(vcpu);
+	if (intel_pmu_ops.is_valid_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL)) {
+		vmx->nested.msrs.entry_ctls_high |=
+				VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high |=
+				VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+	} else {
+		vmx->nested.msrs.entry_ctls_high &=
+				~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
+		vmx->nested.msrs.exit_ctls_high &=
+				~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
+	}
+}
+
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 82d0bc3a4d52..e06884cf88ad 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -331,6 +331,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
 
 #define POSTED_INTR_ON  0
 #define POSTED_INTR_SN  1
-- 
2.23.0.187.g17f5b7556c-goog

