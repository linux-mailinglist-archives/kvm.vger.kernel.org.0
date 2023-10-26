Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6EB7D8574
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 17:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345312AbjJZPC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 11:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjJZPC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 11:02:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D80B9
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 08:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698332531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Le7r1qZdjn6tilkqUR5AFBSjzkY/HKzRQy2FXtGZ7Zs=;
        b=OKnheQcDLpt0MZ7/qDIKU1izK8od9JZGAvm5caZNjdP/tg0TvJ8UqeF4/lYDhig7NO/Ws1
        wurIVqFoobgLvfTiS8Di84HaI9prvGlm34yctrb8dam4G6X3IZLUhOW7P6JiMdX+bwDTYs
        UeGQvKLN/KGsBeTR9puAIeTWTRjkzNM=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-Q-XTeacfNGC313kEBmvPxQ-1; Thu, 26 Oct 2023 11:02:05 -0400
X-MC-Unique: Q-XTeacfNGC313kEBmvPxQ-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1c9fc94b182so9509365ad.1
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 08:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698332522; x=1698937322;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Le7r1qZdjn6tilkqUR5AFBSjzkY/HKzRQy2FXtGZ7Zs=;
        b=Rk/CtzkrDOGFcPyqFtcPQpQj6nwbudG16YZQ5DzEZMWdG0DxfQ+4nrCckQJvU6JTEp
         M3wc8jFsZ7B99iE+MSMDxnw3iZLGmKnOCV6icHYH8WOurDLNKp/2LMQ3pX25NtfWwNVw
         0KHntiMF2GDwLrPWH9bqjsXBQJXsIFV+IWO37sSBoToVwqwMnEEcY9Nt39KLiEi43B0I
         a5osJBm6ch+w4ctNUaj8SVldA32pLKuaAws4JQLUQQG54BpLXOmME5sA6DoRyuNEV3qh
         zcVLcRhqiHVZ5fGcqj0EgvF3jWLfBnI6/HBd9leWLYzOAf5DxcZ1fETxV2i16M6AkM0q
         732Q==
X-Gm-Message-State: AOJu0YyDJC83mC07KVJrm1rUGujGpLV//kCtmhKWZCI0yStdCXycZj2f
        ZKgu64QOe4wuzEJ8hqCX0bRrgrECpoeCdikh+TqATfk+1bxiCG5HmfIo4bOvmu0aBUi+ZyN/Pau
        yi6WjvaF1ic+H
X-Received: by 2002:a17:902:d48b:b0:1cc:c0f:c163 with SMTP id c11-20020a170902d48b00b001cc0c0fc163mr2030466plg.17.1698332522014;
        Thu, 26 Oct 2023 08:02:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkMkNFGl6pf3X2t9+qgnZ2jJ6k9tsZamwMF9GCo+CggK6U8NBQgmvo80UyqhXw/fy4mQy7ew==
X-Received: by 2002:a17:902:d48b:b0:1cc:c0f:c163 with SMTP id c11-20020a170902d48b00b001cc0c0fc163mr2030417plg.17.1698332521352;
        Thu, 26 Oct 2023 08:02:01 -0700 (PDT)
Received: from kernel-devel.local ([240d:1a:c0d:9f00:245e:16ff:fe87:c960])
        by smtp.gmail.com with ESMTPSA id g11-20020a170902740b00b001c60e7bf5besm11032572pll.281.2023.10.26.08.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Oct 2023 08:02:00 -0700 (PDT)
From:   Shigeru Yoshida <syoshida@redhat.com>
To:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shigeru Yoshida <syoshida@redhat.com>
Subject: [PATCH net] virtio/vsock: Fix uninit-value in virtio_transport_recv_pkt()
Date:   Fri, 27 Oct 2023 00:01:54 +0900
Message-ID: <20231026150154.3536433-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KMSAN reported the following uninit-value access issue:

=====================================================
BUG: KMSAN: uninit-value in virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
 virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
 vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
 worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
 kthread+0x3cc/0x520 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

Uninit was stored to memory at:
 virtio_transport_space_update net/vmw_vsock/virtio_transport_common.c:1274 [inline]
 virtio_transport_recv_pkt+0x1ee8/0x26a0 net/vmw_vsock/virtio_transport_common.c:1415
 vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
 worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
 kthread+0x3cc/0x520 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

Uninit was created at:
 slab_post_alloc_hook+0x105/0xad0 mm/slab.h:767
 slab_alloc_node mm/slub.c:3478 [inline]
 kmem_cache_alloc_node+0x5a2/0xaf0 mm/slub.c:3523
 kmalloc_reserve+0x13c/0x4a0 net/core/skbuff.c:559
 __alloc_skb+0x2fd/0x770 net/core/skbuff.c:650
 alloc_skb include/linux/skbuff.h:1286 [inline]
 virtio_vsock_alloc_skb include/linux/virtio_vsock.h:66 [inline]
 virtio_transport_alloc_skb+0x90/0x11e0 net/vmw_vsock/virtio_transport_common.c:58
 virtio_transport_reset_no_sock net/vmw_vsock/virtio_transport_common.c:957 [inline]
 virtio_transport_recv_pkt+0x1279/0x26a0 net/vmw_vsock/virtio_transport_common.c:1387
 vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
 worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
 kthread+0x3cc/0x520 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

CPU: 1 PID: 10664 Comm: kworker/1:5 Not tainted 6.6.0-rc3-00146-g9f3ebbef746f #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc38 04/01/2014
Workqueue: vsock-loopback vsock_loopback_work
=====================================================

The following simple reproducer can cause the issue described above:

int main(void)
{
  int sock;
  struct sockaddr_vm addr = {
    .svm_family = AF_VSOCK,
    .svm_cid = VMADDR_CID_ANY,
    .svm_port = 1234,
  };

  sock = socket(AF_VSOCK, SOCK_STREAM, 0);
  connect(sock, (struct sockaddr *)&addr, sizeof(addr));
  return 0;
}

This issue occurs because the `buf_alloc` and `fwd_cnt` fields of the
`struct virtio_vsock_hdr` are not initialized when a new skb is allocated
in `virtio_transport_alloc_skb()`. This patch resolves the issue by
initializing these fields during allocation.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 352d042b130b..102673bef189 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -68,6 +68,8 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 	hdr->dst_port	= cpu_to_le32(dst_port);
 	hdr->flags	= cpu_to_le32(info->flags);
 	hdr->len	= cpu_to_le32(len);
+	hdr->buf_alloc	= cpu_to_le32(0);
+	hdr->fwd_cnt	= cpu_to_le32(0);
 
 	if (info->msg && len > 0) {
 		payload = skb_put(skb, len);
-- 
2.41.0

