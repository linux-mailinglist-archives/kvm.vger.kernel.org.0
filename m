Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2641315DA1B
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 16:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387576AbgBNPAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 10:00:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26062 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387608AbgBNPAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 10:00:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xpXtTuGpSkzo1drzf1/7JNLkS5MAhpYUiEz9ih2XTYc=;
        b=jF52qn+qsGS7dYI+D8KMK3TgI/x6VT3MHixmwR64AGAkauBIU9tquJkHZi7uMRbSWAyapA
        CgBXgEFKUsHWcHT1gv1Q6nFtmycfMqfSd8iCYe1MXb3ksaf67oTCKNCw3Jj3vERB6qzlHh
        dRfg9UtOjW6yYy4rBVVw7aBxZiEvBVQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-dxftzf4QN7GJp9WXi3-D2A-1; Fri, 14 Feb 2020 09:59:58 -0500
X-MC-Unique: dxftzf4QN7GJp9WXi3-D2A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B3B8800D4E;
        Fri, 14 Feb 2020 14:59:57 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6822D19E9C;
        Fri, 14 Feb 2020 14:59:55 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 13/13] KVM: selftests: Introduce num-pages conversion utilities
Date:   Fri, 14 Feb 2020 15:59:20 +0100
Message-Id: <20200214145920.30792-14-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guests and hosts don't have to have the same page size. This means
calculations are necessary when selecting the number of guest pages
to allocate in order to ensure the number is compatible with the
host. Provide utilities to help with those calculations and apply
them where appropriate.

We also revert commit bffed38d4fb5 ("kvm: selftests: aarch64:
dirty_log_test: fix unaligned memslot size") and then use
vm_adjust_num_guest_pages() there instead.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/demand_paging_test.c        |  8 ++---
 tools/testing/selftests/kvm/dirty_log_test.c  | 13 ++++----
 .../testing/selftests/kvm/include/kvm_util.h  |  8 +++++
 .../testing/selftests/kvm/include/test_util.h |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 32 +++++++++++++++++++
 5 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index a5e57bd63e78..a9289a9386c0 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -164,12 +164,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode m=
ode, int vcpus,
 	pages +=3D (2 * pages) / PTES_PER_4K_PT;
 	pages +=3D ((2 * vcpus * vcpu_memory_bytes) >> PAGE_SHIFT_4K) /
 		 PTES_PER_4K_PT;
-
-	/*
-	 * If the host is uing 64K pages, then we need the number of 4K
-	 * guest pages to be a multiple of 16.
-	 */
-	pages +=3D 16 - pages % 16;
+	pages =3D vm_adjust_num_guest_pages(mode, pages);
=20
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
=20
@@ -382,6 +377,7 @@ static void run_test(enum vm_guest_mode mode, bool us=
e_uffd,
 		    "Guest memory size is not guest page size aligned.");
=20
 	guest_num_pages =3D (vcpus * vcpu_memory_bytes) / guest_page_size;
+	guest_num_pages =3D vm_adjust_num_guest_pages(mode, guest_num_pages);
=20
 #ifdef __s390x__
 	/* Round up to multiple of 1M (segment size) */
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing=
/selftests/kvm/dirty_log_test.c
index 12acf90826c1..a723333b138a 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -178,12 +178,11 @@ static void *vcpu_worker(void *data)
 	return NULL;
 }
