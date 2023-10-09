Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C6E7BE471
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 17:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376518AbjJIPRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 11:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376375AbjJIPRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 11:17:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2F3119
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 08:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696864597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zcw7Xf48QXO/muospsKmYzwhUx5W2eR+Pk46hq3VU24=;
        b=UNAzkGHXenJ3APj2WJMJh2SftBYInMO2dUyATRFnjFM/0D3aITXzywIYawv04dV+tRfJ7D
        dUtkOi1W1F8YHnblToh8DfEC04eHA7hTxWla98fRfqiHTznwhoQg+nE189MjCphk17YMNh
        VCHYaCfrHrDvLy4xVS5Vhio9PdXRYL4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-AHAG98LXN4KOeKLOG0EIzA-1; Mon, 09 Oct 2023 11:16:35 -0400
X-MC-Unique: AHAG98LXN4KOeKLOG0EIzA-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-533f8bc82a8so3946240a12.0
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 08:16:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696864594; x=1697469394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zcw7Xf48QXO/muospsKmYzwhUx5W2eR+Pk46hq3VU24=;
        b=qnDtSOBOTcuYgd++t7DxoxSF2CVAnPou+UOstwbgRxqOhcHO5eDQVpWWgAOF9UwNY4
         dEX0G68Xr5sSbK0+NSeTgazUqrJ+7b14RhXVVacqBqZJYB9Cql1cd6E1AQNE5EP4Cq6F
         AVXuO9ZjtIGg/eL+EAVGx8S0MIltPBsvfDJ24r+u9yi7e79njj/QxEEsGkQsvdt9KLUq
         p1dVgRgY1ZJtBKjGu90ewVqqK9Rn0Rrr7hM6NSMf5LTSkdIgOnxwNTLaGH2yw9nw/J8Q
         n1uXupVPz1mdOkYHiFLJnRZ3vvAAdFW28XhruyvqrNNd0j8I6FR8X/xYNQ3nM2vpx1p2
         XstA==
X-Gm-Message-State: AOJu0YwScO582fWgAlU5TVNA37KhH2aRHjgKfdANoBz56jdKligf8mRx
        EapMiQyXtlhkyhd1v0kUeGbVjup/jkmcYskEo+/PA8tOZ/YiySL4KKOS9aP65XqaGHKd1rX/d2o
        bKkTFYN//XjRy
X-Received: by 2002:a50:ec99:0:b0:531:287d:3232 with SMTP id e25-20020a50ec99000000b00531287d3232mr13988283edr.34.1696864594461;
        Mon, 09 Oct 2023 08:16:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0KLEqcuDriHZJ1yM5JB/u0ufbqdzycWJhvtP3Z757ZxDgnRbmZFLwTSzKZpzFfwr5usZxkg==
X-Received: by 2002:a50:ec99:0:b0:531:287d:3232 with SMTP id e25-20020a50ec99000000b00531287d3232mr13988259edr.34.1696864594109;
        Mon, 09 Oct 2023 08:16:34 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id bm15-20020a0564020b0f00b005346925a474sm6251903edb.43.2023.10.09.08.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 08:16:33 -0700 (PDT)
Date:   Mon, 9 Oct 2023 17:16:28 +0200
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
Subject: Re: [PATCH net-next v3 12/12] test/vsock: io_uring rx/tx tests
Message-ID: <t3xtyfaanhhjyi6mb4ev5q4obktkev5bv24rvdbyyc2yj3cwok@qvrvdlwhn6tj>
References: <20231007172139.1338644-1-avkrasnov@salutedevices.com>
 <20231007172139.1338644-13-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231007172139.1338644-13-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 07, 2023 at 08:21:39PM +0300, Arseniy Krasnov wrote:
