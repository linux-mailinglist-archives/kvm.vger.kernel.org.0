Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68FC67C548B
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 14:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346989AbjJKM4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 08:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234905AbjJKMzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 08:55:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145D1CC
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 05:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697028898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ep7hmDUyuZ0WkIuNExS4JhPOiHqL0a6sa6+rmjXsuck=;
        b=OP5JbY0pS/K0nuWc6Px8rsy7SHMXJ3pMg7LRBTrKEbXPSNdVQiK4ERrdoGyq9dGFFWt/Pt
        fdJMrharq+QyawHCkzpljkDY80R5CUZbjamNqRF0IOfBAfJfkNjsOPmyX9YSuBHtaI6XQZ
        0cMRIwjHJ5WHaL1oCCipAVY5dJVGtN4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338--tI84brVN4SlInJMKV-0rw-1; Wed, 11 Oct 2023 08:54:56 -0400
X-MC-Unique: -tI84brVN4SlInJMKV-0rw-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-418198baf49so73817101cf.1
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 05:54:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697028896; x=1697633696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ep7hmDUyuZ0WkIuNExS4JhPOiHqL0a6sa6+rmjXsuck=;
        b=P6KL3I9O+qqX1jHhv4vyqK87y2h/S8R+S8eyofA/0yQk1NaU1R1V2eQ4GRhkmehmm/
         GUny9Ky35t5lS7+GEuwkX8KZDw/DGwoCr1j+hRif4Jpyw0vPN1Wtd+0vhFIMXLVR3nDH
         wFLIzhbdlbhvbQy8+YTq/xAN1n3EcHPjkB+lI8Ltp3jMC0zUPqSjE7tXMNG5oYUXMB1h
         ftWPUxAjlmQ4HsLeCp4lSn05DRigd6ULC7QvMVjh4Va+WmsDY3SiFdBMuZe5AbvltpiD
         ogm51X7mnjpQFX9tmPyavZveaXTDZdw4QlKsW9VtJCAf7aQWAIXUrOmI7pDvFPVhco5k
         3mVA==
X-Gm-Message-State: AOJu0YwLUMgm6pkiFP/qMN48QiMNc3UAVcuD5ZDMwikLELN+E3acIFPx
        sAfBs/gJlgIM2mDJ+hU/IbkCSOqWQCyGjh+QV+7TOdM2o9wdkdDR2nQPZ8Zg9L3Yo0c8gkHieBL
        bcoyP6abDlbxy
X-Received: by 2002:ac8:7c4f:0:b0:419:529e:dcfd with SMTP id o15-20020ac87c4f000000b00419529edcfdmr28306789qtv.3.1697028896175;
        Wed, 11 Oct 2023 05:54:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFbboJ/XHvBEUZeYPxWc6tPLghl6i5Lo0AgWZ1InH6MBHKWUBjS5nHS3aYazHBH2/YXRXwoA==
X-Received: by 2002:ac8:7c4f:0:b0:419:529e:dcfd with SMTP id o15-20020ac87c4f000000b00419529edcfdmr28306767qtv.3.1697028895824;
        Wed, 11 Oct 2023 05:54:55 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-251.retail.telecomitalia.it. [79.46.200.251])
        by smtp.gmail.com with ESMTPSA id e1-20020ac81301000000b0040331a24f16sm5325650qtj.3.2023.10.11.05.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 05:54:55 -0700 (PDT)
Date:   Wed, 11 Oct 2023 14:54:50 +0200
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
Subject: Re: [PATCH net-next v4 10/12] test/vsock: MSG_ZEROCOPY flag tests
Message-ID: <3w7dz3pkujmysdqoynxrnxcnmsrvgq4c7iijqktg2oynbzmwns@jiu2p6y2hm4m>
References: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
 <20231010191524.1694217-11-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231010191524.1694217-11-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 10, 2023 at 10:15:22PM +0300, Arseniy Krasnov wrote:
>This adds three tests for MSG_ZEROCOPY feature:
>1) SOCK_STREAM tx with different buffers.
>2) SOCK_SEQPACKET tx with different buffers.
>3) SOCK_STREAM test to read empty error queue of the socket.
>
>Patch also works as preparation for the next patches for tools in this
>patchset: vsock_perf and vsock_uring_test:
>1) Adds several new functions to util.c - they will be also used by
>   vsock_uring_test.
>2) Adds two new functions for MSG_ZEROCOPY handling to a new source
>   file - such source will be shared between vsock_test, vsock_perf and
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
> v3 -> v4:
>  * Move code from 'msg_zerocopy_common.h' to 'msg_zerocopy_common.c'
>    to avoid warning about unused functions.
>  * Rename 'iovec_from_test_data()' and 'free_iovec_test_data()' to
>    'alloc_test_iovec()' and 'free_test_iovec(). Also add comments for
>    both functions.
>  * Use '#ifndef' around '#define PAGE_SIZE 4096'.
>
> tools/testing/vsock/Makefile              |   2 +-
> tools/testing/vsock/msg_zerocopy_common.c |  87 ++++++
> tools/testing/vsock/msg_zerocopy_common.h |  18 ++
> tools/testing/vsock/util.c                | 133 ++++++++
> tools/testing/vsock/util.h                |   5 +
> tools/testing/vsock/vsock_test.c          |  16 +
> tools/testing/vsock/vsock_test_zerocopy.c | 358 ++++++++++++++++++++++
> tools/testing/vsock/vsock_test_zerocopy.h |  15 +
> 8 files changed, 633 insertions(+), 1 deletion(-)
> create mode 100644 tools/testing/vsock/msg_zerocopy_common.c
> create mode 100644 tools/testing/vsock/msg_zerocopy_common.h
> create mode 100644 tools/testing/vsock/vsock_test_zerocopy.c
> create mode 100644 tools/testing/vsock/vsock_test_zerocopy.h

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
>index 21a98ba565ab..bb938e4790b5 100644
>--- a/tools/testing/vsock/Makefile
>+++ b/tools/testing/vsock/Makefile
>@@ -1,7 +1,7 @@
> # SPDX-License-Identifier: GPL-2.0-only
> all: test vsock_perf
> test: vsock_test vsock_diag_test
>-vsock_test: vsock_test.o timeout.o control.o util.o
>+vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o msg_zerocopy_common.o
> vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
> vsock_perf: vsock_perf.o
>
>diff --git a/tools/testing/vsock/msg_zerocopy_common.c b/tools/testing/vsock/msg_zerocopy_common.c
>new file mode 100644
>index 000000000000..5a4bdf7b5132
>--- /dev/null
>+++ b/tools/testing/vsock/msg_zerocopy_common.c
>@@ -0,0 +1,87 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+/* Some common code for MSG_ZEROCOPY logic
>+ *
>+ * Copyright (C) 2023 SberDevices.
>+ *
>+ * Author: Arseniy Krasnov <avkrasnov@salutedevices.com>
>+ */
>+
>+#include <stdio.h>
>+#include <stdlib.h>
>+#include <sys/types.h>
>+#include <sys/socket.h>
>+#include <linux/errqueue.h>
>+
>+#include "msg_zerocopy_common.h"
>+
>+void enable_so_zerocopy(int fd)
>+{
>+	int val = 1;
>+
>+	if (setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY, &val, sizeof(val))) {
>+		perror("setsockopt");
>+		exit(EXIT_FAILURE);
>+	}
>+}
>+
>+void vsock_recv_completion(int fd, const bool *zerocopied)
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
>diff --git a/tools/testing/vsock/msg_zerocopy_common.h b/tools/testing/vsock/msg_zerocopy_common.h
>new file mode 100644
>index 000000000000..3763c5ccedb9
>--- /dev/null
>+++ b/tools/testing/vsock/msg_zerocopy_common.h
>@@ -0,0 +1,18 @@
>+/* SPDX-License-Identifier: GPL-2.0-only */
>+#ifndef MSG_ZEROCOPY_COMMON_H
>+#define MSG_ZEROCOPY_COMMON_H
>+
>+#include <stdbool.h>
>+
>+#ifndef SOL_VSOCK
>+#define SOL_VSOCK	287
>+#endif
>+
>+#ifndef VSOCK_RECVERR
>+#define VSOCK_RECVERR	1
>+#endif
>+
>+void enable_so_zerocopy(int fd);
>+void vsock_recv_completion(int fd, const bool *zerocopied);
>+
>+#endif /* MSG_ZEROCOPY_COMMON_H */
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 6779d5008b27..92336721321a 100644
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
>@@ -444,3 +446,134 @@ unsigned long hash_djb2(const void *data, size_t len)
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
>+/* Allocates and returns new 'struct iovec *' according pattern
>+ * in the 'test_iovec'. For each element in the 'test_iovec' it
>+ * allocates new element in the resulting 'iovec'. 'iov_len'
>+ * of the new element is copied from 'test_iovec'. 'iov_base' is
>+ * allocated depending on the 'iov_base' of 'test_iovec':
>+ *
>+ * 'iov_base' == NULL -> valid buf: mmap('iov_len').
>+ *
>+ * 'iov_base' == MAP_FAILED -> invalid buf:
>+ *               mmap('iov_len'), then munmap('iov_len').
>+ *               'iov_base' still contains result of
>+ *               mmap().
>+ *
>+ * 'iov_base' == number -> unaligned valid buf:
>+ *               mmap('iov_len') + number.
>+ *
>+ * 'iovnum' is number of elements in 'test_iovec'.
>+ *
>+ * Returns new 'iovec' or calls 'exit()' on error.
>+ */
>+struct iovec *alloc_test_iovec(const struct iovec *test_iovec, int iovnum)
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
>+/* Frees 'iovec *', previously allocated by 'alloc_test_iovec()'.
>+ * On error calls 'exit()'.
>+ */
>+void free_test_iovec(const struct iovec *test_iovec,
>+		     struct iovec *iovec, int iovnum)
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
>index e5407677ce05..a77175d25864 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -53,4 +53,9 @@ void list_tests(const struct test_case *test_cases);
> void skip_test(struct test_case *test_cases, size_t test_cases_len,
> 	       const char *test_id_str);
> unsigned long hash_djb2(const void *data, size_t len);
>+size_t iovec_bytes(const struct iovec *iov, size_t iovnum);
>+unsigned long iovec_hash_djb2(const struct iovec *iov, size_t iovnum);
>+struct iovec *alloc_test_iovec(const struct iovec *test_iovec, int iovnum);
>+void free_test_iovec(const struct iovec *test_iovec,
>+		     struct iovec *iovec, int iovnum);
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
>index 000000000000..a16ff76484e6
>--- /dev/null
>+++ b/tools/testing/vsock/vsock_test_zerocopy.c
>@@ -0,0 +1,358 @@
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
>+#ifndef PAGE_SIZE
>+#define PAGE_SIZE		4096
>+#endif
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
>+	iovec = alloc_test_iovec(test_data->vecs, test_data->vecs_cnt);
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
>+	free_test_iovec(test_data->vecs, iovec, test_data->vecs_cnt);
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

