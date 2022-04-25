Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30F350E36D
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 16:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242408AbiDYOk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 10:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiDYOk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 10:40:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7602B1E8
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 07:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650897472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UhyqkvZiXbRxPiBMWj6oIQlfqnIMog7MDN3Wn9vBOhY=;
        b=hezHL/4PL9x6GbBkqosioqcyvrNh7ZoiadUOayVWB0nM6cVFClzP7qJ3AtXjxK7RYOotFw
        wWrIG1z59F+Ya2qsbZyCh0JolyJZcHnQqTBD7LVKMWZt6fiVHwpGEKRLv9lWBsNuFsvaz0
        TA5S26A92+4gPKEBj6uZ2/+V+Bphb7M=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-uJ7u3moDOJ-sFsS08Fr1aQ-1; Mon, 25 Apr 2022 10:37:51 -0400
X-MC-Unique: uJ7u3moDOJ-sFsS08Fr1aQ-1
Received: by mail-il1-f199.google.com with SMTP id h28-20020a056e021d9c00b002cc403e851aso6181731ila.12
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 07:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=UhyqkvZiXbRxPiBMWj6oIQlfqnIMog7MDN3Wn9vBOhY=;
        b=ioC4Ox3ZOj/bBT4g06WzldrUe1o2M2BWLKHBpbIr7pZvU6qxQQ0dR+i3ySza/5jtUz
         K4zPt33E7MD/M+tyT2x75juW1KXn4XI+/itODILYuQf/7dHi5TMPlrsGSM80VyyTtfRY
         /xgl7vKNAmudK5OIs4ZcHDQBHitjIWWYFZt2a6Wv04FIKTKUCRYvKUoZl2hPmIsmQ6Zi
         JgB99vHgdSMI1t7XoTgp9kt8qn2thbvGogB/AU+nxUIIS75H873HG+XmsGqAhgGdoKBA
         AzRPw/K7GyYU7XGxH997dZmvB8yoz767Lscuv+z+N9ygL1hBKnv7ycWkrZSz75wPndgH
         UDkg==
X-Gm-Message-State: AOAM532aWHgRwehkkQXxEnT1Rr0F4Wi0Q/mqQA8MGp6bL7Sl6JEpcmB8
        HsYeIxtfR/S36Fde6cnk/hTNz67kHUs909CtZ+9GPtbP0pkue8SdZ5ph8XJ4ho5FEu5SXf84/wn
        3ZLOqChnmEq23
X-Received: by 2002:a05:6638:240a:b0:32a:a215:41a3 with SMTP id z10-20020a056638240a00b0032aa21541a3mr8316589jat.156.1650897470358;
        Mon, 25 Apr 2022 07:37:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwS7GTFh2yY895Pni62/QdISmWYLk7VmGOTC4VuBWdATuKGT727MB+40Ctal/9iM5+RXQofbQ==
X-Received: by 2002:a05:6638:240a:b0:32a:a215:41a3 with SMTP id z10-20020a056638240a00b0032aa21541a3mr8316573jat.156.1650897469981;
        Mon, 25 Apr 2022 07:37:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s5-20020a0566022bc500b0065490deaf19sm7718890iov.31.2022.04.25.07.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 07:37:49 -0700 (PDT)
Date:   Mon, 25 Apr 2022 08:37:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, akrowiak@linux.ibm.com,
        jjherne@linux.ibm.com, chao.p.peng@intel.com, kvm@vger.kernel.org,
        Laine Stump <laine@redhat.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        jasowang@redhat.com, cohuck@redhat.com, thuth@redhat.com,
        peterx@redhat.com, qemu-devel@nongnu.org, pasic@linux.ibm.com,
        eric.auger@redhat.com, yi.y.sun@intel.com, nicolinc@nvidia.com,
        kevin.tian@intel.com, jgg@nvidia.com, eric.auger.pro@gmail.com,
        david@gibson.dropbear.id.au
Subject: Re: [RFC 00/18] vfio: Adopt iommufd
Message-ID: <20220425083748.3465c50f.alex.williamson@redhat.com>
In-Reply-To: <YmZzhohO81z1PVKS@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
        <20220422160943.6ff4f330.alex.williamson@redhat.com>
        <YmZzhohO81z1PVKS@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Apr 2022 11:10:14 +0100
Daniel P. Berrang=C3=A9 <berrange@redhat.com> wrote:

> On Fri, Apr 22, 2022 at 04:09:43PM -0600, Alex Williamson wrote:
> > [Cc +libvirt folks]
> >=20
> > On Thu, 14 Apr 2022 03:46:52 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >  =20
> > > With the introduction of iommufd[1], the linux kernel provides a gene=
ric
> > > interface for userspace drivers to propagate their DMA mappings to ke=
rnel
> > > for assigned devices. This series does the porting of the VFIO devices
> > > onto the /dev/iommu uapi and let it coexist with the legacy implement=
ation.
> > > Other devices like vpda, vfio mdev and etc. are not considered yet. =
=20
>=20
> snip
>=20
> > > The selection of the backend is made on a device basis using the new
> > > iommufd option (on/off/auto). By default the iommufd backend is selec=
ted
> > > if supported by the host and by QEMU (iommufd KConfig). This option is
> > > currently available only for the vfio-pci device. For other types of
> > > devices, it does not yet exist and the legacy BE is chosen by default=
. =20
> >=20
> > I've discussed this a bit with Eric, but let me propose a different
> > command line interface.  Libvirt generally likes to pass file
> > descriptors to QEMU rather than grant it access to those files
> > directly.  This was problematic with vfio-pci because libvirt can't
> > easily know when QEMU will want to grab another /dev/vfio/vfio
> > container.  Therefore we abandoned this approach and instead libvirt
> > grants file permissions.
> >=20
> > However, with iommufd there's no reason that QEMU ever needs more than
> > a single instance of /dev/iommufd and we're using per device vfio file
> > descriptors, so it seems like a good time to revisit this. =20
>=20
> I assume access to '/dev/iommufd' gives the process somewhat elevated
> privileges, such that you don't want to unconditionally give QEMU
> access to this device ?

