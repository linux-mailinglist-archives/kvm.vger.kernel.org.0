Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5820E74A278
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 18:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbjGFQu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 12:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjGFQu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 12:50:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554F71FDD
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 09:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688662152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gJektsoy0misgOoLPFYa4+3boQJ8dt+dK5kdqOR27mc=;
        b=aGYc0LVgnsTlZ3zLww9ck3SK0WI03d3LzohrpbpDVUWVDn1Jos06olBKK1OjHgqQhKWllR
        YpdxYJHOfZVQOw74NKSAakWsOW2J94AKPXYbWO+Sv8rgQWg96PxPOEIW5NWa0ymhLZ1OIL
        iL0ggFmQDuBe67+E4cOVK38m8Gi8y5Y=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-ZJrVtG2POzWNUEwOqb111Q-1; Thu, 06 Jul 2023 12:49:10 -0400
X-MC-Unique: ZJrVtG2POzWNUEwOqb111Q-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-987a0365f77so62805566b.1
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 09:49:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688662150; x=1691254150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gJektsoy0misgOoLPFYa4+3boQJ8dt+dK5kdqOR27mc=;
        b=fuW12szjq29OfeaYjbjm4db9CroSsaCs0ArOnhFfZTiF/510zMdzth+NNYfAQYoi79
         1GGb/1yBDJXJLChdhyw+oqKSqQXBgfUMpJlOwP5GjwbxSe5f6yiWr8fnYNa6qkWlaH6W
         FSyFohLTn8BinJ5n/WBdB6m0mI/xGLmJXzp3daRpiR9QYdK298kv2YOeuF7C4dY54aeW
         r3HugDBRRbgGTEKwfnH1//KY8qxkNJVmesbKGDCjO2jCkXz52/8rjg7V0laWZ/M+oTcY
         PCC6qdIAbM/LSXi410ApK4PMffJHWsTlBF+OLb+I2+c5dqpUP7lQCmF6J3fiF+P/+utS
         jV/A==
X-Gm-Message-State: ABy/qLZVEJBFnkNqVp6O3em5z3Zbq47MD4Bxj2k9Slz12WQhNZGWq8NW
        VOKMvaEkt1NFTMLx5hVBobxYgK+BdBFJcEB6cvdcs8fHFKcMVRfXkIHNwmSyKk+1cuADnEdrtGR
        S7fS2yp3zvLd3
X-Received: by 2002:a17:907:a07c:b0:96a:2acf:61e1 with SMTP id ia28-20020a170907a07c00b0096a2acf61e1mr2160900ejc.64.1688662149877;
        Thu, 06 Jul 2023 09:49:09 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEMy+yG5KRW2pkXS6lw2Ew3M/i1KwRrsz6O8/7lmajYiW6fkNqwbOfOSxce1oyo/cRPsTA5HA==
X-Received: by 2002:a17:907:a07c:b0:96a:2acf:61e1 with SMTP id ia28-20020a170907a07c00b0096a2acf61e1mr2160884ejc.64.1688662149602;
        Thu, 06 Jul 2023 09:49:09 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-163.retail.telecomitalia.it. [79.46.200.163])
        by smtp.gmail.com with ESMTPSA id s6-20020a170906454600b00992c92af6f4sm1039367ejq.144.2023.07.06.09.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 09:49:09 -0700 (PDT)
Date:   Thu, 6 Jul 2023 18:49:06 +0200
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
Subject: Re: [RFC PATCH v5 02/17] vhost/vsock: read data from non-linear skb
Message-ID: <cgq3d3j25doy7qar6xsepsrly5ypyjwahf2gybfi3fnozp3kjx@hh5q5bps37ws>
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
 <20230701063947.3422088-3-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230701063947.3422088-3-AVKrasnov@sberdevices.ru>
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

On Sat, Jul 01, 2023 at 09:39:32AM +0300, Arseniy Krasnov wrote:
>This adds copying to guest's virtio buffers from non-linear skbs. Such
>skbs are created by protocol layer when MSG_ZEROCOPY flags is used. It
>replaces call of 'copy_to_iter()' to 'skb_copy_datagram_iter()'- second
>function can read data from non-linear skb. Also this patch uses field
>'frag_off' from skb control block. This field shows current offset to
>read data from skb which could be both linear or not.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> Changelog:
> v4 -> v5:
>  * Use local variable for 'frag_off'.
>  * Update commit message by adding some details about 'frag_off' field.
>  * R-b from Bobby Eshleman removed due to patch update.

I think we should merge this patch with the previous one, since
vhost-vsock for example uses virtio_transport_stream_do_dequeue()
that we change in the previous commit, so we will break the bisection.

The patch LGTM!

Stefano

>
> drivers/vhost/vsock.c | 14 +++++++++-----
> 1 file changed, 9 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 6578db78f0ae..cb00e0e059e4 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -114,6 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		struct sk_buff *skb;
> 		unsigned out, in;
> 		size_t nbytes;
>+		u32 frag_off;
> 		int head;
>
> 		skb = virtio_vsock_skb_dequeue(&vsock->send_pkt_queue);
>@@ -156,7 +157,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		}
>
> 		iov_iter_init(&iov_iter, ITER_DEST, &vq->iov[out], in, iov_len);
>-		payload_len = skb->len;
>+		frag_off = VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
>+		payload_len = skb->len - frag_off;
> 		hdr = virtio_vsock_hdr(skb);
>
> 		/* If the packet is greater than the space available in the
>@@ -197,8 +199,10 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 			break;
> 		}
>
>-		nbytes = copy_to_iter(skb->data, payload_len, &iov_iter);
>-		if (nbytes != payload_len) {
>+		if (skb_copy_datagram_iter(skb,
>+					   frag_off,
>+					   &iov_iter,
>+					   payload_len)) {
> 			kfree_skb(skb);
> 			vq_err(vq, "Faulted on copying pkt buf\n");
> 			break;
>@@ -212,13 +216,13 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 		vhost_add_used(vq, head, sizeof(*hdr) + payload_len);
> 		added = true;
>
>-		skb_pull(skb, payload_len);
>+		VIRTIO_VSOCK_SKB_CB(skb)->frag_off += payload_len;
> 		total_len += payload_len;
>
> 		/* If we didn't send all the payload we can requeue the packet
> 		 * to send it with the next available buffer.
> 		 */
>-		if (skb->len > 0) {
>+		if (VIRTIO_VSOCK_SKB_CB(skb)->frag_off < skb->len) {
> 			hdr->flags |= cpu_to_le32(flags_to_restore);
>
> 			/* We are queueing the same skb to handle
>-- 
>2.25.1
>

