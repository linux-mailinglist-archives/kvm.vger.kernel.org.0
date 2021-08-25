Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAFF3F6C7B
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 02:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhHYAUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 20:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHYAUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 20:20:03 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C16C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:19:18 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id bk29so19531413qkb.8
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FmMe62JjRAAEC6fo9KJVLuaofCc7+1A6LYoO1aZIh3U=;
        b=AP8glDA+4bnwz0eCR8xrSej3J4lOOEMvY8hwhWgQLShYigVRJIl8GS/g9la7CR55Pc
         prGExw5MGHynuhE5BBlokQ2keCnFS9y9uGf30G6vZmOOxHWtP/bImxiICwQHHOrB042N
         MuX7EdSyDSE+3pHGSB5Y9SK2lDLBk2TZkmyYAoqj6eAX8YSHimFZiYRO7ifNNoagxC7r
         rUiLbPEi2GOZW+cTv2RA+LLjgc+zuPnemAUtgdmAqu4pFk4Nz0bj8JK2A9zwFVtC//Kn
         X6qH+eBj6zA1Oqo8sA46C2zjoBb4jkmuX+FZurDnkO+pLL/pDHfcq/jpHKlZtLYjV2Tr
         MJyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FmMe62JjRAAEC6fo9KJVLuaofCc7+1A6LYoO1aZIh3U=;
        b=ZwkSPrK6btBI89dlWmf2z5OggGcVusOGFvIdulKR3RG21vwbJRnWgc7XU5r6V9aA6x
         hNfYJLo4QZkqE+kNEIdaUO5g5AUR8FFuk0Sfo9DQDsBc5bFRwrKugixeiTeAMGgBAq6R
         oSPRKTx8dt5DhD4chqfLosXCaMlAAolSLDUu/nrMeHXnTCQbpJC6ByJqrGaQJvPO7uj7
         uSjY1LnSOyHwPRVHUWZtrgBbdVYNOog5Q7fLRcDpYZZj2pZS9toNo2YAJzo1wGMaY1Wt
         QQt1lwbnYdjLgRwuzU92hlIzI18sSq86pRS+oYtmptX4+w4z1Z4nlefSvxyOsxIgaYRG
         UqlQ==
X-Gm-Message-State: AOAM533Pfn1d8Fs3xyFuwL9UMeiyoqsNQppK8AJatby9o0lg4D7vZGQc
        bhz5lOi34m3dcRA4THaFodfW5g==
X-Google-Smtp-Source: ABdhPJzyKQHLStr/Y41H14PcVXQayzyZPTibNajLniK/EOwuF4zatqGb0CZG7/szERWNpBruqcP81g==
X-Received: by 2002:a37:8906:: with SMTP id l6mr29462082qkd.210.1629850757960;
        Tue, 24 Aug 2021 17:19:17 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id g12sm9018563qtq.92.2021.08.24.17.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:19:17 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIgdQ-004j0L-GJ; Tue, 24 Aug 2021 21:19:16 -0300
Date:   Tue, 24 Aug 2021 21:19:16 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Message-ID: <20210825001916.GN543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-8-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:42PM +0200, Christoph Hellwig wrote:

> +int vfio_register_group_dev(struct vfio_device *device)
> +{
> +	return __vfio_register_dev(device,
> +		vfio_group_find_or_alloc(device->dev));
> +}
>  EXPORT_SYMBOL_GPL(vfio_register_group_dev);
>  
> +int vfio_register_mediated_dev(struct vfio_device *device)
> +{
> +	return __vfio_register_dev(device,
> +		vfio_noiommu_group_alloc(device->dev, VFIO_MEDIATED));
> +}
> +EXPORT_SYMBOL_GPL(vfio_register_mediated_dev);

The mechanism looks fine, but I think the core code is much clearer if
the name is not 'mediated' but 'sw_iommu' or something that implies
the group is running with a software page table. mediated has become
so overloaded in this code.

Really what this flag is doing is putting the group into a state where
the vfio_*pin_pages APIs are available once the vfio_device is opened.

So it really becomes an API family where a driver will call
vfio_regsiter_sw_iommu_dev(), then use the vfio_pin/unpin_pages API
set.

Jason
