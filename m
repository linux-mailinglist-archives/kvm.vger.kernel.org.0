Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABAFF758A3C
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 02:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbjGSAur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 20:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjGSAuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 20:50:40 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B04019B1
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:21 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-7658430eb5dso692927685a.2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 17:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689727820; x=1692319820;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YwyL60j0LwW2T2Dkd6jqyPcZMdC5174wawCzrtawFxQ=;
        b=ZkFEdOwq2hZ+UH9aki+OAvh12b03IsfbbmomV42Sr1oO//aaD/ebgnltz0if5zRzRw
         kCGRgBejlVJSBR9faXcL/Z8lb42tToOWyKuRZ+r3kWDkLsDHjG4IF9hdeXjcgq1Ar8jo
         lAo/AmRop4+65XfBpTe/ZmLw1ghMlUHtIR40H3XQ2eB2SPJpch9esUCy5wXwCZQw16Qo
         hNgaft6pooZorRPl7hGLkwGEPqVfd8l6hmVe5xLVgj5hO4IDDZ/55DxLee2KXx8fs05/
         jWkktHeT52LbTUtU39jx9vsn5jSdLBBRa4eTV8RhXslnxpjudAQmXfWck7XOMm3qbTca
         Zvtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689727820; x=1692319820;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YwyL60j0LwW2T2Dkd6jqyPcZMdC5174wawCzrtawFxQ=;
        b=IX364YLSb9PDfK/iCHD+EamZrul2kKeB5jYmdgQmykrPZ4S8LNsCLo6vPhK2me7OHe
         BGvGxa+Kz8Q07jpjGrhRy8keX5x4uxr809MpSDTaaoeX9GBbMfi4haqHtuGrpyqwMd00
         20Omw8yKCj4X4goVfwoA3YpS8RiNP1+rG0/96/fbIPMalPgxKNF/AP+3xRLFZ+VkVyJ3
         lHQ3hBXcXKXch2GFGJ4265yJw/pWp6Cter/7+w+LZM7HQcvN9z+QmeyKR8Igbh+m3t4U
         53eteYGG8DvmA4ktzOKSLFDqyIqcRxHjy2I2fqCHzPZBYHWP8zvNVqleedGvREt3yw8P
         eADA==
X-Gm-Message-State: ABy/qLbehOsojxQSg4a/T52klZA3NpGyW9W6TSUOYLKM1I6XyenpoVck
        rayOnWWJGbpoVHoXrYLy2KdvQw==
X-Google-Smtp-Source: APBJJlGjD4uAcDktpne1OPb2niRoR4Sex/q0LgELqlkx3IiIYvS/TlrGRYx0Ylzgb/oYt0xuYtaoTg==
X-Received: by 2002:a05:620a:2687:b0:767:3fa7:2afa with SMTP id c7-20020a05620a268700b007673fa72afamr20697364qkp.28.1689727820255;
        Tue, 18 Jul 2023 17:50:20 -0700 (PDT)
Received: from [172.17.0.7] ([130.44.212.112])
        by smtp.gmail.com with ESMTPSA id c5-20020a05620a11a500b0076738337cd1sm968696qkk.1.2023.07.18.17.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 17:50:19 -0700 (PDT)
From:   Bobby Eshleman <bobby.eshleman@bytedance.com>
Date:   Wed, 19 Jul 2023 00:50:17 +0000
Subject: [PATCH RFC net-next v5 13/14] virtio/vsock: implement datagram
 support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230413-b4-vsock-dgram-v5-13-581bd37fdb26@bytedance.com>
References: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
In-Reply-To: <20230413-b4-vsock-dgram-v5-0-581bd37fdb26@bytedance.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc:     Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org, Bobby Eshleman <bobby.eshleman@bytedance.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit implements datagram support for virtio/vsock by teaching
virtio to use the general virtio transport ->dgram_addr_init() function
and implementation a new version of ->dgram_allow().

Additionally, it drops virtio_transport_dgram_allow() as an exported
symbol because it is no longer used in other transports.

Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 include/linux/virtio_vsock.h            |  1 -
 net/vmw_vsock/virtio_transport.c        | 24 +++++++++++++++++++++++-
 net/vmw_vsock/virtio_transport_common.c |  6 ------
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index b3856b8a42b3..d0a4f08b12c1 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -211,7 +211,6 @@ void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val);
 u64 virtio_transport_stream_rcvhiwat(struct vsock_sock *vsk);
 bool virtio_transport_stream_is_active(struct vsock_sock *vsk);
 bool virtio_transport_stream_allow(u32 cid, u32 port);
-bool virtio_transport_dgram_allow(u32 cid, u32 port);
 void virtio_transport_dgram_addr_init(struct sk_buff *skb,
 				      struct sockaddr_vm *addr);
 
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index ac2126c7dac5..713718861bd4 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -63,6 +63,7 @@ struct virtio_vsock {
 
 	u32 guest_cid;
 	bool seqpacket_allow;
+	bool dgram_allow;
 };
 
 static u32 virtio_transport_get_local_cid(void)
@@ -413,6 +414,7 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
+static bool virtio_transport_dgram_allow(u32 cid, u32 port);
 static bool virtio_transport_seqpacket_allow(u32 remote_cid);
 
 static struct virtio_transport virtio_transport = {
@@ -430,6 +432,7 @@ static struct virtio_transport virtio_transport = {
 
 		.dgram_enqueue            = virtio_transport_dgram_enqueue,
 		.dgram_allow              = virtio_transport_dgram_allow,
+		.dgram_addr_init          = virtio_transport_dgram_addr_init,
 
 		.stream_dequeue           = virtio_transport_stream_dequeue,
 		.stream_enqueue           = virtio_transport_stream_enqueue,
@@ -462,6 +465,21 @@ static struct virtio_transport virtio_transport = {
 	.send_pkt = virtio_transport_send_pkt,
 };
 
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
 static bool virtio_transport_seqpacket_allow(u32 remote_cid)
 {
 	struct virtio_vsock *vsock;
@@ -655,6 +673,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
 		vsock->seqpacket_allow = true;
 
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
+		vsock->dgram_allow = true;
+
 	vdev->priv = vsock;
 
 	ret = virtio_vsock_vqs_init(vsock);
@@ -747,7 +768,8 @@ static struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
-	VIRTIO_VSOCK_F_SEQPACKET
+	VIRTIO_VSOCK_F_SEQPACKET,
+	VIRTIO_VSOCK_F_DGRAM
 };
 
 static struct virtio_driver virtio_vsock_driver = {
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 96118e258097..77898f5325cd 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -783,12 +783,6 @@ bool virtio_transport_stream_allow(u32 cid, u32 port)
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
2.30.2

