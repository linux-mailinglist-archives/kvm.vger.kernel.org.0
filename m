Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0522A70B6CB
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 09:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbjEVHpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 03:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232679AbjEVHo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 03:44:56 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1E6AC;
        Mon, 22 May 2023 00:44:55 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 710585FD54;
        Mon, 22 May 2023 10:44:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1684741491;
        bh=qcm1rcspds6nBbsYu4uQ/1LCrKuUtxLK5dK/r7j7bP0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=hNi+O0YpqXs+X+aAEOSxILxwbo20X1nPmnjySCh14oMTUDskE7sEmWLTIpzG7OnGD
         Q/NLNSehgteTrylb4hZb8gwDF2RwFR8aW3dhkYTcUWHcdiD55WGcPUTOJi0qeiLTfK
         brvTnlG7qfwQGdZyqDPn3uY/uTNQO0XlY7Owj06EK7kT4eyPv0zr/dwPns7Hl6dZMR
         yYHyq7eNDc3cTaWPRZpIq3plZtJMzi86RU5Fy8LxmnU6DDR/+YmZpj0lH1RaY+Timc
         Tsr820Z+37jj3MiCjtgsVPAMprF+EUUZgV5PpAAlT8NBK/ud6DNUCluV+9goe+9Uoo
         1509GwAtG4jSQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon, 22 May 2023 10:44:51 +0300 (MSK)
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
Subject: [RFC PATCH v3 10/17] vhost/vsock: support MSG_ZEROCOPY for transport
Date:   Mon, 22 May 2023 10:39:43 +0300
Message-ID: <20230522073950.3574171-11-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/05/22 04:49:00 #21364689
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add 'msgzerocopy_allow()' callback for vhost transport.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 drivers/vhost/vsock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index b254aa4b756a..318866713ef7 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -396,6 +396,11 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
 	return val < vq->num;
 }
 
+static bool vhost_transport_msgzerocopy_allow(void)
+{
+	return true;
+}
+
 static bool vhost_transport_seqpacket_allow(u32 remote_cid);
 
 static struct virtio_transport vhost_transport = {
@@ -442,6 +447,7 @@ static struct virtio_transport vhost_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 
 		.read_skb = virtio_transport_read_skb,
+		.msgzerocopy_allow        = vhost_transport_msgzerocopy_allow,
 	},
 
 	.send_pkt = vhost_transport_send_pkt,
-- 
2.25.1

