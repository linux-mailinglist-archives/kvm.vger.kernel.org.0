Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B656129CD44
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 02:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgJ1BiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 21:38:22 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:52199 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833036AbgJ0Xhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 19:37:43 -0400
Received: by mail-pf1-f202.google.com with SMTP id x24so1792085pfi.18
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 16:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=rzreZikW60gaJiVdcY2EzoicIJHutGLRqJMwkVCKA9U=;
        b=HqzH3Nvf6A8YEov78cvxeio0MF2i65L+3O99/+FlwlBku6s/wj9jEE2lpQvO3dZqbc
         zbAL0cGIjJp9g9nMRK1o/ufwFGdkOT8rd0Y4iqPfZDzTBpel2M1aM5Ps9Op28tCc8YZJ
         QmptD/hJaGlDNZUSYoPYPCHJIobyvx90QncA4UP9HVt5vRhnByyqwIDh3vMHMj4Ed5kK
         Rs0A7/j/y7gpRqlfeNjMOA0jw7RfeHZwB8bA4cRb7Dt+5+498c87rOjIrjIRobdKVXEg
         H8JbyUDL+omFmU13Cjbx5gNexW2imGOr2xuOvw1JnGMk8SMLKA6bhXmkZxocdeL7sxxz
         GQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rzreZikW60gaJiVdcY2EzoicIJHutGLRqJMwkVCKA9U=;
        b=r9VpZ/8fawbXec1PuS+3wW349aWiGNlgc39OhtRoRxuqnxkiU0dlSHkV41vmka79pm
         uwQIEzeqifIUkhiwSXmeU58cUGO4HV+HOEH/1m8sNNqZtZHyCnmovYMllULgLcE1IKIf
         Jxo5HsIJKVYwVGTwm97dVZtqlxXeWOJfRemlhmjuBcmr6dAkde5eMAQrANfvG4FaLlLy
         0G2taYCkR14VMbLkNhD9nTnXmU4CVphJBmbw8E7sgwKsUaBbpeATJU74dan8aDCbkjuJ
         W1Nb3socYS67SMQOT/5ajUXjhx91IEeFNvj6yusHG68qZ37icS9DvOghNFlGFJYrD1cA
         ByQw==
X-Gm-Message-State: AOAM5306SV24rvm07WNAbhn8xEJOiRVKZ0tO7E+C+Gm/WmqVIoZMsg5u
        cX2Yb2xITc9ln+BOqnTmWyiBOTS9NsXo
X-Google-Smtp-Source: ABdhPJz03YqCQNdI+WxptbzYPbnDEW9KfuX18OqX0D6IMKfctBcOt9tO7ylTy1l8BLqneDCeqAN1g3/ts5M0
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:f693:9fff:fef4:a293])
 (user=bgardon job=sendgmr) by 2002:a17:90a:ba8d:: with SMTP id
 t13mr4053632pjr.38.1603841862144; Tue, 27 Oct 2020 16:37:42 -0700 (PDT)
Date:   Tue, 27 Oct 2020 16:37:31 -0700
In-Reply-To: <20201027233733.1484855-1-bgardon@google.com>
Message-Id: <20201027233733.1484855-4-bgardon@google.com>
Mime-Version: 1.0
References: <20201027233733.1484855-1-bgardon@google.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
Subject: [PATCH 3/5] KVM: selftests: Simplify demand_paging_test with timespec_diff_now
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper function to get the current time and return the time since
a given start time. Use that function to simplify the timekeeping in the
demand paging test.

This series was tested by running the following invocations on an Intel
Skylake machine:
dirty_log_perf_test -b 20m -i 100 -v 64
dirty_log_perf_test -b 20g -i 5 -v 4
dirty_log_perf_test -b 4g -i 5 -v 32
demand_paging_test -b 20m -v 64
demand_paging_test -b 20g -v 4
demand_paging_test -b 4g -v 32
All behaved as expected.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/demand_paging_test.c        | 26 +++++++++----------
 .../testing/selftests/kvm/include/test_util.h |  1 +
 tools/testing/selftests/kvm/lib/test_util.c   | 15 +++++++++--
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 4251e98ceb69f..7de6feb000760 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -50,7 +50,8 @@ static void *vcpu_worker(void *data)
 	int vcpu_id = vcpu_args->vcpu_id;
 	struct kvm_vm *vm = perf_test_args.vm;
 	struct kvm_run *run;
-	struct timespec start, end, ts_diff;
+	struct timespec start;
+	struct timespec ts_diff;
 
 	vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
 	run = vcpu_state(vm, vcpu_id);
@@ -66,8 +67,7 @@ static void *vcpu_worker(void *data)
 			    exit_reason_str(run->exit_reason));
 	}
 
