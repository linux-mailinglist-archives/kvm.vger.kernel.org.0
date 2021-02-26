Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE254326290
	for <lists+kvm@lfdr.de>; Fri, 26 Feb 2021 13:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhBZMSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Feb 2021 07:18:01 -0500
Received: from mga03.intel.com ([134.134.136.65]:51463 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229953AbhBZMQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Feb 2021 07:16:58 -0500
IronPort-SDR: Ke/f65ibRwHFFNozdXQC1MdKDFNHKbxSJLRbItgxPH9t5zfITJtY0Ha3JwjkDIJz8lPd0wTB4l
 uCl48VdG/Sqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9906"; a="185913219"
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="185913219"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:16:26 -0800
IronPort-SDR: BSwcoBg3vdyxckENrSUISirMcAELcKydtX4itStQFZ9x085fdvKhjnkN9m7Vt9q8lTE+SYxZMe
 FNtEg3zhAr3Q==
X-IronPort-AV: E=Sophos;i="5.81,208,1610438400"; 
   d="scan'208";a="598420721"
Received: from ciparjol-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.175])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2021 04:16:22 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v6 20/25] KVM: VMX: Frame in ENCLS handler for SGX virtualization
Date:   Sat, 27 Feb 2021 01:15:47 +1300
Message-Id: <fc3ca34bd93f16a5f56519c59d8400c3ff40313b.1614338774.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614338774.git.kai.huang@intel.com>
References: <cover.1614338774.git.kai.huang@intel.com>
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
index aeab168c5711..64c5e7655daf 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -22,6 +22,8 @@ kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 
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
index 68c6731cabe6..c55c19d17c61 100644
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
@@ -5610,16 +5611,18 @@ static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
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
2.29.2

