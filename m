Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20E760A200
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 13:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiJXLiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 07:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiJXLhl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 07:37:41 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E9BB1E9;
        Mon, 24 Oct 2022 04:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666611439; x=1698147439;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t7W7XVUZQguRPZuAEYrnWIs6HnDF1NedL9PgtWfNfnk=;
  b=GZwwi4fSG7zklKLohEZLz+YWkpgQo1cRPqyW7+jcNrXVDRbCeyYgzAy9
   lejm09s6EYNfgJtKsJTehYqj1V2gXeGsbRmpsaJEpDrBFmbzA3CPIj8fa
   IQUEEi3KwVrTk9duCBx7I8Qm/jvoesABLwZrByhvs5JJi5gZRXTyD0RPV
   4rwZw34dYKu4irYtd2IW7NtqQWp8EVbKR+jEx/3QO1as2k1UGvpJoTzDK
   F387Th2L5Y411JmVGyLVQ+z+CAhnBrIko9l4XV3/875B43JPGOGVMEePV
   9XhVOqASlourqEaaAXUjInwh8gy7PQGyLGrWsQL5frFA3vtrjEtHnDkni
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="371612763"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="371612763"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 04:34:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="773784606"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="773784606"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmsmga001.fm.intel.com with ESMTP; 24 Oct 2022 04:34:50 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     dmatlack@google.com, vipinsh@google.com, ajones@ventanamicro.com,
        eric.auger@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v1 01/18] KVM: selftests/kvm_util: use array of pointers to maintain vcpus in kvm_vm
Date:   Mon, 24 Oct 2022 19:34:28 +0800
Message-Id: <20221024113445.1022147-2-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221024113445.1022147-1-wei.w.wang@intel.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Each vcpu has an id associated with it and is intrinsically faster
and easier to be referenced by indexing into an array with "vcpu->id",
compared to using a list of vcpus in the current implementation. Change
the vcpu list to an array of vcpu pointers. Users then don't need to
allocate such a vcpu array on their own, and instead, they can reuse
the one maintained in kvm_vm.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  4 +++
 .../selftests/kvm/include/kvm_util_base.h     |  3 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 34 ++++++-------------
 tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  2 +-
 4 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index c9286811a4cb..5d5c8968fb06 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -10,4 +10,8 @@
 #include "kvm_util_base.h"
 #include "ucall_common.h"
 
