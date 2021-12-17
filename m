Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769D8478FB9
	for <lists+kvm@lfdr.de>; Fri, 17 Dec 2021 16:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238338AbhLQPaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Dec 2021 10:30:16 -0500
Received: from mga03.intel.com ([134.134.136.65]:10848 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238248AbhLQPaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Dec 2021 10:30:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639755008; x=1671291008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xPVjMhggzr8nWrVWkFh3gagm3PUAtIAJrHO2aKIdNkc=;
  b=LmyceBkhd5XmPCnzNvDnqvHnf/sCacxjsudjP0OlecHNcU8H3Li9SohE
   OT4lHeVSabmxU1OBjPlkbVmLY6ZNJfcUyTCeqqeFxUNXLNvWD8O2C/RWu
   h4YQQyMrId1IM/Zvt6SxYhLhbwXWVQCXc+/OqdN5iT63zEe4vUVhBUbNR
   gkIKqEjixSpN2JDHvYedhMiSpWvQnMLtHg4CuVJBCsPyOlpCQQ2BGB4nB
   cxt0xtYqRb2ylXaPnaVE/ICk3kexfAL3+U7TQEQ49Hzs9mGS9mHrk5NS/
   pxOOoqMt3xq6cZbxCujRoUr0hxjgeixiLi+/q6HuD/bjHsW9W+vzgkFpw
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10200"; a="239723470"
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="239723470"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 07:30:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,213,1635231600"; 
   d="scan'208";a="615588468"
Received: from 984fee00a228.jf.intel.com ([10.165.56.59])
  by orsmga004.jf.intel.com with ESMTP; 17 Dec 2021 07:30:06 -0800
From:   Jing Liu <jing2.liu@intel.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, pbonzini@redhat.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com,
        guang.zeng@intel.com, wei.w.wang@intel.com, yang.zhong@intel.com
Subject: [PATCH v2 19/23] kvm: selftests: Add support for KVM_CAP_XSAVE2
Date:   Fri, 17 Dec 2021 07:29:59 -0800
Message-Id: <20211217153003.1719189-20-jing2.liu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211217153003.1719189-1-jing2.liu@intel.com>
References: <20211217153003.1719189-1-jing2.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

When KVM_CAP_XSAVE2 is supported, userspace is expected to allocate
buffer for KVM_GET_XSAVE2 and KVM_SET_XSAVE using the size returned
by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2).

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Signed-off-by: Guang Zeng <guang.zeng@intel.com>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
---
 tools/arch/x86/include/uapi/asm/kvm.h         | 12 ++++-
 tools/include/uapi/linux/kvm.h                |  3 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  2 +
 .../selftests/kvm/include/x86_64/processor.h  | 12 +++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 31 +++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 45 ++++++++++++++++++-
 .../testing/selftests/kvm/x86_64/evmcs_test.c |  2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c |  2 +-
 .../testing/selftests/kvm/x86_64/state_test.c |  2 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c    |  2 +-
 10 files changed, 106 insertions(+), 7 deletions(-)

diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 5a776a08f78c..240e17829e89 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -373,9 +373,19 @@ struct kvm_debugregs {
 	__u64 reserved[9];
 };
 
