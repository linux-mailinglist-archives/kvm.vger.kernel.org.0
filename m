Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B425445D204
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347116AbhKYA2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:28:25 -0500
Received: from mga18.intel.com ([134.134.136.126]:32626 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352766AbhKYAYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="222281286"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="222281286"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:06 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042132"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:05 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 13/59] KVM: Add max_vcpus field in common 'struct kvm'
Date:   Wed, 24 Nov 2021 16:19:56 -0800
Message-Id: <cb707c90542c9ad4768dae88c80fefcc15a264d6.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 arch/arm64/kvm/arm.c              | 7 ++-----
 arch/arm64/kvm/vgic/vgic-init.c   | 6 +++---
 include/linux/kvm_host.h          | 1 +
 virt/kvm/kvm_main.c               | 3 ++-
 5 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2a5f7f38006f..ff3f4ab57eba 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -108,9 +108,6 @@ struct kvm_arch {
 	/* VTCR_EL2 value for this VM */
 	u64    vtcr;
 
-	/* The maximum number of vCPUs depends on the used GIC model */
-	int max_vcpus;
-
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 2f03cbfefe67..14df7ee047e4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -153,7 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_vgic_early_init(kvm);
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
-	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
+	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
 	set_default_spectre(kvm);
 
@@ -228,7 +228,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPUS:
 	case KVM_CAP_MAX_VCPU_ID:
 		if (kvm)
-			r = kvm->arch.max_vcpus;
+			r = kvm->max_vcpus;
 		else
 			r = kvm_arm_default_max_vcpus();
 		break;
@@ -304,9 +304,6 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
 		return -EBUSY;
 
-	if (id >= kvm->arch.max_vcpus)
-		return -EINVAL;
-
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 0a06d0648970..906aee52f2bc 100644
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
index 9e0667e3723e..625de21ceb43 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -566,6 +566,7 @@ struct kvm {
 	 * and is accessed atomically.
 	 */
 	atomic_t online_vcpus;
+	int max_vcpus;
 	int created_vcpus;
 	int last_boosted_vcpu;
 	struct list_head vm_list;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8544e92db2da..4a1dbf0b1d3d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1052,6 +1052,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 
 	INIT_LIST_HEAD(&kvm->devices);
+	kvm->max_vcpus = KVM_MAX_VCPUS;
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
@@ -3599,7 +3600,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		return -EINVAL;
 
 	mutex_lock(&kvm->lock);
-	if (kvm->created_vcpus == KVM_MAX_VCPUS) {
+	if (kvm->created_vcpus >= kvm->max_vcpus) {
 		mutex_unlock(&kvm->lock);
 		return -EINVAL;
 	}
-- 
2.25.1

