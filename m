Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE32C35B941
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhDLEW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:22:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:53386 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230042AbhDLEW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:22:28 -0400
IronPort-SDR: DriBa8tIauldpEtQMqDpLEhSeefJOhLNrbzk15n1nu1XiJ9ARJEL4rd+ai2M5PWOT6O3Ci86b9
 t/8wDcLNKwqg==
X-IronPort-AV: E=McAfee;i="6000,8403,9951"; a="258083778"
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="258083778"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:10 -0700
IronPort-SDR: M3NHue3jKKHFYr/rhZQrDHbw4n0iHnqpxClaizw5LxC0r1swKt4M8MBDly3XZe4jt11FRt4lfA
 e3s637u4imIQ==
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="521030406"
Received: from rutujajo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.194.203])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:07 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v5 06/11] KVM: VMX: Frame in ENCLS handler for SGX virtualization
Date:   Mon, 12 Apr 2021 16:21:38 +1200
Message-Id: <1c782269608b2f5e1034be450f375a8432fb705d.1618196135.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618196135.git.kai.huang@intel.com>
References: <cover.1618196135.git.kai.huang@intel.com>
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
v4->v5:
 - In handle_encls(), use kvm_rax_read() instead of explicit access to
   data structure.

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
index 000000000000..d874eb180b7d
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
+	u32 leaf = (u32)kvm_rax_read(vcpu);
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
index 09f2c9ec4468..d21036457c40 100644
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
@@ -5607,16 +5608,18 @@ static int handle_vmx_instruction(struct kvm_vcpu *vcpu)
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

