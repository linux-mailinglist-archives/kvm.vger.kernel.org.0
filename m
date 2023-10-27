Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEDE47D908F
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 10:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbjJ0IDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 04:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbjJ0IDB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 04:03:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4D71BB
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 01:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698393737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qahb/LE7va9Q1Iif0xKr62EhnyUP1QxSWkvvxRc0UUw=;
        b=FKuzpXJ2A6Q7eTRUyasPo5Enf3vwxNNo+VtkT2gZtfhYdrQk5mVcJrWlmi/VYKq3jSMQ1A
        4yxj2PW+fupFkza1Lqi5f7P72nN9uRxoXMKVrIGVHU8Mf0j6B1LkMvM8fWHJxgV7P8xk++
        2hCS4LQRN/AwLm4T619k+IwvOA8orO4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-yVGzvzF9PKimPctv335uVw-1; Fri, 27 Oct 2023 04:02:00 -0400
X-MC-Unique: yVGzvzF9PKimPctv335uVw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4084e4ce543so14359445e9.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 01:02:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698393719; x=1698998519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qahb/LE7va9Q1Iif0xKr62EhnyUP1QxSWkvvxRc0UUw=;
        b=RcKZlcakRGaV0OrakuvCbCVc6e+AgYcqVyVEhMsQhNxZFMurh5vfTeH/XgOJ/6sS65
         wALjOh67wpbeAWS4iuq11qaT225ausOqrdTb1dckGKG0f7kMdWVmxZZHxATqHZbWT4rU
         i8rZ7xe2wcWHFOlCVNHu9FgdK5liP7N8g+UNCCyS3LOLtWS6ktAH7Od0sUXXjgCJ4t3O
         Qaw/Z3a1Md5xR55q5l2mpTwV8aoWuTfG2B+E22yZ2lG8tWF5hKkcLIXHTS0s0wQ4LcXl
         Uhd1aBPAP1F3qDAiKaD0bM2t65E3mlf4Bm3lvpkGrk5r6L/Cw6tlBUKYG1Kw/mYg0QRc
         SoTg==
X-Gm-Message-State: AOJu0Yw6LNbjgcr9IU6GzDALT0VE0qiPEW+5iKlQgnDcJaWDd/VDNu56
        0SQDtkA9NVU+HOvF5Ll3JN71DcEHERnwY7CGoL/DxKLrg5PYcn5nDxe00vWXuNpcVmFrd1yZfiZ
        Gtgm7KWIGmbZH
X-Received: by 2002:a7b:cb19:0:b0:403:b86:f624 with SMTP id u25-20020a7bcb19000000b004030b86f624mr1470987wmj.23.1698393719508;
        Fri, 27 Oct 2023 01:01:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsWq4ysIXWhOeaSY7ybDArSvHomlUP94STda82wQjfGaQQaqu+1TEC/2s6C4J8Uij9mn2YWA==
X-Received: by 2002:a7b:cb19:0:b0:403:b86:f624 with SMTP id u25-20020a7bcb19000000b004030b86f624mr1470972wmj.23.1698393719078;
        Fri, 27 Oct 2023 01:01:59 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-185-56.business.telecomitalia.it. [87.12.185.56])
        by smtp.gmail.com with ESMTPSA id ay32-20020a05600c1e2000b004065daba6casm4464276wmb.46.2023.10.27.01.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 01:01:58 -0700 (PDT)
Date:   Fri, 27 Oct 2023 10:01:54 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     stefanha@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bobby.eshleman@bytedance.com,
        bobbyeshleman@gmail.com
Subject: Re: [PATCH net] virtio/vsock: Fix uninit-value in
 virtio_transport_recv_pkt()
