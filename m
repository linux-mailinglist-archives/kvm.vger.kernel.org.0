Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1A261A4C95
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 01:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgDJXRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 19:17:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:20811 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDJXRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 19:17:10 -0400
IronPort-SDR: D4eTMdmRfiHXb4KKfPJfP2nFUO+Cpt0XwbP5M1KOg7fHTX/4dJqJdr6xWI6H1t//sdJDQP1PTX
 FdqeYJs8HSSA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2020 16:17:09 -0700
IronPort-SDR: kxkzD4jfmepLxmFOTFHPis6R14+8oHUKDJwRflVoNDrTDel8g790FRLmQf0AAeWcz+f10UyosH
 rfEQToNA3ZZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,368,1580803200"; 
   d="scan'208";a="452542221"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 10 Apr 2020 16:17:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH 02/10] KVM: selftests: Use kernel's list instead of homebrewed replacement
Date:   Fri, 10 Apr 2020 16:16:59 -0700
Message-Id: <20200410231707.7128-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200410231707.7128-1-sean.j.christopherson@intel.com>
References: <20200410231707.7128-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the KVM selftests' homebrewed linked lists for vCPUs and memory
regions with the kernel's 'struct list_head'.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    | 94 ++++++++-----------
 .../selftests/kvm/lib/kvm_util_internal.h     |  8 +-
 .../selftests/kvm/lib/s390x/processor.c       |  5 +-
 4 files changed, 48 insertions(+), 60 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index a99b875f50d2..2f329e785c58 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -10,6 +10,7 @@
 #include "test_util.h"
 
 #include "asm/kvm.h"
+#include "linux/list.h"
 #include "linux/kvm.h"
 #include <sys/ioctl.h>
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9a783c20dd26..105ee9bc09f0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -161,6 +161,9 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
 
+	INIT_LIST_HEAD(&vm->vcpus);
+	INIT_LIST_HEAD(&vm->userspace_mem_regions);
+
 	vm->mode = mode;
 	vm->type = 0;
 
@@ -258,8 +261,7 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
 	if (vmp->has_irqchip)
 		vm_create_irqchip(vmp);
 
