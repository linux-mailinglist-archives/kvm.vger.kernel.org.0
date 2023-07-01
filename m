Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FB4744763
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 08:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjGAGxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 02:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjGAGwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 02:52:34 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5472A59CC;
        Fri, 30 Jun 2023 23:46:05 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id B3984120010;
        Sat,  1 Jul 2023 09:45:12 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru B3984120010
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1688193912;
        bh=HekjpGnl2zxNT3T4PtMzqPreuhYkvcvhGbre4mbN788=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=P8//UujOtdWFGpzjoEC1wMZuHuwwxHRvFA8XztcwFTX5a1HBVQXP1dFUJfwsix7gE
         dXur1AeWsqqf0O239xyowfXqRnklnJgEBQZfPfBIjuZxyD/9xedX3AbVEzE24GPRzd
         MaHeSWhelLkq1bBntaUKigMyuz18kr/hPOLbRoAeqb4fIfAnh6yspMAuzwubSrkMC6
         WZ6/A1X6BQPuUqaRSyCZ3YLqfsa0uf2a5QYnEEVvV0LyUFT0TYvbrpwW3PFfbPNr41
         Bv8XDSGDM7t9IE/RxPvLqyDOPJTEaPhmtrbDxxfalkezw2mE1A8gTXayAKZF04QNax
         hjzRQDgJobZlA==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat,  1 Jul 2023 09:45:11 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 1 Jul 2023 09:44:48 +0300
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v5 09/17] vsock: enable SOCK_SUPPORT_ZC bit
Date:   Sat, 1 Jul 2023 09:39:39 +0300
Message-ID: <20230701063947.3422088-10-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178380 [Jun 30 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 517 517 b0056c19d8e10afbb16cb7aad7258dedb0179a79, {Tracking_from_domain_doesnt_match_to}, sberdevices.ru:7.1.1,5.0.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;100.64.160.123:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/01 04:02:00 #21597763
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This bit is used by io_uring in case of zerocopy tx mode. io_uring code
checks, that socket has this feature. This patch sets it in two places:
1) For socket in 'connect()' call.
2) For new socket which is returned by 'accept()' call.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/af_vsock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 033006e1b5ad..da22ae0ef477 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1406,6 +1406,9 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
 			goto out;
 		}
 
+		if (vsock_msgzerocopy_allow(transport))
+			set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
+
 		err = vsock_auto_bind(vsk);
 		if (err)
 			goto out;
@@ -1560,6 +1563,9 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 		} else {
 			newsock->state = SS_CONNECTED;
 			sock_graft(connected, newsock);
+			if (vsock_msgzerocopy_allow(vconnected->transport))
+				set_bit(SOCK_SUPPORT_ZC,
+					&connected->sk_socket->flags);
 		}
 
 		release_sock(connected);
-- 
2.25.1

