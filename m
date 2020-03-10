Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E66BC17F343
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 10:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgCJJQO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 05:16:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36761 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726258AbgCJJQO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 05:16:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583831772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hvylOZdADWek7j3Jhf/m/V3e2qbjvFdElGmWWJeZh88=;
        b=G5PZDrY5Unxni2NxJhTc6KJLbTlyfVViattwU8w9o2zioU0mpUjHLryyx7WqKqXU1aH5W6
        WfO29u+PlGLqSlcRZWwcvycHU0ysyHNOaGwND+OlhY3+tXobl4b/AGvaXqjs1WGE4cIlkp
        YL0PB8lxO7fRJ71ZVxWBVR7CHPH+U7g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-0BB7IOB9MKGd_6COxGLSgA-1; Tue, 10 Mar 2020 05:16:10 -0400
X-MC-Unique: 0BB7IOB9MKGd_6COxGLSgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 817A9107ACC4;
        Tue, 10 Mar 2020 09:16:09 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B81760C05;
        Tue, 10 Mar 2020 09:16:07 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, peterx@redhat.com,
        thuth@redhat.com
Subject: [PATCH 2/4] KVM: selftests: Share common API documentation
Date:   Tue, 10 Mar 2020 10:15:54 +0100
Message-Id: <20200310091556.4701-3-drjones@redhat.com>
In-Reply-To: <20200310091556.4701-1-drjones@redhat.com>
References: <20200310091556.4701-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move function documentation comment blocks to the header files in
order to avoid duplicating them for each architecture. While at
it clean up and fix up the comment blocks.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 100 ++++++++-
 .../selftests/kvm/lib/aarch64/processor.c     |  17 --
 .../selftests/kvm/lib/kvm_util_internal.h     |  48 +++++
 .../selftests/kvm/lib/s390x/processor.c       |  74 -------
 .../selftests/kvm/lib/x86_64/processor.c      | 196 ++++--------------
 5 files changed, 187 insertions(+), 248 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
index 707b44805149..3420ca0c2e86 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -16,7 +16,8 @@
 #include "sparsebit.h"
=20
=20
-/* Callers of kvm_util only have an incomplete/opaque description of the
+/*
+ * Callers of kvm_util only have an incomplete/opaque description of the
  * structure kvm_util is using to maintain the state of a VM.
  */
 struct kvm_vm;
@@ -78,6 +79,23 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *fi=
lename,
 		     uint32_t data_memslot, uint32_t pgd_memslot);
=20
 void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
+
+/*
+ * VM VCPU Dump
+ *
+ * Input Args:
+ *   stream - Output FILE stream
+ *   vm     - Virtual Machine
+ *   vcpuid - VCPU ID
+ *   indent - Left margin indent amount
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Dumps the current state of the VCPU specified by @vcpuid, within the =
VM
+ * given by @vm, to the FILE stream given by @stream.
+ */
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid,
 	       uint8_t indent);
=20
@@ -103,6 +121,22 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uin=
t64_t paddr,
 void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
+
+/*
+ * Address Guest Virtual to Guest Physical
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   gva - VM virtual address
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Equivalent VM physical address
+ *
+ * Returns the VM physical address of the translated VM virtual
+ * address given by @gva.
+ */
 vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
=20
 struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
@@ -113,7 +147,27 @@ void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t v=
cpuid,
 		       struct kvm_mp_state *mp_state);
 void vcpu_regs_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *=
regs);
 void vcpu_regs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *=
regs);
+
+/*
+ * VM VCPU Args Set
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpuid - VCPU ID
+ *   num - number of arguments
+ *   ... - arguments, each of type uint64_t
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Sets the first @num function input registers of the VCPU with @vcpuid=
,
+ * per the C calling convention of the architecture, to the values given
+ * as variable args. Each of the variable args is expected to be of type
+ * uint64_t. The maximum @num can be is specific to the architecture.
+ */
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num,=
 ...);
+
 void vcpu_sregs_get(struct kvm_vm *vm, uint32_t vcpuid,
 		    struct kvm_sregs *sregs);
 void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
@@ -142,15 +196,57 @@ int vcpu_nested_state_set(struct kvm_vm *vm, uint32=
_t vcpuid,
 const char *exit_reason_str(unsigned int exit_reason);
=20
 void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot);
+
+/*
+ * VM Virtual Page Map
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vaddr - VM Virtual Address
+ *   paddr - VM Physical Address
+ *   memslot - Memory region slot for new virtual translation tables
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Within @vm, creates a virtual translation for the page starting
+ * at @vaddr to the page starting at @paddr.
+ */
 void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-		 uint32_t pgd_memslot);
