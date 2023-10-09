Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEB77BE47C
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 17:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376536AbjJIPSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 11:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376903AbjJIPSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 11:18:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2D1D8
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 08:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696864646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xDBWSVPFzuu4QHrut7TRW4v5VVDIvv3bRJmPztxHrTA=;
        b=JbqJtNXUBlz3M1eUYOI1r1fZuRSCOeZEGP5dX0caEZLdKrMp9enpXq5N9Ur4Kk49nE1ihc
        YRXaDMjG7Y/J3lfXXyJOFS0zKoiKTxNsHI+62io4sl7icmas+xgViTRvtXbsA7zjoUuXlK
        VdUECxfXUqg2FlfY1yD1kznGKBohAY0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-a17MxEk6N4iKmBSTbhEv5w-1; Mon, 09 Oct 2023 11:17:24 -0400
X-MC-Unique: a17MxEk6N4iKmBSTbhEv5w-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5218b9647a8so3765408a12.1
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 08:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696864643; x=1697469443;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xDBWSVPFzuu4QHrut7TRW4v5VVDIvv3bRJmPztxHrTA=;
        b=QZBkUwfjhuvoZUMRdw+4X3oBhMqIhLuVBr9CgbYwFijbP9wrL5ZPCff+WwmzN3nQ3Z
         t1NA4F7n0wAgRdryq05i7CuP9dGz3HEzGkDXCiTi6LLHY+0+XdWMMNeGzF1PVtMwhs9R
         x1oTJEXaJsdVH4UeETUCT1jVVad6nMoxtUmjdXKlR28FxvITL3jgwmfZz9lWeDniMex6
         Wt+bnxv25AB0Xrcp2Ys++1AzbiKrBy3oN5QuDaUIfWRpbl+HdIl8WL84v/UnUHy4wvKZ
         B6WL6/cbOCtLj7vmZDa4VpuIa7SmltbtKo7qR2Cq5VK6Jm8lJRsSdju2687RWrMbZedE
         dYNg==
X-Gm-Message-State: AOJu0Yzq/DRNvn4EiQQoR2FTFlhtiHqQzUDRzFdMJvdSqOc0RBGkX5pi
        k4HLN9h1HagAQwkciGKNFZd+fk1b1J4KcK5mVc3skF95ql/3c6UAZ39bLiOG3SNMfe8a0m2wbc7
        3Oj/SaMz327LR
X-Received: by 2002:aa7:d94e:0:b0:530:bd6b:7a94 with SMTP id l14-20020aa7d94e000000b00530bd6b7a94mr15374221eds.24.1696864643565;
        Mon, 09 Oct 2023 08:17:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnQDbgpMOQGL0rExH1mpINYOC2NgqVRkR+I9iL2/NESaBp8wA2wFKQm7R3pmh+oHVvC56AOQ==
X-Received: by 2002:aa7:d94e:0:b0:530:bd6b:7a94 with SMTP id l14-20020aa7d94e000000b00530bd6b7a94mr15374194eds.24.1696864643232;
        Mon, 09 Oct 2023 08:17:23 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id o14-20020aa7c50e000000b0052595b17fd4sm6146625edq.26.2023.10.09.08.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 08:17:22 -0700 (PDT)
Date:   Mon, 9 Oct 2023 17:17:20 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [PATCH net-next v3 10/12] test/vsock: MSG_ZEROCOPY flag tests
Message-ID: <q3246d73b2u6lquey2b5ie4xzmsoe6lqqq6nqaq6drne2lx6tt@fpe6gdvuqzll>
References: <20231007172139.1338644-1-avkrasnov@salutedevices.com>
 <20231007172139.1338644-11-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231007172139.1338644-11-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 07, 2023 at 08:21:37PM +0300, Arseniy Krasnov wrote:
