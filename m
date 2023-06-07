Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F5172696B
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 21:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbjFGTFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 15:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbjFGTFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 15:05:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06821BF8
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 12:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686164666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rZRm6DmDwdSY2t/TbWoqBMMo2MbobuklLuQ1Cl8udYA=;
        b=YagCppEXlcUeJoufF1+KvZaj5a1+VxLnova6SPnH//5it2RdzGUwwWKWQRnEb0FfIt1qCg
        3KO2DeiG048SNklUuOckMfC65gCQB/Nr0sSurBgs9w6NY2snDYLyd6xdjrxKE5AgQlmTc/
        S5Ca/UBXWEGXqTDxEgPbrMHc1goi7Fg=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-575-uyR9hUG2PseLrW7K8600Eg-1; Wed, 07 Jun 2023 15:04:24 -0400
X-MC-Unique: uyR9hUG2PseLrW7K8600Eg-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-33bccb5e28fso9840425ab.2
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 12:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686164663; x=1688756663;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rZRm6DmDwdSY2t/TbWoqBMMo2MbobuklLuQ1Cl8udYA=;
        b=RUIT+mpY1UU5PMNiV3rD5We/aIBr8J6P4JYqLuLDszjzI70YCrsF/WV7+9DsAvAqni
         dNuLGGfyPoNgnHroFTtn4QPEgK36vEYOPYW4P2mnYfp2vHWM9sAqHmpA//GDQH2S4QCu
         lfEMa8Hmvmxxw4Ti5u9ld8Ph7j5Fe86n5/ir37cxaZYXqQ9BEYPz2MLw7doNqllsxIXU
         2E0V8CrX+4PYvBeFP/FyLjpOgmpVSiKAWgBi/zVrZjsHCPoteZH5HTSSpolIO2zZtvBe
         zyVKohnGKzTZg/8SSJjCh0to6MfSrQFDiMc6FkkESfjaBgH1BYArStpji5HGop8h0mqF
         g5rw==
X-Gm-Message-State: AC+VfDwEKO8Mn7jBANXxvw03C6AeHbCoKFTHE6vm24kke5iCpgsWH01c
        VoFWZYBfLN3okyBdMJYIcs5xxtw8Xef4uCGNoKo6+QUogDwo2sgfZuMrmfzc1i+NdfJlZa22ozh
        xWFcPX9nE6X4V
X-Received: by 2002:a92:d811:0:b0:33e:6378:d917 with SMTP id y17-20020a92d811000000b0033e6378d917mr934944ilm.9.1686164663401;
        Wed, 07 Jun 2023 12:04:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7KprSVN8b1hTvukEnA46t1uXbdQiiVXD96wSs0eVF3KdCip8bvnrwuwlITGCSycjc4UAHdpw==
X-Received: by 2002:a92:d811:0:b0:33e:6378:d917 with SMTP id y17-20020a92d811000000b0033e6378d917mr934933ilm.9.1686164663132;
        Wed, 07 Jun 2023 12:04:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m11-20020a924a0b000000b0033d2eba1800sm3908916ilf.15.2023.06.07.12.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 12:04:22 -0700 (PDT)
Date:   Wed, 7 Jun 2023 13:04:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, jgg@nvidia.com, clg@redhat.com
Subject: Re: [PATCH 2/3] vfio/platform: Cleanup Kconfig
Message-ID: <20230607130421.4e1b7ced.alex.williamson@redhat.com>
In-Reply-To: <7b4b8592-7857-b437-da06-2a6854fbf36b@redhat.com>
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
        <20230602213315.2521442-3-alex.williamson@redhat.com>
        <7b4b8592-7857-b437-da06-2a6854fbf36b@redhat.com>
Organization: Red Hat
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

