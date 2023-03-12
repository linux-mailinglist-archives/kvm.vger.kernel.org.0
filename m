Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9412F6B6483
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjCLJ6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCLJ60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:58:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0E455079
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615057; x=1710151057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G0tlEaWv3qO1oSU2IzDf4JpCNFHIe0WpsObv3Cnape8=;
  b=lO5ri6spqmQ0lUCBbY4bxL3jgmdA5HqKXK43Nm+N6ZCWtlLLf+MF8yar
   vASAUEIQi8ioba0J+gRgw5bB4Uu5L1hrzhrz5qn0K/ldcE08tpmiyssq2
   lG3oeNG7YlHGVpPznMXNdboSDTHIbutL8vBqd/rJ8L1ipnTCUHA4b+CnD
   ZdpkX2mesJj8dmCBByR6u3q3qwwkBN7LtHTP9xajnPzLWP1O1834CQ7gN
   IV1iI5Dl16aPPo1bu/LRyesbYB9YEtNOhsTgnRlQaKFSjTvhuyfVoQK7s
   q0oyB1N15FPmy4elqGV81APTcytz9MeeccJdxFMIuJ8dU6n7nABmeQSAl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="336998101"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="336998101"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="680677665"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="680677665"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:13 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-5 05/22] pkvm: x86: Add hypercalls for shadow_vm/vcpu init & teardown
Date:   Mon, 13 Mar 2023 02:02:46 +0800
Message-Id: <20230312180303.1778492-6-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180303.1778492-1-jason.cj.chen@intel.com>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Host VM is able to create and launch its guest based on virtual VMX and
virtual EPT. pKVM is expected to provide necessary emulations (e.g.
VMX, EPT) for corresponding guest vcpu, introduce data structure
pkvm_shadow_vm & shadow_vcpu_state to manage/maintain the state &
information for such emulation of each guest vm/vcpu.

shadow_vm_handle is used as the identifier for a specific shadow vm
created by host VM, it links to the pointer of pkvm_shadow_vm for this
shadow vm, which followed by a pkvm_shadow_vcpu array corresponding to
the created vcpus for this vm.

The shadow vm/vcpus data structure for a specific vm is allocated by
host VM during its initialization, then pass to pKVM through new added
hypercalls PKVM_HC_INIT_SHADOW_VM & PKVM_HC_INIT_SHADOW_VCPU. Meanwhile
hypercalls PKVM_HC_TEARDOWN_SHADOW_VM & PKVM_HC_TEARDOWN_SHADOW_VCPU
are used by host VM when it wants to teardown a created vm.

In the future, after supporting page ownership management in pKVM,
these shadow vm/vcpus data structure pages shall be donated from host VM
to pKVM when target vm init, and be un-donated from pKVM to host
VM when this vm teardown, through the hypercalls mentioned above.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 arch/x86/include/asm/kvm_pkvm.h      |   4 +
 arch/x86/kvm/vmx/pkvm/hyp/Makefile   |   3 +
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c     | 297 +++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h |  70 +++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmexit.c   |  13 ++
 5 files changed, 387 insertions(+)

diff --git a/arch/x86/include/asm/kvm_pkvm.h b/arch/x86/include/asm/kvm_pkvm.h
index 0142b3dc3c01..6e8fee717e5d 100644
--- a/arch/x86/include/asm/kvm_pkvm.h
+++ b/arch/x86/include/asm/kvm_pkvm.h
@@ -16,6 +16,10 @@
 
 /* PKVM Hypercalls */
 #define PKVM_HC_INIT_FINALISE		1
+#define PKVM_HC_INIT_SHADOW_VM		2
+#define PKVM_HC_INIT_SHADOW_VCPU	3
+#define PKVM_HC_TEARDOWN_SHADOW_VM	4
+#define PKVM_HC_TEARDOWN_SHADOW_VCPU	5
 
 extern struct memblock_region pkvm_sym(hyp_memory)[];
 extern unsigned int pkvm_sym(hyp_memblock_nr);
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index 9c410ec96f45..7c6f71f18676 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -16,8 +16,11 @@ pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o \
 
 ifndef CONFIG_PKVM_INTEL_DEBUG
 lib-dir		:= lib
+lib2-dir	:= ../../../../../../lib
 pkvm-hyp-y	+= $(lib-dir)/memset_64.o
 pkvm-hyp-y	+= $(lib-dir)/memcpy_64.o
