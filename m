Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE5650DDA6
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 12:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239170AbiDYKNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 06:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241613AbiDYKNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 06:13:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41230CC2
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 03:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650881437;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=MJfV5S/BB/MbzPdioRgmTqclgIaNXTER802ZZLyJuik=;
        b=ZFukmpBTrps+QR4HbvR0gmKVwwtISVg7W0tZEeZfIQ8sLaX7LNmOI/7DklpcIo8wBxI5Pj
        m6w8jdir2inGMhJVIKv3mMLQIoL9OQThiob6Ts7flQ3DH9A0mLiNs85x7lvm0sGgx8NKvR
        2JvhMrrbP1Otk7onoOZM/G4uJe0FUAk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-uzM-iZFhN1GTu9R6Jk9_qg-1; Mon, 25 Apr 2022 06:10:21 -0400
X-MC-Unique: uzM-iZFhN1GTu9R6Jk9_qg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FF1F833972;
        Mon, 25 Apr 2022 10:10:20 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.152])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AECD463DF5;
        Mon, 25 Apr 2022 10:10:16 +0000 (UTC)
Date:   Mon, 25 Apr 2022 11:10:14 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
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
Message-ID: <YmZzhohO81z1PVKS@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220422160943.6ff4f330.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220422160943.6ff4f330.alex.williamson@redhat.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 22, 2022 at 04:09:43PM -0600, Alex Williamson wrote:
> [Cc +libvirt folks]
> 
> On Thu, 14 Apr 2022 03:46:52 -0700
> Yi Liu <yi.l.liu@intel.com> wrote:
> 
> > With the introduction of iommufd[1], the linux kernel provides a generic
> > interface for userspace drivers to propagate their DMA mappings to kernel
> > for assigned devices. This series does the porting of the VFIO devices
> > onto the /dev/iommu uapi and let it coexist with the legacy implementation.
> > Other devices like vpda, vfio mdev and etc. are not considered yet.

snip

> > The selection of the backend is made on a device basis using the new
> > iommufd option (on/off/auto). By default the iommufd backend is selected
> > if supported by the host and by QEMU (iommufd KConfig). This option is
> > currently available only for the vfio-pci device. For other types of
> > devices, it does not yet exist and the legacy BE is chosen by default.
> 
> I've discussed this a bit with Eric, but let me propose a different
> command line interface.  Libvirt generally likes to pass file
> descriptors to QEMU rather than grant it access to those files
> directly.  This was problematic with vfio-pci because libvirt can't
> easily know when QEMU will want to grab another /dev/vfio/vfio
> container.  Therefore we abandoned this approach and instead libvirt
> grants file permissions.
> 
> However, with iommufd there's no reason that QEMU ever needs more than
> a single instance of /dev/iommufd and we're using per device vfio file
> descriptors, so it seems like a good time to revisit this.

I assume access to '/dev/iommufd' gives the process somewhat elevated
privileges, such that you don't want to unconditionally give QEMU
access to this device ?

> The interface I was considering would be to add an iommufd object to
> QEMU, so we might have a:
> 
> -device iommufd[,fd=#][,id=foo]
> 
> For non-libivrt usage this would have the ability to open /dev/iommufd
> itself if an fd is not provided.  This object could be shared with
> other iommufd users in the VM and maybe we'd allow multiple instances
> for more esoteric use cases.  [NB, maybe this should be a -object rather than
> -device since the iommufd is not a guest visible device?]

Yes,  -object would be the right answer for something that's purely
a host side backend impl selector.

> The vfio-pci device might then become:
> 
> -device vfio-pci[,host=DDDD:BB:DD.f][,sysfsdev=/sys/path/to/device][,fd=#][,iommufd=foo]
> 
> So essentially we can specify the device via host, sysfsdev, or passing
> an fd to the vfio device file.  When an iommufd object is specified,
> "foo" in the example above, each of those options would use the
> vfio-device access mechanism, essentially the same as iommufd=on in
> your example.  With the fd passing option, an iommufd object would be
> required and necessarily use device level access.
> 
> In your example, the iommufd=auto seems especially troublesome for
> libvirt because QEMU is going to have different locked memory
> requirements based on whether we're using type1 or iommufd, where the
> latter resolves the duplicate accounting issues.  libvirt needs to know
> deterministically which backed is being used, which this proposal seems
> to provide, while at the same time bringing us more in line with fd
> passing.  Thoughts?  Thanks,

Yep, I agree that libvirt needs to have more direct control over this.
This is also even more important if there are notable feature differences
in the 2 backends.

I wonder if anyone has considered an even more distinct impl, whereby
we have a completely different device type on the backend, eg

  -device vfio-iommu-pci[,host=DDDD:BB:DD.f][,sysfsdev=/sys/path/to/device][,fd=#][,iommufd=foo]

If a vendor wants to fully remove the legacy impl, they can then use the
Kconfig mechanism to disable the build of the legacy impl device, while
keeping the iommu impl (or vica-verca if the new iommu impl isn't considered
reliable enough for them to support yet).

Libvirt would use

   -object iommu,id=iommu0,fd=NNN
   -device vfio-iommu-pci,fd=MMM,iommu=iommu0

Non-libvirt would use a simpler

   -device vfio-iommu-pci,host=0000:03:22.1

with QEMU auto-creating a 'iommu' object in the background.

This would fit into libvirt's existing modelling better. We currently have
a concept of a PCI assignment backend, which previously supported the
legacy PCI assignment, vs the VFIO PCI assignment. This new iommu impl
feels like a 3rd PCI assignment approach, and so fits with how we modelled
it as a different device type in the past.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

