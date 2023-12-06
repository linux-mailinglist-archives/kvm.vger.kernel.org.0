Return-Path: <kvm+bounces-3720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E1514807574
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EB0E1C20F2F
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 389C247778;
	Wed,  6 Dec 2023 16:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HvwHU/3w"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775F3D50
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 08:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701880916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BRBYbA6A9iVFJVJw2yLnCuRWTbq0bYeGysrV9jksr78=;
	b=HvwHU/3wBwdD8oPXKZ2+jR1CI5hSr+MJuSguM9HX7nXpd2cZH6S2D6PxOwqo4tYJcuM7NP
	0/zD+/vmoqPpqJzujAOcdKB9OxHQKxiPDm+TxqH/+FxVOlgkvUpWJEeV8U3Y/X9YNhpNYI
	bjFrf39TuMgC85HBIA1fszBxXyXxFC0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-zpbIc1GxM9eVvXcKWiT7_g-1; Wed, 06 Dec 2023 11:41:55 -0500
X-MC-Unique: zpbIc1GxM9eVvXcKWiT7_g-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4239047911bso10994511cf.3
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 08:41:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701880914; x=1702485714;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BRBYbA6A9iVFJVJw2yLnCuRWTbq0bYeGysrV9jksr78=;
        b=f/rDLJOae3ZY7PuD9r3Orise9jr+Ygti/bATaIJrrVs3V1vuMQhphr5iyUl03PHZNB
         oMcvM6zqUeFlZVH3qAYVc+Pnvrx3dHFk90EeNfOcYnZs9VxGTP9mEkBDiTS5/YtCPOua
         gIa1AhBiCouAfM84uTb54SOAGKFj0NM88UNePFxk1hjbCPDsoFDcrPrWa7EbQ7SUg+yt
         OZDlexBdQigvUvECk4qX/MtbyWSazUctsqaYECD1GP6TRIb2knT/kVIou1ZPJ1VTH+2u
         g3xeLFjG8PQ7RutBv70o8CnKRjLsZQgQsPNK7CQK53WuvKGN9aTYlAN4U1zAh0N0oLwm
         pacA==
X-Gm-Message-State: AOJu0Yzb3l4XUCtrrmxxDpQnf1L8yo3cm47OFFLWCDje5d7bB/HDxu8F
	xcLQv7Oua3QQKTM3eGQ/KGDmtGTdy5ReIsAEv5BHoxrGXiJLQLvIX4EZS6CFyNNi1Ir1hYby9sH
	efrglYakwU1M8
X-Received: by 2002:ac8:5b95:0:b0:425:4043:2a05 with SMTP id a21-20020ac85b95000000b0042540432a05mr1420275qta.128.1701880914552;
        Wed, 06 Dec 2023 08:41:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFaJIB6NOvZQTIiVkkPSR38mjWBsiSx+xgzPD2epv6qC/zaKWzLLIvu6i12qCTPMRBfNOkUNA==
X-Received: by 2002:ac8:5b95:0:b0:425:4043:2a05 with SMTP id a21-20020ac85b95000000b0042540432a05mr1420258qta.128.1701880914272;
        Wed, 06 Dec 2023 08:41:54 -0800 (PST)
Received: from step1.redhat.com (host-79-46-200-125.retail.telecomitalia.it. [79.46.200.125])
        by smtp.gmail.com with ESMTPSA id e25-20020ac86719000000b00423e8021da2sm78802qtp.42.2023.12.06.08.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 08:41:53 -0800 (PST)
From: Stefano Garzarella <sgarzare@redhat.com>
To: netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net] vsock/virtio: fix "comparison of distinct pointer types lacks a cast" warning
Date: Wed,  6 Dec 2023 17:41:43 +0100
Message-ID: <20231206164143.281107-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit

After backporting commit 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY
flag support") in CentOS Stream 9, CI reported the following error:

    In file included from ./include/linux/kernel.h:17,
                     from ./include/linux/list.h:9,
                     from ./include/linux/preempt.h:11,
                     from ./include/linux/spinlock.h:56,
                     from net/vmw_vsock/virtio_transport_common.c:9:
    net/vmw_vsock/virtio_transport_common.c: In function ‘virtio_transport_can_zcopy‘:
    ./include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast [-Werror]
       20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
          |                                   ^~
    ./include/linux/minmax.h:26:18: note: in expansion of macro ‘__typecheck‘
       26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
          |                  ^~~~~~~~~~~
    ./include/linux/minmax.h:36:31: note: in expansion of macro ‘__safe_cmp‘
       36 |         __builtin_choose_expr(__safe_cmp(x, y), \
          |                               ^~~~~~~~~~
    ./include/linux/minmax.h:45:25: note: in expansion of macro ‘__careful_cmp‘
       45 | #define min(x, y)       __careful_cmp(x, y, <)
          |                         ^~~~~~~~~~~~~
    net/vmw_vsock/virtio_transport_common.c:63:37: note: in expansion of macro ‘min‘
       63 |                 int pages_to_send = min(pages_in_iov, MAX_SKB_FRAGS);

We could solve it by using min_t(), but this operation seems entirely
unnecessary, because we also pass MAX_SKB_FRAGS to iov_iter_npages(),
which performs almost the same check, returning at most MAX_SKB_FRAGS
elements. So, let's eliminate this unnecessary comparison.

Fixes: 581512a6dc93 ("vsock/virtio: MSG_ZEROCOPY flag support")
Cc: avkrasnov@salutedevices.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index f6dc896bf44c..c8e162c9d1df 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -59,8 +59,7 @@ static bool virtio_transport_can_zcopy(const struct virtio_transport *t_ops,
 	t_ops = virtio_transport_get_ops(info->vsk);
 
 	if (t_ops->can_msgzerocopy) {
-		int pages_in_iov = iov_iter_npages(iov_iter, MAX_SKB_FRAGS);
-		int pages_to_send = min(pages_in_iov, MAX_SKB_FRAGS);
+		int pages_to_send = iov_iter_npages(iov_iter, MAX_SKB_FRAGS);
 
 		/* +1 is for packet header. */
 		return t_ops->can_msgzerocopy(pages_to_send + 1);
-- 
2.43.0


