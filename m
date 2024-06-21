Return-Path: <kvm+bounces-20308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B88E912DF8
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 21:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17C621F21520
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 19:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A3617C239;
	Fri, 21 Jun 2024 19:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="fBhyssEz"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0553179203;
	Fri, 21 Jun 2024 19:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718998663; cv=none; b=fVFKOMo/PEqnMiVs9JP9A5ttTaL/eFTiWaek04SleEef3hYxNy5zhBTRaaCCtHPD9Fm8Qv1c0n8zU5BSyF66z/0SUy7Pr0bJeAINu8dFa30dijYm5rRk6jhFerkLOL0OR7vr3pSOQmV7hsT7RH6d9k2015Baf4GYjIHF7YBNJCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718998663; c=relaxed/simple;
	bh=b0MVT8obBsnnfcUJguz716T6dfpUAaaH84e9QWzNd5g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S+dJUwNawjgGz4vrrfWFrRzpkoNxyXcXcXVqPaHnpLPX+uH4Z/yx8i4oT2/tTRcoeXIo5ZpciRoNhjqztbqHazaO/Yo/4cfc85X+xv5TTfFBTR4RbgBGGCp0FnsAHuizyGG//uhK2D8LKJwgdDDoCUOGmhV7zCUre7bGAZiSL38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=fBhyssEz; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id BEF2812000A;
	Fri, 21 Jun 2024 22:37:30 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru BEF2812000A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1718998650;
	bh=+imAiTZlutgnKCi/zzqvLyHYlTuHBPLtJT+Rnuz2Hvc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=fBhyssEzoZLN2D4fZNYfH5S1/uBUptuOsOVHT3eNY1d5/KFOYQN2WmRxlXePaZVC8
	 k9kh7mRLj4vR9P58xw7LbFpQ880j5uhCwEOz+n2mz2/HnRY3gfz21XotJOO0lPT8Iw
	 QwrLqPhNX+F9J/e8InBJtol+IgE9YKPq7jBsG20nFaa9tqmZY2IJDfr9Q0DFdyqUp4
	 mIMg6rkJxO0XaASLuS7qg2WZ8xMJquQrofqwh2k/fcZXCeu6rqkVeAR0m1ZeVNJ+Wx
	 1IlkudzCRypXPR3daW+08Of4SeakT8eysWRzcuQvqVlvX4y391Xny4ebaH6mG7b0LZ
	 bw2dM6WKuJdHg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 21 Jun 2024 22:37:30 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Fri, 21 Jun 2024 22:37:29 +0300
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@salutedevices.com>
Subject: [RFC PATCH v1 2/2] vsock/test: add test for deferred credit update
Date: Fri, 21 Jun 2024 22:25:41 +0300
Message-ID: <20240621192541.2082657-3-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20240621192541.2082657-1-avkrasnov@salutedevices.com>
References: <20240621192541.2082657-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 186064 [Jun 21 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 20 0.3.20 743589a8af6ec90b529f2124c2bbfc3ce1d2f20f, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;smtp.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/06/21 16:35:00 #25651590
X-KSMG-AntiVirus-Status: Clean, skipped

This test checks, that we send exactly expected number of credit
update packets during deferred credit update optimization. Test
work in client/server modes:
1) Client just connects to server and send 256Kb of data. 256Kb
   is chosen because it is default space for vsock peer. After
   transmission client waits until server performs checks of this
   test.

2) Server waits for vsock connection and also open raw socket
   binded to vsock monitor interface. Then server waits until
   there will be 256Kb of data in its rx queue (by reading data
   from stream socket with MSG_PEEK flag). Then server starts
   reading data from stream socket - it reads entire socket,
   also reading packets from raw vsock socket, to check that
   there is OP_RW packets. After data read is done, it checks
   raw socket again, by waiting exact amount of CREDIT_UPDATE
   packets. Finally it checks that rx queue of raw socket is
   empty using read with timeout.

Some notes about this test:
* It is only for virtio transport.
* It relies on sizes of virtio rx buffers for guest and host,
  to handle raw packets properly (4Kb for guest and 64Kb for
  host).
