Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E425E7212E1
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 22:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjFCUzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 16:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbjFCUzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 16:55:06 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 703E71B4;
        Sat,  3 Jun 2023 13:54:57 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id B1DF35FD3E;
        Sat,  3 Jun 2023 23:54:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1685825689;
        bh=tL2E1Y90S5bBkA16ZM0oXYsz18KCFk1Zn9JPdTBbPT8=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=RkDGbgFFU3bql1NGpMnKp+sa9IgXSPVYdj8wJKb0NlMmUzuWkI6vLkSJpc/A+hgXp
         kR74vj1zoSnvFHiZ/jjkyeTAL+IDmnGVsFcYNElktnQq56H/m8OuWBEgXWTWFEdEQE
         Pw/mXw40KB8+rXlmn1YmxHnmqkxOepdFxD9Z8klnFZAy8P83qOLcEx67Vyq8jVf7On
         K7URpoNHn090hPm81Ta1ZjcuFkpe9DSkSiPlOa47oadsbBuvBF3/xzUN4URPbFjO7W
         /zA3FCSJ+1IPqEFggnPF0HpLRlR9kK1qvFbnp5T5CZ2lcFlIqXdwDJ6Sk88BrGWVYR
         dmqRm3sQsVYew==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat,  3 Jun 2023 23:54:49 +0300 (MSK)
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
Subject: [RFC PATCH v4 14/17] docs: net: description of MSG_ZEROCOPY for AF_VSOCK
Date:   Sat, 3 Jun 2023 23:49:36 +0300
Message-ID: <20230603204939.1598818-15-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/03 16:55:00 #21417531
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds description of MSG_ZEROCOPY flag support for AF_VSOCK type of
socket.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 Documentation/networking/msg_zerocopy.rst | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/msg_zerocopy.rst b/Documentation/networking/msg_zerocopy.rst
index b3ea96af9b49..34bc7ff411ce 100644
--- a/Documentation/networking/msg_zerocopy.rst
+++ b/Documentation/networking/msg_zerocopy.rst
@@ -7,7 +7,8 @@ Intro
 =====
 
 The MSG_ZEROCOPY flag enables copy avoidance for socket send calls.
-The feature is currently implemented for TCP and UDP sockets.
+The feature is currently implemented for TCP, UDP and VSOCK (with
+virtio transport) sockets.
 
 
 Opportunity and Caveats
@@ -174,7 +175,7 @@ read_notification() call in the previous snippet. A notification
 is encoded in the standard error format, sock_extended_err.
 
 The level and type fields in the control data are protocol family
-specific, IP_RECVERR or IPV6_RECVERR.
+specific, IP_RECVERR or IPV6_RECVERR (for TCP or UDP socket).
 
 Error origin is the new type SO_EE_ORIGIN_ZEROCOPY. ee_errno is zero,
 as explained before, to avoid blocking read and write system calls on
@@ -201,6 +202,7 @@ undefined, bar for ee_code, as discussed below.
 
 	printf("completed: %u..%u\n", serr->ee_info, serr->ee_data);
 
+For VSOCK socket, cmsg_level will be SOL_VSOCK and cmsg_type will be 0.
 
 Deferred copies
 ~~~~~~~~~~~~~~~
@@ -235,12 +237,15 @@ Implementation
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
@@ -254,3 +259,6 @@ instance when run with msg_zerocopy.sh between a veth pair across
 namespaces, the test will not show any improvement. For testing, the
 loopback restriction can be temporarily relaxed by making
 skb_orphan_frags_rx identical to skb_orphan_frags.
+
+For VSOCK type of socket example can be found in  tools/testing/vsock/
+vsock_test_zerocopy.c.
-- 
2.25.1

