Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD36699694
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjBPOD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjBPOD2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:03:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEAC43470
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676556160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jLAlHrmg/N94k15P0ZdSVRRZ/25ME84tuyTznfQGswY=;
        b=Gb/CvH5hAkxcwlwGFUTCqmWr/zrWGy3zqPyMKfg+2B708L95vN0BE6SGfym7Lbxozch3Fa
        ztFxo/wy8NhtEspi8DU3QFNGfCFynruRLiXDq0hRgaQnNIbYtVwBF2fn9mk27hxU+OCbRC
        DCd5vaWbDSKxcOCyTTJd8JyQVS9vsUE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-637-8BGxS67LPI6XZAih-E_LTA-1; Thu, 16 Feb 2023 09:02:38 -0500
X-MC-Unique: 8BGxS67LPI6XZAih-E_LTA-1
Received: by mail-qk1-f198.google.com with SMTP id u11-20020a05620a0c4b00b0073b328e7d17so1215659qki.9
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:02:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jLAlHrmg/N94k15P0ZdSVRRZ/25ME84tuyTznfQGswY=;
        b=yrkUI1GaVmfC5pgXdI++KY2WGboH9TNKNYzFiE6vOuF+AfRmP1z11GCcxllojeszw3
         P/W4XVT/Ghk81cad3gRHypO94nQDC/ZWwJe07JeU9rORvXJ9O3SF6rYRfwNwF8I62ZK1
         qee4A/6ogabDzY4l5m2UUcpBsuL+bTp4dqEPmvbdOmzcans35MRtmONRVQnJx48EblUR
         aWTDRRQQAIm5cxbazjczJGwmW7YbTGL6QBeb+mbXF7lH2/4vmzJPjl44ExtHpO+xxmoi
         l7gkYOoU7qvfqXP6JntHyQCSyzJ4P0aJnR3EuSC/6dOGpGLPXmlBirleMMjPS1TnHdJ/
         8Aqw==
X-Gm-Message-State: AO0yUKUtBtyCTytA2uV4gbD1UHqKsICvXcXeQgDfjIotbbnEDHdtxkyz
        Pbi9MeNO2mroipKok7ypTty7ETsp3ohGnzHEvRzvnIb5DmvXfTYw+/Wr1po0Ix/wEf+7ponG0VV
        KKovT7pBSY4CN
X-Received: by 2002:ad4:5cad:0:b0:56e:af4a:11f8 with SMTP id q13-20020ad45cad000000b0056eaf4a11f8mr11940061qvh.4.1676556157888;
        Thu, 16 Feb 2023 06:02:37 -0800 (PST)
X-Google-Smtp-Source: AK7set+9m6lSguHPttaA6t6O/ygFLCA9e+/4Kab1ifq4gqWCNbHN1aAIRLEgnyZQl/IvOoVqpE1rDw==
X-Received: by 2002:ad4:5cad:0:b0:56e:af4a:11f8 with SMTP id q13-20020ad45cad000000b0056eaf4a11f8mr11940021qvh.4.1676556157593;
        Thu, 16 Feb 2023 06:02:37 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id w3-20020a379403000000b006bb29d932e1sm1198761qkd.105.2023.02.16.06.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 06:02:37 -0800 (PST)
Date:   Thu, 16 Feb 2023 15:02:30 +0100
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
Subject: Re: [RFC PATCH v1 03/12] vsock: check for MSG_ZEROCOPY support
Message-ID: <20230216140230.3ee2362owceyflf3@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <d6c8c90f-bf0b-b310-2737-27d3741f2043@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <d6c8c90f-bf0b-b310-2737-27d3741f2043@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 06:55:46AM +0000, Arseniy Krasnov wrote:
>This feature totally depends on transport, so if transport doesn't
>support it, return error.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/net/af_vsock.h   | 2 ++
> net/vmw_vsock/af_vsock.c | 7 +++++++
> 2 files changed, 9 insertions(+)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index 568a87c5e0d0..96d829004c81 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -173,6 +173,8 @@ struct vsock_transport {
>
> 	/* Addressing. */
> 	u32 (*get_local_cid)(void);
>+

LGTM, just add comment here for a new section following what we did for
other callaback, e.g.:

         /* Zero-copy. */
>+	bool (*msgzerocopy_allow)(void);
> };
>
> /**** CORE ****/
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index f752b30b71d6..fb0fcb390113 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1788,6 +1788,13 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 		goto out;
> 	}
>
>+	if (msg->msg_flags & MSG_ZEROCOPY &&
>+	    (!transport->msgzerocopy_allow ||
>+	     !transport->msgzerocopy_allow())) {
>+		err = -EOPNOTSUPP;
>+		goto out;
>+	}
>+
> 	/* Wait for room in the produce queue to enqueue our user's data. */
> 	timeout = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
>
>-- 
>2.25.1

