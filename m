Return-Path: <kvm+bounces-17614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C58AA8C8858
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 16:47:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E2561F24AF5
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 14:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25CAF6D1AE;
	Fri, 17 May 2024 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZOR7UksO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE4F6CDAB;
	Fri, 17 May 2024 14:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715957190; cv=none; b=T9EiLJotJPS/tGzBm1eAuD/dJnQUJKwQmCa8Hq3zYbNnQaWmLiFVrgv7IzqIH7GhwJ/g+zgNFL7v2b86Vh1m0+9kxW+JKIKyGEJpk1SNXSoH3EnlC/vjw7u/x0728Fbq0ARtJThTqwN221h9bAtBbPsZou1wEFBfDOVCdJcQ2bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715957190; c=relaxed/simple;
	bh=ayTww+DFRdv8kU8QHxSwm1TVYpqV1rJoYpxyAD0nsTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A4S8MEXyobPlBbeFmDXrCXbp+iYT1WuSQVgW7mv6aDU2+Xu2jN2JUOXfdeuGXDj03TwDGElQWZl0j4g9nNF/O2Rh6JPU/nvsU8Oce3K5V+1+RV2L+I3M5PaYpc9OYG0QKFqg6LnygJWs+geYUP15V5PhUaKVW0lhFTjLHYFaW/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZOR7UksO; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1ee38966529so4908705ad.1;
        Fri, 17 May 2024 07:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715957188; x=1716561988; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ObdkphHypw+pCyvAkBy4EywArmTATwnandulAo4H4xI=;
        b=ZOR7UksOqiDVrq7ySQeiOQlGcgnFXIqujtENiBpgATOF3mLcncUokt+SK5LFyWc+dX
         uWT588vIdG2YZ8uYUCeYzu7CTg++2krSR2s8hkDibwsFjCngqASMuHWFaHuip5Alpgh/
         gJjDxFXU8JU/mqQ/FJsmmZrRJMuby8Svk3LR/EWx+jV6yFjcvmYE8k8/Z0GLddu5WB+v
         l82lnTYttAaFjRLKpo5rZvF8+2bHeSXkJX/FUxgD3uVDnztfp9O8WzNKjVpWjCcX35wB
         hFyqKPZ0WviBN35B2wSLmiu0MUWS/B0Y78BkvBS1TwCIKSmTSNrTENTARBTXMTnifRXx
         5RFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715957188; x=1716561988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ObdkphHypw+pCyvAkBy4EywArmTATwnandulAo4H4xI=;
        b=SN8v1/QdoH9QRayswRMa8IJ/EFR2GvAOPRHBq7CcPCBQ5z1uB5lSJlXasN18lhc0cD
         KHg30tzAzXPIczsjAKkWTfpt9BkKX6Sufl/7Cdi4RT623AnlA+XsWxqT/pU/lEC+SlgN
         pbWBdssDdYNe71NJdblxaCojTC/UcdY6Dt0OnwZ9dtyeIplD76mCr6Ihc9uYMgWKHj2P
         C66lgsWuJxiR1xDDro+tIOpkZ15TIJYIXnU/6TKw8zsv20uTGCZTB1F3h9UV+Ec8YvpX
         XfvncXSxSsLd9QWRtIc0eMsn27uHBOJ2rJ1sqLuw8h6d2O8DQP6QBtr8wzxz3cx8sHaH
         TIgQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVXErjMer/I8Auznu2bRj4oQH1lurTHaOu7u6uA8I6eoCCwlV6t5IB9a4MryQiDq3vo6IuKsCWxXfSvWDtu2iFpBsHgO81yVsrlC+2S53vF5JPjkHOqEBL4XaL45onFfZVTk3VfGAOIpwHwwM5e5rv+WT2xpoTf0nH
X-Gm-Message-State: AOJu0YwK4HI6cOxD4cR8eSbQjVbPLKKSibwp7sCztJc1F3+pKthZXXJE
	WQ4di+UWZUuewm4iMdYuCP6SLRc0Eo68Sm2tdpjMFmohH9Q9wFhG