+		 uint32_t memslot);
+
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
 vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
=20
+/*
+ * Create a VM with reasonable defaults
+ *
+ * Input Args:
+ *   vcpuid - The id of the single VCPU to add to the VM.
+ *   extra_mem_pages - The size of extra memories to add (this will
+ *                     decide how much extra space we will need to
+ *                     setup the page tables using memslot 0)
+ *   guest_code - The vCPU's entry point
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Pointer to opaque structure that describes the created VM.
+ */
 struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_siz=
e,
 				 void *guest_code);
+
+/*
+ * Adds a vCPU with reasonable defaults (e.g. a stack)
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpuid - The id of the VCPU to add to the VM.
+ *   guest_code - The vCPU's entry point
+ */
 void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest=
_code);
=20
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/=
testing/selftests/kvm/lib/aarch64/processor.c
index ba2ff3241781..f84270f0e32c 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -334,23 +334,6 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t=
 vcpuid, void *guest_code)
 	aarch64_vcpu_add_default(vm, vcpuid, NULL, guest_code);
 }
=20
-
-/* VM VCPU Args Set
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   num - number of arguments
- *   ... - arguments, each of type uint64_t
- *
- * Output Args: None
- *
- * Return: None
- *
- * Sets the first num function input arguments to the values
- * given as variable args.  Each of the variable args is expected to
- * be of type uint64_t. The registers set by this function are r0-r7.
- */
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num,=
 ...)
 {
 	va_list ap;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/=
testing/selftests/kvm/lib/kvm_util_internal.h
index 2fce6750b8b3..ca56a0133127 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -53,8 +53,56 @@ struct kvm_vm {
 };
=20
 struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid);
+
+/*
+ * Virtual Translation Tables Dump
+ *
+ * Input Args:
+ *   stream - Output FILE stream
+ *   vm     - Virtual Machine
+ *   indent - Left margin indent amount
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Dumps to the FILE stream given by @stream, the contents of all the
+ * virtual translation tables for the VM given by @vm.
+ */
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent);
+
+/*
+ * Register Dump
+ *
+ * Input Args:
+ *   stream - Output FILE stream
+ *   regs   - Registers
+ *   indent - Left margin indent amount
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Dumps the state of the registers given by @regs, to the FILE stream
+ * given by @stream.
+ */
 void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent);
+
+/*
+ * System Register Dump
+ *
+ * Input Args:
+ *   stream - Output FILE stream
+ *   sregs  - System registers
+ *   indent - Left margin indent amount
+ *
+ * Output Args: None
+ *
+ * Return: None
+ *
+ * Dumps the state of the system registers given by @sregs, to the FILE =
stream
+ * given by @stream.
+ */
 void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent);
=20
 struct userspace_mem_region *
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/te=
sting/selftests/kvm/lib/s390x/processor.c
index a0b84235c848..8d94961bd046 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -51,22 +51,6 @@ static uint64_t virt_alloc_region(struct kvm_vm *vm, i=
nt ri, uint32_t memslot)
 		| ((ri < 4 ? (PAGES_PER_REGION - 1) : 0) & REGION_ENTRY_LENGTH);
 }
=20
-/*
- * VM Virtual Page Map
- *
- * Input Args:
- *   vm - Virtual Machine
- *   gva - VM Virtual Address
- *   gpa - VM Physical Address
- *   memslot - Memory region slot for new virtual translation tables
- *
- * Output Args: None
- *
- * Return: None
- *
- * Within the VM given by vm, creates a virtual translation for the page
- * starting at vaddr to the page starting at paddr.
- */
 void virt_pg_map(struct kvm_vm *vm, uint64_t gva, uint64_t gpa,
 		 uint32_t memslot)
 {
@@ -107,26 +91,6 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t gva, uin=
t64_t gpa,
 	entry[idx] =3D gpa;
 }
=20
-/*
- * Address Guest Virtual to Guest Physical
- *
- * Input Args:
- *   vm - Virtual Machine
- *   gpa - VM virtual address
- *
- * Output Args: None
- *
- * Return:
- *   Equivalent VM physical address
- *
- * Translates the VM virtual address given by gva to a VM physical
- * address and then locates the memory region containing the VM
- * physical address, within the VM given by vm.  When found, the host
- * virtual address providing the memory to the vm physical address is
- * returned.
- * A TEST_ASSERT failure occurs if no region containing translated
- * VM virtual address exists.
- */
 vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	int ri, idx;