-/* for KVM_CAP_XSAVE */
+/* for KVM_CAP_XSAVE and KVM_CAP_XSAVE2 */
 struct kvm_xsave {
+	/*
+	 * KVM_GET_XSAVE only uses the first 4096 bytes.
+	 *
+	 * KVM_GET_XSAVE2 must have the size match what is returned by
+	 * KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2).
+	 *
+	 * KVM_SET_XSAVE uses the extra field if guest_fpu::fpstate::size
+	 * exceeds 4096 bytes.
+	 */
 	__u32 region[1024];
+	__u32 extra[0];
 };
 
 #define KVM_MAX_XCRS	16
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 1daa45268de2..f066637ee206 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1131,6 +1131,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_XSAVE2 207
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1551,6 +1552,8 @@ struct kvm_s390_ucas_mapping {
 /* Available with KVM_CAP_XSAVE */
 #define KVM_GET_XSAVE		  _IOR(KVMIO,  0xa4, struct kvm_xsave)
 #define KVM_SET_XSAVE		  _IOW(KVMIO,  0xa5, struct kvm_xsave)
+/* Available with KVM_CAP_XSAVE2 */
+#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
 /* Available with KVM_CAP_XCRS */
 #define KVM_GET_XCRS		  _IOR(KVMIO,  0xa6, struct kvm_xcrs)
 #define KVM_SET_XCRS		  _IOW(KVMIO,  0xa7, struct kvm_xcrs)
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 6a1a37f30494..5d6cbafcb412 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -85,6 +85,7 @@ extern const struct vm_guest_mode_params vm_guest_mode_params[];
 int open_path_or_exit(const char *path, int flags);
 int open_kvm_dev_path_or_exit(void);
 int kvm_check_cap(long cap);
+int vm_check_cap(struct kvm_vm *vm, long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
 int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
 		    struct kvm_enable_cap *cap);
@@ -316,6 +317,7 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
  *   guest_code - The vCPU's entry point
  */
 void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
+void vm_xsave_req_perm(void);
 
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 05e65ca1c30c..0546173ab628 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -10,8 +10,10 @@
 
 #include <assert.h>
 #include <stdint.h>
+#include <syscall.h>
 
 #include <asm/msr-index.h>
+#include <asm/prctl.h>
 
 #include "../kvm_util.h"
 
@@ -352,6 +354,7 @@ struct kvm_x86_state;
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
 		     struct kvm_x86_state *state);
+void kvm_x86_state_cleanup(struct kvm_x86_state *state);
 
 struct kvm_msr_list *kvm_get_msr_index_list(void);
 uint64_t kvm_get_feature_msr(uint64_t msr_index);
@@ -443,4 +446,13 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 /* VMX_EPT_VPID_CAP bits */
 #define VMX_EPT_VPID_CAP_AD_BITS       (1ULL << 21)
 
+#define XSTATE_LEGACY_SIZE		4096
+
+#define XSTATE_XTILE_CFG_BIT		17
+#define XSTATE_XTILE_DATA_BIT		18
+
+#define XSTATE_XTILE_CFG_MASK		(1ULL << XSTATE_XTILE_CFG_BIT)
+#define XSTATE_XTILE_DATA_MASK		(1ULL << XSTATE_XTILE_DATA_BIT)
+#define XFEATURE_XTILE_MASK		(XSTATE_XTILE_CFG_MASK | \
+					XSTATE_XTILE_DATA_MASK)
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8f2e0bb1ef96..dc4ae30b7caf 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -85,6 +85,33 @@ int kvm_check_cap(long cap)
 	return ret;
 }
 
+/* VM Check Capability
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   cap - Capability
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   On success, the Value corresponding to the capability (KVM_CAP_*)
+ *   specified by the value of cap.  On failure a TEST_ASSERT failure
+ *   is produced.
+ *
+ * Looks up and returns the value corresponding to the capability
+ * (KVM_CAP_*) given by cap.
+ */
+int vm_check_cap(struct kvm_vm *vm, long cap)
+{
+	int ret;
+
+	ret = ioctl(vm->fd, KVM_CHECK_EXTENSION, cap);
+	TEST_ASSERT(ret >= 0, "KVM_CHECK_EXTENSION VM IOCTL failed,\n"
+		"  rc: %i errno: %i", ret, errno);
+
+	return ret;
+}
+
 /* VM Enable Capability
  *
  * Input Args:
@@ -370,6 +397,10 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 #ifdef __x86_64__
 	vm_create_irqchip(vm);
 #endif
+	/*
+	 * Permission needs to be requested before KVM_SET_CPUID2.
+	 */
+	vm_xsave_req_perm();
 
 	for (i = 0; i < nr_vcpus; ++i) {
 		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 82c39db91369..00324d73c687 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -650,6 +650,25 @@ static void vcpu_setup(struct kvm_vm *vm, int vcpuid)
 	vcpu_sregs_set(vm, vcpuid, &sregs);
 }
 
