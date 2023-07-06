Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE0274A2DA
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbjGFRJv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjGFRJu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:09:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507D31BF8
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688663255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+rXpsOYTfW3vHN88u3LZ7HIcl5R2ABVLziuLdGjkMjI=;
        b=CVHS3LocFE1+Qv01NYNU8fnkRza8ghJ4hlhS/ihYBeOXcOZBvnsKT/X8bBx1PcZegjD0Vj
        JWU4Ji6IxiXgVjgLLBmjIEQdsJvE22XT08KcH5PqZl9vlmsGN1byQQiX9wEDvmTzDXFsV1
        k/oNtlceoKwmbPBH1Q9jeBNI9Rn6JYs=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-81H1nyniP_WpGL3NgsaKTQ-1; Thu, 06 Jul 2023 13:06:51 -0400
X-MC-Unique: 81H1nyniP_WpGL3NgsaKTQ-1
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-57320c10635so10411707b3.3
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:06:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688663203; x=1691255203;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+rXpsOYTfW3vHN88u3LZ7HIcl5R2ABVLziuLdGjkMjI=;
        b=aNb7+W39+gTqCdSJiyMw9IBA3v+Q++cKN1OG/ktCxwSXhy7zDsqw98s1Ze4GrT18NR
         79qqg7x5O0gHHQkItuMXlwuy9ugpKw9BrOkx8ilY+r9FJFBIFyc+AHfpe/NF7WVScA6o
         rzTdTTXkbI9hSRGFQd3XHwuSsmNMKwl3I30NN/dHEcFQ15Vy3t9MpZgDb5Kmajom7sN+
         jbivyfM4/l0nIpxKexTetQvLAASbe9ueZwLz4oI9c1KOJe0o+jVVQklDjL8kXWFBySAO
         YtFAnxH63+QvseUHaEvniyimOapccyvLiNQHDBCl7EwkZQO61rEfDMoy6YK4ZviXBs4m
         Ax1g==
X-Gm-Message-State: ABy/qLZdQ3Y8xM/rqn9dMw5efN/8HjajfpwiOVBVIQRPjHY9kH9KOy6t
        FTjVO3wtSnqNRNj4uskriYWGOD7pjwaIapcciTo4wGWWd8JcpGFE74MBNPzvnKw+oHMOUuV+ebd
        UJ2TN5k8i7OoL0YZ4vpoyGz/Z/DuE
X-Received: by 2002:a81:920d:0:b0:579:e1ef:4145 with SMTP id j13-20020a81920d000000b00579e1ef4145mr2822098ywg.0.1688663203257;
        Thu, 06 Jul 2023 10:06:43 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEynJyBs0TEv0XWPhLFJboXwX3+isr6U6ChqFJarUYGiCdRZm36RXiD9i9foF/R1uEf6pWO2z+Ld3P3wlpiUTM=
X-Received: by 2002:a81:920d:0:b0:579:e1ef:4145 with SMTP id
 j13-20020a81920d000000b00579e1ef4145mr2822068ywg.0.1688663203017; Thu, 06 Jul
 2023 10:06:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru> <20230701063947.3422088-18-AVKrasnov@sberdevices.ru>
In-Reply-To: <20230701063947.3422088-18-AVKrasnov@sberdevices.ru>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Thu, 6 Jul 2023 19:06:31 +0200
Message-ID: <CAGxU2F5V8jfGnYnp3wdLR3PVwvW6ce02U+R5k1G81r2FdxCV0Q@mail.gmail.com>
Subject: Re: [RFC PATCH v5 17/17] test/vsock: io_uring rx/tx tests
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 01, 2023 at 09:39:47AM +0300, Arseniy Krasnov wrote:
>This adds set of tests which use io_uring for rx/tx. This test suite is
>implemented as separated util like 'vsock_test' and has the same set of
>input arguments as 'vsock_test'. These tests only cover cases of data
>transmission (no connect/bind/accept etc).

Cool, thanks for adding this!

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> tools/testing/vsock/Makefile           |   7 +-
> tools/testing/vsock/vsock_uring_test.c | 321 +++++++++++++++++++++++++
> 2 files changed, 327 insertions(+), 1 deletion(-)
> create mode 100644 tools/testing/vsock/vsock_uring_test.c
>
>diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
>index 0a78787d1d92..8621ae73051d 100644
>--- a/tools/testing/vsock/Makefile
>+++ b/tools/testing/vsock/Makefile
>@@ -1,12 +1,17 @@
> # SPDX-License-Identifier: GPL-2.0-only
>+ifeq ($(MAKECMDGOALS),vsock_uring_test)
>+LDFLAGS = -luring
>+endif
>+
> all: test vsock_perf
> test: vsock_test vsock_diag_test
> vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
> vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
> vsock_perf: vsock_perf.o
>+vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o $(LDFLAGS)

Why we need `$(LDFLAGS)` in the dependencies?


