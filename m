Return-Path: <kvm+bounces-34210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9150C9F8E6A
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 09:58:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1813160486
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 08:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC101A9B48;
	Fri, 20 Dec 2024 08:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iW5ftIgB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F1E1A707D;
	Fri, 20 Dec 2024 08:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734685090; cv=none; b=ZOxDijqKoNOOjvFW10siU7EDQigzHNkSQ3YQmk/EY26DiljbWn5JQmUJ/1MRxJlMD+5IORUoLCmvtfmLFQ7+Hm30Un0pIrtkVL2YvptnGtEWq6GfZqSIVVgjIz/X9eet6776pJ9d/4k0bOdVcGSoNB53ZJUiuwDRQQEWvvIltUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734685090; c=relaxed/simple;
	bh=2M1ZKDHj1ahtpOdevTF1TPstBMgTAUOSLTlSFITzBis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri0SXy36zEALGZfLwJ0pjDAqihsb+T3gpFexYLuudHbaGVsyVwxwPS6mJWLSHx/6c+tqeFbaJz6dJlApg3FP1WLpxV8FfC63H0sSgdwRwCpx1QQTO0mDuVy20xK2vh8T33xf8fzbljTcGYpsiAgVlHAGVaPBgYdEA0BmEduVJVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iW5ftIgB; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734685088; x=1766221088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2M1ZKDHj1ahtpOdevTF1TPstBMgTAUOSLTlSFITzBis=;
  b=iW5ftIgBT7gdQcr0nUu9Wb7x/yin7oV/+NP7B47KIu3X7faxLTGLOT8B
   pOyDgsndQLJ/OPB9P/R5mBfCD0EeYiNOWckaDGcdbcjmfkhkB63x49AGQ
   /yGMvpR/YE/JXjKgvkEa5JW2ATYWKNyYieWzya4/HF5nTSZ1HUb4hUSdd
   QxuWq4kTdiF+8XALJAQhAUBfHYNSlpmiOEbT/TITQMYN5HrbHXAn51h6u
   Sb2fbB60XXqINwG+xbLkE45VpOP6FSkFa9TZEb0/hKwtwmFEaOkzn0EVL
   f4LqmDjgZi65AwJWlCREhxTMCClBK6WCygGuhXzVjFH6Bvc6rPiD8S/r3
   w==;
X-CSE-ConnectionGUID: KFROoET5RUCe+CEtMlpnZg==
X-CSE-MsgGUID: u85kcWxYSUuLO5cvKYj1fw==
X-IronPort-AV: E=McAfee;i="6700,10204,11291"; a="60610846"
X-IronPort-AV: E=Sophos;i="6.12,250,1728975600"; 
   d="scan'208";a="60610846"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 00:58:08 -0800
X-CSE-ConnectionGUID: +AsmofAeRIWJc6Bq//PSNg==
X-CSE-MsgGUID: Qgz7xLTTTqKYFqD9qVpvUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="98284698"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 00:58:05 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: peterx@redhat.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 2/2] KVM: selftests: TDX: Test dirty ring on a gmemfd slot
Date: Fri, 20 Dec 2024 16:23:46 +0800
Message-ID: <20241220082346.15914-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241220082027.15851-1-yan.y.zhao@intel.com>
References: <20241220082027.15851-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Slots with the KVM_MEM_GUEST_MEMFD flag do not support dirty bit tracking.
However, it is still possible for userspace to trigger the resetting of the
dirty ring, asking KVM to reset SPTEs in the mirror root by clearing the
accessed bit or write bit.

Test this to ensure that TDs are not negatively impacted.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/x86_64/tdx_dirty_ring.c     | 231 ++++++++++++++++++
 2 files changed, 232 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/tdx_dirty_ring.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 46fd2194add3..46ee465a0443 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -157,6 +157,7 @@ TEST_GEN_PROGS_x86_64 += pre_fault_memory_test
 TEST_GEN_PROGS_x86_64 += x86_64/tdx_vm_tests
 TEST_GEN_PROGS_x86_64 += x86_64/tdx_shared_mem_test
 TEST_GEN_PROGS_x86_64 += x86_64/tdx_upm_test
+TEST_GEN_PROGS_x86_64 += x86_64/tdx_dirty_ring
 
 # Compiled outputs used by test targets
 TEST_GEN_PROGS_EXTENDED_x86_64 += x86_64/nx_huge_pages_test
