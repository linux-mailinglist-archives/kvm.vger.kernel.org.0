Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6C67B6E5F
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 18:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjJCQYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 12:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240420AbjJCQYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 12:24:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81339E
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 09:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696350225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sfMS7si10Em3Ih0ewdIsQWk4sOjmW1agVLON4O4ZHFs=;
        b=alyLTwYFqGdC8+vuZ6KXziLaCB0LkveQGrPRNvkTa8GlWPlmrL3AD+82hpPJkECibVeVb0
        keDjj+WjntqBEqRnOgAlx1NV+O+5mYNHsBO0JV/5jkGiUBSkBPda8z4/k9eqSZOi2OkPo7
        pthpuB61hB+3IMVjQ53tJzt4M2ke1vA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-YE_irqEcMzqjq0nKM0z44Q-1; Tue, 03 Oct 2023 12:23:38 -0400
X-MC-Unique: YE_irqEcMzqjq0nKM0z44Q-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4180de770f5so12496941cf.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 09:23:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696350218; x=1696955018;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfMS7si10Em3Ih0ewdIsQWk4sOjmW1agVLON4O4ZHFs=;
        b=fBRwNQLu6XRHSqhbZhnUwzmkp6vxgDyqB7iHA+7AIYwYxIqU4A1HtuqTSI57DRSSSP
         dPzR0Y0NJecGh/kCpvpUEwWe8vLx9Qt2M7jkfC2/F0NpTn1VqP/+cPZ1XsIxYF3QH5Bu
         UnYjkVMewijldntsCrOru0Mgc5Gqylx8ltpcSDXd25jTrFsxSJN1FCIhjYmqiXof6DKe
         pvlE5jreONNsbbfkJ74HZebX4GhlCp0m9amjp2vbVnOguumLzbIDsas7JesDNnHsB+IN
         jUOhlq0hxTaRhRkYrADCYwSvAdBs8Tgnqm1XJ0HLiC+e3qyD/1PuJKix5GdADnokSz+v
         31iw==
X-Gm-Message-State: AOJu0YzyiJGWaFCJ3gc+rUsqyrUvPRkdz3tBcaaPnCVFpKNmN6fq7hV0
        72TnwMxDT8f9IRv0AOVKKyLkE/+djJOGD1HGik0pa4+IaRr4z/JwTe3CbQmd4UeSW255dSn/L/T
        GLJnnZl7dYpLH
X-Received: by 2002:ac8:149a:0:b0:419:af26:fc72 with SMTP id l26-20020ac8149a000000b00419af26fc72mr1872208qtj.27.1696350218260;
        Tue, 03 Oct 2023 09:23:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQy1JM0pldsNEW5rolW8PRXJCWF1GlYH0HqlcRRXiBOMMPAuTdsJD5SqR4LDPBV8ljq34JbQ==
X-Received: by 2002:ac8:149a:0:b0:419:af26:fc72 with SMTP id l26-20020ac8149a000000b00419af26fc72mr1872186qtj.27.1696350217966;
        Tue, 03 Oct 2023 09:23:37 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-114.retail.telecomitalia.it. [82.57.51.114])
        by smtp.gmail.com with ESMTPSA id d14-20020ac8118e000000b004198d026be6sm552077qtj.35.2023.10.03.09.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 09:23:37 -0700 (PDT)
Date:   Tue, 3 Oct 2023 18:23:33 +0200
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
Subject: Re: [PATCH net-next v2 08/12] vsock: enable setting SO_ZEROCOPY
Message-ID: <rtc5f42epcmjksoyrvkbjmomucdg2xg6a6e7d3dm2ewuoaqok3@x37szdvwflm6>
References: <20230930210308.2394919-1-avkrasnov@salutedevices.com>
 <20230930210308.2394919-9-avkrasnov@salutedevices.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230930210308.2394919-9-avkrasnov@salutedevices.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 01, 2023 at 12:03:04AM +0300, Arseniy Krasnov wrote:
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
> v1 -> v2:
>  * Place 'sock_valbool_flag()' in a single line.
>
> net/vmw_vsock/af_vsock.c | 45 ++++++++++++++++++++++++++++++++++++++--
> 1 file changed, 43 insertions(+), 2 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index ff44bab05191..a84f242466cf 100644
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
>@@ -1666,6 +1674,33 @@ static int vsock_connectible_setsockopt(struct socket *sock,
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
>+		sock_valbool_flag(sk, SOCK_ZEROCOPY, zerocopy);
>+		goto exit;
>+	}
>+
> 	switch (optname) {
> 	case SO_VM_SOCKETS_BUFFER_SIZE:
> 		COPY_IN(val);
>@@ -2322,6 +2357,12 @@ static int vsock_create(struct net *net, struct socket *sock,
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

