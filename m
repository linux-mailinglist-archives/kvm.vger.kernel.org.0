Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2227212E2
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 22:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbjFCUzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 16:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjFCUzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 16:55:06 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736911B5;
        Sat,  3 Jun 2023 13:54:57 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 745FE5FD3D;
        Sat,  3 Jun 2023 23:54:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1685825689;
        bh=Lcii1bQY+QJwpWB+RMSKu82Ek54JP6VHZpwuHhErzzg=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=Jg52u5GEQEg5YduLkopjTNW3BjaxbL328jtMgCcJGiSHEe1c5falJz5UAYOmb8btl
         7f+eJRuv3Sl6eX4w42HLrim/lrm6Jmi0hABMEJK1ZpKpIVg/qPJCqgcdAmvq725dJ5
         7lNxZpdDEl9jm+a2IhMiHWQjyjDQeFfoRpRS/lzABhlrc4QyEEjLuYQ5jxIfWlN2vv
         YrxGR+OA1+/8rmM2/Zd9ESP90sE4ScNs4TcpAkZzXGHwTA5TI6EeX5B9PWsp0w9Etf
         1huTfS4oouFZtvh/6LZeIZP/GfZIc+FGrSPJ3X6ACxZKCNqpFeX6KhEzv9q8K/ie1v
         nSE+Wie9B5LZg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat,  3 Jun 2023 23:54:49 +0300 (MSK)
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
Subject: [RFC PATCH v4 13/17] net/sock: enable setting SO_ZEROCOPY for PF_VSOCK
Date:   Sat, 3 Jun 2023 23:49:35 +0300
Message-ID: <20230603204939.1598818-14-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/03 16:55:00 #21417531
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

PF_VSOCK supports MSG_ZEROCOPY transmission, so SO_ZEROCOPY could
be enabled. PF_VSOCK implementation is a little bit special comparing to
PF_INET - MSG_ZEROCOPY support depends on transport layer of PF_VSOCK,
but here we can't "ask" its transport, so setting of this option is
always allowed, but if some transport doesn't support zerocopy tx, send
callback of PF_VSOCK will return -EOPNOTSUPP.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/core/sock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 5440e67bcfe3..d558e541e6d7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1452,9 +1452,11 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 			      (sk->sk_type == SOCK_DGRAM &&
 			       sk->sk_protocol == IPPROTO_UDP)))
 				ret = -EOPNOTSUPP;
-		} else if (sk->sk_family != PF_RDS) {
+		} else if (sk->sk_family != PF_RDS &&
+			   sk->sk_family != PF_VSOCK) {
 			ret = -EOPNOTSUPP;
 		}
+
 		if (!ret) {
 			if (val < 0 || val > 1)
 				ret = -EINVAL;
-- 
2.25.1

