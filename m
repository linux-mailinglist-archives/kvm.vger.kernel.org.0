Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C044A6995FF
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 14:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjBPNlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 08:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBPNld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 08:41:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB084A1FF
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 05:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676554846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y98TLzC7T3MjlRAfco0hk5x9PJvmulya2RupI5c7FMk=;
        b=eu6sf+9ulluL7PPyS9xUmzmMaQiKjWuigF0RfzhMm3p/FX+xAEay1UcDdiDgt6RFjJOMGe
        ONRpS5jm9gIxj6lHCtE9DRRzA3e/si3X4ZLMMJtC8+qciM4T1aGL0MRGT5H/xQWoxgzNtG
        R3I+NSCGdETpOvH3OyigIZloVfh9DZo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-652-jVFnyuhYOOGyqx29KtEXNw-1; Thu, 16 Feb 2023 08:40:44 -0500
X-MC-Unique: jVFnyuhYOOGyqx29KtEXNw-1
Received: by mail-qk1-f200.google.com with SMTP id g6-20020ae9e106000000b00720f9e6e3e2so1203215qkm.13
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 05:40:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y98TLzC7T3MjlRAfco0hk5x9PJvmulya2RupI5c7FMk=;
        b=cLtMTSE7tbcf3bcBkUBNIvtKgaU6HnqYKn8YG3uy0rhHidOzT1jnTpiGTMGxSDfEAP
         qMVlj92kIQn9lqAjvF92TK2eiOWOx+jld4oSr9fhz62Dyb86QdiQvkpCULadi34ENHXQ
         I5yc0Zbp8/eKq3HlZFELO2CtSCqc8QsOS7gY29G7uyVg+MO76mtILRLK5D5jwRLycWye
         UXS1jb0VNRX1ojjC7S+f3ePEvI5Lxk3ukhbaknxdUm7jFoVbJ67X+d1XuYzPxObSzo3v
         qHbHvJ+KfbFc8/6hSLrIwG/5AqFNNY3OIAjIwZTaFGX+wrNAVOUk4lqxqCJb+jgGX/qZ
         wKsg==
X-Gm-Message-State: AO0yUKVX3485IrVcnv6wpIq3blZIj6Y5QAcCKlUtZkrAD8PeazHL8tEZ
        J07pPBuf8LaKZIPMcogIfzbgBbZR7bD//os5sWOReXca6iHQQutAYTQ7yxeoVO7U6jPCje825Pg
        ZeDANccWwey+Q
X-Received: by 2002:ac8:5c8a:0:b0:3b6:36a0:adbe with SMTP id r10-20020ac85c8a000000b003b636a0adbemr9858797qta.6.1676554844467;
        Thu, 16 Feb 2023 05:40:44 -0800 (PST)
X-Google-Smtp-Source: AK7set+u2XfrViYGYBUOAnQ+C6klosItAnWhnmgPEyZDck8HDSLvs4kyoFZDdTEvpoeeeF5P7hlYrA==
X-Received: by 2002:ac8:5c8a:0:b0:3b6:36a0:adbe with SMTP id r10-20020ac85c8a000000b003b636a0adbemr9858769qta.6.1676554844177;
        Thu, 16 Feb 2023 05:40:44 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id z143-20020a376595000000b0073ba211e765sm228285qkb.19.2023.02.16.05.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:40:43 -0800 (PST)
Date:   Thu, 16 Feb 2023 14:40:39 +0100
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
Subject: Re: [RFC PATCH v1 01/12] vsock: check error queue to set EPOLLERR
Message-ID: <20230216134039.rgnb2hnzgme2ve76@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <17a276d3-1112-3431-2a33-c17f3da67470@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <17a276d3-1112-3431-2a33-c17f3da67470@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 06, 2023 at 06:53:22AM +0000, Arseniy Krasnov wrote:
>If socket's error queue is not empty, EPOLLERR must be set.

Could this patch go regardless of this series?

Can you explain (even in the commit message) what happens without this
patch?

Thanks,
Stefano

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 19aea7cba26e..b5e51ef4a74c 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1026,7 +1026,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
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

