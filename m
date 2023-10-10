Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2407C0469
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 21:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343968AbjJJTXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 15:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbjJJTXA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 15:23:00 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C42110F;
        Tue, 10 Oct 2023 12:22:48 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 0CF3E100003;
        Tue, 10 Oct 2023 22:22:45 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 0CF3E100003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696965765;
        bh=mBrx4hoWrq6pagTjURDmdZ0qT16EHgb0CnURzu9pdq4=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=IMrdgXLKeTqjxasTJrsPCBD8VnjxXd4L+yyknvgnvCbyBFayBobrxMtoeawtNVfbZ
         XXXAqEzIOAdyUZkxMOh7VtBoeHlR8EP0JbaZ6B3PeoRbexAVKNQiVO8Gd5wg5NEWfa
         FDqk6yGvq/6bY7Scu1fNbhMAIFPMgC9aPxKRZdbIDFuN0Z82+mOlJfEilgMJvBj0jm
         GULbe3454/Jd+olsPSAN9joJC75oBgPu/EjgPnGAx5/GRzGAzTzt9uiOgyaP1VWamq
         rG6RJ6RnVBSUrXfQhDPi88yUiA/dNyioIdRJTKMyz88MaSC4B8XVzdkCXQMhH2ZXTh
         NSgXt+kiuaAPw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Tue, 10 Oct 2023 22:22:44 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Tue, 10 Oct 2023 22:22:43 +0300
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
Subject: [PATCH net-next v4 00/12] vsock/virtio: continue MSG_ZEROCOPY support
Date:   Tue, 10 Oct 2023 22:15:12 +0300
Message-ID: <20231010191524.1694217-1-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
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
X-KSMG-AntiSpam-Info: LuaCore: 536 536 1ae19c7800f69da91432b5e67ed4a00b9ade0d03, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, lore.kernel.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2;git.kernel.org:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/10/10 18:36:00
X-KSMG-LinksScanning: Clean, bases: 2023/10/10 18:36:00
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

Hello,

this patchset contains second and third parts of another big patchset
for MSG_ZEROCOPY flag support:
https://lore.kernel.org/netdev/20230701063947.3422088-1-AVKrasnov@sberdevices.ru/

During review of this series, Stefano Garzarella <sgarzare@redhat.com>
suggested to split it for three parts to simplify review and merging:

1) virtio and vhost updates (for fragged skbs) (merged to net-next, see
   link below)
2) AF_VSOCK updates (allows to enable MSG_ZEROCOPY mode and read
   tx completions) and update for Documentation/. <-- this patchset
3) Updates for tests and utils. <-- this patchset

Part 1) was merged:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=71b263e79370348349553ecdf46f4a69eb436dc7

Head for this patchset is:
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=19537e125cc7cf2da43a606f5bcebbe0c9aea4cc

Link to v1:
https://lore.kernel.org/netdev/20230922052428.4005676-1-avkrasnov@salutedevices.com/
Link to v2:
https://lore.kernel.org/netdev/20230930210308.2394919-1-avkrasnov@salutedevices.com/
Link to v3:
https://lore.kernel.org/netdev/20231007172139.1338644-1-avkrasnov@salutedevices.com/

Changelog:                                                              
 v1 -> v2:                                                              
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---. 
 v2 -> v3:                                                              
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---. 
 v3 -> v4:                                                              
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---. 

Arseniy Krasnov (12):
  vsock: set EPOLLERR on non-empty error queue
  vsock: read from socket's error queue
  vsock: check for MSG_ZEROCOPY support on send
  vsock: enable SOCK_SUPPORT_ZC bit
  vhost/vsock: support MSG_ZEROCOPY for transport
  vsock/virtio: support MSG_ZEROCOPY for transport
  vsock/loopback: support MSG_ZEROCOPY for transport
  vsock: enable setting SO_ZEROCOPY
  docs: net: description of MSG_ZEROCOPY for AF_VSOCK
  test/vsock: MSG_ZEROCOPY flag tests
  test/vsock: MSG_ZEROCOPY support for vsock_perf
  test/vsock: io_uring rx/tx tests

 Documentation/networking/msg_zerocopy.rst |  13 +-
 drivers/vhost/vsock.c                     |   7 +
 include/linux/socket.h                    |   1 +
 include/net/af_vsock.h                    |   7 +
 include/uapi/linux/vm_sockets.h           |  17 +
 net/vmw_vsock/af_vsock.c                  |  63 +++-
 net/vmw_vsock/virtio_transport.c          |   7 +
 net/vmw_vsock/vsock_loopback.c            |   6 +
 tools/testing/vsock/.gitignore            |   1 +
 tools/testing/vsock/Makefile              |  11 +-
 tools/testing/vsock/msg_zerocopy_common.c |  87 ++++++
 tools/testing/vsock/msg_zerocopy_common.h |  18 ++
 tools/testing/vsock/util.c                | 133 ++++++++
 tools/testing/vsock/util.h                |   5 +
 tools/testing/vsock/vsock_perf.c          |  80 ++++-
 tools/testing/vsock/vsock_test.c          |  16 +
 tools/testing/vsock/vsock_test_zerocopy.c | 358 ++++++++++++++++++++++
 tools/testing/vsock/vsock_test_zerocopy.h |  15 +
 tools/testing/vsock/vsock_uring_test.c    | 342 +++++++++++++++++++++
 19 files changed, 1170 insertions(+), 17 deletions(-)
 create mode 100644 tools/testing/vsock/msg_zerocopy_common.c
 create mode 100644 tools/testing/vsock/msg_zerocopy_common.h
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.c
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.h
 create mode 100644 tools/testing/vsock/vsock_uring_test.c

-- 
2.25.1