X-Google-Smtp-Source: AGHT+IGznRigy/pv1m+3lTVs4TUKCUcENj3vk2rDy123ij37qxwzekLbGPS3kJ0q5z1BkgDnP4tNkA==
X-Received: by 2002:a17:903:18a:b0:1eb:7855:43d5 with SMTP id d9443c01a7336-1ef432a0bf9mr313781075ad.30.1715957188387;
        Fri, 17 May 2024 07:46:28 -0700 (PDT)
Received: from devant.hz.ali.com ([47.89.83.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c160a1esm158504985ad.279.2024.05.17.07.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 07:46:27 -0700 (PDT)
From: Xuewei Niu <niuxuewei97@gmail.com>
X-Google-Original-From: Xuewei Niu <niuxuewei.nxw@antgroup.com>
To: stefanha@redhat.com,
	sgarzare@redhat.com
Cc: mst@redhat.com,
	davem@davemloft.net,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: [RFC PATCH 3/5] vsock/virtio: can_msgzerocopy adapts to multi-devices
Date: Fri, 17 May 2024 22:46:05 +0800
Message-Id: <20240517144607.2595798-4-niuxuewei.nxw@antgroup.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
References: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Adds a new argument, named "cid", to let them know which `virtio_vsock` to
be selected.

Signed-off-by: Xuewei Niu <niuxuewei.nxw@antgroup.com>
---
 include/linux/virtio_vsock.h            | 2 +-
 net/vmw_vsock/virtio_transport.c        | 5 ++---
 net/vmw_vsock/virtio_transport_common.c | 6 +++---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c82089dee0c8..21bfd5e0c2e7 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -168,7 +168,7 @@ struct virtio_transport {
 	 * extra checks and can perform zerocopy transmission by
 	 * default.
 	 */
-	bool (*can_msgzerocopy)(int bufs_num);
+	bool (*can_msgzerocopy)(u32 cid, int bufs_num);
 };
 
 ssize_t
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 93d25aeafb83..998b22e5ce36 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -521,14 +521,13 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
-static bool virtio_transport_can_msgzerocopy(int bufs_num)
+static bool virtio_transport_can_msgzerocopy(u32 cid, int bufs_num)
 {
 	struct virtio_vsock *vsock;
 	bool res = false;
 
 	rcu_read_lock();
-
-	vsock = rcu_dereference(the_virtio_vsock);
+	vsock = virtio_transport_get_virtio_vsock(cid);
 	if (vsock) {
 		struct virtqueue *vq = vsock->vqs[VSOCK_VQ_TX];
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index bed75a41419e..e7315d7b9af1 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -39,7 +39,7 @@ virtio_transport_get_ops(struct vsock_sock *vsk)
 
 static bool virtio_transport_can_zcopy(const struct virtio_transport *t_ops,
 				       struct virtio_vsock_pkt_info *info,
-				       size_t pkt_len)
+				       size_t pkt_len, unsigned int cid)
 {
 	struct iov_iter *iov_iter;
 
@@ -62,7 +62,7 @@ static bool virtio_transport_can_zcopy(const struct virtio_transport *t_ops,
 		int pages_to_send = iov_iter_npages(iov_iter, MAX_SKB_FRAGS);
 
 		/* +1 is for packet header. */
-		return t_ops->can_msgzerocopy(pages_to_send + 1);
+		return t_ops->can_msgzerocopy(cid, pages_to_send + 1);
 	}
 
 	return true;
@@ -375,7 +375,7 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 			info->msg->msg_flags &= ~MSG_ZEROCOPY;
 
 		if (info->msg->msg_flags & MSG_ZEROCOPY)
-			can_zcopy = virtio_transport_can_zcopy(t_ops, info, pkt_len);
+			can_zcopy = virtio_transport_can_zcopy(t_ops, info, pkt_len, src_cid);
 
 		if (can_zcopy)
 			max_skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE,
-- 
2.34.1


