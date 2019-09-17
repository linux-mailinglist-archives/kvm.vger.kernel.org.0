Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE6D8B49E8
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 10:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfIQIw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 04:52:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:37165 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfIQIwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 04:52:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 01:52:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,515,1559545200"; 
   d="scan'208";a="193695527"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Sep 2019 01:52:36 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 6/9] x86: spp: Introduce user-space SPP IOCTLs
Date:   Tue, 17 Sep 2019 16:53:01 +0800
Message-Id: <20190917085304.16987-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190917085304.16987-1-weijiang.yang@intel.com>
References: <20190917085304.16987-1-weijiang.yang@intel.com>
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
 arch/x86/include/asm/kvm_host.h |  3 ++
 arch/x86/kvm/vmx/spp.c          | 54 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/spp.h          |  5 +++
 arch/x86/kvm/vmx/vmx.c          |  8 +++++
 arch/x86/kvm/x86.c              | 49 ++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  3 ++
 6 files changed, 122 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cc38670a0c45..3863eb3c0e6a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1216,6 +1216,9 @@ struct kvm_x86_ops {
 	uint16_t (*nested_get_evmcs_version)(struct kvm_vcpu *vcpu);
 
 	bool (*need_emulation_on_page_fault)(struct kvm_vcpu *vcpu);
+
+	int (*init_spp)(struct kvm *kvm);
+	int (*flush_subpages)(struct kvm *kvm, struct kvm_subpage *spp_info);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/vmx/spp.c b/arch/x86/kvm/vmx/spp.c
index ffc4ebcb64a6..edc6a39340d9 100644
--- a/arch/x86/kvm/vmx/spp.c
+++ b/arch/x86/kvm/vmx/spp.c
@@ -535,3 +535,57 @@ inline u64 construct_spptp(unsigned long root_hpa)
 }
 EXPORT_SYMBOL_GPL(construct_spptp);
 
+int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
+		     struct kvm_subpage *spp_info)
+{
+	int ret;
+
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_spp_get_permission(kvm, spp_info);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_ioctl_get_subpages);
+
+int kvm_vm_ioctl_set_subpages(struct kvm *kvm,
+		     struct kvm_subpage *spp_info)
+{
+	int ret;
+
+	if (!kvm_x86_ops->flush_subpages)
+	      return -EINVAL;
+
+	spin_lock(&kvm->mmu_lock);
+	ret = kvm_x86_ops->flush_subpages(kvm, spp_info);
+	spin_unlock(&kvm->mmu_lock);
+
+	if (ret < 0)
+	      return ret;
+
+	mutex_lock(&kvm->slots_lock);
+	spin_lock(&kvm->mmu_lock);
+
+	ret = kvm_spp_set_permission(kvm, spp_info);
+
+	spin_unlock(&kvm->mmu_lock);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_ioctl_set_subpages);
+
+int kvm_vm_ioctl_init_spp(struct kvm *kvm)
+{
+	int ret;
+
+	if (!kvm_x86_ops->init_spp)
+	      return -ENODEV;
+
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_x86_ops->init_spp(kvm);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_ioctl_init_spp);
diff --git a/arch/x86/kvm/vmx/spp.h b/arch/x86/kvm/vmx/spp.h
index 9c3a51feddda..52cf87de1330 100644
--- a/arch/x86/kvm/vmx/spp.h
+++ b/arch/x86/kvm/vmx/spp.h
@@ -6,6 +6,11 @@
 
 bool is_spp_spte(struct kvm_mmu_page *sp);
 inline u64 construct_spptp(unsigned long root_hpa);
+int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
+		     struct kvm_subpage *spp_info);
+int kvm_vm_ioctl_set_subpages(struct kvm *kvm,
+		     struct kvm_subpage *spp_info);
+int kvm_vm_ioctl_init_spp(struct kvm *kvm);
 int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 				u32 access_map, gfn_t gfn);
 int vmx_spp_flush_sppt(struct kvm *kvm, struct kvm_subpage *spp_info);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8ecf9cb24879..7655c62decf4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7597,6 +7597,11 @@ static __init int hardware_setup(void)
 		kvm_x86_ops->enable_log_dirty_pt_masked = NULL;
 	}
 
+	if (!spp_supported) {
+		kvm_x86_ops->flush_subpages = NULL;
+		kvm_x86_ops->init_spp = NULL;
+	}
+
 	if (!cpu_has_vmx_preemption_timer())
 		enable_preemption_timer = false;
 
@@ -7809,6 +7814,9 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.nested_enable_evmcs = NULL,
 	.nested_get_evmcs_version = NULL,
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
+
+	.flush_subpages = vmx_spp_flush_sppt,
+	.init_spp = vmx_spp_init,
 };
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91602d310a3f..3561949577b9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -26,6 +26,7 @@
 #include "cpuid.h"
 #include "pmu.h"
 #include "hyperv.h"
+#include "vmx/spp.h"
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -4977,6 +4978,54 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
 		break;
+	case KVM_SUBPAGES_GET_ACCESS: {
+		struct kvm_subpage spp_info;
+
+		if (!kvm->arch.spp_active) {
+			r = -ENODEV;
+			goto out;
+		}
+
+		r = -EFAULT;
+		if (copy_from_user(&spp_info, argp, sizeof(spp_info)))
+			goto out;
+
+		r = -EINVAL;
+		if (spp_info.npages == 0 ||
+		    spp_info.npages > SUBPAGE_MAX_BITMAP)
+			goto out;
+
+		r = kvm_vm_ioctl_get_subpages(kvm, &spp_info);
+		if (copy_to_user(argp, &spp_info, sizeof(spp_info))) {
+			r = -EFAULT;
+			goto out;
+		}
+		break;
+	}
+	case KVM_SUBPAGES_SET_ACCESS: {
+		struct kvm_subpage spp_info;
+
+		if (!kvm->arch.spp_active) {
+			r = -ENODEV;
+			goto out;
+		}
+
+		r = -EFAULT;
+		if (copy_from_user(&spp_info, argp, sizeof(spp_info)))
+			goto out;
+
+		r = -EINVAL;
+		if (spp_info.npages == 0 ||
+		    spp_info.npages > SUBPAGE_MAX_BITMAP)
+			goto out;
+
+		r = kvm_vm_ioctl_set_subpages(kvm, &spp_info);
+		break;
+	}
+	case KVM_INIT_SPP: {
+		r = kvm_vm_ioctl_init_spp(kvm);
+		break;
+	 }
 	default:
 		r = -ENOTTY;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 9460830de536..700f0825336d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1257,6 +1257,9 @@ struct kvm_vfio_spapr_tce {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_SUBPAGES_GET_ACCESS   _IOR(KVMIO,  0x49, __u64)
+#define KVM_SUBPAGES_SET_ACCESS   _IOW(KVMIO,  0x4a, __u64)
+#define KVM_INIT_SPP              _IOW(KVMIO,  0x4b, __u64)
 
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
-- 
2.17.2

