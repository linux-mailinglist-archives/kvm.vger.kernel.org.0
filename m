Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B2D760CCE
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 10:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjGYISy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 04:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjGYISv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 04:18:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9293E5C
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 01:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690273082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3yzqiXhC1UF6kcx0o3Qs1VmhKMD7xafUTqbIR8LZgYk=;
        b=UY/ETZbi8M0rGUo7espBkO0ribUT/9mwPiH2f24hxmc3iCPbBc/SCSdU+MHS/+3hfButYe
        qteO7ZAKL+2fwX75pBFdGt0hKgiC1bzUFSJjZu6cz/GUeOK/KdpieshUJRMYTOMQWIO9SX
        fMgiuIoxSRlIQXJhOxsrZ1xsLWQ0EOU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-haOsSGV3MXuPV62RQTPAEg-1; Tue, 25 Jul 2023 04:18:01 -0400
X-MC-Unique: haOsSGV3MXuPV62RQTPAEg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-314134f403fso2468113f8f.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 01:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690273080; x=1690877880;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3yzqiXhC1UF6kcx0o3Qs1VmhKMD7xafUTqbIR8LZgYk=;
        b=XPQuDMpYnLMAcTfBwfRBluNFlv7fYVcf4SV2CoPqDWrYkpV5f6J0XP2lUlns4HZbNB
         0LZkksWnCJBiYCn77Zg2rYycgUhyi4M0OFojfB0sccuGfsFPX973Mt4nXBMBgiSzZ36a
         jQ33KE/6wR7YxNcdlZRt6V5b5hsIsrnoxTyzi46mpS3jDv0xnEREtnGhVwAlO6wHzfxc
         i+xcWBBuYdvRmkGx3nAGo3mXaC33KdHnW4EA5lc8akJwL4MmS3Og2U2qNgYHub40uf5T
         6QLcT0mGFFj/1O9Qw16Ll8ilytEzphdeIXJEjoqwOlYsNqjjLEkhk7wvjRR3TYNVjqSz
         K49g==
X-Gm-Message-State: ABy/qLbC9clSq2fWwOyj39wVgq/TVaLS5RT1HcvvykWfkNxDFJb+I7nk
        7ansg5YFQrMN9WcFmhE4Ik2WdiMyDx3kdimSE/IeiFafRhWPQgKh0aIB0eD/XrbZU6eJ5dWlIRW
        +8UmbEkexgRhx
X-Received: by 2002:a5d:6507:0:b0:313:ef96:84c8 with SMTP id x7-20020a5d6507000000b00313ef9684c8mr8687888wru.67.1690273080448;
        Tue, 25 Jul 2023 01:18:00 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFPc/VAU250QGQYgpOMkW4RaBwKVZ3ddrW1YR4h8aiQOpLSV8Prs3MtGQBtJV+o8e48BrZ/aw==
X-Received: by 2002:a5d:6507:0:b0:313:ef96:84c8 with SMTP id x7-20020a5d6507000000b00313ef9684c8mr8687872wru.67.1690273080102;
        Tue, 25 Jul 2023 01:18:00 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.217.123])
        by smtp.gmail.com with ESMTPSA id j6-20020adfff86000000b0031274a184d5sm15506412wrr.109.2023.07.25.01.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 01:17:59 -0700 (PDT)
Date:   Tue, 25 Jul 2023 10:17:55 +0200
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
Subject: Re: [PATCH net-next v3 2/4] vsock/virtio: support to send non-linear
 skb
Message-ID: <5lemb27slnjt3hieixwa744ghzu6zj5fc3eimfng7a2ba7y2as@ueve2vn2cxpl>
References: <20230720214245.457298-1-AVKrasnov@sberdevices.ru>
 <20230720214245.457298-3-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230720214245.457298-3-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 21, 2023 at 12:42:43AM +0300, Arseniy Krasnov wrote:
>For non-linear skb use its pages from fragment array as buffers in
>virtio tx queue. These pages are already pinned by 'get_user_pages()'
>during such skb creation.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>---
> Changelog:
> v2 -> v3:
>  * Comment about 'page_to_virt()' is updated. I don't remove R-b,
>    as this change is quiet small I guess.

Ack!

Thanks,
Stefano

>
> net/vmw_vsock/virtio_transport.c | 41 +++++++++++++++++++++++++++-----
> 1 file changed, 35 insertions(+), 6 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index e95df847176b..7bbcc8093e51 100644
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
>@@ -111,12 +113,39 @@ virtio_transport_send_pkt_work(struct work_struct *work)
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
>+				void *va;
>
>-		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>-		sgs[out_sg++] = &hdr;
>-		if (skb->len > 0) {
>-			sg_init_one(&buf, skb->data, skb->len);
>-			sgs[out_sg++] = &buf;
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

