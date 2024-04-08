Return-Path: <kvm+bounces-13888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 24C4B89C3AD
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:43:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8867284184
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 13:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E89E12DD83;
	Mon,  8 Apr 2024 13:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="RwTMLVeJ"
X-Original-To: kvm@vger.kernel.org
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04olkn2084.outbound.protection.outlook.com [40.92.74.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8C17E111;
	Mon,  8 Apr 2024 13:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.74.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583483; cv=fail; b=ESkQQpCD5U3tYm1EdV0qzjAlSrEVJSVQcG7eY3+W/1fdk1kw8C2NHVLKftnIRR91z570rsAgGsJBRKfYO/NJFpfKjOeKggVrahjEs60AcFnmZ/4eL6NYd+LlH3pTSj56Dm31EAl36YVc45Rj9SJT7t1vtMzuMdoFUObH5qXawMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583483; c=relaxed/simple;
	bh=bjs0waJJJzCAnHAplsfPeH63EhgESuijhn62premjRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kSJ31U9lsUIwUhmd+9052lox7LRuWKJ9EOKS9bxLRH1vHorJH+YC8tBl+hM2yFu17KGpvYj8tSl5UVa7/+3F8coplN/8gNp5lH2B+hg+0OvQuY1uHrLomgt15aOukT2bZ2HsSpfY0YIpkiMjeJ0C0XW5ml/0r/CdVqLQZhMuJVk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=RwTMLVeJ; arc=fail smtp.client-ip=40.92.74.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WvWzAJDKmMg0qYw4G8UyG/8aa/w5jDkRAq6kcJFT85/sqbuXV6hx9QJG+HDdQN11Ul2l4r7twrki/KNOVmbyT+rABjRJFulxNncO9fQi6+RVSt5X/EqdzDr36RmbR4z6wb9oG5CSWySwjrTbJUSx1E7D898j7ANB6HsX+V6ZMx5ipXO/OfnJDp0IiZGyyHwNtyAXj8tHgFZcekXRiCLGDSolnSahEfUtb8CEC8ri0BOgf3BF3zWaclFaeMn8sezSzqkOZh1Iai9eu5aaUU5EwTTlC+KCE1oPZ/LpLA0ZehvmYp3gcedgacvUbNjVYwan9Qr/O4b52QEFxFsWleJPBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrNlYd7P5EJrJNCMHnW3SyA0i93SxmOovuYl0g4DPgk=;
 b=dWCfasbUvBR6r0vnzQClLVIk2e5r/l6O0L3NOmPr6bR2p3hJ/11B76SusNvfoG/3ws4+6cjHMBugRFyQqfrl3yoEaAUUXOngo0QaPGo0/yGuOrStGqw8Y46fqNwXMmeyr1AT/U190Scvfp0ObkmBOPvhEnsnHb7IrFEqbToSnBGc2Oz92fxrydhv556gCCjNiamaML0ojRka8KPGdRuoWMCzO4EyyzDYE0Fw8x2oGI3H2FFi1HQ3I5ntPZAi+HecICrOM6jWCi2yxO7ypWTmUhcKTiM/16JfAoU74gbhV8xE8etKSljec5vI9clTXPbZ0I4JovfwG+TlfgxMLO1JbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrNlYd7P5EJrJNCMHnW3SyA0i93SxmOovuYl0g4DPgk=;
 b=RwTMLVeJFyjBmEfg5fQcv48ua26GTrZoNOL7fX7eC5ElPJysDCYDPPds1yntqj5sHR0GKIOnRAawmET+APH3ScBdsZh+TdEtiBxI3045fbm5NqH4zyMnweT30kxUBQyEPTf6x+aMzZdUfjU9QvvXztBoL3ZrsEu7ZaFxqu1HsL59u9/BOSPDJrAeBT5Fm8slXX9yO5bHIc0tDj9UJWCEokJ2q1C3CZk5WiiQ39pPlMA3PkjUipHjHtppIEGDjZOy+IGiIGVUkwaAuk8O0G3ZkkYfe0TRr+LNGtRISLDm443+jhI3wsYVfwjXlqr5zqNsM8rFYXX5Z1qABkraqZJnbw==
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:642::8)
 by AM8P194MB1662.EURP194.PROD.OUTLOOK.COM (2603:10a6:20b:321::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.47; Mon, 8 Apr
 2024 13:37:57 +0000
Received: from AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e]) by AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 ([fe80::56f0:1717:f1a8:ea4e%2]) with mapi id 15.20.7409.042; Mon, 8 Apr 2024
 13:37:57 +0000
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
Cc: Luigi Leonardi <luigi.leonardi@outlook.com>,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: [PATCH net-next v2 1/3] vsock: add support for SIOCOUTQ ioctl for all vsock socket types.
Date: Mon,  8 Apr 2024 15:37:47 +0200
Message-ID:
 <AS2P194MB21708B8955BEC4C0D2EF822B9A002@AS2P194MB2170.EURP194.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240408133749.510520-1-luigi.leonardi@outlook.com>
