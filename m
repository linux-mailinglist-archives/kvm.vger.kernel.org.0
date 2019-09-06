Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5466BAC1D1
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390242AbfIFVDg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:03:36 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:43365 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389873AbfIFVDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:03:36 -0400
Received: by mail-pl1-f201.google.com with SMTP id y6so4232117plt.10
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 14:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rCyhoUdaGrgN67UpXBGLGCttQlRMLbm+Q6DEjZauY84=;
        b=hhESJAZvy2HG7/31mOJLJuvF+Ps6wzjzmmeuX3qtBzFGL8q2UA1Z8PWr8kNg2yFmSC
         8JxY/Z77JU2EbIRPiBK/YrPX91nwrczc6E5MgX+LjRhFiRomLXHhJ3j11ctH2+XBfsSV
         PWig60VXsO4NCBG2soNeUYVKydwtA1sgG5I/lAOft1MoVt5E6wlerflIe4B8ylvvoPHq
         Kyx9BoR5JPcZQXhOPdZhQkB7+Sx/sbWEWd8bORtEeYZC6OSXcuWw7yjigzepz2ijTYxY
         6nEF3xCxp949vyHcDR3XzcLnCpedb+uQkR17L8pUx5isVyFyMK5EiJ4nscDa4CU1NVBm
         Vw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rCyhoUdaGrgN67UpXBGLGCttQlRMLbm+Q6DEjZauY84=;
        b=emu6nq0XDfP33gPRspik7S9v5O/2dbUxJIgiL63+5qX4AiBwT079ng1VbWswQM9Xfv
         LaS7UmacpxD1bQpgXEhM9JuUBvt3Nod+rjmgH9QJuwJQ9RZXyWrq7guu23jhMd1nOPUG
         ykHvi0fFlVvzZl7SWkCaFQnD/aa/WNRdQi11ZDyvAsbavVQBS0b6sqqqhRwdFbfz2T8U
         WWknQ2JevSdgwZz38XVOMhbduUCHoYWGF1cTn5yWrlvMjl4WhAqm7/beCJDBIXGBRwZ+
         FVefLmiPWWifRfoyeRUMz53iFiERq6qP1thcCiBBth3GP3I9ngqEQ0caODuEqxX7urFS
         lsZg==
X-Gm-Message-State: APjAAAW7loop4FkcF7IL3J31bz9hDrc/AKM7RrS1LDsXz9jiEkcCOOHb
        wvjLpXnjJYgxeAZBpUlmzP3xXxiIXv3aqKqXRQCO496KAG9Oy0do0Xh5lY6ps2OWvbPf31NHLkW
        l3BNUQQMGO1hX18VfcObJoh6qFRkOfAu+6cf4pEHoOjFNLwpCF/6Ic3fdYg==
X-Google-Smtp-Source: APXvYqxBq39FP9hTwCe1ZG+9e4AU8CuDz+HMenwLIQ0RgG+MBLBYB583zs0OhmyElHLn19ewUTSLWGthJNw=
X-Received: by 2002:a65:6108:: with SMTP id z8mr9630680pgu.289.1567803814582;
 Fri, 06 Sep 2019 14:03:34 -0700 (PDT)
Date:   Fri,  6 Sep 2019 14:03:10 -0700
In-Reply-To: <20190906210313.128316-1-oupton@google.com>
Message-Id: <20190906210313.128316-7-oupton@google.com>
Mime-Version: 1.0
References: <20190906210313.128316-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v4 6/9] KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL vm
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
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
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