@@ -196,21 +160,6 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint=
8_t indent)
 	virt_dump_region(stream, vm, indent, vm->pgd);
 }
=20
-/*
- * Create a VM with reasonable defaults
- *
- * Input Args:
- *   vcpuid - The id of the single VCPU to add to the VM.
- *   extra_mem_pages - The size of extra memories to add (this will
- *                     decide how much extra space we will need to
- *                     setup the page tables using mem slot 0)
- *   guest_code - The vCPU's entry point
- *
- * Output Args: None
- *
- * Return:
- *   Pointer to opaque structure that describes the created VM.
- */
 struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pag=
es,
 				 void *guest_code)
 {
@@ -231,13 +180,6 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, ui=
nt64_t extra_mem_pages,
 	return vm;
 }
=20
-/*
- * Adds a vCPU with reasonable defaults (i.e. a stack and initial PSW)
- *
- * Input Args:
- *   vcpuid - The id of the VCPU to add to the VM.
- *   guest_code - The vCPU's entry point
- */
 void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest=
_code)
 {
 	size_t stack_size =3D  DEFAULT_STACK_PGS * getpagesize();
@@ -269,22 +211,6 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t=
 vcpuid, void *guest_code)
 	run->psw_addr =3D (uintptr_t)guest_code;
 }
=20
-/* VM VCPU Args Set
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   num - number of arguments
- *   ... - arguments, each of type uint64_t
- *
- * Output Args: None
- *
- * Return: None
- *
- * Sets the first num function input arguments to the values
- * given as variable args.  Each of the variable args is expected to
- * be of type uint64_t. The registers set by this function are r2-r6.
- */
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num,=
 ...)
 {
 	va_list ap;
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/t=
esting/selftests/kvm/lib/x86_64/processor.c
index 683d3bdb8f6a..7ce067c8a05d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -77,20 +77,6 @@ struct pageTableEntry {
 	uint64_t execute_disable:1;
 };
=20
-/* Register Dump
- *
- * Input Args:
- *   indent - Left margin indent amount
- *   regs - register
- *
- * Output Args:
- *   stream - Output FILE stream
- *
- * Return: None
- *
- * Dumps the state of the registers given by regs, to the FILE stream
- * given by steam.
- */
 void regs_dump(FILE *stream, struct kvm_regs *regs,
 	       uint8_t indent)
 {
@@ -115,19 +101,20 @@ void regs_dump(FILE *stream, struct kvm_regs *regs,
 		regs->rip, regs->rflags);
 }
=20
-/* Segment Dump
+/*
+ * Segment Dump
  *
  * Input Args:
- *   indent - Left margin indent amount
+ *   stream  - Output FILE stream
  *   segment - KVM segment
+ *   indent  - Left margin indent amount
  *
- * Output Args:
- *   stream - Output FILE stream
+ * Output Args: None
  *
  * Return: None
  *
- * Dumps the state of the KVM segment given by segment, to the FILE stre=
am
- * given by steam.
+ * Dumps the state of the KVM segment given by @segment, to the FILE str=
eam
+ * given by @stream.
  */
 static void segment_dump(FILE *stream, struct kvm_segment *segment,
 			 uint8_t indent)
@@ -146,19 +133,20 @@ static void segment_dump(FILE *stream, struct kvm_s=
egment *segment,
 		segment->unusable, segment->padding);
 }
=20
-/* dtable Dump
+/*
+ * dtable Dump
  *
  * Input Args:
- *   indent - Left margin indent amount
+ *   stream - Output FILE stream
  *   dtable - KVM dtable
+ *   indent - Left margin indent amount
  *
- * Output Args:
- *   stream - Output FILE stream
+ * Output Args: None
  *
  * Return: None
  *
- * Dumps the state of the KVM dtable given by dtable, to the FILE stream
- * given by steam.
+ * Dumps the state of the KVM dtable given by @dtable, to the FILE strea=
m
+ * given by @stream.
  */
 static void dtable_dump(FILE *stream, struct kvm_dtable *dtable,
 			uint8_t indent)
@@ -169,20 +157,6 @@ static void dtable_dump(FILE *stream, struct kvm_dta=
ble *dtable,
 		dtable->padding[0], dtable->padding[1], dtable->padding[2]);
 }
