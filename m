Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3837C0472
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 21:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344071AbjJJTXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 15:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbjJJTXB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 15:23:01 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B183115;
        Tue, 10 Oct 2023 12:22:48 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 0059E120007;
        Tue, 10 Oct 2023 22:22:46 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 0059E120007
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696965766;
        bh=dCmMfDl4psL+exObR1aC+n6gPquIX9oUuSgVLiUppTg=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=L3knppTIP3IWCqaHdES5a5H9Zmh0f0sz61wDX3DfOctvnC5gVYoUQcUkUTnUSjbDZ
         +425iB5PGpvc2F3WR6FkDxl8p7rjbn6onYs2yttK7lOXZYxEGpwx6p7A3/f+pY3dnF
         T/P303xrE3PlVwbXXy7zVbukWuKmnO5Sw0LG/NjTrChuEyIn8D4+zDk/uOfxLRR+Ms
         bfR6VCJCcW4fqnrAgHWDZMRvrfQNsAHWSdx8AzNzdlOLBNn5S/xzSgPetJ3S3nXTFd
         4Gm+yVN8ru1ptOX6p9hVajBpEsr2faGkwJ2kQgH76j2QYKARAqxLMAM0EA9thgJs6G
         BdMt9slTCLoKw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 10 Oct 2023 22:22:45 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 10 Oct 2023 22:22:45 +0300
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
Subject: [PATCH net-next v4 04/12] vsock: enable SOCK_SUPPORT_ZC bit
Date:   Tue, 10 Oct 2023 22:15:16 +0300
Message-ID: <20231010191524.1694217-5-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
References: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180515 [Oct 10 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 536 536 1ae19c7800f69da91432b5e67ed4a00b9ade0d03, {Tracking_from_domain_doesnt_match_to}, 100.64.160.123:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/10/10 16:15:00 #22148151
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
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

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 71108b1f0dfc..37b1c0432941 100644
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

