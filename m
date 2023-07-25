Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93931762044
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 19:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjGYRfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 13:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjGYRe6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 13:34:58 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447E5A6;
        Tue, 25 Jul 2023 10:34:55 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 256B012002D;
        Tue, 25 Jul 2023 20:34:53 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 256B012002D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690306493;
        bh=iIi5QtsXIh/MRda/J4c3Msv+knLn+7KAmxvCDlk4Mz0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=GAPgYb6qVKl7FjaY/alLAUUhltGzRjD7eMQnLpOTEmz7w4spM+2T9yTVVArrGSehx
         toUJ2kZ7MIaIUKDtKNnaH4/xB2ppiPQDZUbXhshhD3KmFpmmf2oN/lhLrQZQbqsIL7
         eRl1ONgGdvB84g5MehhSlc+wdpqW+q0RaZUVQOAUCnpltQLdPUP5UWHoO8nuB67VfF
         QGJnEVSltfpdaSrExQpKENq5KJMfNo1GGCDzAzkAB5evazAt1xl/kS7h60wTfOKWCJ
         g/Kh0iCM6oSgyv5Xi0CYlzUly1EJt6FM0yANLGgSkPiTXO7y2ZmgD8EhUYdMqhX6cD
         N3bdqotf9R+hQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 25 Jul 2023 20:34:52 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 25 Jul 2023 20:34:50 +0300
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
Subject: [PATCH net-next v3 0/4] virtio/vsock: some updates for MSG_PEEK flag
Date:   Tue, 25 Jul 2023 20:29:08 +0300
Message-ID: <20230725172912.1659970-1-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178796 [Jul 22 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 525 525 723604743bfbdb7e16728748c3fa45e9eba05f7d, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, sberdevices.ru:7.1.1,5.0.1;git.kernel.org:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2;lore.kernel.org:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/07/23 10:45:00
X-KSMG-LinksScanning: Clean, bases: 2023/07/23 10:46:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/23 08:49:00 #21663637
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patchset does several things around MSG_PEEK flag support. In
general words it reworks MSG_PEEK test and adds support for this flag
in SOCK_SEQPACKET logic. Here is per-patch description:

1) This is cosmetic change for SOCK_STREAM implementation of MSG_PEEK:
   1) I think there is no need of "safe" mode walk here as there is no
      "unlink" of skbs inside loop (it is MSG_PEEK mode - we don't change
      queue).
   2) Nested while loop is removed: in case of MSG_PEEK we just walk
      over skbs and copy data from each one. I guess this nested loop
      even didn't behave as loop - it always executed just for single
      iteration.

2) This adds MSG_PEEK support for SOCK_SEQPACKET. It could be implemented
   be reworking MSG_PEEK callback for SOCK_STREAM to support SOCK_SEQPACKET
   also, but I think it will be more simple and clear from potential
   bugs to implemented it as separate function thus not mixing logics
   for both types of socket. So I've added it as dedicated function.

3) This is reworked MSG_PEEK test for SOCK_STREAM. Previous version just
   sent single byte, then tried to read it with MSG_PEEK flag, then read
   it in normal way. New version is more complex: now sender uses buffer
   instead of single byte and this buffer is initialized with random
   values. Receiver tests several things:
   1) Read empty socket with MSG_PEEK flag.
   2) Read part of buffer with MSG_PEEK flag.
   3) Read whole buffer with MSG_PEEK flag, then checks that it is same
      as buffer from 2) (limited by size of buffer from 2) of course).
   4) Read whole buffer without any flags, then checks that it is same
      as buffer from 3).

4) This is MSG_PEEK test for SOCK_SEQPACKET. It works in the same way
   as for SOCK_STREAM, except it also checks combination of MSG_TRUNC
   and MSG_PEEK.

Head is:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=a5a91f546444940f3d75e2edf3c53b4d235f0557

Link to v1:
https://lore.kernel.org/netdev/20230618062451.79980-1-AVKrasnov@sberdevices.ru/
Link to v2:
https://lore.kernel.org/netdev/20230719192708.1775162-1-AVKrasnov@sberdevices.ru/

Changelog:
 v1 -> v2:
 * Patchset is rebased on the new HEAD of net-next.
 * 0001: R-b tag added.
 * 0003: check return value of 'send()' call. 
 v2 -> v3:
 * Patchset is rebased (and tested) on the new HEAD of net-next.
 * 'RFC' tag is replaced with 'net-next'.
 * Small refactoring in 0004:
   '__test_msg_peek_client()' -> 'test_msg_peek_client()'.
   '__test_msg_peek_server()' -> 'test_msg_peek_server()'.

Arseniy Krasnov (4):
  virtio/vsock: rework MSG_PEEK for SOCK_STREAM
  virtio/vsock: support MSG_PEEK for SOCK_SEQPACKET
  vsock/test: rework MSG_PEEK test for SOCK_STREAM
  vsock/test: MSG_PEEK test for SOCK_SEQPACKET

 net/vmw_vsock/virtio_transport_common.c | 104 +++++++++++++-----
 tools/testing/vsock/vsock_test.c        | 136 ++++++++++++++++++++++--
 2 files changed, 208 insertions(+), 32 deletions(-)

-- 
2.25.1

