Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B15E787F4B
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437229AbfHIQPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:47 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53026 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437122AbfHIQPH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 7A332302478E;
        Fri,  9 Aug 2019 19:01:10 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 0075D305B7A3;
        Fri,  9 Aug 2019 19:01:08 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        He Chen <he.chen@linux.intel.com>,
        Zhang Yi <yi.z.zhang@linux.intel.com>
Subject: [RFC PATCH v6 39/92] KVM: VMX: Introduce SPP user-space IOCTLs
Date:   Fri,  9 Aug 2019 18:59:54 +0300
Message-Id: <20190809160047.8319-40-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yang Weijiang <weijiang.yang@intel.com>

User application, e.g., QEMU or VMI, must initialize SPP
before gets/sets SPP subpages, the dynamic initialization is to
reduce the extra storage cost if the SPP feature is not not used.

Co-developed-by: He Chen <he.chen@linux.intel.com>
Signed-off-by: He Chen <he.chen@linux.intel.com>
Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Message-Id: <20190717133751.12910-7-weijiang.yang@intel.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/x86.c       | 73 ++++++++++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h |  3 ++
 include/uapi/linux/kvm.h |  3 ++
 3 files changed, 79 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b8ae25cb227b..ef29ef7617bf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4926,6 +4926,53 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
+		break;
+	}
+	case KVM_INIT_SPP: {
+		r = kvm_vm_ioctl_init_spp(kvm);
 		break;
 	}
 	default:
@@ -9906,6 +9953,32 @@ bool kvm_arch_has_irq_bypass(void)
 	return kvm_x86_ops->update_pi_irte != NULL;
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
 int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0b9a0f546397..ae4106aae16e 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -837,6 +837,9 @@ struct kvm_mmu_page *kvm_mmu_get_spp_page(struct kvm_vcpu *vcpu,
 int kvm_get_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
 int kvm_set_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
 int kvm_init_spp(struct kvm *kvm);
+int kvm_arch_get_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
+int kvm_arch_set_subpages(struct kvm *kvm, struct kvm_subpage *spp_info);
+int kvm_arch_init_spp(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ad8f2a3ca72d..86dd57e67539 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1248,6 +1248,9 @@ struct kvm_vfio_spapr_tce {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_SUBPAGES_GET_ACCESS   _IOR(KVMIO,  0x49, __u64)
+#define KVM_SUBPAGES_SET_ACCESS   _IOW(KVMIO,  0x4a, __u64)
+#define KVM_INIT_SPP              _IOW(KVMIO,  0x4b, __u64)
 
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