* It relies on free space limit for deferred credit update -
  currently it is 64Kb.
* It needs permissions to open raw sockets.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 tools/testing/vsock/.gitignore          |   1 +
 tools/testing/vsock/Makefile            |   2 +
 tools/testing/vsock/virtio_vsock_test.c | 369 ++++++++++++++++++++++++
 3 files changed, 372 insertions(+)
 create mode 100644 tools/testing/vsock/virtio_vsock_test.c

diff --git a/tools/testing/vsock/.gitignore b/tools/testing/vsock/.gitignore
index d9f798713cd7..74d13a38cf43 100644
--- a/tools/testing/vsock/.gitignore
+++ b/tools/testing/vsock/.gitignore
@@ -4,3 +4,4 @@ vsock_test
 vsock_diag_test
 vsock_perf
 vsock_uring_test
+virtio_vsock_test
diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
index a7f56a09ca9f..e04d69903687 100644
--- a/tools/testing/vsock/Makefile
+++ b/tools/testing/vsock/Makefile
@@ -8,6 +8,8 @@ vsock_perf: vsock_perf.o msg_zerocopy_common.o
 vsock_uring_test: LDLIBS = -luring
 vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o msg_zerocopy_common.o
 
+virtio_vsock_test: virtio_vsock_test.o util.o timeout.o control.o
+
 CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
 .PHONY: all test clean
 clean:
