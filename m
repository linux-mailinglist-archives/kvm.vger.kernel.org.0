Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12A2582659
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 14:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbiG0MYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 08:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbiG0MYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 08:24:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7077B45F5B
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 05:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658924668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dapYisiCBXlgZkwMi+Hyveg1G9f8dLox6yKCT12ZMlw=;
        b=AcN+saR5dMbsvPtmcHpvhEMKENBZHmcwhBexnHXoX6fsi1r66Dpqr5GNlEcaOIO/th8x85
        wMMDXeFZaVTZt6L2bP7q/PoVnkV3hu1rCn9kIrgbdqBWgvWU5xj20F4fj+eL8tHaxS87a6
        H2m8hw+i6E2sn+n4jRSwxDxLcaJIIyE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-IoYja9pSNKGPyAD5TorO0Q-1; Wed, 27 Jul 2022 08:24:24 -0400
X-MC-Unique: IoYja9pSNKGPyAD5TorO0Q-1
Received: by mail-wr1-f71.google.com with SMTP id q17-20020adfab11000000b0021e4c9ca970so2803068wrc.20
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 05:24:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dapYisiCBXlgZkwMi+Hyveg1G9f8dLox6yKCT12ZMlw=;
        b=cUqImT0Ut1tACAuu4+QYf5lTOcHfy9pIujEqyOjwvfN7c3wBll/O7D8pcpavzcT2z/
         gScEylieZQZFz4Hqnv6rDLQEwY/7q3aN6ysSHpQmBikZM+ng3nPj5M/oCKn+92qiSBhT
         mWp9QcNjcaa8wdut+8Yo65ROOL5gf0AK8e8gkCNlOgodyVByKy4J5rEYT1fMVzDBr4xS
         Qo2i8D3HPDq+hb7AFxOju9lS5jpnOEZiLm3Spyt1xlvre0DeOVEr7S8k1FfUY0BxAH+o
         zlyRsp/+sPe5NHov+4FEY6qiX9aqOpWjcfbv9SL2XBfjrQz8H4NdzCYNAOu4y/aDDIh1
         QgnA==
X-Gm-Message-State: AJIora8UoaXmt1ZG6y1j/YR/8jxQ9Q5WoywpZKITELTu1EVQJykD/cR/
        qQ5oYYFlP+MWKMnxwurRP9/bsRlf8pesw1VQQsU2OT/0dtbD4tJ5AHarK+sL87SmNrgZqJPTawK
        2NhaPzOaqo9DS
X-Received: by 2002:a05:6000:1541:b0:21d:b298:96be with SMTP id 1-20020a056000154100b0021db29896bemr13644421wry.206.1658924663471;
        Wed, 27 Jul 2022 05:24:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vC2MGRjFi3qSHZ2fm0BkjEDxRi6ABSiXhvcdsFTw4lBpGNZw6+Ua7w1AgH+IiVMbwoDfqM2g==
X-Received: by 2002:a05:6000:1541:b0:21d:b298:96be with SMTP id 1-20020a056000154100b0021db29896bemr13644403wry.206.1658924663274;
        Wed, 27 Jul 2022 05:24:23 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id bg26-20020a05600c3c9a00b003a3279b9037sm2308365wmb.16.2022.07.27.05.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 05:24:22 -0700 (PDT)
Date:   Wed, 27 Jul 2022 14:24:17 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 5/9] vsock: SO_RCVLOWAT transport set callback
Message-ID: <20220727122417.jvdfjnuybk3mwxkq@sgarzare-redhat>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <8baa2e3a-af6b-c0fe-9bfb-7cf89506474a@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8baa2e3a-af6b-c0fe-9bfb-7cf89506474a@sberdevices.ru>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022 at 08:05:28AM +0000, Arseniy Krasnov wrote:
>This adds transport specific callback for SO_RCVLOWAT, because in some
>transports it may be difficult to know current available number of bytes
>ready to read. Thus, when SO_RCVLOWAT is set, transport may reject it.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/net/af_vsock.h   |  1 +
> net/vmw_vsock/af_vsock.c | 19 +++++++++++++++++++
> 2 files changed, 20 insertions(+)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index f742e50207fb..eae5874bae35 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -134,6 +134,7 @@ struct vsock_transport {
> 	u64 (*stream_rcvhiwat)(struct vsock_sock *);
> 	bool (*stream_is_active)(struct vsock_sock *);
> 	bool (*stream_allow)(u32 cid, u32 port);
>+	int (*set_rcvlowat)(struct vsock_sock *, int);
>
> 	/* SEQ_PACKET. */
> 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 63a13fa2686a..b7a286db4af1 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2130,6 +2130,24 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	return err;
> }
>
>+static int vsock_set_rcvlowat(struct sock *sk, int val)
>+{
>+	const struct vsock_transport *transport;
>+	struct vsock_sock *vsk;
>+	int err = 0;
>+
>+	vsk = vsock_sk(sk);
>+	transport = vsk->transport;

`transport` can be NULL if the user call SO_RCVLOWAT before we assign 
it, so we should check it.

I think if the transport implements `set_rcvlowat`, maybe we should set 
there sk->sk_rcvlowat, so I would do something like that:

     if (transport && transport->set_rcvlowat)
         err = transport->set_rcvlowat(vsk, val);
     else
         WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);

     return err;

In addition I think we should check that val does not exceed 
vsk->buffer_size, something similar of what tcp_set_rcvlowat() does.

Thanks,
Stefano

