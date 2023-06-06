Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34837724F69
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 00:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239812AbjFFWC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 18:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbjFFWC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 18:02:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AE0139
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 15:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686088928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4KQWsbzRdU+vvpD7pXHcp2ReeqKbouPijEKDTx4l0P4=;
        b=TF7Zjrf3l9RWn91fkfRxJoJfTkHWHoiFNbR66+fH1fWN/ivHamR1Bg93xtuT1UHrMnmFrP
        IOHs01A/+BpSQZncIkoADo/IuElliKMgEi7ZYcQ7Yb6oLU40gYT6tXvNLA+goeIcsV58lp
        M2FtPJpcSCmzt/rs1dHtN9QRpny3cSU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-C3eUzgHMP7SIRfqXJUqUfw-1; Tue, 06 Jun 2023 18:02:07 -0400
X-MC-Unique: C3eUzgHMP7SIRfqXJUqUfw-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-77760439873so525730539f.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 15:02:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686088626; x=1688680626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KQWsbzRdU+vvpD7pXHcp2ReeqKbouPijEKDTx4l0P4=;
        b=fcW6uoOovFlRz3Dh1w0r5ClmHbuAuthDSGfsIg2cVsUbTTFP6rAGRNf1BY4WKXmu6v
         Ztrxg3DCxqzIXWaLgKDAUv5Xsoh4CrHDu84XeJhvfIPvC/0WMKMLq/LCTY7oST6WwaOX
         oUoL2ki2QUJAhAnsSCmo2KoSHDxcfOLG7xZCado+l9bay2BS0aYyZaVHC0VO3rQwb4tu
         5F5eTuvHBIQ69QaZVupvXODCjHet06XTsYLvSYSH21UGruTUUGLMvTAvq4ULGcXES07i
         NRLmvZQmHMXUz7S/VXNzB15d7KaBOp+GKmKCQUQxzp96scUc2zswKweKKOebq+Yvh/b5
         MaiA==
X-Gm-Message-State: AC+VfDzU3z20IB/6NFlfg7V5qsRR5Bk1Slikt4H6kKTC0la6NlESA/rG
        EVHojWHhRA3Y0PIQ19x6jdJz0mRFgZFEpedWyx6U9rcJqtdmTJCkmSRyHAJFUzNqQnRnLQG3+qk
        zgeegmUhut8sh8RTGDU1r
X-Received: by 2002:a92:ce46:0:b0:33c:b395:a898 with SMTP id a6-20020a92ce46000000b0033cb395a898mr2851828ilr.18.1686088625989;
        Tue, 06 Jun 2023 14:57:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6OVcLErBJiCjsOzZRri8SCyN5S2KtygosZRKd+7LpJVKWCF87TJ5imdiP4ucCHKtnAO2qHuw==
X-Received: by 2002:a92:ce46:0:b0:33c:b395:a898 with SMTP id a6-20020a92ce46000000b0033cb395a898mr2851820ilr.18.1686088625777;
        Tue, 06 Jun 2023 14:57:05 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e6-20020a02a506000000b0041f52ea3514sm1787339jam.158.2023.06.06.14.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 14:57:05 -0700 (PDT)
Date:   Tue, 6 Jun 2023 15:57:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, clg@redhat.com, liulongfang@huawei.com,
        shameerali.kolothum.thodi@huawei.com, yishaih@nvidia.com,
        kevin.tian@intel.com
Subject: Re: [PATCH 1/3] vfio/pci: Cleanup Kconfig
Message-ID: <20230606155704.037a1f60.alex.williamson@redhat.com>
In-Reply-To: <ZH9BvcgHvX7HFBAa@nvidia.com>
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
        <20230602213315.2521442-2-alex.williamson@redhat.com>
        <ZH4U6ElPSC3wIp1E@nvidia.com>
        <20230605132518.2d536373.alex.williamson@redhat.com>
        <ZH9BvcgHvX7HFBAa@nvidia.com>
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