References: <20240408133749.510520-1-luigi.leonardi@outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [PhkoXylYMxcPjdqbpOwBRj77EFiJq/nQ]
X-ClientProxiedBy: MI0P293CA0013.ITAP293.PROD.OUTLOOK.COM
 (2603:10a6:290:44::18) To AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:20b:642::8)
X-Microsoft-Original-Message-ID:
 <20240408133749.510520-2-luigi.leonardi@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS2P194MB2170:EE_|AM8P194MB1662:EE_
X-MS-Office365-Filtering-Correlation-Id: 1eb9f2cf-ea77-4947-65c3-08dc57d119b2
X-MS-Exchange-SLBlob-MailProps:
	znQPCv1HvwW17eFZrekaPBZuDTSQRy8lVwRyxtiHsHNEkzM5ereoWqUmXLCJpiI2KdtWfnEJlRwiIi5mPKSVDXFI21jLyOYbybTTC8N6OfX+3e7gvbREtHrFEBZwoS5rODHri9ob9bPazOQhgiPw7yle1SUJOwMBp5l74+ANRyRbMGqJNJV79hQFrzlZZ1Ttz0agVhEHTVw5aJfIhMeFe8u91CA5vwd/zWPL14rFlD1Xp01AnW+ASg6QoiQ7dshBQf+/vhftA7mrBkANYmXUgudU2MV/MskvwD6bSh1fddLoeTqom2WfSoFdU9JYmOQ0UH2ncfAZ9Euk7V43Drzz5O/2hQYlyRdNo4/2KKSMS0prtrmBqzJyR26ZVnFit7l98dqVjpVPfhNshsqErKw9JxMwRFnm29c3zW8I/xUB7C7V5paPPoIpNveRg3O6VEnWqejDsFuWbEt5GPalnmCAYmdtHKF93GkqkoU4l42i6H0WMBaQFUkLo+qHMhubTa14cD+PHiP/HMCZiq5VKzR/I90vNxICQh34MjoHI5eVbejMQKN0IHdGsLLERbSUgiGFQL7AnCqMzq5kXuTtQFO9gBL3cdemgA/4rJERdYJgrSaBz0NdkdWpYhu6aNifCcwJtJctenOSrirKROGZyq2k6YX6/El8nhHeJwszjSbp3E4Iyj/vUUzh67BhilI7YiZhMlR/PefFzEYRw1Gx4MPh8fPXdmWY31db79EaC3put9N0nWg3bh5yaXlr5XddpXnTdkHt0UW/9/U=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pK12T2p4NdFk7NsLT3N2Zd+arDOl1qJ2pNZgcvFpCYqFwaXc2u82ElautOWpR9nW4vmgG+PafLIPYcE7BAJyyw8hHCIOl/QV95eHQweNGttLSJV+g1nrGKs5x6jc33aOkZjrwY5e+zvtzozvJnaE7WGXBNN5xUiWehsVQlrDVIX8sp2L/SsliY616XJQRL9cM2o8odMX4vNwTjE8dNpNp8lwHBqgm0SPEsU3R5LaRFo4qMf8UfMEYhqtxUhRS2ByC4wOL9ISdKU/LVJ+j6TIwX4sido+S6qCIZUY5HKrzQL2kJ2uVffJnSyzLC036VtJgrwFJO16af6MjtiWmUaqAkgLc4jabL0AiDSO3ikNj+QreHsZAgfkT7rlpsDAqeltgqYqdwYWsI1NpYtU0JV304zhtGdx06W2e+ZvpAmt+bGgpqHaWGGMjr2TLniQaynm/8WOf/99iBTDNDtX49JLSf5kTwatBu+jIS/Az/mq1qU0/RwiziIqdINDPpJdFJoQSbxokBFmK7g+BMnxbhQVpTOMlFRscjnw0GPwikd5PU2ki4LvA9xsIih4qMKu/hLI4skH9bbaK6U/qTr/xR4Xp+u7rH49mjlYGFsjXNC+QJAjfupnIxdlaHB34kJUYsKz
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VjksOsJFjw4Dog+c8FAimcC81XhupiBY3lz6lPj6Kj08GxdNdS4OoAtT/Dy0?=
 =?us-ascii?Q?RZBC8TtOXKGO0XXOSE4CjVho5iqGx6/E8ZslICRRI0zn/k4ZYFsbmfbHeMJ8?=
 =?us-ascii?Q?bE984ByPHCT9b2L4BLSrb1nER/+uhTOCF1ilKP2pIu6Ut1CdxTuVNJlAlG5v?=
 =?us-ascii?Q?TPALJCeW2346YoT/a3zNXowib6i2qggTUfRxLOLvIPRfdEEPE2m11lkrmRVc?=
 =?us-ascii?Q?+m9LrWfOphTYUVN35yJhr0/gxKCwTpjuDBIw9MaoysG6pS+pdTyMB23I+sVb?=
 =?us-ascii?Q?5LNQjBdM79ClImdoNjZZLwIRuirNogOPpzFzBKU1/yJD47gOWil+p7ArNBEc?=
 =?us-ascii?Q?bUJADG6BN7fBFIRBQ/VKUq4MbEyW3+qVoHF6Nt1AOqHdtkp+ibJVybKGg1dB?=
 =?us-ascii?Q?PbnzcjuasSD8yF6GAzek7Nf74c9rqotKb4cryQVytHVIhGLj+VVScLVAuw3X?=
 =?us-ascii?Q?gNApV5dreGtwlkyNMKbMzOHJeJm9tfRPUZtSx2XGf5fujIihf/ovAdZNRR64?=
 =?us-ascii?Q?qSIpmtyb6XXq/uSIGg/3+SuLTXUch5LJG7lB1O3EfBOGaWqfljnvtvVkHkaL?=
 =?us-ascii?Q?YPvU/i4cKBPMVrP0eUBt80B/L0b53YDYvlReqEzBI3ShYY9XHXQq2lgorY4+?=
 =?us-ascii?Q?D2l4bSjh+xerhHemeEad0+gzDtJH1V/kHwLhOLNDT1zA9TkMi3Mq2UHYAIVQ?=
 =?us-ascii?Q?lQALmrNQ64fhioy0Vkkz7VD9V2xoVJ+TgiYx3HnaeS0vwVa5wBD5AF82qKgu?=
 =?us-ascii?Q?4xHdMtCOeAJ6fFU9yQzJze3q30KneZ01VRioYyHAPJT+fypbHMA+3zjwRERb?=
 =?us-ascii?Q?YIg9ktFsEIEoyI+MwgfaWBAqzEasqD/kZwJDJhaum131z4It0MN6VCn2oxHx?=
 =?us-ascii?Q?ytq8chzM2cTXoQTOgCK+jsB1uuVUynXoWNrqgGLAkWTXoc1ARlsiEOlMiWlg?=
 =?us-ascii?Q?evmdyKt8tkxqUmFJn2Vu4ySEPRmObbKNKYAfROzbZxiaB/uuARdknGwC6Ngs?=
 =?us-ascii?Q?bGgYI4Hg1qXqVQ+uJEHmr6PbBcUvXqxZPvwJyRQe8vGQv0yAgkTtg/+hAZ5Z?=
 =?us-ascii?Q?nTlX49PzQSwx4X1N2knaSvNbo08fTFo+mnWtcuFWVnvoBdA/YaN82GcyhMIS?=
 =?us-ascii?Q?WktK72R0qUbQrQ9C1A6BhavUjfnupxovNkmAxpL9TR1TfVJ0NSyOFMpxrvNs?=
 =?us-ascii?Q?ePs2JlQOQCIG6gwYRVZPFROfRzcSjkLy/oRroFNAAnob5e52aGtaRuDRy0Xn?=
 =?us-ascii?Q?q1UidbkwoJCgQQj9N4lZ?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb9f2cf-ea77-4947-65c3-08dc57d119b2