It's not that much dissimilar to /dev/vfio/vfio, it's an unprivileged
interface which should have limited scope for abuse, but more so here
the goal would be to de-privilege QEMU that one step further that it
cannot open the device file itself.

> > The interface I was considering would be to add an iommufd object to
> > QEMU, so we might have a:
> >=20
> > -device iommufd[,fd=3D#][,id=3Dfoo]
> >=20
> > For non-libivrt usage this would have the ability to open /dev/iommufd
> > itself if an fd is not provided.  This object could be shared with
> > other iommufd users in the VM and maybe we'd allow multiple instances
> > for more esoteric use cases.  [NB, maybe this should be a -object rathe=
r than
> > -device since the iommufd is not a guest visible device?] =20
>=20
> Yes,  -object would be the right answer for something that's purely
> a host side backend impl selector.
>=20
> > The vfio-pci device might then become:
> >=20
> > -device vfio-pci[,host=3DDDDD:BB:DD.f][,sysfsdev=3D/sys/path/to/device]=
[,fd=3D#][,iommufd=3Dfoo]
> >=20
> > So essentially we can specify the device via host, sysfsdev, or passing
> > an fd to the vfio device file.  When an iommufd object is specified,
> > "foo" in the example above, each of those options would use the
> > vfio-device access mechanism, essentially the same as iommufd=3Don in
> > your example.  With the fd passing option, an iommufd object would be
> > required and necessarily use device level access.
> >=20
> > In your example, the iommufd=3Dauto seems especially troublesome for
> > libvirt because QEMU is going to have different locked memory
> > requirements based on whether we're using type1 or iommufd, where the
> > latter resolves the duplicate accounting issues.  libvirt needs to know
> > deterministically which backed is being used, which this proposal seems
> > to provide, while at the same time bringing us more in line with fd
> > passing.  Thoughts?  Thanks, =20
>=20
> Yep, I agree that libvirt needs to have more direct control over this.
> This is also even more important if there are notable feature differences
> in the 2 backends.
>=20
> I wonder if anyone has considered an even more distinct impl, whereby
> we have a completely different device type on the backend, eg
>=20
>   -device vfio-iommu-pci[,host=3DDDDD:BB:DD.f][,sysfsdev=3D/sys/path/to/d=
evice][,fd=3D#][,iommufd=3Dfoo]
>=20
> If a vendor wants to fully remove the legacy impl, they can then use the
> Kconfig mechanism to disable the build of the legacy impl device, while
> keeping the iommu impl (or vica-verca if the new iommu impl isn't conside=
red
> reliable enough for them to support yet).
>=20
> Libvirt would use
>=20
>    -object iommu,id=3Diommu0,fd=3DNNN
>    -device vfio-iommu-pci,fd=3DMMM,iommu=3Diommu0
>=20
> Non-libvirt would use a simpler
>=20
>    -device vfio-iommu-pci,host=3D0000:03:22.1
>=20
> with QEMU auto-creating a 'iommu' object in the background.
>=20
> This would fit into libvirt's existing modelling better. We currently have
> a concept of a PCI assignment backend, which previously supported the
> legacy PCI assignment, vs the VFIO PCI assignment. This new iommu impl
> feels like a 3rd PCI assignment approach, and so fits with how we modelled
> it as a different device type in the past.

I don't think we want to conflate "iommu" and "iommufd", we're creating
an object that interfaces into the iommufd uAPI, not an iommu itself.
Likewise "vfio-iommu-pci" is just confusing, there was an iommu
interface previously, it's just a different implementation now and as
far as the VM interface to the device, it's identical.  Note that a
"vfio-iommufd-pci" device multiplies the matrix of every vfio device
for a rather subtle implementation detail.

My expectation would be that libvirt uses:

 -object iommufd,id=3Diommufd0,fd=3DNNN
 -device vfio-pci,fd=3DMMM,iommufd=3Diommufd0

Whereas simple QEMU command line would be:

 -object iommufd,id=3Diommufd0
 -device vfio-pci,iommufd=3Diommufd0,host=3D0000:02:00.0

The iommufd object would open /dev/iommufd itself.  Creating an
implicit iommufd object is someone problematic because one of the
things I forgot to highlight in my previous description is that the
iommufd object is meant to be shared across not only various vfio
devices (platform, ccw, ap, nvme, etc), but also across subsystems, ex.
vdpa.

If the old style were used:

 -device vfio-pci,host=3D0000:02:00.0

Then QEMU would use vfio for the IOMMU backend.

If libvirt/userspace wants to query whether "legacy" vfio is still
supported by the host kernel, I think it'd only need to look for
whether the /dev/vfio/vfio container interface still exists.

If we need some means for QEMU to remove legacy support, I'd rather
find a way to do it via probing device options.  It's easy enough to
see if iommufd support exists by looking for the presence of the
iommufd option for the vfio-pci device and Kconfig within QEMU could be
used regardless of whether we define a new device name.  Thanks,

Alex