diff --git a/tools/testing/vsock/virtio_vsock_test.c b/tools/testing/vsock/virtio_vsock_test.c
new file mode 100644
index 000000000000..4320dbc31ecc
--- /dev/null
+++ b/tools/testing/vsock/virtio_vsock_test.c
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * virtio_vsock_test - vsock.ko test suite for VirtIO transport.
+ *
+ * Copyright (C) 2024 SaluteDevices.
+ *
+ * Author: Arseniy Krasnov <AVKrasnov@salutedevices.com>
+ */
+#include <assert.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <getopt.h>
+#include <poll.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <linux/if.h>
+#include <linux/if_packet.h>
+#include <linux/if_ether.h>
+#include <linux/virtio_vsock.h>
+#include <linux/vsockmon.h>
+#include <linux/sockios.h>
+#include <netinet/in.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+
+#include "control.h"
+#include "util.h"
+
+#define RAW_SOCK_RCV_BUF	(1024 * 1024)
+
+#define TOTAL_TX_BYTES		(1024 * 256)
+
+#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE	(1024 * 64)
+
+#define VIRTIO_VSOCK_GUEST_RX_BUF_SIZE	(4096)
+#define VIRTIO_VSOCK_HOST_RX_BUF_SIZE	(1024 * 64)
+
+static const char *interface;
+
+static void test_stream_deferred_credit_update_client(const struct test_opts *opts)
+{
+	unsigned char buf[VIRTIO_VSOCK_MAX_PKT_BUF_SIZE];
+	int fd;
+	int i;
+
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("SERVERREADY");
+	memset(buf, 0, sizeof(buf));
+
+	for (i = 0; i < TOTAL_TX_BYTES / VIRTIO_VSOCK_MAX_PKT_BUF_SIZE; i++) {
+		if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
+			perror("write");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	control_writeln("CLIENTDONE");
+	control_expectln("SERVERDONE");
+
+	close(fd);
+}
+
+static int create_raw_sock(const char *ifname)
+{
+	struct sockaddr_ll addr_ll;
+	struct ifreq ifr;
+	size_t rcv_buf;
+	int fd;
+
+	fd = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
+	if (fd < 0) {
+		perror("socket");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(&ifr, 0, sizeof(ifr));
+	snprintf(ifr.ifr_name, sizeof(ifr.ifr_name),
+		 "%s", ifname);
+
+	rcv_buf = RAW_SOCK_RCV_BUF;
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVBUFFORCE, &rcv_buf,
+				sizeof(rcv_buf))) {
+		perror("setsockopt(SO_RCVBUFFORCE)");
+		exit(EXIT_FAILURE);
+	}
+
+	if (ioctl(fd, SIOCGIFINDEX, &ifr)) {
+		perror("ioctl(SIOCGIFINDEX)");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(&addr_ll, 0, sizeof(addr_ll));
+	addr_ll.sll_family = AF_PACKET;
+	addr_ll.sll_ifindex = ifr.ifr_ifindex;
+	addr_ll.sll_protocol = htons(ETH_P_ALL);
+
+	if (bind(fd, (struct sockaddr *)&addr_ll, sizeof(struct sockaddr_ll)) < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	return fd;
+}
+
+
+static void check_raw_packet(int raw_fd, uint16_t expected_op)
+{
+	struct af_vsockmon_hdr *mhdr;
+	struct virtio_vsock_hdr *hdr;
+	unsigned char buf[VIRTIO_VSOCK_MAX_PKT_BUF_SIZE +
+			  sizeof(*mhdr) + sizeof(*hdr)] = { 0 };
+	ssize_t res;
+
+	res = read(raw_fd, buf, sizeof(buf));
+
+	if (res == -1) {
+		if (expected_op == 0xffff && errno == EAGAIN)
+			return;
+
+		fprintf(stderr, "Unexpected raw read: %i\n", errno);
+		exit(EXIT_FAILURE);
+	}
+
+	mhdr = (struct af_vsockmon_hdr *)buf;
+	hdr =  (struct virtio_vsock_hdr *)(mhdr + 1);
+
+	if (hdr->op != expected_op) {
+		fprintf(stderr, "Unexpected op: %hhu, but %hhu expected\n",
+				hdr->op, expected_op);
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void test_stream_deferred_credit_update_server(const struct test_opts *opts)
+{
+	char buf[TOTAL_TX_BYTES] = { 0 };
+	int raw_fd, fd, rx_packet_size, i;
+	int credit_update_pkts;
+	struct timeval tv;
+	size_t total_recv;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	raw_fd = create_raw_sock(interface);
+
+	tv.tv_sec = 2;
+	tv.tv_usec = 0;
+
+	if (setsockopt(raw_fd, SOL_SOCKET, SO_RCVTIMEO,
+		       (void *)&tv, sizeof(tv))) {
+		perror("setsockopt(SO_RCVTIMEO)");
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("SERVERREADY");
+	control_expectln("CLIENTDONE");
+
+	total_recv = 0;
+
+	/* Wait, until we receive whole data. */
+	while (1) {
+		ssize_t ret;
+
+		ret = recv(fd, buf, sizeof(buf), MSG_PEEK);
+		if (ret == sizeof(buf))
+			break;
+
+		if (ret <= 0) {
+			fprintf(stderr, "unexpected 'recv()' return: %zi\n", ret);
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	if (opts->peer_cid == VMADDR_CID_HOST)
+		rx_packet_size = VIRTIO_VSOCK_GUEST_RX_BUF_SIZE;
+	else
+		rx_packet_size = VIRTIO_VSOCK_HOST_RX_BUF_SIZE;
+
+	while (1) {
+		ssize_t ret;
+
+		ret = read(fd, buf, rx_packet_size);
+		if (ret <= 0) {
+			perror("read");
+			exit(EXIT_FAILURE);
+		}
+
+		check_raw_packet(raw_fd, VIRTIO_VSOCK_OP_RW);
+
+		total_recv += ret;
+
+		if (total_recv >= TOTAL_TX_BYTES)
+			break;
+	}
+
+	if (total_recv != TOTAL_TX_BYTES) {
+		fprintf(stderr, "Invalid number of received bytes: %zu",
+			total_recv);
+		exit(EXIT_FAILURE);
+	}
+
+	credit_update_pkts = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE / rx_packet_size;
+	for (i = 0; i < credit_update_pkts; i++)
+		check_raw_packet(raw_fd, VIRTIO_VSOCK_OP_CREDIT_UPDATE);
+
+	/* Check that there are no new packets. */
+	check_raw_packet(raw_fd, 0xffff);
+
+	control_writeln("SERVERDONE");
+
+	close(fd);
+	close(raw_fd);
+}
+
+static struct test_case test_cases[] = {
+	{
+		.name = "SOCK_STREAM deferred credit update",
+		.run_client = test_stream_deferred_credit_update_client,
+		.run_server = test_stream_deferred_credit_update_server,
+	},
+	{}
+};
+
+static const char optstring[] = "";
+static const struct option longopts[] = {
+	{
+		.name = "control-host",
+		.has_arg = required_argument,
+		.val = 'H',
+	},
+	{
+		.name = "control-port",
+		.has_arg = required_argument,
+		.val = 'P',
+	},
+	{
+		.name = "mode",
+		.has_arg = required_argument,
+		.val = 'm',
+	},
+	{
+		.name = "peer-cid",
+		.has_arg = required_argument,
+		.val = 'p',
+	},
+	{
+		.name = "peer-port",
+		.has_arg = required_argument,
+		.val = 'q',
+	},
+	{
+		.name = "interface",
+		.has_arg = required_argument,
+		.val = 'i',
+	},
+	{
+		.name = "help",
+		.has_arg = no_argument,
+		.val = '?',
+	},
+	{},
+};
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: virtio_vsock_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid> [--peer-port=<port>] [--list] [--interface=<iface name>]\n"
+		"\n"
+		"  Server: virtio_vsock_test --control-port=1234 --mode=server --peer-cid=3 --interface=vsockmon0\n"
+		"  Client: virtio_vsock_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
+		"\n"
+		"Run AF_VSOCK tests, specific for virtio transport. Requires\n"
+		"permissions to open raw socket.\n"
+		"\n"
+		"A TCP control socket connection is used to coordinate tests\n"
+		"between the client and the server.  The server requires a\n"
+		"listen address and the client requires an address to\n"
+		"connect to.\n"
+		"\n"
+		"The CID of the other side must be given with --peer-cid=<cid>.\n"
+		"During the test, two AF_VSOCK ports will be used: the port\n"
+		"specified with --peer-port=<port> (or the default port)\n"
+		"and the next one.\n"
+		"\n"
+		"Options:\n"
+		"  --help                 This help message\n"
+		"  --control-host <host>  Server IP address to connect to\n"
+		"  --control-port <port>  Server port to listen on/connect to\n"
+		"  --mode client|server   Server or client mode\n"
+		"  --peer-cid <cid>       CID of the other side\n"
+		"  --peer-port <port>     AF_VSOCK port used for the test [default: %d]\n"
+		"  --interface <iface name>\n",
+		DEFAULT_PEER_PORT
+	       );
+}
+
+int main(int argc, char *argv[])
+{
+	const char *control_host = NULL;
+	const char *control_port = NULL;
+	struct test_opts opts = {
+		.mode = TEST_MODE_UNSET,
+		.peer_cid = VMADDR_CID_ANY,
+		.peer_port = DEFAULT_PEER_PORT,
+	};
+
+	for (;;) {
+		int opt = getopt_long(argc, argv, optstring, longopts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'H':
+			control_host = optarg;
+			break;
+		case 'P':
+			control_port = optarg;
+			break;
+		case 'm':
+			if (strcmp(optarg, "client") == 0)
+				opts.mode = TEST_MODE_CLIENT;
+			else if (strcmp(optarg, "server") == 0)
+				opts.mode = TEST_MODE_SERVER;
+			else {
+				fprintf(stderr, "--mode must be \"client\" or \"server\"\n");
+				return EXIT_FAILURE;
+			}
+			break;
+		case 'p':
+			opts.peer_cid = parse_cid(optarg);
+			break;
+		case 'q':
+			opts.peer_port = parse_port(optarg);
+			break;
+		case 'i':
+			interface = optarg;
+		default:
+			usage();
+		}
+	}
+
+	if (!control_host) {
+		if (opts.mode != TEST_MODE_SERVER)
+			usage();
+		control_host = "0.0.0.0";
+	}
+
+	if (!interface)
+		interface = "vsockmon0";
+
+	control_init(control_host, control_port,
+		     opts.mode == TEST_MODE_SERVER);
+
+	run_tests(test_cases, &opts);
+
+	return EXIT_SUCCESS;
+}
-- 
2.25.1


