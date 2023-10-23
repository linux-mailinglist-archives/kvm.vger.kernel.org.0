Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3917D3953
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 16:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbjJWOa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 10:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233344AbjJWOaw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 10:30:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11CD100
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 07:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698071408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kySDKR+e82Dq0GbnFVXWHHRylAyqPYM5YM7Pq4ou10o=;
        b=BAOGSydwSpKVnMTpzY00RKVQ2CkNvrQXlxR+YvWw8wCDvG4VLUPBl57YjQTMgav6d2hvVj
        bQ3CwSso1e9/zPzV6EJZNNSAl5/GD7ULJHcoqAe8WY6dGsnTdxlDladLXTuDIN+fiUxo+h
        d8PdB+zKBO9BC4tGnC3L9ZJmJmc9FUg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-eBbk-UUlP7e6szwshY7SnA-1; Mon, 23 Oct 2023 10:29:58 -0400
X-MC-Unique: eBbk-UUlP7e6szwshY7SnA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-778a455f975so450375485a.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 07:29:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698071397; x=1698676197;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kySDKR+e82Dq0GbnFVXWHHRylAyqPYM5YM7Pq4ou10o=;
        b=t8erMCwXd+tQK8JhiRcIrDJqJdoxlkrLrpd375Z0qge4LbBUFLexOesMVmZnBwBMyR
         omCMiFWsW6nKk+Kk5UhTu3295dVaCpX1eE6IXs6OtZyBN33n6Runp8/DNRz5tYcSnPEu
         J2/DubmpFlNdx1jpKIH/cuCxnzBY3yWjvzG4Xuay47GmSZLmztt1aSGl0IXoi+8+RZR/
         +t4s/a43n5PJjRBNs+kpAxVMA4gXdM2TTz5nhuWQ/XbwlnRFVLiaOmbQsnXC9ULhGLw0
         kMhfs/jd/NcnAHU0EzC7BaFmK9XATXj9ARYHgYQIsadcox9FtP+6fY4YL3jV1fN+0/XV
         9ynw==
X-Gm-Message-State: AOJu0Yxgm7Gav9ua8lyUtPUwtXy4W+MHzRw5sGl9ttCniEIJ1cknXwPk
        17sUpuCxAN0VYXhdvKHR4RyECJY2ylTiJkuQPvsX1BeAQMuyW4o+/yDMo/rrS4ksZma74wmDFYn
        RRSsQ0ChPLqxu
X-Received: by 2002:a05:620a:c4c:b0:778:b0f5:d4e7 with SMTP id u12-20020a05620a0c4c00b00778b0f5d4e7mr8747571qki.46.1698071397507;
        Mon, 23 Oct 2023 07:29:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoIEdB7iELDRun3hsVSPuymnAKtgjwualgCraxWcYPHJJfqhEETtyAiBCcLGcgIIkq3BUmLg==
X-Received: by 2002:a05:620a:c4c:b0:778:b0f5:d4e7 with SMTP id u12-20020a05620a0c4c00b00778b0f5d4e7mr8747549qki.46.1698071397203;
        Mon, 23 Oct 2023 07:29:57 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-185-56.business.telecomitalia.it. [87.12.185.56])
        by smtp.gmail.com with ESMTPSA id k22-20020a05620a143600b00774350813ccsm2736609qkj.118.2023.10.23.07.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 07:29:56 -0700 (PDT)
Date:   Mon, 23 Oct 2023 16:29:48 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH v2] vsock/virtio: initialize the_virtio_vsock before
 using VQs
Message-ID: <2tc56vwgs5xwqzfqbv5vud346uzagwtygdhkngdt3wjqaslbmh@zauky5czyfkg>
References: <20231023140833.11206-1-alexandru.matei@uipath.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231023140833.11206-1-alexandru.matei@uipath.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 05:08:33PM +0300, Alexandru Matei wrote:
>Once VQs are filled with empty buffers and we kick the host,
>it can send connection requests.  If 'the_virtio_vsock' is not
>initialized before, replies are silently dropped and do not reach the host.
>
>Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on the_virtio_vsock")
>Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
>---
>v2:
>- split virtio_vsock_vqs_init in vqs_init and vqs_fill and moved
>  the_virtio_vsock initialization after vqs_init
>
> net/vmw_vsock/virtio_transport.c | 9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index e95df847176b..92738d1697c1 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -559,6 +559,11 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
> 	vsock->tx_run = true;
> 	mutex_unlock(&vsock->tx_lock);
>
>+	return 0;
>+}
>+
>+static void virtio_vsock_vqs_fill(struct virtio_vsock *vsock)

What about renaming this function in virtio_vsock_vqs_start() and move 
also the setting of `tx_run` here?

Thanks,
Stefano

>+{
> 	mutex_lock(&vsock->rx_lock);
> 	virtio_vsock_rx_fill(vsock);
> 	vsock->rx_run = true;
>@@ -568,8 +573,6 @@ static int virtio_vsock_vqs_init(struct virtio_vsock *vsock)
> 	virtio_vsock_event_fill(vsock);
> 	vsock->event_run = true;
> 	mutex_unlock(&vsock->event_lock);
>-
>-	return 0;
> }
>
> static void virtio_vsock_vqs_del(struct virtio_vsock *vsock)
>@@ -664,6 +667,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 		goto out;
>
> 	rcu_assign_pointer(the_virtio_vsock, vsock);
>+	virtio_vsock_vqs_fill(vsock);
>
> 	mutex_unlock(&the_virtio_vsock_mutex);
>
>@@ -736,6 +740,7 @@ static int virtio_vsock_restore(struct virtio_device *vdev)
> 		goto out;
>
> 	rcu_assign_pointer(the_virtio_vsock, vsock);
>+	virtio_vsock_vqs_fill(vsock);
>
> out:
> 	mutex_unlock(&the_virtio_vsock_mutex);
>-- 
>2.34.1
>

