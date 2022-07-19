Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D04579F9E
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 15:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbiGSN3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 09:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239629AbiGSN2w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 09:28:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B450F85D5C
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658234681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nwoURb29VClO3NnOpfstDR3d53hCEYhJJWEs1w35jSE=;
        b=WGz36lvTBoWbLWIGpviANRjF00Z2PLucwxXknoIu93n2gS7wpKx2GkVZ7MZYRmQ0eNzNoH
        yiTzNoiqlxpc2qqOIy7IF0yxo2mkcj3UMHH21LzRrElZ6os9nlOi+QqfYgQAS2ms71685f
        v7skDUapNZB9NN9Z7bl45G3B+KhLJuw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-VUv2k5arN5ihhIZJXEACmg-1; Tue, 19 Jul 2022 08:44:38 -0400
X-MC-Unique: VUv2k5arN5ihhIZJXEACmg-1
Received: by mail-qv1-f69.google.com with SMTP id lb15-20020a056214318f00b00473726845c8so7244647qvb.8
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nwoURb29VClO3NnOpfstDR3d53hCEYhJJWEs1w35jSE=;
        b=sfWRO1G3G0V5WhsA3ztKVRWP1dfkxa7KpIkuPd3bWjcQoskvF88zXp+mAo5ikVxHyh
         gbgayiPkUHL6vrgroZ/Q13crkTfBt41sFaYy8zIutNhPvz6HPrhnCG4ZDLDDDTlJ5g4q
         Hu+WNy365YwsRMfD2G5zrP8+uqlDPVk164AgD5IRm23QcCX7prn4TdAy0CNKtxbGhTnN
         2119SkH+KxHF097mknC4Xcwbdn+lJqw2PIEbz9xNVjhQHNyjMrJQU0FINWrof92OYO+O
         NHpGRYhR+CB1+7bTX9SNvTSK8VmCP2DgJNxtNMX3AzwBTj/6AFZeM2mYNDoqvkCOUVNt
         au2Q==
X-Gm-Message-State: AJIora8IVHq4I0vF5oy3emRUXLwKqqbpiBUQlK/evTTkSEIqngqsSbV9
        8Ep6D4aLe9MPcz+98JE8uharAGY8Kqn11mJ9SMcYMkOd8OV3YFrQBcIr1h9PSJx4qEplRGb4Via
        9IXiXcf3+EiM6
X-Received: by 2002:a05:620a:4409:b0:6b5:9563:2357 with SMTP id v9-20020a05620a440900b006b595632357mr20517116qkp.394.1658234678309;
        Tue, 19 Jul 2022 05:44:38 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vfYt5xMGWnPHxRK79lORLDfPCOEjuG06J02WcZOiurWkTLl4+3VDRo/4HLmjvxNof1xrPgsQ==
X-Received: by 2002:a05:620a:4409:b0:6b5:9563:2357 with SMTP id v9-20020a05620a440900b006b595632357mr20517108qkp.394.1658234678086;
        Tue, 19 Jul 2022 05:44:38 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id t13-20020a37ea0d000000b006af147d4876sm13363159qkj.30.2022.07.19.05.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 05:44:37 -0700 (PDT)
Date:   Tue, 19 Jul 2022 14:44:29 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 1/3] vsock: use sk_skrcvlowat to set
 POLLIN,POLLRDNORM, bits.
Message-ID: <20220719124429.3y5hi7itx4hdkqbz@sgarzare-redhat>
References: <c8de13b1-cbd8-e3e0-5728-f3c3648c69f7@sberdevices.ru>
 <637e945f-f28a-86d9-a242-1f4be85d9840@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <637e945f-f28a-86d9-a242-1f4be85d9840@sberdevices.ru>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 18, 2022 at 08:15:42AM +0000, Arseniy Krasnov wrote:
>Both bits indicate, that next data read call won't be blocked,
>but when sk_rcvlowat is not 1,these bits will be set by poll
>anyway,thus when user tries to dequeue data, it will wait until
>sk_rcvlowat bytes of data will be available.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/af_vsock.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index f04abf662ec6..0225f3558e30 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -1067,7 +1067,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
> 		    !(sk->sk_shutdown & RCV_SHUTDOWN)) {
> 			bool data_ready_now = false;
> 			int ret = transport->notify_poll_in(
>-					vsk, 1, &data_ready_now);
>+					vsk, sk->sk_rcvlowat, &data_ready_now);

In tcp_poll() we have the following:
     int target = sock_rcvlowat(sk, 0, INT_MAX);

Maybe we can do the same here.

Thanks,
Stefano

> 			if (ret < 0) {
> 				mask |= EPOLLERR;
> 			} else {
>-- 
>2.25.1