-	clock_gettime(CLOCK_MONOTONIC, &end);
-	ts_diff = timespec_sub(end, start);
+	ts_diff = timespec_diff_now(start);
 	PER_VCPU_DEBUG("vCPU %d execution time: %ld.%.9lds\n", vcpu_id,
 		       ts_diff.tv_sec, ts_diff.tv_nsec);
 
@@ -78,7 +78,7 @@ static int handle_uffd_page_request(int uffd, uint64_t addr)
 {
 	pid_t tid;
 	struct timespec start;
-	struct timespec end;
+	struct timespec ts_diff;
 	struct uffdio_copy copy;
 	int r;
 
@@ -98,10 +98,10 @@ static int handle_uffd_page_request(int uffd, uint64_t addr)
 		return r;
 	}
 
-	clock_gettime(CLOCK_MONOTONIC, &end);
+	ts_diff = timespec_diff_now(start);
 
 	PER_PAGE_DEBUG("UFFDIO_COPY %d \t%ld ns\n", tid,
-		       timespec_to_ns(timespec_sub(end, start)));
+		       timespec_to_ns(ts_diff));
 	PER_PAGE_DEBUG("Paged in %ld bytes at 0x%lx from thread %d\n",
 		       perf_test_args.host_page_size, addr, tid);
 
@@ -123,7 +123,8 @@ static void *uffd_handler_thread_fn(void *arg)
 	int pipefd = uffd_args->pipefd;
 	useconds_t delay = uffd_args->delay;
 	int64_t pages = 0;
-	struct timespec start, end, ts_diff;
+	struct timespec start;
+	struct timespec ts_diff;
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	while (!quit_uffd_thread) {
@@ -192,8 +193,7 @@ static void *uffd_handler_thread_fn(void *arg)
 		pages++;
 	}
 
-	clock_gettime(CLOCK_MONOTONIC, &end);
-	ts_diff = timespec_sub(end, start);
+	ts_diff = timespec_diff_now(start);
 	PER_VCPU_DEBUG("userfaulted %ld pages over %ld.%.9lds. (%f/sec)\n",
 		       pages, ts_diff.tv_sec, ts_diff.tv_nsec,
 		       pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
@@ -257,7 +257,8 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 	pthread_t *vcpu_threads;
 	pthread_t *uffd_handler_threads = NULL;
 	struct uffd_handler_args *uffd_args = NULL;
-	struct timespec start, end, ts_diff;
+	struct timespec start;
+	struct timespec ts_diff;
 	int *pipefds = NULL;
 	struct kvm_vm *vm;
 	int vcpu_id;
@@ -335,9 +336,9 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 		PER_VCPU_DEBUG("Joined thread for vCPU %d\n", vcpu_id);
 	}
 
-	pr_info("All vCPU threads joined\n");
+	ts_diff = timespec_diff_now(start);
 
-	clock_gettime(CLOCK_MONOTONIC, &end);
+	pr_info("All vCPU threads joined\n");
 
 	if (use_uffd) {
 		char c;
@@ -351,7 +352,6 @@ static void run_test(enum vm_guest_mode mode, bool use_uffd,
 		}
 	}
 
-	ts_diff = timespec_sub(end, start);
 	pr_info("Total guest execution time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 	pr_info("Overall demand paging rate: %f pgs/sec\n",
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 5eb01bf51b86f..1cc036ddb0c5e 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -64,5 +64,6 @@ int64_t timespec_to_ns(struct timespec ts);
 struct timespec timespec_add_ns(struct timespec ts, int64_t ns);
 struct timespec timespec_add(struct timespec ts1, struct timespec ts2);
 struct timespec timespec_sub(struct timespec ts1, struct timespec ts2);
+struct timespec timespec_diff_now(struct timespec start);
 
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 689e97c27ee24..1a46c2c48c7cb 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -4,10 +4,13 @@
  *
  * Copyright (C) 2020, Google LLC.
  */
-#include <stdlib.h>
+
+#include <assert.h>
 #include <ctype.h>
 #include <limits.h>
-#include <assert.h>
+#include <stdlib.h>
+#include <time.h>
+
 #include "test_util.h"
 
 /*
@@ -81,6 +84,14 @@ struct timespec timespec_sub(struct timespec ts1, struct timespec ts2)
 	return timespec_add_ns((struct timespec){0}, ns1 - ns2);
 }
 
+struct timespec timespec_diff_now(struct timespec start)
+{
+	struct timespec end;
+
+	clock_gettime(CLOCK_MONOTONIC, &end);
+	return timespec_sub(end, start);
+}
+
 void print_skip(const char *fmt, ...)
 {
 	va_list ap;
-- 
2.29.0.rc2.309.g374f81d7ae-goog

