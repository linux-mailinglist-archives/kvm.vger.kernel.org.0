Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0004CC499
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 19:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbiCCSGo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 3 Mar 2022 13:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiCCSGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 13:06:42 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02BB1959FE;
        Thu,  3 Mar 2022 10:05:56 -0800 (PST)
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K8f6Z6zwwz681Z4;
        Fri,  4 Mar 2022 02:05:42 +0800 (CST)
Received: from lhreml714-chm.china.huawei.com (10.201.108.65) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Mar 2022 19:05:54 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml714-chm.china.huawei.com (10.201.108.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Mar 2022 18:05:53 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.021; Thu, 3 Mar 2022 18:05:53 +0000
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH v7 07/10] vfio: Extend the device migration protocol with
 PRE_COPY
Thread-Topic: [PATCH v7 07/10] vfio: Extend the device migration protocol with
 PRE_COPY
Thread-Index: AQHYLltB55o0MLr0xUuA2wIPWDOs6KysjGuAgAA7pQCAAD4kAIAAmqcAgAAm6gCAACxRYA==
Date:   Thu, 3 Mar 2022 18:05:53 +0000
Message-ID: <0cee64d555624e669028ba17d04b8737@huawei.com>
References: <20220302172903.1995-1-shameerali.kolothum.thodi@huawei.com>
        <20220302172903.1995-8-shameerali.kolothum.thodi@huawei.com>
        <20220302133159.3c803f56.alex.williamson@redhat.com>
        <20220303000528.GW219866@nvidia.com>
        <20220302204752.71ea8b32.alex.williamson@redhat.com>
        <20220303130124.GX219866@nvidia.com>
 <20220303082040.1f88e24c.alex.williamson@redhat.com>
In-Reply-To: <20220303082040.1f88e24c.alex.williamson@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.82.4]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: 03 March 2022 15:21
> To: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> linux-crypto@vger.kernel.org; linux-pci@vger.kernel.org; cohuck@redhat.com;
> mgurtovoy@nvidia.com; yishaih@nvidia.com; Linuxarm
> <linuxarm@huawei.com>; liulongfang <liulongfang@huawei.com>; Zengtao (B)
> <prime.zeng@hisilicon.com>; Jonathan Cameron
> <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> Subject: Re: [PATCH v7 07/10] vfio: Extend the device migration protocol with
> PRE_COPY
> 
> On Thu, 3 Mar 2022 09:01:24 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Mar 02, 2022 at 08:47:52PM -0700, Alex Williamson wrote:
> > > On Wed, 2 Mar 2022 20:05:28 -0400
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > > On Wed, Mar 02, 2022 at 01:31:59PM -0700, Alex Williamson wrote:
> > > > > > + * initial_bytes reflects the estimated remaining size of any
> > > > > > + initial mandatory
> > > > > > + * precopy data transfer. When initial_bytes returns as zero
> > > > > > + then the initial
> > > > > > + * phase of the precopy data is completed. Generally initial_bytes
> should start
> > > > > > + * out as approximately the entire device state.
> > > > >
> > > > > What is "mandatory" intended to mean here?  The user isn't required
> to
> > > > > collect any data from the device in the PRE_COPY states.
> > > >
> > > > If the data is split into initial,dirty,trailer then mandatory
> > > > means that first chunk.
> > >
> > > But there's no requirement to read anything in PRE_COPY, so initial
> > > becomes indistinguishable from trailer and dirty doesn't exist.
> >
> > It is still mandatory to read that data out, it doesn't matter if it
> > is read during PRE_COPY or STOP_COPY.
> 
> Not really, PRE_COPY -> RUNNING is a valid arc.
> 
> > > > > "The vfio_precopy_info data structure returned by this ioctl
> > > > > provides  estimates of data available from the device during the
> PRE_COPY states.
> > > > >  This estimate is split into two categories, initial_bytes and
> > > > > dirty_bytes.
> > > > >
> > > > >  The initial_bytes field indicates the amount of static data
> > > > > available  from the device.  This field should have a non-zero initial
> value and
> > > > >  decrease as migration data is read from the device.
> > > >
> > > > static isn't great either, how about just say 'minimum data available'
> > >
> > > 'initial precopy data-set'?
> >
> > Sure
> >
> > > We have no basis to make that assertion.  We've agreed that precopy
> > > can be used for nothing more than a compatibility test, so we could
> > > have a vGPU with a massive framebuffer and no ability to provide
> > > dirty tracking implement precopy only to include the entire
> > > framebuffer in the trailing STOP_COPY data set.  Per my
> > > understanding and the fact that we cannot enforce any heuristics
> > > regarding the size of the tailer relative to the pre-copy data set,
> > > I think the above strongly phrased sentence is necessary to
> > > understand the limitations of what this ioctl is meant to convey.
> > > Thanks,
> >
> > This is why abusing precopy for compatability is not a great idea. It
> > is OK for acc because its total state is tiny, but I would not agree
> > to a vGPU driver being merged working like you describe. It distorts
> > the entire purpose of PRE_COPY and this whole estimation mechanism.
> >
> > The ioctl is intended to convey when to switch to STOP_COPY, and the
> > driver should provide a semantic where the closer the reported length
> > is to 0 then the faster the STOP_COPY will go.
> 
> If it's an abuse, then let's not do it.  It was never my impression or intention
> that this was ok for acc only due to the minimal trailing data size.  My
> statement was that use of PRE_COPY for compatibility testing only had been a
> previously agreed valid use case of the original migration interface.
> 
> Furthermore the acc driver was explicitly directed not to indicate any degree
> of trailing data size in dirty_bytes, so while trailing data may be small for acc,
> this interface is explicitly not intended to provide any indication of trailing
> data size.  Thanks,

Just to clarify, so the suggestion here is not to use PRE_COPY for compatibility
check at all and have a different proper infrastructure for that later as Jason
suggested?

If so, I will remove this patch from this series and go back to the old revision
where we only have STOP_COPY and do the compatibility check during the final
load data operation.

Please let me know.

Thanks,
Shameer

