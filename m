Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC1D515DA14
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387574AbgBNO7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49562 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387525AbgBNO7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 09:59:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dei9e5O1K8S/z0QQGR3o18Z84+GIz//357QMrhH9RqU=;
        b=WXp+L641cMqDXxELWz17e+hVYTnMU17hioa4pItPH243HbirwZZ8/5VkA6fSrL22g6CVXI
        uXfg4QiI8wbTWoqxmzr5SYO5C6TX+zVBwqEk7PPbJJox4ux4O+90O8Bbs9pwSx89qHJ/pw
        IJzF82SfWiUkxHcykEhoL2vrLlJc0Ec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-4ReLJguDOz-SyPuaxrQ9TQ-1; Fri, 14 Feb 2020 09:59:50 -0500
X-MC-Unique: 4ReLJguDOz-SyPuaxrQ9TQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29352801A08;
        Fri, 14 Feb 2020 14:59:49 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B60419E9C;
        Fri, 14 Feb 2020 14:59:47 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 09/13] KVM: selftests: Rework debug message printing
Date:   Fri, 14 Feb 2020 15:59:16 +0100
Message-Id: <20200214145920.30792-10-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There were a few problems with the way we output "debug" messages.
The first is that we used DEBUG() which is defined when NDEBUG is
not defined, but NDEBUG will never be defined for kselftests
because it relies too much on assert(). The next is that most
of the DEBUG() messages were actually "info" messages, which
users may want to turn off if they just want a silent test that
either completes or asserts. Finally, a debug message output from
a library function, and thus for all tests, was annoying when its
information wasn't interesting for a test.

Rework these messages so debug messages only output when DEBUG
is defined and info messages output unless QUIET is defined.
Also name the functions pr_debug and pr_info and make sure that
when they're disabled we eat all the inputs. The later avoids
unused variable warnings when the variables were only defined
for the purpose of printing.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/demand_paging_test.c        | 54 +++++++++----------
 tools/testing/selftests/kvm/dirty_log_test.c  | 16 +++---
 .../testing/selftests/kvm/include/kvm_util.h  |  6 ---
 .../testing/selftests/kvm/include/test_util.h | 13 +++++
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    |  7 +--
 6 files changed, 54 insertions(+), 44 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index f20aa9f0a227..5aae166c2817 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -37,15 +37,15 @@
 #define DEFAULT_GUEST_TEST_MEM_SIZE (1 << 30) /* 1G */
=20
 #ifdef PRINT_PER_PAGE_UPDATES
-#define PER_PAGE_DEBUG(...) DEBUG(__VA_ARGS__)
+#define PER_PAGE_DEBUG(...) printf(__VA_ARGS__)
 #else
-#define PER_PAGE_DEBUG(...)
+#define PER_PAGE_DEBUG(...) _no_printf(__VA_ARGS__)
 #endif
=20
 #ifdef PRINT_PER_VCPU_UPDATES
-#define PER_VCPU_DEBUG(...) DEBUG(__VA_ARGS__)
+#define PER_VCPU_DEBUG(...) printf(__VA_ARGS__)
 #else
-#define PER_VCPU_DEBUG(...)
+#define PER_VCPU_DEBUG(...) _no_printf(__VA_ARGS__)
 #endif
=20
 #define MAX_VCPUS 512
@@ -171,6 +171,8 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mo=
de, int vcpus,
 	 */
 	pages +=3D 16 - pages % 16;
=20
+	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
+
 	vm =3D _vm_create(mode, pages, O_RDWR);
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 #ifdef __x86_64__
@@ -198,8 +200,8 @@ static int handle_uffd_page_request(int uffd, uint64_=
t addr)
=20
 	r =3D ioctl(uffd, UFFDIO_COPY, &copy);
 	if (r =3D=3D -1) {
-		DEBUG("Failed Paged in 0x%lx from thread %d with errno: %d\n",
-		      addr, tid, errno);
+		pr_info("Failed Paged in 0x%lx from thread %d with errno: %d\n",
+			addr, tid, errno);
 		return r;
 	}
=20
@@ -247,19 +249,19 @@ static void *uffd_handler_thread_fn(void *arg)
 		r =3D poll(pollfd, 2, -1);
 		switch (r) {
 		case -1:
-			DEBUG("poll err");
+			pr_info("poll err");
 			continue;
 		case 0:
 			continue;
 		case 1:
 			break;
 		default:
-			DEBUG("Polling uffd returned %d", r);
+			pr_info("Polling uffd returned %d", r);
 			return NULL;
 		}
=20
 		if (pollfd[0].revents & POLLERR) {
-			DEBUG("uffd revents has POLLERR");
+			pr_info("uffd revents has POLLERR");
 			return NULL;
 		}
