Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215E5697352
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 02:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbjBOBRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 20:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbjBOBRE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 20:17:04 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAAF1D92B
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:37 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-507aac99fdfso180068687b3.11
        for <kvm@vger.kernel.org>; Tue, 14 Feb 2023 17:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dwL8ByVHxP2Vn+hru962x6SVu1Z4scs8obV2NcAq9Xw=;
        b=nF5azlsvaUPuLi2Vj+0IbYrSF3V/xn366MyyLZ3Jae+8x3/iP+ZDIUlsGYm85sR+p9
         XFc6Q/cZovQc13uI+9HyCZbHed6ABdMgTnji5JqA0nXqWu5psXe0CHoap1MCHuT+Pvok
         gBGzLXdSt3eaYM29bEnQ6KGDZhow2w5G4yIPV0bEeZBXf6imudjiZumt0m3qzWmbeGFG
         Fc/BKnSZk3Gje0FaNFVBe/FnFEI33bb3brQ8hJhuHDeLsFGEvB+Lh3CkQJeGijFNLi42
         59fCNSqoqu9ZOV2CBt9e2wWSyA9fEya0StFpuzclrRDPeizLHeeoCJD8ix4ljLQuZdlV
         5jVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dwL8ByVHxP2Vn+hru962x6SVu1Z4scs8obV2NcAq9Xw=;
        b=WERyYcuNLox3GGmXgL2cOitf+Zs9upXSyyIBzFRMwJ/fA3DkfV9WtwU1mAhVsFmMKH
         f+RTFNbYg8KSYL/IuOWwHVV8+bS/0gQf1C9O22Mcfj3DwCxLpQPOFglBY7TE5MSOkGlr
         uAkbDx47A/AwGRpZ5EiOX8hAXJ7yA4rhZfFgdNDJHNaDF2jz/qPKQ3l1OwaUZfELfBv/
         RfIr19UKIjkI2k93t4dFsOOj9mtmF7nA3dxE7nwTZ8MijQi++remCr1PJ3R+V3mhXLqn
         RbnEW/aiuNJOwLuh3OAYbHEXU/9uo5M+wb5TfHizJl0B8kE5ZC62TOApMpgT7crIuvS4
         V7ag==
X-Gm-Message-State: AO0yUKW76M16stdavLr6IYSukjryOcIgFr6TXmn7O4EgCK1JjhiUhh22
        BIv0Z+JUvXbtYp77knaNbfO1x02W2P41dg==
X-Google-Smtp-Source: AK7set++GKVNxmpgH1rdfjz4+NZpZFu6Zk2KKMAVxQ5/m+n6r49ItkqSxg7WKhOg7H5N/ibdF++6Er6PpweQNg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:6503:0:b0:52e:c82e:56f with SMTP id
 z3-20020a816503000000b0052ec82e056fmr73265ywb.14.1676423793545; Tue, 14 Feb
 2023 17:16:33 -0800 (PST)
Date:   Wed, 15 Feb 2023 01:16:09 +0000
In-Reply-To: <20230215011614.725983-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230215011614.725983-1-amoorthy@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230215011614.725983-4-amoorthy@google.com>
Subject: [PATCH 3/8] selftests/kvm: Switch demand paging uffd readers to epoll
From:   Anish Moorthy <amoorthy@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With multiple reader threads for each UFFD, the test suffers from the
thundering herd problem: performance degrades as the number of reader
threads is increased. Switching the readers over to EPOLL (which offers
EPOLLEXCLUSIVE) solves this problem, although base-case performance does
suffer significantly.

This commit also changes the error-handling convention of
uffd_handler_thread_fn: instead of checking for errors and returning
when they're found, we just use TEST_ASSERT instead, and "return NULL"
indicates a successful exit of the function (ie, triggered by a write to
the corresponding pipe).

Performance samples are given below, generated by the command in [1].

Num Reader Threads, Paging Rate (POLL), Paging Rate (EPOLL)
1      249k      185k
2      201k      235k
4      186k      155k
16     150k      217k
32     89k       198k

[1] ./demand_paging_test -u MINOR -s MINOR -s shmem -v 4 -o -r <n>

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/demand_paging_test.c        |  1 -
 .../selftests/kvm/lib/userfaultfd_util.c      | 76 +++++++++----------
 2 files changed, 37 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 3c1d5b81c9822..34d5ba2044a2c 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -13,7 +13,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
