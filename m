Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEC77A309C
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 15:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239265AbjIPNQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Sep 2023 09:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239228AbjIPNQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Sep 2023 09:16:26 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7951B5;
        Sat, 16 Sep 2023 06:16:18 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 373CC12000B;
        Sat, 16 Sep 2023 16:16:15 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 373CC12000B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1694870175;
        bh=Sdq3fDXjPa3CrACJWQvLhfRSTOnnHZbbxxjFtBJgqQs=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=Vm/xWXLAS7Izu+GKWS6lCqc/Q5DENeLzjgy1E6f617THBTzB7K6Kckv0Sn8hdhBni
         hPr9BH3MFYzaQpV/p/jLC+ObDlCSXisDyfT7KarF4mUbHbcjTRbCgKLryWjBSKGk/q
         oORn/R1YxDIk8FHoOgqHGfs4szkM892Cmz5F3f705KwhVzIfTp/booGMtbGIjXPpxk
         0bhH+XNFEL2qxrB6whnLNJ1QIVqtT11AhAEpciafJj8EewhnHWCmwkoWTzXeVyRCNE
         9ZIdI/61/lQ/DGQZhZM6l/7ppVzXayHB+aVfw0zQ2bs+X0ugmBPuiw1Hdcu2f1uLps
         wflhxIVpTO7Zg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat, 16 Sep 2023 16:16:14 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 16 Sep 2023 16:16:14 +0300
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
Subject: [PATCH net-next v9 0/4] vsock/virtio/vhost: MSG_ZEROCOPY preparations
Date:   Sat, 16 Sep 2023 16:09:14 +0300
Message-ID: <20230916130918.4105122-1-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m02.sberdevices.ru (172.16.192.103) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 179905 [Sep 16 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 530 530 ecb1547b3f72d1df4c71c0b60e67ba6b4aea5432, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;git.kernel.org:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;127.0.0.199:7.1.2;lore.kernel.org:7.1.1;100.64.160.123:7.1.2;salutedevices.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/09/16 12:20:00
X-KSMG-LinksScanning: Clean, bases: 2023/09/16 12:20:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/16 12:14:00 #21905676
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

Head for this patchset is:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=f2fa1c812c91e99d0317d1fc7d845e1e05f39716

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
Link to v6:
https://lore.kernel.org/netdev/20230814212720.3679058-1-AVKrasnov@sberdevices.ru/
Link to v7:
https://lore.kernel.org/netdev/20230827085436.941183-1-avkrasnov@salutedevices.com/
Link to v8:
https://lore.kernel.org/netdev/20230911202234.1932024-1-avkrasnov@salutedevices.com/

Changelog:
 v3 -> v4:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 v4 -> v5:
 * See per-patch changelog after ---.
 v5 -> v6:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---.
 v6 -> v7:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---.
 v7 -> v8:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---.
 v8 -> v9:
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---.

Arseniy Krasnov (4):
  vsock/virtio/vhost: read data from non-linear skb
  vsock/virtio: support to send non-linear skb
  vsock/virtio: non-linear skb handling for tap
  vsock/virtio: MSG_ZEROCOPY flag support

 drivers/vhost/vsock.c                         |  14 +-
 include/linux/virtio_vsock.h                  |  10 +
 .../events/vsock_virtio_transport_common.h    |  12 +-
 net/vmw_vsock/virtio_transport.c              |  92 +++++-
 net/vmw_vsock/virtio_transport_common.c       | 307 ++++++++++++++----
 5 files changed, 348 insertions(+), 87 deletions(-)

-- 
2.25.1

