Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA54530FD6
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 15:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbiEWKpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 06:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiEWKpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 06:45:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FA7C49C8B
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 03:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653302705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ro0AbdD3qiV64NTFTkLB8uvz3K/Lp6OAyllXm8fL7es=;
        b=AiXnCWdcidetuB/cq9oQUHnGGl+aJ7M95HN25OhqQ/+gYrMXyLImvaUdxML2fuw4HcMrhC
        xyEtCrEkkadRq6r2V/fmOolt7OC+El5vntf9NUzg3QZ7TGu5DzbLwRNGefRbthsc1uCSzJ
        hY3A4GO6RoqTH81UIOewClG+6dOK8nI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-zWGFmiz1PSi4nx1nFFEhjA-1; Mon, 23 May 2022 06:45:04 -0400
X-MC-Unique: zWGFmiz1PSi4nx1nFFEhjA-1
Received: by mail-wm1-f70.google.com with SMTP id h133-20020a1c218b000000b003972dbb1066so6951034wmh.4
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 03:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ro0AbdD3qiV64NTFTkLB8uvz3K/Lp6OAyllXm8fL7es=;
        b=dn1pKwLEHSZRsz7nFQw4w4QGS2AIId9jyhtnrHOdDr6Dmk3pBvCx6/QD/ncDnfrUEu
         btkxqqJvDFuB2W9OsbOApBMRPrm4N+tQNu0Wea1HbBRNxEfLbHxdupxxBZ015RR4vNBR
         64YerT1fZ352edx7WPlfl2DUqWyHuxOQyGuD9+cNfc8iVEo5u2EQo8o1nwKB94OFgOFx
         zRGwK/FRZIuEZyVtY1u/tTY6fgiTWixRM17NvT1i9g8BxfOQ/Aiy4dsz1zP+lLUzpaZp
         54PjDe32nhXNqEpRgQad02vrqdBRXiA4dHYw+4Wmx1OuQEtQMI+ZJtT5FFmqP1rNuYGk
         4V2Q==
X-Gm-Message-State: AOAM533vETLekt+ccbMjMWX0wJri6jZcI4uGHd1GZnuihArbXPlspHLs
        lK0n2/eatiBPni45Y/mY7iY+FtNTHBepEa3qBrgu47H9f350TVyNLqvELNuGUmcCosfvK1i0sB0
        d9Wna271VAa4a
X-Received: by 2002:a5d:6d8f:0:b0:20c:7fb7:d59c with SMTP id l15-20020a5d6d8f000000b0020c7fb7d59cmr19553210wrs.77.1653302701915;
        Mon, 23 May 2022 03:45:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqmvkqQTTuxAVZdOZ/+3TrYKOlXX86OeWQQ0yzjlLLs+0xsSNUd2ZLXvr3yj3HjivcPxFqLg==
X-Received: by 2002:a5d:6d8f:0:b0:20c:7fb7:d59c with SMTP id l15-20020a5d6d8f000000b0020c7fb7d59cmr19553190wrs.77.1653302701675;
        Mon, 23 May 2022 03:45:01 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id m10-20020adfc58a000000b0020e63ab5d78sm9696809wrg.26.2022.05.23.03.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:45:01 -0700 (PDT)
Date:   Mon, 23 May 2022 12:44:58 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        kernel-janitors@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] vhost-vdpa: return -EFAULT on copy_to_user() failure
Message-ID: <20220523104458.exaf2zb3lua76ibf@sgarzare-redhat>
References: <YotG1vXKXXSayr63@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YotG1vXKXXSayr63@kili>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 23, 2022 at 11:33:26AM +0300, Dan Carpenter wrote:
>The copy_to_user() function returns the number of bytes remaining to be
>copied.  However, we need to return a negative error code, -EFAULT, to
>the user.
>
>Fixes: 87f4c217413a ("vhost-vdpa: introduce uAPI to get the number of virtqueue groups")
>Fixes: e96ef636f154 ("vhost-vdpa: introduce uAPI to get the number of address spaces")
>Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>---
> drivers/vhost/vdpa.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>index 3e86080041fc..935a1d0ddb97 100644
>--- a/drivers/vhost/vdpa.c
>+++ b/drivers/vhost/vdpa.c
>@@ -609,11 +609,13 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
> 		r = vhost_vdpa_get_vring_num(v, argp);
> 		break;
> 	case VHOST_VDPA_GET_GROUP_NUM:
>-		r = copy_to_user(argp, &v->vdpa->ngroups,
>-				 sizeof(v->vdpa->ngroups));
>+		if (copy_to_user(argp, &v->vdpa->ngroups,
>+				 sizeof(v->vdpa->ngroups)))
>+			r = -EFAULT;
> 		break;
> 	case VHOST_VDPA_GET_AS_NUM:
>-		r = copy_to_user(argp, &v->vdpa->nas, sizeof(v->vdpa->nas));
>+		if (copy_to_user(argp, &v->vdpa->nas, sizeof(v->vdpa->nas)))
>+			r = -EFAULT;
> 		break;
> 	case VHOST_SET_LOG_BASE:
> 	case VHOST_SET_LOG_FD:
>-- 
>2.35.1
>
>_______________________________________________
>Virtualization mailing list
>Virtualization@lists.linux-foundation.org
>https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>

