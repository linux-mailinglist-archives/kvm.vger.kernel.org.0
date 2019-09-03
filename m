Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45632A763B
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfICVbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:31:19 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:38285 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbfICVbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:31:18 -0400
Received: by mail-pl1-f202.google.com with SMTP id x5so10547698pln.5
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Qo2Q4twlzjicoVWtI4rzleCox1kkRBmxThovol+rgP0=;
        b=IAVamdKoyQ3EjtNLOxK8OnFFJi0RA5CrezA1et1i0/Y+k1XVZUtRSc7yoQ46AK01R5
         8Oo0UasZgFuqFgpnNyROP9v1nrCe7q4e6XAzumyZB0fp76jvUqR68+bYUeRpmwY9vEI8
         ksSq48aUgoJPOgj7zTyO7umphBMuYnQLl4DpFob2E8Cpp1A/XBau0hBX7C67gJiEYe0T
         EuRaXXj8DsSDRtXKbfwLZSyTWO3ElDk23n0YPkXbD5uUk9rwU7ZWLFD6KcOydbXwlRVq
         300Jcqiv25fNjnXWzU/S0Z/C1qLoBWzallkOc4flIIsyzK7qcffSakac1sppa6JRBeVc
         eW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Qo2Q4twlzjicoVWtI4rzleCox1kkRBmxThovol+rgP0=;
        b=TplHYR1UMl8awybnbNCYjigNdWViJJkl7/IErgMyZYY/5RNy3Mxf0nyft2pmZyxgdO
         DtrsXby1qOnddfvwrss8lybdRdd8FK5MAlWFTs5OrYsGulhxLSZjkjU6UU2+eEPExf0s
         pme3H8Qdpup9i89dHrh1vLKSCXF50YW8lCEQjVjHtkQWGDO6LYrRzKqQlPzJXxHIKVMH
         aC8mIAhXwIryQMss9Atr+detJDTF2Xf5kHC5GJUXFNxGTP2lXDuCW4EFDvFeBjTR7eHu
         kXveYoDLioauuhM53kmx0qkOAwinJMPpDNH4yzQDN6DG3IGFnlf+JrSx2Aet9eysnS1P
         HI0g==
X-Gm-Message-State: APjAAAU78WMGoIWC1LwbZ4XqGaVsSLm4m5i5zonm1Ia9z8gTYc4J28a1
        0XhPVAMx+sG4jgOCTPk/XxDQ1cuKyg0AFJVkzFw2URjKXTmXFdKkC+IBukZ+U2xXRhCFE25GUvX
        aN2xp6gZVskhoXP2vk9SZc5/5I9M3VpWnCzBxyGWzi1D5j4AFamfE/+VWdg==
X-Google-Smtp-Source: APXvYqyrkaRPExttbGAODk/KL8Bk58Z+tkOXgFUOxMPCEX7OQKa36PHGhpsDDdRCHCGc2fUoLo+W3zwdY3c=
X-Received: by 2002:a63:d30c:: with SMTP id b12mr16417943pgg.235.1567546277767;
 Tue, 03 Sep 2019 14:31:17 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:30:42 -0700
In-Reply-To: <20190903213044.168494-1-oupton@google.com>
Message-Id: <20190903213044.168494-7-oupton@google.com>
Mime-Version: 1.0
References: <20190903213044.168494-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v2 6/8] KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL vm
 control if supported
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
Create a new helper to allow pmu_refresh() to update the VM-entry and
VM-exit controls to ensure PMU values are initialized when performing
the is_valid_msr() check.

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c |  3 +++
 arch/x86/kvm/vmx/vmx.c       | 21 +++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h       |  1 +
 3 files changed, 25 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 963766d631ad..2dc7be724321 100644
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

