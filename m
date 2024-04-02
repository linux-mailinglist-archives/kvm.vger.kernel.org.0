Return-Path: <kvm+bounces-13378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C768957C6
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 17:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2FED285C04
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 15:06:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7145A13280D;
	Tue,  2 Apr 2024 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Bb3nI1QD"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05olkn2072.outbound.protection.outlook.com [40.92.89.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EF712FB01;
	Tue,  2 Apr 2024 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.89.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712070358; cv=fail; b=PGLho3B5YCq2RZi/uDeIIJMY/Doq51nkWfXT6OXBTRa2u4zvWCZnO6qBuJgPyQ0rw1oJTmzWXT8BEQf9R/vn19WrmW8hzJRvhvCMc3WDd9L0RQ7THLp0IsYBO+QoDato0sRRU65GPjM5NC2nXyj60sYRSosXuP/2dG7v79FDiRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712070358; c=relaxed/simple;
	bh=6j0ZMigYN//DH4xbV1jGCceAialFNF+70tmwiv2Awiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BWgkWZf2etzdU9qJQgBVR6O/ELhZsiWxIqi8njQWyd7X4T7+ZBaMMQUOyLbHwXDuQkUA9O3eGZ4M3RmDoqIA2EuoA31/ha74+avxnDSncHu11Op4z3X/GovJCj0lcmHhH4iOF5/gjXkwf1mbSaow35/yL/tmZlZnYhRnEctjj6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Bb3nI1QD; arc=fail smtp.client-ip=40.92.89.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDbM/RGYfaIvh/6edlp1CJlyR4h+tKsdsabD/UQjtll9b6l0+JSuOs6YRy7Vjj8p0VeETRGR793GQOFpNFEaGhtrVV0ATSi/M7xmZUVUre+a+0GsSF0q+2V/enSeeWBVoR7ViooIowtMXZBPUNQV7m6AiO76Bzsv1bVloRG0UfN/Ku/xmiApVCczEXfbrj1AcUzjOKczyuQ0plqPlMZ5MCfKPQG1gw1dkFnnSx8pdsPllsnD9WhmDRUFG0I1OAJEND4IydKs+wsNKGY/aDEcdyik1bimfMXdggakfJAk58HdX2MNhAZrQzv264UszYMgMtw7f489cqodIg4rJJToeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUEn2OjKUfkWAhbaW9m80S5CbKmWejDeozwTLWd4HW4=;
 b=Jnp4TtIxdiPKdxHiZqPIxyneEhsOZ0+Cng+Fm2fa1zmRc3JP+mKQ/P03NOpSVlo8jr8utal78LBm+0scwEhDJ5CSSL7gQwKHU6FKYEIQS6OkoIRs91TnYAl+LDxx1lFDnT6CSDu+X5wZrQYgvW88JV8JsPx7Lg1J5a9IwTiprUgq6vyVGh/0fN7nOfY3Uq4sF8KSb9yjUrI6ylQvkG8AIzbZ9WVuVgq2ZodfkVU41OEQYW9Pzbrrezs9rkCLwElBv7EP1Ff/rYCUEijNtsP8m9ZBFTXng8tlH4MrOm5w1O2NbOTNrDiaFr6YHuHKtu0ghNvjsFh/AB9tban9BvR6sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUEn2OjKUfkWAhbaW9m80S5CbKmWejDeozwTLWd4HW4=;
 b=Bb3nI1QDQ3yJhrwfglpOKovW9I/AvrhccXfZDzKuWkAIPMZqehnr7pcRL3g27Ta4HUr+HVRgc0Q5pNOi2NQgU6iiANniglp6xGDsa7xTnZtwModxOwJPRn4b1jLKuJH28Cparg1baBkXR/icqYg5GZB3QTbzCGhoELhjlWoEs631zXEhobKyFopuKQZ+7mz+74eGhEKaIFi+JSSt4f9WPFYM3/dGInZLbei38movNbGbm9D0lUhLdnVEwNGPK1J2sG9lxLCcR5AnwJXbSu1wCYCPVK3ZUvnXfAqee2idNZd+UOx2an+mBsZa8zqQGR9h4+8NTb7rgNDVhOTZtU7iXA==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AS8P194MB1141.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:2a1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 2 Apr
 2024 15:05:50 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e%2]) with mapi id 15.20.7409.042; Tue, 2 Apr 2024
 15:05:50 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: sgarzare@redhat.com,
	kvm@vger.kernel.org,
	jasowang@redhat.com,
	virtualization@lists.linux.dev,
	mst@redhat.com,
	kuba@kernel.org,
	xuanzhuo@linux.alibaba.com,
	netdev@vger.kernel.org,
	stefanha@redhat.com,
	pabeni@redhat.com,
	davem@davemloft.net,
	edumazet@google.com
Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
Subject: [PATCH net-next 3/3] test/vsock: add ioctl unsent bytes test
Date: Tue,  2 Apr 2024 17:05:39 +0200
Message-ID:
 <AS2P194MB2170D78CDB7BDF00F0ACCB079A3E2@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240402150539.390269-1-luigi.leonardi@outlook.com>
