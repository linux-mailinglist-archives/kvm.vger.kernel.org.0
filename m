Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79AD5634EF3
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 05:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbiKWEc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 23:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235267AbiKWEcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 23:32:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7AD7FF39
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 20:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669177888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VQl9ff+pm3Bk3aH204X24mZs6zyamDTWXwNuFP1xLlU=;
        b=ioS4y6udGto6FdbJOCjiDvPuEcBJbFV86tIH60H4nWp0VAyPjYItmegP1pzJkpbvUP4ysv
        s+t37dIUrYzUTYwNIuvWzMyi3Zus+BI6cUsMpk5GgeRlaLJE56HwvUnxrpSom1G+fpw6go
        nS9H9fqIYUPF9yeTZWnd5n8hys5teaY=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-50-6LmtxfvoN9G1skF0LwI-Hw-1; Tue, 22 Nov 2022 23:31:27 -0500
X-MC-Unique: 6LmtxfvoN9G1skF0LwI-Hw-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-13c2cedb93bso8008645fac.4
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 20:31:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VQl9ff+pm3Bk3aH204X24mZs6zyamDTWXwNuFP1xLlU=;
        b=ZtL2FmNLfnTwHosSzy8cT1q38+fZLsxwIos+hw3XBpqkfJ60J1ltc6ooQLx1BeJOar
         PsE1XG6lw0tpZCSAZbi5ssJNbEV+Zrzf9jBkvRg9MW0Z+bTB+jDaUsqJL3HYrtjCUkrh
         mhT7ywvf2ukpJDydLq2PAps5uHsljzdkccbW7VCXk6q6uDA2ddH4jQGyK1mdaVV30pbe
         BulDzwdn2tztlQ5mqGLXs5cqQctK9uRmJU3MOvTL5RxrpPfY0TFzkv/TDR3cRHJ54mrq
         a64FCr0D4qGXcTkraHsvg4v2UKtypKKaoS5tAHRiBiDMlK1wuQO4mWipBYPNElXe8Koh
         NMVQ==
X-Gm-Message-State: ANoB5pmHJvR+HHb/bnQg4VYS8XuSnLEZhnXGR0jdetl1Cx6hd7yfH2fi
        WHtgu4oAdMQcXhsBsqtXbN+7bfKMtw5q6cskQzta7HllqJGdu6mCON4iH8aTTt1bluxdjPi3PvE
        06lcpGRBaXicMZHmEpnbV+jP0C6XT
X-Received: by 2002:a4a:94a9:0:b0:480:8f4a:7062 with SMTP id k38-20020a4a94a9000000b004808f4a7062mr3093744ooi.57.1669177886413;
        Tue, 22 Nov 2022 20:31:26 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5p+2/kgwNtkcV/tZnRU73FzLwSP/0hnFdBUnffLOt1Eb3cLSA1SD07EWvhtzopVZbm5DQMqgdOyOqC6G2YoCA=
X-Received: by 2002:a4a:94a9:0:b0:480:8f4a:7062 with SMTP id
 k38-20020a4a94a9000000b004808f4a7062mr3093711ooi.57.1669177886199; Tue, 22
 Nov 2022 20:31:26 -0800 (PST)
MIME-Version: 1.0
References: <0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com> <15-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com>
 <BN9PR11MB5276B0219008568A30F5A4738C099@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y3ejMSTWvJuELQ7K@nvidia.com> <BN9PR11MB5276939555C1460EFBFD15A68C0C9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276939555C1460EFBFD15A68C0C9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 23 Nov 2022 12:31:15 +0800
Message-ID: <CACGkMEumUoHfWE0NkdmNbnx-nmgXrm3ZL6Jrj6x+M=wSXQK32g@mail.gmail.com>
Subject: Re: [PATCH v5 15/19] iommufd: vfio container FD ioctl compatibility
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Rix <trix@redhat.com>, Will Deacon <will@kernel.org>,
        Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Lixiao" <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 9:33 AM Tian, Kevin <kevin.tian@intel.com> wrote:
>
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, November 18, 2022 11:22 PM
> >
> > On Fri, Nov 18, 2022 at 02:58:49AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Thursday, November 17, 2022 5:01 AM
> > > > index ca28a135b9675f..2fdff04000b326 100644
> > > > --- a/drivers/iommu/iommufd/Makefile
> > > > +++ b/drivers/iommu/iommufd/Makefile
> > > > @@ -5,6 +5,7 @@ iommufd-y := \
> > > >   io_pagetable.o \
> > > >   ioas.o \
> > > >   main.o \
> > > > - pages.o
> > > > + pages.o \
> > > > + vfio_compat.o
> > > >
> > >
> > > move vfio_compat out of core? it's not required if VFIO
> > > is not configured.
> >
> > We can, but I don't know if we should. Compat ioctls are part of
> > /dev/iommu, and technically have nothing to do with VFIO. A native
> > iommufd application using VDPA could use them, if it wanted, for
> > instance.
> >
>
> I'm not sure whether that requires further VDPA support. Be safe
> I'd like VDPA to explicitly select vfio_compact when that new
> mixed scheme is supported.
>

This sounds strange. If I don't misunderstand the code, it tries to
provide ioctl compatibility with the VFIO container. I don't see how
it can be used for vDPA, the ioctls used by vDPA is not compatible
with VFIO.

Thanks

