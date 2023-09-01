Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC10D78FD5E
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 14:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349491AbjIAMhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 08:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbjIAMhs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 08:37:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE647E7B
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 05:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693571820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j4h0vgqDbXZ9cKpY1IY0NrIgMllN6xWh52Qc3BdpfdQ=;
        b=fH9rtLuMJfFJPbaQtiWW86rfh4Ue45kcl5kiushrWShaP98sezZeEYzIF/FNmRUhaOjEaV
        v3HEWk876Rre0yk5vsz0p4UZTl3GN3Dm6S+Jbp7VAyT8mBqw4XX9/V0HvpMo6LIPiAcDb3
        nDLJ4Fs+O/hh3ZS7Vu3wvihHwD4yOhY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-2uaGM7IRPx2m6YlBrkvosA-1; Fri, 01 Sep 2023 08:36:59 -0400
X-MC-Unique: 2uaGM7IRPx2m6YlBrkvosA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-993c2d9e496so133199766b.0
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 05:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693571818; x=1694176618;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j4h0vgqDbXZ9cKpY1IY0NrIgMllN6xWh52Qc3BdpfdQ=;
        b=WyVgce5ITb3HaseMoqXRUY6/Tjk9BE9x35xJZu8bRYkcd4rjPodGJYqNxdUCRo9ljE
         lpKxZlcgDUJRPlWjwx8X2YW7AKJORIkc25+xKSFvq/Akm1igiETF19YrroVkYYn1bAg2
         M95NkLmfsN/Ab4DsZrk2HmEF0Yp8NY+N+Tqc75wfgKSr02Z9gnqdaO1Rkwj+K8rk1NhC
         AXkm77rtyz7y9MbNDYRyDcqXk570LHH6vSkLXAnfR9ZN439ryU3t284IPWWKe+HFKyWx
         col73C29S0KAHaGI/LnzBz9btL1OIxRHWKulpcrdb94Nhx4NvPut6d7PGyvun4V5+nYy
         WJ8A==
X-Gm-Message-State: AOJu0Yw9mLHlCzuOPxdR7hhKIbvflITgEUdTkqL67sDcfUJRxHqgMVrk
        4IhwVDJghJmNJ84N9CcERnWUUyofICCENXH7ZjBeLvKfSDXCBprzcAkAE4bsX3MsaR4OE1H1wqN
        GpYn8G6UrM96A
X-Received: by 2002:a17:906:113:b0:99b:4a29:fb6a with SMTP id 19-20020a170906011300b0099b4a29fb6amr1706303eje.59.1693571818102;
        Fri, 01 Sep 2023 05:36:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnc7ku06Rb323HLHpbRqxeg5/4zOqE3MmS5rXNzpID4yPpYKwGJsgULx/Y2zOMng08MkVbQg==
X-Received: by 2002:a17:906:113:b0:99b:4a29:fb6a with SMTP id 19-20020a170906011300b0099b4a29fb6amr1706279eje.59.1693571817799;
        Fri, 01 Sep 2023 05:36:57 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id tk26-20020a170907c29a00b009a1082f423esm1880381ejc.88.2023.09.01.05.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 05:36:57 -0700 (PDT)
Date:   Fri, 1 Sep 2023 14:36:55 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@salutedevices.com>
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
Subject: Re: [PATCH net-next v7 2/4] vsock/virtio: support to send non-linear
 skb
Message-ID: <goakwa53hmon4aspdrjv3vrimy2b4sbv3unjwzhvn5fv5w7eqo@lvugg3vlrwga>
References: <20230827085436.941183-1-avkrasnov@salutedevices.com>
 <20230827085436.941183-3-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230827085436.941183-3-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 27, 2023 at 11:54:34AM +0300, Arseniy Krasnov wrote:
