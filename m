Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4EFF73E4E8
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbjFZQZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbjFZQZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:25:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE1C2941
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687796625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=goJ82gfmaMLDwx1lebPuhQrFW0gpPX2fa0/sdreNvaA=;
        b=SD6KzRytsr6wD2vg5KQ8IbjclesQwG9+zkJGZh10fkBpdzD4JaoMas7GxNSZhiv+vVNGys
        HUl+PNfI4oLA06PL3opD+gKjOgLRd8g+cOW/WHxB2OeM9hb/Fd7xiaA9CUNTTK7Z4n1izb
        MZzCrJTenxPwabQUf9lX5F7iiJNP1OQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-P06w9hkFNVeMbnCg669waQ-1; Mon, 26 Jun 2023 12:23:38 -0400
X-MC-Unique: P06w9hkFNVeMbnCg669waQ-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4009a8498f7so16684631cf.1
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:23:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687796617; x=1690388617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=goJ82gfmaMLDwx1lebPuhQrFW0gpPX2fa0/sdreNvaA=;
        b=J7dFC9IHwKsPmASskMTnzzFUjgy8KdUpg9uqJGTyvlSkSKVWzPeNAityna5uw883Eb
         +vR1N69Xd7iUdA8HRmvCNEv7OsVcYdt/Dm5H/mLHd0tS0L8rkFFpiuct5Prt3UWBs08J
         wVUhBoTW8kbcNTRAVj2RIApEhtYFYfbPaMiv9fPhEH+YmDXIHlN9QUqfdpkSbNgUtw2i
         WQ5VCuJAhMjTePRZ5mJwkcKT/rj/hAzCRcgYuDT+4EatxoMofW1HnfFzRFn6ASfgsXdK
         7f7OayCRkt6CQLQaZomBjwr5wTgq7lHrNyVoO4c+cu7ENg5ulr7+tho4WOrnJVa4DAGJ
         Y4yA==
X-Gm-Message-State: AC+VfDyg1iod9MeFYuiQ6IXqQhNQVJX8VUD9fbJrmgwDka697faBZsfO
        wHp+ZlrlGhewBhh5AqtrxZJJW5hSggOrlg4PgxGTZ/26VdnLB8ZAwTq2XfPgE5yySy4KCSRjnOE
        Es4+bvy/z7WlH
X-Received: by 2002:a05:622a:5cc:b0:3ff:28a6:b507 with SMTP id d12-20020a05622a05cc00b003ff28a6b507mr27045074qtb.62.1687796617354;
        Mon, 26 Jun 2023 09:23:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Fcw3HZ9CsPSMizS0+mFl35ikBhcBByAiRtmV5dvu+j35EXovmFwfSrDE8p+YUssGNZi+Ntg==
X-Received: by 2002:a05:622a:5cc:b0:3ff:28a6:b507 with SMTP id d12-20020a05622a05cc00b003ff28a6b507mr27045049qtb.62.1687796617099;
        Mon, 26 Jun 2023 09:23:37 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id cm23-20020a05622a251700b003e4ee0f5234sm3211789qtb.87.2023.06.26.09.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 09:23:36 -0700 (PDT)
Date:   Mon, 26 Jun 2023 18:23:32 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
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
Subject: Re: [RFC PATCH v1 1/4] virtio/vsock: rework MSG_PEEK for SOCK_STREAM
Message-ID: <fumoatu4z5pvqntnqa6hnuripfa4zrtb5m2rsfkfsdn23pn5y5@f7yy23tjxwwa>
References: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
 <20230618062451.79980-2-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230618062451.79980-2-AVKrasnov@sberdevices.ru>
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

On Sun, Jun 18, 2023 at 09:24:48AM +0300, Arseniy Krasnov wrote:
>This reworks current implementation of MSG_PEEK logic:
>1) Replaces 'skb_queue_walk_safe()' with 'skb_queue_walk()'. There is
>   no need in the first one, as there are no removes of skb in loop.
>2) Removes nested while loop - MSG_PEEK logic could be implemented
>   without it: just iterate over skbs without removing it and copy
>   data from each until destination buffer is not full.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 41 ++++++++++++-------------
> 1 file changed, 19 insertions(+), 22 deletions(-)

Great clean up!

LGTM, but @Bobby can you also take a look?

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index b769fc258931..2ee40574c339 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -348,37 +348,34 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
> 				size_t len)
> {
> 	struct virtio_vsock_sock *vvs = vsk->trans;
>-	size_t bytes, total = 0, off;
>-	struct sk_buff *skb, *tmp;
>-	int err = -EFAULT;
>+	struct sk_buff *skb;
>+	size_t total = 0;
>+	int err;
>
> 	spin_lock_bh(&vvs->rx_lock);
>
>-	skb_queue_walk_safe(&vvs->rx_queue, skb,  tmp) {
>-		off = 0;
>+	skb_queue_walk(&vvs->rx_queue, skb) {
>+		size_t bytes;
>
>-		if (total == len)
>-			break;
>+		bytes = len - total;
>+		if (bytes > skb->len)
>+			bytes = skb->len;
>
>-		while (total < len && off < skb->len) {
>-			bytes = len - total;
>-			if (bytes > skb->len - off)
>-				bytes = skb->len - off;
>+		spin_unlock_bh(&vvs->rx_lock);
>
>-			/* sk_lock is held by caller so no one else can dequeue.
>-			 * Unlock rx_lock since memcpy_to_msg() may sleep.
>-			 */
>-			spin_unlock_bh(&vvs->rx_lock);
>+		/* sk_lock is held by caller so no one else can dequeue.
>+		 * Unlock rx_lock since memcpy_to_msg() may sleep.
>+		 */
>+		err = memcpy_to_msg(msg, skb->data, bytes);
>+		if (err)
>+			goto out;
>
>-			err = memcpy_to_msg(msg, skb->data + off, bytes);
>-			if (err)
>-				goto out;
>+		total += bytes;
>
>-			spin_lock_bh(&vvs->rx_lock);
>+		spin_lock_bh(&vvs->rx_lock);
>
>-			total += bytes;
>-			off += bytes;
>-		}
>+		if (total == len)
>+			break;
> 	}
>
> 	spin_unlock_bh(&vvs->rx_lock);
>-- 
>2.25.1
>

