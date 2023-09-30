Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B36F7B43B8
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 23:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbjI3VKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Sep 2023 17:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbjI3VKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Sep 2023 17:10:34 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2D4E1;
        Sat, 30 Sep 2023 14:10:31 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id B916210000A;
        Sun,  1 Oct 2023 00:10:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru B916210000A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696108228;
        bh=Hv/Y3rqhhHdNcUfeko9rzLOyGTDVm7iAYVCtlg+eZZ0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=fWWoOCni5jUsjJviIc8ZiCNIoLLiK3d/akdb1FDWLZaIA3kmJqq6ftxDVg7TaD2I6
         DVpNOrknt9aRVvMoNngFhfmMOal5Gof3nDaHCsxaYy0yql4vvyv2yoefAnTQVczJkY
         MJIN9d23PuU0f+8EQSIpSdHiNhiBY4UL8w5DMURzBqBBcgw7jthbfArfMwz86zt+GW
         egChf1p/Iq7yP786dW/MEEvSnl+g/Zy26dekwbGA2gnz6nTNtaf6UCvPC9H3v4GzAR
         IRxCK3Z69nbdXFyXgnnukBDcKzeIJMYAJ9beBTWv5J5kA3Eip6rDLIe3d2mvfbEvBX
         HMjcUjPShAnAw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sun,  1 Oct 2023 00:10:28 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sun, 1 Oct 2023 00:10:27 +0300
From:   Arseniy Krasnov <avkrasnov@salutedevices.com>
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
        <avkrasnov@salutedevices.com>
Subject: [PATCH net-next v2 04/12] vsock: enable SOCK_SUPPORT_ZC bit
Date:   Sun, 1 Oct 2023 00:03:00 +0300
Message-ID: <20230930210308.2394919-5-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
References: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180254 [Sep 30 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 535 535 da804c0ea8918f802fc60e7a20ba49783d957ba2, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/30 19:49:00 #22015058
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This bit is used by io_uring in case of zerocopy tx mode. io_uring code
checks, that socket has this feature. This patch sets it in two places:
1) For socket in 'connect()' call.
2) For new socket which is returned by 'accept()' call.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index f1da06aa6b00..ff44bab05191 100644
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