>This adds three tests for MSG_ZEROCOPY feature:
>1) SOCK_STREAM tx with different buffers.
>2) SOCK_SEQPACKET tx with different buffers.
>3) SOCK_STREAM test to read empty error queue of the socket.
>
>Patch also works as preparation for the next patches for tools in this
>patchset: vsock_perf and vsock_uring_test:
>1) Adds several new functions to util.c - they will be also used by
>   vsock_uring_test.
>2) Adds two new functions for MSG_ZEROCOPY handling to a new header
>   file - such header will be shared between vsock_test, vsock_perf and
>   vsock_uring_test, thus avoiding code copy-pasting.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v1 -> v2:
>  * Move 'SOL_VSOCK' and 'VSOCK_RECVERR' from 'util.c' to 'util.h'.
> v2 -> v3:
>  * Patch was reworked. Now it is also preparation patch (see commit
>    message). Shared stuff for 'vsock_perf' and tests is placed to a
>    new header file, while shared code between current test tool and
>    future uring test is placed to the 'util.c'. I think, that making
>    this patch as preparation allows to reduce number of changes in the
>    next patches in this patchset.
>  * Make 'struct vsock_test_data' private by placing it to the .c file.
>    Also add comments to this struct to clarify sense of its fields.
>
> tools/testing/vsock/Makefile              |   2 +-
> tools/testing/vsock/msg_zerocopy_common.h |  92 ++++++
> tools/testing/vsock/util.c                | 110 +++++++
> tools/testing/vsock/util.h                |   5 +
> tools/testing/vsock/vsock_test.c          |  16 +
> tools/testing/vsock/vsock_test_zerocopy.c | 367 ++++++++++++++++++++++
> tools/testing/vsock/vsock_test_zerocopy.h |  15 +
> 7 files changed, 606 insertions(+), 1 deletion(-)
> create mode 100644 tools/testing/vsock/msg_zerocopy_common.h
> create mode 100644 tools/testing/vsock/vsock_test_zerocopy.c
> create mode 100644 tools/testing/vsock/vsock_test_zerocopy.h
>
>diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
>index 21a98ba565ab..1a26f60a596c 100644
>--- a/tools/testing/vsock/Makefile
>+++ b/tools/testing/vsock/Makefile
>@@ -1,7 +1,7 @@
> # SPDX-License-Identifier: GPL-2.0-only
> all: test vsock_perf
> test: vsock_test vsock_diag_test
>-vsock_test: vsock_test.o timeout.o control.o util.o
>+vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
> vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
> vsock_perf: vsock_perf.o
>
>diff --git a/tools/testing/vsock/msg_zerocopy_common.h b/tools/testing/vsock/msg_zerocopy_common.h
>new file mode 100644
>index 000000000000..ce89f1281584
>--- /dev/null
>+++ b/tools/testing/vsock/msg_zerocopy_common.h
>@@ -0,0 +1,92 @@
>+/* SPDX-License-Identifier: GPL-2.0-only */
>+#ifndef MSG_ZEROCOPY_COMMON_H
>+#define MSG_ZEROCOPY_COMMON_H
>+
>+#include <stdio.h>
>+#include <stdlib.h>
>+#include <sys/types.h>
>+#include <sys/socket.h>
>+#include <linux/errqueue.h>
>+
>+#ifndef SOL_VSOCK
>+#define SOL_VSOCK	287
>+#endif
>+
>+#ifndef VSOCK_RECVERR
>+#define VSOCK_RECVERR	1
>+#endif
>+
>+static void enable_so_zerocopy(int fd)
>+{
>+	int val = 1;
>+
>+	if (setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val))) {
>+		perror("setsockopt");
>+		exit(EXIT_FAILURE);
>+	}
>+}
>+
>+static void vsock_recv_completion(int fd, const bool *zerocopied) __maybe_unused;

To avoid this, maybe we can implement those functions in .c file and
link the object.

WDYT?

Ah, here (cc (GCC) 13.2.1 20230728 (Red Hat 13.2.1-1)) the build is
failing:

In file included from vsock_perf.c:23:
msg_zerocopy_common.h: In function ‘vsock_recv_completion’:
msg_zerocopy_common.h:29:67: error: expected declaration specifiers before ‘__maybe_unused’
    29 | static void vsock_recv_completion(int fd, const bool *zerocopied) __maybe_unused;
       |                                                                   ^~~~~~~~~~~~~~