+pkvm-hyp-y	+= $(lib2-dir)/find_bit.o
+pkvm-hyp-y	+= $(lib2-dir)/hweight.o
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
 pkvm-hyp-$(CONFIG_DEBUG_LIST)	+= $(lib-dir)/list_debug.o
 endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
index a5f776195af6..b110ac43a792 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
@@ -5,4 +5,301 @@
 
 #include <pkvm.h>
 
+#include "pkvm_hyp.h"
+
 struct pkvm_hyp *pkvm_hyp;
+
+#define MAX_SHADOW_VMS	255
+#define HANDLE_OFFSET 1
+
+#define to_shadow_vm_handle(vcpu_handle)	((s64)(vcpu_handle) >> SHADOW_VM_HANDLE_SHIFT)
+#define to_shadow_vcpu_idx(vcpu_handle)		((s64)(vcpu_handle) & SHADOW_VCPU_INDEX_MASK)
+
+static DECLARE_BITMAP(shadow_vms_bitmap, MAX_SHADOW_VMS);
+static pkvm_spinlock_t shadow_vms_lock = __PKVM_SPINLOCK_UNLOCKED;
+struct shadow_vm_ref {
+	atomic_t refcount;
+	struct pkvm_shadow_vm *vm;
+};
+static struct shadow_vm_ref shadow_vms_ref[MAX_SHADOW_VMS];
+
+#define SHADOW_VCPU_ARRAY(vm) \
+	((struct shadow_vcpu_array *)((void *)(vm) + sizeof(struct pkvm_shadow_vm)))
+
+static int allocate_shadow_vm_handle(struct pkvm_shadow_vm *vm)
+{
+	struct shadow_vm_ref *vm_ref;
+	int handle;
+
+	/* The shadow_vm_handle is an int so cannot exceed the INT_MAX */
+	BUILD_BUG_ON(MAX_SHADOW_VMS > INT_MAX);
+
+	pkvm_spin_lock(&shadow_vms_lock);
+
+	handle = find_next_zero_bit(shadow_vms_bitmap, MAX_SHADOW_VMS,
+				    HANDLE_OFFSET);
+	if ((u32)handle < MAX_SHADOW_VMS) {
+		__set_bit(handle, shadow_vms_bitmap);
+		vm->shadow_vm_handle = handle;
+		vm_ref = &shadow_vms_ref[handle];
+		vm_ref->vm = vm;
+		atomic_set(&vm_ref->refcount, 1);
+	} else
+		handle = -ENOMEM;
+
+	pkvm_spin_unlock(&shadow_vms_lock);
+
+	return handle;
+}
+
+static struct pkvm_shadow_vm *free_shadow_vm_handle(int handle)
+{
+	struct shadow_vm_ref *vm_ref;
+	struct pkvm_shadow_vm *vm = NULL;
+
+	pkvm_spin_lock(&shadow_vms_lock);
+
+	if ((u32)handle >= MAX_SHADOW_VMS)
+		goto out;
+
+	vm_ref = &shadow_vms_ref[handle];
+	if ((atomic_cmpxchg(&vm_ref->refcount, 1, 0) != 1)) {
+		pkvm_err("%s: VM%d is busy, refcount %d\n",
+			 __func__, handle, atomic_read(&vm_ref->refcount));
+		goto out;
+	}
+
+	vm = vm_ref->vm;
+
+	vm_ref->vm = NULL;
+	__clear_bit(handle, shadow_vms_bitmap);
+out:
+	pkvm_spin_unlock(&shadow_vms_lock);
+	return vm;
+}
+
+int __pkvm_init_shadow_vm(unsigned long kvm_va,
+			  unsigned long shadow_pa,
+			  size_t shadow_size)
+{
+	struct pkvm_shadow_vm *vm;
+
+	if (!PAGE_ALIGNED(shadow_pa) ||
+		!PAGE_ALIGNED(shadow_size) ||
+		(shadow_size != PAGE_ALIGN(sizeof(struct pkvm_shadow_vm)
+					   + pkvm_shadow_vcpu_array_size())))
+		return -EINVAL;
+
+	vm = pkvm_phys_to_virt(shadow_pa);
+
+	memset(vm, 0, shadow_size);
+	pkvm_spin_lock_init(&vm->lock);
+
+	vm->host_kvm_va = kvm_va;
+	return allocate_shadow_vm_handle(vm);
+}
+
+unsigned long __pkvm_teardown_shadow_vm(int shadow_vm_handle)
+{
+	struct pkvm_shadow_vm *vm = free_shadow_vm_handle(shadow_vm_handle);
+
+	if (!vm)
+		return 0;
+
+	memset(vm, 0, sizeof(struct pkvm_shadow_vm) + pkvm_shadow_vcpu_array_size());
+
+	return pkvm_virt_to_phys(vm);
+}
+
+static struct pkvm_shadow_vm *get_shadow_vm(int shadow_vm_handle)
+{
+	struct shadow_vm_ref *vm_ref;
+
+	if ((u32)shadow_vm_handle >= MAX_SHADOW_VMS)
+		return NULL;
+
+	vm_ref = &shadow_vms_ref[shadow_vm_handle];
+	return atomic_inc_not_zero(&vm_ref->refcount) ? vm_ref->vm : NULL;
+}
+
+static void put_shadow_vm(int shadow_vm_handle)
+{
+	struct shadow_vm_ref *vm_ref;
+
+	if ((u32)shadow_vm_handle >= MAX_SHADOW_VMS)
+		return;
+
+	vm_ref = &shadow_vms_ref[shadow_vm_handle];
+	WARN_ON(atomic_dec_if_positive(&vm_ref->refcount) <= 0);
+}
+
+struct shadow_vcpu_state *get_shadow_vcpu(s64 shadow_vcpu_handle)
+{
+	int shadow_vm_handle = to_shadow_vm_handle(shadow_vcpu_handle);
+	u32 vcpu_idx = to_shadow_vcpu_idx(shadow_vcpu_handle);
+	struct shadow_vcpu_ref *vcpu_ref;
+	struct shadow_vcpu_state *vcpu;
+	struct pkvm_shadow_vm *vm;
+
+	if (vcpu_idx >= KVM_MAX_VCPUS)
+		return NULL;
+
+	vm = get_shadow_vm(shadow_vm_handle);
+	if (!vm)
+		return NULL;
+
+	vcpu_ref = &SHADOW_VCPU_ARRAY(vm)->ref[vcpu_idx];
+	vcpu = atomic_inc_not_zero(&vcpu_ref->refcount) ? vcpu_ref->vcpu : NULL;
+
+	put_shadow_vm(shadow_vm_handle);
+	return vcpu;
+}
+
+void put_shadow_vcpu(s64 shadow_vcpu_handle)
+{
+	int shadow_vm_handle = to_shadow_vm_handle(shadow_vcpu_handle);
+	u32 vcpu_idx = to_shadow_vcpu_idx(shadow_vcpu_handle);
+	struct shadow_vcpu_ref *vcpu_ref;
+	struct pkvm_shadow_vm *vm;
+
+	if (vcpu_idx >= KVM_MAX_VCPUS)
+		return;
+
+	vm = get_shadow_vm(shadow_vm_handle);
+	if (!vm)
+		return;
+
+	vcpu_ref = &SHADOW_VCPU_ARRAY(vm)->ref[vcpu_idx];
+	WARN_ON(atomic_dec_if_positive(&vcpu_ref->refcount) <= 0);
+
+	put_shadow_vm(shadow_vm_handle);
+}
+
+static s64 attach_shadow_vcpu_to_vm(struct pkvm_shadow_vm *vm,
+				    struct shadow_vcpu_state *shadow_vcpu)
+{
+	struct shadow_vcpu_ref *vcpu_ref;
+	u32 vcpu_idx;
+
+	/*
+	 * Shadow_vcpu_handle is a s64 value combined with shadow_vm_handle
+	 * and shadow_vcpu index from the array. So the array size cannot be
+	 * larger than the shadow_vcpu index mask.
+	 */
+	BUILD_BUG_ON(KVM_MAX_VCPUS > SHADOW_VCPU_INDEX_MASK);
+
+	/*
+	 * Save a shadow_vm pointer in shadow_vcpu requires additional
+	 * get so that later when use this pointer at runtime no need
+	 * to get again. This will be put when detaching this shadow_vcpu.
+	 */
+	shadow_vcpu->vm = get_shadow_vm(vm->shadow_vm_handle);
+	if (!shadow_vcpu->vm)
+		return -EINVAL;
+
+	pkvm_spin_lock(&vm->lock);
+
+	if (vm->created_vcpus == KVM_MAX_VCPUS) {
+		pkvm_spin_unlock(&vm->lock);
+		return -EINVAL;
+	}
+
+	vcpu_idx = vm->created_vcpus;
+	shadow_vcpu->shadow_vcpu_handle =
+		to_shadow_vcpu_handle(vm->shadow_vm_handle, vcpu_idx);
+	vcpu_ref = &SHADOW_VCPU_ARRAY(vm)->ref[vcpu_idx];
+	vcpu_ref->vcpu = shadow_vcpu;
+	vm->created_vcpus++;
+	atomic_set(&vcpu_ref->refcount, 1);
+
+	pkvm_spin_unlock(&vm->lock);
+
+	return shadow_vcpu->shadow_vcpu_handle;
+}
+
+static struct shadow_vcpu_state *
+detach_shadow_vcpu_from_vm(struct pkvm_shadow_vm *vm, s64 shadow_vcpu_handle)
+{
+	u32 vcpu_idx = to_shadow_vcpu_idx(shadow_vcpu_handle);
+	struct shadow_vcpu_state *shadow_vcpu = NULL;
+	struct shadow_vcpu_ref *vcpu_ref;
+
+	if (vcpu_idx >= KVM_MAX_VCPUS)
+		return NULL;
+
+	pkvm_spin_lock(&vm->lock);
+
+	vcpu_ref = &SHADOW_VCPU_ARRAY(vm)->ref[vcpu_idx];
+	if ((atomic_cmpxchg(&vcpu_ref->refcount, 1, 0) != 1)) {
+		pkvm_err("%s: VM%d shadow_vcpu%d is busy, refcount %d\n",
+			 __func__, vm->shadow_vm_handle, vcpu_idx,
+			 atomic_read(&vcpu_ref->refcount));
+	} else {
+		shadow_vcpu = vcpu_ref->vcpu;
+		vcpu_ref->vcpu = NULL;
+	}
+
+	pkvm_spin_unlock(&vm->lock);
+
+	if (shadow_vcpu)
+		/*
+		 * Paired with the get_shadow_vm when saving the shadow_vm pointer
+		 * during attaching shadow_vcpu.
+		 */
+		put_shadow_vm(shadow_vcpu->vm->shadow_vm_handle);
+
+	return shadow_vcpu;
+}
+
+s64 __pkvm_init_shadow_vcpu(struct kvm_vcpu *hvcpu, int shadow_vm_handle,
+			    unsigned long vcpu_va, unsigned long shadow_pa,
+			    size_t shadow_size)
+{
+	struct pkvm_shadow_vm *vm;
+	struct shadow_vcpu_state *shadow_vcpu;
+	struct x86_exception e;
+	s64 shadow_vcpu_handle;
+	int ret;
+
+	if (!PAGE_ALIGNED(shadow_pa) || !PAGE_ALIGNED(shadow_size) ||
+		(shadow_size != PAGE_ALIGN(sizeof(struct shadow_vcpu_state))) ||
+		(pkvm_hyp->vmcs_config.size > PAGE_SIZE))
+		return -EINVAL;
+
+	shadow_vcpu = pkvm_phys_to_virt(shadow_pa);
+	memset(shadow_vcpu, 0, shadow_size);
+
+	ret = read_gva(hvcpu, vcpu_va, &shadow_vcpu->vmx, sizeof(struct vcpu_vmx), &e);
+	if (ret < 0)
+		return -EINVAL;
+
+	vm = get_shadow_vm(shadow_vm_handle);
+	if (!vm)
+		return -EINVAL;
+
+	shadow_vcpu_handle = attach_shadow_vcpu_to_vm(vm, shadow_vcpu);
+
+	put_shadow_vm(shadow_vm_handle);
+
+	return shadow_vcpu_handle;
+}
+
+unsigned long __pkvm_teardown_shadow_vcpu(s64 shadow_vcpu_handle)
+{
+	int shadow_vm_handle = to_shadow_vm_handle(shadow_vcpu_handle);
+	struct shadow_vcpu_state *shadow_vcpu;
+	struct pkvm_shadow_vm *vm = get_shadow_vm(shadow_vm_handle);
+
+	if (!vm)
+		return 0;
+
+	shadow_vcpu = detach_shadow_vcpu_from_vm(vm, shadow_vcpu_handle);
+
+	put_shadow_vm(shadow_vm_handle);
+
+	if (!shadow_vcpu)
+		return 0;
+
+	memset(shadow_vcpu, 0, sizeof(struct shadow_vcpu_state));
+	return pkvm_virt_to_phys(shadow_vcpu);
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
index e84296a714a2..f15a49b3be5d 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
@@ -5,6 +5,76 @@
 #ifndef __PKVM_HYP_H
 #define __PKVM_HYP_H
 
+#include <asm/pkvm_spinlock.h>
+
+/*
+ * A container for the vcpu state that hyp needs to maintain for protected VMs.
+ */
+struct shadow_vcpu_state {
+	/*
+	 * A unique id to the shadow vcpu, which is combined by
+	 * shadow_vm_handle and shadow_vcpu index in the array.
+	 * As shadow_vm_handle is in the high end and it is an
+	 * int, so define the shadow_vcpu_handle as a s64.
+	 */
+	s64 shadow_vcpu_handle;
+
+	struct pkvm_shadow_vm *vm;
+
+	struct vcpu_vmx vmx;
+} __aligned(PAGE_SIZE);
+
+#define SHADOW_VM_HANDLE_SHIFT		32
+#define SHADOW_VCPU_INDEX_MASK		((1UL << SHADOW_VM_HANDLE_SHIFT) - 1)
+#define to_shadow_vcpu_handle(vm_handle, vcpu_idx)		\
+		(((s64)(vm_handle) << SHADOW_VM_HANDLE_SHIFT) | \
+		 ((vcpu_idx) & SHADOW_VCPU_INDEX_MASK))
+
+/*
+ * Shadow_vcpu_array will be appended to the end of the pkvm_shadow_vm area
+ * implicitly, so that the shadow_vcpu_state pointer cannot be got directly
+ * from the pkvm_shadow_vm, but needs to be done through the interface
+ * get/put_shadow_vcpu. This can prevent the shadow_vcpu_state pointer from
+ * being abused without getting/putting the refcount.
+ */
+struct shadow_vcpu_array {
+	struct shadow_vcpu_ref {
+		atomic_t refcount;
+		struct shadow_vcpu_state *vcpu;
+	} ref[KVM_MAX_VCPUS];
+} __aligned(PAGE_SIZE);
+
+static inline size_t pkvm_shadow_vcpu_array_size(void)
+{
+	return sizeof(struct shadow_vcpu_array);
+}
+
+/*
+ * Holds the relevant data for running a protected vm.
+ */
+struct pkvm_shadow_vm {
+	/* A unique id to the shadow structs in the hyp shadow area. */
+	int shadow_vm_handle;
+
+	/* Number of vcpus for the vm. */
+	int created_vcpus;
+
+	/* The host's kvm va. */
+	unsigned long host_kvm_va;
+
+	pkvm_spinlock_t lock;
+} __aligned(PAGE_SIZE);
+
+int __pkvm_init_shadow_vm(unsigned long kvm_va, unsigned long shadow_pa,
+			  size_t shadow_size);
+unsigned long __pkvm_teardown_shadow_vm(int shadow_vm_handle);
+s64 __pkvm_init_shadow_vcpu(struct kvm_vcpu *hvcpu, int shadow_vm_handle,
+			    unsigned long vcpu_va, unsigned long shadow_pa,
+			    size_t shadow_size);
+unsigned long __pkvm_teardown_shadow_vcpu(s64 shadow_vcpu_handle);
+struct shadow_vcpu_state *get_shadow_vcpu(s64 shadow_vcpu_handle);
+void put_shadow_vcpu(s64 shadow_vcpu_handle);
+
 extern struct pkvm_hyp *pkvm_hyp;
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
index 02224d93384a..6b82b6be612c 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmexit.c
@@ -8,6 +8,7 @@
 #include <pkvm.h>
 #include "vmexit.h"
 #include "ept.h"
+#include "pkvm_hyp.h"
 #include "debug.h"
 
 #define CR4	4
@@ -88,6 +89,18 @@ static unsigned long handle_vmcall(struct kvm_vcpu *vcpu)
 	case PKVM_HC_INIT_FINALISE:
 		__pkvm_init_finalise(vcpu, a0, a1);
 		break;
+	case PKVM_HC_INIT_SHADOW_VM:
+		ret = __pkvm_init_shadow_vm(a0, a1, a2);
+		break;
+	case PKVM_HC_INIT_SHADOW_VCPU:
+		ret = __pkvm_init_shadow_vcpu(vcpu, a0, a1, a2, a3);
+		break;
+	case PKVM_HC_TEARDOWN_SHADOW_VM:
+		ret = __pkvm_teardown_shadow_vm(a0);
+		break;
+	case PKVM_HC_TEARDOWN_SHADOW_VCPU:
+		ret = __pkvm_teardown_shadow_vcpu(a0);
+		break;
 	default:
 		ret = -EINVAL;
 	}
-- 
2.25.1