On Tue, 6 Jun 2023 11:25:01 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jun 05, 2023 at 01:25:18PM -0600, Alex Williamson wrote:
> > On Mon, 5 Jun 2023 14:01:28 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Fri, Jun 02, 2023 at 03:33:13PM -0600, Alex Williamson wrote:  
> > > > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> > > > index 70e7dcb302ef..151e816b2ff9 100644
> > > > --- a/drivers/vfio/Makefile
> > > > +++ b/drivers/vfio/Makefile
> > > > @@ -10,7 +10,7 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> > > >  
> > > >  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> > > >  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> > > > -obj-$(CONFIG_VFIO_PCI) += pci/
> > > > +obj-$(CONFIG_VFIO_PCI_CORE) += pci/
> > > >  obj-$(CONFIG_VFIO_PLATFORM) += platform/
> > > >  obj-$(CONFIG_VFIO_MDEV) += mdev/
> > > >  obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/    
> > > 
> > > This makes sense on its own even today  
> > 
> > It's only an academic fix today, currently nothing in pci/ can be
> > selected without VFIO_PCI.
> >   
> > > > diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
> > > > index f9d0c908e738..86bb7835cf3c 100644
> > > > --- a/drivers/vfio/pci/Kconfig
> > > > +++ b/drivers/vfio/pci/Kconfig
> > > > @@ -1,5 +1,7 @@
> > > >  # SPDX-License-Identifier: GPL-2.0-only
> > > > -if PCI && MMU
> > > > +menu "VFIO support for PCI devices"
> > > > +	depends on PCI && MMU    
> > > 
> > > 
> > > I still think this is excessive, it is normal to hang the makefile
> > > components off the kconfig for the "core". Even VFIO is already doing this:
> > > 
> > > menuconfig VFIO
> > >         tristate "VFIO Non-Privileged userspace driver framework"
> > >         select IOMMU_API
> > >         depends on IOMMUFD || !IOMMUFD
> > >         select INTERVAL_TREE
> > >         select VFIO_CONTAINER if IOMMUFD=n
> > > 
> > > [..]
> > > 
> > > obj-$(CONFIG_VFIO) += vfio.o  
> > 
> > I think the "core" usually does something on its own though without
> > out-of-tree drivers,  
> 
> Not really, maybe it creates a sysfs class, but it certainly doesn't
> do anything useful unless there is a vfio driver also selected.

Sorry, I wasn't referring to vfio "core" here, I was thinking more
along the lines of when we include the PCI or IOMMU subsystem there's
a degree of base functionality included there regardless of what
additional options or drivers are selected.  OTOH, if we enable
CONFIG_VFIO without any in-kernel drivers for it, it's simply a waste of
space.

> > so I don't see this as an example of how things
> > should work as much as it is another target for improvement.  
> 
> It is the common pattern in the kernel, I'm not sure where you are
> getting this "improvement" idea from.

Common practice or not, configurations that build and install a module
that has no possibility of an in-kernel user is a waste of time and
space, which leaves room for improvement.
 
> > Ideally I think we'd still have a top level menuconfig, but it should
> > look more like VIRT_DRIVERS, which just enables Makefile traversal and
> > unhides menu options.  It should be things like VFIO_PCI_CORE or
> > VFIO_MDEV that actually select VFIO.    
> 
> There are many ways to use kconfig, but I think this is not typical
> usage and becomes over complicated to solve an unimportant problem.
> 
> The menu configs follow the makefiles which is nice and simple to
> understand and implement.

But leaves open the possibility of building and installing modules that
have no users, which therefore make them open for improvement.  I don't
see anything overly complicated in this series.  We certainly have more
important topics to quibble about than a select or depend, but here we
are.

The current state is that we cannot build vfio-pci-core.ko without
vfio-pci.ko, so there's always an in-kernel user.  The proposal which
allows building vfio-pci-core.ko w/o any in-kernel users is therefore a
regression (imo) prompting this alternative.  CONFIG_VFIO is a separate
pre-existing issue.  Thanks,

Alex