=20
-static void vm_dirty_log_verify(unsigned long *bmap)
+static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *=
bmap)
 {
+	uint64_t step =3D vm_num_host_pages(mode, 1);
 	uint64_t page;
 	uint64_t *value_ptr;
-	uint64_t step =3D host_page_size >=3D guest_page_size ? 1 :
-				guest_page_size / host_page_size;
=20
 	for (page =3D 0; page < host_num_pages; page +=3D step) {
 		value_ptr =3D host_test_mem + page * host_page_size;
@@ -291,14 +290,14 @@ static void run_test(enum vm_guest_mode mode, unsig=
ned long iterations,
 	 * case where the size is not aligned to 64 pages.
 	 */
 	guest_num_pages =3D (1ul << (DIRTY_MEM_BITS -
-				   vm_get_page_shift(vm))) + 16;
+				   vm_get_page_shift(vm))) + 3;
+	guest_num_pages =3D vm_adjust_num_guest_pages(mode, guest_num_pages);
 #ifdef __s390x__
 	/* Round up to multiple of 1M (segment size) */
 	guest_num_pages =3D (guest_num_pages + 0xff) & ~0xffUL;
 #endif
 	host_page_size =3D getpagesize();
-	host_num_pages =3D (guest_num_pages * guest_page_size) / host_page_size=
 +
-			 !!((guest_num_pages * guest_page_size) % host_page_size);
+	host_num_pages =3D vm_num_host_pages(mode, guest_num_pages);
=20
 	if (!phys_offset) {
 		guest_test_phys_mem =3D (vm_get_max_gfn(vm) -
@@ -369,7 +368,7 @@ static void run_test(enum vm_guest_mode mode, unsigne=
d long iterations,
 		kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
 				       host_num_pages);
 #endif
-		vm_dirty_log_verify(bmap);
+		vm_dirty_log_verify(mode, bmap);
 		iteration++;
 		sync_global_to_guest(vm, iteration);
 	}
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
index 45c6c7ea24c5..bc7c67913fe0 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -158,6 +158,14 @@ unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
 unsigned int vm_get_max_gfn(struct kvm_vm *vm);
=20
+unsigned int vm_num_host_pages(enum vm_guest_mode mode, unsigned int num=
_guest_pages);
+unsigned int vm_num_guest_pages(enum vm_guest_mode mode, unsigned int nu=
m_host_pages);
+static inline unsigned int
+vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_gues=
t_pages)
+{
+	return vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages=
));
+}
+
 struct kvm_userspace_memory_region *
 kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 				 uint64_t end);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
index c921ea719ae0..a60cf4ffcc3b 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -19,6 +19,8 @@
 #include <fcntl.h>
 #include "kselftest.h"
=20
+#define getpageshift() (__builtin_ffs(getpagesize()) - 1)
+
 static inline int _no_printf(const char *format, ...) { return 0; }
=20
 #ifdef DEBUG
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
index 5e26e24bd609..44f1ef064085 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -583,6 +583,10 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	size_t huge_page_size =3D KVM_UTIL_PGS_PER_HUGEPG * vm->page_size;
 	size_t alignment;
=20
+	TEST_ASSERT(vm_adjust_num_guest_pages(vm->mode, npages) =3D=3D npages,
+		"Number of guest pages is not compatible with the host. "
+		"Try npages=3D%d", vm_adjust_num_guest_pages(vm->mode, npages));
+
 	TEST_ASSERT((guest_paddr % vm->page_size) =3D=3D 0, "Guest physical "
 		"address not on a page boundary.\n"
 		"  guest_paddr: 0x%lx vm->page_size: 0x%x",
@@ -1718,3 +1722,31 @@ unsigned int vm_get_max_gfn(struct kvm_vm *vm)
 {
 	return vm->max_gfn;
 }
+
+static unsigned int vm_calc_num_pages(unsigned int num_pages,
+				      unsigned int page_shift,
+				      unsigned int new_page_shift,
+				      bool ceil)
+{
+	unsigned int n =3D 1 << (new_page_shift - page_shift);
+
+	if (page_shift >=3D new_page_shift)
+		return num_pages * (1 << (page_shift - new_page_shift));
+
+	return num_pages / n + !!(ceil && num_pages % n);
+}
+
+unsigned int
+vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
+{
+	return vm_calc_num_pages(num_guest_pages,
+				 vm_guest_mode_params[mode].page_shift,
+				 getpageshift(), true);
+}
+
+unsigned int
+vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_pages)
+{
+	return vm_calc_num_pages(num_host_pages, getpageshift(),
+				 vm_guest_mode_params[mode].page_shift, false);
+}
--=20
2.21.1