>This adds set of tests which use io_uring for rx/tx. This test suite is
>implemented as separated util like 'vsock_test' and has the same set of
>input arguments as 'vsock_test'. These tests only cover cases of data
>transmission (no connect/bind/accept etc).
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v1 -> v2:
>  * Add 'LDLIBS = -luring' to the target 'vsock_uring_test'.
>  * Add 'vsock_uring_test' to the target 'test'.
> v2 -> v3:
>  * Make 'struct vsock_test_data' private by placing it to the .c file.
>    Rename it and add comments to this struct to clarify sense of its
>    fields.
>  * Add 'vsock_uring_test' to the '.gitignore'.
>  * Add receive loop to the server side - this is needed to read entire
>    data sent by client.
>
> tools/testing/vsock/.gitignore         |   1 +
> tools/testing/vsock/Makefile           |   7 +-
> tools/testing/vsock/vsock_uring_test.c | 350 +++++++++++++++++++++++++
> 3 files changed, 356 insertions(+), 2 deletions(-)
> create mode 100644 tools/testing/vsock/vsock_uring_test.c
>
>diff --git a/tools/testing/vsock/.gitignore b/tools/testing/vsock/.gitignore
>index a8adcfdc292b..d9f798713cd7 100644
>--- a/tools/testing/vsock/.gitignore
>+++ b/tools/testing/vsock/.gitignore
>@@ -3,3 +3,4 @@
> vsock_test
> vsock_diag_test
> vsock_perf
>+vsock_uring_test
>diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
>index 1a26f60a596c..b80e7c7def1e 100644
>--- a/tools/testing/vsock/Makefile
>+++ b/tools/testing/vsock/Makefile
>@@ -1,12 +1,15 @@
> # SPDX-License-Identifier: GPL-2.0-only
> all: test vsock_perf
>-test: vsock_test vsock_diag_test
>+test: vsock_test vsock_diag_test vsock_uring_test
> vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
> vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
> vsock_perf: vsock_perf.o
>
>+vsock_uring_test: LDLIBS = -luring
>+vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o
>+
> CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
> .PHONY: all test clean
> clean:
>-	${RM} *.o *.d vsock_test vsock_diag_test vsock_perf
>+	${RM} *.o *.d vsock_test vsock_diag_test vsock_perf vsock_uring_test
> -include *.d
>diff --git a/tools/testing/vsock/vsock_uring_test.c b/tools/testing/vsock/vsock_uring_test.c
>new file mode 100644
>index 000000000000..889887cf3989
>--- /dev/null
>+++ b/tools/testing/vsock/vsock_uring_test.c
>@@ -0,0 +1,350 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+/* io_uring tests for vsock
>+ *
>+ * Copyright (C) 2023 SberDevices.
>+ *
>+ * Author: Arseniy Krasnov <avkrasnov@salutedevices.com>
>+ */
>+
>+#include <getopt.h>
>+#include <stdio.h>
>+#include <stdlib.h>
>+#include <string.h>
>+#include <liburing.h>
>+#include <unistd.h>
>+#include <sys/mman.h>
>+#include <linux/kernel.h>
>+#include <error.h>
>+
>+#include "util.h"
>+#include "control.h"
>+#include "msg_zerocopy_common.h"
>+
>+#define PAGE_SIZE		4096

Ditto.

