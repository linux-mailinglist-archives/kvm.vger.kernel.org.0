Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADBF51869A5
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 12:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbgCPLBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 07:01:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37514 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730761AbgCPLBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 07:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584356513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PN4YbhhcdMcyt5QyRLHE8p5QSyN9Hizt+RXQJXitYXo=;
        b=esO0XS+aPGLVBGAxMCqfyOaGIr7EhM4Kp5Ay+g8le7UQZ9MX5CRluFndfst/lT45C033Yu
        f+ntUtnNgnpuWlYjXHWp1XJlI75AWbOl7+JbiFfrh45L7PXOwRFW5EmbodVphH+8s6zaZQ
        rigvVvwVUzII0sALKVUZCVo76YBMlIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-9Yra0-DdNouSiBijhQ9izA-1; Mon, 16 Mar 2020 07:01:51 -0400
X-MC-Unique: 9Yra0-DdNouSiBijhQ9izA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C96973C25F
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 11:01:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-240.brq.redhat.com [10.40.204.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECCB35DA8B;
        Mon, 16 Mar 2020 11:01:44 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 2/2] KVM: selftests: Rework timespec functions and usage
Date:   Mon, 16 Mar 2020 12:01:36 +0100
Message-Id: <20200316110136.31326-3-drjones@redhat.com>
In-Reply-To: <20200316110136.31326-1-drjones@redhat.com>
References: <20200316110136.31326-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The steal_time test's timespec stop condition was wrong and should have
used the timespec functions instead to avoid being wrong, but
timespec_diff had a strange interface. Rework all the timespec API and
its use.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/demand_paging_test.c        | 37 +++++++---------
 .../testing/selftests/kvm/include/test_util.h |  3 +-
 tools/testing/selftests/kvm/lib/test_util.c   | 42 +++++++++++--------
 tools/testing/selftests/kvm/steal_time.c      |  2 +-
 4 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index d82f7bc060c3..360cd3ea4cd6 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -117,8 +117,7 @@ static void *vcpu_worker(void *data)
 	struct kvm_vm *vm =3D args->vm;
 	int vcpu_id =3D args->vcpu_id;
 	struct kvm_run *run;
-	struct timespec start;
-	struct timespec end;
+	struct timespec start, end, ts_diff;
=20
 	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
 	run =3D vcpu_state(vm, vcpu_id);
@@ -135,9 +134,9 @@ static void *vcpu_worker(void *data)
 	}
=20
 	clock_gettime(CLOCK_MONOTONIC, &end);
-	PER_VCPU_DEBUG("vCPU %d execution time: %lld.%.9lds\n", vcpu_id,
-		       (long long)(timespec_diff(start, end).tv_sec),
-		       timespec_diff(start, end).tv_nsec);
+	ts_diff =3D timespec_sub(end, start);
+	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_id,
+		       ts_diff.tv_sec, ts_diff.tv_nsec);
=20
 	return NULL;
 }
@@ -201,8 +200,8 @@ static int handle_uffd_page_request(int uffd, uint64_=
t addr)
=20
 	clock_gettime(CLOCK_MONOTONIC, &end);
=20
-	PER_PAGE_DEBUG("UFFDIO_COPY %d \t%lld ns\n", tid,
-		       (long long)timespec_to_ns(timespec_diff(start, end)));
+	PER_PAGE_DEBUG("UFFDIO_COPY %d \t%ld ns\n", tid,
+		       timespec_to_ns(timespec_sub(end, start)));
 	PER_PAGE_DEBUG("Paged in %ld bytes at 0x%lx from thread %d\n",
 		       host_page_size, addr, tid);
=20
@@ -224,8 +223,7 @@ static void *uffd_handler_thread_fn(void *arg)
 	int pipefd =3D uffd_args->pipefd;
 	useconds_t delay =3D uffd_args->delay;
 	int64_t pages =3D 0;
-	struct timespec start;
-	struct timespec end;
+	struct timespec start, end, ts_diff;
=20
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	while (!quit_uffd_thread) {
@@ -295,11 +293,10 @@ static void *uffd_handler_thread_fn(void *arg)
 	}
=20
 	clock_gettime(CLOCK_MONOTONIC, &end);
-	PER_VCPU_DEBUG("userfaulted %ld pages over %lld.%.9lds. (%f/sec)\n",
-		       pages, (long long)(timespec_diff(start, end).tv_sec),
-		       timespec_diff(start, end).tv_nsec, pages /
-		       ((double)timespec_diff(start, end).tv_sec +
-			(double)timespec_diff(start, end).tv_nsec / 100000000.0));
+	ts_diff =3D timespec_sub(end, start);
+	PER_VCPU_DEBUG("userfaulted %ld pages over %ld.%.9lds. (%f/sec)\n",
+		       pages, ts_diff.tv_sec, ts_diff.tv_nsec,
+		       pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100=
000000.0));
=20
 	return NULL;
 }