+void vm_xsave_req_perm(void)
+{
+	unsigned long bitmask;
+	long rc = syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM,
+			  XSTATE_XTILE_DATA_BIT);
+	/*
+	 * The older kernel version(<5.15) can't support
+	 * ARCH_REQ_XCOMP_GUEST_PERM and directly return.
+	 */
+	if (rc)
+		return;
+
+	rc = syscall(SYS_arch_prctl, ARCH_GET_XCOMP_GUEST_PERM, &bitmask);
+	TEST_ASSERT(rc == 0, "prctl(ARCH_GET_XCOMP_GUEST_PERM) error: %ld", rc);
+	TEST_ASSERT(bitmask & XFEATURE_XTILE_MASK,
+		    "prctl(ARCH_REQ_XCOMP_GUEST_PERM) failure bitmask=0x%lx",
+		    bitmask);
+}
+
 void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 {
 	struct kvm_mp_state mp_state;
@@ -1018,10 +1037,10 @@ void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 }
 
 struct kvm_x86_state {
+	struct kvm_xsave *xsave;
 	struct kvm_vcpu_events events;
 	struct kvm_mp_state mp_state;
 	struct kvm_regs regs;
-	struct kvm_xsave xsave;
 	struct kvm_xcrs xcrs;
 	struct kvm_sregs sregs;
 	struct kvm_debugregs debugregs;
@@ -1069,6 +1088,22 @@ struct kvm_msr_list *kvm_get_msr_index_list(void)
 	return list;
 }
 
+static int vcpu_save_xsave_state(struct kvm_vm *vm, struct vcpu *vcpu,
+				 struct kvm_x86_state *state)
+{
+	int size;
+
+	size = vm_check_cap(vm, KVM_CAP_XSAVE2);
+	if (!size)
+		size = XSTATE_LEGACY_SIZE;
+
+	state->xsave = malloc(size);
+	if (size == XSTATE_LEGACY_SIZE)
+		return ioctl(vcpu->fd, KVM_GET_XSAVE, state->xsave);
+	else
+		return ioctl(vcpu->fd, KVM_GET_XSAVE2, state->xsave);
+}
+
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
@@ -1112,7 +1147,7 @@ struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid)
         TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_REGS, r: %i",
                 r);
 
-	r = ioctl(vcpu->fd, KVM_GET_XSAVE, &state->xsave);
+	r = vcpu_save_xsave_state(vm, vcpu, state);
         TEST_ASSERT(r == 0, "Unexpected result from KVM_GET_XSAVE, r: %i",
                 r);
 
@@ -1198,6 +1233,12 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
 	}
 }
 
+void kvm_x86_state_cleanup(struct kvm_x86_state *state)
+{
+	free(state->xsave);
+	free(state);
+}
+
 bool is_intel_cpu(void)
 {
 	int eax, ebx, ecx, edx;
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 2b46dcca86a8..4c7841dfd481 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -129,7 +129,7 @@ static void save_restore_vm(struct kvm_vm *vm)
 	vcpu_set_hv_cpuid(vm, VCPU_ID);
 	vcpu_enable_evmcs(vm, VCPU_ID);
 	vcpu_load_state(vm, VCPU_ID, state);
-	free(state);
+	kvm_x86_state_cleanup(state);
 
 	memset(&regs2, 0, sizeof(regs2));
 	vcpu_regs_get(vm, VCPU_ID, &regs2);
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index d0fe2fdce58c..2da8eb8e2d96 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -212,7 +212,7 @@ int main(int argc, char *argv[])
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
-		free(state);
+		kvm_x86_state_cleanup(state);
 	}
 
 done:
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 32854c1462ad..2e0a92da8ff5 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -218,7 +218,7 @@ int main(int argc, char *argv[])
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
-		free(state);
+		kvm_x86_state_cleanup(state);
 
 		memset(&regs2, 0, sizeof(regs2));
 		vcpu_regs_get(vm, VCPU_ID, &regs2);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
index a07480aed397..ff92e25b6f1e 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_preemption_timer_test.c
@@ -244,7 +244,7 @@ int main(int argc, char *argv[])
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
-		free(state);
+		kvm_x86_state_cleanup(state);
 
 		memset(&regs2, 0, sizeof(regs2));
 		vcpu_regs_get(vm, VCPU_ID, &regs2);
-- 
2.27.0

