Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED20315DA10
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 15:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387531AbgBNO7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 09:59:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53146 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387508AbgBNO7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 09:59:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581692378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cJoPIbsK9GhYKf/WnE8jKYnYU/Z3g4rIk5TFH83WU0I=;
        b=DIHpqSjMPO6tsUDmCOlSuF9KK4x5DaKLCvR60iHuMBzcQ+viq9Q7iXz/jtUfmy4ZDMs6uQ
        54efAisZlUdmny3kDBBq9BHpU85Hvleqyj/BBJMf8kqzuQVWIe8Slrv9Dbe7rZCnKVWg6/
        S8qn4ZLkNOyjL4aF2ydDhK7TXlxsaH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-NNOMIHSiNduQaNZnKgqBWg-1; Fri, 14 Feb 2020 09:59:37 -0500
X-MC-Unique: NNOMIHSiNduQaNZnKgqBWg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 187A7A0CC0;
        Fri, 14 Feb 2020 14:59:36 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6913119E9C;
        Fri, 14 Feb 2020 14:59:34 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, bgardon@google.com, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, thuth@redhat.com, peterx@redhat.com
Subject: [PATCH 05/13] fixup! KVM: selftests: Time guest demand paging
Date:   Fri, 14 Feb 2020 15:59:12 +0100
Message-Id: <20200214145920.30792-6-drjones@redhat.com>
In-Reply-To: <20200214145920.30792-1-drjones@redhat.com>
References: <20200214145920.30792-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Move timespec-diff to test_util.h]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/demand_paging_test.c        | 42 +++++--------------
 .../testing/selftests/kvm/include/test_util.h |  3 ++
 tools/testing/selftests/kvm/lib/test_util.c   | 20 +++++++++
 3 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index 2e6e3db8418a..22a3011df62f 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -74,26 +74,6 @@ static uint64_t guest_test_phys_mem;
  */
 static uint64_t guest_test_virt_mem =3D DEFAULT_GUEST_TEST_MEM;
=20
-int64_t to_ns(struct timespec ts)
-{
-	return (int64_t)ts.tv_nsec + 1000000000LL * (int64_t)ts.tv_sec;
-}
-
-struct timespec diff(struct timespec start, struct  timespec end)
-{
-	struct   timespec temp;
-
-	if ((end.tv_nsec-start.tv_nsec) < 0) {
-		temp.tv_sec =3D end.tv_sec - start.tv_sec - 1;
-		temp.tv_nsec =3D 1000000000 + end.tv_nsec - start.tv_nsec;
-	} else {
-		temp.tv_sec =3D end.tv_sec - start.tv_sec;
-		temp.tv_nsec =3D end.tv_nsec - start.tv_nsec;
-	}
-
-	return temp;
-}
-
 struct vcpu_args {
 	uint64_t gva;
 	uint64_t pages;
@@ -157,8 +137,8 @@ static void *vcpu_worker(void *data)
=20
 	clock_gettime(CLOCK_MONOTONIC, &end);
 	PER_VCPU_DEBUG("vCPU %d execution time: %lld.%.9lds\n", vcpu_id,
-		       (long long)(diff(start, end).tv_sec),
-		       diff(start, end).tv_nsec);
+		       (long long)(timespec_diff(start, end).tv_sec),
+		       timespec_diff(start, end).tv_nsec);
=20
 	return NULL;
 }
@@ -226,7 +206,7 @@ static int handle_uffd_page_request(int uffd, uint64_=
t addr)
 	clock_gettime(CLOCK_MONOTONIC, &end);
=20
 	PER_PAGE_DEBUG("UFFDIO_COPY %d \t%lld ns\n", tid,
-		       (long long)to_ns(diff(start, end)));
+		       (long long)timespec_to_ns(timespec_diff(start, end)));
 	PER_PAGE_DEBUG("Paged in %ld bytes at 0x%lx from thread %d\n",
 		       host_page_size, addr, tid);
=20
@@ -321,10 +301,10 @@ static void *uffd_handler_thread_fn(void *arg)
=20
 	clock_gettime(CLOCK_MONOTONIC, &end);
 	PER_VCPU_DEBUG("userfaulted %ld pages over %lld.%.9lds. (%f/sec)\n",
-		       pages, (long long)(diff(start, end).tv_sec),
-		       diff(start, end).tv_nsec, pages /
-		       ((double)diff(start, end).tv_sec +
-			(double)diff(start, end).tv_nsec / 100000000.0));
+		       pages, (long long)(timespec_diff(start, end).tv_sec),
+		       timespec_diff(start, end).tv_nsec, pages /
+		       ((double)timespec_diff(start, end).tv_sec +
+			(double)timespec_diff(start, end).tv_nsec / 100000000.0));
=20
 	return NULL;
 }
@@ -432,7 +412,6 @@ static void run_test(enum vm_guest_mode mode, bool us=
e_uffd,
 	DEBUG("guest physical test memory offset: 0x%lx\n",
 	      guest_test_phys_mem);
=20
-
 	/* Add an extra memory slot for testing demand paging */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 				    guest_test_phys_mem,
@@ -548,10 +527,11 @@ static void run_test(enum vm_guest_mode mode, bool =
use_uffd,
 	}
=20
 	DEBUG("Total guest execution time: %lld.%.9lds\n",
-	      (long long)(diff(start, end).tv_sec), diff(start, end).tv_nsec);
+	      (long long)(timespec_diff(start, end).tv_sec),
+	      timespec_diff(start, end).tv_nsec);
 	DEBUG("Overall demand paging rate: %f pgs/sec\n",
-	      guest_num_pages / ((double)diff(start, end).tv_sec +
-	      (double)diff(start, end).tv_nsec / 100000000.0));
+	      guest_num_pages / ((double)timespec_diff(start, end).tv_sec +
+	      (double)timespec_diff(start, end).tv_nsec / 100000000.0));
=20
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
index e696c8219d69..920328ca5f7e 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -41,4 +41,7 @@ void test_assert(bool exp, const char *exp_str,
=20
 size_t parse_size(const char *size);
=20
+int64_t timespec_to_ns(struct timespec ts);
+struct timespec timespec_diff(struct timespec start, struct timespec end=
);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/=
selftests/kvm/lib/test_util.c
index cbd7f51b07a1..1c0d45afdf36 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -49,3 +49,23 @@ size_t parse_size(const char *size)
=20
 	return base << shift;
 }
+
+int64_t timespec_to_ns(struct timespec ts)
+{
+	return (int64_t)ts.tv_nsec + 1000000000LL * (int64_t)ts.tv_sec;
+}
+
+struct timespec timespec_diff(struct timespec start, struct timespec end=
)
+{
+	struct timespec temp;
+
+	if ((end.tv_nsec - start.tv_nsec) < 0) {
+		temp.tv_sec =3D end.tv_sec - start.tv_sec - 1;
+		temp.tv_nsec =3D 1000000000LL + end.tv_nsec - start.tv_nsec;
+	} else {
+		temp.tv_sec =3D end.tv_sec - start.tv_sec;
+		temp.tv_nsec =3D end.tv_nsec - start.tv_nsec;
+	}
+
+	return temp;
+}
--=20
2.21.1

