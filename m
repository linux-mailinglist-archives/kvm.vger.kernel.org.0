Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D51769A8EC
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 11:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjBQKN0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 05:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjBQKNY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 05:13:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6B362FF4
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 02:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676628757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Y7MkPKxQ4b4S+E2uuEcl4fSWKwkp7IBI4B2vVLi24A=;
        b=ClxYJ0hn4Jr7aQog7ltNWg76fmRK3NOEJcdlPIUCrT/eKgm/RZhIgVxlnDvJ6LPyBg8ntL
        ksIYg6CX1U9lbF5oc5QZMsjJ9PfeDRQkVpWQTY+LVaHOxx0b1S910LUrvuYiopCwUSLPRp
        W2bpWxpRBZiHp8Snb9sY+6Cz35DhpcQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-633-eNfdYF_pPTKpqHbOa_11Jw-1; Fri, 17 Feb 2023 05:12:36 -0500
X-MC-Unique: eNfdYF_pPTKpqHbOa_11Jw-1
Received: by mail-wm1-f72.google.com with SMTP id l36-20020a05600c1d2400b003dfe4bae099so417981wms.0
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 02:12:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Y7MkPKxQ4b4S+E2uuEcl4fSWKwkp7IBI4B2vVLi24A=;
        b=QNSJzi55J8BGyGRfMDnnE+diMn55rjbGlkPqxfJql/ckZ1x3cd+aWgeGrvCL9sX1a9
         WRmk78YMvMVi7WjxPA/Qqu/OeCtM2tkssIiUwywXPwoxBQnN0QtPSykqJRjf7KzqRNCe
         ACUk6bXtXHqdqnBmfY7hUFJvG1Ih+yUglZbOh8Kvns3J5C9o3VRaOBHgZayVjUJwDs41
         9Us1exCz66rF4ZqyAqQdJCull4wuZbrsT9wp46c+pPaqZbP99fTy5PDXNZcCNDgmAI5H
         9IItD675gcjajk2xJyinvQOokM/52jZAb6luWvCMVpgZeZCgE3/aU7z6dADxlyIECdJZ
         8UUA==
X-Gm-Message-State: AO0yUKUOKX5fcVxd/2sFZpN/GN+vhmg2hpC1f8YotTDGS2m4uE3qujB0
        DeGPjQy6s7q+Va7ya/U4xKO1gJhw6mvsZ3wSb34MhsMRqnXf8IJ0BEsenKmBp7icHk40wL4Ss9o
        BYi2UECIFzFcf
X-Received: by 2002:adf:f40b:0:b0:2c5:5ff8:93e5 with SMTP id g11-20020adff40b000000b002c55ff893e5mr6717181wro.44.1676628755108;
        Fri, 17 Feb 2023 02:12:35 -0800 (PST)
X-Google-Smtp-Source: AK7set9h4wA736ZeMYva3jBcgfzObA1Ee5DxMQNCqSjLJtJ9uB6fqQFZuR5r1/3OYbU7YpGJ6GX0bQ==
X-Received: by 2002:adf:f40b:0:b0:2c5:5ff8:93e5 with SMTP id g11-20020adff40b000000b002c55ff893e5mr6717163wro.44.1676628754834;
        Fri, 17 Feb 2023 02:12:34 -0800 (PST)
Received: from redhat.com ([2.52.5.34])
        by smtp.gmail.com with ESMTPSA id i3-20020a05600011c300b002c4061a687bsm3720864wrx.31.2023.02.17.02.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 02:12:34 -0800 (PST)
Date:   Fri, 17 Feb 2023 05:12:29 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Nanyong Sun <sunnanyong@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, jasowang@redhat.com,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, wangrong68@huawei.com
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
Message-ID: <20230217051158-mutt-send-email-mst@kernel.org>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+7G+tiBCjKYnxcZ@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023 at 08:14:50PM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> > From: Rong Wang <wangrong68@huawei.com>
> > 
> > Once enable iommu domain for one device, the MSI
> > translation tables have to be there for software-managed MSI.
> > Otherwise, platform with software-managed MSI without an
> > irq bypass function, can not get a correct memory write event
> > from pcie, will not get irqs.
> > The solution is to obtain the MSI phy base address from
> > iommu reserved region, and set it to iommu MSI cookie,
> > then translation tables will be created while request irq.
> 
> Probably not what anyone wants to hear, but I would prefer we not add
> more uses of this stuff. It looks like we have to get rid of
> iommu_get_msi_cookie() :\
> 
> I'd like it if vdpa could move to iommufd not keep copying stuff from
> it..

Absolutely but when is that happening?

> Also the iommu_group_has_isolated_msi() check is missing on the vdpa
> path, and it is missing the iommu ownership mechanism.
> 
> Also which in-tree VDPA driver that uses the iommu runs on ARM? Please
> don't propose core changes for unmerged drivers. :(
> 
> Jason

