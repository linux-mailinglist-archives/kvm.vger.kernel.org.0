Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65AA814B1CD
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 10:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbgA1Jev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 04:34:51 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:39274 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725853AbgA1Jev (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jan 2020 04:34:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580204089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=p1cuTqBpAu7dAS53tDA9Lq4+9PX3cIAy2MQULa5xpEQ=;
        b=STdYTK24uz6gMt5puqlaK0Lem8Y1ERAQl40Sg38kSwIKNqUh4+CMIAAb1i57AQhRtxPZUu
        QHmbDKWCgLYy5+HzNbFF4YA72Z1Xx66eXuS5Tm8YCj9t3A2xxI0Xlu7dWq6J+1dZe7n+WH
        GC3wIkhdFb+42CrhWVQjM8+6RQhfxqY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-EWIXQv4wOgynUEChqEiFrg-1; Tue, 28 Jan 2020 04:34:47 -0500
X-MC-Unique: EWIXQv4wOgynUEChqEiFrg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6051E800EBB;
        Tue, 28 Jan 2020 09:34:46 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 302F788821;
        Tue, 28 Jan 2020 09:34:45 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, bgardon@google.com
Subject: [PATCH v2] kvm: selftests: Introduce num-pages conversion utilities
Date:   Tue, 28 Jan 2020 10:34:43 +0100
Message-Id: <20200128093443.25414-1-drjones@redhat.com>
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
host. Provide utilities to help with those calculations.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 10 ++++----
 .../testing/selftests/kvm/include/kvm_util.h  |  3 +++
 .../testing/selftests/kvm/include/test_util.h |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 24 +++++++++++++++++++
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing=
/selftests/kvm/dirty_log_test.c
index 5614222a6628..2383c55a1a1a 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -178,12 +178,11 @@ static void *vcpu_worker(void *data)
 	return NULL;
 }
=20
-static void vm_dirty_log_verify(unsigned long *bmap)
+static void vm_dirty_log_verify(struct kvm_vm *vm, unsigned long *bmap)
 {
+	uint64_t step =3D vm_num_host_pages(vm, 1);
 	uint64_t page;
 	uint64_t *value_ptr;
-	uint64_t step =3D host_page_size >=3D guest_page_size ? 1 :
-				guest_page_size / host_page_size;
=20
 	for (page =3D 0; page < host_num_pages; page +=3D step) {
 		value_ptr =3D host_test_mem + page * host_page_size;
@@ -295,8 +294,7 @@ static void run_test(enum vm_guest_mode mode, unsigne=
d long iterations,
 	guest_num_pages =3D (guest_num_pages + 0xff) & ~0xffUL;
 #endif
 	host_page_size =3D getpagesize();
-	host_num_pages =3D (guest_num_pages * guest_page_size) / host_page_size=
 +
-			 !!((guest_num_pages * guest_page_size) % host_page_size);
+	host_num_pages =3D vm_num_host_pages(vm, guest_num_pages);
=20
 	if (!phys_offset) {
 		guest_test_phys_mem =3D (vm_get_max_gfn(vm) -
@@ -369,7 +367,7 @@ static void run_test(enum vm_guest_mode mode, unsigne=
d long iterations,
 		kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
 				       host_num_pages);
 #endif
-		vm_dirty_log_verify(bmap);
+		vm_dirty_log_verify(vm, bmap);
 		iteration++;
 		sync_global_to_guest(vm, iteration);
 	}
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
index 29cccaf96baf..0d05ade3022c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -158,6 +158,9 @@ unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
 unsigned int vm_get_max_gfn(struct kvm_vm *vm);
=20
+unsigned int vm_num_host_pages(struct kvm_vm *vm, unsigned int num_guest=
_pages);
+unsigned int vm_num_guest_pages(struct kvm_vm *vm, unsigned int num_host=
_pages);
+
 struct kvm_userspace_memory_region *
 kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 				 uint64_t end);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
index a41db6fb7e24..25c27739e085 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -19,6 +19,8 @@
 #include <fcntl.h>
 #include "kselftest.h"
=20
+#define getpageshift() (__builtin_ffs(getpagesize()) - 1)
+
 ssize_t test_write(int fd, const void *buf, size_t count);
 ssize_t test_read(int fd, void *buf, size_t count);
 int test_seq_read(const char *path, char **bufp, size_t *sizep);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
index 41cf45416060..d9bca2f1cc95 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1667,3 +1667,27 @@ unsigned int vm_get_max_gfn(struct kvm_vm *vm)
 {
 	return vm->max_gfn;
 }
+
+static unsigned int vm_calc_num_pages(unsigned int num_pages,
+				      unsigned int page_shift,
+				      unsigned int new_page_shift)
+{
+	unsigned int n =3D 1 << (new_page_shift - page_shift);
+
+	if (page_shift >=3D new_page_shift)
+		return num_pages * (1 << (page_shift - new_page_shift));
+
+	return num_pages / n + !!(num_pages % n);
+}
+
+unsigned int vm_num_host_pages(struct kvm_vm *vm, unsigned int num_guest=
_pages)
+{
+	return vm_calc_num_pages(num_guest_pages, vm_get_page_shift(vm),
+				 getpageshift());
+}
+
+unsigned int vm_num_guest_pages(struct kvm_vm *vm, unsigned int num_host=
_pages)
+{
+	return vm_calc_num_pages(num_host_pages, getpageshift(),
+				 vm_get_page_shift(vm));
+}
--=20
2.21.1

