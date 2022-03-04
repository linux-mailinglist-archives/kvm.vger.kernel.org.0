Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C184CDDF6
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbiCDUJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiCDUHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:15 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F89233E74;
        Fri,  4 Mar 2022 12:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424101; x=1677960101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z6mau14vjkrTQpVseJHnXxQjEtgENXNOQ45qyYOOZEo=;
  b=chqc2CyyC+l/aMNm5d+XdoSWPLRFuICwIvuxTn48Wo9KH+4zSBIPcUOw
   m9GpwLnVeffyLGOjbZcJGjE+QDyuZfXfcmftT+nSu8q2Tc2ji5D9Qt2hz
   0Bk6D334z4YUBCkLqx7j/7efl+ojjjVE89KzoiIT5SAg1y1Uh8vQCdcvA
   Xta6XwHhS8PsUSN00T43iLR8yxZyVJMVA/uDd0R3/WL3UyxENdtpAWGDe
   Mej0B/XnW0wQWeu6wTqJHh/kCK8213TJfzEL+sQip9sIMb/uvCXDwUjT+
   oGruOqEXtBfU9dvWYi4vqsxkrxpPgao0BQK2Tkk0/ThhBzVlMZLITEuKq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983388"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983388"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:13 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344245"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:13 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 022/104] KVM: Add max_vcpus field in common 'struct kvm'
Date:   Fri,  4 Mar 2022 11:48:38 -0800
Message-Id: <e53234cdee6a92357d06c80c03d77c19cdefb804.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

For TDX guests, the maximum number of vcpus needs to be specified when the
TDX guest VM is initialized (creating the TDX data corresponding to TDX
guest) before creating vcpu.  It needs to record the maximum number of
vcpus on VM creation (KVM_CREATE_VM) and return error if the number of
vcpus exceeds it

Because there is already max_vcpu member in arm64 struct kvm_arch, move it
to common struct kvm and initialize it to KVM_MAX_VCPUS before
kvm_arch_init_vm() instead of adding it to x86 struct kvm_arch.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 ---
 arch/arm64/kvm/arm.c              | 6 +++---
 arch/arm64/kvm/vgic/vgic-init.c   | 6 +++---
 include/linux/kvm_host.h          | 1 +
 virt/kvm/kvm_main.c               | 3 ++-
 5 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5bc01e62c08a..27249d634605 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -107,9 +107,6 @@ struct kvm_arch {
 	/* VTCR_EL2 value for this VM */
 	u64    vtcr;
 
-	/* The maximum number of vCPUs depends on the used GIC model */
-	int max_vcpus;
-
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecc5958e27fe..defec2cd94bd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -153,7 +153,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_vgic_early_init(kvm);
 
 	/* The maximum number of VCPUs is limited by the host's GIC model */
-	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
+	kvm->max_vcpus = kvm_arm_default_max_vcpus();
 
 	set_default_spectre(kvm);
 
@@ -229,7 +229,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MAX_VCPUS:
 	case KVM_CAP_MAX_VCPU_ID:
 		if (kvm)
-			r = kvm->arch.max_vcpus;
+			r = kvm->max_vcpus;
 		else
 			r = kvm_arm_default_max_vcpus();
 		break;
@@ -305,7 +305,7 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
 	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
 		return -EBUSY;
 
-	if (id >= kvm->arch.max_vcpus)
+	if (id >= kvm->max_vcpus)
 		return -EINVAL;
 
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index fc00304fe7d8..77feafd5c0e3 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -98,11 +98,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
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
index f11039944c08..a56044a31bc6 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -715,6 +715,7 @@ struct kvm {
 	 * and is accessed atomically.
 	 */
 	atomic_t online_vcpus;
+	int max_vcpus;
 	int created_vcpus;
 	int last_boosted_vcpu;
 	struct list_head vm_list;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 52f72a366beb..3adee9c6b370 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1075,6 +1075,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	spin_lock_init(&kvm->gpc_lock);
 
 	INIT_LIST_HEAD(&kvm->devices);
+	kvm->max_vcpus = KVM_MAX_VCPUS;
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
 
@@ -3718,7 +3719,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
 		return -EINVAL;
 
 	mutex_lock(&kvm->lock);
-	if (kvm->created_vcpus == KVM_MAX_VCPUS) {
+	if (kvm->created_vcpus >= kvm->max_vcpus) {
 		mutex_unlock(&kvm->lock);
 		return -EINVAL;
 	}
-- 
2.25.1

