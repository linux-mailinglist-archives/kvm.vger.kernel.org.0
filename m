Return-Path: <kvm+bounces-3771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C080807A55
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 22:27:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3754C2824E7
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 21:27:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D762256389;
	Wed,  6 Dec 2023 21:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="Cuzk563T"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3798DF7;
	Wed,  6 Dec 2023 13:27:12 -0800 (PST)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 0ACFD120037;
	Thu,  7 Dec 2023 00:27:10 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 0ACFD120037
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1701898030;
	bh=t/kjl2Vjg1LdCA2ZU1r92JWEZ4RRp+5azAC7FUXgjBk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=Cuzk563TF7WxIIc4ol+sKU/bjzg6wXZS9/h7FAy4laFmOySQmoUXjOLwZjfdgUWDH
	 JJe5lJ3/rSPMv4+vhIgWV4M+yuDTBAKCIb1452QiPfvjWxfqQT3nd4ajcJfpFZwa/v
	 JusSd1atwfGNnb+gOd9vMzk8znAPO08NGaqQe6FzW+J36X0jK4GiQlE266Ae1hemk9
	 gNHBTQ0ySJEgyPCNRuQpyv0F4Hk+nvGYObDrsxAd9lnUjxdyr9dO94w9t5BO44S8Wg
	 h7bWQ6ANN4m6BGO3ALRnE0etomgqgicZ2at+MjhHfqlmUOfuXEiXm3qAtI8WbhVK5Q
	 QnCP3pEsjXWgQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Thu,  7 Dec 2023 00:27:09 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Thu, 7 Dec 2023 00:27:09 +0300
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@salutedevices.com>
Subject: [PATCH net-next v7 1/4] vsock: update SO_RCVLOWAT setting callback
Date: Thu, 7 Dec 2023 00:18:46 +0300
Message-ID: <20231206211849.2707151-2-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20231206211849.2707151-1-avkrasnov@salutedevices.com>
References: <20231206211849.2707151-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181917 [Dec 06 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 5 0.3.5 98d108ddd984cca1d7e65e595eac546a62b0144b, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/12/06 19:07:00 #22622451
X-KSMG-AntiVirus-Status: Clean, skipped

Do not return if transport callback for SO_RCVLOWAT is set (only in
error case). In this case we don't need to set 'sk_rcvlowat' field in
each transport - only in 'vsock_set_rcvlowat()'. Also, if 'sk_rcvlowat'
is now set only in af_vsock.c, change callback name from 'set_rcvlowat'
to 'notify_set_rcvlowat'.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 Changelog:
 v3 -> v4:
  * Rename 'set_rcvlowat' to 'notify_set_rcvlowat'.
  * Commit message updated.

 include/net/af_vsock.h           | 2 +-
 net/vmw_vsock/af_vsock.c         | 9 +++++++--
 net/vmw_vsock/hyperv_transport.c | 4 ++--
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index e302c0e804d0..535701efc1e5 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -137,7 +137,6 @@ struct vsock_transport {
 	u64 (*stream_rcvhiwat)(struct vsock_sock *);
 	bool (*stream_is_active)(struct vsock_sock *);
 	bool (*stream_allow)(u32 cid, u32 port);
-	int (*set_rcvlowat)(struct vsock_sock *vsk, int val);
 
 	/* SEQ_PACKET. */
 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
@@ -168,6 +167,7 @@ struct vsock_transport {
 		struct vsock_transport_send_notify_data *);
 	/* sk_lock held by the caller */
 	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
+	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
 
 	/* Shutdown. */
 	int (*shutdown)(struct vsock_sock *, int);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 816725af281f..54ba7316f808 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2264,8 +2264,13 @@ static int vsock_set_rcvlowat(struct sock *sk, int val)
 
 	transport = vsk->transport;
 
-	if (transport && transport->set_rcvlowat)
-		return transport->set_rcvlowat(vsk, val);
+	if (transport && transport->notify_set_rcvlowat) {
+		int err;
+
+		err = transport->notify_set_rcvlowat(vsk, val);
+		if (err)
+			return err;
+	}
 
 	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 	return 0;
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 7cb1a9d2cdb4..e2157e387217 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -816,7 +816,7 @@ int hvs_notify_send_post_enqueue(struct vsock_sock *vsk, ssize_t written,
 }
 
 static
-int hvs_set_rcvlowat(struct vsock_sock *vsk, int val)
+int hvs_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
 {
 	return -EOPNOTSUPP;
 }
@@ -856,7 +856,7 @@ static struct vsock_transport hvs_transport = {
 	.notify_send_pre_enqueue  = hvs_notify_send_pre_enqueue,
 	.notify_send_post_enqueue = hvs_notify_send_post_enqueue,
 
-	.set_rcvlowat             = hvs_set_rcvlowat
+	.notify_set_rcvlowat      = hvs_notify_set_rcvlowat
 };
 
 static bool hvs_check_transport(struct vsock_sock *vsk)
-- 
2.25.1


