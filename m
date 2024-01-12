Return-Path: <kvm+bounces-6165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8529282C6AF
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 22:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3DFCB24539
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 21:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8839917730;
	Fri, 12 Jan 2024 21:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="fCT9yDvM"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F371C171D8;
	Fri, 12 Jan 2024 21:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id B2EA5120002;
	Sat, 13 Jan 2024 00:30:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru B2EA5120002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1705095003;
	bh=Orr+8pQCj9w9tZ7vpvYVcKAP7cJ4B2uVNjRXKEdlhj4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=fCT9yDvMSwdkTK3LeVjBdnHOBXnHPirzwWCvcmssk46yvFJct+qSBECci8voK9OAG
	 pMG4Qth6HA9hibRAIZ4mATAlSiNAQRFU5UFAXyMmp7fcfpJPVFZuVhfHSoozzDNbKj
	 ieEKlSFSjD2IWYdO5HwrlxI1kr8xCFkR7JHYJ9qUV2YK011Vb3BdMhEc2iJJ+N/Eql
	 9WvlUDqpNG5JSAD6zzf5dxNrrgQ9Duc6wy6cE+kweCkv0xbnFhZr4/mG8uSCZBB8Fh
	 YcOpcDnV5ShG3NRG15ym57LLKuDbGEw6sTiSF3VoCi1lB3OFjkwAmXjJdXLIyrxY3m
	 aR54vOGhkNiWA==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Sat, 13 Jan 2024 00:30:03 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Sat, 13 Jan 2024 00:30:03 +0300
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@salutedevices.com>
Subject: [RFC PATCH v1] vsock/test: add '--peer-port' input argument
Date: Sat, 13 Jan 2024 00:21:10 +0300
Message-ID: <20240112212110.1906150-1-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 182617 [Jan 12 2024]
X-KSMG-AntiSpam-Version: 6.1.0.3
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 7 0.3.7 6d6bf5bd8eea7373134f756a2fd73e9456bb7d1a, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/01/12 18:46:00 #23122211
X-KSMG-AntiVirus-Status: Clean, skipped

Implement port for given CID as input argument instead of using
hardcoded value '1234'. This allows to run different test instances
on a single CID. Port argument is not required parameter and if it is
not set, then default value will be '1234' - thus we preserve previous
behaviour.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 tools/testing/vsock/util.c                | 17 +++-
 tools/testing/vsock/util.h                |  4 +
 tools/testing/vsock/vsock_diag_test.c     | 18 ++++-
 tools/testing/vsock/vsock_test.c          | 96 +++++++++++++----------
 tools/testing/vsock/vsock_test_zerocopy.c | 12 +--
 tools/testing/vsock/vsock_uring_test.c    | 16 +++-
 6 files changed, 107 insertions(+), 56 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index ae2b33c21c45..554b290fefdc 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -33,8 +33,7 @@ void init_signals(void)
 	signal(SIGPIPE, SIG_IGN);
 }
 
-/* Parse a CID in string representation */
-unsigned int parse_cid(const char *str)
+static unsigned int parse_uint(const char *str, const char *err_str)
 {
 	char *endptr = NULL;
 	unsigned long n;
@@ -42,12 +41,24 @@ unsigned int parse_cid(const char *str)
 	errno = 0;
 	n = strtoul(str, &endptr, 10);
 	if (errno || *endptr != '\0') {
-		fprintf(stderr, "malformed CID \"%s\"\n", str);
+		fprintf(stderr, "malformed %s \"%s\"\n", err_str, str);
 		exit(EXIT_FAILURE);
 	}
 	return n;
 }
 
