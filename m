Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD9C774A282
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 18:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjGFQwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 12:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjGFQwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 12:52:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485D81FCC
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 09:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688662267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2lY92+ddtv43Js0GKJTCX1QniXKfhiDq46fV1jZcI+8=;
        b=Bj0ucICt/onfvxHKN45HfGrBZ5E6VLStsuFldGwzIHoXeclm114G+PGN44R3IE4pIEqQeP
        zS8BEAxXPb82tyuQlTJC3qXuJcnWdkLisnnqqTL/MtzsawbyEIFxRDKMev1/n620pasEdM
        mpkCVqPOTVk2rsmdt2cvzvlaH/E6WF8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-483-p3uE7VuDNzWTgFeA2r-B8A-1; Thu, 06 Jul 2023 12:51:06 -0400
X-MC-Unique: p3uE7VuDNzWTgFeA2r-B8A-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9835bf83157so63435066b.2
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 09:51:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688662265; x=1691254265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2lY92+ddtv43Js0GKJTCX1QniXKfhiDq46fV1jZcI+8=;
        b=WAygeunXkuNwhqtWKvF2z5bXoVsZrVkgaTsqqfS7pk0f7tRzSwD6A2sJ5YlKNW2fdA
         FA+ChijQomv1j/NNoiU0Y+U6KbLX3CLFqX5pT6Lr47Z5gOhAuiQPw8yeIeTzbSMfH/Jm
         1wmkyAYbfb/wJQ7+5kHlYTxcFPwUgp4tiyhAIzPtY5d8MGRjoR6tacuWccCBlIY3j06m
         U3HRXO0d7Kel2BucY113YdFLuVhJ8ZZjedF4LpbYr/t8d09k/eKgneB4SNRJvn8xJMnO
         JFby+aMIGSyy3fnDEOXIn053QkYg60uCWcQwTgBVd2ExIaLeqU00Z+X31s0Kz8S6EtcH
         lH6g==
X-Gm-Message-State: ABy/qLbtZkFf7t/td2fFr4avqauX4BNR7wl/0hi5X1OjwxC+pJdrbxgV
        F5JoA6hqlVxaMgfNll7he0pVeLbmprNS+3x1DdK5Z1hjBEysKAWvznHArPBkjiHiL6GqYhmt2OI
        fQ1kQzZ06jdGm
X-Received: by 2002:a17:906:7046:b0:992:b9f4:85db with SMTP id r6-20020a170906704600b00992b9f485dbmr1815343ejj.39.1688662264980;
        Thu, 06 Jul 2023 09:51:04 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGqgmU14xEa56II5zxLyRGIPXThOhEyLQmB+kMCm8D12EMDJhS0ZJLYiNGRDuHhor0mACYvpg==
X-Received: by 2002:a17:906:7046:b0:992:b9f4:85db with SMTP id r6-20020a170906704600b00992b9f485dbmr1815324ejj.39.1688662264645;
        Thu, 06 Jul 2023 09:51:04 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-163.retail.telecomitalia.it. [79.46.200.163])
        by smtp.gmail.com with ESMTPSA id s24-20020a170906169800b0096f7500502csm1023286ejd.199.2023.07.06.09.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 09:51:04 -0700 (PDT)
Date:   Thu, 6 Jul 2023 18:51:01 +0200
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
Subject: Re: [RFC PATCH v5 03/17] vsock/virtio: support to send non-linear skb
Message-ID: <joml4wolu5r2wpetvbfezu6buwfnfntu5okxjacfgdsp7uaebk@onkmwg7r7fod>
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
 <20230701063947.3422088-4-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230701063947.3422088-4-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 01, 2023 at 09:39:33AM +0300, Arseniy Krasnov wrote:
>For non-linear skb use its pages from fragment array as buffers in
>virtio tx queue. These pages are already pinned by 'get_user_pages()'
>during such skb creation.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> Changelog:
> v4 -> v5:
>  * Use 'out_sgs' variable to index 'bufs', not only 'sgs'.
>  * Move smaller branch above, see 'if (!skb_is_nonlinear(skb)').
>  * Remove blank line.
>  * R-b from Bobby Eshleman removed due to patch update.
>
> net/vmw_vsock/virtio_transport.c | 40 +++++++++++++++++++++++++++-----
> 1 file changed, 34 insertions(+), 6 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index e95df847176b..6cbb45bb12d2 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -100,7 +100,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> 	vq = vsock->vqs[VSOCK_VQ_TX];
>
> 	for (;;) {
>-		struct scatterlist hdr, buf, *sgs[2];
>+		/* +1 is for packet header. */
>+		struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
>+		struct scatterlist bufs[MAX_SKB_FRAGS + 1];
> 		int ret, in_sg = 0, out_sg = 0;
> 		struct sk_buff *skb;
> 		bool reply;
>@@ -111,12 +113,38 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>
> 		virtio_transport_deliver_tap_pkt(skb);
> 		reply = virtio_vsock_skb_reply(skb);
>+		sg_init_one(&bufs[out_sg], virtio_vsock_hdr(skb),
>+			    sizeof(*virtio_vsock_hdr(skb)));
>+		sgs[out_sg] = &bufs[out_sg];
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
>+			si = skb_shinfo(skb);
>+
>+			for (i = 0; i < si->nr_frags; i++) {
>+				skb_frag_t *skb_frag = &si->frags[i];
>+				void *va = page_to_virt(skb_frag->bv_page);
>
>-		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>-		sgs[out_sg++] = &hdr;
>-		if (skb->len > 0) {
>-			sg_init_one(&buf, skb->data, skb->len);
>-			sgs[out_sg++] = &buf;
>+				/* We will use 'page_to_virt()' for userspace page here,
>+				 * because virtio layer will call 'virt_to_phys()' later
>+				 * to fill buffer descriptor. We don't touch memory at
>+				 * "virtual" address of this page.
>+				 */
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