diff --git a/tools/testing/selftests/kvm/x86_64/tdx_dirty_ring.c b/tools/testing/selftests/kvm/x86_64/tdx_dirty_ring.c
new file mode 100644
index 000000000000..ffeb0a2a70aa
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/tdx_dirty_ring.c
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <signal.h>
+
+#include <asm/barrier.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "tdx/tdcall.h"
+#include "tdx/tdx.h"
+#include "tdx/tdx_util.h"
+#include "tdx/test_util.h"
+#include "test_util.h"
+
+#define TDX_TEST_DIRTY_RING_GPA (0xc0400000)
+#define TDX_TEST_DIRTY_RING_GVA (0x90400000)
+#define TDX_TEST_DIRTY_RING_REGION_SLOT 11
+#define TDX_TEST_DIRTY_RING_REGION_SIZE 0x200000
+
+#define TDX_TEST_DIRTY_RING_REPORT_PORT 0x50
+#define TDX_TEST_DIRTY_RING_REPORT_SIZE 4
+#define TDX_TEST_DIRTY_RING_COUNT 256
+#define TDX_TEST_DIRTY_RING_GUEST_WRITE_MAX_CNT 3
+
+static int reset_index;
+
+/*
+ * Write to a private GPA in a guest_memfd slot.
+ * Exit to host after each write to allow host to check dirty ring.
+ */
+void guest_code_dirty_gpa(void)
+{
+	uint64_t count = 0;
+
+	while (count <= TDX_TEST_DIRTY_RING_GUEST_WRITE_MAX_CNT) {
+		count++;
+		memset((void *)TDX_TEST_DIRTY_RING_GVA, 1, 8);
+		tdg_vp_vmcall_instruction_io(TDX_TEST_DIRTY_RING_REPORT_PORT,
+					     TDX_TEST_DIRTY_RING_REPORT_SIZE,
+					     TDG_VP_VMCALL_INSTRUCTION_IO_WRITE,
+					     &count);
+	}
+	tdx_test_success();
+}
+
+/*
+ * Verify that KVM_MEM_LOG_DIRTY_PAGES cannot be set on a memslot with flag
+ * KVM_MEM_GUEST_MEMFD.
+ */
+static void verify_turn_on_log_dirty_pages_flag(struct kvm_vcpu *vcpu)
+{
+	struct userspace_mem_region *region;
+	int ret;
+
+	region = memslot2region(vcpu->vm, TDX_TEST_DIRTY_RING_REGION_SLOT);
+	region->region.flags |= KVM_MEM_LOG_DIRTY_PAGES;
+
+	ret = __vm_ioctl(vcpu->vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
+
+	TEST_ASSERT(ret, "KVM_SET_USER_MEMORY_REGION2 incorrectly succeeds\n"
+		    "ret: %i errno: %i slot: %u new_flags: 0x%x",
+		    ret, errno, region->region.slot, region->region.flags);
+	region->region.flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
+}
+
+static inline bool dirty_gfn_is_dirtied(struct kvm_dirty_gfn *gfn)
+{
+	return smp_load_acquire(&gfn->flags) == KVM_DIRTY_GFN_F_DIRTY;
+}
+
+static inline void dirty_gfn_set_collected(struct kvm_dirty_gfn *gfn)
+{
+	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_RESET);
+}
+
+static bool dirty_ring_empty(struct kvm_vcpu *vcpu)
+{
+	struct kvm_dirty_gfn *dirty_gfns = vcpu_map_dirty_ring(vcpu);
+	struct kvm_dirty_gfn *cur;
+	int i;
+
+	for (i = 0; i < TDX_TEST_DIRTY_RING_COUNT; i++) {
+		cur = &dirty_gfns[i];
+
+		if (dirty_gfn_is_dirtied(cur))
+			return false;
+	}
+	return true;
+}
+
+/*
+ * Purposely reset the dirty ring incorrectly by resetting a dirty ring entry
+ * even when KVM does not report the entry as dirty.
+ *
+ * In the entry, a slot with flag KVM_MEM_GUEST_MEMFD (which does not allow
+ * dirty page tracking) is specified.
+ *
+ * This is to verify that userspace cannot do anything wrong to cause entries
+ * in private EPT get zapped (caused by incorrect write permission reduction).
+ */
+static void reset_dirty_ring(struct kvm_vcpu *vcpu)
+{
+	struct kvm_dirty_gfn *dirty_gfns = vcpu_map_dirty_ring(vcpu);
+	struct kvm_dirty_gfn *cur = &dirty_gfns[reset_index];
+	uint32_t cleared;
+
+	cur->slot = TDX_TEST_DIRTY_RING_REGION_SLOT;
+	cur->offset = 0;
+	dirty_gfn_set_collected(cur);
+	cleared = kvm_vm_reset_dirty_ring(vcpu->vm);
+	reset_index += cleared;
+
+	TEST_ASSERT(cleared == 1, "Unexpected cleared count %d\n", cleared);
+}
+
+/*
+ * The vCPU worker to loop vcpu_run(). After each vCPU access to a GFN, check if
+ * the dirty ring is empty and reset the dirty ring.
+ */
+static void reset_dirty_ring_worker(struct kvm_vcpu *vcpu)
+{
+	while (1) {
+		vcpu_run(vcpu);
+
+		if (vcpu->run->exit_reason == KVM_EXIT_IO &&
+		    vcpu->run->io.port == TDX_TEST_SUCCESS_PORT &&
+		    vcpu->run->io.size == TDX_TEST_SUCCESS_SIZE &&
+		    vcpu->run->io.direction == TDG_VP_VMCALL_INSTRUCTION_IO_WRITE)
+			break;
+
+		if (vcpu->run->exit_reason == KVM_EXIT_IO &&
+		    vcpu->run->io.port == TDX_TEST_DIRTY_RING_REPORT_PORT &&
+		    vcpu->run->io.size == TDX_TEST_DIRTY_RING_REPORT_SIZE &&
+		    vcpu->run->io.direction == TDG_VP_VMCALL_INSTRUCTION_IO_WRITE) {
+			TEST_ASSERT(dirty_ring_empty(vcpu),
+				    "Guest write on a gmemfd slot should not cause GFN dirty\n");
+			reset_dirty_ring(vcpu);
+		}
+	}
+	TDX_TEST_ASSERT_SUCCESS(vcpu);
+}
+
+void reset_dirty_ring_on_gmemfd_slot(bool manual_protect_and_init_set)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+
+	vm_enable_dirty_ring(vm, TDX_TEST_DIRTY_RING_COUNT * sizeof(struct kvm_dirty_gfn));
+
+	/*
+	 * Let KVM detect that kvm_dirty_log_manual_protect_and_init_set() is
+	 * true in kvm_arch_mmu_enable_log_dirty_pt_masked() to check if
+	 * kvm_mmu_slot_gfn_write_protect() will be called on a memslot that
+	 * does not have dirty track enabled.
+	 */
+	if (manual_protect_and_init_set) {
+		u64 manual_caps;
+
+		manual_caps = kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
+
+		manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
+				KVM_DIRTY_LOG_INITIALLY_SET);
+
+		if (!manual_caps)
+			return;
+
+		vm_enable_cap(vm, KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2, manual_caps);
+	}
+
+	vcpu = td_vcpu_add(vm, 0, guest_code_dirty_gpa);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    TDX_TEST_DIRTY_RING_GPA,
+				    TDX_TEST_DIRTY_RING_REGION_SLOT,
+				    TDX_TEST_DIRTY_RING_REGION_SIZE / getpagesize(),
+				    KVM_MEM_GUEST_MEMFD);
+	vm->memslots[MEM_REGION_TEST_DATA] = TDX_TEST_DIRTY_RING_REGION_SLOT;
+
+	____vm_vaddr_alloc(vm, TDX_TEST_DIRTY_RING_REGION_SIZE,
+			   TDX_TEST_DIRTY_RING_GVA,
+			   TDX_TEST_DIRTY_RING_GPA, MEM_REGION_TEST_DATA, true);
+	td_finalize(vm);
+
+	printf("Verifying reset dirty ring on gmemfd slot with dirty log initially %s:\n",
+	       manual_protect_and_init_set ? "set" : "unset");
+
+	verify_turn_on_log_dirty_pages_flag(vcpu);
+	reset_dirty_ring_worker(vcpu);
+
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
+/*
+ * Test if resetting a GFN in a memslot with the KVM_MEM_GUEST_MEMFD flag in the
+ * dirty ring does not negatively impact TDs.
+ * (when manual protect and initially_set is off)
+ */
+void verify_reset_dirty_ring_config1(void)
+{
+	reset_dirty_ring_on_gmemfd_slot(false);
+}
+
+/*
+ * Test if resetting a GFN in a memslot with the KVM_MEM_GUEST_MEMFD flag in the
+ * dirty ring does not negatively impact TDs.
+ * (when manual protect and initially_set is on)
+ */
+void verify_reset_dirty_ring_config2(void)
+{
+	reset_dirty_ring_on_gmemfd_slot(true);
+}
+
+int main(int argc, char **argv)
+{
+	ksft_print_header();
+
+	if (!is_tdx_enabled())
+		ksft_exit_skip("TDX is not supported by the KVM. Exiting.\n");
+
+	ksft_set_plan(2);
+	ksft_test_result(!run_in_new_process(&verify_reset_dirty_ring_config1),
+			 "verify_reset_dirty_ring_config1\n");
+	ksft_test_result(!run_in_new_process(&verify_reset_dirty_ring_config2),
+			 "verify_reset_dirty_ring_config2\n");
+	ksft_finished();
+	return 0;
+}
-- 
2.43.2


