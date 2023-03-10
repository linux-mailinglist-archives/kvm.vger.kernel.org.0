Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCE06B39C0
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 10:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbjCJJMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 04:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCJJLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 04:11:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D32A115B6B
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678439161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wz8nUvi2fGgDgewNMYegfHqQ2FX4wiXlwJl5P4TAg0M=;
        b=Up8E6K8+hG6QYaYxdDnsxrWLCEXESGQgbvdNkqDGsj7RJRpVGR/YuzTZbAO/WcgU0xW78w
        g3KxLvDT//u26gagLnvNt1vgiyCg5FoxISI+H5N+Pe2HPbN2ZeqqRQkdsE5pfBfVJbNem2
        GcWVrxHhuYtC3Way3cuaodWE1Dm0kTY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-16-XmJCO6HlNdqhBKfSjSa8Ug-1; Fri, 10 Mar 2023 04:06:00 -0500
X-MC-Unique: XmJCO6HlNdqhBKfSjSa8Ug-1
Received: by mail-wr1-f72.google.com with SMTP id by11-20020a056000098b00b002ce45687cbdso933600wrb.12
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 01:06:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678439157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wz8nUvi2fGgDgewNMYegfHqQ2FX4wiXlwJl5P4TAg0M=;
        b=rqRMvvvV875vhWCtD0W9bbPmZXRbggXF60Bdrm6uQ+Y61Lzorhf1QZ54WPdS7L9l7+
         UEGMLcgop4cmjO5IWjQQ2+hQ++QnM3E2JDu8+wA+pf3+VcOqZ6p2OYHj07eERRxetRf7
         KsC1MxOkUoyW5tKoLwHlDSzKIqvrFfWo4Jp5aZb/+5IjYxA6400HG+beZuXhrhrHnbcO
         FeKfHK+SIRXnibow6+tklr0ZcyDdtYDiQ2YQqOeDTXr2B0lw3GUDui5EUF7wLN/JTU4r
         g11b7JjNmT2+lc+tQh+awERs1rmU5GdHRMTq473X1HU1dXmH1xW8eZYI6xbaTWUWy/XD
         MwgA==
X-Gm-Message-State: AO0yUKUwSiMUpUyTI/IY3+Wj9rloGVDVuv+qjLkYLP0sskKpEzejxj0Z
        zpO3cvqFxo0s0203ymPCF89rcU+T9A0YoeghSaBINtNJ0u1aFH2ygnrqPWwKKRDBMXRWrU3wFBP
        n9A8XnLwsqCNw
X-Received: by 2002:adf:e343:0:b0:2c7:f56:285b with SMTP id n3-20020adfe343000000b002c70f56285bmr16988083wrj.63.1678439157274;
        Fri, 10 Mar 2023 01:05:57 -0800 (PST)
X-Google-Smtp-Source: AK7set/kMCf2/pJ8VDpyvGWvl95/R1kauUwT62ehT8eA6aqrdwrsYUpmjAVFex11URKqVX/AodZhVQ==
X-Received: by 2002:adf:e343:0:b0:2c7:f56:285b with SMTP id n3-20020adfe343000000b002c70f56285bmr16988072wrj.63.1678439157105;
        Fri, 10 Mar 2023 01:05:57 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id a4-20020adffb84000000b002c592535839sm1624988wrr.17.2023.03.10.01.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 01:05:56 -0800 (PST)
Date:   Fri, 10 Mar 2023 10:05:53 +0100
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
Subject: Re: [RFC PATCH v4 3/4] virtio/vsock: don't drop skbuff on copy
 failure
Message-ID: <20230310090553.mlvthrdpmehi5op5@sgarzare-redhat>
References: <1804d100-1652-d463-8627-da93cb61144e@sberdevices.ru>
 <e29e788a-51d7-f733-85a5-707044f54dd6@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e29e788a-51d7-f733-85a5-707044f54dd6@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 09, 2023 at 11:28:01PM +0300, Arseniy Krasnov wrote:
>This returns behaviour of SOCK_STREAM read as before skbuff usage. When
>copying to user fails current skbuff won't be dropped, but returned to
>sockets's queue. Technically instead of 'skb_dequeue()', 'skb_peek()' is
>called and when skbuff becomes empty, it is removed from queue by
>'__skb_unlink()'.
>
>Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 9a411475e201..6564192e7f20 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -364,7 +364,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
>
> 	spin_lock_bh(&vvs->rx_lock);
> 	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
>-		skb = __skb_dequeue(&vvs->rx_queue);
>+		skb = skb_peek(&vvs->rx_queue);
>
> 		bytes = len - total;
> 		if (bytes > skb->len)
>@@ -388,9 +388,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
>
> 			virtio_transport_dec_rx_pkt(vvs, pkt_len);
>+			__skb_unlink(skb, &vvs->rx_queue);
> 			consume_skb(skb);
>-		} else {
>-			__skb_queue_head(&vvs->rx_queue, skb);
> 		}
> 	}
>
>-- 
>2.25.1
>

