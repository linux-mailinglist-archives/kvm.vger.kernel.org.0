Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE5674A29B
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 18:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbjGFQzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 12:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjGFQzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 12:55:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26ACC1BE9
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 09:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688662486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=glhZ+2qeJMm9MWfPWx9SoMWGjL42JiHnlLy0ooXyD8I=;
        b=dznWdg8z4xUewzZv4Wm5RLsCmxbtNJiuXN6LYVeHiKh/fLtIltB2qLFizSen43bM+kscoS
        raKj/1842HXIMO/XLeh6/mr9X3Y+zT8fdmpiU8lSIpBuprJy+bMZB9/wXT/JzeW3Eo86jj
        c+9kQSgdwcUz0SB1fZC1uVN5zF9RDOQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-CUhY1TIBPpqnAPvUzwEnyw-1; Thu, 06 Jul 2023 12:54:43 -0400
X-MC-Unique: CUhY1TIBPpqnAPvUzwEnyw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-98890dda439so47174566b.1
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 09:54:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688662482; x=1691254482;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=glhZ+2qeJMm9MWfPWx9SoMWGjL42JiHnlLy0ooXyD8I=;
        b=VomWqO1PuA3d4sIpL41/SFiRq3Whrc1ezmU2bclauc3v1HVTsTLYWT+rtxWLjrYjON
         c3OwUUh0t7By6UdFz3Yl5m+PegPBND4cgKNrzbARszUFqu/My+xbuYC/zcVMc5hQalvt
         YDmHwaB3Wbx/yEY2Zo8NhLDjmuIfxHMH2CfF7u9lnY+PsonLtxyePYo3uYZzhhAQl05t
         YbCLWtO80GMLwpRyF/XA8FzyJ3pKVR3D1Go4yZfnLYV2xoQXRVc9XPdYs9U0qFel795p
         WHF6tGbwnbaXe9ITs8xdHKitU9YkGtAp+dRow6U+C6V8SRvj0nR+2Ci0ZOc0E3RfkY68
         Bnew==
X-Gm-Message-State: ABy/qLb3821cdsVltwCwsproy2zQyvkmV8+V8DG5jYAU4EnR+67EbVdq
        znw2anHOFr2adS761y2r5P8gL/6jr2O03DYQPBE84QIIIlt6+O4r6uvTf9buQhM+SKAPCF+DFZW
        54UVWHLoaDL4Y
X-Received: by 2002:a17:906:89a0:b0:98c:cc3c:194e with SMTP id gg32-20020a17090689a000b0098ccc3c194emr1668117ejc.52.1688662482341;
        Thu, 06 Jul 2023 09:54:42 -0700 (PDT)
X-Google-Smtp-Source: APBJJlF62VXDxBiD2YIMucVbmZsWHocuUY9mKHoepmGkw2mj8oHke7cYIWYsLK4/i6qDTk9eWPxoDA==
X-Received: by 2002:a17:906:89a0:b0:98c:cc3c:194e with SMTP id gg32-20020a17090689a000b0098ccc3c194emr1668102ejc.52.1688662482046;
        Thu, 06 Jul 2023 09:54:42 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-163.retail.telecomitalia.it. [79.46.200.163])
        by smtp.gmail.com with ESMTPSA id k12-20020a170906970c00b0096f6a131b9fsm1034242ejx.23.2023.07.06.09.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 09:54:41 -0700 (PDT)
Date:   Thu, 6 Jul 2023 18:54:39 +0200
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
Subject: Re: [RFC PATCH v5 07/17] vsock: read from socket's error queue
Message-ID: <ho76zima4fe7yxm5ckj66ibgyl6kstjaexf4x5dxq7azjamoif@tny2uqb5yifn>
References: <20230701063947.3422088-1-AVKrasnov@sberdevices.ru>
 <20230701063947.3422088-8-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230701063947.3422088-8-AVKrasnov@sberdevices.ru>
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

On Sat, Jul 01, 2023 at 09:39:37AM +0300, Arseniy Krasnov wrote:
>This adds handling of MSG_ERRQUEUE input flag in receive call. This flag
>is used to read socket's error queue instead of data queue. Possible
>scenario of error queue usage is receiving completions for transmission
>with MSG_ZEROCOPY flag. This patch also adds 'SOL_VSOCK' define.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> Changelog:
> v4 -> v5:
>  * Update commit message by adding sentence that 'SOL_VSOCK' is also
>    added.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
> include/linux/socket.h   | 1 +
> net/vmw_vsock/af_vsock.c | 5 +++++
> 2 files changed, 6 insertions(+)
>
>diff --git a/include/linux/socket.h b/include/linux/socket.h
>index bd1cc3238851..d79efd026880 100644
>--- a/include/linux/socket.h
>+++ b/include/linux/socket.h
>@@ -382,6 +382,7 @@ struct ucred {
> #define SOL_MPTCP	284
> #define SOL_MCTP	285
> #define SOL_SMC		286
>+#define SOL_VSOCK	287
>
> /* IPX options */
> #define IPX_TYPE	1
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 45fd20c4ed50..07803d9fbf6d 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -110,6 +110,7 @@
> #include <linux/workqueue.h>
> #include <net/sock.h>
> #include <net/af_vsock.h>
>+#include <linux/errqueue.h>
>
> static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
> static void vsock_sk_destruct(struct sock *sk);
>@@ -2135,6 +2136,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	int err;
>
> 	sk = sock->sk;
>+
>+	if (unlikely(flags & MSG_ERRQUEUE))
>+		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
>+
> 	vsk = vsock_sk(sk);
> 	err = 0;
>
>-- 
>2.25.1
>