References: <20240402150539.390269-1-luigi.leonardi@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [n/sqeC4ap42aZMRqDNtkUSy5ekACeoKk]
X-ClientProxiedBy: MI2P293CA0011.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:45::11) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240402150539.390269-4-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AS8P194MB1141:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c37df0-b72b-4204-3117-08dc532661da
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XLU+9pJZmrhMcZ9+84edN7ddRPXXFHPWI78QWsQ7CsvBsQjMbgzy/TeG3SUGqV9oFnuLurdIpcfkRadDUkiFnKpZemju6DhDUrxCNejWshQVRl9fsz4jupGsJfG5F2N0HVBckBVedpm8FD4jGkCWgqAD7/nYEWUgJhzbVenWhVeM4Nr++5ECz178c7K5pfzcR2bbjO1gE7KLvkjvQ2gv9abubgSMULUjL4l1T/HijTnpqE0Jdw2OGT2oaRTrp1HGqi2ZtAbBhXpHVCcDFU5ljfhVHsia5Gx3rvNBBQ2BAWbq05LRW/arN5xpjOt9EspE2YQpnu+sZC8ToG5lUui6uttcRzE8W+UsTKdk9t7y3q3nPm6k/70jxZ7SqJSTB0Lo8ch5ahLUQAeZ3064w/37oUhrZUbuJTFNb9VVxoqmpkLecQ8arv1KPYao3e5eUHF2AbqGWSJWyQqHY+FSJho47skY+8cu0h4p676BSb0m9JdqRhkiOH83sdu5fu5QHtyqFdCUWxGM31ubE8kEk3b8x5OUcZCQ1n7SB3ZzbwRIr6pqkpttCgnf2wx0C0TaBe8y+0nhgk8SEEDNHpgAYWn0w4ilGO+a5FMwrN/nDyGaHQ2G5N29UILoajr/0C7xBquf
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KYh3dAw3qytVpHLotFe9z7mQhlOIfTq174I2r7PJTedBXODfTfMoZMUqhqK+?=
 =?us-ascii?Q?1jtvJpEU2NzBgXtfMgVhRllUi69x29oZ1YFSnv9AQXOheWHTW9l+vsblVsHF?=
 =?us-ascii?Q?RrMuyQp7iRHkUSpnHrqSZ00HSDNCE97NMNa6rUkISgZSKwKxGFwFLZvKwgkm?=
 =?us-ascii?Q?EXObXbD0byEuU6vRc2bV6OObQ3sE8BtMvyqqqHz7ENTwuPtCiIGqAuD8j9O2?=
 =?us-ascii?Q?2wSudSkH4BdYIi0HTLKxkrqq1W7/kBg1makhkm70+RZfx9gkKfvlKsvsgd+W?=
 =?us-ascii?Q?yFuzVmxQOWvHyY9+yaC+OiGL19W0cvVUVJgsbHDN03+gx89tEwELGE/L+sSh?=
 =?us-ascii?Q?0rTo0Y2pnCO95TQXAIwlufmTU4O+pcQqh1f1q8J12XnTsk5uH2XeRaxM4yqt?=
 =?us-ascii?Q?/srIjHCQjW51YdHsESLq/majN4kcLcGm/fcqm2GrdldTq4EwgzAdsgw1bsiD?=
 =?us-ascii?Q?QVaA/uPiXZ4zpnBBmEhpS335yaTpwE2Ya0w7E3F0zLXIXF46vP7LxbtBl6Xt?=
 =?us-ascii?Q?3VO1bfigwcnGsub0clCnNatxopqIcWpD/4YPTNo3vWSA5FwWPddhDU2m/14D?=
 =?us-ascii?Q?/cGcMd9pEb8KuaOIcNToabRzkXOiej9VP2+QsPB9d5y+H7VqZXa7TbKqOBzQ?=
 =?us-ascii?Q?sC1tly+LsmHiAL0ZNCAXvb+NFtoKByZuZ21p70kyANOR8QahOBsDPaOQ/fb/?=
 =?us-ascii?Q?aS0ZwDFl3rfelujo+CE2cu9BAcimDa4OGfZ970KdEvqtTAzNKffOJWdPC8Qm?=
 =?us-ascii?Q?0aB+M/o4Yiv61ksZsy9fnvVOdid3bbPW4Nx6XjI57akWqhsTDad/MvvQSLWb?=
 =?us-ascii?Q?OONycMa/pG04jHbeLtzfP6/EDFNRuX4V3t5316Bmnxkw2/6mW+xdnvP8zb3S?=
 =?us-ascii?Q?AOelJESEVtkbJ+zB+/wEmOz/pW1BA3O+xjqDV5duWmB5gBRh40VC6jkvA8aw?=
 =?us-ascii?Q?DtCiiJXBJYFQ6/+ukUUAi9wbtAfXCJfv62B7lO2xPezKrzhCTkSlckW3C1Qu?=
 =?us-ascii?Q?X//ccm+4fF4xI/FauDYe0wR8xEQ/tX7I+75CE7U3+zjJVliOPK0JXQiwHQQP?=
 =?us-ascii?Q?B2w23biMOKwCBl/Ha8GYZ9Tw3gJf/pOh5bH6H6cK0dISxt4Zdy7msCjssj4h?=
 =?us-ascii?Q?7NYZsDcviN0UgTIbS0ncgms5pFoX+MRklDU/XNinu0m7ywOxB/GVrPDBgf+y?=
 =?us-ascii?Q?5H5uWj1V9OBmzUSecB8JOjfLBgXa+ipOL2JRVFWxnjfgeVEypwLOfqXORxYn?=
 =?us-ascii?Q?R3iQkQFXux1xH0dC8khN?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c37df0-b72b-4204-3117-08dc532661da
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2024 15:05:49.8634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P194MB1141

