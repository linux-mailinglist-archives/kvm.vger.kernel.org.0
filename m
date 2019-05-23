Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895C927D69
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 14:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbfEWM6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 08:58:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfEWM6A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 08:58:00 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C958E9FDFB
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 12:58:00 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A96916090E;
        Thu, 23 May 2019 12:57:59 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, thuth@redhat.com
Subject: [PATCH 1/4] kvm: selftests: rename vm_vcpu_add to vm_vcpu_add_memslots
Date:   Thu, 23 May 2019 14:57:53 +0200
Message-Id: <20190523125756.4645-2-drjones@redhat.com>
In-Reply-To: <20190523125756.4645-1-drjones@redhat.com>
References: <20190523125756.4645-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 23 May 2019 12:58:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This frees up the name vm_vcpu_add for another use.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h       |  4 ++--
 tools/testing/selftests/kvm/lib/aarch64/processor.c  |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c           | 12 +++++++-----
 tools/testing/selftests/kvm/lib/x86_64/processor.c   |  2 +-
 tools/testing/selftests/kvm/x86_64/evmcs_test.c      |  2 +-
 .../selftests/kvm/x86_64/kvm_create_max_vcpus.c      |  2 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c        |  2 +-
 tools/testing/selftests/kvm/x86_64/state_test.c      |  2 +-
 8 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 8c6b9619797d..4e92f34cf46a 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -88,8 +88,8 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid, unsigned long ioctl,
 		void *arg);
 void vm_ioctl(struct kvm_vm *vm, unsigned long ioctl, void *arg);
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
-void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
-		 int gdt_memslot);
+void vm_vcpu_add_memslots(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
+			  int gdt_memslot);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 			  uint32_t data_memslot, uint32_t pgd_memslot);
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 19e667911496..713a0e6b0e08 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -243,7 +243,7 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
 					DEFAULT_ARM64_GUEST_STACK_VADDR_MIN, 0, 0);
 
-	vm_vcpu_add(vm, vcpuid, 0, 0);
+	vm_vcpu_add_memslots(vm, vcpuid, 0, 0);
 
 	set_reg(vm, vcpuid, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
 	set_reg(vm, vcpuid, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e9113857f44e..937292dca81b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -756,21 +756,23 @@ static int vcpu_mmap_sz(void)
 }
 
 /*
- * VM VCPU Add
+ * VM VCPU Add with provided memslots
  *
  * Input Args:
  *   vm - Virtual Machine
  *   vcpuid - VCPU ID
+ *   pgd_memslot - Memory region slot for new virtual translation tables
+ *   gdt_memslot - Memory region slot for data pages
  *
  * Output Args: None
  *
  * Return: None
  *
- * Creates and adds to the VM specified by vm and virtual CPU with
- * the ID given by vcpuid.
+ * Adds a virtual CPU to the VM specified by vm with the ID given by vcpuid
+ * and then sets it up with vcpu_setup() and the provided memslots.
  */
-void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
-		 int gdt_memslot)
+void vm_vcpu_add_memslots(struct kvm_vm *vm, uint32_t vcpuid, int pgd_memslot,
+			  int gdt_memslot)
 {
 	struct vcpu *vcpu;
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index dc7fae9fa424..7779cdcc9159 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -658,7 +658,7 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 				     DEFAULT_GUEST_STACK_VADDR_MIN, 0, 0);
 
 	/* Create VCPU */
-	vm_vcpu_add(vm, vcpuid, 0, 0);
+	vm_vcpu_add_memslots(vm, vcpuid, 0, 0);
 
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vm, vcpuid, &regs);
diff --git a/tools/testing/selftests/kvm/x86_64/evmcs_test.c b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
index 36669684eca5..f4bce50ded95 100644
--- a/tools/testing/selftests/kvm/x86_64/evmcs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/evmcs_test.c
@@ -149,7 +149,7 @@ int main(int argc, char *argv[])
 
 		/* Restore state in a new VM.  */
 		kvm_vm_restart(vm, O_RDWR);
-		vm_vcpu_add(vm, VCPU_ID, 0, 0);
+		vm_vcpu_add_memslots(vm, VCPU_ID, 0, 0);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c b/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
index 50e92996f918..ded4e0272f8a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_create_max_vcpus.c
@@ -34,7 +34,7 @@ void test_vcpu_creation(int first_vcpu_id, int num_vcpus)
 		int vcpu_id = first_vcpu_id + i;
 
 		/* This asserts that the vCPU was created. */
-		vm_vcpu_add(vm, vcpu_id, 0, 0);
+		vm_vcpu_add_memslots(vm, vcpu_id, 0, 0);
 	}
 
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index fb8086964d83..b31d8c29b215 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -145,7 +145,7 @@ int main(int argc, char *argv[])
 		state = vcpu_save_state(vm, VCPU_ID);
 		kvm_vm_release(vm);
 		kvm_vm_restart(vm, O_RDWR);
-		vm_vcpu_add(vm, VCPU_ID, 0, 0);
+		vm_vcpu_add_memslots(vm, VCPU_ID, 0, 0);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index e0a3c0204b7c..b564ebdd34ca 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -182,7 +182,7 @@ int main(int argc, char *argv[])
 
 		/* Restore state in a new VM.  */
 		kvm_vm_restart(vm, O_RDWR);
-		vm_vcpu_add(vm, VCPU_ID, 0, 0);
+		vm_vcpu_add_memslots(vm, VCPU_ID, 0, 0);
 		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
 		vcpu_load_state(vm, VCPU_ID, state);
 		run = vcpu_state(vm, VCPU_ID);
-- 
2.20.1

