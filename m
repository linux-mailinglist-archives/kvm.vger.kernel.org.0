Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E38B3A769F
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfICV6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:58:19 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:44888 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbfICV6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:58:19 -0400
Received: by mail-qt1-f201.google.com with SMTP id x11so20493453qtm.11
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bN2YbEcyYMUiFznHgJcQvFVodagIFOKOSU42bIILepg=;
        b=pRl3qA4ZMjmFbFObq0gqUUl4J2eWLVoeFmgun4FSp3mOeCemDaiycinWuX3fRd0iLS
         Cqp5tUbz1GXemXeiCTEi+JE+PdCPCfmKN9y7Gl8/k+V+wlz4jel9ApRrdPsjeYKQyjF6
         RTnb/9j73EzUDcDFmVxgpER6Pxn3FkdHPpIvFHM4uATVjfu4395U1L3Zm9Tfghuz30/x
         lmU13o3qxG7FauMv5TgLfipNWNuqiUeW8BzCLLSEhMj8B6j1AYv/CEdiH3/rRpl404qw
         WXw7ungU8pMt3vDwvchxhN54PjK3i25ncgPpSm7X3cPAD0KUYJa10fsTAz5eHOAet6L5
         bYZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bN2YbEcyYMUiFznHgJcQvFVodagIFOKOSU42bIILepg=;
        b=RhVC7UQ2yKL4KsepjYFreBM0IauIfFg37+qeZR1gxJsNeFUsRhPf0iFu8KpKbwWx3T
         ran22Y3uXX8UJ2NfrRCMCpdYfYHFnpwC8+pTOmGEDs4Ni1JKfo1OepmSshuKJfDvM2vN
         w5VEGQoQlviuxaSt4Xn8ag+zdAc+/cW4SoSNGUDW0CUXeJC5C6SywPwBYDhCHvxW3c49
         BK1+8GIl/eb+kJFBAzKGbyT8Rk7HvM7y4U7JNJ+tpQpP7j/z3glaXDg831lnZd1GhhXY
         WH3k1EMh85kw75vOqG5Vmdqa/d0v/apOjIar7boLBGrvLCZPN13xJ0giGTJX57skobpd
         o9Kw==
X-Gm-Message-State: APjAAAVJW0Lb3gFrST7hp6AL1EJBTCYbHagdjHxFRL0Kid2Nh84ouWb2
        SSCEL1qXu39BNju7l7p373sAZDua02uKydXJ4jGgoJk5revw5ql5RCbbFSAaquRMftyXXSbFguy
        qxHGscvPxDsCNfDIFTodb/Y07eJuJuLZUHo4OVBfl3yivw/jzg4xf+9+Lew==
X-Google-Smtp-Source: APXvYqy+v161gVUZVluXDv4fXiJJtfgSAzr3L/+aD0m495I1evxelGTWrRAtTXi0neFkDQzQMS6kb9PLdWw=
X-Received: by 2002:a37:a544:: with SMTP id o65mr34522857qke.252.1567547898569;
 Tue, 03 Sep 2019 14:58:18 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:57:59 -0700
In-Reply-To: <20190903215801.183193-1-oupton@google.com>
Message-Id: <20190903215801.183193-7-oupton@google.com>
Mime-Version: 1.0
References: <20190903215801.183193-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v3 6/8] KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL vm
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
index 570a233e272b..5b0664bff23b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6417,6 +6417,27 @@ void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
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

