Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F21E7BC959
	for <lists+kvm@lfdr.de>; Sat,  7 Oct 2023 19:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344183AbjJGR3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Oct 2023 13:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344080AbjJGR2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Oct 2023 13:28:52 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F1783;
        Sat,  7 Oct 2023 10:28:49 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id C0D28100005;
        Sat,  7 Oct 2023 20:28:45 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru C0D28100005
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1696699725;
        bh=KFEkqOqupYYt+5NP2KNyZqpHQQiyvOKt0Dx7aRXPaMo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=TzVotlkmy+d4Xqi6SJk8Dl5lsZs6q6oKMejTxbDTFT8duv7nFL1SdZ9vfjkADBq0z
         QOEWp3pUJ3hfGTdoK2L00j4kxfY8A+8H0JLwZW0op4BncGh1JxvklGyYTyA0FBwL7b
         YaHYDkyn7dcnTMldOTdAQWntRyvNjnS+3PxN9W18GEY9Uj0EfBLOtjqqKPfMdOMJ+T
         Hqs8VrClr/tx+y4xop1CrhSIjDrR5vn7Zw3D8aOrzufTonklco/I0Lici3Ktj1f0Vn
         fllvitVNVbTsl9RLCekGt2kS80CjNypPrKiZb584RFwZRqnFSLjHAPXjJSjR3byQ+O
         uEUVED65wBw7Q==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Sat,  7 Oct 2023 20:28:45 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Sat, 7 Oct 2023 20:28:45 +0300
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
Subject: [PATCH net-next v3 00/12] vsock/virtio: continue MSG_ZEROCOPY support
Date:   Sat, 7 Oct 2023 20:21:27 +0300
Message-ID: <20231007172139.1338644-1-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180453 [Oct 07 2023]
X-KSMG-AntiSpam-Version: 6.0.0.2
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 535 535 da804c0ea8918f802fc60e7a20ba49783d957ba2, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, lore.kernel.org:7.1.1;salutedevices.com:7.1.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;git.kernel.org:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/10/07 16:25:00
X-KSMG-LinksScanning: Clean, bases: 2023/10/07 16:25:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/10/07 16:48:00 #22085983
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
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=91e43ca0090b5fd59302c3d150835299785f30ea

Link to v1:
https://lore.kernel.org/netdev/20230922052428.4005676-1-avkrasnov@salutedevices.com/
Link to v2:
https://lore.kernel.org/netdev/20230930210308.2394919-1-avkrasnov@salutedevices.com/

Changelog:                                                              
 v1 -> v2:                                                              
 * Patchset rebased and tested on new HEAD of net-next (see hash above).
 * See per-patch changelog after ---. 
 v2 -> v3:                                                              
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
 include/uapi/linux/vm_sockets.h           |  12 +
 net/vmw_vsock/af_vsock.c                  |  63 +++-
 net/vmw_vsock/virtio_transport.c          |   7 +
 net/vmw_vsock/vsock_loopback.c            |   6 +
 tools/testing/vsock/.gitignore            |   1 +
 tools/testing/vsock/Makefile              |   9 +-
 tools/testing/vsock/msg_zerocopy_common.h |  92 ++++++
 tools/testing/vsock/util.c                | 110 +++++++
 tools/testing/vsock/util.h                |   5 +
 tools/testing/vsock/vsock_perf.c          |  80 ++++-
 tools/testing/vsock/vsock_test.c          |  16 +
 tools/testing/vsock/vsock_test_zerocopy.c | 367 ++++++++++++++++++++++
 tools/testing/vsock/vsock_test_zerocopy.h |  15 +
 tools/testing/vsock/vsock_uring_test.c    | 350 +++++++++++++++++++++
 18 files changed, 1145 insertions(+), 16 deletions(-)
 create mode 100644 tools/testing/vsock/msg_zerocopy_common.h
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.c
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.h
 create mode 100644 tools/testing/vsock/vsock_uring_test.c

-- 
2.25.1