Message-ID: <waodmdtiiq6qcdj4pwys5pod7eyveqkfq6fwqy5hqptzembcxf@siitwagevn2f>
References: <20231026150154.3536433-1-syoshida@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231026150154.3536433-1-syoshida@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 27, 2023 at 12:01:54AM +0900, Shigeru Yoshida wrote:
>KMSAN reported the following uninit-value access issue:
>
>=====================================================
>BUG: KMSAN: uninit-value in virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
> virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
> vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
> process_one_work kernel/workqueue.c:2630 [inline]
> process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
> worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
> kthread+0x3cc/0x520 kernel/kthread.c:388
> ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
> ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
>
>Uninit was stored to memory at:
> virtio_transport_space_update net/vmw_vsock/virtio_transport_common.c:1274 [inline]
> virtio_transport_recv_pkt+0x1ee8/0x26a0 net/vmw_vsock/virtio_transport_common.c:1415
> vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
> process_one_work kernel/workqueue.c:2630 [inline]
> process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
> worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
> kthread+0x3cc/0x520 kernel/kthread.c:388
> ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
> ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
>
>Uninit was created at:
> slab_post_alloc_hook+0x105/0xad0 mm/slab.h:767
> slab_alloc_node mm/slub.c:3478 [inline]
> kmem_cache_alloc_node+0x5a2/0xaf0 mm/slub.c:3523
> kmalloc_reserve+0x13c/0x4a0 net/core/skbuff.c:559
> __alloc_skb+0x2fd/0x770 net/core/skbuff.c:650
> alloc_skb include/linux/skbuff.h:1286 [inline]
> virtio_vsock_alloc_skb include/linux/virtio_vsock.h:66 [inline]
> virtio_transport_alloc_skb+0x90/0x11e0 net/vmw_vsock/virtio_transport_common.c:58
> virtio_transport_reset_no_sock net/vmw_vsock/virtio_transport_common.c:957 [inline]
> virtio_transport_recv_pkt+0x1279/0x26a0 net/vmw_vsock/virtio_transport_common.c:1387
> vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
> process_one_work kernel/workqueue.c:2630 [inline]
> process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
> worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
> kthread+0x3cc/0x520 kernel/kthread.c:388
> ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
> ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304
>
>CPU: 1 PID: 10664 Comm: kworker/1:5 Not tainted 6.6.0-rc3-00146-g9f3ebbef746f #3
>Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc38 04/01/2014
>Workqueue: vsock-loopback vsock_loopback_work
>=====================================================
>
>The following simple reproducer can cause the issue described above:
>
>int main(void)
>{
>  int sock;
>  struct sockaddr_vm addr = {
>    .svm_family = AF_VSOCK,
>    .svm_cid = VMADDR_CID_ANY,
>    .svm_port = 1234,
>  };
>
>  sock = socket(AF_VSOCK, SOCK_STREAM, 0);
>  connect(sock, (struct sockaddr *)&addr, sizeof(addr));
>  return 0;
>}
>
>This issue occurs because the `buf_alloc` and `fwd_cnt` fields of the
>`struct virtio_vsock_hdr` are not initialized when a new skb is allocated
>in `virtio_transport_alloc_skb()`. This patch resolves the issue by
>initializing these fields during allocation.
>
>Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")

CCin Bobby, the original author, for any additional comments/checks.

Yeah, I see, before that commit we used kzalloc() to allocate the
header so we forgot to reset these 2 fields, and checking they are
the only 2 missing.

I was thinking of putting a memset(hdr, 0, sizeof(*hdr)) in
virtio_vsock_alloc_skb() but I think it's just extra unnecessary work,
since here we set all the fields (thanks to this fix), in vhost/vsock.c
we copy all the header we receive from the guest and in
virtio_transport.c we already set it all to 0 because we are
preallocating the receive buffers.

So I'm fine with this fix!

>Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
>---
> net/vmw_vsock/virtio_transport_common.c | 2 ++
> 1 file changed, 2 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 352d042b130b..102673bef189 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -68,6 +68,8 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
> 	hdr->dst_port	= cpu_to_le32(dst_port);
> 	hdr->flags	= cpu_to_le32(info->flags);
> 	hdr->len	= cpu_to_le32(len);
>+	hdr->buf_alloc	= cpu_to_le32(0);
>+	hdr->fwd_cnt	= cpu_to_le32(0);
>
> 	if (info->msg && len > 0) {
> 		payload = skb_put(skb, len);
>-- 
>2.41.0
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

