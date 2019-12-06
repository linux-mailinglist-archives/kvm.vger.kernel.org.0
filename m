Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65955114D8E
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 09:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLFIZS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 03:25:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:25876 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbfLFIZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 03:25:17 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Dec 2019 00:25:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,283,1571727600"; 
   d="scan'208";a="294797958"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 06 Dec 2019 00:25:15 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v9 05/10] x86: spp: Introduce user-space SPP IOCTLs
Date:   Fri,  6 Dec 2019 16:26:29 +0800
Message-Id: <20191206082634.21042-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20191206082634.21042-1-weijiang.yang@intel.com>
References: <20191206082634.21042-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

User application, e.g., QEMU or VMI, must initialize SPP
before gets/sets SPP subpages, the dynamic initialization is to
reduce the extra storage cost if the SPP feature is not not used.

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++
 arch/x86/kvm/mmu/spp.c          | 44 +++++++++++++++
 arch/x86/kvm/mmu/spp.h          |  9 ++++
 arch/x86/kvm/vmx/vmx.c          | 15 ++++++
 arch/x86/kvm/x86.c              | 95 ++++++++++++++++++++++++++++++++-
 include/uapi/linux/kvm.h        |  3 ++
 6 files changed, 169 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a30cff333033..0869ece49dbf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1216,6 +1216,10 @@ struct kvm_x86_ops {
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
 
 	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
+
+	int (*init_spp)(struct kvm *kvm);
+	int (*flush_subpages)(struct kvm *kvm, u64 gfn, u32 npages);
+	int (*get_inst_len)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index 332fca0156cd..85aefc3516b3 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -555,3 +555,47 @@ inline u64 construct_spptp(unsigned long root_hpa)
 }
 EXPORT_SYMBOL_GPL(construct_spptp);
 
+int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
+			      u64 gfn,
+			      u32 npages,
+			      u32 *access_map)
+{
+	int ret;
+
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_spp_get_permission(kvm, gfn, npages, access_map);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_ioctl_get_subpages);
+
+int kvm_vm_ioctl_set_subpages(struct kvm *kvm,
+			      u64 gfn,
+			      u32 npages,
+			      u32 *access_map)
+{
+	int ret;
+
+	if (!kvm_x86_ops->flush_subpages)
+		return -EINVAL;
+
+	spin_lock(&kvm->mmu_lock);
+	ret = kvm_x86_ops->flush_subpages(kvm, gfn, npages);
+	spin_unlock(&kvm->mmu_lock);
+
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&kvm->slots_lock);
+	spin_lock(&kvm->mmu_lock);
+
+	ret = kvm_spp_set_permission(kvm, gfn, npages, access_map);
+
+	spin_unlock(&kvm->mmu_lock);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_ioctl_set_subpages);
+
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
index a636d09f6db0..370a6b71e143 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -3,6 +3,7 @@
 #define __KVM_X86_VMX_SPP_H
 
 #define FULL_SPP_ACCESS		((u32)((1ULL << 32) - 1))
+#define KVM_SUBPAGE_MAX_PAGES   512
 
 int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map);
@@ -11,6 +12,14 @@ int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
 int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access);
 bool is_spp_spte(struct kvm_mmu_page *sp);
 inline u64 construct_spptp(unsigned long root_hpa);
+int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
+			      u64 gfn,
+			      u32 npages,
+			      u32 *access_map);
+int kvm_vm_ioctl_set_subpages(struct kvm *kvm,
+			      u64 gfn,
+			      u32 npages,
+			      u32 *access_map);
 int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 			    u32 access_map, gfn_t gfn);
 int vmx_spp_flush_sppt(struct kvm *kvm, u64 gfn_base, u32 npages);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9d1a7e624c5b..10132a2f62c3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1338,6 +1338,11 @@ static bool emulation_required(struct kvm_vcpu *vcpu)
 	return emulate_invalid_guest_state && !guest_state_valid(vcpu);
 }
 
+static int vmx_get_inst_len(struct kvm_vcpu *vcpu)
+{
+	return vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
+}
+
 static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu);
 
 unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
@@ -7596,6 +7601,12 @@ static __init int hardware_setup(void)
 		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
 	}
 
+	if (!spp_supported) {
+		kvm_x86_ops->flush_subpages = NULL;
+		kvm_x86_ops->init_spp = NULL;
+		kvm_x86_ops->get_inst_len = NULL;
+	}
+
 	if (!cpu_has_vmx_preemption_timer())
 		enable_preemption_timer = false;
 
