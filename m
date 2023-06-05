Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C1F722FCF
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 21:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbjFET26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 15:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjFET2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 15:28:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9BDA7
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 12:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685993285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L4y/xeRTz3az0seB+sUm79wiqxaqUWvSbEeC0T1el4Y=;
        b=Nwf7fGYbDqnkKUU0Fy7HgCe5JKJeS1ZWhWQsVUfNoe9Joz1P2UUFElSKai4CNJLr8Zrdvl
        EwbrWH8RHQXBx9tDMK44Yv56Btg2H7C/sS3CkMFJKyTuMM25omaDLSsh62VmHzO3L2rUqd
        DfNPAwZhCFCQRtnhfccIUjyrvmsUUsA=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-mFY6eODgPnWTD9OQ-eGEvQ-1; Mon, 05 Jun 2023 15:28:04 -0400
X-MC-Unique: mFY6eODgPnWTD9OQ-eGEvQ-1
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-558a4e869bcso1859323eaf.0
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 12:28:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685993284; x=1688585284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L4y/xeRTz3az0seB+sUm79wiqxaqUWvSbEeC0T1el4Y=;
        b=hEpwugXHTkC7aflhnolXSjcqvT8JpFIJWG6XpXEa6FLvG2Qzi6cvu0qsMyndqiLoMM
         w4CMJQbGIElOOOlGEblaTG8emnkstQAPha53vz5Z8bvaTI2OetmErEtUpOGQlLBA98Ps
         udHc6tDCpzNbwblZ/bgrShhOMQE5hkLHlbBGsNFqBfjPfHJJDDeJZNmtj/Bu+ZXV5r/A
         NWUOluc1cdwKcfSyMBOwzTSG/YgprShJIElgsay5WbyFaYazpy2DrJMrarEE5XY/qD23
         jyWNduNrVIQFWEqf1m2hPm2dx1IWwdauSJotO0ZKEbK0RJ9Ok1Ic7Xn74TMk6oKQqW3P
         g6hg==
X-Gm-Message-State: AC+VfDztspqsNXe9uQ/8rdUAbuNi0yvTmmiMlNnaB8oOo3XpKY/wYWaC
        3n7QTz2ukH95GqiPT7go1VhQG8EGOxh6J7g61Ui2WDWRcqnEl0K+/9zrvJhLuBYKugBNo9qg93y
        VaOryvGk57Edq
X-Received: by 2002:a92:cf4e:0:b0:33d:24f9:d537 with SMTP id c14-20020a92cf4e000000b0033d24f9d537mr694350ilr.26.1685993122113;
        Mon, 05 Jun 2023 12:25:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7y2FfDMF8ECQHUTuY+oFLbwvtJJ1ZusSezsvZ+teyfCtCmN1sy47MXbcZnzk3Rv3c9lfhcfQ==
X-Received: by 2002:a92:cf4e:0:b0:33d:24f9:d537 with SMTP id c14-20020a92cf4e000000b0033d24f9d537mr694339ilr.26.1685993121884;
        Mon, 05 Jun 2023 12:25:21 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id q18-20020a92d412000000b00331ab6616easm2573891ilm.67.2023.06.05.12.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 12:25:21 -0700 (PDT)
Date:   Mon, 5 Jun 2023 13:25:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, clg@redhat.com, liulongfang@huawei.com,
        shameerali.kolothum.thodi@huawei.com, yishaih@nvidia.com,
        kevin.tian@intel.com
Subject: Re: [PATCH 1/3] vfio/pci: Cleanup Kconfig
Message-ID: <20230605132518.2d536373.alex.williamson@redhat.com>
In-Reply-To: <ZH4U6ElPSC3wIp1E@nvidia.com>
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
        <20230602213315.2521442-2-alex.williamson@redhat.com>
        <ZH4U6ElPSC3wIp1E@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Jun 2023 14:01:28 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Jun 02, 2023 at 03:33:13PM -0600, Alex Williamson wrote:
> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> > index 70e7dcb302ef..151e816b2ff9 100644
> > --- a/drivers/vfio/Makefile
> > +++ b/drivers/vfio/Makefile
> > @@ -10,7 +10,7 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> >  
> >  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> >  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> > -obj-$(CONFIG_VFIO_PCI) += pci/
> > +obj-$(CONFIG_VFIO_PCI_CORE) += pci/
> >  obj-$(CONFIG_VFIO_PLATFORM) += platform/
> >  obj-$(CONFIG_VFIO_MDEV) += mdev/
> >  obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/  
> 
> This makes sense on its own even today

It's only an academic fix today, currently nothing in pci/ can be
selected without VFIO_PCI.

> > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > index f9d0c908e738..86bb7835cf3c 100644
> > --- a/drivers/vfio/pci/Kconfig
> > +++ b/drivers/vfio/pci/Kconfig
> > @@ -1,5 +1,7 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> > -if PCI && MMU
> > +menu "VFIO support for PCI devices"
> > +	depends on PCI && MMU  
> 
> 
> I still think this is excessive, it is normal to hang the makefile
> components off the kconfig for the "core". Even VFIO is already doing this:
> 
> menuconfig VFIO
>         tristate "VFIO Non-Privileged userspace driver framework"
>         select IOMMU_API
>         depends on IOMMUFD || !IOMMUFD
>         select INTERVAL_TREE
>         select VFIO_CONTAINER if IOMMUFD=n
> 
> [..]
> 
> obj-$(CONFIG_VFIO) += vfio.o

I think the "core" usually does something on its own though without
out-of-tree drivers, so I don't see this as an example of how things
should work as much as it is another target for improvement.

Ideally I think we'd still have a top level menuconfig, but it should
look more like VIRT_DRIVERS, which just enables Makefile traversal and
unhides menu options.  It should be things like VFIO_PCI_CORE or
VFIO_MDEV that actually select VFIO.  We shouldn't build vfio.ko if
there's nothing in-kernel that uses it, nor should we burden the user
with Kconfig options for other intermediate helper modules.  I see the
top level menuconfig as necessary to de-clutter the config, but ideally
users should be selecting config options based on actual functionality,
not just config options to enable other config options.

It looks like there are some non-trivial dependency loops that need to
be resolved if we hide VFIO and make is selected by other modules, so I
don't know that I'll be able to expand this series to include that
right now.  Thanks,

Alex