>
> CFLAGS += -g -O2 -Werror -Wall -I. -I../../include
> -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow
> -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
> .PHONY: all test clean
> clean:
>-      ${RM} *.o *.d vsock_test vsock_diag_test
>+      ${RM} *.o *.d vsock_test vsock_diag_test vsock_uring_test
> -include *.d
>diff --git a/tools/testing/vsock/vsock_uring_test.c b/tools/testing/vsock/vsock_uring_test.c
>new file mode 100644
>index 000000000000..7637ff510490
>--- /dev/null
>+++ b/tools/testing/vsock/vsock_uring_test.c
>@@ -0,0 +1,321 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+/* io_uring tests for vsock
>+ *
>+ * Copyright (C) 2023 SberDevices.
>+ *
>+ * Author: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
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
>+
>+#define PAGE_SIZE             4096
>+#define RING_ENTRIES_NUM      4
>+
>+static struct vsock_test_data test_data_array[] = {
>+      /* All elements have page aligned base and size. */
>+      {
>+              .vecs_cnt = 3,
>+              {
>+                      { NULL, PAGE_SIZE },
>+                      { NULL, 2 * PAGE_SIZE },
>+                      { NULL, 3 * PAGE_SIZE },
>+              }
>+      },
>+      /* Middle element has both non-page aligned base and size. */
>+      {
>+              .vecs_cnt = 3,
>+              {
>+                      { NULL, PAGE_SIZE },
>+                      { (void *)1, 200  },
>+                      { NULL, 3 * PAGE_SIZE },
>+              }
>+      }
>+};
>+
>+static void vsock_io_uring_client(const struct test_opts *opts,
>+                                const struct vsock_test_data *test_data,
>+                                bool msg_zerocopy)
>+{
>+      struct io_uring_sqe *sqe;
>+      struct io_uring_cqe *cqe;
>+      struct io_uring ring;
>+      struct iovec *iovec;
>+      struct msghdr msg;
>+      int fd;
>+
>+      fd = vsock_stream_connect(opts->peer_cid, 1234);
>+      if (fd < 0) {
>+              perror("connect");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      if (msg_zerocopy)
>+              enable_so_zerocopy(fd);
>+
>+      iovec = iovec_from_test_data(test_data);
>+
>+      if (io_uring_queue_init(RING_ENTRIES_NUM, &ring, 0))
>+              error(1, errno, "io_uring_queue_init");
>+
>+      if (io_uring_register_buffers(&ring, iovec, test_data->vecs_cnt))
>+              error(1, errno, "io_uring_register_buffers");
>+
>+      memset(&msg, 0, sizeof(msg));
>+      msg.msg_iov = iovec;
>+      msg.msg_iovlen = test_data->vecs_cnt;
>+      sqe = io_uring_get_sqe(&ring);
>+
>+      if (msg_zerocopy)
>+              io_uring_prep_sendmsg_zc(sqe, fd, &msg, 0);
>+      else
>+              io_uring_prep_sendmsg(sqe, fd, &msg, 0);
>+
>+      if (io_uring_submit(&ring) != 1)
>+              error(1, errno, "io_uring_submit");
>+
>+      if (io_uring_wait_cqe(&ring, &cqe))
>+              error(1, errno, "io_uring_wait_cqe");
>+
>+      io_uring_cqe_seen(&ring, cqe);
>+
>+      control_writeulong(iovec_hash_djb2(iovec, test_data->vecs_cnt));
>+
>+      control_writeln("DONE");
>+      io_uring_queue_exit(&ring);
>+      free_iovec_test_data(test_data, iovec);
>+      close(fd);
>+}
>+
>+static void vsock_io_uring_server(const struct test_opts *opts,
>+                                const struct vsock_test_data *test_data)
>+{
>+      unsigned long remote_hash;
>+      unsigned long local_hash;
>+      struct io_uring_sqe *sqe;
>+      struct io_uring_cqe *cqe;
>+      struct io_uring ring;
>+      struct iovec iovec;
>+      size_t data_len;
>+      void *data;
>+      int fd;
>+
>+      fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
>+      if (fd < 0) {
>+              perror("accept");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      data_len = iovec_bytes(test_data->vecs, test_data->vecs_cnt);
>+
>+      data = malloc(data_len);
>+      if (!data) {
>+              perror("malloc");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      if (io_uring_queue_init(RING_ENTRIES_NUM, &ring, 0))
>+              error(1, errno, "io_uring_queue_init");
>+
>+      sqe = io_uring_get_sqe(&ring);
>+      iovec.iov_base = data;
>+      iovec.iov_len = data_len;
>+
>+      io_uring_prep_readv(sqe, fd, &iovec, 1, 0);
>+
>+      if (io_uring_submit(&ring) != 1)
>+              error(1, errno, "io_uring_submit");
>+
>+      if (io_uring_wait_cqe(&ring, &cqe))
>+              error(1, errno, "io_uring_wait_cqe");
>+
>+      if (cqe->res != data_len) {
>+              fprintf(stderr, "expected %zu, got %u\n", data_len,
>+                      cqe->res);
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      local_hash = hash_djb2(data, data_len);
>+
>+      remote_hash = control_readulong();
>+      if (remote_hash != local_hash) {
>+              fprintf(stderr, "hash mismatch\n");
>+              exit(EXIT_FAILURE);
>+      }
>+
>+      control_expectln("DONE");
>+      io_uring_queue_exit(&ring);
>+      free(data);
>+}
>+
>+void test_stream_uring_server(const struct test_opts *opts)
>+{
>+      int i;
>+
>+      for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>+              vsock_io_uring_server(opts, &test_data_array[i]);
>+}
>+
>+void test_stream_uring_client(const struct test_opts *opts)
>+{
>+      int i;
>+
>+      for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>+              vsock_io_uring_client(opts, &test_data_array[i], false);
>+}
>+
>+void test_stream_uring_msg_zc_server(const struct test_opts *opts)
>+{
>+      int i;
>+
>+      for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>+              vsock_io_uring_server(opts, &test_data_array[i]);
>+}
>+
>+void test_stream_uring_msg_zc_client(const struct test_opts *opts)
>+{
>+      int i;
>+
>+      for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
>+              vsock_io_uring_client(opts, &test_data_array[i], true);
>+}
>+
>+static struct test_case test_cases[] = {
>+      {
>+              .name = "SOCK_STREAM io_uring test",
>+              .run_server = test_stream_uring_server,
>+              .run_client = test_stream_uring_client,
>+      },
>+      {
>+              .name = "SOCK_STREAM io_uring MSG_ZEROCOPY test",
>+              .run_server = test_stream_uring_msg_zc_server,
>+              .run_client = test_stream_uring_msg_zc_client,
>+      },
>+      {},
>+};
>+
>+static const char optstring[] = "";
>+static const struct option longopts[] = {
>+      {
>+              .name = "control-host",
>+              .has_arg = required_argument,
>+              .val = 'H',
>+      },
>+      {
>+              .name = "control-port",
>+              .has_arg = required_argument,
>+              .val = 'P',
>+      },
>+      {
>+              .name = "mode",
>+              .has_arg = required_argument,
>+              .val = 'm',
>+      },
>+      {
>+              .name = "peer-cid",
>+              .has_arg = required_argument,
>+              .val = 'p',
>+      },
>+      {
>+              .name = "help",
>+              .has_arg = no_argument,
>+              .val = '?',
>+      },
>+      {},
>+};
>+
>+static void usage(void)
>+{
>+      fprintf(stderr, "Usage: vsock_uring_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid>\n"
>+              "\n"
>+              "  Server: vsock_uring_test --control-port=1234 --mode=server --peer-cid=3\n"
>+              "  Client: vsock_uring_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
>+              "\n"
>+              "Run transmission tests using io_uring. Usage is the same as\n"
>+              "in ./vsock_test\n"
>+              "\n"
>+              "Options:\n"
>+              "  --help                 This help message\n"
>+              "  --control-host <host>  Server IP address to connect to\n"
>+              "  --control-port <port>  Server port to listen on/connect to\n"
>+              "  --mode client|server   Server or client mode\n"
>+              "  --peer-cid <cid>       CID of the other side\n"
>+              );
>+      exit(EXIT_FAILURE);
>+}
>+
>+int main(int argc, char **argv)
>+{
>+      const char *control_host = NULL;
>+      const char *control_port = NULL;
>+      struct test_opts opts = {
>+              .mode = TEST_MODE_UNSET,
>+              .peer_cid = VMADDR_CID_ANY,
>+      };
>+
>+      init_signals();
>+
>+      for (;;) {
>+              int opt = getopt_long(argc, argv, optstring, longopts, NULL);
>+
>+              if (opt == -1)
>+                      break;
>+
>+              switch (opt) {
>+              case 'H':
>+                      control_host = optarg;
>+                      break;
>+              case 'm':
>+                      if (strcmp(optarg, "client") == 0) {
>+                              opts.mode = TEST_MODE_CLIENT;
>+                      } else if (strcmp(optarg, "server") == 0) {
>+                              opts.mode = TEST_MODE_SERVER;
>+                      } else {
>+                              fprintf(stderr, "--mode must be \"client\" or \"server\"\n");
>+                              return EXIT_FAILURE;
>+                      }
>+                      break;
>+              case 'p':
>+                      opts.peer_cid = parse_cid(optarg);
>+                      break;
>+              case 'P':
>+                      control_port = optarg;
>+                      break;
>+              case '?':
>+              default:
>+                      usage();
>+              }
>+      }
>+
>+      if (!control_port)
>+              usage();
>+      if (opts.mode == TEST_MODE_UNSET)
>+              usage();
>+      if (opts.peer_cid == VMADDR_CID_ANY)
>+              usage();
>+
>+      if (!control_host) {
>+              if (opts.mode != TEST_MODE_SERVER)
>+                      usage();
>+              control_host = "0.0.0.0";
>+      }
>+
>+      control_init(control_host, control_port,
>+                   opts.mode == TEST_MODE_SERVER);
>+
>+      run_tests(test_cases, &opts);
>+
>+      control_cleanup();
>+
>+      return 0;
>+}
>--
>2.25.1
>