-#include <poll.h>
 #include <pthread.h>
 #include <linux/userfaultfd.h>
 #include <sys/syscall.h>
diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
index 2723ee1e3e1b2..863840d340105 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -16,6 +16,7 @@
 #include <poll.h>
 #include <pthread.h>
 #include <linux/userfaultfd.h>
+#include <sys/epoll.h>
 #include <sys/syscall.h>
 
 #include "kvm_util.h"
@@ -32,60 +33,56 @@ static void *uffd_handler_thread_fn(void *arg)
 	int64_t pages = 0;
 	struct timespec start;
 	struct timespec ts_diff;
+	int epollfd;
+	struct epoll_event evt;
+
+	epollfd = epoll_create(1);
+	TEST_ASSERT(epollfd >= 0, "Failed to create epollfd.");
+
+	evt.events = EPOLLIN | EPOLLEXCLUSIVE;
+	evt.data.u32 = 0;
+	TEST_ASSERT(epoll_ctl(epollfd, EPOLL_CTL_ADD, uffd, &evt) == 0,
+				"Failed to add uffd to epollfd");
+
+	evt.events = EPOLLIN;
+	evt.data.u32 = 1;
+	TEST_ASSERT(epoll_ctl(epollfd, EPOLL_CTL_ADD, reader_args->pipe, &evt) == 0,
+				"Failed to add pipe to epollfd");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	while (1) {
 		struct uffd_msg msg;
-		struct pollfd pollfd[2];
-		char tmp_chr;
 		int r;
 
-		pollfd[0].fd = uffd;
-		pollfd[0].events = POLLIN;
-		pollfd[1].fd = reader_args->pipe;
-		pollfd[1].events = POLLIN;
-
-		r = poll(pollfd, 2, -1);
-		switch (r) {
-		case -1:
-			pr_info("poll err");
-			continue;
-		case 0:
-			continue;
-		case 1:
-			break;
-		default:
-			pr_info("Polling uffd returned %d", r);
-			return NULL;
-		}
+		r = epoll_wait(epollfd, &evt, 1, -1);
+		TEST_ASSERT(
+			r == 1,
+			"Unexpected number of events (%d) returned by epoll, errno = %d",
+			r, errno);
 
-		if (pollfd[0].revents & POLLERR) {
-			pr_info("uffd revents has POLLERR");
-			return NULL;
-		}
+		if (evt.data.u32 == 1) {
+			char tmp_chr;
 
-		if (pollfd[1].revents & POLLIN) {
-			r = read(pollfd[1].fd, &tmp_chr, 1);
+			TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
+						"Reader thread received EPOLLERR or EPOLLHUP on pipe.");
+			r = read(reader_args->pipe, &tmp_chr, 1);
 			TEST_ASSERT(r == 1,
-				    "Error reading pipefd in UFFD thread\n");
+						"Error reading pipefd in uffd reader thread");
 			return NULL;
 		}
 
-		if (!(pollfd[0].revents & POLLIN))
-			continue;
+		TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
+					"Reader thread received EPOLLERR or EPOLLHUP on uffd.");
 
 		r = read(uffd, &msg, sizeof(msg));
 		if (r == -1) {
-			if (errno == EAGAIN)
-				continue;
-			pr_info("Read of uffd got errno %d\n", errno);
-			return NULL;
+			TEST_ASSERT(errno == EAGAIN,
+						"Error reading from UFFD: errno = %d", errno);
+			continue;
 		}
 
-		if (r != sizeof(msg)) {
-			pr_info("Read on uffd returned unexpected size: %d bytes", r);
-			return NULL;
-		}
+		TEST_ASSERT(r == sizeof(msg),
+					"Read on uffd returned unexpected number of bytes (%d)", r);
 
 		if (!(msg.event & UFFD_EVENT_PAGEFAULT))
 			continue;
@@ -93,8 +90,9 @@ static void *uffd_handler_thread_fn(void *arg)
 		if (reader_args->delay)
 			usleep(reader_args->delay);
 		r = reader_args->handler(reader_args->uffd_mode, uffd, &msg);
-		if (r < 0)
-			return NULL;
+		TEST_ASSERT(
+			r >= 0,
+			"Reader thread handler function returned negative value %d", r);
 		pages++;
 	}
 
-- 
2.39.1.581.gbfd45094c4-goog

