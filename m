Return-Path: <kvm+bounces-21358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C84E892DAFD
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:31:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83E5B285485
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E67016C86D;
	Wed, 10 Jul 2024 21:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KHRWoSok"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A8C1607B6;
	Wed, 10 Jul 2024 21:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720646769; cv=none; b=GCCLrvq2+Th/hhgDlXIMtHtmpByT+RTrLn1VgKptG0E38WBU1KIVCj0mMJu4sekdiYzxZCrwVZxeiSwvFURwjBH67r1wy0mwhyfGW4G4ZQzooJjV8byIFDg//lMsBoEyy95iiJP7Tvd/WccuN2T8B6XlgXPMPKoXruSKOSU8v9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720646769; c=relaxed/simple;
	bh=gGDd9b+eIPhJKP6IsUlyGBx9zga4xIilMlUsKve5RCs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Bk0+/1KWcMHBIDBAVYixwS+03+Nf688VYnN5gY4ifgJNdAN7pMehzW+4sZFVnezfFXwBnwzlAR3cKTkMIn1slhhNeIdpA+vJOHGl0/Z/CSKuJG02kTY6d0iRX4cEeUvIM3lXfJBfafmKDZJRgJyyK7bR6rUQqIqtLkDLn3y2NT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KHRWoSok; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-79f06c9c929so114618185a.0;
        Wed, 10 Jul 2024 14:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720646766; x=1721251566; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pVIqbNrhEav3W0++Ik3CGMaAVVSiaEFKng5Yf5v/RzU=;
        b=KHRWoSokpNQF/LrwUQhUBpeFAgqmYde6tEO/BlNtw8dXui/rmG2qpuOC1QZnQ4g3Xh
         72CvDP+7K2fd8SvM9VXlbZEf+QzvY7cluI1w6+mzY8H7KeLWkl96rz3oTI+ZeOgkfNMz
         XBLJGqBvDzPvcHkRGOVCJlherkY+xT8qHPviWrotq/tiPiqeJ1/yj/Yx5ovKtH6f857E
         9GOSLIID7ogUKpjdrFnUeQOnNy2y41FBcRcnEZZAv5qRyaj+8IWWwfywYLRk7MP3ZndH
         oI7lRkbFQoE8TWjFVaLDX7Rbj5+twQQiWs0Gfte3cp3w2RAswHUoveRPpkefWekuBZN6
         8vMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720646766; x=1721251566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pVIqbNrhEav3W0++Ik3CGMaAVVSiaEFKng5Yf5v/RzU=;
        b=YgX3vFH/GXfXRxESxZL9R8WpD752N5LAGAok1fAZGWnUue4CoWWFTLnzWqUaJ1dvVN
         Pe9TfWMpkym7yn3B0+mHEufS/jMhyjcD+QMfn5yE1hREDKmrV3Pz6UKpsIwlGA8JMMv3
         5gG4RH3HL8AgOgiswrvmIibDKXVRczLaAxhAiOEO4uJH7yYnQG2OqvRdSxMwLf9OGpHm
         Yw2SHWEV73WmnSK8ePekF8ySqd6EhOMZV0lihRWLf+gVY3soroomRFtUtX5XZmTXuJDN
         l7t4gb7Lrpq9zTu6Wjq6RNSGSzlie6CcNOu9vCfPa0B2sEn+NXDBQ45mofkbbCJegD2h
         qO6A==
X-Forwarded-Encrypted: i=1; AJvYcCUU5rREEte7+MwFYzXJjuxhlZiaB62IdWx9mNIQksII0ZxNFLD8Q+1uDm6d/Z9nFVQAeunj0XLVJXGt0puvzIHVAz8epGBGbHXNvOsGdSFGnMfGzRxRS9ece0655JluQFlzgkBdXFgT0trgsgWgyzFro34oJsLIZT3TxysgbhtCbuqvS3kzuqVOVccqyAKdJDoGNQ2gDn4blhOdRQbEAi4WpHRiLCMd6r6uLuoj
X-Gm-Message-State: AOJu0Yy7ZwWePLcvSdgGobSZ0iN0+4syCaImWPSlCOatxhKbJS10tn8A
	U8LeMdYSBwm8Aao22oc85Jlb+rwk+vRO98SQCFOPe2WD6S5pxqj+
