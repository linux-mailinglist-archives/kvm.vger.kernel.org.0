Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717DD6C2445
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 23:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCTWK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 18:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCTWKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 18:10:53 -0400
Received: from out-58.mta1.migadu.com (out-58.mta1.migadu.com [IPv6:2001:41d0:203:375::3a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54B71CAE5
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 15:10:47 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679350245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NX+zgnfJ/oGTbRu3KKYL4GZduU4JUJo9BDONnVgt4Kk=;
        b=AyICnckkaqibJKNTaBdIicvy3XXrYFJ1pTlQ3o7HL+EalzqfVRJgRRgElabgg7k9Csdmv7
        gq4lV2+ijnafIdGDviR/fd9RPf8tNtEaW9/sCgOGbs7w2iyvN07JWdbJizf4LLQCejBBnB
        iuhK7Na9mih7b58pAar2JTlRgz6dUzE=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Sean Christopherson <seanjc@google.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 09/11] KVM: arm64: Indroduce support for userspace SMCCC filtering
Date:   Mon, 20 Mar 2023 22:10:00 +0000
Message-Id: <20230320221002.4191007-10-oliver.upton@linux.dev>
In-Reply-To: <20230320221002.4191007-1-oliver.upton@linux.dev>
References: <20230320221002.4191007-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the SMCCC (and related specifications) march towards an 'everything
and the kitchen sink' interface for interacting with a system it becomes
less likely that KVM will support every related feature. We could do
better by letting userspace have a crack at it instead.

Allow userspace to define an 'SMCCC filter' that applies to both HVCs
and SMCs initiated by the guest. Supporting both conduits with this
interface is important for a couple of reasons. Guest SMC usage is table
stakes for a nested guest, as HVCs are always taken to the virtual EL2.
Additionally, guests may want to interact with a service on the secure
side which can now be proxied by userspace.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 Documentation/virt/kvm/devices/vm.rst | 74 +++++++++++++++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h     | 11 ++++
 arch/arm64/kvm/arm.c                  |  4 ++
 arch/arm64/kvm/hypercalls.c           | 58 +++++++++++++++++++++
 include/kvm/arm_hypercalls.h          |  3 ++
 5 files changed, 150 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
index 147efec626e5..9bba8bacbd5d 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -321,3 +321,77 @@ Allows userspace to query the status of migration mode.
 	     if it is enabled
 :Returns:   -EFAULT if the given address is not accessible from kernel space;
 	    0 in case of success.
+
+6. GROUP: KVM_ARM_VM_SMCCC_CTRL
+===============================
+
+:Architectures: arm64
+
+6.1. ATTRIBUTE: KVM_ARM_VM_SMCCC_FILTER (w/o)
+---------------------------------------------
+
+:Parameters: Pointer to a ``struct kvm_smccc_filter``
+
+:Returns:
+
+        =======  ===========================================
+        -EPERM   Range intersects with a reserved range
+        -EEXIST  Range intersects with a previously inserted
+                 range
+        -EBUSY   A vCPU in the VM has already run
+        -EINVAL  Invalid filter configuration
+        -ENOMEM  Failed to allocate memory for the in-kernel
+                 representation of the SMCCC filter
+        =======  ===========================================
+
+Requests the installation of an SMCCC call filter described as follows::
+
+    enum kvm_smccc_filter_action {
+            KVM_SMCCC_FILTER_ALLOW = 0,
+            KVM_SMCCC_FILTER_DENY,
+            KVM_SMCCC_FILTER_FWD_TO_USER,
+    };
+
+    struct kvm_smccc_filter {
+            __u32 base;
+            __u32 nr_functions;
+            __u8 action;
+            __u8 pad[7];
+    };
+
+The filter is defined as a set of non-overlapping ranges. Each
+range defines an action to be applied to SMCCC calls within the range.
+Userspace can insert multiple ranges into the filter by using
+successive calls to this attribute.
+
+The default configuration of KVM is such that all implemented SMCCC
+calls are allowed. Thus, the SMCCC filter can be defined sparsely
+by userspace, only describing ranges that modify the default behavior.
+
+The range expressed by ``struct kvm_smccc_filter`` is
+[``base``, ``base + nr_functions``).
+
+The SMCCC filter applies to both SMC and HVC calls initiated by the
+guest.
+
+Actions:
+
+ - ``KVM_SMCCC_FILTER_ALLOW``: Allows the guest SMCCC call to be
+   handled in-kernel. It is strongly recommended that userspace *not*
+   explicitly describe the allowed SMCCC call ranges.
+
+ - ``KVM_SMCCC_FILTER_DENY``: Rejects the guest SMCCC call in-kernel
+   and returns to the guest.
+
+ - ``KVM_SMCCC_FILTER_FWD_TO_USER``: The guest SMCCC call is forwarded
+   to userspace with an exit reason of ``KVM_EXIT_HYPERCALL``.
+
+KVM reserves the 'Arm Architecture Calls' range of function IDs and
+will reject attempts to define a filter for any portion of these ranges:
+
+        =========== ===============
+        Start       End (inclusive)
+        =========== ===============
+        0x8000_0000 0x8000_FFFF
+        0xC000_0000 0xC000_FFFF
+        =========== ===============
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 1dabb7d05514..ba188562b7e0 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -372,6 +372,10 @@ enum {
 #endif
 };
 
+/* Device Control API on vm fd */
+#define KVM_ARM_VM_SMCCC_CTRL		0
+#define   KVM_ARM_VM_SMCCC_FILTER	0
+
 /* Device Control API: ARM VGIC */
 #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
 #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
@@ -479,6 +483,13 @@ enum kvm_smccc_filter_action {
 #endif
 };
 
+struct kvm_smccc_filter {
+	__u32 base;
+	__u32 nr_functions;
+	__u8 action;
+	__u8 pad[7];
+};
+
 /* arm64-specific KVM_EXIT_HYPERCALL flags */
 #define KVM_HYPERCALL_EXIT_SMC	(1U << 0)
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1202ac03bee0..efee032c9560 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1444,6 +1444,8 @@ static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
 static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	switch (attr->group) {
+	case KVM_ARM_VM_SMCCC_CTRL:
+		return kvm_vm_smccc_has_attr(kvm, attr);
 	default:
 		return -ENXIO;
 	}
@@ -1452,6 +1454,8 @@ static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 static int kvm_vm_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	switch (attr->group) {
+	case KVM_ARM_VM_SMCCC_CTRL:
+		return kvm_vm_smccc_set_attr(kvm, attr);
 	default:
 		return -ENXIO;
 	}
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 2843c8493c8a..e30c3d59f9d7 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -145,6 +145,42 @@ static void init_smccc_filter(struct kvm *kvm)
 	KVM_BUG_ON(r, kvm);
 }
 
