Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4E7799240
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344020AbjIHWaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343820AbjIHWaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:30:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98932106
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:30:04 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-cf4cb742715so2482161276.2
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212203; x=1694817003; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XNvo3KyCXhe4/JPrBh+FqhkqSizcDNuUzKgVoWMo32M=;
        b=Z8h9+7UKUCHXZL6Zso+geVwXDg6C+ybBRW9kkeztHg9myQQIf/o+O2gtbeDyclnfuj
         WFMLwZssTcoLamRHKMNhlwSRLYDGqIwdQUzyGuVaAm3680ro2z5QlzSPD12durXk6dzC
         26v56QEXqgqTW+toIIPb8DX3ZQJ354+LMCbe4ZSp4ewjMyK3nhFOFmes/E9DuafQtML6
         FZpTmKdjdAUWFEzoUU869IJjDd64A6Ow07mEyxQWg+qPhcidSarZfJQgNpmcxeMyU5G/
         XX9rHHGT0xw4yWYCVugtIt+wzkPUGhlhwdZ/CiY5g7C/LAUlzZ2C0jMHCz5AS+xXWIMD
         Q7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212203; x=1694817003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNvo3KyCXhe4/JPrBh+FqhkqSizcDNuUzKgVoWMo32M=;
        b=nW7mlvOanG6ersGPspR8Y9T69Y2GSt1nY4XRJlH6O+wHDytkF5eQ3f/TipCEhNvbwg
         wkLJTaAj6yagkL2ALGLsZ+uX9ftOa0XgxlQIDrdjzRCsVbl/yjRd+mMYx+DJZxPWzuJn
         VqawgrihJP72fivwphEGEjieCPmD0LYxByXiG6elBjeBlXlEdL4NS++RPVpN0/2eQqFZ
         Kjmwg/zcwwM6SKsulC9rO2YsPMsAOzQ0ger//atsf6qKw9ozLQ5UbsbvgTBTzWvXQwqv
         UuDD0JvxyJwHQRWXnd9kzDGU8ty4DuRjxIESJcwLQhXkJswJzdYEmu2bmDY7aNnXrsE0
         +EqA==
X-Gm-Message-State: AOJu0YzXGd2xpdL+hsuvmccoVxcy/bDwjdhd1KF9y37ga+RLQfDI92Mx
        Qf3vkD34MNky29QlJinvml7wjE2hIyXSzg==
X-Google-Smtp-Source: AGHT+IHVTKhRKMD4mfkphXrMFXILZjv8PZl6WZRe9vF1bvuSlGumwwco+OrsrNQCiYRM232dhWiDHy6su+dfHw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:748f:0:b0:d47:4b58:a19e with SMTP id
 p137-20020a25748f000000b00d474b58a19emr77254ybc.11.1694212202919; Fri, 08 Sep
 2023 15:30:02 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:29:02 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-16-amoorthy@google.com>
Subject: [PATCH v5 15/17] KVM: selftests: Use EPOLL in userfaultfd_util reader
 threads and signal errors via TEST_ASSERT
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
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
index f7897a951f90..0455347f932a 100644
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
2.42.0.283.g2d96d420d3-goog

