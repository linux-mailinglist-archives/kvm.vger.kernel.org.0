Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0B86BD2D
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 15:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbfGQNgn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 09:36:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:36159 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727647AbfGQNgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 09:36:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 06:36:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,274,1559545200"; 
   d="scan'208";a="191261876"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jul 2019 06:36:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 6/9] KVM: VMX: Introduce SPP user-space IOCTLs
Date:   Wed, 17 Jul 2019 21:37:48 +0800
Message-Id: <20190717133751.12910-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190717133751.12910-1-weijiang.yang@intel.com>
References: <20190717133751.12910-1-weijiang.yang@intel.com>
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
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c       | 90 ++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h |  4 ++
 include/uapi/linux/kvm.h |  3 ++
 3 files changed, 97 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c7cb17941344..54a1d2423a17 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4589,6 +4589,23 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	return r;
 }
 
+static int kvm_vm_ioctl_get_subpages(struct kvm *kvm,
+				     struct kvm_subpage *spp_info)
+{
+	return kvm_arch_get_subpages(kvm, spp_info);
+}
+
+static int kvm_vm_ioctl_set_subpages(struct kvm *kvm,
+				     struct kvm_subpage *spp_info)
+{
+	return kvm_arch_set_subpages(kvm, spp_info);
+}
+
+static int kvm_vm_ioctl_init_spp(struct kvm *kvm)
+{
+	return kvm_arch_init_spp(kvm);
+}
+
 int kvm_get_subpages(struct kvm *kvm,
 		     struct kvm_subpage *spp_info)
 {
@@ -4922,8 +4939,55 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (copy_from_user(&hvevfd, argp, sizeof(hvevfd)))
 			goto out;
 		r = kvm_vm_ioctl_hv_eventfd(kvm, &hvevfd);
+	}
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
 		break;
 	}
+	case KVM_INIT_SPP: {
+		r = kvm_vm_ioctl_init_spp(kvm);
+		break;
+	 }
 	default:
 		r = -ENOTTY;
 	}
@@ -9925,6 +9989,32 @@ int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 	return kvm_x86_ops->update_pi_irte(kvm, host_irq, guest_irq, set);
 }
 
+int kvm_arch_get_subpages(struct kvm *kvm,
+			  struct kvm_subpage *spp_info)
+{
+	if (!kvm_x86_ops->get_subpages)
+		return -EINVAL;
+
+	return kvm_x86_ops->get_subpages(kvm, spp_info);
+}
+
+int kvm_arch_set_subpages(struct kvm *kvm,
+			  struct kvm_subpage *spp_info)
+{
+	if (!kvm_x86_ops->set_subpages)
+		return -EINVAL;
+
+	return kvm_x86_ops->set_subpages(kvm, spp_info);
+}
+
+int kvm_arch_init_spp(struct kvm *kvm)
+{
+	if (!kvm_x86_ops->init_spp)
+		return -EINVAL;
+
+	return kvm_x86_ops->init_spp(kvm);
+}
+
 bool kvm_vector_hashing_enabled(void)
 {
 	return vector_hashing;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index da30fcbb2727..b5ae112f209f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -852,6 +852,10 @@ struct kvm_mmu_page *kvm_mmu_get_spp_page(struct kvm_vcpu *vcpu,
 int kvm_get_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
 int kvm_set_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
 int kvm_init_spp(struct kvm *kvm);
+int kvm_arch_get_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
+int kvm_arch_set_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
+int kvm_arch_init_spp(struct kvm *kvm);
+
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
  * All architectures that want to use vzalloc currently also
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2c75a87ab3b5..5754f8d21e7d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1246,6 +1246,9 @@ struct kvm_vfio_spapr_tce {
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