@@ -360,13 +357,12 @@ static void run_test(enum vm_guest_mode mode, bool =
use_uffd,
 	pthread_t *vcpu_threads;
 	pthread_t *uffd_handler_threads =3D NULL;
 	struct uffd_handler_args *uffd_args =3D NULL;
+	struct timespec start, end, ts_diff;
 	int *pipefds =3D NULL;
 	struct kvm_vm *vm;
 	uint64_t guest_num_pages;
 	int vcpu_id;
 	int r;
-	struct timespec start;
-	struct timespec end;
=20
 	vm =3D create_vm(mode, vcpus, vcpu_memory_bytes);
=20
@@ -514,12 +510,11 @@ static void run_test(enum vm_guest_mode mode, bool =
use_uffd,
 		}
 	}
=20
-	pr_info("Total guest execution time: %lld.%.9lds\n",
-		(long long)(timespec_diff(start, end).tv_sec),
-		timespec_diff(start, end).tv_nsec);
+	ts_diff =3D timespec_sub(end, start);
+	pr_info("Total guest execution time: %ld.%.9lds\n",
+		ts_diff.tv_sec, ts_diff.tv_nsec);
 	pr_info("Overall demand paging rate: %f pgs/sec\n",
-		guest_num_pages / ((double)timespec_diff(start, end).tv_sec +
-		(double)timespec_diff(start, end).tv_nsec / 100000000.0));
+		guest_num_pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / =
100000000.0));
=20
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/test=
ing/selftests/kvm/include/test_util.h
index f588ad1403f1..5eb01bf51b86 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -61,7 +61,8 @@ void test_assert(bool exp, const char *exp_str,
 size_t parse_size(const char *size);
=20
 int64_t timespec_to_ns(struct timespec ts);
-struct timespec timespec_diff(struct timespec start, struct timespec end=
);
 struct timespec timespec_add_ns(struct timespec ts, int64_t ns);
+struct timespec timespec_add(struct timespec ts1, struct timespec ts2);
+struct timespec timespec_sub(struct timespec ts1, struct timespec ts2);
=20
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/=
selftests/kvm/lib/test_util.c
index ee12c4b9ae05..ac9145a9c6b9 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -56,21 +56,6 @@ int64_t timespec_to_ns(struct timespec ts)
 	return (int64_t)ts.tv_nsec + 1000000000LL * (int64_t)ts.tv_sec;
 }
=20
-struct timespec timespec_diff(struct timespec start, struct timespec end=
)
-{
-	struct timespec temp;
-
-	if ((end.tv_nsec - start.tv_nsec) < 0) {
-		temp.tv_sec =3D end.tv_sec - start.tv_sec - 1;
-		temp.tv_nsec =3D 1000000000LL + end.tv_nsec - start.tv_nsec;
-	} else {
-		temp.tv_sec =3D end.tv_sec - start.tv_sec;
-		temp.tv_nsec =3D end.tv_nsec - start.tv_nsec;
-	}
-
-	return temp;
-}
-
 struct timespec timespec_add_ns(struct timespec ts, int64_t ns)
 {
 	struct timespec res;
@@ -78,14 +63,35 @@ struct timespec timespec_add_ns(struct timespec ts, i=
nt64_t ns)
 	res.tv_sec =3D ts.tv_sec;
 	res.tv_nsec =3D ts.tv_nsec + ns;
=20
-	if (res.tv_nsec > 1000000000UL) {
-		res.tv_sec +=3D 1;
-		res.tv_nsec -=3D 1000000000UL;
+	if (res.tv_nsec > 0) {
+		while (res.tv_nsec > 1000000000LL) {
+			res.tv_sec +=3D 1;
+			res.tv_nsec -=3D 1000000000LL;
+		}
+	} else {
+		while (res.tv_nsec < 1000000000LL) {
+			res.tv_sec -=3D 1;
+			res.tv_nsec +=3D 1000000000LL;
+		}
 	}
=20
 	return res;
 }
=20
+struct timespec timespec_add(struct timespec ts1, struct timespec ts2)
+{
+	int64_t ns1 =3D timespec_to_ns(ts1);
+	int64_t ns2 =3D timespec_to_ns(ts2);
+	return timespec_add_ns((struct timespec){0}, ns1 + ns2);
+}
+
+struct timespec timespec_sub(struct timespec ts1, struct timespec ts2)
+{
+	int64_t ns1 =3D timespec_to_ns(ts1);
+	int64_t ns2 =3D timespec_to_ns(ts2);
+	return timespec_add_ns((struct timespec){0}, ns1 - ns2);
+}
+
 void print_skip(const char *fmt, ...)
 {
 	va_list ap;
diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/sel=
ftests/kvm/steal_time.c
index 21990d653099..86f30eda0ae7 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -242,7 +242,7 @@ static void *do_steal_time(void *arg)
=20
 	while (1) {
 		clock_gettime(CLOCK_MONOTONIC, &ts);
-		if (ts.tv_sec > stop.tv_sec || ts.tv_nsec >=3D stop.tv_nsec)
+		if (timespec_to_ns(timespec_sub(ts, stop)) >=3D 0)
 			break;
 	}
=20
--=20
2.21.1