=20
-/* System Register Dump
- *
- * Input Args:
- *   indent - Left margin indent amount
- *   sregs - System registers
- *
- * Output Args:
- *   stream - Output FILE stream
- *
- * Return: None
- *
- * Dumps the state of the system registers given by sregs, to the FILE s=
tream
- * given by steam.
- */
 void sregs_dump(FILE *stream, struct kvm_sregs *sregs,
 		uint8_t indent)
 {
@@ -240,21 +214,6 @@ void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_=
memslot)
 	}
 }
=20
-/* VM Virtual Page Map
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vaddr - VM Virtual Address
- *   paddr - VM Physical Address
- *   pgd_memslot - Memory region slot for new virtual translation tables
- *
- * Output Args: None
- *
- * Return: None
- *
- * Within the VM given by vm, creates a virtual translation for the page
- * starting at vaddr to the page starting at paddr.
- */
 void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 	uint32_t pgd_memslot)
 {
@@ -326,20 +285,6 @@ void virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, =
uint64_t paddr,
 	pte[index[0]].present =3D 1;
 }
=20
-/* Virtual Translation Tables Dump
- *
- * Input Args:
- *   vm - Virtual Machine
- *   indent - Left margin indent amount
- *
- * Output Args:
- *   stream - Output FILE stream
- *
- * Return: None
- *
- * Dumps to the FILE stream given by stream, the contents of all the
- * virtual translation tables for the VM given by vm.
- */
 void virt_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 {
 	struct pageMapL4Entry *pml4e, *pml4e_start;
@@ -421,7 +366,8 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8=
_t indent)
 	}
 }
=20
-/* Set Unusable Segment
+/*
+ * Set Unusable Segment
  *
  * Input Args: None
  *
@@ -430,7 +376,7 @@ void virt_dump(FILE *stream, struct kvm_vm *vm, uint8=
_t indent)
  *
  * Return: None
  *
- * Sets the segment register pointed to by segp to an unusable state.
+ * Sets the segment register pointed to by @segp to an unusable state.
  */
 static void kvm_seg_set_unusable(struct kvm_segment *segp)
 {
@@ -460,7 +406,8 @@ static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm,=
 struct kvm_segment *segp)
 }
=20
=20
-/* Set Long Mode Flat Kernel Code Segment
+/*
+ * Set Long Mode Flat Kernel Code Segment
  *
  * Input Args:
  *   vm - VM whose GDT is being filled, or NULL to only write segp
@@ -471,8 +418,8 @@ static void kvm_seg_fill_gdt_64bit(struct kvm_vm *vm,=
 struct kvm_segment *segp)
  *
  * Return: None
  *
- * Sets up the KVM segment pointed to by segp, to be a code segment
- * with the selector value given by selector.
+ * Sets up the KVM segment pointed to by @segp, to be a code segment
+ * with the selector value given by @selector.
  */
 static void kvm_seg_set_kernel_code_64bit(struct kvm_vm *vm, uint16_t se=
lector,
 	struct kvm_segment *segp)
@@ -491,7 +438,8 @@ static void kvm_seg_set_kernel_code_64bit(struct kvm_=
vm *vm, uint16_t selector,
 		kvm_seg_fill_gdt_64bit(vm, segp);
 }
=20
-/* Set Long Mode Flat Kernel Data Segment
+/*
+ * Set Long Mode Flat Kernel Data Segment
  *
  * Input Args:
  *   vm - VM whose GDT is being filled, or NULL to only write segp
@@ -502,8 +450,8 @@ static void kvm_seg_set_kernel_code_64bit(struct kvm_=
vm *vm, uint16_t selector,
  *
  * Return: None
  *
- * Sets up the KVM segment pointed to by segp, to be a data segment
- * with the selector value given by selector.
+ * Sets up the KVM segment pointed to by @segp, to be a data segment
+ * with the selector value given by @selector.
  */
 static void kvm_seg_set_kernel_data_64bit(struct kvm_vm *vm, uint16_t se=
lector,
 	struct kvm_segment *segp)
@@ -521,24 +469,6 @@ static void kvm_seg_set_kernel_data_64bit(struct kvm=
_vm *vm, uint16_t selector,
 		kvm_seg_fill_gdt_64bit(vm, segp);
 }
