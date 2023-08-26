Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125D2789891
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 20:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjHZSF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Aug 2023 14:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjHZSFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Aug 2023 14:05:33 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09FE6E7D;
        Sat, 26 Aug 2023 11:05:28 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 65785100009;
        Sat, 26 Aug 2023 21:05:25 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 65785100009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1693073125;
        bh=HwyGrg3JITzWbAUvBCqkkF++pFXZA9noQ8tS9Eu6ozo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=pd4a3boV+Nw3ajRTiw4CFSSFdIPLUdOhFyX1WHqnTJQ+e5mYn511a683P4dAS3OoE
         PTHX+E2Q01tP1baFGnoHKIg5XL8tT+3bAH9v03hAvWk/Ucr9SrHWiv9hvUDLdf5oSA
         nKdVdrcTEzjVGZ+En22iBnf1m3h5NueQg88DN0F5TFETdCZhlU2xfMEUBw5a73gIgq
         1wvWmYlV07U1KGGJygI+KYMWWdnrtlC0TqRr7bS2MDHxGTQOZsfpeW5KKCzESqbJ8/
         OuNQt8EAtSonvRnFd2kz0nzn8J+Oi6bppG0L1OVjnZyP/uXiFoqnvqwwwEHNJOnBGL
         Z8TtaqC+yNTLQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat, 26 Aug 2023 21:05:25 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 26 Aug 2023 21:05:08 +0300
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
Subject: [RFC PATCH v2 1/2] vsock: send SIGPIPE on write to shutdowned socket
Date:   Sat, 26 Aug 2023 20:58:59 +0300
Message-ID: <20230826175900.3693844-2-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230826175900.3693844-1-avkrasnov@salutedevices.com>
References: <20230826175900.3693844-1-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179455 [Aug 25 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 527 527 5bb611be2ca2baa31d984ccbf4ef4415504fc308, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;salutedevices.com:7.1.1;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/08/26 15:09:00 #21728460
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

POSIX requires to send SIGPIPE on write to SOCK_STREAM socket which was
shutdowned with SHUT_WR flag or its peer was shutdowned with SHUT_RD
flag. Also we must not send SIGPIPE if MSG_NOSIGNAL flag is set.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 net/vmw_vsock/af_vsock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 020cf17ab7e4..013b65241b65 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1921,6 +1921,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 			err = total_written;
 	}
 out:
+	if (sk->sk_type == SOCK_STREAM)
+		err = sk_stream_error(sk, msg->msg_flags, err);
+
 	release_sock(sk);
 	return err;
 }
-- 
2.25.1

