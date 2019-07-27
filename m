Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42964776F2
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2019 07:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbfG0Fws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Jul 2019 01:52:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:40956 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728467AbfG0FwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Jul 2019 01:52:23 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jul 2019 22:52:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,313,1559545200"; 
   d="scan'208";a="254568642"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 26 Jul 2019 22:52:16 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 21/21] KVM: x86: Add capability to grant VM access to privileged SGX attribute
Date:   Fri, 26 Jul 2019 22:52:14 -0700
Message-Id: <20190727055214.9282-22-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190727055214.9282-1-sean.j.christopherson@intel.com>
References: <20190727055214.9282-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SGX subsystem restricts access to a subset of enclave attributes to
provide additional security for an uncompromised kernel, e.g. to prevent
malware from using the PROVISIONKEY to ensure its nodes are running
inside a geniune SGX enclave and/or to obtain a stable fingerprint.

To prevent userspace from circumventing such restrictions by running an
enclave in a VM, KVM restricts guest access to privileged attributes by
default.  Add a capability, KVM_CAP_SGX_ATTRIBUTE, that can be used by
userspace to grant a VM access to a priveleged attribute, with args[0]
holding a file handle to a valid SGX attribute file corresponding to
an attribute that is restricted by KVM (currently only PROVISIONKEY).

Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 Documentation/virtual/kvm/api.txt | 20 ++++++++++++++++++++
 arch/x86/kvm/cpuid.c              |  2 +-
 arch/x86/kvm/x86.c                | 22 ++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  1 +
 4 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 383b292966fa..b1c0ff4e9224 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -5013,6 +5013,26 @@ it hard or impossible to use it correctly.  The availability of
 KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 signals that those bugs are fixed.
 Userspace should not try to use KVM_CAP_MANUAL_DIRTY_LOG_PROTECT.
 
+7.19 KVM_CAP_SGX_ATTRIBUTE
+
+Architectures: x86
+Parameters: args[0] is a file handle of a SGX attribute file in securityfs
+Returns: 0 on success, -EINVAL if the file handle is invalid or if a requested
+	 attribute is not supported by KVM.
+
+The SGX subsystem restricts access to a subset of enclave attributes, e.g. the
+PROVISIONKEY, to provide additional security for an uncompromised kernel, e.g.
+to prevent malware from using the PROVISIONKEY to ensure its nodes are running
+inside a geniune SGX enclave and/or to obtain a stable system fingerprint.
+
+To prevent userspace from circumventing such restrictions by running an enclave
+in a VM, KVM prevents access to privileged attributes by default.  Userspace
+can use KVM_CAP_SGX_ATTRIBUTE to grant a VM access to a priveleged attribute.
+args[0] must hold a file handle to a valid SGX attribute file corresponding to
+an attribute that is supported/restricted by KVM (currently only PROVISIONKEY).
+
+See Documentation/x86/sgx/2.Kernel-internals.rst for more details.
+
 8. Other capabilities.
 ----------------------
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 73a0326a1968..73af09edb2fa 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -439,7 +439,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	/* cpuid 12.1.eax*/
 	const u32 kvm_cpuid_12_1_eax_sgx_features =
-		SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | 0 /* PROVISIONKEY */ |
+		SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | SGX_ATTR_PROVISIONKEY |
 		SGX_ATTR_EINITTOKENKEY | SGX_ATTR_KSS;
 
 	/* cpuid 12.1.ebx*/
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ec92c5534336..9144909d4a8e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -67,6 +67,8 @@
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
 #include <asm/intel_pt.h>
+#include <asm/sgx.h>
+#include <asm/sgx_arch.h>
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -3090,6 +3092,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+#ifdef CONFIG_INTEL_SGX_VIRTUALIZATION
+	case KVM_CAP_SGX_ATTRIBUTE:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -4626,6 +4631,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+#ifdef CONFIG_INTEL_SGX_VIRTUALIZATION
+	case KVM_CAP_SGX_ATTRIBUTE: {
+		u64 allowed_attributes = 0;
+
+		r = sgx_set_attribute(&allowed_attributes, cap->args[0]);
+		if (r)
+			break;
+
+		/* KVM only supports the PROVISIONKEY privileged attribute. */
+		if ((allowed_attributes & SGX_ATTR_PROVISIONKEY) &&
+		    !(allowed_attributes & ~SGX_ATTR_PROVISIONKEY))
+			kvm->arch.sgx_provisioning_allowed = true;
+		else
+			r = -EINVAL;
+		break;
+	}
+#endif
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2fe12b40d503..b16708c2b6c9 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -993,6 +993,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_SVE 170
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
+#define KVM_CAP_SGX_ATTRIBUTE 200
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.22.0