=20
-/* Address Guest Virtual to Guest Physical
- *
- * Input Args:
- *   vm - Virtual Machine
- *   gpa - VM virtual address
- *
- * Output Args: None
- *
- * Return:
- *   Equivalent VM physical address
- *
- * Translates the VM virtual address given by gva to a VM physical
- * address and then locates the memory region containing the VM
- * physical address, within the VM given by vm.  When found, the host
- * virtual address providing the memory to the vm physical address is re=
turned.
- * A TEST_ASSERT failure occurs if no region containing translated
- * VM virtual address exists.
- */
 vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 {
 	uint16_t index[4];
@@ -640,12 +570,7 @@ static void vcpu_setup(struct kvm_vm *vm, int vcpuid=
, int pgd_memslot, int gdt_m
 	sregs.cr3 =3D vm->pgd;
 	vcpu_sregs_set(vm, vcpuid, &sregs);
 }
-/* Adds a vCPU with reasonable defaults (i.e., a stack)
- *
- * Input Args:
- *   vcpuid - The id of the VCPU to add to the VM.
- *   guest_code - The vCPU's entry point
- */
+
 void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest=
_code)
 {
 	struct kvm_mp_state mp_state;
@@ -670,7 +595,8 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t =
vcpuid, void *guest_code)
 	vcpu_set_mp_state(vm, vcpuid, &mp_state);
 }
=20
-/* Allocate an instance of struct kvm_cpuid2
+/*
+ * Allocate an instance of struct kvm_cpuid2
  *
  * Input Args: None
  *
@@ -703,7 +629,8 @@ static struct kvm_cpuid2 *allocate_kvm_cpuid2(void)
 	return cpuid;
 }
=20
-/* KVM Supported CPUID Get
+/*
+ * KVM Supported CPUID Get
  *
  * Input Args: None
  *
@@ -735,11 +662,12 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 	return cpuid;
 }
=20
-/* Locate a cpuid entry.
+/*
+ * Locate a cpuid entry.
  *
  * Input Args:
- *   cpuid: The cpuid.
  *   function: The function of the cpuid entry to find.
+ *   index: The index of the cpuid entry.
  *
  * Output Args: None
  *
@@ -766,7 +694,8 @@ kvm_get_supported_cpuid_index(uint32_t function, uint=
32_t index)
 	return entry;
 }
=20
-/* VM VCPU CPUID Set
+/*
+ * VM VCPU CPUID Set
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -793,20 +722,6 @@ void vcpu_set_cpuid(struct kvm_vm *vm,
=20
 }
=20
-/* Create a VM with reasonable defaults
- *
- * Input Args:
- *   vcpuid - The id of the single VCPU to add to the VM.
- *   extra_mem_pages - The size of extra memories to add (this will
- *                     decide how much extra space we will need to
- *                     setup the page tables using mem slot 0)
- *   guest_code - The vCPU's entry point
- *
- * Output Args: None
- *
- * Return:
- *   Pointer to opaque structure that describes the created VM.
- */
 struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pag=
es,
 				 void *guest_code)
 {
@@ -837,7 +752,8 @@ struct kvm_vm *vm_create_default(uint32_t vcpuid, uin=
t64_t extra_mem_pages,
 	return vm;
 }
=20
-/* VCPU Get MSR
+/*
+ * VCPU Get MSR
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -869,7 +785,8 @@ uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcp=
uid, uint64_t msr_index)
 	return buffer.entry.data;
 }
=20
-/* _VCPU Set MSR
+/*
+ * _VCPU Set MSR
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -902,7 +819,8 @@ int _vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid,=
 uint64_t msr_index,
 	return r;
 }
=20
-/* VCPU Set MSR
+/*
+ * VCPU Set MSR
  *
  * Input Args:
  *   vm - Virtual Machine
@@ -926,22 +844,6 @@ void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid=
, uint64_t msr_index,
 		"  rc: %i errno: %i", r, errno);
 }
=20
-/* VM VCPU Args Set
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   num - number of arguments
- *   ... - arguments, each of type uint64_t
- *
- * Output Args: None
- *
- * Return: None
- *
- * Sets the first num function input arguments to the values
- * given as variable args.  Each of the variable args is expected to
- * be of type uint64_t.
- */
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num,=
 ...)
 {
 	va_list ap;
@@ -976,22 +878,6 @@ void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpui=
d, unsigned int num, ...)
 	va_end(ap);
 }
=20
-/*
- * VM VCPU Dump
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   indent - Left margin indent amount
- *
- * Output Args:
- *   stream - Output FILE stream
- *
- * Return: None
- *
- * Dumps the current state of the VCPU specified by vcpuid, within the V=
M
- * given by vm, to the FILE stream given by stream.
- */
 void vcpu_dump(FILE *stream, struct kvm_vm *vm, uint32_t vcpuid, uint8_t=
 indent)
 {
 	struct kvm_regs regs;
--=20
2.21.1

