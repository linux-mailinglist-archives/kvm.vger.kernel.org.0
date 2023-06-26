Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D073A73E42A
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 18:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjFZQFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 12:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbjFZQFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 12:05:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F06591
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687795504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b0yQZBdpdUXl4YMdFLcFlkwsrjZb29VthZRnokOZ88k=;
        b=Znoe+IpFB687Zgfg6VzZzJgNAbHP/hERDBfs+77yaiwimlFsM+roekD2SorCRyoyvVMYOa
        5Zj2vseW4kt24BEpXg4ftK8sB4u1x2maAGwA2qHqzi4xlFn3yW1mn0lM4iwEN6IZ/1VWxW
        aG/Jd7SpGjNCtEG/SOLQJPPtRr3ckPo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-n7X_ISnWOxedvfxSTmIlyQ-1; Mon, 26 Jun 2023 12:05:01 -0400
X-MC-Unique: n7X_ISnWOxedvfxSTmIlyQ-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4007c8a49fdso30329151cf.3
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 09:04:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687795490; x=1690387490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b0yQZBdpdUXl4YMdFLcFlkwsrjZb29VthZRnokOZ88k=;
        b=eqsep3XR52UBPn1tQtNM5lPylxn/Weythpj1Q2ZrLnWaUUzTvG6SipPlv80gMvkAGg
         yxG6iQWZXCMNf4Ssq/xuVXToUiDlJzGlkGORyGud8mweq1FlkAhmfoaXhDSvqWhMVghX
         ULHSpiJezJp4nqxXOWfhoX9Y2cZssfL91KrIRDUKoD0huz654Ve5kyskfNCebVy/lH4B
         iyBNEG0sdADXpwLOHTFfvkDpUFGb59XZ87H839jvZOGHAfyV+XJSwBj1IolFhzO4DMES
         StZCr0QNWgAC5QLyKEZ7qCjULhd93C5vKxKIeYVF3Cnm+fROf188ftOIgcKymaM+oW2w
         8tJg==
X-Gm-Message-State: AC+VfDy87bUIBrXcBE+zQ8PCXVfY4hZOLcToVOJSgX8uHmuvmCjNY4WH
        HVCX4DDemBKAtu9XT4MwQl6+tLkFvSg42ebD/KsrlS2nFwVffMwPgtTI1nv/It98C/FINpvSELX
        oAORm10pnQpcT
X-Received: by 2002:ac8:5dcc:0:b0:3ff:2fae:b4bb with SMTP id e12-20020ac85dcc000000b003ff2faeb4bbmr22270355qtx.37.1687795489891;
        Mon, 26 Jun 2023 09:04:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6scFxlQwYFHNY1LJg+2KYwo5IzNCiATxO/eK3932x063Eqk2Ca+8K2qyxj23DPRz3vgCwgrw==
X-Received: by 2002:ac8:5dcc:0:b0:3ff:2fae:b4bb with SMTP id e12-20020ac85dcc000000b003ff2faeb4bbmr22270315qtx.37.1687795489480;
        Mon, 26 Jun 2023 09:04:49 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id z6-20020a05622a124600b00400ab543858sm900265qtx.67.2023.06.26.09.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 09:04:48 -0700 (PDT)
Date:   Mon, 26 Jun 2023 18:04:44 +0200
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
Subject: Re: [RFC PATCH v4 06/17] vsock: check error queue to set EPOLLERR
Message-ID: <rg3qxgiqqi5ltt4jcf3k5tcnynh2so5ascvrte4gywcfffusv4@qjz3tkumeq7g>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
 <20230603204939.1598818-7-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230603204939.1598818-7-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 03, 2023 at 11:49:28PM +0300, Arseniy Krasnov wrote:
>If socket's error queue is not empty, EPOLLERR must be set. Otherwise,
>reader of error queue won't detect data in it using EPOLLERR bit.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

This patch looks like it can go even without this series.

Is it a fix? Should we add a fixes tag?

Thanks,
Stefano

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

