Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C71D2EB7F3
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 02:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbhAFB66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 20:58:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:44483 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbhAFB66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 20:58:58 -0500
IronPort-SDR: fRecX27ZV1aOFfh9UAMMNKJ5xCWqQP97rQrMsODCb7jXUe87zM8zY4SdiIQpScPQ730eNQc5Ew
 d6vGAu95yIIw==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="195755857"
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="195755857"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:58:17 -0800
IronPort-SDR: sRiPTHTxEV6hBx7lKqmF8hHlUHQO+AVfvDL6x/j4bLFQdEujsqFx9hcISfw1Q1vUB+6S70OL+5
 1MkAqrTSl9tQ==
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="421993656"
Received: from zhuoxuan-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.29.237])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 17:58:13 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        mattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, corbet@lwn.net,
        Andy Lutomirski <luto@amacapital.net>,
        Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH 23/23] KVM: x86: Add capability to grant VM access to privileged SGX attribute
Date:   Wed,  6 Jan 2021 14:58:04 +1300
Message-Id: <7e45bb147f99357ecc9bf2167bf4fa16e917a8b6.1609890536.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1609890536.git.kai.huang@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
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
index e00a66d72372..edd650e8a87d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6014,6 +6014,29 @@ KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR exit notifications which user space
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
index 99e5e6f1a1ae..b53ba5570ee5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -811,7 +811,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * expected to derive it from supported XCR0.
 		 */
 		entry->eax &= SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
-			      /* PROVISIONKEY | */ SGX_ATTR_EINITTOKENKEY |
+			      SGX_ATTR_PROVISIONKEY | SGX_ATTR_EINITTOKENKEY |
 			      SGX_ATTR_KSS;
 		entry->ebx &= 0;
 		break;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c195494da0ea..bfc44ca6b6ba 100644
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
@@ -3739,6 +3741,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_USER_SPACE_MSR:
 	case KVM_CAP_X86_MSR_FILTER:
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
+#ifdef CONFIG_X86_SGX_VIRTUALIZATION
+	case KVM_CAP_SGX_ATTRIBUTE:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_SYNC_REGS:
@@ -5270,6 +5275,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.user_space_msr_mask = cap->args[0];
 		r = 0;
 		break;
+#ifdef CONFIG_X86_SGX_VIRTUALIZATION
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
index ca41220b40b8..4053522ac191 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1053,6 +1053,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_X86_USER_SPACE_MSR 188
 #define KVM_CAP_X86_MSR_FILTER 189
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
+#define KVM_CAP_SGX_ATTRIBUTE 200
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.29.2