=20
@@ -277,13 +279,12 @@ static void *uffd_handler_thread_fn(void *arg)
 		if (r =3D=3D -1) {
 			if (errno =3D=3D EAGAIN)
 				continue;
-			DEBUG("Read of uffd gor errno %d", errno);
+			pr_info("Read of uffd gor errno %d", errno);
 			return NULL;
 		}
=20
 		if (r !=3D sizeof(msg)) {
-			DEBUG("Read on uffd returned unexpected size: %d bytes",
-			      r);
+			pr_info("Read on uffd returned unexpected size: %d bytes", r);
 			return NULL;
 		}
=20
@@ -321,14 +322,14 @@ static int setup_demand_paging(struct kvm_vm *vm,
=20
 	uffd =3D syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
 	if (uffd =3D=3D -1) {
-		DEBUG("uffd creation failed\n");
+		pr_info("uffd creation failed\n");
 		return -1;
 	}
=20
 	uffdio_api.api =3D UFFD_API;
 	uffdio_api.features =3D 0;
 	if (ioctl(uffd, UFFDIO_API, &uffdio_api) =3D=3D -1) {
-		DEBUG("ioctl uffdio_api failed\n");
+		pr_info("ioctl uffdio_api failed\n");
 		return -1;
 	}
=20
@@ -336,13 +337,13 @@ static int setup_demand_paging(struct kvm_vm *vm,
 	uffdio_register.range.len =3D len;
 	uffdio_register.mode =3D UFFDIO_REGISTER_MODE_MISSING;
 	if (ioctl(uffd, UFFDIO_REGISTER, &uffdio_register) =3D=3D -1) {
-		DEBUG("ioctl uffdio_register failed\n");
+		pr_info("ioctl uffdio_register failed\n");
 		return -1;
 	}
=20
 	if ((uffdio_register.ioctls & UFFD_API_RANGE_IOCTLS) !=3D
 			UFFD_API_RANGE_IOCTLS) {
-		DEBUG("unexpected userfaultfd ioctl set\n");
+		pr_info("unexpected userfaultfd ioctl set\n");
 		return -1;
 	}
=20
@@ -409,8 +410,7 @@ static void run_test(enum vm_guest_mode mode, bool us=
e_uffd,
 	guest_test_phys_mem &=3D ~((1 << 20) - 1);
 #endif
=20
-	DEBUG("guest physical test memory offset: 0x%lx\n",
-	      guest_test_phys_mem);
+	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_m=
em);
=20
 	/* Add an extra memory slot for testing demand paging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
@@ -491,7 +491,7 @@ static void run_test(enum vm_guest_mode mode, bool us=
e_uffd,
 	sync_global_to_guest(vm, guest_page_size);
 	sync_global_to_guest(vm, vcpu_args);
=20
-	DEBUG("Finished creating vCPUs and starting uffd threads\n");
+	pr_info("Finished creating vCPUs and starting uffd threads\n");
=20
 	clock_gettime(CLOCK_MONOTONIC, &start);
=20
@@ -500,7 +500,7 @@ static void run_test(enum vm_guest_mode mode, bool us=
e_uffd,
 			       &vcpu_args[vcpu_id]);
 	}
=20
-	DEBUG("Started all vCPUs\n");
+	pr_info("Started all vCPUs\n");
=20
 	/* Wait for the vcpu threads to quit */
 	for (vcpu_id =3D 0; vcpu_id < vcpus; vcpu_id++) {
@@ -508,7 +508,7 @@ static void run_test(enum vm_guest_mode mode, bool us=
e_uffd,
 		PER_VCPU_DEBUG("Joined thread for vCPU %d\n", vcpu_id);
 	}
=20
-	DEBUG("All vCPU threads joined\n");
+	pr_info("All vCPU threads joined\n");
=20
 	clock_gettime(CLOCK_MONOTONIC, &end);
=20
@@ -524,12 +524,12 @@ static void run_test(enum vm_guest_mode mode, bool =
use_uffd,
 		}
 	}
=20
-	DEBUG("Total guest execution time: %lld.%.9lds\n",
-	      (long long)(timespec_diff(start, end).tv_sec),
-	      timespec_diff(start, end).tv_nsec);
-	DEBUG("Overall demand paging rate: %f pgs/sec\n",
-	      guest_num_pages / ((double)timespec_diff(start, end).tv_sec +
-	      (double)timespec_diff(start, end).tv_nsec / 100000000.0));
+	pr_info("Total guest execution time: %lld.%.9lds\n",
+		(long long)(timespec_diff(start, end).tv_sec),
+		timespec_diff(start, end).tv_nsec);
+	pr_info("Overall demand paging rate: %f pgs/sec\n",
+		guest_num_pages / ((double)timespec_diff(start, end).tv_sec +
+		(double)timespec_diff(start, end).tv_nsec / 100000000.0));
=20
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing=
/selftests/kvm/dirty_log_test.c
index 3146302ac563..587edf40cc32 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -173,7 +173,7 @@ static void *vcpu_worker(void *data)
 		}
 	}
