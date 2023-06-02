Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBC172075D
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236811AbjFBQUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236939AbjFBQUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:20:07 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1517DB6
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:20:06 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5695f6ebd85so9335627b3.3
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722805; x=1688314805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PgT1Uj5zI5TzwBHmSWJMIEOClx3Ozd7mBri9eACyvhU=;
        b=DH+sHpekA4CtcNNFE2ts4GyEJexMMg0gcpP/Pdnx1rkU1sDHqbpzd+MLPkewMSfiAw
         pf6Mx59ADFAhnPz6Ay8YErOP+qzH9uVKPwoLoLOWjEX1kTiH8UD9WWZFC4k8vAAwQg1m
         PhTwJ5YpDK6F9LKeOh3Td44IubbolyfnC4Nk6YeLlIvMTpn7wWTkF/3SQQP7r8z6c5Pu
         PIsqG2FokCpKXOAhs0IGVnYp4jWpuovE2fodhWPnAl8dYIUN9Gc1hR+GKg2cv5/c6+zD
         lhHIvF4IgvBow0xjvqbGJZMslesbwKDBCbv+bwrDA71OTIjyMTsegJLAYbwFy3iDlyz/
         NNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722805; x=1688314805;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PgT1Uj5zI5TzwBHmSWJMIEOClx3Ozd7mBri9eACyvhU=;
        b=T2Rp/OpIaCEZmkfZtUkPiYYgvBUDacehKxX8eTMcSs4FmxN1pE0qJDODZW7MCFx/xS
         pIpDmv9GUk5aT8GdaXL19gbXiYrHlIk0IQ7KInlb3U8UE3W3Cb+MrRCQQz2VJNeY3tMn
         PjX/9+bYyrwN7dpGiGRgyUFjYEea8RTk6LB/cSF5iNiM7j1tBlqBBdvTt5P9CDT0EITb
         qau04csyDpgVv8+akbrs5aggCih1q7VCkDdw0Fclou69iz6imKvy5NOJBSYrxkNCMdqR
         8iXWQeO8VDB9/vYqDu+svbX2EG2XNnNYLEJVmGGixyw1Gf8Tj4FBwmIh+nR8cKjEC3Uh
         NFog==
X-Gm-Message-State: AC+VfDysMD9miiurM+IzESovFntVduxZXkqixwaYJwXfsNeu6QjPDiAw
        hIGUIRJeor9LzzyJiY+e/QfGaK66BPKE+g==
X-Google-Smtp-Source: ACHHUZ6FuEoBJYVj6pYeKpfGgq/woKRX0q7sUC5NxE1Bbdm0MKKd8BKDYRrzajT7ySnJCtTNqv1sGxdIHbreyg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a5b:804:0:b0:bac:a7d5:f895 with SMTP id
 x4-20020a5b0804000000b00baca7d5f895mr1209528ybp.10.1685722805363; Fri, 02 Jun
 2023 09:20:05 -0700 (PDT)
Date:   Fri,  2 Jun 2023 16:19:19 +0000
In-Reply-To: <20230602161921.208564-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602161921.208564-15-amoorthy@google.com>
Subject: [PATCH v4 14/16] KVM: selftests: Use EPOLL in userfaultfd_util reader
 threads and signal errors via TEST_ASSERT
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, bgardon@google.com,
        dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
        peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With multiple reader threads POLLing a single UFFD, the test suffers
from the thundering herd problem: performance degrades as the number of
reader threads is increased. Solve this issue [1] by switching the
the polling mechanism to EPOLL + EPOLLEXCLUSIVE.

Also, change the error-handling convention of uffd_handler_thread_fn.
Instead of just printing errors and returning early from the polling
loop, check for them via TEST_ASSERT. "return NULL" is reserved for a
successful exit from uffd_handler_thread_fn, ie one triggered by a
write to the exit pipe.

Performance samples generated by the command in [2] are given below.

Num Reader Threads, Paging Rate (POLL), Paging Rate (EPOLL)
1      249k      185k
2      201k      235k
4      186k      155k
16     150k      217k
32     89k       198k

[1] Single-vCPU performance does suffer somewhat.
[2] ./demand_paging_test -u MINOR -s shmem -v 4 -o -r <num readers>

Signed-off-by: Anish Moorthy <amoorthy@google.com>
Acked-by: James Houghton <jthoughton@google.com>
---
 .../selftests/kvm/demand_paging_test.c        |  1 -
 .../selftests/kvm/lib/userfaultfd_util.c      | 74 +++++++++----------
 2 files changed, 35 insertions(+), 40 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 35935874c690..115194e19ad9 100644
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
index 6f220aa4fb08..2a179133645a 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -16,6 +16,7 @@
 #include <poll.h>
 #include <pthread.h>
 #include <linux/userfaultfd.h>
+#include <sys/epoll.h>
 #include <sys/syscall.h>
 
 #include "kvm_util.h"
@@ -32,60 +33,55 @@ static void *uffd_handler_thread_fn(void *arg)
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
+		    "Failed to add uffd to epollfd");
+
+	evt.events = EPOLLIN;
+	evt.data.u32 = 1;
+	TEST_ASSERT(epoll_ctl(epollfd, EPOLL_CTL_ADD, reader_args->pipe, &evt) == 0,
+		    "Failed to add pipe to epollfd");
 
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
+		TEST_ASSERT(r == 1,
+			    "Unexpected number of events (%d) from epoll, errno = %d",
+			    r, errno);
 
-		if (pollfd[0].revents & POLLERR) {
-			pr_info("uffd revents has POLLERR");
-			return NULL;
-		}
+		if (evt.data.u32 == 1) {
+			char tmp_chr;
 
-		if (pollfd[1].revents & POLLIN) {
-			r = read(pollfd[1].fd, &tmp_chr, 1);
+			TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
+				    "Reader thread received EPOLLERR or EPOLLHUP on pipe.");
+			r = read(reader_args->pipe, &tmp_chr, 1);
 			TEST_ASSERT(r == 1,
-				    "Error reading pipefd in UFFD thread\n");
+				    "Error reading pipefd in uffd reader thread");
 			break;
 		}
 
-		if (!(pollfd[0].revents & POLLIN))
-			continue;
+		TEST_ASSERT(!(evt.events & (EPOLLERR | EPOLLHUP)),
+			    "Reader thread received EPOLLERR or EPOLLHUP on uffd.");
 
 		r = read(uffd, &msg, sizeof(msg));
 		if (r == -1) {
-			if (errno == EAGAIN)
-				continue;
-			pr_info("Read of uffd got errno %d\n", errno);
-			return NULL;
+			TEST_ASSERT(errno == EAGAIN,
+				    "Error reading from UFFD: errno = %d", errno);
+			continue;
 		}
 
-		if (r != sizeof(msg)) {
-			pr_info("Read on uffd returned unexpected size: %d bytes", r);
-			return NULL;
-		}
+		TEST_ASSERT(r == sizeof(msg),
+			    "Read on uffd returned unexpected number of bytes (%d)", r);
 
 		if (!(msg.event & UFFD_EVENT_PAGEFAULT))
 			continue;
@@ -93,8 +89,8 @@ static void *uffd_handler_thread_fn(void *arg)
 		if (reader_args->delay)
 			usleep(reader_args->delay);
 		r = reader_args->handler(reader_args->uffd_mode, uffd, &msg);
-		if (r < 0)
-			return NULL;
+		TEST_ASSERT(r >= 0,
+			    "Reader thread handler fn returned negative value %d", r);
 		pages++;
 	}
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

