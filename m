Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B09732E46
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 12:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344623AbjFPKal (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 06:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344989AbjFPKaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 06:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A944C31;
        Fri, 16 Jun 2023 03:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D674635A2;
        Fri, 16 Jun 2023 10:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09345C43397;
        Fri, 16 Jun 2023 10:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686911237;
        bh=kIsf8AbSmXSzhxQYkllhPv2Z+84eoqLgyPp+vctmyI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Akw9uytdR0MNllkRhU5ErvSA8IN9Kgejjbc0pXGZQcqN2ftmMpgySTSKc8cynauoz
         O6mzFjXOIX2QfDBLFn/77UFxqI9VqfVuc+5bgpJP6ty9mN7UEmnTlY9GnxyZXfBU8P
         z810hm2WOAr+Cpvk94MupGRy5HayiK2ba4HjG/2JFRmIyS4zvbSy+IKCt+KC062fW9
         FQeuoUwYxq9dxbgam4a7R7kDQDkhDwrjXP9tgvjScq0Xnd1vyNlrEQcEB9/z7vQFF8
         31wS/94LMA41YMLa6hituhpDB8CnsQMYrTVkL6z92oGC+JhtAAY9hC8ugr7/8VvqJD
         a+tAmpK6/oeSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrey Smetanin <asmetanin@yandex-team.ru>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 26/26] vhost_net: revert upend_idx only on retriable error
Date:   Fri, 16 Jun 2023 06:26:23 -0400
Message-Id: <20230616102625.673454-26-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230616102625.673454-1-sashal@kernel.org>
References: <20230616102625.673454-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.34
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Andrey Smetanin <asmetanin@yandex-team.ru>

[ Upstream commit 1f5d2e3bab16369d5d4b4020a25db4ab1f4f082c ]

Fix possible virtqueue used buffers leak and corresponding stuck
in case of temporary -EIO from sendmsg() which is produced by
tun driver while backend device is not up.

In case of no-retriable error and zcopy do not revert upend_idx
to pass packet data (that is update used_idx in corresponding
vhost_zerocopy_signal_used()) as if packet data has been
transferred successfully.

v2: set vq->heads[ubuf->desc].len equal to VHOST_DMA_DONE_LEN
in case of fake successful transmit.

Signed-off-by: Andrey Smetanin <asmetanin@yandex-team.ru>
Message-Id: <20230424204411.24888-1-asmetanin@yandex-team.ru>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Andrey Smetanin <asmetanin@yandex-team.ru>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/net.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 4c538b30fd76d..4418192ab8aaa 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -934,13 +934,18 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
+			bool retry = err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS;
+
 			if (zcopy_used) {
 				if (vq->heads[ubuf->desc].len == VHOST_DMA_IN_PROGRESS)
 					vhost_net_ubuf_put(ubufs);
-				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
-					% UIO_MAXIOV;
+				if (retry)
+					nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
+						% UIO_MAXIOV;
+				else
+					vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
 			}
-			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
+			if (retry) {
 				vhost_discard_vq_desc(vq, 1);
 				vhost_net_enable_vq(net, vq);
 				break;
-- 
2.39.2

