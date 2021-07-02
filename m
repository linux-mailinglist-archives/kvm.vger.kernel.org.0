Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318403BA567
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhGBWIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:08:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:51169 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230249AbhGBWH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951902"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951902"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:23 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814739"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:22 -0700
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
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 21/69] KVM: Add max_vcpus field in common 'struct kvm'
Date:   Fri,  2 Jul 2021 15:04:27 -0700
Message-Id: <bf7685a4665a4f70259b0cd5f7d11a162753278c.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
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
index 7cd7d5c8c4bc..96a0dc3a8780 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -106,9 +106,6 @@ struct kvm_arch {
 	/* VTCR_EL2 value for this VM */
 	u64    vtcr;
 
-	/* The maximum number of vCPUs depends on the used GIC model */
-	int max_vcpus;
-
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e720148232a0..a46306cf3106 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -145,7 +145,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_vgic_early_init(kvm);
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
-	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
+	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
 	set_default_spectre(kvm);
 
@@ -220,7 +220,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPUS:
 	case KVM_CAP_MAX_VCPU_ID:
 		if (kvm)
-			r = kvm->arch.max_vcpus;
+			r = kvm->max_vcpus;
 		else
 			r = kvm_arm_default_max_vcpus();
 		break;
@@ -299,9 +299,6 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
 		return -EBUSY;
 
-	if (id >= kvm->arch.max_vcpus)
-		return -EINVAL;
-
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 58cbda00e56d..089ac00c55d7 100644
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
index e87f07c5c601..ddd4d0f68cdf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -544,6 +544,7 @@ struct kvm {
 	 * and is accessed atomically.
 	 */
 	atomic_t online_vcpus;
+	int max_vcpus;
 	int created_vcpus;
 	int last_boosted_vcpu;
 	struct list_head vm_list;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index dc752d0bd3ec..52d40ea75749 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -910,6 +910,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
 	INIT_LIST_HEAD(&kvm->devices);
+	kvm->max_vcpus = KVM_MAX_VCPUS;
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
@@ -3329,7 +3330,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		return -EINVAL;
 
 	mutex_lock(&kvm->lock);
-	if (kvm->created_vcpus == KVM_MAX_VCPUS) {
+	if (kvm->created_vcpus >= kvm->max_vcpus) {
 		mutex_unlock(&kvm->lock);
 		return -EINVAL;
 	}
-- 
2.25.1