>+#define RING_ENTRIES_NUM	4
>+
>+#define VSOCK_TEST_DATA_MAX_IOV 3
>+
>+struct vsock_io_uring_test {
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
>+static struct vsock_io_uring_test test_data_array[] = {
>+	/* All elements have page aligned base and size. */
>+	{
>+		.vecs_cnt = 3,
>+		{
>+			{ NULL, PAGE_SIZE },
>+			{ NULL, 2 * PAGE_SIZE },
>+			{ NULL, 3 * PAGE_SIZE },
>+		}
>+	},
>+	/* Middle element has both non-page aligned base and size. */
>+	{
>+		.vecs_cnt = 3,
>+		{
>+			{ NULL, PAGE_SIZE },
>+			{ (void *)1, 200  },
>+			{ NULL, 3 * PAGE_SIZE },
>+		}
>+	}
>+};
>+
>+static void vsock_io_uring_client(const struct test_opts *opts,
>+				  const struct vsock_io_uring_test *test_data,
>+				  bool msg_zerocopy)
>+{
>+	struct io_uring_sqe *sqe;
>+	struct io_uring_cqe *cqe;
>+	struct io_uring ring;
>+	struct iovec *iovec;
>+	struct msghdr msg;
>+	int fd;
>+
>+	fd = vsock_stream_connect(opts->peer_cid, 1234);
>+	if (fd < 0) {
>+		perror("connect");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	if (msg_zerocopy)
>+		enable_so_zerocopy(fd);
>+
>+	iovec = iovec_from_test_data(test_data->vecs, test_data->vecs_cnt);

Ah, I see this is used also here, so now I get why in util.h

Okay, it is fine, but please change the name in something like
`alloc_test_iovec`/`free_test_iovec` and add a bit of documentation
in util.c about the input and output of that function.

The rest LGMT.

Stefano

>+
>+	if (io_uring_queue_init(RING_ENTRIES_NUM, &ring, 0))
>+		error(1, errno, "io_uring_queue_init");
>+
>+	if (io_uring_register_buffers(&ring, iovec, test_data->vecs_cnt))
>+		error(1, errno, "io_uring_register_buffers");
>+
>+	memset(&msg, 0, sizeof(msg));
>+	msg.msg_iov = iovec;
>+	msg.msg_iovlen = test_data->vecs_cnt;
>+	sqe = io_uring_get_sqe(&ring);
>+
>+	if (msg_zerocopy)
>+		io_uring_prep_sendmsg_zc(sqe, fd, &msg, 0);
>+	else
>+		io_uring_prep_sendmsg(sqe, fd, &msg, 0);
>+
>+	if (io_uring_submit(&ring) != 1)
>+		error(1, errno, "io_uring_submit");
>+
>+	if (io_uring_wait_cqe(&ring, &cqe))
>+		error(1, errno, "io_uring_wait_cqe");
>+
>+	io_uring_cqe_seen(&ring, cqe);
>+
>+	control_writeulong(iovec_hash_djb2(iovec, test_data->vecs_cnt));
>+
>+	control_writeln("DONE");
>+	io_uring_queue_exit(&ring);
>+	free_iovec_test_data(test_data->vecs, iovec, test_data->vecs_cnt);
>+	close(fd);
>+}
>+
>+static void vsock_io_uring_server(const struct test_opts *opts,
>+				  const struct vsock_io_uring_test *test_data)
>+{
>+	unsigned long remote_hash;
>+	unsigned long local_hash;
>+	struct io_uring ring;
>+	size_t data_len;
>+	size_t recv_len;
>+	void *data;
>+	int fd;
>+
>+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
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
>+	if (io_uring_queue_init(RING_ENTRIES_NUM, &ring, 0))
>+		error(1, errno, "io_uring_queue_init");
>+
>+	recv_len = 0;
>+
>+	while (recv_len < data_len) {
>+		struct io_uring_sqe *sqe;
>+		struct io_uring_cqe *cqe;
>+		struct iovec iovec;
>+
>+		sqe = io_uring_get_sqe(&ring);
>+		iovec.iov_base = data + recv_len;
>+		iovec.iov_len = data_len;
>+
>+		io_uring_prep_readv(sqe, fd, &iovec, 1, 0);
>+
>+		if (io_uring_submit(&ring) != 1)
>+			error(1, errno, "io_uring_submit");
>+
>+		if (io_uring_wait_cqe(&ring, &cqe))
>+			error(1, errno, "io_uring_wait_cqe");
>+
>+		recv_len += cqe->res;
>+		io_uring_cqe_seen(&ring, cqe);
>+	}
>+
>+	if (recv_len != data_len) {
>+		fprintf(stderr, "expected %zu, got %zu\n", data_len,
>+			recv_len);
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	local_hash = hash_djb2(data, data_len);
>+
>+	remote_hash = control_readulong();
>+	if (remote_hash != local_hash) {
>+		fprintf(stderr, "hash mismatch\n");
>+		exit(EXIT_FAILURE);
>+	}
>+
>+	control_expectln("DONE");
>+	io_uring_queue_exit(&ring);
>+	free(data);
>+}
>+
>+void test_stream_uring_server(const struct test_opts *opts)
>+{
>+	int i;
>+
>+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>+		vsock_io_uring_server(opts, &test_data_array[i]);
>+}
>+
>+void test_stream_uring_client(const struct test_opts *opts)
>+{
>+	int i;
>+
>+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>+		vsock_io_uring_client(opts, &test_data_array[i], false);
>+}
>+
>+void test_stream_uring_msg_zc_server(const struct test_opts *opts)
>+{
>+	int i;
>+
>+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>+		vsock_io_uring_server(opts, &test_data_array[i]);
>+}
>+
>+void test_stream_uring_msg_zc_client(const struct test_opts *opts)
>+{
>+	int i;
>+
>+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>+		vsock_io_uring_client(opts, &test_data_array[i], true);
>+}
>+
>+static struct test_case test_cases[] = {
>+	{
>+		.name = "SOCK_STREAM io_uring test",
>+		.run_server = test_stream_uring_server,
>+		.run_client = test_stream_uring_client,
>+	},
>+	{
>+		.name = "SOCK_STREAM io_uring MSG_ZEROCOPY test",
>+		.run_server = test_stream_uring_msg_zc_server,
>+		.run_client = test_stream_uring_msg_zc_client,
>+	},
>+	{},
>+};
>+
>+static const char optstring[] = "";
>+static const struct option longopts[] = {
>+	{
>+		.name = "control-host",
>+		.has_arg = required_argument,
>+		.val = 'H',
>+	},
>+	{
>+		.name = "control-port",
>+		.has_arg = required_argument,
>+		.val = 'P',
>+	},
>+	{
>+		.name = "mode",
>+		.has_arg = required_argument,
>+		.val = 'm',
>+	},
>+	{
>+		.name = "peer-cid",
>+		.has_arg = required_argument,
>+		.val = 'p',
>+	},
>+	{
>+		.name = "help",
>+		.has_arg = no_argument,
>+		.val = '?',
>+	},
>+	{},
>+};
>+
>+static void usage(void)
>+{
>+	fprintf(stderr, "Usage: vsock_uring_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid>\n"
>+		"\n"
>+		"  Server: vsock_uring_test --control-port=1234 --mode=server --peer-cid=3\n"
>+		"  Client: vsock_uring_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
>+		"\n"
>+		"Run transmission tests using io_uring. Usage is the same as\n"
>+		"in ./vsock_test\n"
>+		"\n"
>+		"Options:\n"
>+		"  --help                 This help message\n"
>+		"  --control-host <host>  Server IP address to connect to\n"
>+		"  --control-port <port>  Server port to listen on/connect to\n"
>+		"  --mode client|server   Server or client mode\n"
>+		"  --peer-cid <cid>       CID of the other side\n"
>+		);
>+	exit(EXIT_FAILURE);
>+}
>+
>+int main(int argc, char **argv)
>+{
>+	const char *control_host = NULL;
>+	const char *control_port = NULL;
>+	struct test_opts opts = {
>+		.mode = TEST_MODE_UNSET,
>+		.peer_cid = VMADDR_CID_ANY,
>+	};
>+
>+	init_signals();
>+
>+	for (;;) {
>+		int opt = getopt_long(argc, argv, optstring, longopts, NULL);
>+
>+		if (opt == -1)
>+			break;
>+
>+		switch (opt) {
>+		case 'H':
>+			control_host = optarg;
>+			break;
>+		case 'm':
>+			if (strcmp(optarg, "client") == 0) {
>+				opts.mode = TEST_MODE_CLIENT;
>+			} else if (strcmp(optarg, "server") == 0) {
>+				opts.mode = TEST_MODE_SERVER;
>+			} else {
>+				fprintf(stderr, "--mode must be \"client\" or \"server\"\n");
>+				return EXIT_FAILURE;
>+			}
>+			break;
>+		case 'p':
>+			opts.peer_cid = parse_cid(optarg);
>+			break;
>+		case 'P':
>+			control_port = optarg;
>+			break;
>+		case '?':
>+		default:
>+			usage();
>+		}
>+	}
>+
>+	if (!control_port)
>+		usage();
>+	if (opts.mode == TEST_MODE_UNSET)
>+		usage();
>+	if (opts.peer_cid == VMADDR_CID_ANY)
>+		usage();
>+
>+	if (!control_host) {
>+		if (opts.mode != TEST_MODE_SERVER)
>+			usage();
>+		control_host = "0.0.0.0";
>+	}
>+
>+	control_init(control_host, control_port,
>+		     opts.mode == TEST_MODE_SERVER);
>+
>+	run_tests(test_cases, &opts);
>+
>+	control_cleanup();
>+
>+	return 0;
>+}
>-- 
>2.25.1
>

