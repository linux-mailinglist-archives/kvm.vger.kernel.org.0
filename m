Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20AA18D9C5
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 21:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgCTUzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 16:55:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:32133 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCTUzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 16:55:49 -0400
IronPort-SDR: A+Fbkft2UiLIyK4wZCZtPA+4/BxY+yTCIg9KfhNbX1tFd60XFcEMgGDcxCXqluhuqoQWxpgtjx
 ogEMdizMyvrw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 13:55:48 -0700
IronPort-SDR: kOc50hqflBAi6+e86IYBSqCdVZtsOHsAdJ2opWl90587yh8hMe8AYCKDxBhQFqJ2qX0DQjJGlH
 9y3/VdeyEkqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,285,1580803200"; 
   d="scan'208";a="280543326"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 20 Mar 2020 13:55:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Peter Xu <peterx@redhat.com>
Subject: [PATCH 4/7] KVM: selftests: Add helpers to consolidate open coded list operations
Date:   Fri, 20 Mar 2020 13:55:43 -0700
Message-Id: <20200320205546.2396-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320205546.2396-1-sean.j.christopherson@intel.com>
References: <20200320205546.2396-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers for the KVM sefltests' variant of a linked list to replace a
variety of open coded adds, deletes and iterators.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 68 ++++++++++++----------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 9a783c20dd26..d7b74f465570 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -19,6 +19,27 @@
 #define KVM_UTIL_PGS_PER_HUGEPG 512
 #define KVM_UTIL_MIN_PFN	2
 
