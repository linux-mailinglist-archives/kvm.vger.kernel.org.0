Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74F87AA84D
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 07:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjIVFcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 01:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjIVFbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 01:31:53 -0400
Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C41192;
        Thu, 21 Sep 2023 22:31:45 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk02 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id 374F2120005;
        Fri, 22 Sep 2023 08:31:42 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 374F2120005
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1695360702;
        bh=uU0HiYEbsNKJ6Oi4dggUk9GqK8ftuB4QtmG8yc6O7uU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=VWszeK37rEj0s4kVOt2eBpEaOL4o4HpfCBh7b5JEG/l5COgNz7ZNtwvMC9Nd/UiIr
         BOu+BMJvSGslSnORFfvyNc+PSKszJMVh2xp5tNlrpuSOAXjLqCUjE+UuPXpEkDTqkB
         jsovjfLftMh9pyHgY+hbEIKSrmNlhYWlg+ge+uvTHfcUCo8QdE7Rfo1zj6MG9BI14R
         1Gv8JiG1OZWkdWTh1kG2bK5wGKPt6f/b5bnUMsmhaGrHRkPFtz5IPvjaX2vsBKYCz5
         0fR2kdpQtD5dv/C1AXLCNQb1XSiAXObhYICGgQpGHBRoezdrcQrDV8uF/z7yxDirY7
         NpVba60wOLlpw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Fri, 22 Sep 2023 08:31:42 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 22 Sep 2023 08:31:41 +0300
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
Subject: [PATCH net-next v1 00/12] vsock/virtio: continue MSG_ZEROCOPY support
Date:   Fri, 22 Sep 2023 08:24:16 +0300
Message-ID: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [100.64.160.123]
X-ClientProxiedBy: p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 180033 [Sep 21 2023]
X-KSMG-AntiSpam-Version: 5.9.59.0
X-KSMG-AntiSpam-Envelope-From: avkrasnov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 534 534 808c2ea49f7195c68d40844e073217da4fa0d1e3, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, salutedevices.com:7.1.1;100.64.160.123:7.1.2;127.0.0.199:7.1.2;git.kernel.org:7.1.1;lore.kernel.org:7.1.1;p-i-exch-sc-m01.sberdevices.ru:5.0.1,7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2023/09/22 02:40:00
X-KSMG-LinksScanning: Clean, bases: 2023/09/22 02:40:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2023/09/22 02:22:00 #21944311
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
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=71b263e79370348349553ecdf46f4a69eb436dc7

Arseniy Krasnov (12):
  vsock: fix EPOLLERR set on non-empty error queue
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
 include/uapi/linux/vsock.h                |   9 +
 net/vmw_vsock/af_vsock.c                  |  64 ++++-
 net/vmw_vsock/virtio_transport.c          |   7 +
 net/vmw_vsock/vsock_loopback.c            |   6 +
 tools/testing/vsock/Makefile              |   9 +-
 tools/testing/vsock/util.c                | 222 +++++++++++++++
 tools/testing/vsock/util.h                |  19 ++
 tools/testing/vsock/vsock_perf.c          | 143 +++++++++-
 tools/testing/vsock/vsock_test.c          |  16 ++
 tools/testing/vsock/vsock_test_zerocopy.c | 314 +++++++++++++++++++++
 tools/testing/vsock/vsock_test_zerocopy.h |  15 +
 tools/testing/vsock/vsock_uring_test.c    | 321 ++++++++++++++++++++++
 16 files changed, 1158 insertions(+), 15 deletions(-)
 create mode 100644 include/uapi/linux/vsock.h
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.c
 create mode 100644 tools/testing/vsock/vsock_test_zerocopy.h
 create mode 100644 tools/testing/vsock/vsock_uring_test.c

-- 
2.25.1

