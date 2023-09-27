Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A274A7B0809
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 17:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjI0PVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 11:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbjI0PVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 11:21:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF9913A
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 08:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695828016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/EIbBjpy9O83n9qhTihg7QeV6q2TpAQGQwYAPKsUVIA=;
        b=QO89LwHhSWpEQ4Gz3cRzfuyNbnv5oYIy+zCXT8xrhhL+LU5tJvomGXdovRlAaEhmFAxr8y
        FtXHI6lt7v7HWZCpOVYh5zbudijqZOWtzX1/TfdUw12+C9CKXSaVWGliIH64QVjzhxenuc
        OACWAlHx349touXCJ2q+iYci/S7xBVE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-D8s8bm-iPii3P-hhu-vnow-1; Wed, 27 Sep 2023 11:20:14 -0400
X-MC-Unique: D8s8bm-iPii3P-hhu-vnow-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-315af0252c2so9267051f8f.0
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 08:20:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695828011; x=1696432811;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/EIbBjpy9O83n9qhTihg7QeV6q2TpAQGQwYAPKsUVIA=;
        b=Xt0kNnYjSxJbu/Q4XrzpUJ1ae+F8acBRpzPVdR1LMERmxpM9p1R5Sxu4mMw82uS0FB
         RpNfXT3vRquQw0i5D3TtJQRB+lPWzAhIgC7sATQFQY8iOfSpKI9OLD6WCRxJYMBVnlrC
         1sGsgqcQXFFB1v2kphLOUinqULw5S9aomTct+sRg8xWS0tqTdq9e2a2vG+4jqfsxh5u+
         9cs0IjxPuYbHIRJKypi2i2Yh6wOvyQunS4GvtLoE86ZnH/xNJdJOen2e/7tQglB4p4ey
         QLpZVCbHP2S1O2N887k8FHJvmnDCib2qcC7XDyynFYd6o9E3Oo6RdmpDG1ioEm9E5QI0
         BULQ==
X-Gm-Message-State: AOJu0YzPqEo6vDUFXmPWIBfK7Pyp0RUW7oGavKoplLWcFm/cWwa7kWCl
        8t8hjNbycAgrxnszkxIz7M4DaI0KZG3213cLdoPEauBv0vEkICAbfOdQXOn9wCVywUMLeZQLvMM
        gRfi5dE4wIfZOO0Ur6zVW
X-Received: by 2002:a5d:4cc7:0:b0:314:a3f:9c08 with SMTP id c7-20020a5d4cc7000000b003140a3f9c08mr1876011wrt.39.1695828011766;
        Wed, 27 Sep 2023 08:20:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdjsQhdmBlcldN4VQo0/wB1Ma3pLJGSeiqWpRsH5/5aS/zWnrBptxpvSLI02eGQaomR+j8gQ==
X-Received: by 2002:a5d:4cc7:0:b0:314:a3f:9c08 with SMTP id c7-20020a5d4cc7000000b003140a3f9c08mr1875993wrt.39.1695828011418;
        Wed, 27 Sep 2023 08:20:11 -0700 (PDT)
Received: from redhat.com ([2a02:14f:16e:b9f6:556e:c001:fe18:7e0a])
        by smtp.gmail.com with ESMTPSA id x17-20020a5d6511000000b0031fd849e797sm17324370wru.105.2023.09.27.08.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 08:20:10 -0700 (PDT)
Date:   Wed, 27 Sep 2023 11:20:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     liming.wu@jaguarmicro.com
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 398776277@qq.com
Subject: Re: [PATCH 2/2] tools/virtio: Add hints when module is not installed
Message-ID: <20230927111904-mutt-send-email-mst@kernel.org>
References: <20230926050021.717-1-liming.wu@jaguarmicro.com>
 <20230926050021.717-2-liming.wu@jaguarmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230926050021.717-2-liming.wu@jaguarmicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 01:00:20PM +0800, liming.wu@jaguarmicro.com wrote:
> From: Liming Wu <liming.wu@jaguarmicro.com>
> 
> Need to insmod vhost_test.ko before run virtio_test.
> Give some hints to users.
> 
> Signed-off-by: Liming Wu <liming.wu@jaguarmicro.com>
> ---
>  tools/virtio/virtio_test.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> index 028f54e6854a..ce2c4d93d735 100644
> --- a/tools/virtio/virtio_test.c
> +++ b/tools/virtio/virtio_test.c
> @@ -135,6 +135,10 @@ static void vdev_info_init(struct vdev_info* dev, unsigned long long features)
>  	dev->buf = malloc(dev->buf_size);
>  	assert(dev->buf);
>  	dev->control = open("/dev/vhost-test", O_RDWR);
> +
> +	if (dev->control < 0)
> +		fprintf(stderr, "Install vhost_test module" \
> +		"(./vhost_test/vhost_test.ko) firstly\n");

Thanks!

things to improve:

firstly -> first
add space before (
End sentence with a dot
align "" on the two lines

>  	assert(dev->control >= 0);
>  	r = ioctl(dev->control, VHOST_SET_OWNER, NULL);
>  	assert(r >= 0);
> -- 
> 2.34.1

