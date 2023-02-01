Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4B1686B07
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 17:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbjBAQAc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 11:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbjBAQAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 11:00:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715247519A
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 07:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675267141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XzoNqKV6Cz9SVsHFKDeNJCe9fKu9P6AEJ0vvGP1TI1k=;
        b=ATvOEFmY8ki5n98qVUxYX5zV/v8F8ohMbPwT2TVJuQPN5kg3Uq2LAn4fhSAGHL+Cg3hOK7
        91Ifo3yFJowjEX+G40HChzj/POHyrwtrf5ND5TEmT+K6pRpd52aJeiTLvTw9oWWAp/HX6w
        xIfReDx4xKJEyx86zyeEx2A/DOKfqsU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-107-e9uV5SdCPoypTV9JJ5Hhzw-1; Wed, 01 Feb 2023 10:52:41 -0500
X-MC-Unique: e9uV5SdCPoypTV9JJ5Hhzw-1
Received: by mail-wm1-f72.google.com with SMTP id bd21-20020a05600c1f1500b003dc5cb10dcfso4362975wmb.9
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 07:52:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XzoNqKV6Cz9SVsHFKDeNJCe9fKu9P6AEJ0vvGP1TI1k=;
        b=mB3Bw4r9jJMsHhgdv1M2yfffqo+KEawIeIMiqP+chaw6LqpBH6MZ33Si97y+Z4fVun
         6PNLMwNJTw1r0u41rUY7hnygj3P0MsrNZB4/REb5tp5VY8xX0dLcwO7PUb55FYTROJ7V
         XS5RvE0Kj9UMur0Vjcnyd43eEvvCAKna9MEgLoTPnb8SmWpEZcsLcJqdRUVlhgrdxRks
         mN7gys92m5jCXNRrZMsK1/EpQKuKmdO6525ugmt7vnzgZev3hTcYXMu/1bPRu/DEv5Qb
         sCHoF5cYBd3B6phoFMft3vrwxUIuRsItVYbQqjAoVGqyL0+aS6uIT8gvqxEJlLRlVcLt
         ELCw==
X-Gm-Message-State: AO0yUKXGegmqwyJ96BGAWw3Vny8QaAQY9bJPOBTk7BCLiDMKlT5U36/o
        uPK6I4RZ+NWq9VeOQq8ZgVEzFbTJkvwwSVAlFdML47XxUlc09Wq7Gsst9VL4TKxDC2x/QZY8X3O
        AavpbjpggJkfP
X-Received: by 2002:a5d:68c8:0:b0:2bb:6b92:d4cc with SMTP id p8-20020a5d68c8000000b002bb6b92d4ccmr2670032wrw.53.1675266759390;
        Wed, 01 Feb 2023 07:52:39 -0800 (PST)
X-Google-Smtp-Source: AK7set8qYSlMDMNOSFaN19grpNcj5RrzZI2G3D9+Cd/RumqUU7LsytpntPRQ2vaoy76EUXG76UA3pA==
X-Received: by 2002:a5d:68c8:0:b0:2bb:6b92:d4cc with SMTP id p8-20020a5d68c8000000b002bb6b92d4ccmr2670025wrw.53.1675266759217;
        Wed, 01 Feb 2023 07:52:39 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id j15-20020a5d452f000000b002be505ab59asm17589261wra.97.2023.02.01.07.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 07:52:38 -0800 (PST)
Date:   Wed, 1 Feb 2023 10:52:35 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        Eugenio Perez Martin <eperezma@redhat.com>
Subject: Re: [PATCH] vhost-vdpa: print error when vhost_vdpa_alloc_domain
 fails
Message-ID: <20230201105200-mutt-send-email-mst@kernel.org>
References: <20230201152018.1270226-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201152018.1270226-1-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 05:20:18PM +0200, Alvaro Karsz wrote:
> Add a print explaining why vhost_vdpa_alloc_domain failed if the device
> is not IOMMU cache coherent capable.
> 
> Without this print, we have no hint why the operation failed.
> 
> For example:
> 
> $ virsh start <domain>
> 	error: Failed to start domain <domain>
> 	error: Unable to open '/dev/vhost-vdpa-<idx>' for vdpa device:
> 	       Unknown error 524
> 
> Suggested-by: Eugenio Perez Martin <eperezma@redhat.com>
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>

I'm not sure this is a good idea. Userspace is not supposed to be
able to trigger dev_err.

> ---
>  drivers/vhost/vdpa.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 23db92388393..56287506aa0d 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1151,8 +1151,11 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>  	if (!bus)
>  		return -EFAULT;
>  
> -	if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
> +	if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY)) {
> +		dev_err(&v->dev,
> +			"Failed to allocate domain, device is not IOMMU cache coherent capable\n");
>  		return -ENOTSUPP;
> +	}
>  
>  	v->domain = iommu_domain_alloc(bus);
>  	if (!v->domain)
> -- 
> 2.34.1