+/* Parse a CID in string representation */
+unsigned int parse_cid(const char *str)
+{
+	return parse_uint(str, "CID");
+}
+
+/* Parse a port in string representation */
+unsigned int parse_port(const char *str)
+{
+	return parse_uint(str, "port");
+}
+
 /* Wait for the remote to close the connection */
 void vsock_wait_remote_close(int fd)
 {
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index 03c88d0cb861..e95e62485959 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -12,10 +12,13 @@ enum test_mode {
 	TEST_MODE_SERVER
 };
 
+#define DEFAULT_PEER_PORT	1234
+
 /* Test runner options */
 struct test_opts {
 	enum test_mode mode;
 	unsigned int peer_cid;
+	unsigned int peer_port;
 };
 
 /* A test case definition.  Test functions must print failures to stderr and
@@ -35,6 +38,7 @@ struct test_case {
 
 void init_signals(void);
 unsigned int parse_cid(const char *str);
+unsigned int parse_port(const char *str);
 int vsock_stream_connect(unsigned int cid, unsigned int port);
 int vsock_bind_connect(unsigned int cid, unsigned int port,
 		       unsigned int bind_port, int type);
diff --git a/tools/testing/vsock/vsock_diag_test.c b/tools/testing/vsock/vsock_diag_test.c
index fa927ad16f8a..5e6049226b77 100644
--- a/tools/testing/vsock/vsock_diag_test.c
+++ b/tools/testing/vsock/vsock_diag_test.c
@@ -342,7 +342,7 @@ static void test_listen_socket_server(const struct test_opts *opts)
 	} addr = {
 		.svm = {
 			.svm_family = AF_VSOCK,
-			.svm_port = 1234,
+			.svm_port = opts->peer_port,
 			.svm_cid = VMADDR_CID_ANY,
 		},
 	};
@@ -378,7 +378,7 @@ static void test_connect_client(const struct test_opts *opts)
 	LIST_HEAD(sockets);
 	struct vsock_stat *st;
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -403,7 +403,7 @@ static void test_connect_server(const struct test_opts *opts)
 	LIST_HEAD(sockets);
 	int client_fd;
 
-	client_fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	client_fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (client_fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -461,6 +461,11 @@ static const struct option longopts[] = {
 		.has_arg = required_argument,
 		.val = 'p',
 	},
+	{
+		.name = "peer-port",
+		.has_arg = required_argument,
+		.val = 'q',
+	},
 	{
 		.name = "list",
 		.has_arg = no_argument,
@@ -481,7 +486,7 @@ static const struct option longopts[] = {
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: vsock_diag_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid> [--list] [--skip=<test_id>]\n"
+	fprintf(stderr, "Usage: vsock_diag_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid> [--peer-port=<port>] [--list] [--skip=<test_id>]\n"
 		"\n"
 		"  Server: vsock_diag_test --control-port=1234 --mode=server --peer-cid=3\n"
 		"  Client: vsock_diag_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
@@ -503,6 +508,7 @@ static void usage(void)
 		"  --control-port <port>  Server port to listen on/connect to\n"
 		"  --mode client|server   Server or client mode\n"
 		"  --peer-cid <cid>       CID of the other side\n"
+		"  --peer-port <port>     Port of the other side\n"
 		"  --list                 List of tests that will be executed\n"
 		"  --skip <test_id>       Test ID to skip;\n"
 		"                         use multiple --skip options to skip more tests\n"
@@ -517,6 +523,7 @@ int main(int argc, char **argv)
 	struct test_opts opts = {
 		.mode = TEST_MODE_UNSET,
 		.peer_cid = VMADDR_CID_ANY,
+		.peer_port = DEFAULT_PEER_PORT
 	};
 
 	init_signals();
@@ -544,6 +551,9 @@ int main(int argc, char **argv)
 		case 'p':
 			opts.peer_cid = parse_cid(optarg);
 			break;
+		case 'q':
+			opts.peer_port = parse_port(optarg);
+			break;
 		case 'P':
 			control_port = optarg;
 			break;
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 66246d81d654..58574f4d1fe1 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -34,7 +34,7 @@ static void test_stream_connection_reset(const struct test_opts *opts)
 	} addr = {
 		.svm = {
 			.svm_family = AF_VSOCK,
-			.svm_port = 1234,
+			.svm_port = opts->peer_port,
 			.svm_cid = opts->peer_cid,
 		},
 	};
@@ -70,7 +70,7 @@ static void test_stream_bind_only_client(const struct test_opts *opts)
 	} addr = {
 		.svm = {
 			.svm_family = AF_VSOCK,
-			.svm_port = 1234,
+			.svm_port = opts->peer_port,
 			.svm_cid = opts->peer_cid,
 		},
 	};
@@ -112,7 +112,7 @@ static void test_stream_bind_only_server(const struct test_opts *opts)
 	} addr = {
 		.svm = {
 			.svm_family = AF_VSOCK,
-			.svm_port = 1234,
+			.svm_port = opts->peer_port,
 			.svm_cid = VMADDR_CID_ANY,
 		},
 	};
@@ -138,7 +138,7 @@ static void test_stream_client_close_client(const struct test_opts *opts)
 {
 	int fd;
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -152,7 +152,7 @@ static void test_stream_client_close_server(const struct test_opts *opts)
 {
 	int fd;
 
-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -173,7 +173,7 @@ static void test_stream_server_close_client(const struct test_opts *opts)
 {
 	int fd;
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -194,7 +194,7 @@ static void test_stream_server_close_server(const struct test_opts *opts)
 {
 	int fd;
 
-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -215,7 +215,7 @@ static void test_stream_multiconn_client(const struct test_opts *opts)
 	int i;
 
 	for (i = 0; i < MULTICONN_NFDS; i++) {
-		fds[i] = vsock_stream_connect(opts->peer_cid, 1234);
+		fds[i] = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 		if (fds[i] < 0) {
 			perror("connect");
 			exit(EXIT_FAILURE);
@@ -239,7 +239,7 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
 	int i;
 
 	for (i = 0; i < MULTICONN_NFDS; i++) {
-		fds[i] = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+		fds[i] = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 		if (fds[i] < 0) {
 			perror("accept");
 			exit(EXIT_FAILURE);
@@ -267,9 +267,9 @@ static void test_msg_peek_client(const struct test_opts *opts,
 	int i;
 
 	if (seqpacket)
-		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+		fd = vsock_seqpacket_connect(opts->peer_cid, opts->peer_port);
 	else
-		fd = vsock_stream_connect(opts->peer_cid, 1234);
+		fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 
 	if (fd < 0) {
 		perror("connect");
@@ -295,9 +295,9 @@ static void test_msg_peek_server(const struct test_opts *opts,
 	int fd;
 
 	if (seqpacket)
-		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	else
-		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+		fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 
 	if (fd < 0) {
 		perror("accept");
@@ -363,7 +363,7 @@ static void test_seqpacket_msg_bounds_client(const struct test_opts *opts)
 	int msg_count;
 	int fd;
 
-	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	fd = vsock_seqpacket_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -434,7 +434,7 @@ static void test_seqpacket_msg_bounds_server(const struct test_opts *opts)
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
 
-	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -505,7 +505,7 @@ static void test_seqpacket_msg_trunc_client(const struct test_opts *opts)
 	int fd;
 	char buf[MESSAGE_TRUNC_SZ];
 
-	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	fd = vsock_seqpacket_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -524,7 +524,7 @@ static void test_seqpacket_msg_trunc_server(const struct test_opts *opts)
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
 
-	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -575,7 +575,7 @@ static void test_seqpacket_timeout_client(const struct test_opts *opts)
 	time_t read_enter_ns;
 	time_t read_overhead_ns;
 
-	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	fd = vsock_seqpacket_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -620,7 +620,7 @@ static void test_seqpacket_timeout_server(const struct test_opts *opts)
 {
 	int fd;
 
-	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -639,7 +639,7 @@ static void test_seqpacket_bigmsg_client(const struct test_opts *opts)
 
 	len = sizeof(sock_buf_size);
 
-	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	fd = vsock_seqpacket_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -671,7 +671,7 @@ static void test_seqpacket_bigmsg_server(const struct test_opts *opts)
 {
 	int fd;
 
-	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -692,7 +692,7 @@ static void test_seqpacket_invalid_rec_buffer_client(const struct test_opts *opt
 	unsigned char *buf2;
 	int buf_size = getpagesize() * 3;
 
-	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	fd = vsock_seqpacket_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -732,7 +732,7 @@ static void test_seqpacket_invalid_rec_buffer_server(const struct test_opts *opt
 	int flags = MAP_PRIVATE | MAP_ANONYMOUS;
 	int i;
 
-	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -808,7 +808,7 @@ static void test_stream_poll_rcvlowat_server(const struct test_opts *opts)
 	int fd;
 	int i;
 
-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -839,7 +839,7 @@ static void test_stream_poll_rcvlowat_client(const struct test_opts *opts)
 	short poll_flags;
 	int fd;
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -906,9 +906,9 @@ static void test_inv_buf_client(const struct test_opts *opts, bool stream)
 	int fd;
 
 	if (stream)
-		fd = vsock_stream_connect(opts->peer_cid, 1234);
+		fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	else
-		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+		fd = vsock_seqpacket_connect(opts->peer_cid, opts->peer_port);
 
 	if (fd < 0) {
 		perror("connect");
@@ -941,9 +941,9 @@ static void test_inv_buf_server(const struct test_opts *opts, bool stream)
 	int fd;
 
 	if (stream)
-		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+		fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	else
-		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 
 	if (fd < 0) {
 		perror("accept");
@@ -986,7 +986,7 @@ static void test_stream_virtio_skb_merge_client(const struct test_opts *opts)
 {
 	int fd;
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -1015,7 +1015,7 @@ static void test_stream_virtio_skb_merge_server(const struct test_opts *opts)
 	unsigned char buf[64];
 	int fd;
 
-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -1108,7 +1108,7 @@ static void test_stream_shutwr_client(const struct test_opts *opts)
 
 	sigaction(SIGPIPE, &act, NULL);
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -1130,7 +1130,7 @@ static void test_stream_shutwr_server(const struct test_opts *opts)
 {
 	int fd;
 
-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -1151,7 +1151,7 @@ static void test_stream_shutrd_client(const struct test_opts *opts)
 
 	sigaction(SIGPIPE, &act, NULL);
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -1170,7 +1170,7 @@ static void test_stream_shutrd_server(const struct test_opts *opts)
 {
 	int fd;
 
-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -1193,7 +1193,7 @@ static void test_double_bind_connect_server(const struct test_opts *opts)
 	struct sockaddr_vm sa_client;
 	socklen_t socklen_client = sizeof(sa_client);
 
-	listen_fd = vsock_stream_listen(VMADDR_CID_ANY, 1234);
+	listen_fd = vsock_stream_listen(VMADDR_CID_ANY, opts->peer_port);
 
 	for (i = 0; i < 2; i++) {
 		control_writeln("LISTENING");
@@ -1226,7 +1226,13 @@ static void test_double_bind_connect_client(const struct test_opts *opts)
 		/* Wait until server is ready to accept a new connection */
 		control_expectln("LISTENING");
 
-		client_fd = vsock_bind_connect(opts->peer_cid, 1234, 4321, SOCK_STREAM);
+		/* We use 'peer_port + 1' as "some" port for the 'bind()'
+		 * call. It is safe for overflow, but must be considered,
+		 * when running multiple test applications simultaneously
+		 * where 'peer-port' argument differs by 1.
+		 */
+		client_fd = vsock_bind_connect(opts->peer_cid, opts->peer_port,
+					       opts->peer_port + 1, SOCK_STREAM);
 
 		close(client_fd);
 	}
