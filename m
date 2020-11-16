Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898512B4FCC
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388691AbgKPSd2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:33:28 -0500
Received: from mga06.intel.com ([134.134.136.31]:20628 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732871AbgKPS17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:27:59 -0500
IronPort-SDR: /bewYYkmRqkWWzYmHYosaC8RdkzAybN4SzbCY5f8IlLVAkFLK0C3IfmUdoYf3/WA69JAKRT96N
 ySmpotGshjwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410011"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410011"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:58 -0800
IronPort-SDR: B+v+kirPHf2zOjGQvzRHA0d/GaEuzx4CUa8CKXEbUM76bxxJAELInTJEOA2+VCqfBeC3mqlAJm
 7eWry/eBsVDQ==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527869"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:27:58 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 14/67] KVM: Add max_vcpus field in common 'struct kvm'
Date:   Mon, 16 Nov 2020 10:25:59 -0800
Message-Id: <deec01f358031b8fdcf17cfa3ff97ce1c6017ca7.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 arch/arm64/kvm/arm.c              | 7 ++-----
 arch/arm64/kvm/vgic/vgic-init.c   | 6 +++---
 include/linux/kvm_host.h          | 1 +
 virt/kvm/kvm_main.c               | 3 ++-
 5 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 781d029b8aa8..259b05376807 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -95,9 +95,6 @@ struct kvm_arch {
 	/* VTCR_EL2 value for this VM */
 	u64    vtcr;
 
-	/* The maximum number of vCPUs depends on the used GIC model */
-	int max_vcpus;
-
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5750ec34960e..b3ba6c66183d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -125,7 +125,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_vgic_early_init(kvm);
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
-	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
+	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
 	return ret;
 out_free_stage2_pgd:
@@ -193,7 +193,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPUS:
 	case KVM_CAP_MAX_VCPU_ID:
 		if (kvm)
-			r = kvm->arch.max_vcpus;
+			r = kvm->max_vcpus;
 		else
 			r = kvm_arm_default_max_vcpus();
 		break;
@@ -247,9 +247,6 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
 		return -EBUSY;
 
-	if (id >= kvm->arch.max_vcpus)
-		return -EINVAL;
-
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 32e32d67a127..9af003b62509 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -97,11 +97,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	ret = 0;
 
 	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
-		kvm->arch.max_vcpus = VGIC_V2_MAX_CPUS;
+		kvm->max_vcpus = VGIC_V2_MAX_CPUS;
 	else
-		kvm->arch.max_vcpus = VGIC_V3_MAX_CPUS;
+		kvm->max_vcpus = VGIC_V3_MAX_CPUS;
 
-	if (atomic_read(&kvm->online_vcpus) > kvm->arch.max_vcpus) {
+	if (atomic_read(&kvm->online_vcpus) > kvm->max_vcpus) {
 		ret = -E2BIG;
 		goto out_unlock;
 	}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ad9b6963d19d..95371750c23f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -467,6 +467,7 @@ struct kvm {
 	 * and is accessed atomically.
 	 */
 	atomic_t online_vcpus;
+	int max_vcpus;
 	int created_vcpus;
 	int last_boosted_vcpu;
 	struct list_head vm_list;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b29b6c3484dd..3dc41b6e12a0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -752,6 +752,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
 	INIT_LIST_HEAD(&kvm->devices);
+	kvm->max_vcpus = KVM_MAX_VCPUS;
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
@@ -3098,7 +3099,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		return -EINVAL;
 
 	mutex_lock(&kvm->lock);
-	if (kvm->created_vcpus == KVM_MAX_VCPUS) {
+	if (kvm->created_vcpus >= kvm->max_vcpus) {
 		mutex_unlock(&kvm->lock);
 		return -EINVAL;
 	}
-- 
2.17.1

