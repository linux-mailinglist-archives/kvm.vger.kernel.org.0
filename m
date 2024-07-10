Return-Path: <kvm+bounces-21357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BED692DAF8
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B65CF1F21F49
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:30:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 578A216B72E;
	Wed, 10 Jul 2024 21:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKP5bwZ5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BDC15EFC1;
	Wed, 10 Jul 2024 21:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646768; cv=none; b=REo0LuoDnYbPfwRaT68QzMBrZ4jsgQq6jct+OD8U2fSi7/3KEwKmLYFcB9Mee6rydEZy7g0Um6YSQA1M3x0rSjNTV7bJpCg+8NtyIWTPxT3YA1n2yTaPaySUybC3G7ET8qNURbVPvID+81gphRxaTTaMJ1GfECh89xeCj/ofqFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646768; c=relaxed/simple;
	bh=aa9fCTbYzE+aisD6RqXIAVWYsXTP3Jh37dzQFu2SwWI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rw8GqsWBxRODVmpHk2DhJr8B8cI0pXe6H0SvsN4e9W441oRC7pfJWkzlg6R/7vIbK0B2vke3iZm2x/Z5VITr8x20hLb6SsOIQEz1WxWsSOLh5nnk0zGfu/1wqtQU0VygvEgcutMlzN6xHOVKz1HDu9lIdc9dk5m3V+/AmsYtF6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mKP5bwZ5; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e04f1bcbf84so226886276.0;
        Wed, 10 Jul 2024 14:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646765; x=1721251565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNa2JyqzSfsQHlae80C+dAnyTQSrxK9qhyOYTj2h2/o=;
        b=mKP5bwZ5gbs29Qb1c82tMG5nFdVzqPhVaBmk5LsIY6TE8lpQ6UIKoPXpfWGzST9XSI
         zljfuLsUj9phOSv8h+tH1yAhlbXxEKF9SJCqFGSjVqQAcq+nxknaH3UPV0GkU7dPRogw
         sP2wKtJ53o5MyGqqYnpjtCOFUDN/lUDf7KUqXKFuXgO3aO11fs/Kj8YV0VvwrgD0P4q/
         Btcxa2/IUfiQDfC4WpCXxKVtv1LsPMXvk/Gk4uMizoU1Ocoo9PmMCsE5ysLRmt4DMLDd
         DshXPAfbxWPs8ZxO7ART/G9lYwVMYoT6bOQNGoIikHBe/4X+AsSuoEUolpF9tYmFgqgr
         TWqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646765; x=1721251565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNa2JyqzSfsQHlae80C+dAnyTQSrxK9qhyOYTj2h2/o=;
        b=IysT0atNuH+SG/HX2d8mP/65FMMFd72PSN/gp2GxiYJ2x81Muej5qOz1J+xxX/z39H
         b+1N183vHfJ5A/oI5PDjZXcwuXGcloDG97XWv1nebYjQg5qeullyXXD2NTJCPYvh7Xr/
         WS9TsaP+mBpgvjxFF9HVQp0mo03GNt1JkCxoTk0/eypbScM80EKDOsjH+QHredTYe99N
         2emoWf2I5fr24Q/2CKsKT+INErWRGe76hozXjTS6kkuFkura5lOhKlQVe3dwFyJCp7Nj
         g1a/cVa7TzzFyz1bjy5e1hCEuTq8TzqfAv0gVt2o+qKsJd2Y+VV0N+H8/N1eFnQigPvG
         v0oA==
X-Forwarded-Encrypted: i=1; AJvYcCUPSN/4rDurSas2hhr2JMZu5oYWRl1Q2C+r9/NwdX97fBarIr6n60phccyvY0/4NS1LfV+7D6r7CbMMJqMA/uKrPlKcadLEDzYS837GCJfEWfJ9AkxlGlbYuGK+t/T6OQNGSJeONrBwgD7iwyrKDZ58nLC5RMxWmYKmcVJA8IDA9xjHikW4II0mT0Q76Dh81dDCq15K98hocqvoI+7PEoTKnCSax0fXXexvEbGc
X-Gm-Message-State: AOJu0YxQnYxRCtvUMFp3UlU0vwQT43c9SZbK+oNZQ2BVYPNKMWt4iiyd
	3rOsQhWXZnM62tE5BVEVu8xJbqlFPe9Mt8PsiQcfrVFriprSbZ2U
X-Google-Smtp-Source: AGHT+IF5ioq7BkP55ZrDd65MHpqGoaQfutI36NHEnLXbX07dGmO7XnmHfZ+Wg65ipK41BqyPE67tdw==
X-Received: by 2002:a25:7416:0:b0:e03:adcb:f8e8 with SMTP id 3f1490d57ef6-e041b078c55mr7655917276.30.1720646765536;
        Wed, 10 Jul 2024 14:26:05 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:26:05 -0700 (PDT)
From: Amery Hung <ameryhung@gmail.com>
X-Google-Original-From: Amery Hung <amery.hung@bytedance.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	bryantan@vmware.com,
	vdasa@vmware.com,
	pv-drivers@vmware.com
Cc: dan.carpenter@linaro.org,
	simon.horman@corigine.com,
	oxffffaa@gmail.com,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	bobby.eshleman@bytedance.com,
	jiang.wang@bytedance.com,
	amery.hung@bytedance.com,
	ameryhung@gmail.com,
	xiyou.wangcong@gmail.com
Subject: [RFC PATCH net-next v6 12/14] vsock/loopback: implement datagram support
Date: Wed, 10 Jul 2024 21:25:53 +0000
Message-Id: <20240710212555.1617795-13-amery.hung@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240710212555.1617795-1-amery.hung@bytedance.com>
References: <20240710212555.1617795-1-amery.hung@bytedance.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bobby Eshleman <bobby.eshleman@bytedance.com>

This commit implements datagram support for vsock loopback.

Not much more than simply toggling on "dgram_allow" and continuing to
use the common virtio functions.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Amery Hung <amery.hung@bytedance.com>
---
 net/vmw_vsock/vsock_loopback.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 4dd4886f29d1..0de4e2c8573c 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -46,6 +46,11 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
 	return 0;
 }
 
+static bool vsock_loopback_dgram_allow(u32 cid, u32 port)
+{
+	return true;
+}
+
 static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
 static bool vsock_loopback_msgzerocopy_allow(void)
 {
@@ -66,7 +71,7 @@ static struct virtio_transport loopback_transport = {
 		.cancel_pkt               = vsock_loopback_cancel_pkt,
 
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
-		.dgram_allow              = virtio_transport_dgram_allow,
+		.dgram_allow              = vsock_loopback_dgram_allow,
 
 		.stream_dequeue           = virtio_transport_stream_dequeue,
 		.stream_enqueue           = virtio_transport_stream_enqueue,
-- 
2.20.1