>For non-linear skb use its pages from fragment array as buffers in
>virtio tx queue. These pages are already pinned by 'get_user_pages()'
>during such skb creation.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v2 -> v3:
>  * Comment about 'page_to_virt()' is updated. I don't remove R-b,
>    as this change is quiet small I guess.
> v6 -> v7:
>  * Move arrays '*sgs' and 'bufs' to 'virtio_vsock' instead of being
>    local variables. This allows to save stack space in cases of too
>    big MAX_SKB_FRAGS.
>  * Add 'WARN_ON_ONCE()' for handling nonlinear skbs - it checks that
>    linear part of such skb contains only header.
>  * R-b tag removed due to updates above.
>
> net/vmw_vsock/virtio_transport.c | 54 +++++++++++++++++++++++++++-----
> 1 file changed, 47 insertions(+), 7 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index e95df847176b..8636477cf088 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -63,6 +63,10 @@ struct virtio_vsock {
>
> 	u32 guest_cid;
> 	bool seqpacket_allow;
>+

I'd add a comment here specifying specifying what we need these fields
for and why we put them here (basically Paolo's suggestion).

>+	/* +1 is for packet header. */
>+	struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
>+	struct scatterlist bufs[MAX_SKB_FRAGS + 1];
> };
>
> static u32 virtio_transport_get_local_cid(void)
>@@ -100,8 +104,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> 	vq = vsock->vqs[VSOCK_VQ_TX];
>
> 	for (;;) {
>-		struct scatterlist hdr, buf, *sgs[2];
> 		int ret, in_sg = 0, out_sg = 0;
>+		struct scatterlist **sgs;
>+		struct scatterlist *bufs;
> 		struct sk_buff *skb;
> 		bool reply;
>
>@@ -111,12 +116,47 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>
> 		virtio_transport_deliver_tap_pkt(skb);
> 		reply = virtio_vsock_skb_reply(skb);
>-
>-		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>-		sgs[out_sg++] = &hdr;
>-		if (skb->len > 0) {
>-			sg_init_one(&buf, skb->data, skb->len);
>-			sgs[out_sg++] = &buf;
>+		sgs = vsock->sgs;
>+		bufs = vsock->bufs;
>+		sg_init_one(&bufs[out_sg], virtio_vsock_hdr(skb),
>+			    sizeof(*virtio_vsock_hdr(skb)));
>+		sgs[out_sg] = &bufs[out_sg];

IIUC `sgs[i]` always contains `&bufs[i]`.

Could we initialize it once when we allocate `struct virtio_vsock` in
`virtio_vsock_probe`?

Of course putting a comment in `struct virtio_vsock` about it.

Since we are using them only for out buffers, I'd also rename them in
out_sgs and out_bufs.

The rest LGTM.

Stefano

>+		out_sg++;
>+
>+		if (!skb_is_nonlinear(skb)) {
>+			if (skb->len > 0) {
>+				sg_init_one(&bufs[out_sg], skb->data, skb->len);
>+				sgs[out_sg] = &bufs[out_sg];
>+				out_sg++;
>+			}
>+		} else {
>+			struct skb_shared_info *si;
>+			int i;
>+
>+			/* If skb is nonlinear, then its buffer must contain
>+			 * only header and nothing more. Data is stored in
>+			 * the fragged part.
>+			 */
>+			WARN_ON_ONCE(skb_headroom(skb) != sizeof(*virtio_vsock_hdr(skb)));
>+
>+			si = skb_shinfo(skb);
>+
>+			for (i = 0; i < si->nr_frags; i++) {
>+				skb_frag_t *skb_frag = &si->frags[i];
>+				void *va;
>+
>+				/* We will use 'page_to_virt()' for the userspace page
>+				 * here, because virtio or dma-mapping layers will call
>+				 * 'virt_to_phys()' later to fill the buffer descriptor.
>+				 * We don't touch memory at "virtual" address of this page.
>+				 */
>+				va = page_to_virt(skb_frag->bv_page);
>+				sg_init_one(&bufs[out_sg],
>+					    va + skb_frag->bv_offset,
>+					    skb_frag->bv_len);
>+				sgs[out_sg] = &bufs[out_sg];
>+				out_sg++;
>+			}
> 		}
>
> 		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
>-- 
>2.25.1
>

