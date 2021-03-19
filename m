Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B064E341682
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 08:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbhCSHYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 03:24:47 -0400
Received: from mga12.intel.com ([192.55.52.136]:44045 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234084AbhCSHYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 03:24:23 -0400
IronPort-SDR: njjPvbLzhTzzabwrUglnUTjhUDJDyIBxrMw8Qy4Z13px6WkwFlTPnCNNskpsKPLr7/x17hAEPs
 cfnXcqHfxJAA==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="169143728"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="169143728"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:24:22 -0700
IronPort-SDR: prE2Oa7fVq0e5RcmLyAOoPxbbsKkZubanbUe6H6DB4pIGEoaoCNdAoahPfe40LzDNLV00r3PqI
 x/hhrZAtf3tg==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413409947"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:24:18 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 20/25] KVM: VMX: Frame in ENCLS handler for SGX virtualization
Date:   Fri, 19 Mar 2021 20:23:44 +1300
Message-Id: <9736f5182eae12365cd6460f8e0ac012af79edbe.1616136308.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Introduce sgx.c and sgx.h, along with the framework for handling ENCLS
VM-Exits.  Add a bool, enable_sgx, that will eventually be wired up to a
module param to control whether or not SGX virtualization is enabled at
runtime.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/Makefile  |  2 ++
 arch/x86/kvm/vmx/sgx.c | 50 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/sgx.h | 15 +++++++++++++
 arch/x86/kvm/vmx/vmx.c |  9 +++++---
 4 files changed, 73 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/sgx.c
 create mode 100644 arch/x86/kvm/vmx/sgx.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 1b4766fe1de2..87f514c36eae 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -23,6 +23,8 @@ kvm-$(CONFIG_KVM_XEN)	+= xen.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
+kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
+
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
new file mode 100644
index 000000000000..f68adbe38750
--- /dev/null
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Copyright(c) 2021 Intel Corporation. */
+
+#include <asm/sgx.h>
+
+#include "cpuid.h"
+#include "kvm_cache_regs.h"
+#include "sgx.h"
+#include "vmx.h"
+#include "x86.h"
+
+bool __read_mostly enable_sgx;
+
+static inline bool encls_leaf_enabled_in_guest(struct kvm_vcpu *vcpu, u32 leaf)
+{
+	if (!enable_sgx || !guest_cpuid_has(vcpu, X86_FEATURE_SGX))
+		return false;
+
+	if (leaf >= ECREATE && leaf <= ETRACK)
+		return guest_cpuid_has(vcpu, X86_FEATURE_SGX1);
+
+	if (leaf >= EAUG && leaf <= EMODT)
+		return guest_cpuid_has(vcpu, X86_FEATURE_SGX2);
+
+	return false;
+}
+
+static inline bool sgx_enabled_in_guest_bios(struct kvm_vcpu *vcpu)
+{
+	const u64 bits = FEAT_CTL_SGX_ENABLED | FEAT_CTL_LOCKED;
+
+	return (to_vmx(vcpu)->msr_ia32_feature_control & bits) == bits;
+}
+
+int handle_encls(struct kvm_vcpu *vcpu)
+{
+	u32 leaf = (u32)vcpu->arch.regs[VCPU_REGS_RAX];
+
+	if (!encls_leaf_enabled_in_guest(vcpu, leaf)) {
+		kvm_queue_exception(vcpu, UD_VECTOR);
+	} else if (!sgx_enabled_in_guest_bios(vcpu)) {
+		kvm_inject_gp(vcpu, 0);
+	} else {
+		WARN(1, "KVM: unexpected exit on ENCLS[%u]", leaf);
+		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+		vcpu->run->hw.hardware_exit_reason = EXIT_REASON_ENCLS;
+		return 0;
+	}
+	return 1;
+}
diff --git a/arch/x86/kvm/vmx/sgx.h b/arch/x86/kvm/vmx/sgx.h
new file mode 100644
index 000000000000..6e17ecd4aca3
--- /dev/null
+++ b/arch/x86/kvm/vmx/sgx.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_SGX_H
+#define __KVM_X86_SGX_H
+
+#include <linux/kvm_host.h>
+
+#ifdef CONFIG_X86_SGX_KVM
+extern bool __read_mostly enable_sgx;
+
+int handle_encls(struct kvm_vcpu *vcpu);
+#else
+#define enable_sgx 0
+#endif
+
+#endif /* __KVM_X86_SGX_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9dd185a53a3e..ef668047a8f9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -57,6 +57,7 @@
 #include "mmu.h"
 #include "nested.h"
 #include "pmu.h"
+#include "sgx.h"
 #include "trace.h"
 #include "vmcs.h"
 #include "vmcs12.h"
@@ -5673,16 +5674,18 @@ static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+#ifndef CONFIG_X86_SGX_KVM
 static int handle_encls(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * SGX virtualization is not yet supported.  There is no software
-	 * enable bit for SGX, so we have to trap ENCLS and inject a #UD
-	 * to prevent the guest from executing ENCLS.
+	 * SGX virtualization is disabled.  There is no software enable bit for
+	 * SGX, so KVM intercepts all ENCLS leafs and injects a #UD to prevent
+	 * the guest from executing ENCLS (when SGX is supported by hardware).
 	 */
 	kvm_queue_exception(vcpu, UD_VECTOR);
 	return 1;
 }
+#endif /* CONFIG_X86_SGX_KVM */
 
 static int handle_bus_lock_vmexit(struct kvm_vcpu *vcpu)
 {
-- 
2.30.2

