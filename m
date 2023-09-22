Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62FD7AA738
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 05:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjIVDDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 23:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjIVDDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 23:03:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6326194
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 20:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695351779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C4/7HVPf6uamIbhGmRjVc4ZotzNyCXQbQd4oze32eow=;
        b=Ft3ZTzsg6P26MA6HrlDIW01aczWBehfslJqMIKZEtyhqd+6YbnFPAyC+7eK9p5MQyqvm7b
        R8vjnAzxPSoKvFVMJUXCPnunrfp7E105pP18h3iJ6M3zNjpTCUK5Lj/F4aVNpiTSifMu7l
        P2fAV400Ud4ziyB0uTLID2uqFBMtAWA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-EjB6KDc3P9iuZ-sOo_QG0w-1; Thu, 21 Sep 2023 23:02:57 -0400
X-MC-Unique: EjB6KDc3P9iuZ-sOo_QG0w-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2bff8e92054so22788561fa.2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 20:02:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695351776; x=1695956576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C4/7HVPf6uamIbhGmRjVc4ZotzNyCXQbQd4oze32eow=;
        b=jW1yVQXwCQLy0FaDBlR2unqCPh+bJrSeTYFNX8FTdjzHznpoLz1kr/WfkYxONgNq8d
         qp/q2pj0lPEWSe9D9d7UkMTXT/+aUgF91JZY1lYjIYJZzhB2gTJC0ELjILgGUfOwYwcB
         quJpc0r6Cmv4uNelIDaiOHYCnhRW2lb+iwU7AqsvNBruYxPI0n0imf6XuDlVsBJjcPRj
         c0JaO443Vo+39hATG4Sa5+uiVXuhWQRr1y9rLYhWLVdVQGVQMJIXKB+ZMElYzZs1niyD
         Y7iOfkS+EJzQLo6nOU2AQ9Wph6QjbJqGWC1Zlsg0/WHk/Aj5Lbnz4QkBKRp7n6+Bclj4
         Mdhw==
X-Gm-Message-State: AOJu0YxHB8aqrWHsIlhdGx2hcXbIEI9IhTzADU2lF8u5CbpcNmm77XLr
        Fa0kpSBCKn3dM1+coZPg/6DrzD6vV+dR568Wq9n7y6mMhiILIbLo9akExmBByRmTiyl6q3u/AbO
        robYGmpPt+yeGmRBgehWHa5B3r3PQ
X-Received: by 2002:a05:6512:3e17:b0:501:bf37:1fc0 with SMTP id i23-20020a0565123e1700b00501bf371fc0mr7518463lfv.33.1695351775885;
        Thu, 21 Sep 2023 20:02:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEK0VNN1CQqjxfBqcyZruxzFlh3gm1m468Kkmtaqhcvh89ukdHWFMbXLOQnTSo1SwuQSl9L8ShMnn3mbZgUoL8=
X-Received: by 2002:a05:6512:3e17:b0:501:bf37:1fc0 with SMTP id
 i23-20020a0565123e1700b00501bf371fc0mr7518442lfv.33.1695351775543; Thu, 21
 Sep 2023 20:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20230921124040.145386-12-yishaih@nvidia.com> <20230921090844-mutt-send-email-mst@kernel.org>
 <20230921141125.GM13733@nvidia.com> <20230921101509-mutt-send-email-mst@kernel.org>
 <20230921164139.GP13733@nvidia.com> <20230921124331-mutt-send-email-mst@kernel.org>
 <20230921183926.GV13733@nvidia.com> <20230921150448-mutt-send-email-mst@kernel.org>
 <20230921194946.GX13733@nvidia.com> <20230921163421-mutt-send-email-mst@kernel.org>
 <20230921225526.GE13733@nvidia.com>
In-Reply-To: <20230921225526.GE13733@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 22 Sep 2023 11:02:44 +0800
Message-ID: <CACGkMEtNZ1FdUb_xG5862nve565Oh-=o8ZUjfR_Gr7JPCbJ_Kw@mail.gmail.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        maorg@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 6:55=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Sep 21, 2023 at 04:45:45PM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 21, 2023 at 04:49:46PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Sep 21, 2023 at 03:13:10PM -0400, Michael S. Tsirkin wrote:
> > > > On Thu, Sep 21, 2023 at 03:39:26PM -0300, Jason Gunthorpe wrote:
> > > > > On Thu, Sep 21, 2023 at 12:53:04PM -0400, Michael S. Tsirkin wrot=
e:
> > > > > > > vdpa is not vfio, I don't know how you can suggest vdpa is a
> > > > > > > replacement for a vfio driver. They are completely different
> > > > > > > things.
> > > > > > > Each side has its own strengths, and vfio especially is accel=
erating
> > > > > > > in its capability in way that vpda is not. eg if an iommufd c=
onversion
> > > > > > > had been done by now for vdpa I might be more sympathetic.
> > > > > >
> > > > > > Yea, I agree iommufd is a big problem with vdpa right now. Cind=
y was
> > > > > > sick and I didn't know and kept assuming she's working on this.=
 I don't
> > > > > > think it's a huge amount of work though.  I'll take a look.
> > > > > > Is there anything else though? Do tell.
> > > > >
> > > > > Confidential compute will never work with VDPA's approach.
> > > >
> > > > I don't see how what this patchset is doing is different
> > > > wrt to Confidential compute - you trap IO accesses and emulate.
> > > > Care to elaborate?
> > >
> > > This patch series isn't about confidential compute, you asked about
> > > the future. VFIO will support confidential compute in the future, VDP=
A
> > > will not.

What blocks vDPA from supporting that?

> >
> > Nonsense it already works.
>
> That isn't what I'm talking about. With a real PCI function and TDISP
> we can actually DMA directly from the guest's memory without needing
> the ugly bounce buffer hack. Then you can get decent performance.

This series requires the trapping in the legacy I/O BAR in VFIO. Why
can TDISP work when trapping in VFIO but not vDPA? If neither, how can
TDISP affect here?

>
> > But I did not ask about the future since I do not believe it
> > can be confidently predicted. I asked what is missing in VDPA
> > now for you to add this feature there and not in VFIO.
>
> I don't see that VDPA needs this, VDPA should process the IO BAR on
> its own with its own logic, just like everything else it does.
>
> This is specifically about avoiding mediation by relaying directly the
> IO BAR operations to the device itself.

So we had:

1) a new virtio specific driver for VFIO
2) the existing vp_vdpa driver

How much differences between them in the context of the mediation or
relaying? Or is it hard to introduce admin commands in the vDPA bus?

> That is the entire irony, this whole scheme was designed and
> standardized *specifically* to avoid complex mediation and here you
> are saying we should just use mediation.

No, using "simple VFIO passthrough" is just fine.

Thanks

>
> Jason
>