+#define kvm_list_add(head, new)		\
+do {					\
+	if (head)			\
+		head->prev = new;	\
+	new->next = head;		\
+	head = new;			\
+} while (0)
+
+#define kvm_list_del(head, del)			\
+do {						\
+	if (del->next)				\
+		del->next->prev = del->prev;	\
+	if (del->prev)				\
+		del->prev->next = del->next;	\
+	else					\
+		head = del->next;		\
+} while (0)
+
+#define kvm_list_for_each(head, iter)		\
+	for (iter = head; iter; iter = iter->next)
+
 /* Aligns x up to the next multiple of size. Size must be a power of 2. */
 static void *align(void *x, size_t size)
 {
@@ -258,8 +279,7 @@ void kvm_vm_restart(struct kvm_vm *vmp, int perm)
 	if (vmp->has_irqchip)
 		vm_create_irqchip(vmp);
 
-	for (region = vmp->userspace_mem_region_head; region;
-		region = region->next) {
+	kvm_list_for_each(vmp->userspace_mem_region_head, region) {
 		int ret = ioctl(vmp->fd, KVM_SET_USER_MEMORY_REGION, &region->region);
 		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed,\n"
 			    "  rc: %i errno: %i\n"
@@ -319,8 +339,7 @@ userspace_mem_region_find(struct kvm_vm *vm, uint64_t start, uint64_t end)
 {
 	struct userspace_mem_region *region;
 
-	for (region = vm->userspace_mem_region_head; region;
-		region = region->next) {
+	kvm_list_for_each(vm->userspace_mem_region_head, region) {
 		uint64_t existing_start = region->region.guest_phys_addr;
 		uint64_t existing_end = region->region.guest_phys_addr
 			+ region->region.memory_size - 1;
@@ -380,7 +399,7 @@ struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	struct vcpu *vcpup;
 
-	for (vcpup = vm->vcpu_head; vcpup; vcpup = vcpup->next) {
+	kvm_list_for_each(vm->vcpu_head, vcpup) {
 		if (vcpup->id == vcpuid)
 			return vcpup;
 	}
@@ -412,12 +431,7 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct vcpu *vcpu)
 	TEST_ASSERT(ret == 0, "Close of VCPU fd failed, rc: %i "
 		"errno: %i", ret, errno);
 
-	if (vcpu->next)
-		vcpu->next->prev = vcpu->prev;
-	if (vcpu->prev)
-		vcpu->prev->next = vcpu->next;
-	else
-		vm->vcpu_head = vcpu->next;
+	kvm_list_del(vm->vcpu_head, vcpu);
 	free(vcpu);
 }
 
@@ -452,13 +466,14 @@ void kvm_vm_free(struct kvm_vm *vmp)
 		struct userspace_mem_region *region
 			= vmp->userspace_mem_region_head;
 
+		kvm_list_del(vmp->userspace_mem_region_head, region);
+
 		region->region.memory_size = 0;
 		ret = ioctl(vmp->fd, KVM_SET_USER_MEMORY_REGION,
 			&region->region);
 		TEST_ASSERT(ret == 0, "KVM_SET_USER_MEMORY_REGION IOCTL failed, "
 			"rc: %i errno: %i", ret, errno);
 
-		vmp->userspace_mem_region_head = region->next;
 		sparsebit_free(&region->unused_phy_pages);
 		ret = munmap(region->mmap_start, region->mmap_size);
 		TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i",
@@ -611,8 +626,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			(uint64_t) region->region.memory_size);
 
 	/* Confirm no region with the requested slot already exists. */
-	for (region = vm->userspace_mem_region_head; region;
-		region = region->next) {
+	kvm_list_for_each(vm->userspace_mem_region_head, region) {
 		if (region->region.slot == slot)
 			break;
 	}
@@ -685,10 +699,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 		guest_paddr, (uint64_t) region->region.memory_size);
 
 	/* Add to linked-list of memory regions. */
-	if (vm->userspace_mem_region_head)
-		vm->userspace_mem_region_head->prev = region;
-	region->next = vm->userspace_mem_region_head;
-	vm->userspace_mem_region_head = region;
+	kvm_list_add(vm->userspace_mem_region_head, region);
 }
 
 /*
@@ -711,8 +722,7 @@ memslot2region(struct kvm_vm *vm, uint32_t memslot)
 {
 	struct userspace_mem_region *region;
 
-	for (region = vm->userspace_mem_region_head; region;
-		region = region->next) {
+	kvm_list_for_each(vm->userspace_mem_region_head, region) {
 		if (region->region.slot == memslot)
 			break;
 	}
@@ -862,10 +872,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid)
 		"vcpu id: %u errno: %i", vcpuid, errno);
 
 	/* Add to linked-list of VCPUs. */
-	if (vm->vcpu_head)
-		vm->vcpu_head->prev = vcpu;
-	vcpu->next = vm->vcpu_head;
-	vm->vcpu_head = vcpu;
+	kvm_list_add(vm->vcpu_head, vcpu);
 }
 
 /*
@@ -1058,8 +1065,8 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
 {
 	struct userspace_mem_region *region;
-	for (region = vm->userspace_mem_region_head; region;
-	     region = region->next) {
+
+	kvm_list_for_each(vm->userspace_mem_region_head, region) {
 		if ((gpa >= region->region.guest_phys_addr)
 			&& (gpa <= (region->region.guest_phys_addr
 				+ region->region.memory_size - 1)))
@@ -1091,8 +1098,8 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva)
 {
 	struct userspace_mem_region *region;
-	for (region = vm->userspace_mem_region_head; region;
-	     region = region->next) {
+
+	kvm_list_for_each(vm->userspace_mem_region_head, region) {
 		if ((hva >= region->host_mem)
 			&& (hva <= (region->host_mem
 				+ region->region.memory_size - 1)))
@@ -1519,8 +1526,7 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	fprintf(stream, "%*sfd: %i\n", indent, "", vm->fd);
 	fprintf(stream, "%*spage_size: 0x%x\n", indent, "", vm->page_size);
 	fprintf(stream, "%*sMem Regions:\n", indent, "");
-	for (region = vm->userspace_mem_region_head; region;
-		region = region->next) {
+	kvm_list_for_each(vm->userspace_mem_region_head, region) {
 		fprintf(stream, "%*sguest_phys: 0x%lx size: 0x%lx "
 			"host_virt: %p\n", indent + 2, "",
 			(uint64_t) region->region.guest_phys_addr,
@@ -1539,7 +1545,7 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 		virt_dump(stream, vm, indent + 4);
 	}
 	fprintf(stream, "%*sVCPUs:\n", indent, "");
-	for (vcpu = vm->vcpu_head; vcpu; vcpu = vcpu->next)
+	kvm_list_for_each(vm->vcpu_head, vcpu)
 		vcpu_dump(stream, vm, vcpu->id, indent + 2);
 }
 
-- 
2.24.1

