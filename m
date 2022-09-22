Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C435E6935
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 19:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbiIVRJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 13:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiIVRJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 13:09:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A172A2ED59
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663866581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pd4NQd/acmlQwbtRIaR62uheKJfZdTca4no+neUVSYQ=;
        b=ZCdJOUs5wDzsif7GN1dwtS2hZxkuBSyLdCd7dZEOUnkLk2Fo/Rz/C7NiC1bDSLoWQMVa3u
        3KbA3rtr5S1F3D6CqBj+uhEs0NMtencLg5leLW/+ccpgrqZ0LzG4o8RnXXcQUZVj4wQLBy
        YFSIfi9tGZmOWvb6zqtmMuOvQvvEwNY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-103--lrtRmfYNZ-sdJeQonF4Ig-1; Thu, 22 Sep 2022 13:09:33 -0400
X-MC-Unique: -lrtRmfYNZ-sdJeQonF4Ig-1
Received: by mail-il1-f199.google.com with SMTP id h10-20020a92c26a000000b002f57c5ac7dbso6023337ild.15
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 10:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Pd4NQd/acmlQwbtRIaR62uheKJfZdTca4no+neUVSYQ=;
        b=QqOgrN9OSsRk/E3k6AfYLrITtFPgLDWYnD3q07roEhoybjqxByQFKFb2rkDgf7k8JR
         ESwplv0Lm5tva7ZqNPOja2czdcHNKXSn6qO9tV95MH1ox1Jdw2784V/NleL8rRqpDlLy
         zGQNhGKOJjM/Oa9/dwpF7PcI2qwfL+HccXxeTehS37saJJiE7SU1gcWXB7dONbdVO0lC
         rnFzUutcqGBQRqCygpiS0/oDh25Mh7hwTuQaRURiTa+dDX4kG+z4KEn74HMSOwKROAbg
         KbAcxxdeFYIp6Pzup2TF08ram8ofA5rtSliXbxFfVI6CPSLBIsLkyoJQo9u58txNlguW
         dIfQ==
X-Gm-Message-State: ACrzQf2/igWQtvG+mGezOMOASoS1u6zSLaeA8AyQAB91wj/amTsLvTVH
        OgTn+oVP1h4GH3IpkdeG42jUDMi1dPc6OEIWOOwQSTYfla5CJeHSEPsJFVDeACXuaykT5yV1rMf
        lQoy4gUYFK1cn
X-Received: by 2002:a6b:e60f:0:b0:6a1:75d7:271e with SMTP id g15-20020a6be60f000000b006a175d7271emr2125008ioh.79.1663866572447;
        Thu, 22 Sep 2022 10:09:32 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5oAmtefB+5/h7N3J1sw416SdJif/Avh5sHqzZ/Zh3Qsp0yCDr2fB+mYMXIPK8e60Memwb9kA==
X-Received: by 2002:a6b:e60f:0:b0:6a1:75d7:271e with SMTP id g15-20020a6be60f000000b006a175d7271emr2124999ioh.79.1663866572236;
        Thu, 22 Sep 2022 10:09:32 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n25-20020a02a199000000b0035ad8408d40sm2419009jah.108.2022.09.22.10.09.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 10:09:31 -0700 (PDT)
Date:   Thu, 22 Sep 2022 11:09:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] vfio: Split the container code into a clean
 layer and dedicated file
Message-ID: <20220922110930.0beadbc3.alex.williamson@redhat.com>
In-Reply-To: <Yyuzrqe8PocywMld@nvidia.com>
References: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
        <BN9PR11MB527613A28174EBE5450B4A218C4F9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <Yyuzrqe8PocywMld@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 21 Sep 2022 22:00:30 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Sep 21, 2022 at 08:07:42AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, September 21, 2022 8:42 AM
> > >  drivers/vfio/Makefile    |   1 +
> > >  drivers/vfio/container.c | 680 +++++++++++++++++++++++++++++++++++++
> > >  drivers/vfio/vfio.h      |  56 ++++
> > >  drivers/vfio/vfio_main.c | 708 ++-------------------------------------
> > >  4 files changed, 765 insertions(+), 680 deletions(-)
> > >  create mode 100644 drivers/vfio/container.c
> > > 
> > > 
> > > base-commit: 245898eb9275ce31942cff95d0bdc7412ad3d589  
> > 
> > it's not the latest vfio/next:  
> 
> Ah, I did the rebase before I left for lpc..
> 
> There is a minor merge conflict with the stuff from the last week:
> 
> diff --cc drivers/vfio/Makefile
> index d67c604d0407ef,d5ae6921eb4ece..00000000000000
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@@ -1,11 -1,10 +1,12 @@@
>   # SPDX-License-Identifier: GPL-2.0
>   vfio_virqfd-y := virqfd.o
>   
>  -vfio-y += container.o
>  -vfio-y += vfio_main.o
>  -
>   obj-$(CONFIG_VFIO) += vfio.o
>  +
>  +vfio-y += vfio_main.o \
>  +        iova_bitmap.o \
> ++        container.o
>  +
>   obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
>   obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>   obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> 
> Alex, let me know if you want me to respin it

That's trivial, but you also have conflicts with Kevin's 'Tidy up
vfio_device life cycle' series, which gets uglier than I'd like to
fixup on commit.  Could one of you volunteer to rebase on the other?
Thanks,

Alex

