Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAE4544618
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 10:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbiFIIhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 04:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbiFIIhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 04:37:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4C16D33E17
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 01:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654763871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=694gobC9lwyLqW5J3peoYMEWnd+AT+IRtqYjzog1lRg=;
        b=PcLHF1oftXOyIZ/cRVnIReAJEKI784DkRIbZDe97ZfB8cGcK20kYPpKa6BFAU+QMg5tRxo
        5q/a2H6SZh/JnflcwYBnyTvpTvbl1gUmr0F0UTLNheYXwWEk9YhgEr+fse705Hcm7Oj90Y
        wtRKtgz7+HNy6QSegmkB+5AShLVRYBk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-ITKA_GAyP4Cx7DfdKYKIkA-1; Thu, 09 Jun 2022 04:37:50 -0400
X-MC-Unique: ITKA_GAyP4Cx7DfdKYKIkA-1
Received: by mail-wr1-f69.google.com with SMTP id v4-20020adfebc4000000b002102c69be5eso5308772wrn.13
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 01:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=694gobC9lwyLqW5J3peoYMEWnd+AT+IRtqYjzog1lRg=;
        b=bBR0Ea7ybhcUSTB2VFYkUXYPJQngH9U61nBL870c3hKdgLco8c7L8ErJttj6E8IQnj
         s5tBjzwlsajLS8ZHySwGYuThnI0Afg82qOtkngSuL0E5MBUyf0YttPNcAaif4PwKjdly
         mR+g6GuxTDjFBDV9KoOIU995op+ihSK8APeBE79rwvQWFTBiyLI5WolEytA/dtu7yHsi
         vOxMrGZzvuQrao3ZnLBQd3b6t4nyxjTqRhOM+Iz6Sb/N1SiEPcU0tieX8c/GTcXbqghB
         S1KCeBYDEGByFvUOtocTJIRyYX5ofUdI0cW+x4+gRTMEsnnZ36OXFk9epcU6q5R46ns3
         5exQ==
X-Gm-Message-State: AOAM532CGOHCZpvwb/KW1DXr2MgF/2YN4A2C7K6jBSubV7F9LThpqRZw
        teAx7LTUjSXyB7gg9V9OB4VZ++f2W7jbhVE0hEvRcBtdZcqg8jYWR7igp7/2zz83qwADasa/VJ1
        gIdH65QwqglaB
X-Received: by 2002:a5d:4b90:0:b0:210:2b99:3862 with SMTP id b16-20020a5d4b90000000b002102b993862mr35493369wrt.586.1654763869332;
        Thu, 09 Jun 2022 01:37:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwiqT3Yvpq9pYGfhjPxNPxWZqR6y14eJJY0ZyXFqShFrcIt83mK03m0/3Oo0tgjuYoxDJ5vA==
X-Received: by 2002:a5d:4b90:0:b0:210:2b99:3862 with SMTP id b16-20020a5d4b90000000b002102b993862mr35493350wrt.586.1654763869063;
        Thu, 09 Jun 2022 01:37:49 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-40.retail.telecomitalia.it. [79.46.200.40])
        by smtp.gmail.com with ESMTPSA id h1-20020a5d4fc1000000b0020fc4cd81f6sm23434686wrw.60.2022.06.09.01.37.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 01:37:48 -0700 (PDT)
Date:   Thu, 9 Jun 2022 10:37:45 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>,
        Krasnov Arseniy <oxffffaa@gmail.com>
Subject: Re: [RFC PATCH v2 1/8] virtio/vsock: rework packet allocation logic
Message-ID: <20220609083745.hgqzaq6i7s4u2cgx@sgarzare-redhat>
References: <e37fdf9b-be80-35e1-ae7b-c9dfeae3e3db@sberdevices.ru>
 <78157286-3663-202f-da94-1a17e4ffe819@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <78157286-3663-202f-da94-1a17e4ffe819@sberdevices.ru>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03, 2022 at 05:31:00AM +0000, Arseniy Krasnov wrote:
>To support zerocopy receive, packet's buffer allocation
>is changed: for buffers which could be mapped to user's
>vma we can't use 'kmalloc()'(as kernel restricts to map
>slab pages to user's vma) and raw buddy allocator now
>called. But, for tx packets(such packets won't be mapped
>to user), previous 'kmalloc()' way is used, but with special
>flag in packet's structure which allows to distinguish
>between 'kmalloc()' and raw pages buffers.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/linux/virtio_vsock.h            | 1 +
> net/vmw_vsock/virtio_transport.c        | 8 ++++++--
> net/vmw_vsock/virtio_transport_common.c | 9 ++++++++-
> 3 files changed, 15 insertions(+), 3 deletions(-)

Each patch should as much as possible work to not break the 
bisectability, and here we are not touching vhost_vsock_alloc_pkt() that 
uses kmalloc to allocate the buffer.

I see you updated it in the next patch, that should be fine, but here 
you should set slab_buf in vhost_vsock_alloc_pkt(), or you can merge the 
two patches.

>
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 35d7eedb5e8e..d02cb7aa922f 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -50,6 +50,7 @@ struct virtio_vsock_pkt {
> 	u32 off;
> 	bool reply;
> 	bool tap_delivered;
>+	bool slab_buf;
> };
>
> struct virtio_vsock_pkt_info {
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index ad64f403536a..19909c1e9ba3 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -255,16 +255,20 @@ static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
> 	vq = vsock->vqs[VSOCK_VQ_RX];
>
> 	do {
>+		struct page *buf_page;
>+
> 		pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
> 		if (!pkt)
> 			break;
>
>-		pkt->buf = kmalloc(buf_len, GFP_KERNEL);
>-		if (!pkt->buf) {
>+		buf_page = alloc_page(GFP_KERNEL);
>+
>+		if (!buf_page) {
> 			virtio_transport_free_pkt(pkt);
> 			break;
> 		}
>
>+		pkt->buf = page_to_virt(buf_page);
> 		pkt->buf_len = buf_len;
> 		pkt->len = buf_len;
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index ec2c2afbf0d0..278567f748f2 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -69,6 +69,7 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
> 		if (!pkt->buf)
> 			goto out_pkt;
>
>+		pkt->slab_buf = true;
> 		pkt->buf_len = len;
>
> 		err = memcpy_from_msg(pkt->buf, info->msg, len);
>@@ -1342,7 +1343,13 @@ EXPORT_SYMBOL_GPL(virtio_transport_recv_pkt);
>
> void virtio_transport_free_pkt(struct virtio_vsock_pkt *pkt)
> {
>-	kfree(pkt->buf);
>+	if (pkt->buf_len) {
>+		if (pkt->slab_buf)
>+			kfree(pkt->buf);
>+		else
>+			free_pages(buf, get_order(pkt->buf_len));
>+	}
>+
> 	kfree(pkt);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_free_pkt);
>-- 
>2.25.1