+#define vm_iterate_over_vcpus(vm, vcpu, i)				\
+	for (i = 0, vcpu = vm->vcpus[0];				\
+		vcpu && i < KVM_MAX_VCPUS; vcpu = vm->vcpus[++i])
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index e42a09cd24a0..c90a9609b853 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -45,7 +45,6 @@ struct userspace_mem_region {
 };
 
 struct kvm_vcpu {
-	struct list_head list;
 	uint32_t id;
 	int fd;
 	struct kvm_vm *vm;
@@ -75,7 +74,6 @@ struct kvm_vm {
 	unsigned int pa_bits;
 	unsigned int va_bits;
 	uint64_t max_gfn;
-	struct list_head vcpus;
 	struct userspace_mem_regions regions;
 	struct sparsebit *vpages_valid;
 	struct sparsebit *vpages_mapped;
@@ -92,6 +90,7 @@ struct kvm_vm {
 	int stats_fd;
 	struct kvm_stats_header stats_header;
 	struct kvm_stats_desc *stats_desc;
+	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 };
 
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f1cb1627161f..941f6c3ea9dc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -195,7 +195,6 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
 
-	INIT_LIST_HEAD(&vm->vcpus);
 	vm->regions.gpa_tree = RB_ROOT;
 	vm->regions.hva_tree = RB_ROOT;
 	hash_init(vm->regions.slot_hash);
@@ -534,6 +533,10 @@ __weak void vcpu_arch_free(struct kvm_vcpu *vcpu)
 static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
 	int ret;
+	uint32_t vcpu_id = vcpu->id;
+
+	TEST_ASSERT(!!vm->vcpus[vcpu_id], "vCPU%d wasn't added\n", vcpu_id);
+	vm->vcpus[vcpu_id] = NULL;
 
 	if (vcpu->dirty_gfns) {
 		ret = munmap(vcpu->dirty_gfns, vm->dirty_ring_size);
@@ -547,18 +550,16 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	ret = close(vcpu->fd);
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
 
-	list_del(&vcpu->list);
-
 	vcpu_arch_free(vcpu);
 	free(vcpu);
 }
 
 void kvm_vm_release(struct kvm_vm *vmp)
 {
-	struct kvm_vcpu *vcpu, *tmp;
-	int ret;
+	struct kvm_vcpu *vcpu;
+	int i, ret;
 
-	list_for_each_entry_safe(vcpu, tmp, &vmp->vcpus, list)
+	vm_iterate_over_vcpus(vmp, vcpu, i)
 		vm_vcpu_rm(vmp, vcpu);
 
 	ret = close(vmp->fd);
@@ -1085,18 +1086,6 @@ static int vcpu_mmap_sz(void)
 	return ret;
 }
 
-static bool vcpu_exists(struct kvm_vm *vm, uint32_t vcpu_id)
-{
-	struct kvm_vcpu *vcpu;
-
-	list_for_each_entry(vcpu, &vm->vcpus, list) {
-		if (vcpu->id == vcpu_id)
-			return true;
-	}
-
-	return false;
-}
-
 /*
  * Adds a virtual CPU to the VM specified by vm with the ID given by vcpu_id.
  * No additional vCPU setup is done.  Returns the vCPU.
@@ -1106,7 +1095,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	struct kvm_vcpu *vcpu;
 
 	/* Confirm a vcpu with the specified id doesn't already exist. */
-	TEST_ASSERT(!vcpu_exists(vm, vcpu_id), "vCPU%d already exists\n", vcpu_id);
+	TEST_ASSERT(!vm->vcpus[vcpu_id], "vCPU%d already exists\n", vcpu_id);
 
 	/* Allocate and initialize new vcpu structure. */
 	vcpu = calloc(1, sizeof(*vcpu));
@@ -1125,8 +1114,7 @@ struct kvm_vcpu *__vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	TEST_ASSERT(vcpu->run != MAP_FAILED,
 		    __KVM_SYSCALL_ERROR("mmap()", (int)(unsigned long)MAP_FAILED));
 
-	/* Add to linked-list of VCPUs. */
-	list_add(&vcpu->list, &vm->vcpus);
+	vm->vcpus[vcpu_id] = vcpu;
 
 	return vcpu;
 }
@@ -1684,7 +1672,7 @@ void kvm_gsi_routing_write(struct kvm_vm *vm, struct kvm_irq_routing *routing)
  */
 void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
-	int ctr;
+	int i, ctr;
 	struct userspace_mem_region *region;
 	struct kvm_vcpu *vcpu;
 
@@ -1712,7 +1700,7 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	}
 	fprintf(stream, "%*sVCPUs:\n", indent, "");
 
-	list_for_each_entry(vcpu, &vm->vcpus, list)
+	vm_iterate_over_vcpus(vm, vcpu, i)
 		vcpu_dump(stream, vcpu, indent + 2);
 }
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index d21049c38fc5..77812dd03647 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -549,7 +549,7 @@ bool kvm_vm_has_ept(struct kvm_vm *vm)
 	struct kvm_vcpu *vcpu;
 	uint64_t ctrl;
 
-	vcpu = list_first_entry(&vm->vcpus, struct kvm_vcpu, list);
+	vcpu = vm->vcpus[0];
 	TEST_ASSERT(vcpu, "Cannot determine EPT support without vCPUs.\n");
 
 	ctrl = vcpu_get_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS) >> 32;
-- 
2.27.0