On Wed, 7 Jun 2023 15:32:07 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> Hi Alex,
> 
> On 6/2/23 23:33, Alex Williamson wrote:
> > Like vfio-pci, there's also a base module here where vfio-amba depends on
> > vfio-platform, when really it only needs vfio-platform-base.  Create a
> > sub-menu for platform drivers and a nested menu for reset drivers.  Cleanup
> > Makefile to make use of new CONFIG_VFIO_PLATFORM_BASE for building the
> > shared modules and traversing reset modules.
> >
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/Makefile          |  2 +-
> >  drivers/vfio/platform/Kconfig  | 17 ++++++++++++++---
> >  drivers/vfio/platform/Makefile |  9 +++------
> >  3 files changed, 18 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> > index 151e816b2ff9..8da44aa1ea16 100644
> > --- a/drivers/vfio/Makefile
> > +++ b/drivers/vfio/Makefile
> > @@ -11,6 +11,6 @@ vfio-$(CONFIG_VFIO_VIRQFD) += virqfd.o
> >  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> >  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> >  obj-$(CONFIG_VFIO_PCI_CORE) += pci/
> > -obj-$(CONFIG_VFIO_PLATFORM) += platform/
> > +obj-$(CONFIG_VFIO_PLATFORM_BASE) += platform/
> >  obj-$(CONFIG_VFIO_MDEV) += mdev/
> >  obj-$(CONFIG_VFIO_FSL_MC) += fsl-mc/
> > diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
> > index 331a5920f5ab..6d18faa66a2e 100644
> > --- a/drivers/vfio/platform/Kconfig
> > +++ b/drivers/vfio/platform/Kconfig
> > @@ -1,8 +1,14 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> > +menu "VFIO support for platform devices"
> > +
> > +config VFIO_PLATFORM_BASE
> > +	tristate
> > +
> >  config VFIO_PLATFORM
> > -	tristate "VFIO support for platform devices"
> > +	tristate "Generic VFIO support for any platform device"
> >  	depends on ARM || ARM64 || COMPILE_TEST  
> I wonder if we couldn't put those dependencies at the menu level. I
> guess this also applies to AMBA. And just leave 'depends on ARM_AMBA ' in
> 
> config VFIO_AMBA?

Yup, we could, something like:

menu "VFIO support for platform devices"
	depends on ARM || ARM64 || COMPILE_TEST

And we could move VFIO_VIRQFD to VFIO_PLATFORM_BASE

config VFIO_PLATFORM_BASE
	tristate
	select VFIO_VIRQFD

VFIO_AMBA would then only depend on ARM_AMBA and both would select
VFIO_PLATFORM_BASE.

> 
> >  	select VFIO_VIRQFD
> > +	select VFIO_PLATFORM_BASE
> >  	help
> >  	  Support for platform devices with VFIO. This is required to make
> >  	  use of platform devices present on the system using the VFIO
> > @@ -10,10 +16,11 @@ config VFIO_PLATFORM
> >  
> >  	  If you don't know what to do here, say N.
> >  
> > -if VFIO_PLATFORM
> >  config VFIO_AMBA
> >  	tristate "VFIO support for AMBA devices"
> >  	depends on ARM_AMBA || COMPILE_TEST
> > +	select VFIO_VIRQFD
> > +	select VFIO_PLATFORM_BASE
> >  	help
> >  	  Support for ARM AMBA devices with VFIO. This is required to make
> >  	  use of ARM AMBA devices present on the system using the VFIO
> > @@ -21,5 +28,9 @@ config VFIO_AMBA
> >  
> >  	  If you don't know what to do here, say N.
> >  
> > +menu "VFIO platform reset drivers"
> > +	depends on VFIO_PLATFORM_BASE  
> I wonder if this shouldn't depend on VFIO_PLATFORM instead?
> There are no amba reset devices at the moment so why whould be compile
> them if VFIO_AMBA is set (which is unlikely by the way)?

I did see that AMBA sets reset_required = false, but at the same time
the handling of reset modules is in the base driver, so if there were
an AMBA reset driver, wouldn't it also live in the reset/ directory?
It seems like we'd therefore want to traverse into reset/Kconfig, but
maybe if all the current config options in there are non-AMBA we should
wrap them in 'if VFIO_PLATFORM' (or 'depends on' for each, but the 'if'
is marginally cleaner).  Thanks,

Alex

