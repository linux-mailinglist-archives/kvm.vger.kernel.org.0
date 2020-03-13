Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4FB184BD2
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 16:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgCMP46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 11:56:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59546 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727024AbgCMP46 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 11:56:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584115016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0TlnYuG1vxW9vxNmtolQqNH8uI5iJFkajryLnEBQjsU=;
        b=Evdbg7sBlPux3vw6gJkoKDcjmdB4gNiQG8o0dVt2qYt9Lix9gr94Ehw4WvN4V/1l4xR5iP
        ESdf19K7MWNx78CmsVARruf1Z7J5A3HIAzELLwR206HFwrhmqqSatnum8LlVUFliwAPHHQ
        jpBJ5EdGoDcmdG3WkuuLwQs+gDoWmgk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-tbd92L-sOumh-eZ3ofcpBQ-1; Fri, 13 Mar 2020 11:56:54 -0400
X-MC-Unique: tbd92L-sOumh-eZ3ofcpBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08C531005513
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 15:56:54 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E05C93535;
        Fri, 13 Mar 2020 15:56:50 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 1/2] KVM: selftests: virt_map should take npages, not size
Date:   Fri, 13 Mar 2020 16:56:43 +0100
Message-Id: <20200313155644.29779-2-drjones@redhat.com>
In-Reply-To: <20200313155644.29779-1-drjones@redhat.com>
References: <20200313155644.29779-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Also correct the comment and prototype for vm_create_default(),
as it takes a number of pages, not a size.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c      |  3 +--
 tools/testing/selftests/kvm/dirty_log_test.c          |  3 +--
 tools/testing/selftests/kvm/include/kvm_util.h        |  6 +++---
 tools/testing/selftests/kvm/lib/kvm_util.c            | 10 +++++-----
 .../selftests/kvm/x86_64/set_memory_region_test.c     |  2 +-
 .../testing/selftests/kvm/x86_64/vmx_dirty_log_test.c | 11 +++++------
 6 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index c4fc96bd064b..d82f7bc060c3 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -410,8 +410,7 @@ static void run_test(enum vm_guest_mode mode, bool us=
e_uffd,
 				    guest_num_pages, 0);
=20
 	/* Do mapping for the demand paging memory slot */
-	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem,
-		 guest_num_pages * guest_page_size, 0);
+	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages,=
 0);
=20
 	ucall_init(vm, NULL);
=20
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing=
/selftests/kvm/dirty_log_test.c
index 051791e0f5fb..8f5b590805a4 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -334,8 +334,7 @@ static void run_test(enum vm_guest_mode mode, unsigne=
d long iterations,
 				    KVM_MEM_LOG_DIRTY_PAGES);
=20
 	/* Do mapping for the dirty track memory slot */
-	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem,
-		 guest_num_pages * guest_page_size, 0);
+	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages,=
 0);
=20
 	/* Cache the HVA pointer of the region */
 	host_test_mem =3D addr_gpa2hva(vm, (vm_paddr_t)guest_test_phys_mem);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
index 24f7a93671a2..3aa4d1e52284 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -117,7 +117,7 @@ void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
 vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr=
_min,
 			  uint32_t data_memslot, uint32_t pgd_memslot);
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-	      size_t size, uint32_t pgd_memslot);
+	      unsigned int npages, uint32_t pgd_memslot);
 void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa);
 void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
@@ -226,7 +226,7 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size=
_t num,
  *
  * Input Args:
  *   vcpuid - The id of the single VCPU to add to the VM.
- *   extra_mem_pages - The size of extra memories to add (this will
+ *   extra_mem_pages - The number of extra pages to add (this will
  *                     decide how much extra space we will need to
  *                     setup the page tables using memslot 0)
  *   guest_code - The vCPU's entry point
@@ -236,7 +236,7 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size=
_t num,
  * Return:
  *   Pointer to opaque structure that describes the created VM.
  */
-struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_siz=
e,
+struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pag=
es,
 				 void *guest_code);
