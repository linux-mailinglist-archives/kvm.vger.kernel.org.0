Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939D75ED7B7
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 10:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbiI1I2f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 04:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233555AbiI1I2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 04:28:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E954774DED
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 01:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664353710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g5jRqFBs3ZpqqID4I8CKzY6l+aiJ3r8Xkuq0qHKyk3s=;
        b=IFDiBFUUSZvfS9fbp/IzVM0jVUHpgLyUGNd8GAuxV059a10nFr6Y3r0Gg4y5GZaWnfLjbO
        BKzZfJqxUpzMu0veeVSfwR3Bd5OOcGxhJXJ1WgBY6+O18rU0PeuU+XNJvLc6pyEYe+Vgk+
        VmtQqGLFgyNuaRO+eXJcluvycyHpAM4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-115-9fX1KmvnMlaP2PFCR9dOEQ-1; Wed, 28 Sep 2022 04:28:29 -0400
X-MC-Unique: 9fX1KmvnMlaP2PFCR9dOEQ-1
Received: by mail-wr1-f71.google.com with SMTP id h20-20020adfaa94000000b0022cc1de1251so1029953wrc.15
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 01:28:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=g5jRqFBs3ZpqqID4I8CKzY6l+aiJ3r8Xkuq0qHKyk3s=;
        b=2fCziwW2Y9A0lwi1mrv3oD/Em7Z6bNZH7iitb3pir9v2D2/1TjQJDYOq+CADPgqDP4
         +rCr4in4JaqDktAFYdUCWEJYGfhl7/V16YoYkaGVrCW3Qr3SALzUPuP+XDNC4+/OVvUB
         mlvjYSfItqfonFqJNnrBx0BA1ID/43iN/4mqi/Zqy9ROKqFX81BKze0iGiSjIrJmTpvp
         zpOQUcjo/YT7Ea3/+nk6JBbyo185hgZYKUTM6nKb+5iFjuCxztkphGvJifjRyDwMNaS9
         LuifdAH3r5bpqlkVZ0w5e09l+9gciPkBiD0OI33nxlrNYpIYDL8KPToekbi7FB4UeVol
         CzbQ==
X-Gm-Message-State: ACrzQf3Q1vqRKSX280v5It0qU9UVzEyPty0lDU/2lM3pZIeTF6DqEE7X
        /egeXkZaCbaT1SJgi2mqTxwSl7zPhJ2dlKQTqcxHz22PF5DWQdza3r41kVSDeXJe5v5cnQAFM9p
        b8nJMqC5xWgKR
X-Received: by 2002:a7b:c4cc:0:b0:3b4:757b:492f with SMTP id g12-20020a7bc4cc000000b003b4757b492fmr5920806wmk.74.1664353707731;
        Wed, 28 Sep 2022 01:28:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM47jgP3O0DziLeVykTicWQQEQFnRqKDM2sPzfZXITIBwu4Xs1v2ngdyKb/2zKNsf907hLdJjw==
X-Received: by 2002:a7b:c4cc:0:b0:3b4:757b:492f with SMTP id g12-20020a7bc4cc000000b003b4757b492fmr5920780wmk.74.1664353707446;
        Wed, 28 Sep 2022 01:28:27 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-222.retail.telecomitalia.it. [79.46.200.222])
        by smtp.gmail.com with ESMTPSA id q10-20020a1cf30a000000b003b47575d304sm1233345wmq.32.2022.09.28.01.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 01:28:26 -0700 (PDT)
Date:   Wed, 28 Sep 2022 10:28:23 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Junichi Uekawa <uekawa@chromium.org>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        mst@redhat.com, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
References: <20220928064538.667678-1-uekawa@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220928064538.667678-1-uekawa@chromium.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 28, 2022 at 03:45:38PM +0900, Junichi Uekawa wrote:
>When copying a large file over sftp over vsock, data size is usually 32kB,
>and kmalloc seems to fail to try to allocate 32 32kB regions.
>
> Call Trace:
>  [<ffffffffb6a0df64>] dump_stack+0x97/0xdb
>  [<ffffffffb68d6aed>] warn_alloc_failed+0x10f/0x138
>  [<ffffffffb68d868a>] ? __alloc_pages_direct_compact+0x38/0xc8
>  [<ffffffffb664619f>] __alloc_pages_nodemask+0x84c/0x90d
>  [<ffffffffb6646e56>] alloc_kmem_pages+0x17/0x19
>  [<ffffffffb6653a26>] kmalloc_order_trace+0x2b/0xdb
>  [<ffffffffb66682f3>] __kmalloc+0x177/0x1f7
>  [<ffffffffb66e0d94>] ? copy_from_iter+0x8d/0x31d
>  [<ffffffffc0689ab7>] vhost_vsock_handle_tx_kick+0x1fa/0x301 [vhost_vsock]
>  [<ffffffffc06828d9>] vhost_worker+0xf7/0x157 [vhost]
>  [<ffffffffb683ddce>] kthread+0xfd/0x105
>  [<ffffffffc06827e2>] ? vhost_dev_set_owner+0x22e/0x22e [vhost]
>  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
>  [<ffffffffb6eb332e>] ret_from_fork+0x4e/0x80
>  [<ffffffffb683dcd1>] ? flush_kthread_worker+0xf3/0xf3
>
>Work around by doing kvmalloc instead.
>
>Signed-off-by: Junichi Uekawa <uekawa@chromium.org>
>---
>
> drivers/vhost/vsock.c                   | 2 +-
> net/vmw_vsock/virtio_transport_common.c | 2 +-
> 2 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 368330417bde..5703775af129 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -393,7 +393,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> 		return NULL;
> 	}
>
>-	pkt->buf = kmalloc(pkt->len, GFP_KERNEL);
>+	pkt->buf = kvmalloc(pkt->len, GFP_KERNEL);
> 	if (!pkt->buf) {
> 		kfree(pkt);
> 		return NULL;
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index ec2c2afbf0d0..3a12aee33e92 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -1342,7 +1342,7 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
>
> void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
> {
>-	kfree(pkt->buf);
>+	kvfree(pkt->buf);

virtio_transport_free_pkt() is used also in virtio_transport.c and 
vsock_loopback.c where pkt->buf is allocated with kmalloc(), but IIUC 
kvfree() can be used with that memory, so this should be fine.

> 	kfree(pkt);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
>-- 
>2.37.3.998.g577e59143f-goog
>

This issue should go away with the Bobby's work about introducing 
sk_buff [1], but we can queue this for now.

I'm not sure if we should do the same also in the virtio-vsock driver 
(virtio_transport.c). Here in vhost-vsock the buf allocated is only used 
in the host, while in the virtio-vsock driver the buffer is exposed to 
the device emulated in the host, so it should be physically contiguous 
(if not, maybe we need to adjust virtio_vsock_rx_fill()).
So for now I think is fine to use kvmalloc only on vhost-vsock 
(eventually we can use it also in vsock_loopback), since the Bobby's 
patch should rework this code:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

[1] 
https://lore.kernel.org/lkml/65d117ddc530d12a6d47fcc45b38891465a90d9f.1660362668.git.bobby.eshleman@bytedance.com/

Thanks,
Stefano

