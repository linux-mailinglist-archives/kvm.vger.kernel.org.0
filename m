Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D7C73A3F7
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 16:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbjFVO6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 10:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjFVO61 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 10:58:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1AAA2
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 07:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687445856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=StWTcZ4+l9QPhbORn1PrY5bDL4InPF3vO5n1F8OE0xo=;
        b=IGQGjznsbYFIdxMVyWYZ9G7N9Gn66LDTHJOoqGdywaQ0eBJvXmym3jfY+CmOqSBprzEXJd
        9KKh5PhGeSQSlq31adoxcm3JHWz8YJM6cE6Xr/JTo1/MNm/KLG7wnAij0tC6T07WiedYke
        1KuNDt2lCsnnGOQAGqwpVgV0ztG8GrY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-138-qxs0lCEPOZCEmMROvKHBLg-1; Thu, 22 Jun 2023 10:57:30 -0400
X-MC-Unique: qxs0lCEPOZCEmMROvKHBLg-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-31126581e13so10269107f8f.2
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 07:57:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687445846; x=1690037846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StWTcZ4+l9QPhbORn1PrY5bDL4InPF3vO5n1F8OE0xo=;
        b=D5exOuNIs80p6OfBXAGRdGwpMi9PJIdD9uCJR9A5bCU6UgQ9al1jiW2DIe6u4csi8p
         LeGKwfwnEwHrDmb5I5RNCeyvZtgGe7Cv6D52btAQwjZvbABqqVVcWvx7MwzeN/adKii3
         PGSWGXeUhkZcckdZSA4ocYQWgEHysw2Nzcd1BZ+MYNCWat73puLcRPVv0yiQsYAC7Q0H
         W7J1VQ8Mp3HQWIPKCasJDprjSuASpCk0Cut/kDuhcqSs4a012g5fTGEpMQW3xtviVxES
         ebVULJeWDONmacrGhhLW+H28RAWoO+a1Tl5CkQzz+wVFd1NVAclMZgFWOhs9jP+/hkOA
         hVYA==
X-Gm-Message-State: AC+VfDy0hInq/n50mi1oeBrlP1etFwzZ8+o792yxKvvkg/Nj2GXGz8+t
        mWAf65H4fE5LSc7rjTo767JjBiWSacvvzRfsnyj/8HwO33OKoJUANZZ9EdzTEIHYNWUG0FoZknw
        yGKRprWB1wNCM
X-Received: by 2002:adf:cf11:0:b0:30a:e435:63a6 with SMTP id o17-20020adfcf11000000b0030ae43563a6mr19252143wrj.4.1687445846765;
        Thu, 22 Jun 2023 07:57:26 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6buBbyxIEJzfQL6PgRyTGWSK7AHMk6+0fjAWJPeOmyomH1eoQU5jcnnNJ9NYA+HxSgqoL/xA==
X-Received: by 2002:adf:cf11:0:b0:30a:e435:63a6 with SMTP id o17-20020adfcf11000000b0030ae43563a6mr19252133wrj.4.1687445846476;
        Thu, 22 Jun 2023 07:57:26 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-160.retail.telecomitalia.it. [87.11.6.160])
        by smtp.gmail.com with ESMTPSA id e10-20020a5d65ca000000b002f28de9f73bsm7231665wrw.55.2023.06.22.07.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 07:57:25 -0700 (PDT)
Date:   Thu, 22 Jun 2023 16:57:22 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Simon Horman <simon.horman@corigine.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC net-next v4 2/8] vsock: refactor transport lookup code
Message-ID: <ytlovggd6p6m5i3ye2y7qgtdhss57lqnohgkixp5z3imh6trv7@jnfdvnhstgyf>
References: <20230413-b4-vsock-dgram-v4-0-0cebbb2ae899@bytedance.com>
 <20230413-b4-vsock-dgram-v4-2-0cebbb2ae899@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230413-b4-vsock-dgram-v4-2-0cebbb2ae899@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 10, 2023 at 12:58:29AM +0000, Bobby Eshleman wrote:
>Introduce new reusable function vsock_connectible_lookup_transport()
>that performs the transport lookup logic.
>
>No functional change intended.
>
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>---
> net/vmw_vsock/af_vsock.c | 25 ++++++++++++++++++-------
> 1 file changed, 18 insertions(+), 7 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index ffb4dd8b6ea7..74358f0b47fa 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -422,6 +422,22 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
> 	vsk->transport = NULL;
> }
>
>+static const struct vsock_transport *
>+vsock_connectible_lookup_transport(unsigned int cid, __u8 flags)
>+{
>+	const struct vsock_transport *transport;
>+
>+	if (vsock_use_local_transport(cid))
>+		transport = transport_local;
>+	else if (cid <= VMADDR_CID_HOST || !transport_h2g ||
>+		 (flags & VMADDR_FLAG_TO_HOST))
>+		transport = transport_g2h;
>+	else
>+		transport = transport_h2g;
>+
>+	return transport;
>+}
>+
> /* Assign a transport to a socket and call the .init transport callback.
>  *
>  * Note: for connection oriented socket this must be called when vsk->remote_addr
>@@ -462,13 +478,8 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
> 		break;
> 	case SOCK_STREAM:
> 	case SOCK_SEQPACKET:
>-		if (vsock_use_local_transport(remote_cid))
>-			new_transport = transport_local;
>-		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
>-			 (remote_flags & VMADDR_FLAG_TO_HOST))
>-			new_transport = transport_g2h;
>-		else
>-			new_transport = transport_h2g;
>+		new_transport = vsock_connectible_lookup_transport(remote_cid,
>+								   remote_flags);
> 		break;
> 	default:
> 		return -ESOCKTNOSUPPORT;
>
>-- 
>2.30.2
>