X-Google-Smtp-Source: AGHT+IFI320bP+IbIdMehUjmnO755tB0kWKy6r95fV4jib7ke50hwNQJtvQqfOpqotKxyY96hgBfNw==
X-Received: by 2002:a05:620a:4011:b0:79e:fb4c:2fb7 with SMTP id af79cd13be357-7a1469bce83mr198013985a.12.1720646766248;
        Wed, 10 Jul 2024 14:26:06 -0700 (PDT)
Received: from n36-183-057.byted.org ([130.44.215.118])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f190b0af1sm228791885a.122.2024.07.10.14.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jul 2024 14:26:06 -0700 (PDT)
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
Subject: [RFC PATCH net-next v6 13/14] virtio/vsock: implement datagram support
Date: Wed, 10 Jul 2024 21:25:54 +0000
Message-Id: <20240710212555.1617795-14-amery.hung@bytedance.com>
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

This commit implements datagram support with a new version of
->dgram_allow().

Additionally, it drops virtio_transport_dgram_allow() as an exported
symbol because it is no longer used in other transports.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Signed-off-by: Amery Hung <amery.hung@bytedance.com>
---
 include/linux/virtio_vsock.h            |  1 -
 net/vmw_vsock/virtio_transport.c        | 22 +++++++++++++++++++++-
 net/vmw_vsock/virtio_transport_common.c |  6 ------
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 4408749febd2..fe8fa0a9669d 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -222,7 +222,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
 u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
 bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
 bool virtio_transport_stream_allow(u32 cid, u32 port);
-bool virtio_transport_dgram_allow(u32 cid, u32 port);
 
 int virtio_transport_connect(struct vsock_sock *vsk);
 
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 4891b845fcde..4e1ed3b11e26 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -63,6 +63,7 @@ struct virtio_vsock {
 
 	u32 guest_cid;
 	bool seqpacket_allow;
+	bool dgram_allow;
 
 	/* These fields are used only in tx path in function
 	 * 'virtio_transport_send_pkt_work()', so to save
@@ -492,6 +493,21 @@ static bool virtio_transport_msgzerocopy_allow(void)
 	return true;
 }
 
+static bool virtio_transport_dgram_allow(u32 cid, u32 port)
+{
+	struct virtio_vsock *vsock;
+	bool dgram_allow;
+
+	dgram_allow = false;
+	rcu_read_lock();
+	vsock = rcu_dereference(the_virtio_vsock);
+	if (vsock)
+		dgram_allow = vsock->dgram_allow;
+	rcu_read_unlock();
+
+	return dgram_allow;
+}
+
 static bool virtio_transport_seqpacket_allow(u32 remote_cid);
 
 static struct virtio_transport virtio_transport = {
@@ -753,6 +769,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
 		vsock->seqpacket_allow = true;
 
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
+		vsock->dgram_allow = true;
+
 	vdev->priv = vsock;
 
 	ret = virtio_vsock_vqs_init(vsock);
@@ -850,7 +869,8 @@ static struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
-	VIRTIO_VSOCK_F_SEQPACKET
+	VIRTIO_VSOCK_F_SEQPACKET,
+	VIRTIO_VSOCK_F_DGRAM
 };
 
 static struct virtio_driver virtio_vsock_driver = {
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index a571b575fde9..52f671287fe3 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1010,12 +1010,6 @@ bool virtio_transport_stream_allow(u32 cid, u32 port)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
 
-bool virtio_transport_dgram_allow(u32 cid, u32 port)
-{
-	return false;
-}
-EXPORT_SYMBOL_GPL(virtio_transport_dgram_allow);
-
 int virtio_transport_connect(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_pkt_info info = {
-- 
2.20.1


