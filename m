Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1296C14C7
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 15:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjCTObP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 10:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjCTObB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 10:31:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865F9E1AD
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679322611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fYYltObAoBAJHBew4d0/wtXHVG5SadqFvZoyE4YqRs0=;
        b=VjeiY86gY6V/a7q4MQzdNx0ZZGDUTF3eKT1HhYx2C1+Hi7Bj3Mt+bZjETMmR0vM0kntQ60
        JFR3flXWJXtoRPZspRn8qIX3whNlfYB0jxBiW0jd9OGS+V2ALydV0ffGz0r9Eg3Csspf86
        oHBUaNitszyekh18qwl8TPNUCZCZYK8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-224-CQlthyh0N_yp__4Ybfx0tw-1; Mon, 20 Mar 2023 10:30:07 -0400
X-MC-Unique: CQlthyh0N_yp__4Ybfx0tw-1
Received: by mail-qk1-f197.google.com with SMTP id 187-20020a3707c4000000b007468d9a30faso821946qkh.23
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 07:30:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679322605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fYYltObAoBAJHBew4d0/wtXHVG5SadqFvZoyE4YqRs0=;
        b=h+tE0SBUVzhOtILwZ4sWoFGu6485ip4ochUI2/wsqqzdDYmm75mMbrFhCUJbOz0cKc
         T2tkBzO/TtDG/VV2HL7n+9dXeRIinFAJxSP4OsV9jrMxsMZoOSTrUegSuWkf5W6LMVh9
         HJaNited3dIF34YyGW2yeZmdAY/fS/n81sxCVzJcV2QNa8ecFpwkzfE/asmTOfwEL+9s
         nofPDtYDjubTliu8GQHZccebgtyJ+UsMh5KggQywqhuvb9J7+Tdn1DfCn23oNgtxGvhH
         zpVjOM0tLvS+xhRENAlZkAl1VXY9bi91wp8ow+E/H9wzm6ln2+4fJ8a/29RrEH1v0CwY
         c2jQ==
X-Gm-Message-State: AO0yUKX8XzXoZvOfYJbtpc4SEkxGVCk53wO6v4oy5wX+hF6eo1cXQm2X
        Q6a+LTVIB3imWee9syhExx7yjLZE3MqGFdR5IucCjxzyjtUA4LTne4g5ApjS46uKIJ/xu11bk01
        HDTjknYcQ8efX
X-Received: by 2002:ac8:4e42:0:b0:3d7:57b:467c with SMTP id e2-20020ac84e42000000b003d7057b467cmr29522677qtw.43.1679322605281;
        Mon, 20 Mar 2023 07:30:05 -0700 (PDT)
X-Google-Smtp-Source: AK7set9hlZuyivlx1H18m4rYyb3oaING8patBHWuxdHYD2CvI9lsFliZKypqpOpiOcNd9X094fyYsg==
X-Received: by 2002:ac8:4e42:0:b0:3d7:57b:467c with SMTP id e2-20020ac84e42000000b003d7057b467cmr29522623qtw.43.1679322604965;
        Mon, 20 Mar 2023 07:30:04 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id t10-20020ac86a0a000000b003b9b48cdbe8sm6446788qtr.58.2023.03.20.07.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 07:30:04 -0700 (PDT)
Date:   Mon, 20 Mar 2023 15:29:59 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2] virtio/vsock: allocate multiple skbuffs on tx
Message-ID: <20230320142959.2wwf474fiyp3ex5z@sgarzare-redhat>
References: <ea5725eb-6cb5-cf15-2938-34e335a442fa@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ea5725eb-6cb5-cf15-2938-34e335a442fa@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 19, 2023 at 09:46:10PM +0300, Arseniy Krasnov wrote:
>This adds small optimization for tx path: instead of allocating single
>skbuff on every call to transport, allocate multiple skbuff's until
>credit space allows, thus trying to send as much as possible data without
>return to af_vsock.c.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> Link to v1:
> https://lore.kernel.org/netdev/2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru/
>
> Changelog:
> v1 -> v2:
> - If sent something, return number of bytes sent (even in
>   case of error). Return error only if failed to sent first
>   skbuff.
>
> net/vmw_vsock/virtio_transport_common.c | 53 ++++++++++++++++++-------
> 1 file changed, 39 insertions(+), 14 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 6564192e7f20..3fdf1433ec28 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -196,7 +196,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	const struct virtio_transport *t_ops;
> 	struct virtio_vsock_sock *vvs;
> 	u32 pkt_len = info->pkt_len;
>-	struct sk_buff *skb;
>+	u32 rest_len;
>+	int ret;
>
> 	info->type = virtio_transport_get_type(sk_vsock(vsk));
>
>@@ -216,10 +217,6 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>
> 	vvs = vsk->trans;
>
>-	/* we can send less than pkt_len bytes */
>-	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>-		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>-
> 	/* virtio_transport_get_credit might return less than pkt_len credit */
> 	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
>
>@@ -227,17 +224,45 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
> 		return pkt_len;
>
>-	skb = virtio_transport_alloc_skb(info, pkt_len,
>-					 src_cid, src_port,
>-					 dst_cid, dst_port);
>-	if (!skb) {
>-		virtio_transport_put_credit(vvs, pkt_len);
>-		return -ENOMEM;
>-	}
>+	ret = 0;
>+	rest_len = pkt_len;
>+
>+	do {
>+		struct sk_buff *skb;
>+		size_t skb_len;
>+
>+		skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
>+
>+		skb = virtio_transport_alloc_skb(info, skb_len,
>+						 src_cid, src_port,
>+						 dst_cid, dst_port);
>+		if (!skb) {
>+			ret = -ENOMEM;
>+			break;
>+		}
>+
>+		virtio_transport_inc_tx_pkt(vvs, skb);
>+
>+		ret = t_ops->send_pkt(skb);
>+
>+		if (ret < 0)
>+			break;
>
>-	virtio_transport_inc_tx_pkt(vvs, skb);
>+		rest_len -= skb_len;

t_ops->send_pkt() is returning the number of bytes sent. Current
implementations always return `skb_len`, so there should be no problem,
but it would be better to put a comment here, or we should handle the
case where ret != skb_len to avoid future issues.

>+	} while (rest_len);
>
>-	return t_ops->send_pkt(skb);
>+	/* Don't call this function with zero as argument:
>+	 * it tries to acquire spinlock and such argument
>+	 * makes this call useless.

Good point, can we do the same also for virtio_transport_get_credit()?
(Maybe in a separate patch)

I'm thinking if may be better to do it directly inside the functions,
but I don't have a strong opinion on that since we only call them here.

Thanks,
Stefano

>+	 */
>+	if (rest_len)
>+		virtio_transport_put_credit(vvs, rest_len);
>+
>+	/* Return number of bytes, if any data has been sent. */
>+	if (rest_len != pkt_len)
>+		ret = pkt_len - rest_len;
>+
>+	return ret;
> }
>
> static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>-- 
>2.25.1
>

