Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2449B6C1437
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 14:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjCTN7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 09:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjCTN7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 09:59:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474B714E91
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 06:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679320700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xluQCIRM9KUg+iS1ks5cvU7xSezg5DUOPbgJwMPELqs=;
        b=Sm9JlDfMdBi7ddhsh2/XN/JSHCDATjK/tsJpw7ocyuj4oRsQuoig/LpmpfmBc1tg6sWmzx
        c9hJ8/w8y7LEYEAmYRwCTG4pyA9lvuKQHv2QDOIc/10qhDkEcdHeNhQf7YBaeSqkeTJiA5
        OImKX+fnYFR7ZK29js7n4iHUrxeFamE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-ZgHDCpTiPhua_MQ_ZHMvUQ-1; Mon, 20 Mar 2023 09:58:18 -0400
X-MC-Unique: ZgHDCpTiPhua_MQ_ZHMvUQ-1
Received: by mail-wr1-f69.google.com with SMTP id i11-20020a5d522b000000b002ceac3d4413so1463062wra.11
        for <kvm@vger.kernel.org>; Mon, 20 Mar 2023 06:58:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679320698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xluQCIRM9KUg+iS1ks5cvU7xSezg5DUOPbgJwMPELqs=;
        b=WjJNlFb8WaCc2uHMtFzTLrohdiBLDQxvVtgciQ/fG28cwY3TwugzGFBOUIXnRwVX/y
         aXrCO2+PY/RHhEjisBuwyoUFWMQ0ZwVC/f6OKoIlmbu5tujHcdxrZDGof28cq/oB7y/T
         woWJlQVq0mylOzRx+rBMdFvf2jYRXPkjTZJI7ry1ArgPsY3tc2CWgtotLnK3W9ZSKhyu
         3ZcrAG3D0tLZOOkZ2ROp0JjOHP8kCevPEDmHArN0JZagsrHiVc8zVcom1CgbNMIHi5sk
         LqJJRg1IuM4ZuZK2tTLN5Z8VkWiMNrW+h+tDyyDpEn2YWE8FadCb3jCOZtMQoXMQ8bO2
         XOkg==
X-Gm-Message-State: AO0yUKV4SxaSySAgu9IdlJ2MELNk4G5YcUut2g6uGaGaLx7C/jgHH3Nm
        6spWBBeOymAcAaclmJ7Pud8vvB0DyzJbFA5D4xoOTBgQYi9K/Q7ItauccuZf8oQXG+3Dj7luTkH
        X+O9XNUw9T6Nx
X-Received: by 2002:adf:ce11:0:b0:2c7:851:c0bf with SMTP id p17-20020adfce11000000b002c70851c0bfmr13818702wrn.0.1679320697841;
        Mon, 20 Mar 2023 06:58:17 -0700 (PDT)
X-Google-Smtp-Source: AK7set+FUDvH/psBKoCx/B613vRQOYlndcOrSX0ahkGfyMMplDZBRpmL9wOqCuvTHwUfmOLfiNDOAg==
X-Received: by 2002:adf:ce11:0:b0:2c7:851:c0bf with SMTP id p17-20020adfce11000000b002c70851c0bfmr13818684wrn.0.1679320697599;
        Mon, 20 Mar 2023 06:58:17 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id s13-20020a5d510d000000b002c794495f6fsm5977998wrt.117.2023.03.20.06.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 06:58:17 -0700 (PDT)
Date:   Mon, 20 Mar 2023 14:58:14 +0100
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
Subject: Re: [RFC PATCH v1] virtio/vsock: check transport before skb
 allocation
Message-ID: <20230320135814.jncpvznka56liu36@sgarzare-redhat>
References: <47a7dbf6-1c63-3338-5102-122766e6378d@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <47a7dbf6-1c63-3338-5102-122766e6378d@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 01:37:10PM +0300, Arseniy Krasnov wrote:
>Pointer to transport could be checked before allocation of skbuff, thus
>there is no need to free skbuff when this pointer is NULL.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 8 +++-----
> 1 file changed, 3 insertions(+), 5 deletions(-)

LGTM, I think net-next is fine for this.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index cda587196475..607149259e8b 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -867,6 +867,9 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
> 	if (le16_to_cpu(hdr->op) == VIRTIO_VSOCK_OP_RST)
> 		return 0;
>
>+	if (!t)
>+		return -ENOTCONN;
>+
> 	reply = virtio_transport_alloc_skb(&info, 0,
> 					   le64_to_cpu(hdr->dst_cid),
> 					   le32_to_cpu(hdr->dst_port),
>@@ -875,11 +878,6 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
> 	if (!reply)
> 		return -ENOMEM;
>
>-	if (!t) {
>-		kfree_skb(reply);
>-		return -ENOTCONN;
>-	}
>-
> 	return t->send_pkt(reply);
> }
>
>-- 
>2.25.1
>

