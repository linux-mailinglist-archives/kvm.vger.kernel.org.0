Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9740073E459
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231848AbjFZQMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjFZQMR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:12:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8E3E59
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687795887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YymWdEkHWhyai/v4Ncfq5HtLNdYJQriBatYjnpRoPBU=;
        b=L4gnn+zipafrw2UnqrumIvZSgw+64P+MGtcMZ5DlPC3Q1QZMtZcvEq88XjgQvDEfOG3eR1
        WtZTzc3LzMXwg3z45dIW9dyBbWbABgu5pXGvOkskAlI5ElpMhCKMbh78DrmqyJ7GjRQiOI
        6824vpRukM37IfuITAPvqBqyZbLFTPA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-yi73-pYcMzeRWzldB70GRA-1; Mon, 26 Jun 2023 12:11:22 -0400
X-MC-Unique: yi73-pYcMzeRWzldB70GRA-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-763c36d4748so334579385a.0
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:11:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687795881; x=1690387881;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YymWdEkHWhyai/v4Ncfq5HtLNdYJQriBatYjnpRoPBU=;
        b=fDh0hv81V4SqsgTJfeyXsEBBtHcw21SJj690q1WYfpI1ki6e+wjTRyMf0Xk6hKAlBP
         +xlaor9lTOtL1XWI3vuWSPJhWlX8jQL5hxPs3bFB/cv/ZX+r08V0uU/rbUq5aYdYZ05e
         tZNGfpWFeB0EnQwU5Ayo6ZRkcuk1umpWuZv+3kzDdfGNH+CyXU2tefTYKxv5xbvBx3T+
         HQfg3t3A4VO/YhvgJV//gnkHzHGM8eO6LDCQ9gjvr5IJ5mIyEwNV+ynCTavZhc7e6nAX
         FoID04DzhjF7jUZr4o1Ga7uLevb+QgNUB8kpc24CJ0veo06xYzOint6nF4CRAqt7gmed
         k71g==
X-Gm-Message-State: AC+VfDwnYjKxWeuXxaAeC+/2JBo+9yIznA2s2CsEKUp5kgg2KAQVsJ5e
        KZ7CfFQNC5H5CUxyzhhT19GUPip4KgLmYTg1XuO0qIt9wAisPyDRDp7tHubF6x9sgkjcoZCjl6/
        KonkS7/FA8ZmS
X-Received: by 2002:a05:620a:4308:b0:765:619c:cca8 with SMTP id u8-20020a05620a430800b00765619ccca8mr8196735qko.16.1687795881651;
        Mon, 26 Jun 2023 09:11:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4OTPuoDBhm9NFpKvI1ovmDpK5uOGhA7usFuq/EJikHKcpNPEengaaoKEb0Pz/YsBCORIP4qQ==
X-Received: by 2002:a05:620a:4308:b0:765:619c:cca8 with SMTP id u8-20020a05620a430800b00765619ccca8mr8196717qko.16.1687795881447;
        Mon, 26 Jun 2023 09:11:21 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id y26-20020a37e31a000000b00765a7843382sm1252256qki.74.2023.06.26.09.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 09:11:20 -0700 (PDT)
Date:   Mon, 26 Jun 2023 18:11:16 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v4 11/17] vsock/virtio: support MSG_ZEROCOPY for
 transport
Message-ID: <fvxvln7njntjflcwbw7ypzu7jybe2cwq5xedgjcxkkubuuayp7@bs3r3r5rvifw>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-12-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230603204939.1598818-12-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 03, 2023 at 11:49:33PM +0300, Arseniy Krasnov wrote:
>Add 'msgzerocopy_allow()' callback for virtio transport.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 6053d8341091..d9ffa16dda69 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -438,6 +438,11 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
> 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> }
>
>+static bool virtio_transport_msgzerocopy_allow(void)
>+{
>+	return true;
>+}
>+
> static bool virtio_transport_seqpacket_allow(u32 remote_cid);
>
> static struct virtio_transport virtio_transport = {
>@@ -484,6 +489,8 @@ static struct virtio_transport virtio_transport = {
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>
> 		.read_skb = virtio_transport_read_skb,
>+
>+		.msgzerocopy_allow        = virtio_transport_msgzerocopy_allow,

Ditto.

> 	},
>
> 	.send_pkt = virtio_transport_send_pkt,
>-- 
>2.25.1
>

