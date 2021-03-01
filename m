Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED266327B2E
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 10:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbhCAJv3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 04:51:29 -0500
Received: from mga18.intel.com ([134.134.136.126]:59926 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234199AbhCAJrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 04:47:49 -0500
IronPort-SDR: SDKwnPutDlwjglIO2ANjIS/m7wP7dwSQq5kYHbem5e0kKF/B1n8F+vm90l0191RoHbhsb9j4aD
 4UbmI4YHlCtQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9909"; a="174046944"
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="174046944"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:47:09 -0800
IronPort-SDR: ElVnjXrfiGi/YdX4+8c1ETl9CYNvr7zSW7sxAafA3qGMN2t85CfK4e5t29IB981SScCml//ckZ
 qhJWQFz0b7Rw==
X-IronPort-AV: E=Sophos;i="5.81,215,1610438400"; 
   d="scan'208";a="599267771"
Received: from jscomeax-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.139.76])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 01:47:03 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, corbet@lwn.net,
        Andy Lutomirski <luto@amacapital.net>,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH 25/25] KVM: x86: Add capability to grant VM access to privileged SGX attribute
Date:   Mon,  1 Mar 2021 22:46:56 +1300
Message-Id: <e444a20d3a30195ea62a36caf1371ae4dc268b21.1614590788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1614590788.git.kai.huang@intel.com>
References: <cover.1614590788.git.kai.huang@intel.com>
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
 arch/x86/kvm/x86.c             | 21 +++++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 4 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index aed52b0fc16e..d65016a05a8b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6227,6 +6227,29 @@ KVM_RUN_BUS_LOCK flag is used to distinguish between them.
 This capability can be used to check / enable 2nd DAWR feature provided
 by POWER10 processor.
 
+7.24 KVM_CAP_SGX_ATTRIBUTE
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
index a0d45607b702..6dc12d949f86 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -849,7 +849,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * expected to derive it from supported XCR0.
 		 */
 		entry->eax &= SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
-			      /* PROVISIONKEY | */ SGX_ATTR_EINITTOKENKEY |
+			      SGX_ATTR_PROVISIONKEY | SGX_ATTR_EINITTOKENKEY |
 			      SGX_ATTR_KSS;
 		entry->ebx &= 0;
 		break;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a4a514523c45..0f9d9ace2b66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -75,6 +75,7 @@
 #include <asm/tlbflush.h>
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
+#include <asm/sgx.h>
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -3754,6 +3755,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_USER_SPACE_MSR:
 	case KVM_CAP_X86_MSR_FILTER:
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
+#ifdef CONFIG_X86_SGX_KVM
+	case KVM_CAP_SGX_ATTRIBUTE:
+#endif
 		r = 1;
 		break;
 	case KVM_CAP_XEN_HVM:
@@ -5330,6 +5334,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			kvm->arch.bus_lock_detection_enabled = true;
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
index 8b281f722e5b..df37fcf41a74 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1078,6 +1078,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
 #define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_SGX_ATTRIBUTE 195
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.29.2

