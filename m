Return-Path: <kvm+bounces-13890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DADA89C3B7
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:43:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8ECD283EAD
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B68D13A403;
	Mon,  8 Apr 2024 13:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="KXtFA0Ss"
X-Original-To: kvm@vger.kernel.org
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04olkn2084.outbound.protection.outlook.com [40.92.74.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DAD512E1DB;
	Mon,  8 Apr 2024 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.74.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583487; cv=fail; b=KcuVJL3uj1tO1MRd0rZx6lRbdIRtJtYOjWK+ONHMYuZla1TQfkwaQm/vZbGCXPXM57+l80qaHKwaa+6SNlI7Rgi+AwxwKNfSRCM3gSzvkKV650g9yR8yTZPBFAnx+KeFvR7tVh1KAGw1Ix6lEZ8QQ54hFfroBlNCNH4nIzDEeu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583487; c=relaxed/simple;
	bh=kMkbuSouMVyfx9e17I2jia19HrSAMQA6Vxiyr4jC7TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n4HlFrwUlB7rbJpJQ0kdP3foavb8kPJKDWzqSnbbiGxHB+uZTcuH7dlvPxH1/ygbJmatcxaLKsGib1V93er55tLnFNtvfsnpvD+bsnR2KSZh+MhBICGJEzdVq/Snp4S+aujJj59kIblalA93OiutMxifRiCALmK1odUnavRiOFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=KXtFA0Ss; arc=fail smtp.client-ip=40.92.74.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jt6uIzF/4h1kqkxkaJLVIb03TeuBpRLK0zlkGd1elnkDUyWhP1CnmXNgQP3KBjyCPuUfrKuoZBYXqpJh5tfinXuPcKLhFRmhXDOTIJmkriN1krxI2m0H3HSCujYf7KWskGN4lErJRVjcNaa/B2ybuRZyIMgSW+cKPtb5lkWocOBQeUaCaawj0OKSjF+IEwLhKD8VeibaQ7XoyaxywFj1BzNQvpn2QV8+ZpbrVBdE1YpzHVHphEr6M0UJUQsuk47kAqgwEx+hFl8pLkbP3MJPZfi+GgPOI/Zfmi7UBXxP1PexA5UYejMDZ2rPehcg5xbbUq6NscxvfDQ05ZWQZNCj9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7WJsOAcjdVDt7Vxd6SdrBgUI2q3HCWMcb42jSXmBoAI=;
 b=WdLB1+cppQ/dDZVjGhmxb0yLziLBQoDRsZVpOOkieq650v2dBfI5bbTKs80H6F7CiGV0JdTHHuPeVYsM+S5oOwXwLVo62gyYl+1k72/xCJSs/REZSpkAUpVIA7iDaWWA7iCjgZygFhZUXP4G5nxJ79OgDBMrmmyd22WIKHOpVzlhc6PKRQAs4XBV3xpKHr+K7+SWOdrfF5nOoDMU+awBPp5NmZH9o/ipThWiqL6UZQ1aqAacDeOW6NxH9jOIzr3Ns4Zzeu/uzSFOt+yf+VYkv/DFAhlwEQJrUPbCHihiFjkEHN0YkYsx35OyxTgQ7aLKHDdWo33x6n13tLymWbXbNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7WJsOAcjdVDt7Vxd6SdrBgUI2q3HCWMcb42jSXmBoAI=;
 b=KXtFA0SsGemNrSCqoNB4Ghd/tVY31F9erv1IYXfI7JV9L4E7UTSHYi5R2l//fgJmMo6VvDMkWbxQ3Uk2a9n4UCfQbXO8QRnxS/4/nfCpVsL44dPKxXefUAinu58M9zQBtDSOFRycYyo+JrqSjI8pmt4x/9xSq5HwRpQP/oJHXB8Mv3rRElJPVBHf4rNcXp8OuwzVQ/SgmqG9bj6uksTfdwHm70T9MntA0jB48efRD19OJ6Rf2ZeGuRYJfhHZCZoPZ4jIexUCunzJaoraJKO+eM9kfFf21b8FUmRdMFF3I8EuFtNfwcZ/4VrfB/KTgGIsj4O3tx0DVMpMxTlRiHkx5Q==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AM8P194MB1662.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:321::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.47; Mon, 8 Apr
 2024 13:37:58 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e%2]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 13:37:58 +0000
From: Luigi Leonardi <luigi.leonardi@outlook.com>
To: mst@redhat.com,
	xuanzhuo@linux.alibaba.com,
	virtualization@lists.linux.dev,
	sgarzare@redhat.com,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	stefanha@redhat.com,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	kvm@vger.kernel.org,
	jasowang@redhat.com
