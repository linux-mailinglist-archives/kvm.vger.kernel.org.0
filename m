Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DB47AED65
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 14:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234729AbjIZM5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 08:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbjIZM5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 08:57:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B14F3
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 05:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695732988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CddDDC+YI+osxwaqHzSITH6Nt7h9FcyMOVgoijeQ4uU=;
        b=NSolXkPnO6XZnOh1Xjl8Bk6Q0aCMRyhW7+6kKAkF1+dapEeinb0B0S8gXYBdBUOPZt6s1T
        z+L5p6JzB2XbJuY00KeHDwFDKoDcAi8FfQqXvJDAiu1qq+usbu5mu1C7SceJ4I6L3p+wYP
        Uw+MkXnw6BzXlXg2JwLEbyEFkRccs3Y=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-GW4_ZZaeOgGrkV9hP4cvSg-1; Tue, 26 Sep 2023 08:56:27 -0400
X-MC-Unique: GW4_ZZaeOgGrkV9hP4cvSg-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-99bebfada8cso729012566b.1
        for <kvm@vger.kernel.org>; Tue, 26 Sep 2023 05:56:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695732986; x=1696337786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CddDDC+YI+osxwaqHzSITH6Nt7h9FcyMOVgoijeQ4uU=;
        b=Vc3ycoad7Fnf8qKT3rGTkjpdUWczOyfkPC32SaKglhe0hSeEotZUYavZ9S2SHp6MdZ
         Bc7PQ5Aw+5IMJcy+sZ1dtz4rnFE44JzyG0Wu7+7KkBzyl66TniFjovCANhuNqYqG9+aN
         rVUlP0zRD456jDhz4Kcpx2MRKLH/VCJGrYQzQyh6vpAZV5cEct+yZ0ZCUHRyI7jAuGDV
         vNY+8OC1X1BSAFPGwD48pSC38JUqtQVdA9pjALdHlwqfi6xoJ/IFf8y5+6NwwUCeaXJG
         8SrNwQBmQLots+i+n5ozsEYOuGni2ocNdkzuf7WpyunWdpQcB6BxeEszC8zyj/eXlrVb
         wVAg==
X-Gm-Message-State: AOJu0Yzdw53EHifzT1mL9kVkHS27eTI2XX3NRCNMewmdazKs1oEBo4NY
        N1HCtfcVmF+XIx0McIdEX7898DVtocxE4BZlDPDY4+WrtsnCCuTFUSRQqm/WlzoakLStXZIi7D4
        rlVSKHltl1YhF
X-Received: by 2002:a17:906:1053:b0:9ae:76a2:7022 with SMTP id j19-20020a170906105300b009ae76a27022mr7553821ejj.38.1695732986335;
        Tue, 26 Sep 2023 05:56:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYIrhN3P+JunkiZ5FgZXx3Bbhz4TDm2/Kn4vGreEaUXS+V3cU+FHm9hTpW1zj5nQMrff4I8w==
X-Received: by 2002:a17:906:1053:b0:9ae:76a2:7022 with SMTP id j19-20020a170906105300b009ae76a27022mr7553804ejj.38.1695732986087;
        Tue, 26 Sep 2023 05:56:26 -0700 (PDT)
Received: from sgarzare-redhat ([46.6.146.182])
        by smtp.gmail.com with ESMTPSA id u12-20020a1709064acc00b009a1e73f2b4bsm7729413ejt.48.2023.09.26.05.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 05:56:25 -0700 (PDT)
Date:   Tue, 26 Sep 2023 14:56:21 +0200
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
Subject: Re: [PATCH net-next v1 08/12] vsock: enable setting SO_ZEROCOPY
Message-ID: <ynuctxau4ta4pk763ut7gfdaqzcuyve7uf2a2iltyspravs5uf@xrtqtbhuuvwq>
References: <20230922052428.4005676-1-avkrasnov@salutedevices.com>
 <20230922052428.4005676-9-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230922052428.4005676-9-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 08:24:24AM +0300, Arseniy Krasnov wrote:
>For AF_VSOCK, zerocopy tx mode depends on transport, so this option must
>be set in AF_VSOCK implementation where transport is accessible (if
>transport is not set during setting SO_ZEROCOPY: for example socket is
>not connected, then SO_ZEROCOPY will be enabled, but once transport will
>be assigned, support of this type of transmission will be checked).
>
>To handle SO_ZEROCOPY, AF_VSOCK implementation uses SOCK_CUSTOM_SOCKOPT
>bit, thus handling SOL_SOCKET option operations, but all of them except
>SO_ZEROCOPY will be forwarded to the generic handler by calling
>'sock_setsockopt()'.
>
>Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>---
> Changelog:
> v5(big patchset) -> v1:
>  * Compact 'if' conditions.
>  * Rename 'zc_val' to 'zerocopy'.
>  * Use 'zerocopy' value directly in 'sock_valbool_flag()', without
>    ?: operator.
>  * Set 'SOCK_CUSTOM_SOCKOPT' bit for connectible sockets only, as
>    suggested by Bobby Eshleman <bobbyeshleman@gmail.com>.
>
> net/vmw_vsock/af_vsock.c | 46 ++++++++++++++++++++++++++++++++++++++--
> 1 file changed, 44 insertions(+), 2 deletions(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 482300eb88e0..c05a42e02a17 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1406,8 +1406,16 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
> 			goto out;
> 		}
>
>-		if (vsock_msgzerocopy_allow(transport))
>+		if (vsock_msgzerocopy_allow(transport)) {
> 			set_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
>+		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>+			/* If this option was set before 'connect()',
>+			 * when transport was unknown, check that this
>+			 * feature is supported here.
>+			 */
>+			err = -EOPNOTSUPP;
>+			goto out;
>+		}
>
> 		err = vsock_auto_bind(vsk);
> 		if (err)
>@@ -1643,7 +1651,7 @@ static int vsock_connectible_setsockopt(struct socket *sock,
> 	const struct vsock_transport *transport;
> 	u64 val;
>
>-	if (level != AF_VSOCK)
>+	if (level != AF_VSOCK && level != SOL_SOCKET)
> 		return -ENOPROTOOPT;
>
> #define COPY_IN(_v)                                       \
>@@ -1666,6 +1674,34 @@ static int vsock_connectible_setsockopt(struct socket *sock,
>
> 	transport = vsk->transport;
>
>+	if (level == SOL_SOCKET) {
>+		int zerocopy;
>+
>+		if (optname != SO_ZEROCOPY) {
>+			release_sock(sk);
>+			return sock_setsockopt(sock, level, optname, optval, optlen);
>+		}
>+
>+		/* Use 'int' type here, because variable to
>+		 * set this option usually has this type.
>+		 */
>+		COPY_IN(zerocopy);
>+
>+		if (zerocopy < 0 || zerocopy > 1) {
>+			err = -EINVAL;
>+			goto exit;
>+		}
>+
>+		if (transport && !vsock_msgzerocopy_allow(transport)) {
>+			err = -EOPNOTSUPP;
>+			goto exit;
>+		}
>+
>+		sock_valbool_flag(sk, SOCK_ZEROCOPY,
>+				  zerocopy);

it's not necessary to wrap this call.

>+		goto exit;
>+	}
>+
> 	switch (optname) {
> 	case SO_VM_SOCKETS_BUFFER_SIZE:
> 		COPY_IN(val);
>@@ -2322,6 +2358,12 @@ static int vsock_create(struct net *net, struct socket *sock,
> 		}
> 	}
>
>+	/* SOCK_DGRAM doesn't have 'setsockopt' callback set in its
>+	 * proto_ops, so there is no handler for custom logic.
>+	 */
>+	if (sock_type_connectible(sock->type))
>+		set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
>+
> 	vsock_insert_unbound(vsk);
>
> 	return 0;
>-- 
>2.25.1
>

