Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87F876C766
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 09:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbjHBHuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 03:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbjHBHtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 03:49:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076F235A1
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 00:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690962376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=h0UDSjpYhDP6foyjtQosf3cDeLd01SyV7B6Zn77rW4I=;
        b=hVlz3z9oubslwFeNNfP1fFqZuRqYGw7POGtZt/4+j9N0PvOqXix6iTAuT+NrtFQapRAMmF
        kfpuCF6tC4i3WSc038+9VEanZn67ddivfGIu4Ya2dIJ8osEjAd7V83xMsfLJSEmVZAXWSb
        C/aS+S211EQcDepzZeomwPoVZPvYHB4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-2htY7CvANk2hWxcNEAZ7FA-1; Wed, 02 Aug 2023 03:46:14 -0400
X-MC-Unique: 2htY7CvANk2hWxcNEAZ7FA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-76c83aab2c7so676697885a.0
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 00:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690962374; x=1691567174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h0UDSjpYhDP6foyjtQosf3cDeLd01SyV7B6Zn77rW4I=;
        b=mD0w7EBacJdzsSjYTZPBH1ftg28DhEhjtbDDEs+49FFu7rSPzSPP32k45He1ou0GzP
         SzzR0J4DX5PHudl79EGqrbrZdstFY0pl88geboTKjTbMCILO+Ney7h2XBuLVfVfFoopS
         2VkVzSQbo+j2x8oSJ1q9u5anuXeEWze7civKfKiMx/17LsNQ8UH8cC0gcRFSaZWMHHHb
         cOtzLRzRIRBcpM4v81CxArmM6cyn7l0SKX/PdaiA1dsSfwanA3CpUXP+2uHL0NaGv+IU
         S46vTgqYlS+ZfwNmYULmK6N1Uqy7HsKBaY0c/LCAX/zNGMBIG5KkhVl7BJwQod9dM0KA
         DjVQ==
X-Gm-Message-State: ABy/qLYCbg8lKfwYJGhlzzswyWZ1cfafYfdbtknDLsSTTPyV5iuTWzsV
        OksS2srKKNvAQO4aGOPn64521wuR00b6CUvpd3zKhq/h0yJgrUoiZvSPis5e64/PkADIX6XfNfJ
        6cN7tg86nmaMe
X-Received: by 2002:a05:620a:2ae7:b0:76c:a35d:ee7b with SMTP id bn39-20020a05620a2ae700b0076ca35dee7bmr10630789qkb.75.1690962374344;
        Wed, 02 Aug 2023 00:46:14 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFodtYusq4miD67/qZPAflmfAiVup1o7pJRX1yLg/dsHxa8uZugDcgzMDc/Lwni4Tbe0+BMww==
X-Received: by 2002:a05:620a:2ae7:b0:76c:a35d:ee7b with SMTP id bn39-20020a05620a2ae700b0076ca35dee7bmr10630782qkb.75.1690962374098;
        Wed, 02 Aug 2023 00:46:14 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-214.retail.telecomitalia.it. [82.57.51.214])
        by smtp.gmail.com with ESMTPSA id f10-20020a0ccc8a000000b0062439f05b87sm5270298qvl.45.2023.08.02.00.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 00:46:13 -0700 (PDT)
Date:   Wed, 2 Aug 2023 09:46:08 +0200
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
Subject: Re: [RFC PATCH v1 1/2] vsock: send SIGPIPE on write to shutdowned
 socket
Message-ID: <qgn26mgfotc7qxzp6ad7ezkdex6aqniv32c5tvehxh4hljsnvs@x7wvyvptizxx>
References: <20230801141727.481156-1-AVKrasnov@sberdevices.ru>
 <20230801141727.481156-2-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230801141727.481156-2-AVKrasnov@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 01, 2023 at 05:17:26PM +0300, Arseniy Krasnov wrote:
>POSIX requires to send SIGPIPE on write to SOCK_STREAM socket which was
>shutdowned with SHUT_WR flag or its peer was shutdowned with SHUT_RD
>flag. Also we must not send SIGPIPE if MSG_NOSIGNAL flag is set.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 020cf17ab7e4..013b65241b65 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1921,6 +1921,9 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
> 			err = total_written;
> 	}
> out:
>+	if (sk->sk_type == SOCK_STREAM)
>+		err = sk_stream_error(sk, msg->msg_flags, err);

Do you know why we don't need this for SOCK_SEQPACKET and SOCK_DGRAM?

Thanks,
Stefano

>+
> 	release_sock(sk);
> 	return err;
> }
>-- 
>2.25.1
>

