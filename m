Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46F277C279
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 23:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbjHNVeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 17:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjHNVdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 17:33:37 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08F5E77;
        Mon, 14 Aug 2023 14:33:30 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 0CE77100004;
        Tue, 15 Aug 2023 00:33:28 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 0CE77100004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1692048808;
        bh=QrGuO/KW8Lv2v6J6gyzhGxNvKGG3DxYkGcLcDgDZ7zg=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=AfbazDbZqhzQrlCE2p7PS8a7RtCwHQp+E+vyYrgFHAgGEotlnxLH1HWik3gZmwbHA
         zCt8zN+ovvToeCj4UOdMXHHetn3m1sk6T5p/AKg0/dj0PZIpmFS/iWyNCUVbYLnwoR
         1TiZh+iWY9ar29n4HNwdhRqMRlLGZjKuB/iaFew5moBINKst1l4OH+fz8nLoP9QS8U
         yr+/Bsh/d5yW0m+ldxJHT2A0fNP7wh/oS19L5Bzgh4GfB+BV84Chwq+TO0DfxhimOL
         jkeMbTb7Q/dymkUx2D08erpRo9SDuDetNR2iRlJ0V6G7S/KkYsuhafjJ4Vu3PUtqke
         0IP5hdY77p9pw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 15 Aug 2023 00:33:27 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 15 Aug 2023 00:33:24 +0300
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
Subject: [PATCH net-next v6 0/4] vsock/virtio/vhost: MSG_ZEROCOPY preparations
Date:   Tue, 15 Aug 2023 00:27:16 +0300
Message-ID: <20230814212720.3679058-1-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179236 [Aug 14 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: AVKrasnov@sberdevices.ru
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 526 526 7a6a9b19f6b9b3921b5701490f189af0e0cd5310, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;127.0.0.199:7.1.2;sberdevices.ru:5.0.1,7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;100.64.160.123:7.1.2, FromAlignment: s, {Tracking_white_helo}, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/08/14 18:25:00
X-KSMG-LinksScanning: Clean, bases: 2023/08/14 18:25:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/08/14 17:33:00 #21612035
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Head for this patchset is 83b5f0253b1ef352f4333c4fb2d24eff23045f6b

Link to v1:
https://lore.kernel.org/netdev/20230717210051.856388-1-AVKrasnov@sberdevices.ru/
Link to v2:
https://lore.kernel.org/netdev/20230718180237.3248179-1-AVKrasnov@sberdevices.ru/
Link to v3:
https://lore.kernel.org/netdev/20230720214245.457298-1-AVKrasnov@sberdevices.ru/
Link to v4:
https://lore.kernel.org/netdev/20230727222627.1895355-1-AVKrasnov@sberdevices.ru/
Link to v5:
https://lore.kernel.org/netdev/20230730085905.3420811-1-AVKrasnov@sberdevices.ru/

Changelog:
 v3 -> v4:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 v4 -> v5:
 * See per-patch changelog after ---.
 v5 -> v6:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---.

Arseniy Krasnov (4):
  vsock/virtio/vhost: read data from non-linear skb
  vsock/virtio: support to send non-linear skb
  vsock/virtio: non-linear skb handling for tap
  vsock/virtio: MSG_ZEROCOPY flag support

 drivers/vhost/vsock.c                   |  14 +-
 include/linux/virtio_vsock.h            |   6 +
 net/vmw_vsock/virtio_transport.c        |  74 +++++-
 net/vmw_vsock/virtio_transport_common.c | 303 ++++++++++++++++++------
 4 files changed, 318 insertions(+), 79 deletions(-)

-- 
2.25.1

