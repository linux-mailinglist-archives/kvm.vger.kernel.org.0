Return-Path: <kvm+bounces-57805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CE69B7E411
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:45:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 328B11C04403
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 23:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610762F549A;
	Tue, 16 Sep 2025 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gLNy5qKi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5172F39B5
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 23:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066241; cv=none; b=PYUt2+bJx6dbfusC+LsVNAzrScUPPAjb28aO1FUOzgbkppo/YELOvozL1ME9xFUlbQw6s7Lt9mCD9dWRRCzwRDc7Z1ZZOm0uMc82GThagnCxhpMlymznIo46o5vOf9hdOFn16GwMc4NKBq6hpDWKbL9kSqEXAvZ1nrDQ9GxUUEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066241; c=relaxed/simple;
	bh=9Wny9EveYUKuOodiYR//AaIkSgCmI3lCDOCST2vOIoM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HvdWzHmj2KW+Pm8dAjs/j0zRKN3wsnbmmym0tUOnfZ5WfKwfSse53sBiAsev4HfGmFkoH7q4Ah3eqvqZwoXe3pBw/ffcVC2XqkOmFbN24L8Icqn9LMUAwXIV3IRsLzqYv/nPQn5OfuocGCIxydfi3kfR0QLZGnoiBNu7DkujwgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gLNy5qKi; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-267fac63459so5079585ad.1
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066237; x=1758671037; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xznpXjSPg14L8u6GPVNf9rVdoH0mv1cEtj7GXHqOaxM=;
        b=gLNy5qKixvDygboO/M8qQ0zHZJAdHwwntcYJdmg4aCnb5nu30Vph6f7mKvTeU6wdux
         BVCfrKfVZlZQNvIRFZ9aldxDb4EJztv8yKRT3skDroj4APXMI2Dp+tHLuGUdD1HdWqQA
         PXhGOasafU3Y5uCQEWknro263trHXduupzfLpg/OBD/5O3sSwipnfUIJYB2FD35sY6kp
         SUyez05tf7vY6jbq2f2vKQ6iPKhHHmRoEdoLOx1Z8JTfuhvzYVtySk9x2XdXsQU0XOYU
         LhVQbRUH+dkwF+Mp6hJ6eB8pjA9UHkEPz1nOT+8rJtu93+IK7bzU1uV7yH7kpkoGDPJy
         BO4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066237; x=1758671037;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xznpXjSPg14L8u6GPVNf9rVdoH0mv1cEtj7GXHqOaxM=;
        b=dDB273rid7l9Oy9+/97VBqLlkLchWtUpkEs2cL+R+bE0jH7Zc/nreLrb+UT3J5VNqx
         PTkAjBKYe99eR/1zj8ka61IAoBvxbg/Sonfl80MkC2eiUST4lSYv0zJyD4E51QMaCmxo
         OJJcQ3SBNTOsvaTXjfMtMtJuRlkRRgc19oMVDjIJWx6NT0TXQ+09cLVbp268aRvz5y08
         yrVXIu+teHjMHNtJWG1BBzLOu/tf2FwrtsCNIuIrrPm4jbZ/YfwbMOs2iYnDm7VqOyOn
         QR+yvuy1lITSTCFzAkDKRhneZxHrmSpqbTELceftiu33gbdKzyar/LHxQqnIrQ1NAko4
         N+/g==
X-Forwarded-Encrypted: i=1; AJvYcCWhb4SHyMdMRMr+kqEHEZVaUQZjamOihSuGkI0C2EFxzP7Y+ORH56A6nZJo8ch3SuBWXcA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8n8f6116w88BhvG8AIWoDcH3UKigk4MbZiXIKP22u7EYANGdH
	ai05Be4rzL7n2K/C4xxMGNYVdSvRz2dV9hpoKvM7c+6DZtykfP3KyoWo
X-Gm-Gg: ASbGncv7hydz69tT5PdS49fc0rU7BftaVOPkoPHCX5KxJb//KAUVVL4plSp7C5/X9dq
	pDvWwsnzz9KjVIDihB7E9HVZg1EpVOLNYf0Kz4g7uNMhlU7Cr4jzcgi+CRyjJRCNiKNF7W0c/j4
	7C6iy16Bi/ts9V8CvW6hKt7nHzJ4M9ZNJLEdHuzS008MEMMjP35k1s9HnUFhNZu3u/GdzaIUZP9
	VGyz/qZSdRb0BYyg9QntnOxbxBtUFIS1SC/71l4mlwU2/8MF/UWD1bsQEg/RfTuBXjiVCAXlykw
	yUNZ78sbNNdtqQjgen4tPwuu27PPWVLj0w1s1QEaHEIcRt5U9ckZ488W1c+j5FUojDAH5EjMbet
	f2Kfjj+qyhPBnep/cluIBmyWJt31gbBM=
