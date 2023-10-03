Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A107B6E56
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 18:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbjJCQYJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 12:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240305AbjJCQYI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 12:24:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F72AB
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 09:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696350205;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K8nJSyCd6Mj6/uVIoeX6vSBcbL415T2j/UKJhN/9HxQ=;
        b=Sai8HJMhi7Uwjt+q1B5PCX3oLqUIaT6SESSkD6w7hWOnDflgFIh6IWY33xbEaLqibxRTQJ
        ZuAMQ57W7ylzBY6bn16CV18atOKYBSFVU8fpm58RaD3LZaJ42nlkTMD3JOJUOOePLhy2L4
        2ru8AC/OarK7Pc/tsJlMDSo8cYxfMwo=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-pwFM-q59MX23ffOg1jTwdg-1; Tue, 03 Oct 2023 12:23:19 -0400
X-MC-Unique: pwFM-q59MX23ffOg1jTwdg-1
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-65afb9c405aso11353586d6.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 09:23:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696350199; x=1696954999;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K8nJSyCd6Mj6/uVIoeX6vSBcbL415T2j/UKJhN/9HxQ=;
        b=CpDnsRNvG5YxC+77HZc3E2PSA+uJ6ai3lOhnP7GEVEmDebt6D3X700Sxrcq3/cb7JT
         eo+VH/c9IweV/a7MBNezphSQK8TSt7MMcVSVQEx55VEGsi6yvsZ0pl6tJ7O0EUV3Cqzv
         zA/Jat+ZAoMPPxo7By8Vo08wQw6CC1OB6gemDC3kUo9szP5DqtZWjKXtXy3AzWpfshtr
         GxqrP/Iz6w0fTcoI7lxEicEZUNtcA8Lob+lPmCChVjw7Nby70Xlr1g1+LsyvGXhSHiHs
         zfukJezxFqr+ksq5QtRWsqP1aF911ew0ARK3VFfl9RrwcJF8kfJFln43EsKgpGB8xT85
         TuWg==
X-Gm-Message-State: AOJu0Yymx8aI9zVpLdIgafKdEV1f+bMSIdXrQS/Py7U3Y5gLUw3fD2Q7
        cC1WmUbEkFwzUoxGFcbZrwF7icm0N+sCkry8avG2uw8D+lbTiFPDz+DIuArjhVT0A6kK+uAatn5
        DsHpVZmcEYoCJ
X-Received: by 2002:a0c:f04c:0:b0:658:a29a:e297 with SMTP id b12-20020a0cf04c000000b00658a29ae297mr12037766qvl.49.1696350198909;
        Tue, 03 Oct 2023 09:23:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8uQkWWDZB3h/ubLuDg4GpK42nrIzlPUoFwtgf5CmfllU3UftYG/UPLqG6M4Qulj6QX9ZOAw==
X-Received: by 2002:a0c:f04c:0:b0:658:a29a:e297 with SMTP id b12-20020a0cf04c000000b00658a29ae297mr12037737qvl.49.1696350198592;
        Tue, 03 Oct 2023 09:23:18 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id vv22-20020a05620a563600b0076ca9f79e1fsm580607qkn.46.2023.10.03.09.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 09:23:18 -0700 (PDT)
Date:   Tue, 3 Oct 2023 18:23:13 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@salutedevices.com>
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
Subject: Re: [PATCH net-next v2 02/12] vsock: read from socket's error queue
Message-ID: <2o6wtfwxa3xeurri2tomed3zkdginsgu7gty7bvf5solgyheck@45pkpcol2xb3>
References: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
 <20230930210308.2394919-3-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230930210308.2394919-3-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 01, 2023 at 12:02:58AM +0300, Arseniy Krasnov wrote:
>This adds handling of MSG_ERRQUEUE input flag in receive call. This flag
>is used to read socket's error queue instead of data queue. Possible
>scenario of error queue usage is receiving completions for transmission
>with MSG_ZEROCOPY flag. This patch also adds new defines: 'SOL_VSOCK'
>and 'VSOCK_RECVERR'.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v1 -> v2:
>  * Place new defines for userspace to the existing file 'vm_sockets.h'
>    instead of creating new one.
>
> include/linux/socket.h          | 1 +
> include/uapi/linux/vm_sockets.h | 4 ++++
> net/vmw_vsock/af_vsock.c        | 6 ++++++
> 3 files changed, 11 insertions(+)
>
>diff --git a/include/linux/socket.h b/include/linux/socket.h
>index 39b74d83c7c4..cfcb7e2c3813 100644
>--- a/include/linux/socket.h
>+++ b/include/linux/socket.h
>@@ -383,6 +383,7 @@ struct ucred {
> #define SOL_MPTCP	284
> #define SOL_MCTP	285
> #define SOL_SMC		286
>+#define SOL_VSOCK	287
>
> /* IPX options */
> #define IPX_TYPE	1
>diff --git a/include/uapi/linux/vm_sockets.h b/include/uapi/linux/vm_sockets.h
>index c60ca33eac59..b1a66c1a7054 100644
>--- a/include/uapi/linux/vm_sockets.h
>+++ b/include/uapi/linux/vm_sockets.h
>@@ -191,4 +191,8 @@ struct sockaddr_vm {
>
> #define IOCTL_VM_SOCKETS_GET_LOCAL_CID		_IO(7, 0xb9)
>
>+#define SOL_VSOCK	287
>+
>+#define VSOCK_RECVERR	1

Please add good documentation for both of them. This is an header
exposed to the user space.

>+
> #endif /* _UAPI_VM_SOCKETS_H */
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index d841f4de33b0..0365382beab6 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -110,6 +110,8 @@
> #include <linux/workqueue.h>
> #include <net/sock.h>
> #include <net/af_vsock.h>
>+#include <linux/errqueue.h>
>+#include <uapi/linux/vm_sockets.h>

Let's keep the alphabetic order as it was before this change.

`net/af_vsock.h` already includes the `uapi/linux/vm_sockets.h`,
and we also use several defines from it in this file, so you can also
skip it.

On the other end it would be better to directly include the headers that
we use, so it's also okay to keep it. As you prefer.

>
> static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
> static void vsock_sk_destruct(struct sock *sk);
>@@ -2137,6 +2139,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	int err;
>
> 	sk = sock->sk;
>+
>+	if (unlikely(flags & MSG_ERRQUEUE))
>+		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, VSOCK_RECVERR);
>+
> 	vsk = vsock_sk(sk);
> 	err = 0;
>
>-- 
>2.25.1
>

