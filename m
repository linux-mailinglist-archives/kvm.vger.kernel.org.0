Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF41F7AA856
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 07:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjIVFcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 01:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjIVFbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 01:31:53 -0400
Received: from mx1.sberdevices.ru (mx1.sberdevices.ru [37.18.73.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DB619D;
        Thu, 21 Sep 2023 22:31:46 -0700 (PDT)
Received: from p-infra-ksmg-sc-msk01 (localhost [127.0.0.1])
        by mx1.sberdevices.ru (Postfix) with ESMTP id D53E010000C;
        Fri, 22 Sep 2023 08:31:44 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru D53E010000C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
        s=mail; t=1695360704;
        bh=Z9QjSJ6cghhhAlFPs4XS22HdVsw9F7q+6wRxQ20lZSA=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
        b=cc6QqTiAf5rBzJtFlpV8yrV2XZh5t6p3rTrpfTxDfFaQ3hV1VsIAXQXxaJSqRd7Xg
         i1tEFvJX1heZHPYc5yeKkmFv201WrmmOfmwajXySPvk7AywweD3jaCQP7fbpoc1kj2
         fqhW7pBarhjI7pP626hLsRMviehyeCNZAX5KhRblkGYywp5LaUYr4KySm2P/fUSGlT
         qVvwqcO6Y5xxMQMqzIOvRbbIQv4GMshtJfmbjdFchbpzeTGMLuWNlxSQcZDJ2wMCiu
         DCG6lrbWUKINxa6UgMcnR8hBufBDgRwXegMpb3idkTAtg5LP1XbKxAmm5avNBmTyG2
         lM6CpzEy56vDw==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.sberdevices.ru (Postfix) with ESMTPS;
        Fri, 22 Sep 2023 08:31:44 +0300 (MSK)
Received: from localhost.localdomain (100.64.160.123) by
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Fri, 22 Sep 2023 08:31:44 +0300
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
Subject: [PATCH net-next v1 09/12] docs: net: description of MSG_ZEROCOPY for AF_VSOCK
Date:   Fri, 22 Sep 2023 08:24:25 +0300
Message-ID: <20230922052428.4005676-10-avkrasnov@salutedevices.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
References: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
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
X-KSMG-AntiSpam-Info: LuaCore: 534 534 808c2ea49f7195c68d40844e073217da4fa0d1e3, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;salutedevices.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;p-i-exch-sc-m01.sberdevices.ru:7.1.1,5.0.1;100.64.160.123:7.1.2, FromAlignment: s, ApMailHostAddress: 100.64.160.123
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
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

This adds description of MSG_ZEROCOPY flag support for AF_VSOCK type of
socket.

Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
---
 Changelog:
 v5(big patchset) -> v1:
  * Add information about 'VSOCK_RECVERR'.
  * Do not break line for test path.

 Documentation/networking/msg_zerocopy.rst | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/msg_zerocopy.rst b/Documentation/networking/msg_zerocopy.rst
index b3ea96af9b49..78fb70e748b7 100644
--- a/Documentation/networking/msg_zerocopy.rst
+++ b/Documentation/networking/msg_zerocopy.rst
@@ -7,7 +7,8 @@ Intro
 =====
 
 The MSG_ZEROCOPY flag enables copy avoidance for socket send calls.
-The feature is currently implemented for TCP and UDP sockets.
+The feature is currently implemented for TCP, UDP and VSOCK (with
+virtio transport) sockets.
 
 
 Opportunity and Caveats
@@ -174,7 +175,9 @@ read_notification() call in the previous snippet. A notification
 is encoded in the standard error format, sock_extended_err.
 
 The level and type fields in the control data are protocol family
-specific, IP_RECVERR or IPV6_RECVERR.
+specific, IP_RECVERR or IPV6_RECVERR (for TCP or UDP socket).
+For VSOCK socket, cmsg_level will be SOL_VSOCK and cmsg_type will be
+VSOCK_RECVERR.
 
 Error origin is the new type SO_EE_ORIGIN_ZEROCOPY. ee_errno is zero,
 as explained before, to avoid blocking read and write system calls on
@@ -235,12 +238,15 @@ Implementation
 Loopback
 --------
 
+For TCP and UDP:
 Data sent to local sockets can be queued indefinitely if the receive
 process does not read its socket. Unbound notification latency is not
 acceptable. For this reason all packets generated with MSG_ZEROCOPY
 that are looped to a local socket will incur a deferred copy. This
 includes looping onto packet sockets (e.g., tcpdump) and tun devices.
 
+For VSOCK:
+Data path sent to local sockets is the same as for non-local sockets.
 
 Testing
 =======
@@ -254,3 +260,6 @@ instance when run with msg_zerocopy.sh between a veth pair across
 namespaces, the test will not show any improvement. For testing, the
 loopback restriction can be temporarily relaxed by making
 skb_orphan_frags_rx identical to skb_orphan_frags.
+
+For VSOCK type of socket example can be found in
+tools/testing/vsock/vsock_test_zerocopy.c.
-- 
2.25.1

