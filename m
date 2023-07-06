Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4EE374A2A9
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 18:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbjGFQ4t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 12:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbjGFQ4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 12:56:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A281FC3
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 09:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688662548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y7EFslApvIMhSEz1WUIyVbtwIYD8kB8bBcKW8IzvGEk=;
        b=IyMu8CsaEBttKaaH1CTPXRpPmhR4AiFztvBvNBk15TWXX6wlt7L8D6nd7FYYtBlDN0aL/L
        r1o1FWvRENQhtbKGMJAoIruAojS8QxnZM8GQSkyPoyMF9YjJVbWVTO0z4b03Rb84FVzJq7
        n4Mpp+v2mGskFDchFTiPURYJ4X2VrPA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-Z98jKmaGO2iapBKnO0pBag-1; Thu, 06 Jul 2023 12:55:47 -0400
X-MC-Unique: Z98jKmaGO2iapBKnO0pBag-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-992e6840901so113359966b.0
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 09:55:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688662546; x=1691254546;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y7EFslApvIMhSEz1WUIyVbtwIYD8kB8bBcKW8IzvGEk=;
        b=aduR25T4cdQKChsVhwY817N+yXS7iZk3zqV8BLf7xC1yf6yongQCodzZZfwM9AAlvO
         2g+cOrQYLqJSITZSYttrUwhCro1134/xNMf6zM/S7AGjxL063YI21mXUUWGzPSdrHK93
         8ZtHNT0sq+AfuBGjo+tQGWLS2voA/tBFZ9d/y/LsgIapCgYXbslX+Wh+WYwH64bLAKSv
         WMLuOVRNsQ766OhW0KYxk6OnIsU5OGTQnqkib/4aNC2cTbJjvRNZXk0obf/d2r+t0xF7
         JlIGA2Syv9xUO14GTKW3LhDaEmhvZeLP4kpSPt1I8jIj18PViZ/qAgnjsjx67G4HjM5i
         YGOw==
X-Gm-Message-State: ABy/qLa0p+qgk+o58qpe5baCc9hluZ6c0m3prUXN1zJe3bFzcXv0VACw
        b9JSxxAF//8RkcvhtLUnIi8ynnwoDTGetvlO152RSZW3M6ijvziZT+7MMkArreoN07FpZ186zml
        AlfgK8DxZvRZv
X-Received: by 2002:a17:906:2d6:b0:993:b238:314 with SMTP id 22-20020a17090602d600b00993b2380314mr2600083ejk.38.1688662546152;
        Thu, 06 Jul 2023 09:55:46 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFGg/FURu/KpBWldonp5cKBo2TqmSR+9W2fAH24sb2tpeMexZDCIz1vdjUXF4DUou9tWLwsog==
X-Received: by 2002:a17:906:2d6:b0:993:b238:314 with SMTP id 22-20020a17090602d600b00993b2380314mr2600069ejk.38.1688662545830;
        Thu, 06 Jul 2023 09:55:45 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-163.retail.telecomitalia.it. [79.46.200.163])
        by smtp.gmail.com with ESMTPSA id h20-20020a170906719400b0099290e2c163sm1041264ejk.204.2023.07.06.09.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 09:55:45 -0700 (PDT)
Date:   Thu, 6 Jul 2023 18:55:43 +0200
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
Subject: Re: [RFC PATCH v5 11/17] vsock/virtio: support MSG_ZEROCOPY for
 transport
Message-ID: <tx4i6pikd6k2lejpukxsf2auodldrsciic2xu23r66dnt3ozzm@7k7nw22ek5iv>
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
 <20230701063947.3422088-12-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230701063947.3422088-12-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 01, 2023 at 09:39:41AM +0300, Arseniy Krasnov wrote:
>Add 'msgzerocopy_allow()' callback for virtio transport.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> Changelog:
> v4 -> v5:
>  * Move 'msgzerocopy_allow' right after seqpacket callbacks.
>
> net/vmw_vsock/virtio_transport.c | 7 +++++++
> 1 file changed, 7 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 6cbb45bb12d2..8d3e9f441fa1 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -441,6 +441,11 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
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
>@@ -474,6 +479,8 @@ static struct virtio_transport virtio_transport = {
> 		.seqpacket_allow          = virtio_transport_seqpacket_allow,
> 		.seqpacket_has_data       = virtio_transport_seqpacket_has_data,
>
>+		.msgzerocopy_allow        = virtio_transport_msgzerocopy_allow,
>+
> 		.notify_poll_in           = virtio_transport_notify_poll_in,
> 		.notify_poll_out          = virtio_transport_notify_poll_out,
> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>-- 
>2.25.1
>