X-MS-Exchange-CrossTenant-AuthSource: AS2P194MB2170.EURP194.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2024 13:37:57.2938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8P194MB1662

This add support for ioctl(s) for SOCK_STREAM SOCK_SEQPACKET and SOCK_DGRAM
in AF_VSOCK.
The only ioctl available is SIOCOUTQ/TIOCOUTQ, which returns the number
of unsent bytes in the socket. This information is transport-specific
and is delegated to them using a callback.

Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Signed-off-by: Luigi Leonardi <luigi.leonardi@outlook.com>
---
 include/net/af_vsock.h   |  3 +++
 net/vmw_vsock/af_vsock.c | 51 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 535701efc1e5..7d67faa7bbdb 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -169,6 +169,9 @@ struct vsock_transport {
 	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
 	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
 
+	/* SIOCOUTQ ioctl */
+	int (*unsent_bytes)(struct vsock_sock *vsk);
+
 	/* Shutdown. */
 	int (*shutdown)(struct vsock_sock *, int);
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 54ba7316f808..fc108283409a 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -112,6 +112,7 @@
 #include <net/sock.h>
 #include <net/af_vsock.h>
 #include <uapi/linux/vm_sockets.h>
+#include <uapi/asm-generic/ioctls.h>
 
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
 static void vsock_sk_destruct(struct sock *sk);
@@ -1292,6 +1293,50 @@ int vsock_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
 }
 EXPORT_SYMBOL_GPL(vsock_dgram_recvmsg);
 