X-Google-Smtp-Source: AGHT+IGgEOkn91Dg5X4PgnpAYAK6sltdoKTmbUSmUOQXkvL2vD/GIGzT/HGBTqnu8s5A/IqxmQFqpw==
X-Received: by 2002:a17:902:e84f:b0:264:f3ed:ee2c with SMTP id d9443c01a7336-268119b2af4mr1220725ad.12.1758066237368;
        Tue, 16 Sep 2025 16:43:57 -0700 (PDT)
Received: from localhost ([2a03:2880:2ff:71::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-267f4d286aesm14613895ad.63.2025.09.16.16.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:43:56 -0700 (PDT)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Tue, 16 Sep 2025 16:43:48 -0700
Subject: [PATCH net-next v6 4/9] vsock/loopback: add netns support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250916-vsock-vmtest-v6-4-064d2eb0c89d@meta.com>
References: <20250916-vsock-vmtest-v6-0-064d2eb0c89d@meta.com>
In-Reply-To: <20250916-vsock-vmtest-v6-0-064d2eb0c89d@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
 Vishnu Dasa <vishnu.dasa@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 Bobby Eshleman <bobbyeshleman@gmail.com>, berrange@redhat.com, 
 Bobby Eshleman <bobbyeshleman@meta.com>
X-Mailer: b4 0.13.0

From: Bobby Eshleman <bobbyeshleman@meta.com>

Add NS support to vsock loopback. Sockets in a global mode netns
communicate with each other, regardless of namespace. Sockets in a local
mode netns may only communicate with other sockets within the same
namespace.

Use pernet_ops to install a vsock_loopback for every namespace that is
created (to be used if local mode is enabled).

Retroactively call init/exit on every namespace when the vsock_loopback
module is loaded in order to initialize the per-ns device.

Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>

---
Changes in v6:
- init pernet ops for vsock_loopback module
- vsock_loopback: add space in struct to clarify lock protection
- do proper cleanup/unregister on vsock_loopback_exit()
- vsock_loopback: use virtio_vsock_skb_net()

Changes in v5:
- add callbacks code to avoid reverse dependency
- add logic for handling vsock_loopback setup for already existing
  namespaces
---
 include/net/af_vsock.h         |  1 +
 include/net/netns/vsock.h      |  6 +++
 net/vmw_vsock/vsock_loopback.c | 98 ++++++++++++++++++++++++++++++++++++++----
 3 files changed, 97 insertions(+), 8 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 628e35ae9d00..5180b7dbb6d6 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -320,4 +320,5 @@ static inline bool vsock_net_check_mode(struct vsock_sock *vsk, struct net *net,
 
 	return orig_net_mode == VSOCK_NET_MODE_GLOBAL && vsk->orig_net_mode == VSOCK_NET_MODE_GLOBAL;
 }
+
 #endif /* __AF_VSOCK_H__ */
diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
index d4593c0b8dc4..a32d546793a2 100644
--- a/include/net/netns/vsock.h
+++ b/include/net/netns/vsock.h
@@ -9,6 +9,8 @@ enum vsock_net_mode {
 	VSOCK_NET_MODE_LOCAL,
 };
 
+struct vsock_loopback;
+
 struct netns_vsock {
 	struct ctl_table_header *vsock_hdr;
 	spinlock_t lock;
@@ -16,5 +18,9 @@ struct netns_vsock {
 	/* protected by lock */
 	enum vsock_net_mode mode;
 	bool written;
+
+#if IS_ENABLED(CONFIG_VSOCKETS_LOOPBACK)
+	struct vsock_loopback *loopback;
+#endif
 };
 #endif /* __NET_NET_NAMESPACE_VSOCK_H */
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 1b2fab73e0d0..134e0619de07 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -28,8 +28,16 @@ static u32 vsock_loopback_get_local_cid(void)
 
 static int vsock_loopback_send_pkt(struct sk_buff *skb)
 {
-	struct vsock_loopback *vsock = &the_vsock_loopback;
+	struct vsock_loopback *vsock;
 	int len = skb->len;
+	struct net *net;
+
+	net = virtio_vsock_skb_net(skb);
+
+	if (net && net->vsock.mode == VSOCK_NET_MODE_LOCAL)
+		vsock = net->vsock.loopback;
+	else
+		vsock = &the_vsock_loopback;
 
 	virtio_vsock_skb_queue_tail(&vsock->pkt_queue, skb);
 	queue_work(vsock->workqueue, &vsock->pkt_work);
@@ -134,27 +142,99 @@ static void vsock_loopback_work(struct work_struct *work)
 	}
 }
 
-static int __init vsock_loopback_init(void)
+static int vsock_loopback_init_vsock(struct vsock_loopback *vsock)
 {
-	struct vsock_loopback *vsock = &the_vsock_loopback;
-	int ret;
-
 	vsock->workqueue = alloc_workqueue("vsock-loopback", 0, 0);
 	if (!vsock->workqueue)
 		return -ENOMEM;
 
 	skb_queue_head_init(&vsock->pkt_queue);
 	INIT_WORK(&vsock->pkt_work, vsock_loopback_work);
+	return 0;
+}
+
+static void vsock_loopback_deinit_vsock(struct vsock_loopback *vsock)
+{
+	if (vsock->workqueue)
+		destroy_workqueue(vsock->workqueue);
+}
+
+static int vsock_loopback_init_net(struct net *net)
+{
+	if (WARN_ON_ONCE(net->vsock.loopback))
+		return 0;
+
+	net->vsock.loopback = kmalloc(sizeof(*net->vsock.loopback), GFP_KERNEL);
+	if (!net->vsock.loopback)
+		return -ENOMEM;
+
+	return vsock_loopback_init_vsock(net->vsock.loopback);
+}
+
+static void vsock_loopback_exit_net(struct net *net)
+{
+	if (net->vsock.loopback) {
+		vsock_loopback_deinit_vsock(net->vsock.loopback);
+		kfree(net->vsock.loopback);
+		net->vsock.loopback = NULL;
+	}
+}
+
+static void vsock_loopback_deinit_all(void)
+{
+	struct net *net;
+
+	down_read(&net_rwsem);
+	for_each_net(net)
+		vsock_loopback_exit_net(net);
+	up_read(&net_rwsem);
+}
+
+static struct pernet_operations vsock_loopback_net_ops = {
+	.init = vsock_loopback_init_net,
+	.exit = vsock_loopback_exit_net,
+};
+
+static int __init vsock_loopback_init(void)
+{
+	struct vsock_loopback *vsock = &the_vsock_loopback;
+	struct net *net;
+	int ret;
+
+	ret = vsock_loopback_init_vsock(vsock);
+	if (ret < 0)
+		return ret;
+
+	ret = register_pernet_subsys(&vsock_loopback_net_ops);
+	if (ret < 0)
+		goto out_deinit_vsock;
+
+	/* call callbacks on any net previously created */
+	down_read(&net_rwsem);
+	for_each_net(net) {
+		ret = vsock_loopback_init_net(net);
+		if (ret < 0)
+			break;
+	}
+	up_read(&net_rwsem);
+
+	/* undo any initializations that succeeded */
+	if (ret < 0)
+		goto out_deinit_pernet_vsock;
 
 	ret = vsock_core_register(&loopback_transport.transport,
 				  VSOCK_TRANSPORT_F_LOCAL);
 	if (ret)
-		goto out_wq;
+		goto out_deinit_pernet_vsock;
+
 
 	return 0;
 
-out_wq:
-	destroy_workqueue(vsock->workqueue);
+out_deinit_pernet_vsock:
+	vsock_loopback_deinit_all();
+	unregister_pernet_subsys(&vsock_loopback_net_ops);
+out_deinit_vsock:
+	vsock_loopback_deinit_vsock(vsock);
 	return ret;
 }
 
@@ -164,6 +244,8 @@ static void __exit vsock_loopback_exit(void)
 
 	vsock_core_unregister(&loopback_transport.transport);
 
+	vsock_loopback_deinit_all();
+
 	flush_work(&vsock->pkt_work);
 
 	virtio_vsock_skb_queue_purge(&vsock->pkt_queue);

-- 
2.47.3


