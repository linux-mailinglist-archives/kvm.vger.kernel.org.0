Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B92D7AA733
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 05:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjIVDC3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 23:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjIVDC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 23:02:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B188F
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 20:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695351698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rew5kkS2gk0Kx6de5ikcwTNfnxislnRtj601jvpsqnA=;
        b=CNE0mT1kr9+EP4TbH9rPxwmkg2E6PkUjdt/oz88E8V1HaDdfakqTT0E8kRXxDTzjIBYQyw
        N43OSVBM2KqU0FCCJl8mg7aEhy0y+HWiLFZk1eRQQCgEPSYRepoUtjYt4DLwq0QkMw4NQC
        cA+CTexd238J1rgq/yHaoDrXprOsMXM=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-E_By34uYM9e1ZOotaO0M2g-1; Thu, 21 Sep 2023 23:01:37 -0400
X-MC-Unique: E_By34uYM9e1ZOotaO0M2g-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2c120e3aa0dso18896821fa.2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 20:01:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695351695; x=1695956495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rew5kkS2gk0Kx6de5ikcwTNfnxislnRtj601jvpsqnA=;
        b=oCGewIMLaCtAGPbzEMzZwxaY7uewHaWZdy886anYuNKO/lslXisBYCYJ2ST2k+vat1
         C4uOnMzDz/hIZ0M7DteMDdwad0d3oksCrC/hk7g93Pn++9kSIduQtT0sAO9unjZ2ogJW
         tqjA5Y6QjJnQl4AWn56gkk7daYifU9SGT3zzsxKGtAIE9+lDI32+bVWpAonNJWBA4xRp
         /iWuPSWEgzws0AeV1U2A8NPTjmygwpg0NaAVqt7Wg8gEI2I3IyRfjc+0x6pgON4G8+A7
         FHi3Y1cyi7atlWaKYDzUVYU3ZxAUlaPlBQTSsvUGg17PjhbT2W+mtxVc4dVvsPE8zlod
         O5CQ==
X-Gm-Message-State: AOJu0YyEwNskCEHZeAAneNXf/IheoWd6xof0xLiiZfej3VLJuRqA98Fb
        tPVPkYbGar/o0beyzjaTy/uaMCNgP9MpnS/bzmQg2EdICMRoJRmsMoTg92+L+W38F3I2KF3niG9
        JSgNFCVv7bCcHJZd/mDl2IWE0WCIP17u3OEzZAXA=
X-Received: by 2002:a05:6512:3090:b0:501:ba04:f34b with SMTP id z16-20020a056512309000b00501ba04f34bmr7095491lfd.44.1695351694900;
        Thu, 21 Sep 2023 20:01:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyvZ5y9Tm2MtSv8GTK4mxYG5xXps1elO4+woLhmW0ZWQZ2GwsvhOqLLLs/lJEJ7dUOoRtymPTUuyJnZVDusEg=
X-Received: by 2002:a05:6512:3090:b0:501:ba04:f34b with SMTP id
 z16-20020a056512309000b00501ba04f34bmr7095472lfd.44.1695351694550; Thu, 21
 Sep 2023 20:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230921124040.145386-1-yishaih@nvidia.com> <20230921124040.145386-12-yishaih@nvidia.com>
 <20230921090844-mutt-send-email-mst@kernel.org> <20230921141125.GM13733@nvidia.com>
 <20230921101509-mutt-send-email-mst@kernel.org> <20230921164139.GP13733@nvidia.com>
 <20230921124331-mutt-send-email-mst@kernel.org> <20230921183926.GV13733@nvidia.com>
 <20230921150448-mutt-send-email-mst@kernel.org> <20230921194946.GX13733@nvidia.com>
In-Reply-To: <20230921194946.GX13733@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 22 Sep 2023 11:01:23 +0800
Message-ID: <CACGkMEvMP05yTNGE5dBA2-M0qX-GXFcdGho7_T5NR6kAEq9FNg@mail.gmail.com>
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

On Fri, Sep 22, 2023 at 3:49=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Sep 21, 2023 at 03:13:10PM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 21, 2023 at 03:39:26PM -0300, Jason Gunthorpe wrote:
> > > On Thu, Sep 21, 2023 at 12:53:04PM -0400, Michael S. Tsirkin wrote:
> > > > > vdpa is not vfio, I don't know how you can suggest vdpa is a
> > > > > replacement for a vfio driver. They are completely different
> > > > > things.
> > > > > Each side has its own strengths, and vfio especially is accelerat=
ing
> > > > > in its capability in way that vpda is not. eg if an iommufd conve=
rsion
> > > > > had been done by now for vdpa I might be more sympathetic.
> > > >
> > > > Yea, I agree iommufd is a big problem with vdpa right now. Cindy wa=
s
> > > > sick and I didn't know and kept assuming she's working on this. I d=
on't
> > > > think it's a huge amount of work though.  I'll take a look.
> > > > Is there anything else though? Do tell.
> > >
> > > Confidential compute will never work with VDPA's approach.
> >
> > I don't see how what this patchset is doing is different
> > wrt to Confidential compute - you trap IO accesses and emulate.
> > Care to elaborate?
>
> This patch series isn't about confidential compute, you asked about
> the future. VFIO will support confidential compute in the future, VDPA
> will not.
>
> > > > There are a bunch of things that I think are important for virtio
> > > > that are completely out of scope for vfio, such as migrating
> > > > cross-vendor.
> > >
> > > VFIO supports migration, if you want to have cross-vendor migration
> > > then make a standard that describes the VFIO migration data format fo=
r
> > > virtio devices.
> >
> > This has nothing to do with data formats - you need two devices to
> > behave identically. Which is what VDPA is about really.
>
> We've been looking at VFIO live migration extensively. Device
> mediation, like VDPA does, is one legitimate approach for live
> migration. It suites a certain type of heterogeneous environment well.
>
> But, it is equally legitimate to make the devices behave the same and
> have them process a common migration data.
>
> This can happen in public with standards, or it can happen in private
> within a cloud operator's "private-standard" environment.
>
> To date, in most of my discussions, I have not seen a strong appetite
> for such public standards. In part due to the complexity.
>
> Regardles, it is not the kernel communities job to insist on one
> approach or the other.
>
> > > You are asking us to invest in the complexity of VDPA through out
> > > (keep it working, keep it secure, invest time in deploying and
> > > debugging in the field)
> > >
> > > When it doesn't provide *ANY* value to the solution.
> >
> > There's no "the solution"
>
> Nonsense.
>
> > this sounds like a vendor only caring about solutions that involve
> > that vendor's hardware exclusively, a little.
>
> Not really.
>
> Understand the DPU provider is not the vendor here. The DPU provider
> gives a cloud operator a SDK to build these things. The operator is
> the vendor from your perspective.
>
> In many cases live migration never leaves the operator's confines in
> the first place.
>
> Even when it does, there is no real use case to live migrate a
> virtio-net function from, say, AWS to GCP.

It can happen inside a single cloud vendor. For some reasons, DPU must
be purchased from different vendors. And vDPA has been used in that
case.

I've asked them to present this probably somewhere like KVM Forum.

>
> You are pushing for a lot of complexity and software that solves a
> problem people in this space don't actually have.
>
> As I said, VDPA is fine for the scenarios it addresses. It is an
> alternative, not a replacement, for VFIO.

We never try to replace VFIO. I don't see any problem by just using
the current VFIO to assign a virtio-pci device to the guest.

The problem is the mediation (or what you called relaying) layer
you've invented.

Thanks

>
> Jason
>

