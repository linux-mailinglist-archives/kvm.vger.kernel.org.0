Return-Path: <kvm+bounces-8844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 611B185720C
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 00:55:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93A8D1C2243D
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 23:55:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3896C1474DB;
	Thu, 15 Feb 2024 23:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T+1WAAsc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D171474C8
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 23:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041266; cv=none; b=PMDMXn5oahafyXgzTDnEBBisn5fcCUnIQgjxkk8QKTlnjhr8sVJBDWiLI3XfF+rr7hCC9jaDMRdBnFzqVJCzO0+PjFYKzb81n9hZqYy41+pBVpyrEGAUQnED/kOCvK/86SSWzXzGl2y2Y6RE11T+mFgWpL1maPR/Zn+q/506oV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041266; c=relaxed/simple;
	bh=a7eKLWtaoxoL7cVfHGdohyj2AF5ZACc8LDLsIrxBv08=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k2CeMtQkk5vaB2sWP4NrkD02rEX+p3HBtbK/1PHOFducHqtQQAZL/TrYogtVybf4CEP2nK+XxXia+6OCTblpakMcYxfM/T1sri54HK6vfiDQT5rxBZvyCrn57He63z800BN/twn8jhiCC3di/dzXYghzPwurRWPbZJ2Lhy1EQdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T+1WAAsc; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b267bf11so256961276.2
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 15:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041264; x=1708646064; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp/0bdTdp/wTZtC8stanHESpr8tHISyMMSdV5bn6+Y0=;
        b=T+1WAAscF0gL3YptIoW1pfA/RiwY1yeuNvYiPtkNwv1wX4r2TbBUkB9SZOBBofD2Z8
         wGqwyapSzVC/0Qsn9KOZd6/8Ffy6lOAMNpm2jxMspVrP/2E/njKlbKeOuTJWa5CYWY55
         gsFdZ8XKLiZWF6zvQL9xpiup6RqKFzIMKVxaO4Q0opVMvzBcnCkO2RmInFnkvkVlA6cG
         LK+OOPT8p6U2XMT7b61AQCrGz6l8krvvMxniYWQbmpF5asjd88mVj/xVhyvr5PV1o+/w
         B+JrIdGxGUeq1AWXdremS1DCe7XK228ZCriH/oYMYDF84LWMCf/h9OygD0+dUhk+JoWA
         1UnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041264; x=1708646064;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp/0bdTdp/wTZtC8stanHESpr8tHISyMMSdV5bn6+Y0=;
        b=tQXNxQFYIaPXnl82flQ9DNk/vgiyNrOnEQsfSaH7IrbrWdTtMRrBCGeiRB0fT+idoQ
         GbxNRL/TxuvzvosOHnJr01lNBLd7JaRotUlvTR3zDKQ0i2/dGvUDAaQ2kzWX7fwfs2lY
         MMPmpv5SGi2PqUWML2U1G/SDyNU9+v1Upo5rAdkrf1ru438WEfCtN8UGh9eljbC3ITps
         9pgWQyjaPmmGvl9/8EPIY8ljtBHxujMyC8DaHmSMpVhhKO3dmDNVH/T3LIHpk5a7r1qT
         7T4cuBBZFaB9CC15NPkv89j5LWwm0OxKQ+ucYSbITSPUrOMo8KRAPSrtbcAbUgGEVUWT
         yjSg==
X-Forwarded-Encrypted: i=1; AJvYcCWvvRL2TUsFlPfAsWXIXEESpiKsrdTOqAJOzBLtTZznc69TMS5js8lsGC6gUGDJS2jHHh2xBJQwAWOApZQN1joi+XNb
X-Gm-Message-State: AOJu0Yw6MZZ486+i3LhG8W5dlzyqkgjQ/ud+QPjzmcVUL3d+sAPK6HQF
	whCCQLZOzUA9kwi501J7qbvkCljqx3kGuBWXcyYqdQ8Vx4DSSrHrHF+taAUC0XJia57UdsFlrqA
	bhI5buhG+bg==
X-Google-Smtp-Source: AGHT+IGo9PYNpFMRSL7MDuuM071FwDbG6033GhiZwLkGjhQJG67+BYPtQK3FZHpNcH0hyJDMDR4MZgbnf0Bqqw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a5b:ca:0:b0:dc6:b813:5813 with SMTP id
 d10-20020a5b00ca000000b00dc6b8135813mr123862ybp.9.1708041263965; Thu, 15 Feb
 2024 15:54:23 -0800 (PST)
Date: Thu, 15 Feb 2024 23:54:03 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-13-amoorthy@google.com>
Subject: [PATCH v7 12/14] KVM: selftests: Use EPOLL in userfaultfd_util reader
 threads and signal errors via TEST_ASSERT
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

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
2.44.0.rc0.258.g7320e95886-goog


