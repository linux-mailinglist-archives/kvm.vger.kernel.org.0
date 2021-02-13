Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95F531ABD2
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 14:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhBMNdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 13 Feb 2021 08:33:37 -0500
Received: from mga05.intel.com ([192.55.52.43]:55920 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229861AbhBMNcy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 13 Feb 2021 08:32:54 -0500
IronPort-SDR: bH/UfTBdE0OK3d4L47N7gBBFYMI/CAl98+zgv8zecLFvY3AcZefAjv6EgRQz6mzLQ7dYgVwU9U
 gk/MglycZPdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="267371909"
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="267371909"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:30:57 -0800
IronPort-SDR: od26tjulHm6ZJ8i0gMWcEmUMe0K3NnRwlus4FeK4hDJOpy3tOFgZaASjXbPJto1GDuVBfpLCRR
 lNwe/hjvPg0g==
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="398366310"
Received: from kshah-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.239])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:30:53 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, corbet@lwn.net,
        Andy Lutomirski <luto@amacapital.net>,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v5 26/26] KVM: x86: Add capability to grant VM access to privileged SGX attribute
Date:   Sun, 14 Feb 2021 02:30:45 +1300
Message-Id: <5cb830912bb6a641a3947a10743ff40d71b4e953.1613221549.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1613221549.git.kai.huang@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a capability, KVM_CAP_SGX_ATTRIBUTE, that can be used by userspace
to grant a VM access to a priveleged attribute, with args[0] holding a
file handle to a valid SGX attribute file.

The SGX subsystem restricts access to a subset of enclave attributes to
provide additional security for an uncompromised kernel, e.g. to prevent
malware from using the PROVISIONKEY to ensure its nodes are running
inside a geniune SGX enclave and/or to obtain a stable fingerprint.

To prevent userspace from circumventing such restrictions by running an
enclave in a VM, KVM restricts guest access to privileged attributes by
default.

Cc: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 Documentation/virt/kvm/api.rst | 23 +++++++++++++++++++++++
 arch/x86/kvm/cpuid.c           |  2 +-
 arch/x86/kvm/x86.c             | 22 ++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 4 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c136e254b496..47c7c7c33025 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6037,6 +6037,29 @@ KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR exit notifications which user space
 can then handle to implement model specific MSR handling and/or user notifications
 to inform a user that an MSR was not handled.
 
+7.22 KVM_CAP_SGX_ATTRIBUTE
+----------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] is a file handle of a SGX attribute file in securityfs
+:Returns: 0 on success, -EINVAL if the file handle is invalid or if a requested
+          attribute is not supported by KVM.
+
+KVM_CAP_SGX_ATTRIBUTE enables a userspace VMM to grant a VM access to one or
+more priveleged enclave attributes.  args[0] must hold a file handle to a valid
+SGX attribute file corresponding to an attribute that is supported/restricted
+by KVM (currently only PROVISIONKEY).
+
+The SGX subsystem restricts access to a subset of enclave attributes to provide
+additional security for an uncompromised kernel, e.g. use of the PROVISIONKEY
+is restricted to deter malware from using the PROVISIONKEY to obtain a stable
+system fingerprint.  To prevent userspace from circumventing such restrictions
+by running an enclave in a VM, KVM prevents access to privileged attributes by
+default.
+
+See Documentation/x86/sgx/2.Kernel-internals.rst for more details.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 04b2f5de2d7b..ad00a1af1545 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -833,7 +833,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * expected to derive it from supported XCR0.
 		 */
 		entry->eax &= SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
-			      /* PROVISIONKEY | */ SGX_ATTR_EINITTOKENKEY |
+			      SGX_ATTR_PROVISIONKEY | SGX_ATTR_EINITTOKENKEY |
 			      SGX_ATTR_KSS;
 		entry->ebx &= 0;
 		break;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5ca7b181a3ae..3d1b4113a57b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -74,6 +74,8 @@
 #include <asm/tlbflush.h>
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
+#include <asm/sgx.h>
+#include <asm/sgx_arch.h>
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -3767,6 +3769,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_USER_SPACE_MSR:
 	case KVM_CAP_X86_MSR_FILTER:
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
+#ifdef CONFIG_X86_SGX_KVM
+	case KVM_CAP_SGX_ATTRIBUTE:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -5295,6 +5300,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.user_space_msr_mask = cap->args[0];
 		r = 0;
 		break;
+#ifdef CONFIG_X86_SGX_KVM
+	case KVM_CAP_SGX_ATTRIBUTE: {
+		unsigned long allowed_attributes = 0;
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
index 374c67875cdb..e17bda18a9b4 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1058,6 +1058,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_SGX_ATTRIBUTE 200
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.29.2

