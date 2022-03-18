Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9354DD76C
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 10:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbiCRJzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 05:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiCRJzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 05:55:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A04E4129248
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 02:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647597269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B0N2tqLbrUYXG1JSQlScpTqqNArTVktmTNzG3PVVQ64=;
        b=KSNa1vkL5p7Eq2AnvtKNmWV5edLGovzXZqUAPllatqyY330F6R0rdPpuhhsE0RFJ4HuZyO
        oVB0xeuiTBwaGt959gxQra9qcUH7PNwjG0y3wnIXdZtaxoXq6Sk+YYxo5KOkLU5oZLXVlD
        y2WDomVTSQ1BNhOw3ZLco6r8Dk31YUo=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-9fYZgXstOWOD4vyqxjiEbg-1; Fri, 18 Mar 2022 05:54:28 -0400
X-MC-Unique: 9fYZgXstOWOD4vyqxjiEbg-1
Received: by mail-qt1-f197.google.com with SMTP id e28-20020ac8415c000000b002c5e43ca6b7so5315583qtm.9
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 02:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B0N2tqLbrUYXG1JSQlScpTqqNArTVktmTNzG3PVVQ64=;
        b=s/pLbkPremP8mGCiZvyEoXrvGcD6KmqW+qDX5RShxUQwyKY+b4c//SOVwuns6glFKV
         f7yD04GgyZBTdQ3eXM/H8SIKPLEK7wRcgacgGWEFCbpILWCgiY9yut/c08ovGC8U60IL
         U4hJzQKzUcB9etbnhXVoiaBWbGW1HvG27kvdAcciRFzRgLFS9UozFJG9Tzm5djwKPSfx
         R8J9dXJeCfb1QK67lju9J2/0sckG6l5UQaoQFJNllgamIJb4znXhhh5ENFWvtp+KHZQS
         L52xZ47L8JDYwity5F7wsOfQ6k3qk10aMI0zW6VCZPO4ArNFQGDNwmDbBSI+5MbdgU4b
         VFAA==
X-Gm-Message-State: AOAM532b5oMqkomEYfXpGefpzNIA7mu2WGOXdSUFxIq1S86L6rBq2nFC
        3HuP2ZRcDaLXSGlYCP+PkvXUUAXgUUvuX88WPa0srp6OLmzyT14vPGgpE/ev5ZH3URWcXwfYzO/
        Kpadrv2WVFznx
X-Received: by 2002:a0c:c404:0:b0:431:31c3:3d15 with SMTP id r4-20020a0cc404000000b0043131c33d15mr6517885qvi.116.1647597267948;
        Fri, 18 Mar 2022 02:54:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJww4OeEttXpHADmj/zwubxQlNCZdF6Q1KI9KtTuFS5WVsX1Yj8sug1rDI4IQP0gxF1xEeAyKQ==
X-Received: by 2002:a0c:c404:0:b0:431:31c3:3d15 with SMTP id r4-20020a0cc404000000b0043131c33d15mr6517872qvi.116.1647597267762;
        Fri, 18 Mar 2022 02:54:27 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id de26-20020a05620a371a00b0067dc7923b14sm3642875qkb.132.2022.03.18.02.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 02:54:27 -0700 (PDT)
Date:   Fri, 18 Mar 2022 10:54:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: handle error while adding split ranges to iotlb
Message-ID: <20220318095422.a37g7vxaiwqo5wxx@sgarzare-redhat>
References: <20220312141121.4981-1-mail@anirudhrb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220312141121.4981-1-mail@anirudhrb.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 12, 2022 at 07:41:21PM +0530, Anirudh Rayabharam wrote:
>vhost_iotlb_add_range_ctx() handles the range [0, ULONG_MAX] by
>splitting it into two ranges and adding them separately. The return
>value of adding the first range to the iotlb is currently ignored.
>Check the return value and bail out in case of an error.
>

We could add:

Fixes: e2ae38cf3d91 ("vhost: fix hung thread due to erroneous iotlb entries")

>Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
>---
> drivers/vhost/iotlb.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
>index 40b098320b2a..5829cf2d0552 100644
>--- a/drivers/vhost/iotlb.c
>+++ b/drivers/vhost/iotlb.c
>@@ -62,8 +62,12 @@ int vhost_iotlb_add_range_ctx(struct vhost_iotlb *iotlb,
> 	 */
> 	if (start == 0 && last == ULONG_MAX) {
> 		u64 mid = last / 2;
>+		int err = vhost_iotlb_add_range_ctx(iotlb, start, mid, addr,
>+				perm, opaque);
>+
>+		if (err)
>+			return err;
>
>-		vhost_iotlb_add_range_ctx(iotlb, start, mid, addr, perm, opaque);
> 		addr += mid + 1;
> 		start = mid + 1;
> 	}
>-- 
>2.35.1
>

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

