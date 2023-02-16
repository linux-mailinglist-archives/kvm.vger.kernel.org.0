Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBBD699712
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjBPOT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjBPOTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:19:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D6593C3
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676557143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pchzyi+iGSx4x4FUy9UsNRB/fTEcGnGSHaYZsjr+hLc=;
        b=XoPKYFhoHfI6N26kj0JoQveaX/HNnEFqoM9JpCATC93jVFp6LsGQZ9NTMW2RY6JRauZuRu
        QBBiiSQOPrsxuC3Ph4ud9D6aCwPQicIJAsTwN8b0d3GR4NmB8ARjhQH1LJcWgaXp9QPThu
        pdA9SRpCiu9lFZXWxJhHbtA7w8kUoRM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-107-Kp6TvyiqPq6JR7eyn8UQVA-1; Thu, 16 Feb 2023 09:19:02 -0500
X-MC-Unique: Kp6TvyiqPq6JR7eyn8UQVA-1
Received: by mail-qv1-f72.google.com with SMTP id pv24-20020ad45498000000b0056ea549d728so1144129qvb.10
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:19:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pchzyi+iGSx4x4FUy9UsNRB/fTEcGnGSHaYZsjr+hLc=;
        b=TyEc0ebkFDS5npofNnP+qxjmTgmaHvo+zHDEvn8k1UioQ+jrBhYEyijMeBGLl+3k2T
         Wa8tmskX7+j38JzUt9e4fUINOR/rXILZrFAPGgv8CPvC8/DO6/h6uLPypB22D0gg9Z4V
         BbiyJeTV6seO8SPkFlE2/o7XiinG7uGwzrMeAPTU5/1JV6egyqiyQ/mCgnBG2t04ZEES
         9U41S2/3aahwnDK3a1i5LCPPw9a2ffuxn9OFYBNUOh8uoeAWEYNLzJnaOy+cNh89THc4
         pwhGIqDA4TAJ8r8V3V+seaJA1ny7Yd1rRw1mqjN8U3vjw8Qdg2azffVCIhjb2l8jSkU4
         iacw==
X-Gm-Message-State: AO0yUKXc8PHLGlFAir7wWB5mgrjcIzjMA8XvtNIinRxZiauTvGX1bd1G
        Vfz176QdbRfQHRpEALZa7Wm6+qbkQx6FyJ5lNlH1ZcMidqsShH9u7qOoVnjqI/dskFebl7llrg+
        KyA+JKMbIucBL
X-Received: by 2002:a05:622a:1492:b0:3b8:52b6:a313 with SMTP id t18-20020a05622a149200b003b852b6a313mr11672821qtx.30.1676557142031;
        Thu, 16 Feb 2023 06:19:02 -0800 (PST)
X-Google-Smtp-Source: AK7set+fxS4JhBoepOcXeUJoLRmfP/igXjolczTeDHypWOV4T3CC6+zz+5nMobryi+/8kbpvaTg/2g==
X-Received: by 2002:a05:622a:1492:b0:3b8:52b6:a313 with SMTP id t18-20020a05622a149200b003b852b6a313mr11672776qtx.30.1676557141742;
        Thu, 16 Feb 2023 06:19:01 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id 205-20020a370ad6000000b0073b76f9409csm1278267qkk.14.2023.02.16.06.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 06:19:01 -0800 (PST)
Date:   Thu, 16 Feb 2023 15:18:56 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 05/12] vsock/virtio: non-linear skb support
Message-ID: <20230216141856.fnczv3ui6d3lpujy@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <b3060caf-df19-f1df-6d27-4e58f894c417@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b3060caf-df19-f1df-6d27-4e58f894c417@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 06:58:24AM +0000, Arseniy Krasnov wrote:
>Use pages of non-linear skb as buffers in virtio tx queue.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport.c | 31 +++++++++++++++++++++++++------
> 1 file changed, 25 insertions(+), 6 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 28b5a8e8e094..b8a7d6dc9f46 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -100,7 +100,8 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> 	vq = vsock->vqs[VSOCK_VQ_TX];
>
> 	for (;;) {
>-		struct scatterlist hdr, buf, *sgs[2];
>+		struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
>+		struct scatterlist bufs[MAX_SKB_FRAGS + 1];

+ 1 is for the header, right?
I'd add a comment just to be clear ;-)

> 		int ret, in_sg = 0, out_sg = 0;
> 		struct sk_buff *skb;
> 		bool reply;
>@@ -111,12 +112,30 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>
> 		virtio_transport_deliver_tap_pkt(skb);
> 		reply = virtio_vsock_skb_reply(skb);
>+		sg_init_one(&bufs[0], virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>+		sgs[out_sg++] = &bufs[0];
>+
>+		if (skb_is_nonlinear(skb)) {
>+			int i;
>+
>+			for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
>+				struct page *data_page = skb_shinfo(skb)->frags[i].bv_page;
>+
>+				/* We will use 'page_to_virt()' for userspace page here,
>+				 * because virtio layer will call 'virt_to_phys()' later
>+				 * to fill buffer descriptor. We don't touch memory at
>+				 * "virtual" address of this page.
>+				 */

IIUC data_page is a user page, so since we are exposing it to the host,
I think we should pin it.

Is data_page always a user page, or can it be a kernel page when skb is 
nonlinear?

Thanks,
Stefano

>+				sg_init_one(&bufs[i + 1],
>+					    page_to_virt(data_page), PAGE_SIZE);
>+				sgs[out_sg++] = &bufs[i + 1];
>+			}
>+		} else {
>+			if (skb->len > 0) {
>+				sg_init_one(&bufs[1], skb->data, skb->len);
>+				sgs[out_sg++] = &bufs[1];
>+			}
>
>-		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>-		sgs[out_sg++] = &hdr;
>-		if (skb->len > 0) {
>-			sg_init_one(&buf, skb->data, skb->len);
>-			sgs[out_sg++] = &buf;
> 		}
>
> 		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
>-- 
>2.25.1