msg_zerocopy_common.h:31:1: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘{’ token
    31 | {
       | ^

>+static void vsock_recv_completion(int fd, const bool *zerocopied)
>+{
>+	struct sock_extended_err *serr;
>+	struct msghdr msg = { 0 };
>+	char cmsg_data[128];
>+	struct cmsghdr *cm;
>+	ssize_t res;
>+
>+	msg.msg_control = cmsg_data;
>+	msg.msg_controllen = sizeof(cmsg_data);
>+
>+	res = recvmsg(fd, &msg, MSG_ERRQUEUE);
>+	if (res) {
>+		fprintf(stderr, "failed to read error queue: %zi\n", res);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	cm = CMSG_FIRSTHDR(&msg);
>+	if (!cm) {
>+		fprintf(stderr, "cmsg: no cmsg\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (cm->cmsg_level != SOL_VSOCK) {
>+		fprintf(stderr, "cmsg: unexpected 'cmsg_level'\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (cm->cmsg_type != VSOCK_RECVERR) {
>+		fprintf(stderr, "cmsg: unexpected 'cmsg_type'\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	serr = (void *)CMSG_DATA(cm);
>+	if (serr->ee_origin != SO_EE_ORIGIN_ZEROCOPY) {
>+		fprintf(stderr, "serr: wrong origin: %u\n", serr->ee_origin);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (serr->ee_errno) {
>+		fprintf(stderr, "serr: wrong error code: %u\n", serr->ee_errno);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	/* This flag is used for tests, to check that transmission was
>+	 * performed as expected: zerocopy or fallback to copy. If NULL
>+	 * - don't care.
>+	 */
>+	if (!zerocopied)
>+		return;
>+
>+	if (*zerocopied && (serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
>+		fprintf(stderr, "serr: was copy instead of zerocopy\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (!*zerocopied && !(serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
>+		fprintf(stderr, "serr: was zerocopy instead of copy\n");
>+		exit(EXIT_FAILURE);
>+	}
>+}
>+
>+#endif /* MSG_ZEROCOPY_COMMON_H */
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 6779d5008b27..b1770edd8cc1 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -11,10 +11,12 @@
> #include <stdio.h>
> #include <stdint.h>
> #include <stdlib.h>
>+#include <string.h>
> #include <signal.h>
> #include <unistd.h>
> #include <assert.h>
> #include <sys/epoll.h>
>+#include <sys/mman.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -444,3 +446,111 @@ unsigned long hash_djb2(const void *data, size_t len)
>
> 	return hash;
> }
>+
>+size_t iovec_bytes(const struct iovec *iov, size_t iovnum)
>+{
>+	size_t bytes;
>+	int i;
>+
>+	for (bytes = 0, i = 0; i < iovnum; i++)
>+		bytes += iov[i].iov_len;
>+
>+	return bytes;
>+}
>+
>+unsigned long iovec_hash_djb2(const struct iovec *iov, size_t iovnum)
>+{
>+	unsigned long hash;
>+	size_t iov_bytes;
>+	size_t offs;
>+	void *tmp;
>+	int i;
>+
>+	iov_bytes = iovec_bytes(iov, iovnum);
>+
>+	tmp = malloc(iov_bytes);
>+	if (!tmp) {
>+		perror("malloc");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	for (offs = 0, i = 0; i < iovnum; i++) {
>+		memcpy(tmp + offs, iov[i].iov_base, iov[i].iov_len);
>+		offs += iov[i].iov_len;
>+	}
>+
>+	hash = hash_djb2(tmp, iov_bytes);
>+	free(tmp);
>+
>+	return hash;
>+}
>+
>+struct iovec *iovec_from_test_data(const struct iovec *test_iovec, int 
>iovnum)

 From the name this function seems related to vsock_test_data, so I'd
suggest to move this and free_iovec_test_data() in vsock_test_zerocopy.c

>+{
>+	struct iovec *iovec;
>+	int i;
>+
>+	iovec = malloc(sizeof(*iovec) * iovnum);
>+	if (!iovec) {
>+		perror("malloc");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	for (i = 0; i < iovnum; i++) {
>+		iovec[i].iov_len = test_iovec[i].iov_len;
>+
>+		iovec[i].iov_base = mmap(NULL, iovec[i].iov_len,
>+					 PROT_READ | PROT_WRITE,
>+					 MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE,
>+					 -1, 0);
>+		if (iovec[i].iov_base == MAP_FAILED) {
>+			perror("mmap");
>+			exit(EXIT_FAILURE);
>+		}
>+
>+		if (test_iovec[i].iov_base != MAP_FAILED)
>+			iovec[i].iov_base += (uintptr_t)test_iovec[i].iov_base;
>+	}
>+
>+	/* Unmap "invalid" elements. */
>+	for (i = 0; i < iovnum; i++) {
>+		if (test_iovec[i].iov_base == MAP_FAILED) {
>+			if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
>+				perror("munmap");
>+				exit(EXIT_FAILURE);
>+			}
>+		}
>+	}
>+
>+	for (i = 0; i < iovnum; i++) {
>+		int j;
>+
>+		if (test_iovec[i].iov_base == MAP_FAILED)
>+			continue;
>+
>+		for (j = 0; j < iovec[i].iov_len; j++)
>+			((uint8_t *)iovec[i].iov_base)[j] = rand() & 0xff;
>+	}
>+
>+	return iovec;
>+}
>+
>+void free_iovec_test_data(const struct iovec *test_iovec,
>+			  struct iovec *iovec, int iovnum)
>+{
>+	int i;
>+
>+	for (i = 0; i < iovnum; i++) {
>+		if (test_iovec[i].iov_base != MAP_FAILED) {
>+			if (test_iovec[i].iov_base)
>+				iovec[i].iov_base -= (uintptr_t)test_iovec[i].iov_base;
>+
>+			if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
>+				perror("munmap");
>+				exit(EXIT_FAILURE);
>+			}
>+		}
>+	}
>+
>+	free(iovec);
>+}
>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index e5407677ce05..4cacb8d804c1 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -53,4 +53,9 @@ void list_tests(const struct test_case *test_cases);
> void skip_test(struct test_case *test_cases, size_t test_cases_len,
> 	       const char *test_id_str);
> unsigned long hash_djb2(const void *data, size_t len);
>+size_t iovec_bytes(const struct iovec *iov, size_t iovnum);
>+unsigned long iovec_hash_djb2(const struct iovec *iov, size_t iovnum);
>+struct iovec *iovec_from_test_data(const struct iovec *test_iovec, int iovnum);
>+void free_iovec_test_data(const struct iovec *test_iovec,
>+			  struct iovec *iovec, int iovnum);
> #endif /* UTIL_H */
>diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>index da4cb819a183..c1f7bc9abd22 100644
>--- a/tools/testing/vsock/vsock_test.c
>+++ b/tools/testing/vsock/vsock_test.c
>@@ -21,6 +21,7 @@
> #include <poll.h>
> #include <signal.h>
>
>+#include "vsock_test_zerocopy.h"
> #include "timeout.h"
> #include "control.h"
> #include "util.h"
>@@ -1269,6 +1270,21 @@ static struct test_case test_cases[] = {
> 		.run_client = test_stream_shutrd_client,
> 		.run_server = test_stream_shutrd_server,
> 	},
>+	{
>+		.name = "SOCK_STREAM MSG_ZEROCOPY",
>+		.run_client = test_stream_msgzcopy_client,
>+		.run_server = test_stream_msgzcopy_server,
>+	},
>+	{
>+		.name = "SOCK_SEQPACKET MSG_ZEROCOPY",
>+		.run_client = test_seqpacket_msgzcopy_client,
>+		.run_server = test_seqpacket_msgzcopy_server,
>+	},
>+	{
>+		.name = "SOCK_STREAM MSG_ZEROCOPY empty MSG_ERRQUEUE",
>+		.run_client = test_stream_msgzcopy_empty_errq_client,
>+		.run_server = test_stream_msgzcopy_empty_errq_server,
>+	},
> 	{},
> };
>
>diff --git a/tools/testing/vsock/vsock_test_zerocopy.c b/tools/testing/vsock/vsock_test_zerocopy.c
>new file mode 100644
>index 000000000000..af14efdf334b
>--- /dev/null
>+++ b/tools/testing/vsock/vsock_test_zerocopy.c
>@@ -0,0 +1,367 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+/* MSG_ZEROCOPY feature tests for vsock
>+ *
>+ * Copyright (C) 2023 SberDevices.
>+ *
>+ * Author: Arseniy Krasnov <avkrasnov@salutedevices.com>
>+ */
>+
>+#include <stdio.h>
>+#include <stdlib.h>
>+#include <string.h>
>+#include <sys/mman.h>
>+#include <unistd.h>
>+#include <poll.h>
>+#include <linux/errqueue.h>
>+#include <linux/kernel.h>
>+#include <errno.h>
>+
>+#include "control.h"
>+#include "vsock_test_zerocopy.h"
>+#include "msg_zerocopy_common.h"
>+
>+#define PAGE_SIZE		4096

In some tests I saw `sysconf(_SC_PAGESIZE)` is used,
e.g. in selftests/ptrace/peeksiginfo.c:

#ifndef PAGE_SIZE
#define PAGE_SIZE sysconf(_SC_PAGESIZE)
#endif

WDYT?

>+
>+#define VSOCK_TEST_DATA_MAX_IOV 3
>+
>+struct vsock_test_data {
>+	/* This test case if for SOCK_STREAM only. */
>+	bool stream_only;
>+	/* Data must be zerocopied. This field is checked against
>+	 * field 'ee_code' of the 'struct sock_extended_err', which
>+	 * contains bit to detect that zerocopy transmission was
>+	 * fallbacked to copy mode.
>+	 */
>+	bool zerocopied;
>+	/* Enable SO_ZEROCOPY option on the socket. Without enabled
>+	 * SO_ZEROCOPY, every MSG_ZEROCOPY transmission will behave
>+	 * like without MSG_ZEROCOPY flag.
>+	 */
>+	bool so_zerocopy;
>+	/* 'errno' after 'sendmsg()' call. */
>+	int sendmsg_errno;
>+	/* Number of valid elements in 'vecs'. */
>+	int vecs_cnt;
>+	/* Array how to allocate buffers for test.
>+	 * 'iov_base' == NULL -> valid buf: mmap('iov_len').
>+	 *
>+	 * 'iov_base' == MAP_FAILED -> invalid buf:
>+	 *               mmap('iov_len'), then munmap('iov_len').
>+	 *               'iov_base' still contains result of
>+	 *               mmap().
>+	 *
>+	 * 'iov_base' == number -> unaligned valid buf:
>+	 *               mmap('iov_len') + number.
>+	 */
>+	struct iovec vecs[VSOCK_TEST_DATA_MAX_IOV];
>+};
>+
>+static struct vsock_test_data test_data_array[] = {
>+	/* Last element has non-page aligned size. */
>+	{
>+		.zerocopied = true,
>+		.so_zerocopy = true,
>+		.sendmsg_errno = 0,
>+		.vecs_cnt = 3,
>+		{
>+			{ NULL, PAGE_SIZE },
>+			{ NULL, PAGE_SIZE },
>+			{ NULL, 200 }
>+		}
>+	},
>+	/* All elements have page aligned base and size. */
>+	{
>+		.zerocopied = true,
>+		.so_zerocopy = true,
>+		.sendmsg_errno = 0,
>+		.vecs_cnt = 3,
>+		{
>+			{ NULL, PAGE_SIZE },
>+			{ NULL, PAGE_SIZE * 2 },
>+			{ NULL, PAGE_SIZE * 3 }
>+		}
>+	},
>+	/* All elements have page aligned base and size. But
>+	 * data length is bigger than 64Kb.
>+	 */
>+	{
>+		.zerocopied = true,
>+		.so_zerocopy = true,
>+		.sendmsg_errno = 0,
>+		.vecs_cnt = 3,
>+		{
>+			{ NULL, PAGE_SIZE * 16 },
>+			{ NULL, PAGE_SIZE * 16 },
>+			{ NULL, PAGE_SIZE * 16 }
>+		}
>+	},
>+	/* Middle element has both non-page aligned base and size. */
>+	{
>+		.zerocopied = true,
>+		.so_zerocopy = true,
>+		.sendmsg_errno = 0,
>+		.vecs_cnt = 3,
>+		{
>+			{ NULL, PAGE_SIZE },
>+			{ (void *)1, 100 },
>+			{ NULL, PAGE_SIZE }
>+		}
>+	},
>+	/* Middle element is unmapped. */
>+	{
>+		.zerocopied = false,
>+		.so_zerocopy = true,
>+		.sendmsg_errno = ENOMEM,
>+		.vecs_cnt = 3,
>+		{
>+			{ NULL, PAGE_SIZE },
>+			{ MAP_FAILED, PAGE_SIZE },
>+			{ NULL, PAGE_SIZE }
>+		}
>+	},
>+	/* Valid data, but SO_ZEROCOPY is off. This
>+	 * will trigger fallback to copy.
>+	 */
>+	{
>+		.zerocopied = false,
>+		.so_zerocopy = false,
>+		.sendmsg_errno = 0,
>+		.vecs_cnt = 1,
>+		{
>+			{ NULL, PAGE_SIZE }
>+		}
>+	},
>+	/* Valid data, but message is bigger than peer's
>+	 * buffer, so this will trigger fallback to copy.
>+	 * This test is for SOCK_STREAM only, because
>+	 * for SOCK_SEQPACKET, 'sendmsg()' returns EMSGSIZE.
>+	 */
>+	{
>+		.stream_only = true,
>+		.zerocopied = false,
>+		.so_zerocopy = true,
>+		.sendmsg_errno = 0,
>+		.vecs_cnt = 1,
>+		{
>+			{ NULL, 100 * PAGE_SIZE }
>+		}
>+	},
>+};
>+
>+#define POLL_TIMEOUT_MS		100
>+
>+static void test_client(const struct test_opts *opts,
>+			const struct vsock_test_data *test_data,
>+			bool sock_seqpacket)
>+{
>+	struct pollfd fds = { 0 };
>+	struct msghdr msg = { 0 };
>+	ssize_t sendmsg_res;
>+	struct iovec *iovec;
>+	int fd;
>+
>+	if (sock_seqpacket)
>+		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
>+	else
>+		fd = vsock_stream_connect(opts->peer_cid, 1234);
>+
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (test_data->so_zerocopy)
>+		enable_so_zerocopy(fd);
>+
>+	iovec = iovec_from_test_data(test_data->vecs, test_data->vecs_cnt);
>+
>+	msg.msg_iov = iovec;
>+	msg.msg_iovlen = test_data->vecs_cnt;
>+
>+	errno = 0;
>+
>+	sendmsg_res = sendmsg(fd, &msg, MSG_ZEROCOPY);
>+	if (errno != test_data->sendmsg_errno) {
>+		fprintf(stderr, "expected 'errno' == %i, got %i\n",
>+			test_data->sendmsg_errno, errno);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (!errno) {
>+		if (sendmsg_res != iovec_bytes(iovec, test_data->vecs_cnt)) {
>+			fprintf(stderr, "expected 'sendmsg()' == %li, got %li\n",
>+				iovec_bytes(iovec, test_data->vecs_cnt),
>+				sendmsg_res);
>+			exit(EXIT_FAILURE);
>+		}
>+	}
>+
>+	fds.fd = fd;
>+	fds.events = 0;
>+
>+	if (poll(&fds, 1, POLL_TIMEOUT_MS) < 0) {
>+		perror("poll");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (fds.revents & POLLERR) {
>+		vsock_recv_completion(fd, &test_data->zerocopied);
>+	} else if (test_data->so_zerocopy && !test_data->sendmsg_errno) {
>+		/* If we don't have data in the error queue, but
>+		 * SO_ZEROCOPY was enabled and 'sendmsg()' was
>+		 * successful - this is an error.
>+		 */
>+		fprintf(stderr, "POLLERR expected\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (!test_data->sendmsg_errno)
>+		control_writeulong(iovec_hash_djb2(iovec, test_data->vecs_cnt));
>+	else
>+		control_writeulong(0);
>+
>+	control_writeln("DONE");
>+	free_iovec_test_data(test_data->vecs, iovec, test_data->vecs_cnt);
>+	close(fd);
>+}
>+
>+void test_stream_msgzcopy_client(const struct test_opts *opts)
>+{
>+	int i;
>+
>+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>+		test_client(opts, &test_data_array[i], false);
>+}
>+
>+void test_seqpacket_msgzcopy_client(const struct test_opts *opts)
>+{
>+	int i;
>+
>+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++) {
>+		if (test_data_array[i].stream_only)
>+			continue;
>+
>+		test_client(opts, &test_data_array[i], true);
>+	}
>+}
>+
>+static void test_server(const struct test_opts *opts,
>+			const struct vsock_test_data *test_data,
>+			bool sock_seqpacket)
>+{
>+	unsigned long remote_hash;
>+	unsigned long local_hash;
>+	ssize_t total_bytes_rec;
>+	unsigned char *data;
>+	size_t data_len;
>+	int fd;
>+
>+	if (sock_seqpacket)
>+		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
>+	else
>+		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	data_len = iovec_bytes(test_data->vecs, test_data->vecs_cnt);
>+
>+	data = malloc(data_len);
>+	if (!data) {
>+		perror("malloc");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	total_bytes_rec = 0;
>+
>+	while (total_bytes_rec != data_len) {
>+		ssize_t bytes_rec;
>+
>+		bytes_rec = read(fd, data + total_bytes_rec,
>+				 data_len - total_bytes_rec);
>+		if (bytes_rec <= 0)
>+			break;
>+
>+		total_bytes_rec += bytes_rec;
>+	}
>+
>+	if (test_data->sendmsg_errno == 0)
>+		local_hash = hash_djb2(data, data_len);
>+	else
>+		local_hash = 0;
>+
>+	free(data);
>+
>+	/* Waiting for some result. */
>+	remote_hash = control_readulong();
>+	if (remote_hash != local_hash) {
>+		fprintf(stderr, "hash mismatch\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("DONE");
>+	close(fd);
>+}
>+
>+void test_stream_msgzcopy_server(const struct test_opts *opts)
>+{
>+	int i;
>+
>+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>+		test_server(opts, &test_data_array[i], false);
>+}
>+
>+void test_seqpacket_msgzcopy_server(const struct test_opts *opts)
>+{
>+	int i;
>+
>+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++) {
>+		if (test_data_array[i].stream_only)
>+			continue;
>+
>+		test_server(opts, &test_data_array[i], true);
>+	}
>+}
>+
>+void test_stream_msgzcopy_empty_errq_client(const struct test_opts *opts)
>+{
>+	struct msghdr msg = { 0 };
>+	char cmsg_data[128];
>+	ssize_t res;
>+	int fd;
>+
>+	fd = vsock_stream_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	msg.msg_control = cmsg_data;
>+	msg.msg_controllen = sizeof(cmsg_data);
>+
>+	res = recvmsg(fd, &msg, MSG_ERRQUEUE);
>+	if (res != -1) {
>+		fprintf(stderr, "expected 'recvmsg(2)' failure, got %zi\n",
>+			res);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_writeln("DONE");
>+	close(fd);
>+}
>+
>+void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts)
>+{
>+	int fd;
>+
>+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+	if (fd < 0) {
>+		perror("accept");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("DONE");
>+	close(fd);
>+}
>diff --git a/tools/testing/vsock/vsock_test_zerocopy.h b/tools/testing/vsock/vsock_test_zerocopy.h
>new file mode 100644
>index 000000000000..3ef2579e024d
>--- /dev/null
>+++ b/tools/testing/vsock/vsock_test_zerocopy.h
>@@ -0,0 +1,15 @@
>+/* SPDX-License-Identifier: GPL-2.0-only */
>+#ifndef VSOCK_TEST_ZEROCOPY_H
>+#define VSOCK_TEST_ZEROCOPY_H
>+#include "util.h"
>+
>+void test_stream_msgzcopy_client(const struct test_opts *opts);
>+void test_stream_msgzcopy_server(const struct test_opts *opts);
>+
>+void test_seqpacket_msgzcopy_client(const struct test_opts *opts);
>+void test_seqpacket_msgzcopy_server(const struct test_opts *opts);
>+
>+void test_stream_msgzcopy_empty_errq_client(const struct test_opts *opts);
>+void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts);
>+
>+#endif /* VSOCK_TEST_ZEROCOPY_H */
>-- 
>2.25.1
>

