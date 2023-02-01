Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2100A686F33
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 20:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjBATsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 14:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjBATsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 14:48:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58A07D6C1
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 11:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675280866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KsKUKAFzrjctC8+BAilBX6IagI/ItJtieRxvqFKd760=;
        b=E2+tC2s/tFGW4I7BF58QRtYkAmekkUtzFM7z5rTd7gjerARum5gK24wYRq7buNNJVvg+M5
        ylCIIilZB42mg8BPpude9ljv2PjPMkbvVmqHTd3TLL58GTjartFwVzWdFxmBo41vuP9eLl
        r93gmTYvyiO1AgfpZV1MF9qLnNR62v0=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-42-6DJfhE9RO9-7aQT5p9P6tg-1; Wed, 01 Feb 2023 14:47:45 -0500
X-MC-Unique: 6DJfhE9RO9-7aQT5p9P6tg-1
Received: by mail-io1-f70.google.com with SMTP id d24-20020a5d9bd8000000b006ee2ddf6d77so10827175ion.6
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 11:47:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KsKUKAFzrjctC8+BAilBX6IagI/ItJtieRxvqFKd760=;
        b=ttPgw8QCynGL6dsrhwi3IObYsCG8/1eN4S5kZrNr6IFH6C9AWStovav6NgsLz4eLTJ
         /WpaqHiUleCtontkM5BCHsxHQ9g4YJuQO70RqtcSQDtBqXoASFPWm8pUpEPPDPF0FYPP
         zmajYRcoJFHtuzdVPpYJ6v4D4+jFhRFilwVevv48NUSZAxKaUl20Q5iKZIelUmsfQ04X
         qzVOoYtUCw3+0JN7t74Jey5R+SdRkkm4IJabUDnsXC31f8HnKiIopAUN2iycow9aA+yB
         tye1TVvBYoursRSdiNYa35RfA5FRkNImv6jCPxmXI2DhFVrn2/ZclLD/Rs3+nW3y4HvX
         L6Xg==
X-Gm-Message-State: AO0yUKU0bMbpb7RY1AXA8L84TarvjFpSaciyXwNJ4XAAZioQ0k+/ThqS
        QDqrV7n2EfIUZdT8aaCS74VtaXlYOpsgSNDL++FzfLiT9W0YQ+nLu6vILdrPCpJbFUjZB/LtpE9
        GLTuWCcq8390P
X-Received: by 2002:a05:6e02:148a:b0:310:a04d:abe with SMTP id n10-20020a056e02148a00b00310a04d0abemr156517ilk.2.1675280864956;
        Wed, 01 Feb 2023 11:47:44 -0800 (PST)
X-Google-Smtp-Source: AK7set8hQtblrX3fZRITnWeYooAK206rRg3w/eVZ5M/TUcA5JZjwlnYCEG6N3A0HHAQjRHmRWSpQCg==
X-Received: by 2002:a05:6e02:148a:b0:310:a04d:abe with SMTP id n10-20020a056e02148a00b00310a04d0abemr156493ilk.2.1675280864721;
        Wed, 01 Feb 2023 11:47:44 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y2-20020a056e020f4200b0031107762217sm1943410ilj.3.2023.02.01.11.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 11:47:44 -0800 (PST)
Date:   Wed, 1 Feb 2023 12:47:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tomasz Duszynski <tduszynski@marvell.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "open list:VFIO PLATFORM DRIVER" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, <jerinj@marvell.com>
Subject: Re: [PATCH v2] vfio: platform: ignore missing reset if disabled at
 module init
Message-ID: <20230201124742.08f15a1a.alex.williamson@redhat.com>
In-Reply-To: <20230131083349.2027189-1-tduszynski@marvell.com>
References: <20230131083349.2027189-1-tduszynski@marvell.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 Jan 2023 09:33:49 +0100
Tomasz Duszynski <tduszynski@marvell.com> wrote:

> If reset requirement was relaxed via module parameter errors caused by
> missing reset should not be propagated down to the vfio core.
> Otherwise initialization will fail.
> 
> Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
> Fixes: 5f6c7e0831a1 ("vfio/platform: Use the new device life cycle helpers")
> ---
> v2:
> - return directly instead of using ternary to do that
> 
>  drivers/vfio/platform/vfio_platform_common.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 1a0a238ffa35..7325ff463cf0 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -650,10 +650,13 @@ int vfio_platform_init_common(struct vfio_platform_device *vdev)
>  	mutex_init(&vdev->igate);
> 
>  	ret = vfio_platform_get_reset(vdev);
> -	if (ret && vdev->reset_required)
> +	if (ret && vdev->reset_required) {
>  		dev_err(dev, "No reset function found for device %s\n",
>  			vdev->name);
> -	return ret;
> +		return ret;
> +	}
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_init_common);

Applied to vfio next branch for v6.3.  Thanks,

Alex