@@ -1246,7 +1252,7 @@ static void test_stream_rcvlowat_def_cred_upd_client(const struct test_opts *opt
 	void *buf;
 	int fd;
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -1282,7 +1288,7 @@ static void test_stream_credit_update_test(const struct test_opts *opts,
 	void *buf;
 	int fd;
 
-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -1542,6 +1548,11 @@ static const struct option longopts[] = {
 		.has_arg = required_argument,
 		.val = 'p',
 	},
+	{
+		.name = "peer-port",
+		.has_arg = required_argument,
+		.val = 'q',
+	},
 	{
 		.name = "list",
 		.has_arg = no_argument,
@@ -1562,7 +1573,7 @@ static const struct option longopts[] = {
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: vsock_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid> [--list] [--skip=<test_id>]\n"
+	fprintf(stderr, "Usage: vsock_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid> [--peer-port=<port>] [--list] [--skip=<test_id>]\n"
 		"\n"
 		"  Server: vsock_test --control-port=1234 --mode=server --peer-cid=3\n"
 		"  Client: vsock_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
@@ -1584,6 +1595,7 @@ static void usage(void)
 		"  --control-port <port>  Server port to listen on/connect to\n"
 		"  --mode client|server   Server or client mode\n"
 		"  --peer-cid <cid>       CID of the other side\n"
+		"  --peer-port <port>     Port of the other side\n"
 		"  --list                 List of tests that will be executed\n"
 		"  --skip <test_id>       Test ID to skip;\n"
 		"                         use multiple --skip options to skip more tests\n"
@@ -1598,6 +1610,7 @@ int main(int argc, char **argv)
 	struct test_opts opts = {
 		.mode = TEST_MODE_UNSET,
 		.peer_cid = VMADDR_CID_ANY,
+		.peer_port = DEFAULT_PEER_PORT
 	};
 
 	srand(time(NULL));
@@ -1626,6 +1639,9 @@ int main(int argc, char **argv)
 		case 'p':
 			opts.peer_cid = parse_cid(optarg);
 			break;
+		case 'q':
+			opts.peer_port = parse_port(optarg);
+			break;
 		case 'P':
 			control_port = optarg;
 			break;
diff --git a/tools/testing/vsock/vsock_test_zerocopy.c b/tools/testing/vsock/vsock_test_zerocopy.c
index a16ff76484e6..04c376b6937f 100644
--- a/tools/testing/vsock/vsock_test_zerocopy.c
+++ b/tools/testing/vsock/vsock_test_zerocopy.c
@@ -152,9 +152,9 @@ static void test_client(const struct test_opts *opts,
 	int fd;
 
 	if (sock_seqpacket)
-		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+		fd = vsock_seqpacket_connect(opts->peer_cid, opts->peer_port);
 	else
-		fd = vsock_stream_connect(opts->peer_cid, 1234);
+		fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 
 	if (fd < 0) {
 		perror("connect");
@@ -248,9 +248,9 @@ static void test_server(const struct test_opts *opts,
 	int fd;
 
 	if (sock_seqpacket)
-		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	else
-		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+		fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 
 	if (fd < 0) {
 		perror("accept");
@@ -323,7 +323,7 @@ void test_stream_msgzcopy_empty_errq_client(const struct test_opts *opts)
 	ssize_t res;
 	int fd;
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -347,7 +347,7 @@ void test_stream_msgzcopy_empty_errq_server(const struct test_opts *opts)
 {
 	int fd;
 
-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
diff --git a/tools/testing/vsock/vsock_uring_test.c b/tools/testing/vsock/vsock_uring_test.c
index d976d35f0ba9..4e363c6d6e4d 100644
--- a/tools/testing/vsock/vsock_uring_test.c
+++ b/tools/testing/vsock/vsock_uring_test.c
@@ -66,7 +66,7 @@ static void vsock_io_uring_client(const struct test_opts *opts,
 	struct msghdr msg;
 	int fd;
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	fd = vsock_stream_connect(opts->peer_cid, opts->peer_port);
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -120,7 +120,7 @@ static void vsock_io_uring_server(const struct test_opts *opts,
 	void *data;
 	int fd;
 
-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	fd = vsock_stream_accept(VMADDR_CID_ANY, opts->peer_port, NULL);
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -247,6 +247,11 @@ static const struct option longopts[] = {
 		.has_arg = required_argument,
 		.val = 'p',
 	},
+	{
+		.name = "peer-port",
+		.has_arg = required_argument,
+		.val = 'q',
+	},
 	{
 		.name = "help",
 		.has_arg = no_argument,
@@ -257,7 +262,7 @@ static const struct option longopts[] = {
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: vsock_uring_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid>\n"
+	fprintf(stderr, "Usage: vsock_uring_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid> [--peer-port=<port>]\n"
 		"\n"
 		"  Server: vsock_uring_test --control-port=1234 --mode=server --peer-cid=3\n"
 		"  Client: vsock_uring_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
@@ -271,6 +276,7 @@ static void usage(void)
 		"  --control-port <port>  Server port to listen on/connect to\n"
 		"  --mode client|server   Server or client mode\n"
 		"  --peer-cid <cid>       CID of the other side\n"
+		"  --peer-port <port>     Port of the other side\n"
 		);
 	exit(EXIT_FAILURE);
 }
@@ -282,6 +288,7 @@ int main(int argc, char **argv)
 	struct test_opts opts = {
 		.mode = TEST_MODE_UNSET,
 		.peer_cid = VMADDR_CID_ANY,
+		.peer_port = DEFAULT_PEER_PORT
 	};
 
 	init_signals();
@@ -309,6 +316,9 @@ int main(int argc, char **argv)
 		case 'p':
 			opts.peer_cid = parse_cid(optarg);
 			break;
+		case 'q':
+			opts.peer_port = parse_port(optarg);
+			break;
 		case 'P':
 			control_port = optarg;
 			break;
-- 
2.25.1


