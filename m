Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F73031ABCF
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 14:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhBMNdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Feb 2021 08:33:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:30418 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229651AbhBMNcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Feb 2021 08:32:15 -0500
IronPort-SDR: DDx0Iey94J70lZIU6j3hq01YIYwnkVvbFFKWfHAACLyCA6OQg3N76idX8yeHPV8S2NT2TzmOMI
 oJWpLp1iEMXg==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="201682468"
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="201682468"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:30:29 -0800
IronPort-SDR: YKETXvXyKixJ8iadKQqr+6l5+At0Ru1UHLwc21pTwOFHEbMdvuZ72ZG7A+Qju/DVDY8agqlGIV
 chXLtddyHrGg==
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="398366216"
Received: from kshah-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.239])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:30:25 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v5 21/26] KVM: VMX: Frame in ENCLS handler for SGX virtualization
Date:   Sun, 14 Feb 2021 02:29:49 +1300
Message-Id: <e60259a5bab930829cdecc7628c5bd983657c9c4.1613221549.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1613221549.git.kai.huang@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
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
 arch/x86/kvm/vmx/sgx.c | 51 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/sgx.h | 15 +++++++++++++
 arch/x86/kvm/vmx/vmx.c |  9 +++++---
 4 files changed, 74 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/sgx.c
 create mode 100644 arch/x86/kvm/vmx/sgx.h

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 4bd14ab01323..5c86edc73b72 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -21,6 +21,8 @@ kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
+kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
+
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o svm/sev.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
new file mode 100644
index 000000000000..6b3d614d288c
--- /dev/null
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Copyright(c) 2021 Intel Corporation. */
+
+#include <asm/sgx.h>
+#include <asm/sgx_arch.h>
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
index 4cb8a3f1374c..dbe585329842 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -56,6 +56,7 @@
 #include "mmu.h"
 #include "nested.h"
 #include "pmu.h"
+#include "sgx.h"
 #include "trace.h"
 #include "vmcs.h"
 #include "vmcs12.h"
@@ -5623,16 +5624,18 @@ static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
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
 
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
-- 
2.29.2