This test that after a packet is delivered the number
of unsent bytes is zero.

Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 tools/testing/vsock/util.c       |  6 +--
 tools/testing/vsock/util.h       |  3 ++
 tools/testing/vsock/vsock_test.c | 83 ++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index 554b290fefdc..a3d448a075e3 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -139,7 +139,7 @@ int vsock_bind_connect(unsigned int cid, unsigned int port, unsigned int bind_po
 }
 
 /* Connect to <cid, port> and return the file descriptor. */
-static int vsock_connect(unsigned int cid, unsigned int port, int type)
+int vsock_connect(unsigned int cid, unsigned int port, int type)
 {
 	union {
 		struct sockaddr sa;
@@ -226,8 +226,8 @@ static int vsock_listen(unsigned int cid, unsigned int port, int type)
 /* Listen on <cid, port> and return the first incoming connection.  The remote
  * address is stored to clientaddrp.  clientaddrp may be NULL.
  */
-static int vsock_accept(unsigned int cid, unsigned int port,
-			struct sockaddr_vm *clientaddrp, int type)
+int vsock_accept(unsigned int cid, unsigned int port,
+		 struct sockaddr_vm *clientaddrp, int type)
 {
 	union {
 		struct sockaddr sa;
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index e95e62485959..fff22d4a14c0 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -39,6 +39,9 @@ struct test_case {
 void init_signals(void);
 unsigned int parse_cid(const char *str);
 unsigned int parse_port(const char *str);
+int vsock_connect(unsigned int cid, unsigned int port, int type);
+int vsock_accept(unsigned int cid, unsigned int port,
+		 struct sockaddr_vm *clientaddrp, int type);
 int vsock_stream_connect(unsigned int cid, unsigned int port);
 int vsock_bind_connect(unsigned int cid, unsigned int port,
 		       unsigned int bind_port, int type);
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index f851f8961247..58c94e04e3af 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -20,6 +20,8 @@
 #include <sys/mman.h>
 #include <poll.h>
 #include <signal.h>
+#include <sys/ioctl.h>
+#include <linux/sockios.h>
 
 #include "vsock_test_zerocopy.h"
 #include "timeout.h"
@@ -1238,6 +1240,77 @@ static void test_double_bind_connect_client(const struct test_opts *opts)
 	}
 }
 
+#define MSG_BUF_IOCTL_LEN 64
+static void test_unsent_bytes_server(const struct test_opts *opts, int type)
+{
+	unsigned char buf[MSG_BUF_IOCTL_LEN];
+	int client_fd;
+
+	client_fd = vsock_accept(VMADDR_CID_ANY, 1234, NULL, type);
+	if (client_fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	recv_buf(client_fd, buf, sizeof(buf), 0, sizeof(buf));
+	control_writeln("RECEIVED");
+
+	close(client_fd);
+}
+
+static void test_unsent_bytes_client(const struct test_opts *opts, int type)
+{
+	unsigned char buf[MSG_BUF_IOCTL_LEN];
+	int ret, fd, sock_bytes_unsent;
+
+	fd = vsock_connect(opts->peer_cid, 1234, type);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	for (int i = 0; i < sizeof(buf); i++)
+		buf[i] = rand() & 0xFF;
+
+	send_buf(fd, buf, sizeof(buf), 0, sizeof(buf));
+	control_expectln("RECEIVED");
+
+	ret = ioctl(fd, SIOCOUTQ, &sock_bytes_unsent);
+	if (ret < 0 && errno != EOPNOTSUPP) {
+		perror("ioctl");
+		exit(EXIT_FAILURE);
+	}
+
+	if (ret == 0 && sock_bytes_unsent != 0) {
+		fprintf(stderr,
+			"Unexpected 'SIOCOUTQ' value, expected 0, got %i\n",
+			sock_bytes_unsent);
+		exit(EXIT_FAILURE);
+	}
+
+	close(fd);
+}
+
+static void test_stream_unsent_bytes_client(const struct test_opts *opts)
+{
+	test_unsent_bytes_client(opts, SOCK_STREAM);
+}
+
+static void test_stream_unsent_bytes_server(const struct test_opts *opts)
+{
+	test_unsent_bytes_server(opts, SOCK_STREAM);
+}
+
+static void test_seqpacket_unsent_bytes_client(const struct test_opts *opts)
+{
+	test_unsent_bytes_client(opts, SOCK_SEQPACKET);
+}
+
+static void test_seqpacket_unsent_bytes_server(const struct test_opts *opts)
+{
+	test_unsent_bytes_server(opts, SOCK_SEQPACKET);
+}
+
 #define RCVLOWAT_CREDIT_UPD_BUF_SIZE	(1024 * 128)
 /* This define is the same as in 'include/linux/virtio_vsock.h':
  * it is used to decide when to send credit update message during
@@ -1523,6 +1596,16 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_rcvlowat_def_cred_upd_client,
 		.run_server = test_stream_cred_upd_on_low_rx_bytes,
 	},
+	{
+		.name = "SOCK_STREAM ioctl(SIOCOUTQ) 0 unsent bytes",
+		.run_client = test_stream_unsent_bytes_client,
+		.run_server = test_stream_unsent_bytes_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET ioctl(SIOCOUTQ) 0 unsent bytes",
+		.run_client = test_seqpacket_unsent_bytes_client,
+		.run_server = test_seqpacket_unsent_bytes_server,
+	},
 	{},
 };
 
-- 
2.34.1