@@ -7808,6 +7819,10 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.nested_enable_evmcs = NULL,
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
+
+	.flush_subpages = vmx_spp_flush_sppt,
+	.init_spp = vmx_spp_init,
+	.get_inst_len = vmx_get_inst_len,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91602d310a3f..cdbb3694f22c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -26,6 +26,7 @@
 #include "cpuid.h"
 #include "pmu.h"
 #include "hyperv.h"
+#include "mmu/spp.h"
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -3183,6 +3184,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = kvm_x86_ops->get_nested_state ?
 			kvm_x86_ops->get_nested_state(NULL, NULL, 0) : 0;
 		break;
+	case KVM_CAP_X86_SPP:
+		r = KVM_SUBPAGE_MAX_PAGES;
+		break;
 	default:
 		break;
 	}
@@ -3957,7 +3961,6 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 				r = -EFAULT;
 		}
 		return r;
-
 	default:
 		return -EINVAL;
 	}
@@ -4670,6 +4673,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_X86_SPP:
+		r =  kvm_x86_ops->init_spp(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -4977,6 +4983,93 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
 		break;
+	case KVM_SUBPAGES_GET_ACCESS: {
+		struct kvm_subpage spp_info, *pinfo;
+		u32 total;
+
+		r = -ENODEV;
+		if (!kvm->arch.spp_active)
+			goto out;
+
+		r = -EFAULT;
+		if (copy_from_user(&spp_info, argp, sizeof(spp_info)))
+			goto out;
+
+		r = -EINVAL;
+		if (spp_info.flags != 0 ||
+		    spp_info.npages > KVM_SUBPAGE_MAX_PAGES)
+			goto out;
+		r = 0;
+		if (!spp_info.npages)
+			goto out;
+
+		total = sizeof(spp_info) +
+			sizeof(spp_info.access_map[0]) * spp_info.npages;
+		pinfo = kvzalloc(total, GFP_KERNEL_ACCOUNT);
+
+		r = -ENOMEM;
+		if (!pinfo)
+			goto out;
+
+		r = -EFAULT;
+		if (copy_from_user(pinfo, argp, total))
+			goto out;
+
+		r = kvm_vm_ioctl_get_subpages(kvm,
+					      pinfo->gfn_base,
+					      pinfo->npages,
+					      pinfo->access_map);
+		if (r != pinfo->npages)
+			goto out;
+
+		r = -EFAULT;
+		if (copy_to_user(argp, pinfo, total))
+			goto out;
+
+		kfree(pinfo);
+		r = pinfo->npages;
+		break;
+	}
+	case KVM_SUBPAGES_SET_ACCESS: {
+		struct kvm_subpage spp_info, *pinfo;
+		u32 total;
+
+		r = -ENODEV;
+		if (!kvm->arch.spp_active)
+			goto out;
+
+		r = -EFAULT;
+		if (copy_from_user(&spp_info, argp, sizeof(spp_info)))
+			goto out;
+
+		r = -EINVAL;
+		if (spp_info.flags != 0 ||
+		    spp_info.npages > KVM_SUBPAGE_MAX_PAGES)
+			goto out;
+
+		r = 0;
+		if (!spp_info.npages)
+			goto out;
+
+		total = sizeof(spp_info) +
+			sizeof(spp_info.access_map[0]) * spp_info.npages;
+		pinfo = kvzalloc(total, GFP_KERNEL_ACCOUNT);
+
+		r = -ENOMEM;
+		if (!pinfo)
+			goto out;
+
+		r = -EFAULT;
+		if (copy_from_user(pinfo, argp, total))
+			goto out;
+
+		r = kvm_vm_ioctl_set_subpages(kvm,
+					      pinfo->gfn_base,
+					      pinfo->npages,
+					      pinfo->access_map);
+		kfree(pinfo);
+		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 592624e46669..f3a5a36a6c1c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1004,6 +1004,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_X86_SPP 176
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1256,6 +1257,8 @@ struct kvm_vfio_spapr_tce {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_SUBPAGES_GET_ACCESS   _IOR(KVMIO,  0x49, __u64)
+#define KVM_SUBPAGES_SET_ACCESS   _IOW(KVMIO,  0x4a, __u64)
 
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
-- 
2.17.2