Cc: Luigi Leonardi <luigi.leonardi@outlook.com>
Subject: [PATCH net-next v2 3/3] test/vsock: add ioctl unsent bytes test
Date: Mon,  8 Apr 2024 15:37:49 +0200
Message-ID:
 <AS2P194MB217007992597CC2E1BF71D679A002@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408133749.510520-1-luigi.leonardi@outlook.com>
References: <20240408133749.510520-1-luigi.leonardi@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [dILONH51rufQGRaOkOyWZiPNRtnd5OWN]
X-ClientProxiedBy: MI0P293CA0013.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::18) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240408133749.510520-4-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AM8P194MB1662:EE_
X-MS-Office365-Filtering-Correlation-Id: cf91efde-5ae0-495c-9032-08dc57d11a9d
X-MS-Exchange-SLBlob-MailProps:
	znQPCv1HvwW17eFZrekaPBZuDTSQRy8lIpg5mhFRKw0dzIef8ex5pMt4k4PMUxPPmFkwPMy3AtVzRP7WjFRwAkckTI3gHEUIXuIjgJqWtPyLF2zlL2K6qCydptc1rmAOf/gqw5QaHcwwXvE0kL/kybgxJLw0x1AIlOOfhHOmDwA/cV9lmbHQf50rfglG/Xk6oish/+4Mx7O4T0BLluXhM4ufip09AuDGsX7DUTWn9niRBDwckLNw5V7I6dJUYiPf6FO30zNe60wtYKa8SN6iPOar3azooJC7i8uZYZXO/LbvJyjvAX/wlOW6jcfHK8QbQxm0BXEIWgouYqAI+ksrepXEqpcslmb+EV4rGrBDRMZ6VsxQFHcLzZKoRFoh8Gxnl0sw/8iHcqfkh9vj0dTPuXkU6G7Mv13LP+fChuc3haj2PTjvkL/EyRd27/G/m0/d8qpzB0TyuQBAbkzJ5Dctt0sy7x/uztwMdA0MpGlJG8eDObpETSRclHsqZDaa5Z463pj0vrvZ18/T28O5wJNQljTakeMMqsn2PrWUhU4xyr9ymACDpmLTcdKgU6wtg7o1tjXr+t+gZFgm6oDCNVWsQPye2A61u5yNy3cCyTamvq4GeHELP/q+AQyDvqPvOPt4y8BOAjC/ZwlfSvG4C/hWR/A/mjcvXrpkEuzdoyRLJRoN/qiGzMnTEEWClAtoZW5fnkGI4e/40xIQ0g9MOaDOXrlceKin2JmrJ1F03PlH2IEWr7oU+7aH3Bc3cUmXQCiFYyoCg7cKF1o=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DTkg/jpp6AQDWuR1wTaWJN/QIgJnaPHc4PCI9k9501z5hGr1+l152pLieJmQ7L+hrI+pmaYj16q4/MPb1a2G+9yV/SWvWqdNnpoZpboL8d/Bmcdof3s6qGUBGSW4QsaCs1KULjgZ+NNAsjdIUCWqDw/qwJj/PwlnT7cfZyDnnJfYwQFSDqrR7OLucko7Dkk7+uFMGxrnaBmniiN16nr8Kp3cvK7y2QR5I577m1yFz4IWk7pOi5h0/V9MvP6KbKetcbUl51xN/J46mH6kjxpcOncMOCrjr1fQLb2F5+fy0w94upNXaatoh5TiVbo1FXRcNLsvbXob7pRU51DncJbZLSrGIC3uWCvYJfSRoQldqxgKmV8Foq50Qo1/0m8ohWUp/vMK7fMzoQEvX5FRUCpQkQgtOLwfT51sd57CcRx7qk+JMEhDPF64ZiiB1YmXpYqrHWoCiOYwvs0N9YvtJCIVIEFV4q0RmXHxx7MQbemkhqSSPkwjLxHchCqGUaoPN4wzC0XSZ/Dn6j6yL1pUGIqqx1FknRRjLvUh1J8MA4RI3+mk89ffXd4KZtoqMAmFzuuAsjkT+eUKYMorw2cjNrgOBD+MItr0j1jvHiJ7W/8WQTovgqTp9E4N+x/tczyibpy4
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x4g4wC0NHtL006aM8irss2E4QcP3OsY4oFZrhLwt9xH4AFejyBX7mRaQ01rC?=
 =?us-ascii?Q?MEzR877rFLQCUeOfGeoduUPA+gV4PcLzjW+CGHOncIe82k212yWaDFBp/g2O?=
 =?us-ascii?Q?K+3cN68wNRMfCu8dumShB89ZdZ5JnZ/sn/tiOvT7PRCwO8cepimoAk092VKI?=
 =?us-ascii?Q?G7lowW4SLsfX0ub0H0H+igV4L/TC2hYQ3Qcd2x2vD+yBfb869UwOSymAcucr?=
 =?us-ascii?Q?S6dppYvROIYEDr3d8JIMMPoRie9D3KwsvJ4Vf6nxNtM/glLkQ5qQ03uA2St0?=
 =?us-ascii?Q?YYmPid/AkLwdEZM/D33xGfbcqbF/cV8kAzJ4el9uHGLlyOC1HF1wz805VyCn?=
 =?us-ascii?Q?3+k7GvSB9EqKHaGy7+UCdywj7PaN/9sJIK1iSB26523S7AqYcKFI2aX0Eady?=
 =?us-ascii?Q?Iw3YfqbAvT6XAt/9jcnxgUYzmRK4yn+Vm2iaq4kJZ6bBevU17UC2VOHO5JK6?=
 =?us-ascii?Q?sC5nVPtW3AHZ/AHlaB5R0+dilfKE7ktcJFS2nzv49HZB1IsYX+Izd21ihWyk?=
 =?us-ascii?Q?jKazrUeTBqoRK02vMtWVUs/YB5TgL6zHhrwZral4f9cKoLmt+7t5Ody/ov/q?=
 =?us-ascii?Q?IsWIUSfdpNfs6ejDbbPnrUi4qhdVZnIJJf+oc7wDOYJfWbGTFC7AE1ClZ3T6?=
 =?us-ascii?Q?vIvvnwlxsUX5awBfv7Y4xOnSwq5bk8S3OQ3Mhqo4I6nSTcabRvoJGGYeln/X?=
 =?us-ascii?Q?/yvod23Ag/yhGZBD1ZljqkAeztj2ujhdVh8UcFHHFYi4tuDP6aqDR6/4q/xo?=
 =?us-ascii?Q?ONP0BW/m97Kf7Z+wMfGgKT69bcKHiF394Q9JWW316optm+qNBvJY7rTF01so?=
 =?us-ascii?Q?BW3XedBUrCKtSXGg2hSMb369wODoI1IVWN2ETax+elg4Um3CzIDmy/ViLgEe?=
 =?us-ascii?Q?hjH6G0sklz1g7VKZyJ19Rv3vdnOzLYzFv8+uJ3FCsZvMDW+/nCf+pKvInrV4?=
 =?us-ascii?Q?fwjEmKJGIaMwRL2m/gM/+rAbdWH0jhLgKgRr6Zfx+cMG0sSwlR1OtiuZm+IX?=
 =?us-ascii?Q?OMeQnnfTxOTMjrDZWIaQ8z4eetwDtGOsthY8O+84C875JA+TPPf6dAgEOWk6?=
 =?us-ascii?Q?HWG28IWs7Ew3WuDC2NGmG899NH98f2+PuU5T5z5Vnb7pxfJHhEx5RircpgW3?=
 =?us-ascii?Q?4aq5V6iMbsmiddEAWpuSIdr2ov8a8mXsHr+OThXgwVQ8mlJKlywf0hhBNK3b?=
 =?us-ascii?Q?pe9Q6FFBUIFDeIU2WIPwvp9bEq1ojIoczrsuDI3n+R/nyfCozLJQKzSRBUXt?=
 =?us-ascii?Q?icP2MCHSadPPhhZ9EP2C?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf91efde-5ae0-495c-9032-08dc57d11a9d
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2024 13:37:58.8173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P194MB1662

This test that after a packet is delivered the number
of unsent bytes is zero.

Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 tools/testing/vsock/util.c       |  6 +--
 tools/testing/vsock/util.h       |  3 ++
 tools/testing/vsock/vsock_test.c | 85 ++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 3 deletions(-)

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
index f851f8961247..c19ffbcca9dd 100644
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
@@ -1238,6 +1240,79 @@ static void test_double_bind_connect_client(const struct test_opts *opts)
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
+	if (ret < 0) {
+		perror("ioctl");
+
+		if (errno != EOPNOTSUPP)
+			exit(EXIT_FAILURE);
+
+		fprintf(stderr, "Test skipped\n");
+	} else if (ret == 0 && sock_bytes_unsent != 0) {
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
@@ -1523,6 +1598,16 @@ static struct test_case test_cases[] = {
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


