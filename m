Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843C255A54D
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 02:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbiFYANH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 20:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiFYANH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 20:13:07 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1CB175B1
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 17:13:06 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id u14so4234373qvv.2
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 17:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+zgAHdqbW6KkxfirWh5m0boNH0Y6RXgaT47LaNHIE6s=;
        b=DVIjgeM5e5IxUFbVXZ7bgClbz5kfHXGvHXEg2J3j1BQd6oPPHRoewezWMdHbNFicJ2
         e88e2BFNzXDV37YHXmXCkVZ8MSZynmhSNdYhhX27BUG5Sv0V13MLWDtWVjaDI7tP4ZIV
         wUUpA7Nqf5AVDpycjUx5jjljv7kK0PZZj+WblkbWltwp9EJJGdAFrdXwS8EbEqhL7IcE
         GG4nTIuwZPLNIA3MQxPKlazpGmrlhY26HgvE07OM0dSC/zWljIjNtEQVaWF8pWhBjRMw
         d8jR8emTGFIO8TphCmMEppdJirurBjsHWFxc61kaA8Ox6IwpINQXlr7sqntF23mHQ99z
         2w+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+zgAHdqbW6KkxfirWh5m0boNH0Y6RXgaT47LaNHIE6s=;
        b=BeenIhnif+pfDSeyWd65I9ff5FT+A5iSbkkRGy3XkCB40bnXkz7r0QxpV3OOYrNFwv
         qcJsBdiAmTlXUU5V+uYkavN7yxDPn4m2NuJt4bEARmCIPbrytRvnp5DqSMzuoYa1fQMd
         UsdlpsQo0q8FpRkVP3XXRz/f4Ypof1RNqRcdxOsdxp6q9dG0MHJcyjlC5iQDHqoD17KH
         dMwK4Mqa76pK1xZSj8eS+tIcy55BExedxOPIFipPbAA0+rkDtlv8Jfkekyas0q8ppAz5
         0DNSmxVlwomTIs088yNJR/n6JGWobmGZlu8kkIDiotim0A1DG6//aMh4i//VbbKYKOVG
         f3PA==
X-Gm-Message-State: AJIora+fZDk4A6DXEx8lme/jroLHIhwikQ9C4bVgDplvt/XcHCgtoTk6
        VBfvt6StAevvKT0sbVNcBtJ5Z+hdXNjJeg==
X-Google-Smtp-Source: AGRyM1tKAa61VnKF0qvWQse8/IPmP8YMv7v4wf/kj3KckZaMtp7TSh1O9Io45lQMqyoNxO2rydvc7Q==
X-Received: by 2002:a05:622a:1884:b0:304:f534:cfe5 with SMTP id v4-20020a05622a188400b00304f534cfe5mr1433458qtc.544.1656115985828;
        Fri, 24 Jun 2022 17:13:05 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id u3-20020a05620a454300b006aef6a244a4sm3108346qkp.129.2022.06.24.17.13.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 17:13:05 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1o4tQ8-001Idy-Qd; Fri, 24 Jun 2022 21:13:04 -0300
Date:   Fri, 24 Jun 2022 21:13:04 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     lizhe.67@bytedance.com
Cc:     alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan.x@bytedance.com
Subject: Re: [RFC] vfio: remove useless judgement
Message-ID: <20220625001304.GI23621@ziepe.ca>
References: <20220623115603.22288-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623115603.22288-1-lizhe.67@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 23, 2022 at 07:56:03PM +0800, lizhe.67@bytedance.com wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> In function vfio_dma_do_unmap(), we currently prevent process to unmap
> vfio dma region whose mm_struct is different from the vfio_dma->task.
> In our virtual machine scenario which is using kvm and qemu, this
> judgement stops us from liveupgrading our qemu, which uses fork() &&
> exec() to load the new binary but the new process cannot do the
> VFIO_IOMMU_UNMAP_DMA action during vm exit because of this judgement.
> 
> This judgement is added in commit 8f0d5bb95f76 ("vfio iommu type1: Add
> task structure to vfio_dma") for the security reason. But it seems that
> no other task who has no family relationship with old and new process
> can get the same vfio_dma struct here for the reason of resource
> isolation. So this patch delete it.
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 6 ------
>  1 file changed, 6 deletions(-)

I'm inclined to agree with this reasoning and deliberately did not
include a similar check in iommufd. Any process with access to the
container FD should be able to manipulate the IOVA space.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
