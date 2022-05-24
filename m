Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B64E532418
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 09:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbiEXHbP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 24 May 2022 03:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbiEXHbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 03:31:05 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D321CC
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 00:31:00 -0700 (PDT)
Received: from kwepemi500024.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L6m8J27dgzDqNl;
        Tue, 24 May 2022 15:30:56 +0800 (CST)
Received: from kwepemm000007.china.huawei.com (7.193.23.189) by
 kwepemi500024.china.huawei.com (7.221.188.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 24 May 2022 15:30:58 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 24 May 2022 15:30:57 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2375.024; Tue, 24 May 2022 08:30:55 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        liulongfang <liulongfang@huawei.com>
Subject: RE: [PATCH] vfio: Split migration ops from main device ops
Thread-Topic: [PATCH] vfio: Split migration ops from main device ops
Thread-Index: AQHYbcEbaYBIfiJZj0Om5FEMX9txd60sp8kAgABlhACAAJNZ4A==
Date:   Tue, 24 May 2022 07:30:55 +0000
Message-ID: <cdc5ea6bd40745d0ab86ef790a893ddf@huawei.com>
References: <20220522094756.219881-1-yishaih@nvidia.com>
 <20220523112500.3a227814.alex.williamson@redhat.com>
 <20220523232820.GM1343366@nvidia.com>
In-Reply-To: <20220523232820.GM1343366@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 24 May 2022 00:28
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Yishai Hadas <yishaih@nvidia.com>; kvm@vger.kernel.org;
> maorg@nvidia.com; cohuck@redhat.com; kevin.tian@intel.com; Shameerali
> Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>; liulongfang
> <liulongfang@huawei.com>
> Subject: Re: [PATCH] vfio: Split migration ops from main device ops
> 
> On Mon, May 23, 2022 at 11:25:00AM -0600, Alex Williamson wrote:
> > On Sun, 22 May 2022 12:47:56 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >
> > > vfio core checks whether the driver sets some migration op (e.g.
> > > set_state/get_state) and accordingly calls its op.
> > >
> > > However, currently mlx5 driver sets the above ops without regards to
> > > its migration caps.
> > >
> > > This might lead to unexpected usage/Oops if user space may call to
> > > the above ops even if the driver doesn't support migration. As for
> > > example, the migration state_mutex is not initialized in that case.
> > >
> > > The cleanest way to manage that seems to split the migration ops
> > > from the main device ops, this will let the driver setting them
> > > separately from the main ops when it's applicable.
> > >
> > > As part of that, cleaned-up HISI driver to match this scheme.
> > >
> > > This scheme may enable down the road to come with some extra group
> > > of ops (e.g. DMA log) that can be set without regards to the other
> > > options based on driver caps.
> >
> > It seems like the hisi-acc driver already manages this by registering
> > different structs based on the device migration capabilities, why is
> > that not the default solution here?  Or of course the mlx5 driver
> > could test the migration capabilities before running into the weeds.
> > We also have vfio_device.migration_flags which could factor in here as well.
> 
> It starts to hit combinatoral explosion when the next patches add ops for dirty
> logging that may be optional too. This is simpler and simpifies the hisi driver to
> remove the 2nd ops too.

Hmm..but for hisi driver we still need to have those mmap/ioctl/read/write override 
functions to restrict the BAR region exposure to Guest in case of migration support. So I
am not sure we can get rid of two ops easily there(Though, we could add an explicit
check for the migration support in those callbacks).

Thanks,
Shameer


