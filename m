Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3220357652
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 22:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhDGUuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 16:50:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:47246 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231508AbhDGUun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 16:50:43 -0400
IronPort-SDR: VCIlbXH3ibqG3q2yB4O1j3ZzlbN6mmITIj+b+A5UAvWy1liNCsbgfilHCVk8EMOr7KhIBAhd/z
 RJlkCiUq1ivA==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="278660421"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="278660421"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 13:50:33 -0700
IronPort-SDR: 7C2TD1WJHGa4ABbt3uxljRe8/MJRmva1RTbDpwgFTBKf4QhlbOpI05Lo9ql2aI02Ow4P1ckqp/
 tsj1sRTJQ8ig==
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="415437507"
Received: from tkokeray-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.113.100])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 13:50:30 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        Andy Lutomirski <luto@amacapital.net>,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v4 11/11] KVM: x86: Add capability to grant VM access to privileged SGX attribute
Date:   Thu,  8 Apr 2021 08:49:35 +1200
Message-Id: <78179bb5dfde6cff7b1e4df8ead5b3674018079b.1617825858.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617825858.git.kai.huang@intel.com>
References: <cover.1617825858.git.kai.huang@intel.com>
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
index 38e327d4b479..ebb47e48d4f3 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6230,6 +6230,29 @@ KVM_RUN_BUS_LOCK flag is used to distinguish between them.
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
index d2da5abcf395..81139e076380 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -75,6 +75,7 @@
 #include <asm/tlbflush.h>
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
+#include <asm/sgx.h>
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -3759,6 +3760,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_USER_SPACE_MSR:
 	case KVM_CAP_X86_MSR_FILTER:
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
+#ifdef CONFIG_X86_SGX_KVM
+	case KVM_CAP_SGX_ATTRIBUTE:
+#endif
 		r = 1;
 		break;
 #ifdef CONFIG_KVM_XEN
@@ -5345,6 +5349,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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
index f6afee209620..7d8927e474f8 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1078,6 +1078,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DIRTY_LOG_RING 192
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
 #define KVM_CAP_PPC_DAWR1 194
+#define KVM_CAP_SGX_ATTRIBUTE 195
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.30.2