-	for (region = vmp->userspace_mem_region_head; region;
-		region = region->next) {
+	list_for_each_entry(region, &vmp->userspace_mem_regions, list) {
 		int ret = ioctl(vmp->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
 		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
 			    "  rc: %i errno: %i\n"
@@ -319,8 +321,7 @@ userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end)
 {
 	struct userspace_mem_region *region;
 
-	for (region = vm->userspace_mem_region_head; region;
-		region = region->next) {
+	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
 		uint64_t existing_start = region->region.guest_phys_addr;
 		uint64_t existing_end = region->region.guest_phys_addr
 			+ region->region.memory_size - 1;
@@ -378,11 +379,11 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
  */
 struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpup;
+	struct vcpu *vcpu;
 
-	for (vcpup = vm->vcpu_head; vcpup; vcpup = vcpup->next) {
-		if (vcpup->id == vcpuid)
-			return vcpup;
+	list_for_each_entry(vcpu, &vm->vcpus, list) {
+		if (vcpu->id == vcpuid)
+			return vcpu;
 	}
 
 	return NULL;
@@ -392,16 +393,15 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
  * VM VCPU Remove
  *
  * Input Args:
- *   vm - Virtual Machine
  *   vcpu - VCPU to remove
  *
  * Output Args: None
  *
  * Return: None, TEST_ASSERT failures for all error conditions
  *
- * Within the VM specified by vm, removes the VCPU given by vcpuid.
+ * Removes a vCPU from a VM and frees its resources.
  */
-static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
+static void vm_vcpu_rm(struct vcpu *vcpu)
 {
 	int ret;
 
@@ -412,21 +412,17 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
 	TEST_ASSERT(ret == 0, "Close of VCPU fd failed, rc: %i "
 		"errno: %i", ret, errno);
 
-	if (vcpu->next)
-		vcpu->next->prev = vcpu->prev;
-	if (vcpu->prev)
-		vcpu->prev->next = vcpu->next;
-	else
-		vm->vcpu_head = vcpu->next;
+	list_del(&vcpu->list);
 	free(vcpu);
 }
 
 void kvm_vm_release(struct kvm_vm *vmp)
 {
+	struct vcpu *vcpu, *tmp;
 	int ret;
 
-	while (vmp->vcpu_head)
-		vm_vcpu_rm(vmp, vmp->vcpu_head);
+	list_for_each_entry_safe(vcpu, tmp, &vmp->vcpus, list)
+		vm_vcpu_rm(vcpu);
 
 	ret = close(vmp->fd);
 	TEST_ASSERT(ret == 0, "Close of vm fd failed,\n"
@@ -442,15 +438,15 @@ void kvm_vm_release(struct kvm_vm *vmp)
  */
 void kvm_vm_free(struct kvm_vm *vmp)
 {
+	struct userspace_mem_region *region, *tmp;
 	int ret;
 
 	if (vmp == NULL)
 		return;
 
 	/* Free userspace_mem_regions. */
-	while (vmp->userspace_mem_region_head) {
-		struct userspace_mem_region *region
-			= vmp->userspace_mem_region_head;
+	list_for_each_entry_safe(region, tmp, &vmp->userspace_mem_regions, list) {
+		list_del(&region->list);
 
 		region->region.memory_size = 0;
 		ret = ioctl(vmp->fd, KVM_SET_USER_MEMORY_REGION,
@@ -458,7 +454,6 @@ void kvm_vm_free(struct kvm_vm *vmp)
 		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed, "
 			"rc: %i errno: %i", ret, errno);
 
-		vmp->userspace_mem_region_head = region->next;
 		sparsebit_free(&region->unused_phy_pages);
 		ret = munmap(region->mmap_start, region->mmap_size);
 		TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i",
@@ -611,12 +606,10 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			(uint64_t) region->region.memory_size);
 
 	/* Confirm no region with the requested slot already exists. */
-	for (region = vm->userspace_mem_region_head; region;
-		region = region->next) {
-		if (region->region.slot == slot)
-			break;
-	}
-	if (region != NULL)
+	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
+		if (region->region.slot != slot)
+			continue;
+
 		TEST_FAIL("A mem region with the requested slot "
 			"already exists.\n"
 			"  requested slot: %u paddr: 0x%lx npages: 0x%lx\n"
@@ -625,6 +618,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			region->region.slot,
 			(uint64_t) region->region.guest_phys_addr,
 			(uint64_t) region->region.memory_size);
+	}
 
 	/* Allocate and initialize new mem region structure. */
 	region = calloc(1, sizeof(*region));
@@ -685,10 +679,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 		guest_paddr, (uint64_t) region->region.memory_size);
 
 	/* Add to linked-list of memory regions. */
-	if (vm->userspace_mem_region_head)
-		vm->userspace_mem_region_head->prev = region;
-	region->next = vm->userspace_mem_region_head;
-	vm->userspace_mem_region_head = region;
+	list_add(&region->list, &vm->userspace_mem_regions);
 }
 
 /*
@@ -711,20 +702,17 @@ memslot2region(struct kvm_vm *vm, uint32_t memslot)
 {
 	struct userspace_mem_region *region;
 
-	for (region = vm->userspace_mem_region_head; region;
-		region = region->next) {
+	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
 		if (region->region.slot == memslot)
-			break;
-	}
-	if (region == NULL) {
-		fprintf(stderr, "No mem region with the requested slot found,\n"
-			"  requested slot: %u\n", memslot);
-		fputs("---- vm dump ----\n", stderr);
-		vm_dump(stderr, vm, 2);
-		TEST_FAIL("Mem region not found");
+			return region;
 	}
 
-	return region;
+	fprintf(stderr, "No mem region with the requested slot found,\n"
+		"  requested slot: %u\n", memslot);
+	fputs("---- vm dump ----\n", stderr);
+	vm_dump(stderr, vm, 2);
+	TEST_FAIL("Mem region not found");
+	return NULL;
 }
 
 /*
@@ -862,10 +850,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 		"vcpu id: %u errno: %i", vcpuid, errno);
 
 	/* Add to linked-list of VCPUs. */
-	if (vm->vcpu_head)
-		vm->vcpu_head->prev = vcpu;
-	vcpu->next = vm->vcpu_head;
-	vm->vcpu_head = vcpu;
+	list_add(&vcpu->list, &vm->vcpus);
 }
 
 /*
@@ -1058,8 +1043,8 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
 {
 	struct userspace_mem_region *region;
-	for (region = vm->userspace_mem_region_head; region;
-	     region = region->next) {
+
+	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
 		if ((gpa >= region->region.guest_phys_addr)
 			&& (gpa <= (region->region.guest_phys_addr
 				+ region->region.memory_size - 1)))
@@ -1091,8 +1076,8 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
 {
 	struct userspace_mem_region *region;
-	for (region = vm->userspace_mem_region_head; region;
-	     region = region->next) {
+
+	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
 		if ((hva >= region->host_mem)
 			&& (hva <= (region->host_mem
 				+ region->region.memory_size - 1)))
@@ -1519,8 +1504,7 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	fprintf(stream, "%*sfd: %i\n", indent, "", vm->fd);
 	fprintf(stream, "%*spage_size: 0x%x\n", indent, "", vm->page_size);
 	fprintf(stream, "%*sMem Regions:\n", indent, "");
-	for (region = vm->userspace_mem_region_head; region;
-		region = region->next) {
+	list_for_each_entry(region, &vm->userspace_mem_regions, list) {
 		fprintf(stream, "%*sguest_phys: 0x%lx size: 0x%lx "
 			"host_virt: %p\n", indent + 2, "",
 			(uint64_t) region->region.guest_phys_addr,
@@ -1539,7 +1523,7 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 		virt_dump(stream, vm, indent + 4);
 	}
 	fprintf(stream, "%*sVCPUs:\n", indent, "");
-	for (vcpu = vm->vcpu_head; vcpu; vcpu = vcpu->next)
+	list_for_each_entry(vcpu, &vm->vcpus, list)
 		vcpu_dump(stream, vm, vcpu->id, indent + 2);
 }
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
index ca56a0133127..2ef446520748 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -13,7 +13,6 @@
 #define KVM_DEV_PATH		"/dev/kvm"
 
 struct userspace_mem_region {
-	struct userspace_mem_region *next, *prev;
 	struct kvm_userspace_memory_region region;
 	struct sparsebit *unused_phy_pages;
 	int fd;
@@ -21,10 +20,11 @@ struct userspace_mem_region {
 	void *host_mem;
 	void *mmap_start;
 	size_t mmap_size;
+	struct list_head list;
 };
 
 struct vcpu {
-	struct vcpu *next, *prev;
+	struct list_head list;
 	uint32_t id;
 	int fd;
 	struct kvm_run *state;
@@ -41,8 +41,8 @@ struct kvm_vm {
 	unsigned int pa_bits;
 	unsigned int va_bits;
 	uint64_t max_gfn;
-	struct vcpu *vcpu_head;
-	struct userspace_mem_region *userspace_mem_region_head;
+	struct list_head vcpus;
+	struct list_head userspace_mem_regions;
 	struct sparsebit *vpages_valid;
 	struct sparsebit *vpages_mapped;
 	bool has_irqchip;
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 8d94961bd046..a88c5d665725 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -233,7 +233,10 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
 
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t indent)
 {
-	struct vcpu *vcpu = vm->vcpu_head;
+	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
+
+	if (!vcpu)
+		return;
 
 	fprintf(stream, "%*spstate: psw: 0x%.16llx:0x%.16llx\n",
 		indent, "", vcpu->state->psw_mask, vcpu->state->psw_addr);
-- 
2.26.0