=20
 /*
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
index aa7697212267..e26917ba25bc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1015,21 +1015,21 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size=
_t sz, vm_vaddr_t vaddr_min,
  *   vm - Virtual Machine
  *   vaddr - Virtuall address to map
  *   paddr - VM Physical Address
- *   size - The size of the range to map
+ *   npages - The number of pages to map
  *   pgd_memslot - Memory region slot for new virtual translation tables
  *
  * Output Args: None
  *
  * Return: None
  *
- * Within the VM given by vm, creates a virtual translation for the
- * page range starting at vaddr to the page range starting at paddr.
+ * Within the VM given by @vm, creates a virtual translation for
+ * @npages starting at @vaddr to the page range starting at @paddr.
  */
 void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
-	      size_t size, uint32_t pgd_memslot)
+	      unsigned int npages, uint32_t pgd_memslot)
 {
 	size_t page_size =3D vm->page_size;
-	size_t npages =3D size / page_size;
+	size_t size =3D npages * page_size;
=20
 	TEST_ASSERT(vaddr + size > vaddr, "Vaddr overflow");
 	TEST_ASSERT(paddr + size > paddr, "Paddr overflow");
diff --git a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c =
b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
index f2efaa576794..c6691cff4e19 100644
--- a/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_memory_region_test.c
@@ -87,7 +87,7 @@ static void test_move_memory_region(void)
 	gpa =3D vm_phy_pages_alloc(vm, 2, MEM_REGION_GPA, MEM_REGION_SLOT);
 	TEST_ASSERT(gpa =3D=3D MEM_REGION_GPA, "Failed vm_phy_pages_alloc\n");
=20
-	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA, 2 * 4096, 0);
+	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA, 2, 0);
=20
 	/* Ditto for the host mapping so that both pages can be zeroed. */
 	hva =3D addr_gpa2hva(vm, MEM_REGION_GPA);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c b/to=
ols/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
index d9ca948d0b72..7a3228c80d2d 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
@@ -21,7 +21,7 @@
=20
 /* The memory slot index to track dirty pages */
 #define TEST_MEM_SLOT_INDEX		1
-#define TEST_MEM_SIZE			3
+#define TEST_MEM_PAGES			3
=20
 /* L1 guest test virtual memory offset */
 #define GUEST_TEST_MEM			0xc0000000
@@ -91,15 +91,14 @@ int main(int argc, char *argv[])
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    GUEST_TEST_MEM,
 				    TEST_MEM_SLOT_INDEX,
-				    TEST_MEM_SIZE,
+				    TEST_MEM_PAGES,
 				    KVM_MEM_LOG_DIRTY_PAGES);
=20
 	/*
 	 * Add an identity map for GVA range [0xc0000000, 0xc0002000).  This
 	 * affects both L1 and L2.  However...
 	 */
-	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM,
-		 TEST_MEM_SIZE * 4096, 0);
+	virt_map(vm, GUEST_TEST_MEM, GUEST_TEST_MEM, TEST_MEM_PAGES, 0);
=20
 	/*
 	 * ... pages in the L2 GPA range [0xc0001000, 0xc0003000) will map to
@@ -113,11 +112,11 @@ int main(int argc, char *argv[])
 	nested_map(vmx, vm, NESTED_TEST_MEM1, GUEST_TEST_MEM, 4096, 0);
 	nested_map(vmx, vm, NESTED_TEST_MEM2, GUEST_TEST_MEM, 4096, 0);
=20
-	bmap =3D bitmap_alloc(TEST_MEM_SIZE);
+	bmap =3D bitmap_alloc(TEST_MEM_PAGES);
 	host_test_mem =3D addr_gpa2hva(vm, GUEST_TEST_MEM);
=20
 	while (!done) {
-		memset(host_test_mem, 0xaa, TEST_MEM_SIZE * 4096);
+		memset(host_test_mem, 0xaa, TEST_MEM_PAGES * 4096);
 		_vcpu_run(vm, VCPU_ID);
 		TEST_ASSERT(run->exit_reason =3D=3D KVM_EXIT_IO,
 			    "Unexpected exit reason: %u (%s),\n",
--=20
2.21.1

