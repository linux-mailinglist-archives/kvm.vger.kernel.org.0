Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63DC074A29A
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 18:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjGFQzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 12:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbjGFQz3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 12:55:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658BB1FC7
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 09:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688662462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JAiHhriZpvTS63ort7r8zwvuONWQrrwpaGdn7CXb3ds=;
        b=OSPMjqKdJBUuFfbJrFux3lSm/SNE4/1JL1fvYl2w0rDoFtJ3r2k4iKDgR43rDBj4PpbVUU
        +aBFtbbwSKHX3jc5XZXWMCThYCKr3xgUl3f+in6uloRFx54WmzsJ4YaIuWYrjISxfaLnfd
        maxb6D9DkozuzOnpRWfbtkBcdGIIKNQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-Q4PEGHQ7NGmeduAVMnPJSQ-1; Thu, 06 Jul 2023 12:54:20 -0400
X-MC-Unique: Q4PEGHQ7NGmeduAVMnPJSQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-993c24f3246so61647166b.1
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 09:54:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688662459; x=1691254459;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAiHhriZpvTS63ort7r8zwvuONWQrrwpaGdn7CXb3ds=;
        b=MOLUzs/Igj1j8bgF0dhPQHepdAaB3l0/uiWLmLEVJ3bjj2V0xTMLEGLfBNhyj9X44B
         dt9R9xuePN+CW9ejL/My24WOokU5RPDrucM0wSwGEh6Ytk0ETOwBahK7zwyk2JKm4Ojs
         1rqq3/JVApvgac937I+AKV2uOjXeSOhGDKQONORydQ3J52mf0fIPvR0ESEhUGTJyeJ9D
         FZZ+KPGhKXyg1d/FegaWqmlPU8+/frofge11IBe0meAMl97nYMOEFAuQoZIsswxhPdeB
         A26udyes3D25LqdBwsG1w/eqkF3r6d+lE6CwUR8vdRraa4Pp3Z+IxREtcDrbuxFUWQry
         cPYg==
X-Gm-Message-State: ABy/qLZlFwpQ6H9z9HWfea46Emw/7nGcpSBNWzmH0bKB4C7gU9GJJv/2
        UIHuhMTWFRzEJtrhU2gpwOpL/d0K3x149jYZdoCY8P2BZd3hYOeHKU8IyQjLf5FcbA2tkajUIJl
        scAwWGz2GpO21
X-Received: by 2002:a17:906:189:b0:978:8685:71d5 with SMTP id 9-20020a170906018900b00978868571d5mr2589625ejb.30.1688662459238;
        Thu, 06 Jul 2023 09:54:19 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFnhk3IpvpZs4YO7xxAyJb/wtXZUKN6ADWvXy9B2WEMXrs6pu4JTD3zmKxYP2iPxRlve8MOrw==
X-Received: by 2002:a17:906:189:b0:978:8685:71d5 with SMTP id 9-20020a170906018900b00978868571d5mr2589600ejb.30.1688662458935;
        Thu, 06 Jul 2023 09:54:18 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-163.retail.telecomitalia.it. [79.46.200.163])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709066b8a00b00992f2befcbcsm1023534ejr.180.2023.07.06.09.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 09:54:18 -0700 (PDT)
Date:   Thu, 6 Jul 2023 18:54:16 +0200
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
Subject: Re: [RFC PATCH v5 06/17] vsock: fix EPOLLERR set on non-empty error
 queue
Message-ID: <bwcgwfiwf5siky3nqvcedenvooszd4vk2gfi6tkvge2ayfyim6@wihfy74lqoct>
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
 <20230701063947.3422088-7-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230701063947.3422088-7-AVKrasnov@sberdevices.ru>
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

On Sat, Jul 01, 2023 at 09:39:36AM +0300, Arseniy Krasnov wrote:
>If socket's error queue is not empty, EPOLLERR must be set. Otherwise,
>reader of error queue won't detect data in it using EPOLLERR bit.
>Currently for AF_VSOCK this is reproducible only with MSG_ZEROCOPY, as
>this feature is the only user of an error queue of the socket.
>
>Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")

Sorry if I confused you, but if without MSG_ZEROCOPY this is not an
issue, then we can remove the Fixes tag.

>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> Changelog:
> v4 -> v5:
>  * Change commit message as Fix patch. Also add details that this
>    problem could be reproduced only with MSG_ZEROCOPY transmission
>    mode.
>
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index efb8a0937a13..45fd20c4ed50 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1030,7 +1030,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 	poll_wait(file, sk_sleep(sk), wait);
> 	mask = 0;
>
>-	if (sk->sk_err)
>+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
> 		/* Signify that there has been an error on this socket. */
> 		mask |= EPOLLERR;
>
>-- 
>2.25.1
>