+static int vsock_do_ioctl(struct socket *sock, unsigned int cmd,
+			  int __user *arg)
+{
+	struct sock *sk = sock->sk;
+	struct vsock_sock *vsk;
+	int retval;
+
+	vsk = vsock_sk(sk);
+
+	switch (cmd) {
+	case SIOCOUTQ: {
+		int n_bytes;
+
+		if (vsk->transport->unsent_bytes) {
+			if (sock_type_connectible(sk->sk_type) && sk->sk_state == TCP_LISTEN) {
+				retval = -EINVAL;
+				break;
+			}
+
+			n_bytes = vsk->transport->unsent_bytes(vsk);
+			if (n_bytes < 0) {
+				retval = n_bytes;
+				break;
+			}
+
+			retval = put_user(n_bytes, arg);
+		} else {
+			retval = -EOPNOTSUPP;
+		}
+		break;
+	}
+	default:
+		retval = -ENOIOCTLCMD;
+	}
+
+	return retval;
+}
+
+static int vsock_ioctl(struct socket *sock, unsigned int cmd,
+		       unsigned long arg)
+{
+	return vsock_do_ioctl(sock, cmd, (int __user *)arg);
+}
+
 static const struct proto_ops vsock_dgram_ops = {
 	.family = PF_VSOCK,
 	.owner = THIS_MODULE,
@@ -1302,7 +1347,7 @@ static const struct proto_ops vsock_dgram_ops = {
 	.accept = sock_no_accept,
 	.getname = vsock_getname,
 	.poll = vsock_poll,
-	.ioctl = sock_no_ioctl,
+	.ioctl = vsock_ioctl,
 	.listen = sock_no_listen,
 	.shutdown = vsock_shutdown,
 	.sendmsg = vsock_dgram_sendmsg,
@@ -2286,7 +2331,7 @@ static const struct proto_ops vsock_stream_ops = {
 	.accept = vsock_accept,
 	.getname = vsock_getname,
 	.poll = vsock_poll,
-	.ioctl = sock_no_ioctl,
+	.ioctl = vsock_ioctl,
 	.listen = vsock_listen,
 	.shutdown = vsock_shutdown,
 	.setsockopt = vsock_connectible_setsockopt,
@@ -2308,7 +2353,7 @@ static const struct proto_ops vsock_seqpacket_ops = {
 	.accept = vsock_accept,
 	.getname = vsock_getname,
 	.poll = vsock_poll,
-	.ioctl = sock_no_ioctl,
+	.ioctl = vsock_ioctl,
 	.listen = vsock_listen,
 	.shutdown = vsock_shutdown,
 	.setsockopt = vsock_connectible_setsockopt,
-- 
2.34.1


