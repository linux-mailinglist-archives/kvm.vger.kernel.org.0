Return-Path: <kvm+bounces-2025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3295F7F0902
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 21:57:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E20F5280E02
	for <lists+kvm@lfdr.de>; Sun, 19 Nov 2023 20:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 851D419BDC;
	Sun, 19 Nov 2023 20:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="vgwwcdmb"
X-Original-To: kvm@vger.kernel.org
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04034E0;
	Sun, 19 Nov 2023 12:57:20 -0800 (PST)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 93455120007;
	Sun, 19 Nov 2023 23:57:18 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 93455120007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1700427438;
	bh=vL+qQ9rhbaR3YIaKSe6iD2hKBiaKdxLdqmIkkNYOJUg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=vgwwcdmbfmsShWynIaCY9yTWWjJ9WDGhvgA4NxraFj7m6XA/+PWspRUCaX/IVBlHJ
	 rBDGxi9ZmW6I/QdN7mey552dfJFQA6ZD4HGtPeCQ6AyOVM8a5Gvoi4lPJhhRUxeDCk
	 VvDog1qVP24WTpFar6vJSlhrVZXC6kAwcPij64PkDGhXuykEUD4DfaYDGQTa9RIrVD
	 BjoKCRMs4kvyYwN7zSjDzYAGvRpRsIQ9Eq4jQ/wv54ThYF8PierThYAZRyjaeLUgqs
	 Zuu5VbK3UN5HUop6EnE5wWSdGQMh+VOEjQAUZoj6xUUKjCMqM3q1c6AiHt2hDbCYEa
	 dqX5BOF/DnSXg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Sun, 19 Nov 2023 23:57:18 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Sun, 19 Nov 2023 23:57:18 +0300
From: Arseniy Krasnov <avkrasnov@salutedevices.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@salutedevices.com>
Subject: [RFC PATCH v2 1/3] vsock: update SO_RCVLOWAT setting callback
Date: Sun, 19 Nov 2023 23:49:20 +0300
Message-ID: <20231119204922.2251912-2-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20231119204922.2251912-1-avkrasnov@salutedevices.com>
References: <20231119204922.2251912-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 181465 [Nov 19 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 543 543 1e3516af5cdd92079dfeb0e292c8747a62cb1ee4, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/11/19 19:33:00 #22482963
X-KSMG-AntiVirus-Status: Clean, skipped

Do not return if transport callback for SO_RCVLOWAT is set (only in
error case). In this case we don't need to set 'sk_rcvlowat' field in
each transport - only in 'vsock_set_rcvlowat()'.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 net/vmw_vsock/af_vsock.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 816725af281f..af0058037f72 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2264,8 +2264,13 @@ static int vsock_set_rcvlowat(struct sock *sk, int val)
 
 	transport = vsk->transport;
 
-	if (transport && transport->set_rcvlowat)
-		return transport->set_rcvlowat(vsk, val);
+	if (transport && transport->set_rcvlowat) {
+		int err;
+
+		err = transport->set_rcvlowat(vsk, val);
+		if (err)
+			return err;
+	}
 
 	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 	return 0;
-- 
2.25.1


