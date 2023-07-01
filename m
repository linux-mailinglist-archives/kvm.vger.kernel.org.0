Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A75744757
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 08:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjGAGxf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 02:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjGAGwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 02:52:24 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373EB4692;
        Fri, 30 Jun 2023 23:46:03 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 3086012000C;
        Sat,  1 Jul 2023 09:45:09 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 3086012000C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1688193909;
        bh=2BWXHhctpAkbTJhGKfSJxyOEOoSV2p85OEMm5gTeQ6k=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=X2wY3A5iThazFE48+eFTNfpb+X9+4m4DS4zCBsWgD8fjKt3nfc9eoMzWc2RpPJV5T
         K7DyySEaWpNqtnPB8OF6CgXIGlxdNM5Wic0MS0/eKLhdLnji4GXfIWemK9n/OICbaS
         ck8PjZiZqFfVN8QJQ3SbUoc8/fNTuPnJzb0goaAzUSh/Na/8bquBcMZ6d52ZqfQajI
         0NKxXFZjdRfFhLM4i9WFlF0MlGPFhwsB9xIaxmz/NsHllQ5BQn7M971iFNzwdkF2Dq
         ZWBzbzxTaWb0XvNbg6dbJxKJbcR9HgNUebHh/zmscNQ6qcxPa/Akkob7OJ/bphp1sg
         RfCEwOBPhPJ7Q==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat,  1 Jul 2023 09:45:08 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 1 Jul 2023 09:44:46 +0300
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
Subject: [RFC PATCH v5 06/17] vsock: fix EPOLLERR set on non-empty error queue
Date:   Sat, 1 Jul 2023 09:39:36 +0300
Message-ID: <20230701063947.3422088-7-AVKrasnov@sberdevices.ru>
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

If socket's error queue is not empty, EPOLLERR must be set. Otherwise,
reader of error queue won't detect data in it using EPOLLERR bit.
Currently for AF_VSOCK this is reproducible only with MSG_ZEROCOPY, as
this feature is the only user of an error queue of the socket.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 Changelog:
 v4 -> v5:
  * Change commit message as Fix patch. Also add details that this
    problem could be reproduced only with MSG_ZEROCOPY transmission
    mode.

 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index efb8a0937a13..45fd20c4ed50 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1030,7 +1030,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 	poll_wait(file, sk_sleep(sk), wait);
 	mask = 0;
 
-	if (sk->sk_err)
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		/* Signify that there has been an error on this socket. */
 		mask |= EPOLLERR;
 
-- 
2.25.1

