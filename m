Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E663B74A2A3
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 18:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbjGFQ4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 12:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbjGFQ4J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 12:56:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52B6171D
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 09:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688662533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pOCS7eTE+RzvcUp/IElOID7dnpR7b6985yidue+c0zc=;
        b=KBbTleLwCi44oZV80eecZS2lJorpFI7e7rBEI3v5QzxnS8N4AqZZYIGRc5KiAbQG+VowYf
        RobKLbKcwnNg9T390BpLN3hUxIAsE/EtXUdYuS7hy7pwjfYHwYV7BagjBBXGZ7mQKkSJoj
        Rfzu+wGFT2is0EAq6b037oowOibqfxw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-yfakiRFHOJ25f3s8TU3WYg-1; Thu, 06 Jul 2023 12:55:30 -0400
X-MC-Unique: yfakiRFHOJ25f3s8TU3WYg-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-992e68297bcso65498466b.3
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 09:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688662528; x=1691254528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pOCS7eTE+RzvcUp/IElOID7dnpR7b6985yidue+c0zc=;
        b=Tt9+8O/xBuvGny05S1EyYby911aHbYlMDoe3ZqzharqfCjqTep+uwSUy2agLa0w1kv
         /pIQndNn7rwVQGDFlNbKPB4FN1rqvYFrZ3RinIw+g9k6RAK/58ROmuZh8Jjs4K+ZWd1N
         U08JY39lrX33g4llckY7pNh8b2F9rGoonuV1+OG3fS27+RvNWZfj3bhkv1uI05sHVTqK
         7b4SbGx5F++MrQ/oGFaj38XQLTejgVcajNJlOwE+JQ8Rbtg6ucbjS1dGJ6iU3t9/rUBI
         N9rEn4XYyI87g4tgkfn8IOq9UcMcNdOnLpnKq/gASH6s748Z5EJ6njl8GrXX32o1gHdv
         CJRA==
X-Gm-Message-State: ABy/qLb2mpNy8YlKnPNWa3dS4elHNmxTVGP/+3f4fkMGScSnRuVqxsUW
        294fIxxj1jhceA2Dm60E3vu6+S2utLCWRpdjFq46//2OBsLImFDroBrKU4hjMZ7oVhX+WPDwC6t
        k6lqC5/Mh/Ac4
X-Received: by 2002:a17:906:72d9:b0:978:6e73:e837 with SMTP id m25-20020a17090672d900b009786e73e837mr1868717ejl.4.1688662527916;
        Thu, 06 Jul 2023 09:55:27 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEvgZQm6ryvcWo+UUSqeryd0MPNi4F0BgqwURSiTTNmtxQQXekVmYt8i1lFjJmIZa8T3HBYkg==
X-Received: by 2002:a17:906:72d9:b0:978:6e73:e837 with SMTP id m25-20020a17090672d900b009786e73e837mr1868706ejl.4.1688662527647;
        Thu, 06 Jul 2023 09:55:27 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-163.retail.telecomitalia.it. [79.46.200.163])
        by smtp.gmail.com with ESMTPSA id u20-20020a17090617d400b009829d2e892csm1060449eje.15.2023.07.06.09.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 09:55:27 -0700 (PDT)
Date:   Thu, 6 Jul 2023 18:55:25 +0200
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
Subject: Re: [RFC PATCH v5 10/17] vhost/vsock: support MSG_ZEROCOPY for
 transport
Message-ID: <3y3emmciqa5ymphc3n5nw3infyiuty65ia7i4movyfmq7rodqb@cethro3rcyf6>
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
 <20230701063947.3422088-11-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230701063947.3422088-11-AVKrasnov@sberdevices.ru>
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

On Sat, Jul 01, 2023 at 09:39:40AM +0300, Arseniy Krasnov wrote:
>Add 'msgzerocopy_allow()' callback for vhost transport.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> Changelog:
> v4 -> v5:
>  * Move 'msgzerocopy_allow' right after seqpacket callbacks.
>
> drivers/vhost/vsock.c | 7 +++++++
> 1 file changed, 7 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index cb00e0e059e4..3fd0ab0c0edc 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -398,6 +398,11 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
> 	return val < vq->num;
> }
>
>+static bool vhost_transport_msgzerocopy_allow(void)
>+{
>+	return true;
>+}
>+
> static bool vhost_transport_seqpacket_allow(u32 remote_cid);
>
> static struct virtio_transport vhost_transport = {
>@@ -431,6 +436,8 @@ static struct virtio_transport vhost_transport = {
> 		.seqpacket_allow          = vhost_transport_seqpacket_allow,
> 		.seqpacket_has_data       = virtio_transport_seqpacket_has_data,
>
>+		.msgzerocopy_allow        = vhost_transport_msgzerocopy_allow,
>+
> 		.notify_poll_in           = virtio_transport_notify_poll_in,
> 		.notify_poll_out          = virtio_transport_notify_poll_out,
> 		.notify_recv_init         = virtio_transport_notify_recv_init,
>-- 
>2.25.1
>

