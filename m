Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E7535B946
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhDLEXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:23:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:31690 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230208AbhDLEWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:22:52 -0400
IronPort-SDR: ywNlP/uf51VsM2+bq2s/L8Ic4lOU3pq6zGSrNXvKSRVm7DfsCX22FT12dd8mOGgpCOmzNznyeb
 LV9Kz2B/sTMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9951"; a="181234715"
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="181234715"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:26 -0700
IronPort-SDR: lAFA4YzoE7WQbr1CJAA3s1OnShHfKrmMoD61HCzxd5+gb6Xcya3hQMSLRzwwDQH68QCBWTMB/j
 rd3wEXrwULgg==
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="521030468"
Received: from rutujajo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.194.203])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:22:23 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        Andy Lutomirski <luto@amacapital.net>,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v5 11/11] KVM: x86: Add capability to grant VM access to privileged SGX attribute
Date:   Mon, 12 Apr 2021 16:21:43 +1200
Message-Id: <0b099d65e933e068e3ea934b0523bab070cb8cea.1618196135.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618196135.git.kai.huang@intel.com>
References: <cover.1618196135.git.kai.huang@intel.com>
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
v4->v5:
 - rebase to latest kvm/queue.

---
 Documentation/virt/kvm/api.rst | 23 +++++++++++++++++++++++
 arch/x86/kvm/cpuid.c           |  2 +-
 arch/x86/kvm/x86.c             | 21 +++++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 4 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2c4253718881..1c073588cf0b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6246,6 +6246,29 @@ the two vms from accidentally clobbering each other through interrupts and
 MSRs.
 
 
+7.25 KVM_CAP_SGX_ATTRIBUTE
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
index b9600540508e..aab07334e1d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -75,6 +75,7 @@
 #include <asm/tlbflush.h>
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
+#include <asm/sgx.h>
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -3803,6 +3804,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_X86_MSR_FILTER:
 	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
 	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
+#ifdef CONFIG_X86_SGX_KVM
+	case KVM_CAP_SGX_ATTRIBUTE:
+#endif
 		r = 1;
 		break;
 #ifdef CONFIG_KVM_XEN
@@ -5393,6 +5397,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (kvm_x86_ops.vm_copy_enc_context_from)
 			r = kvm_x86_ops.vm_copy_enc_context_from(kvm, cap->args[0]);
 		return r;
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
index 424b12658923..130f756c696d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1079,6 +1079,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_X86_BUS_LOCK_EXIT 193
 #define KVM_CAP_PPC_DAWR1 194
 #define KVM_CAP_VM_COPY_ENC_CONTEXT_FROM 195
+#define KVM_CAP_SGX_ATTRIBUTE 196
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.30.2