=20
-	DEBUG("Dirtied %"PRIu64" pages\n", pages_count);
+	pr_info("Dirtied %"PRIu64" pages\n", pages_count);
=20
 	return NULL;
 }
@@ -252,6 +252,8 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mo=
de, uint32_t vcpuid,
 	struct kvm_vm *vm;
 	uint64_t extra_pg_pages =3D extra_mem_pages / 512 * 2;
=20
+	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
+
 	vm =3D _vm_create(mode, DEFAULT_GUEST_PHY_PAGES + extra_pg_pages, O_RDW=
R);
 	kvm_vm_elf_load(vm, program_invocation_name, 0, 0);
 #ifdef __x86_64__
@@ -311,7 +313,7 @@ static void run_test(enum vm_guest_mode mode, unsigne=
d long iterations,
 	guest_test_phys_mem &=3D ~((1 << 20) - 1);
 #endif
=20
-	DEBUG("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem=
);
+	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_m=
em);
=20
 	bmap =3D bitmap_alloc(host_num_pages);
 	host_bmap_track =3D bitmap_alloc(host_num_pages);
@@ -376,9 +378,9 @@ static void run_test(enum vm_guest_mode mode, unsigne=
d long iterations,
 	host_quit =3D true;
 	pthread_join(vcpu_thread, NULL);
=20
-	DEBUG("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
-	      "track_next (%"PRIu64")\n", host_dirty_count, host_clear_count,
-	      host_track_next_count);
+	pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
+		"track_next (%"PRIu64")\n", host_dirty_count, host_clear_count,
+		host_track_next_count);
=20
 	free(bmap);
 	free(host_bmap_track);
@@ -492,8 +494,8 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(iterations > 2, "Iterations must be greater than two");
 	TEST_ASSERT(interval > 0, "Interval must be greater than zero");
=20
-	DEBUG("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
-	      iterations, interval);
+	pr_info("Test iterations: %"PRIu64", interval: %"PRIu64" (ms)\n",
+		iterations, interval);
=20
 	srandom(time(0));
=20
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
index ae0d14c2540a..45c6c7ea24c5 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -24,12 +24,6 @@ struct kvm_vm;
 typedef uint64_t vm_paddr_t; /* Virtual Machine (Guest) physical address=
 */
 typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address =
*/
=20
-#ifndef NDEBUG
-#define DEBUG(...) printf(__VA_ARGS__);
-#else
-#define DEBUG(...)
-#endif
-
 /* Minimum allocated guest virtual and physical addresses */
 #define KVM_UTIL_MIN_VADDR		0x2000
=20
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
index 920328ca5f7e..c921ea719ae0 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -19,6 +19,19 @@
 #include <fcntl.h>
 #include "kselftest.h"
=20
+static inline int _no_printf(const char *format, ...) { return 0; }
+
+#ifdef DEBUG
+#define pr_debug(...) printf(__VA_ARGS__)
+#else
+#define pr_debug(...) _no_printf(__VA_ARGS__)
+#endif
+#ifndef QUIET
+#define pr_info(...) printf(__VA_ARGS__)
+#else
+#define pr_info(...) _no_printf(__VA_ARGS__)
+#endif
+
 ssize_t test_write(int fd, const void *buf, size_t count);
 ssize_t test_read(int fd, void *buf, size_t count);
 int test_seq_read(const char *path, char **bufp, size_t *sizep);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/=
testing/selftests/kvm/lib/aarch64/processor.c
index 053e1c940e7c..f84270f0e32c 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -186,7 +186,7 @@ vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t=
 gva)
=20
 static void pte_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent, ui=
nt64_t page, int level)
 {
-#ifdef DEBUG_VM
+#ifdef DEBUG
 	static const char * const type[] =3D { "", "pud", "pmd", "pte" };
 	uint64_t pte, *ptep;
=20
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
index fc597d7d6f84..c8a7ed338bed 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -138,7 +138,8 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, ui=
nt64_t phy_pages, int perm)
 {
 	struct kvm_vm *vm;
=20
-	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
+	pr_debug("%s: mode=3D'%s' pages=3D'%ld' perm=3D'%d'\n", __func__,
+		 vm_guest_mode_string(mode), phy_pages, perm);
=20
 	vm =3D calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm !=3D NULL, "Insufficient Memory");
@@ -198,8 +199,8 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, ui=
nt64_t phy_pages, int perm)
 		vm->pgtable_levels =3D 4;
 		vm->page_size =3D 0x1000;
 		vm->page_shift =3D 12;
-		DEBUG("Guest physical address width detected: %d\n",
-		      vm->pa_bits);
+		pr_debug("Guest physical address width detected: %d\n",
+			 vm->pa_bits);
 #else
 		TEST_ASSERT(false, "VM_MODE_PXXV48_4K not supported on "
 			    "non-x86 platforms");
--=20
2.21.1

