Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB07C756EBA
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 23:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjGQVGa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jul 2023 17:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjGQVG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jul 2023 17:06:29 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF2A121;
        Mon, 17 Jul 2023 14:06:27 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 6C4AF120015;
        Tue, 18 Jul 2023 00:06:24 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 6C4AF120015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1689627984;
        bh=SPhiYzsyGgLosRewaIPtYGjZ9h2WMstC54d53RRdjwY=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=VND8XKzReXJ1F/ju58tM4VY3+5JDMnRDtq0Wl4+OcMzekpP+du4/iG4urDMeH63Sm
         ZLwWmTF5Kx4fglbrAl3KyTmbE37jwIrRmw0u3OAaYm4jTKH66kiJSOtu0VrTq5e4U9
         SKLrw4HnAcnYoILbPD6/a7cPebZKtEtt1nDEQ4sJBX4KF0dqG4aPi1XwBmicQT8s0v
         UKo9g41I1wciRLYQKonjwlE5vPTmNoh2IXLZIV+4DfuegxQf/pAP9VpZE/PJ8civRs
         cv7lVQiFB9B3ZSRIN29b/XV/xDmDkHy5OS2wYuf+9jWvloEUJWe31qDoaOjz4bCjJL
         ltXinF3MZV+GQ==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 18 Jul 2023 00:06:24 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 18 Jul 2023 00:06:23 +0300
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
Subject: [PATCH net-next v1 0/4] vsock/virtio/vhost: MSG_ZEROCOPY preparations
Date:   Tue, 18 Jul 2023 00:00:47 +0300
Message-ID: <20230717210051.856388-1-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 178666 [Jul 17 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 523 523 523027ce26ed1d9067f7a52a4756a876e54db27c, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;100.64.160.123:7.1.2;sberdevices.ru:5.0.1,7.1.1, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/07/17 19:46:00
X-KSMG-LinksScanning: Clean, bases: 2023/07/17 19:46:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/17 13:15:00 #21627216
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

this patchset is first of three parts of another big patchset for
MSG_ZEROCOPY flag support:
https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/

During review of this series, Stefano Garzarella <sgarzare@redhat.com>
suggested to split it for three parts to simplify review and merging:

1) virtio and vhost updates (for fragged skbs) <--- this patchset
2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
   tx completions) and update for Documentation/.
3) Updates for tests and utils.

This series enables handling of fragged skbs in virtio and vhost parts.
Newly logic won't be triggered, because SO_ZEROCOPY options is still
impossible to enable at this moment (next bunch of patches from big
set above will enable it).

I've included changelog to some patches anyway, because there were some
comments during review of last big patchset from the link above.

Head for this patchset is 60cc1f7d0605598b47ee3c0c2b4b6fbd4da50a06

Arseniy Krasnov (4):
  vsock/virtio/vhost: read data from non-linear skb
  vsock/virtio: support to send non-linear skb
  vsock/virtio: non-linear skb handling for tap
  vsock/virtio: MSG_ZEROCOPY flag support

 drivers/vhost/vsock.c                   |  14 +-
 include/linux/virtio_vsock.h            |   1 +
 net/vmw_vsock/virtio_transport.c        |  40 ++-
 net/vmw_vsock/virtio_transport_common.c | 310 ++++++++++++++++++------
 4 files changed, 283 insertions(+), 82 deletions(-)

-- 
2.25.1

