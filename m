Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A4F1D6117
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 14:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbgEPMyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 08:54:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:47567 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgEPMyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 08:54:02 -0400
IronPort-SDR: WB/+nmIXfLg9XONJ2xBOgloWiqLJHz9KhHYJ03X7f3LLRaUmzOo4W9tj9QghhcilpiUn+gZ4kI
 poZQvbK+yYeQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 05:54:00 -0700
IronPort-SDR: AUN2JKAMOomw2711rXsm87dO5gKUZMIR5+HgVeyT4mINxdtanbvWy4A0GId+2MTIWQLmTzQ3Vr
 2aKTs7ulDxNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="288076586"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2020 05:53:58 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com, ssicleru@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 05/11] x86: spp: Introduce user-space SPP IOCTLs
Date:   Sat, 16 May 2020 20:55:01 +0800
Message-Id: <20200516125507.5277-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200516125507.5277-1-weijiang.yang@intel.com>
References: <20200516125507.5277-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace application, e.g., QEMU or VMI, must initialize SPP
before {gets|sets} SPP subpages.

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/mmu/spp.c   | 79 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/spp.h   | 11 ++++-
 arch/x86/kvm/x86.c       | 88 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h |  2 +
 4 files changed, 179 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/spp.c b/arch/x86/kvm/mmu/spp.c
index df5d79b17ef3..25207f1ac9f8 100644
--- a/arch/x86/kvm/mmu/spp.c
+++ b/arch/x86/kvm/mmu/spp.c
@@ -205,6 +205,46 @@ int kvm_spp_setup_structure(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+int spp_flush_sppt(struct kvm *kvm, u64 gfn_base, u32 npages)
+{
+	struct kvm_shadow_walk_iterator iter;
+	struct kvm_vcpu *vcpu;
+	gfn_t gfn = gfn_base;
+	gfn_t gfn_end = gfn_base + npages - 1;
+	u64 spde;
+	int count;
+	bool flush = false;
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	if (!VALID_PAGE(vcpu->kvm->arch.sppt_root))
+		return -EFAULT;
+
+	for (; gfn <= gfn_end; gfn++) {
+		for_each_shadow_spp_entry(vcpu, (u64)gfn << PAGE_SHIFT, iter) {
+			if (!is_shadow_present_pte(*iter.sptep))
+				break;
+
+			if (iter.level != PT_DIRECTORY_LEVEL)
+				continue;
+
+			spde = *iter.sptep;
+			spde &= ~PT_PRESENT_MASK;
+			spp_spte_set(iter.sptep, spde);
+			count = kvm_spp_level_pages(gfn, gfn_end,
+						    PT_DIRECTORY_LEVEL);
+			flush = true;
+			if (count >= npages)
+				goto out;
+			gfn += count;
+			break;
+		}
+	}
+out:
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
+	return 0;
+}
+
 int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map)
 {
@@ -371,3 +411,42 @@ int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access)
 	}
 	return ret;
 }
+
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
+
+int kvm_vm_ioctl_set_subpages(struct kvm *kvm,
+			      u64 gfn,
+			      u32 npages,
+			      u32 *access_map)
+{
+	int ret;
+
+	spin_lock(&kvm->mmu_lock);
+	ret = spp_flush_sppt(kvm, gfn, npages);
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
diff --git a/arch/x86/kvm/mmu/spp.h b/arch/x86/kvm/mmu/spp.h
index 9171e682be1f..75d4bfd64dbd 100644
--- a/arch/x86/kvm/mmu/spp.h
+++ b/arch/x86/kvm/mmu/spp.h
@@ -3,15 +3,24 @@
 #define __KVM_X86_VMX_SPP_H
 
 #define FULL_SPP_ACCESS		(u32)(BIT_ULL(32) - 1)
+#define KVM_SUBPAGE_MAX_PAGES   512
 
 int kvm_spp_get_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map);
 int kvm_spp_set_permission(struct kvm *kvm, u64 gfn, u32 npages,
 			   u32 *access_map);
 int kvm_spp_mark_protection(struct kvm *kvm, u64 gfn, u32 access);
-
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
 u32 *gfn_to_subpage_wp_info(struct kvm_memory_slot *slot, gfn_t gfn);
+int spp_flush_sppt(struct kvm *kvm, u64 gfn_base, u32 npages);
 
 #endif /* __KVM_X86_VMX_SPP_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 35e4b57dbabf..c0b09d8be31b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -28,6 +28,7 @@
 #include "pmu.h"
 #include "hyperv.h"
 #include "lapic.h"
+#include "mmu/spp.h"
 
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -5196,6 +5197,93 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
+		r = pinfo->npages;
+		kfree(pinfo);
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
index 63a477720a17..2b70cf0d402a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1280,6 +1280,8 @@ struct kvm_vfio_spapr_tce {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_SUBPAGES_GET_ACCESS   _IOR(KVMIO,  0x49, __u64)
+#define KVM_SUBPAGES_SET_ACCESS   _IOW(KVMIO,  0x4a, __u64)
 
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
-- 
2.17.2

