Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0565473E4C1
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbjFZQRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbjFZQPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:15:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD83BE58
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687796059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lAvdeHjRiEhExMf/8PkhS/lqlgbR8Yp8qV2L+W5RPMM=;
        b=RTWSUEM8agZMDdvszk286YZ2qBcZUR9jjtBLbetLdrLeUfQGTkuIkSD6Zviqy/ELf+w30Q
        Hm9X1uCT9CvcTCHAHBkoFx7cEVAZL4awmIKiFW7Og3FqLkj/D6hcik1eA7aDdryiK8RvKv
        MANG0/BNvXSSQtBFC/E/1GHTq5oiXI0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-xjiAKPD_M5Kbtd4nSuQATw-1; Mon, 26 Jun 2023 12:14:14 -0400
X-MC-Unique: xjiAKPD_M5Kbtd4nSuQATw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-765de3a3404so105524185a.2
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687796054; x=1690388054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lAvdeHjRiEhExMf/8PkhS/lqlgbR8Yp8qV2L+W5RPMM=;
        b=KD+p8WhNN95PThgylJm5nJwhXmWsx2vscHV6UywXA1Uedf/SuaD69dVvUyF080h65l
         l/++/vhkouz4g1qWXRa406hm70CkioJVyfoyghlr0hexX6ZQ1kVH6LNgPy2D1KwRqORv
         by74h0+do0WI9h53+Y9GylK3yVlYjQn4ZG8IIIqAU0oYTIOEchxNolksjg6GulvdSGFE
         /bUl0+roBxpkfXbO5zxCgtdw35pegMRvzND5IwGSo9/jC6ifpW7IaPTmxFk2Iud7cOjj
         TVs8qb1Tkq+lzhrGdM31LFCAxzwWf8EhqFKHm8dCVodpCE+deSj7GI7JY2gzDL43XXPS
         jQaA==
X-Gm-Message-State: AC+VfDwjGcBpiD6H4jeU/v//AiYS2/ABJCt/9i7ImSpLbPQI4PAZXBtW
        L2/SkTI/ctnwdoxFMH9gVAmeWlZCxrfOvmmZPZ5/pOsBnVCE5oix01q2p4SE/btfSlYXeJkdESK
        n5OGT0pW9k4Bk
X-Received: by 2002:a05:6214:4015:b0:62d:d6e4:7ccf with SMTP id kd21-20020a056214401500b0062dd6e47ccfmr31955500qvb.40.1687796054279;
        Mon, 26 Jun 2023 09:14:14 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6dcXj93WXuU6BFIJYyBOMHVPNnCeqXrPEQR3X/qVTsVAuQorwHM7WjdhifsJqsX7Lt2y/AjA==
X-Received: by 2002:a05:6214:4015:b0:62d:d6e4:7ccf with SMTP id kd21-20020a056214401500b0062dd6e47ccfmr31955480qvb.40.1687796054044;
        Mon, 26 Jun 2023 09:14:14 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id lw15-20020a05621457cf00b00626161ea7a3sm3349930qvb.2.2023.06.26.09.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 09:14:13 -0700 (PDT)
Date:   Mon, 26 Jun 2023 18:14:09 +0200
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
Subject: Re: [RFC PATCH v4 12/17] vsock/loopback: support MSG_ZEROCOPY for
 transport
Message-ID: <lex6l5suez7azhirt22lidndtjomkbagfbpvvi5p7c2t7klzas@4l2qly7at37c>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-13-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230603204939.1598818-13-AVKrasnov@sberdevices.ru>
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

On Sat, Jun 03, 2023 at 11:49:34PM +0300, Arseniy Krasnov wrote:
>Add 'msgzerocopy_allow()' callback for loopback transport.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/vsock_loopback.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index 5c6360df1f31..a2e4aeda2d92 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -47,6 +47,7 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
> }
>
> static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
>+static bool vsock_loopback_msgzerocopy_allow(void);

I don't know why we did this for `vsock_loopback_seqpacket_allow`, but
can we just put the implementation here?

>
> static struct virtio_transport loopback_transport = {
> 	.transport = {
>@@ -92,11 +93,18 @@ static struct virtio_transport loopback_transport = {
> 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
>
> 		.read_skb = virtio_transport_read_skb,
>+
>+		.msgzerocopy_allow        = vsock_loopback_msgzerocopy_allow,

Ditto the moving.

> 	},
>
> 	.send_pkt = vsock_loopback_send_pkt,
> };
>
>+static bool vsock_loopback_msgzerocopy_allow(void)
>+{
>+	return true;
>+}
>+
> static bool vsock_loopback_seqpacket_allow(u32 remote_cid)
> {
> 	return true;
>-- 
>2.25.1
>

