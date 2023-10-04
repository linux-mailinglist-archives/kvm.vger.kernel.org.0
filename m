Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018EC7B83CD
	for <lists+kvm@lfdr.de>; Wed,  4 Oct 2023 17:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbjJDPkQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 11:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbjJDPkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 11:40:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629FC98
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 08:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696433966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DZf7yqs3s2yfxoseGukyXasdNVpfduWSd7FqhQ168ZQ=;
        b=FcsgwhkSSgjccYAVtFbSKrjm1H1lAG77kCDRzIuThH1VeBT4Vf6G9DdKYDpFhBuTgnrrcv
        w+1PRtPzghwCoNHA3xPSkFq/jea6S2XIL48zRGRu8XqX01UH/y3SXmqIwgc94H1NL3GpN9
        eQiH8EcGL2IAKXp8fKYHT0PbKIGkboM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-IvcC1SSONp2zN3kEfE9rKA-1; Wed, 04 Oct 2023 11:39:25 -0400
X-MC-Unique: IvcC1SSONp2zN3kEfE9rKA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7756d4d252cso288733785a.1
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 08:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696433964; x=1697038764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZf7yqs3s2yfxoseGukyXasdNVpfduWSd7FqhQ168ZQ=;
        b=EXYksZBbeXm0OBYkP17Bhf6AspBtqRgr+HTxtbi37EjmwGbjj1u+W4GUA624acejEM
         baTqKYOe11U68nYNrAVVs3uKAowHUWopGmRzFyQaDVNLwQLw2AKwPkb1gdU3vmpAf6j5
         ONKO/cRfei5JPX7Lv2Trnyj1pbc90MTFHUBAA/XwM5vyrvkLwNSQsK4J/DeNQen7iA9A
         YDg6Zx/oSWgzeHUUi7Ew89cAfPRaTCie6pXrVCe/Ag+q5ylKz5nQAqAbKuh374Oua8Y7
         gS3OA7y9KwKpO4XVIfk3PoWNubG2A3vKaP8k5n2uJrvuNBcs/0e7cZKBkrhB3GmcwUOX
         JteA==
X-Gm-Message-State: AOJu0Yz+xqc3HQndO3mB6yllZGSf0T4tZnA+Njwyvf/Hwg8L3FMOlMqY
        1N9piN44Q1WQA6pfa1qBYN+lTbAfKtFOlrOIHctxqBkt0iAOFIay76HK0xvVf8ia7wgECZMOsIY
        jBCbBqYX76JZe
X-Received: by 2002:a05:620a:394e:b0:76f:93e:4b45 with SMTP id qs14-20020a05620a394e00b0076f093e4b45mr2954358qkn.69.1696433964385;
        Wed, 04 Oct 2023 08:39:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwxy92r8sFfjfaSUvcjDpxZCZaLm9Th0tpMVkjRSQmprRkBx48AmiQgB8RvC8HjyzVnR+AWA==
X-Received: by 2002:a05:620a:394e:b0:76f:93e:4b45 with SMTP id qs14-20020a05620a394e00b0076f093e4b45mr2954340qkn.69.1696433964030;
        Wed, 04 Oct 2023 08:39:24 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id t7-20020a05620a034700b007758d87524esm1346552qkm.3.2023.10.04.08.39.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 08:39:23 -0700 (PDT)
Date:   Wed, 4 Oct 2023 17:39:18 +0200
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
Subject: Re: [PATCH net-next v2 10/12] test/vsock: MSG_ZEROCOPY flag tests
Message-ID: <z2pa3jl37srx7rymhswjiazkssq67scrp2dh5pjyb73zxa4232@6verblafci2w>
References: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
 <20230930210308.2394919-11-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230930210308.2394919-11-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 01, 2023 at 12:03:06AM +0300, Arseniy Krasnov wrote:
>This adds three tests for MSG_ZEROCOPY feature:
>1) SOCK_STREAM tx with different buffers.
>2) SOCK_SEQPACKET tx with different buffers.
>3) SOCK_STREAM test to read empty error queue of the socket.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v1 -> v2:
>  * Move 'SOL_VSOCK' and 'VSOCK_RECVERR' from 'util.c' to 'util.h'.
>
> tools/testing/vsock/Makefile              |   2 +-
> tools/testing/vsock/util.c                | 214 +++++++++++++++
> tools/testing/vsock/util.h                |  27 ++
> tools/testing/vsock/vsock_test.c          |  16 ++
> tools/testing/vsock/vsock_test_zerocopy.c | 314 ++++++++++++++++++++++
> tools/testing/vsock/vsock_test_zerocopy.h |  15 ++
> 6 files changed, 587 insertions(+), 1 deletion(-)
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
>diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
>index 6779d5008b27..2a641ab38f08 100644
>--- a/tools/testing/vsock/util.c
>+++ b/tools/testing/vsock/util.c
>@@ -11,10 +11,14 @@
> #include <stdio.h>
> #include <stdint.h>
> #include <stdlib.h>
>+#include <string.h>
> #include <signal.h>
> #include <unistd.h>
> #include <assert.h>
> #include <sys/epoll.h>
>+#include <sys/mman.h>
>+#include <linux/errqueue.h>
>+#include <poll.h>
>
> #include "timeout.h"
> #include "control.h"
>@@ -444,3 +448,213 @@ unsigned long hash_djb2(const void *data, size_t len)
>
> 	return hash;
> }
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
>+static void *mmap_no_fail(size_t bytes)
>+{
>+	void *res;
>+
>+	res = mmap(NULL, bytes, PROT_READ | PROT_WRITE,
>+		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
>+	if (res == MAP_FAILED) {
>+		perror("mmap");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	return res;
>+}
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
>+static void iovec_random_init(struct iovec *iov,
>+			      const struct vsock_test_data *test_data)
>+{
>+	int i;
>+
>+	for (i = 0; i < test_data->vecs_cnt; i++) {
>+		int j;
>+
>+		if (test_data->vecs[i].iov_base == MAP_FAILED)
>+			continue;
>+
>+		for (j = 0; j < iov[i].iov_len; j++)
>+			((uint8_t *)iov[i].iov_base)[j] = rand() & 0xff;
>+	}
>+}
>+
>+unsigned long iovec_hash_djb2(struct iovec *iov, size_t iovnum)
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
>+struct iovec *iovec_from_test_data(const struct vsock_test_data *test_data)
>+{
>+	const struct iovec *test_iovec;
>+	struct iovec *iovec;
>+	int i;
>+
>+	iovec = malloc(sizeof(*iovec) * test_data->vecs_cnt);
>+	if (!iovec) {
>+		perror("malloc");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	test_iovec = test_data->vecs;
>+
>+	for (i = 0; i < test_data->vecs_cnt; i++) {
>+		iovec[i].iov_len = test_iovec[i].iov_len;
>+		iovec[i].iov_base = mmap_no_fail(test_iovec[i].iov_len);
>+
>+		if (test_iovec[i].iov_base != MAP_FAILED &&
>+		    test_iovec[i].iov_base)
>+			iovec[i].iov_base += (uintptr_t)test_iovec[i].iov_base;
>+	}
>+
>+	/* Unmap "invalid" elements. */
>+	for (i = 0; i < test_data->vecs_cnt; i++) {
>+		if (test_iovec[i].iov_base == MAP_FAILED) {
>+			if (munmap(iovec[i].iov_base, iovec[i].iov_len)) {
>+				perror("munmap");
>+				exit(EXIT_FAILURE);
>+			}
>+		}
>+	}
>+
>+	iovec_random_init(iovec, test_data);
>+
>+	return iovec;
>+}
>+
>+void free_iovec_test_data(const struct vsock_test_data *test_data,
>+			  struct iovec *iovec)
>+{
>+	int i;
>+
>+	for (i = 0; i < test_data->vecs_cnt; i++) {
>+		if (test_data->vecs[i].iov_base != MAP_FAILED) {
>+			if (test_data->vecs[i].iov_base)
>+				iovec[i].iov_base -= (uintptr_t)test_data->vecs[i].iov_base;
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
>+
>+#define POLL_TIMEOUT_MS		100
>+void vsock_recv_completion(int fd, bool zerocopied, bool completion)
>+{
>+	struct sock_extended_err *serr;
>+	struct msghdr msg = { 0 };
>+	struct pollfd fds = { 0 };
>+	char cmsg_data[128];
>+	struct cmsghdr *cm;
>+	ssize_t res;
>+
>+	fds.fd = fd;
>+	fds.events = 0;
>+
>+	if (poll(&fds, 1, POLL_TIMEOUT_MS) < 0) {
>+		perror("poll");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (!(fds.revents & POLLERR)) {
>+		if (completion) {
>+			fprintf(stderr, "POLLERR expected\n");
>+			exit(EXIT_FAILURE);
>+		} else {
>+			return;
>+		}
>+	}
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

What "serr" means?

>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (serr->ee_errno) {
>+		fprintf(stderr, "serr: wrong error code: %u\n", serr->ee_errno);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (zerocopied && (serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
>+		fprintf(stderr, "serr: was copy instead of zerocopy\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (!zerocopied && !(serr->ee_code & SO_EE_CODE_ZEROCOPY_COPIED)) {
>+		fprintf(stderr, "serr: was zerocopy instead of copy\n");
>+		exit(EXIT_FAILURE);
>+	}
>+}

Why we are putting this functions in util.c if they are only used by
zerocopy tests?

>diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
>index e5407677ce05..407f415adef6 100644
>--- a/tools/testing/vsock/util.h
>+++ b/tools/testing/vsock/util.h
>@@ -2,9 +2,18 @@
> #ifndef UTIL_H
> #define UTIL_H
>
>+#include <stdbool.h>
> #include <sys/socket.h>
> #include <linux/vm_sockets.h>
>
>+#ifndef SOL_VSOCK
>+#define SOL_VSOCK	287
>+#endif
>+
>+#ifndef VSOCK_RECVERR
>+#define VSOCK_RECVERR	1
>+#endif
>+
> /* Tests can either run as the client or the server */
> enum test_mode {
> 	TEST_MODE_UNSET,
>@@ -18,6 +27,17 @@ struct test_opts {
> 	unsigned int peer_cid;
> };
>

Ditto.

>+#define VSOCK_TEST_DATA_MAX_IOV 4
>+
>+struct vsock_test_data {
>+	bool stream_only;	/* Only for SOCK_STREAM. */
>+	bool zerocopied;	/* Data must be zerocopied. */
>+	bool so_zerocopy;	/* Enable zerocopy mode. */

What is the difference between `zerocopied` and `so_zerocopy`?
We should explain better, or change the names, they are a bit confusing.

>+	int sendmsg_errno;	/* 'errno' after 'sendmsg()'. */
>+	int vecs_cnt;		/* Number of elements in 'vecs'. */
>+	struct iovec vecs[VSOCK_TEST_DATA_MAX_IOV];
>+};
>+
> /* A test case definition.  Test functions must print failures to stderr and
>  * terminate with exit(EXIT_FAILURE).
>  */
>@@ -53,4 +73,11 @@ void list_tests(const struct test_case *test_cases);
> void skip_test(struct test_case *test_cases, size_t test_cases_len,
> 	       const char *test_id_str);
> unsigned long hash_djb2(const void *data, size_t len);
>+void enable_so_zerocopy(int fd);
>+size_t iovec_bytes(const struct iovec *iov, size_t iovnum);
>+unsigned long iovec_hash_djb2(struct iovec *iov, size_t iovnum);
>+struct iovec *iovec_from_test_data(const struct vsock_test_data *test_data);
>+void free_iovec_test_data(const struct vsock_test_data *test_data,
>+			  struct iovec *iovec);
>+void vsock_recv_completion(int fd, bool zerocopied, bool completion);
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
>index 000000000000..655ef92ef25d
>--- /dev/null
>+++ b/tools/testing/vsock/vsock_test_zerocopy.c
>@@ -0,0 +1,314 @@
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
>+
>+#define PAGE_SIZE		4096

I think we can move all the util.c/util.h changes here.

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
>+static void test_client(const struct test_opts *opts,
>+			const struct vsock_test_data *test_data,
>+			bool sock_seqpacket)
>+{
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
>+	iovec = iovec_from_test_data(test_data);
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
>+	/* Receive completion only in case of successful 'sendmsg()'. */
>+	vsock_recv_completion(fd, test_data->zerocopied,
>+			      test_data->so_zerocopy && !test_data->sendmsg_errno);
>+
>+	if (!test_data->sendmsg_errno)
>+		control_writeulong(iovec_hash_djb2(iovec, test_data->vecs_cnt));
>+	else
>+		control_writeulong(0);
>+
>+	control_writeln("DONE");
>+	free_iovec_test_data(test_data, iovec);
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