+static int kvm_smccc_set_filter(struct kvm *kvm, struct kvm_smccc_filter __user *uaddr)
+{
+	struct kvm_smccc_filter filter;
+	unsigned long start, end;
+	int r;
+
+	if (copy_from_user(&filter, uaddr, sizeof(filter)))
+		return -EFAULT;
+
+	mutex_lock(&kvm->lock);
+
+	if (kvm_vm_has_ran_once(kvm)) {
+		r = -EBUSY;
+		goto out_unlock;
+	}
+
+	if (!filter.nr_functions || filter.action >= NR_SMCCC_FILTER_ACTIONS) {
+		r = -EINVAL;
+		goto out_unlock;
+	}
+
+	start = filter.base;
+	end = start + filter.nr_functions - 1;
+
+	r = mtree_insert_range(&kvm->arch.smccc_filter, start, end,
+			       xa_mk_value(filter.action), GFP_KERNEL_ACCOUNT);
+	if (r)
+		goto out_unlock;
+
+	set_bit(KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED, &kvm->arch.flags);
+
+out_unlock:
+	mutex_unlock(&kvm->lock);
+	return r;
+}
+
 static u8 kvm_smccc_filter_get_action(struct kvm *kvm, u32 func_id)
 {
 	unsigned long idx = func_id;
@@ -566,3 +602,25 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 
 	return -EINVAL;
 }
+
+int kvm_vm_smccc_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VM_SMCCC_FILTER:
+		return 0;
+	default:
+		return -ENXIO;
+	}
+}
+
+int kvm_vm_smccc_set_attr(struct kvm *kvm, struct kvm_device_attr *attr)
+{
+	void __user *uaddr = (void __user *)attr->addr;
+
+	switch (attr->attr) {
+	case KVM_ARM_VM_SMCCC_FILTER:
+		return kvm_smccc_set_filter(kvm, uaddr);
+	default:
+		return -ENXIO;
+	}
+}
diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
index fe6c31575b05..2df152207ccd 100644
--- a/include/kvm/arm_hypercalls.h
+++ b/include/kvm/arm_hypercalls.h
@@ -49,4 +49,7 @@ int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
 int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
 
+int kvm_vm_smccc_has_attr(struct kvm *kvm, struct kvm_device_attr *attr);
+int kvm_vm_smccc_set_attr(struct kvm *kvm, struct kvm_device_attr *attr);
+
 #endif
-- 
2.40.0.rc1.284.g88254d51c5-goog

