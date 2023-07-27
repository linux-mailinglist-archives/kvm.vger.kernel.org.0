Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF40765F89
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 00:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbjG0WcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 18:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbjG0WcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 18:32:17 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EA42D63;
        Thu, 27 Jul 2023 15:32:13 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 14B04120004;
        Fri, 28 Jul 2023 01:32:11 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 14B04120004
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1690497131;
        bh=IsmKJ/jqcuZa5LQ1yHb+N0LqenyHgFebC0piM5XZJFg=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=Uvh2Ljr2mHc0NV3egjwZbzYEfZAg7+leKTU2cwdMmxgr62H6hbjyX6xGK1LCgxdLl
         C9QFR/DIgm+UQpJrcVavbtawsIEbFL7Ax2rBZSk9YhfxFJbxxVxWYBt8lHpANyH1yy
         408JPrrBXhAZ+LLIxQwL8uPgxMqPKAXqpDz+QRtcslJ08TYMMtOIxsZyFyKNgwbNOk
         2t5RNDFIWXFujqw5CAHxpZ8Mw4cOcy7QCOhBWS142ajlOPNFGYvikDADZD/b4nMn4l
         YSINVJ5lKMNYAsUbCQaLmWBsTHoMOpQna2Pg7UzWscQW22Aw+ij8cR9T3c06WbJUob
         xXuSLYjO/uBJw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Fri, 28 Jul 2023 01:32:10 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 28 Jul 2023 01:31:50 +0300
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
Subject: [PATCH net-next v4 0/4] vsock/virtio/vhost: MSG_ZEROCOPY preparations
Date:   Fri, 28 Jul 2023 01:26:23 +0300
Message-ID: <20230727222627.1895355-1-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
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
X-KSMG-AntiSpam-Info: LuaCore: 525 525 723604743bfbdb7e16728748c3fa45e9eba05f7d, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/07/23 10:45:00
X-KSMG-LinksScanning: Clean, bases: 2023/07/23 10:46:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/07/23 08:49:00 #21663637
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

Head for this patchset is 9d0cd5d25f7d45bce01bbb3193b54ac24b3a60f3

Link to v1:
https://lore.kernel.org/netdev/20230717210051.856388-1-AVKrasnov@sberdevices.ru/
Link to v2:
https://lore.kernel.org/netdev/20230718180237.3248179-1-AVKrasnov@sberdevices.ru/
Link to v3:
https://lore.kernel.org/netdev/20230720214245.457298-1-AVKrasnov@sberdevices.ru/

Changelog:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---.

Arseniy Krasnov (4):
  vsock/virtio/vhost: read data from non-linear skb
  vsock/virtio: support to send non-linear skb
  vsock/virtio: non-linear skb handling for tap
  vsock/virtio: MSG_ZEROCOPY flag support

 drivers/vhost/vsock.c                   |  14 +-
 include/linux/virtio_vsock.h            |   6 +
 net/vmw_vsock/virtio_transport.c        |  79 +++++-
 net/vmw_vsock/virtio_transport_common.c | 312 ++++++++++++++++++------
 4 files changed, 330 insertions(+), 81 deletions(-)

-- 
2.25.1

