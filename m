Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5ABA7CE69C
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 20:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345065AbjJRSav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 14:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344988AbjJRSa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 14:30:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C1A11F
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 11:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697653780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7R6RTAkgPJ3A2Sl/SrJ6GMc2ikyq7O3Z+XFs2kp36A8=;
        b=UBi9gIxyEh51U9EJfGtsBTYq7jk7NG0ySIuJQRXlIB3Sr11xTJkhnNJJASesSJOKE+R/bZ
        zPnt1czBVEANDhsKxkqUuMtNLtp8c49uV8IKBcBNo+j9iWSQURzaIs+VgpCm9wvHjeDgd+
        4VQ+0V8S5MRXuJoLF5Hnju06fi4sH2w=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-x5oG-HkUOiGH7m3FW-EQFw-1; Wed, 18 Oct 2023 14:29:29 -0400
X-MC-Unique: x5oG-HkUOiGH7m3FW-EQFw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-780addd7382so588768339f.1
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 11:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697653768; x=1698258568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7R6RTAkgPJ3A2Sl/SrJ6GMc2ikyq7O3Z+XFs2kp36A8=;
        b=svd+ZEbOjaPyY6kNjB3YamMo2ceocOSPju/jrvWJz4T8DbRrUcid8EaiSNkN/4qsd5
         Qm2QWrLVkgQDVSDM9WqcMxwTLdnMaq57Ape8sxlrARs7Wb6476XeOtIE7R/rOvDyG/jJ
         H6BlQ5OKQVvdSg5/NAzN3Rpji0nGmEOjRkf4zqu4Cr5nu4xkuKJ+BhSPbt3hIR76MlNO
         JzDX26Tggq7K7r8S3H0GW17Cut9rQhsbTbGXfO0WiWcFuayxd3i6FJ3fGXBF+w3cPPcq
         TD7Us5mpmdIxnPBgLTeKdsBFlMJh2rrpQywS0lWogUcmDEdDrwIvQDSO3KAexYqdR/P/
         HxbQ==
X-Gm-Message-State: AOJu0YxtqO1+aaORSnjF8SS1/ZuLmthIfd0pthy826jisZkwtB0sP/sg
        8iMIOpn8crGsZ8r1yiR0aQaOZEXUXZ/Kwbt+CVPLtt+N5j+6sqmDCgB4qrg2zMrEDRGy8zqGVvJ
        I9fVOZfApKhC6
X-Received: by 2002:a05:6602:2c90:b0:79f:e9ac:f60a with SMTP id i16-20020a0566022c9000b0079fe9acf60amr55504iow.20.1697653768607;
        Wed, 18 Oct 2023 11:29:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZOgP35lJk8sk1selAnhrxsD5cVz/op+LUUohZIIuhrccEv2yoS+AMAHgBHkSLHcYMuVLrUw==
X-Received: by 2002:a05:6602:2c90:b0:79f:e9ac:f60a with SMTP id i16-20020a0566022c9000b0079fe9acf60amr55478iow.20.1697653768208;
        Wed, 18 Oct 2023 11:29:28 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id i141-20020a6b3b93000000b007a667019071sm900347ioa.22.2023.10.18.11.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 11:29:27 -0700 (PDT)
Date:   Wed, 18 Oct 2023 12:29:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, si-wei.liu@oracle.com,
        leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V1 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231018122925.3fde9405.alex.williamson@redhat.com>
In-Reply-To: <20231018163333.GZ3952@nvidia.com>
References: <20231017134217.82497-1-yishaih@nvidia.com>
        <20231017134217.82497-10-yishaih@nvidia.com>
        <20231017142448.08673cdc.alex.williamson@redhat.com>
        <20231018163333.GZ3952@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Oct 2023 13:33:33 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Oct 17, 2023 at 02:24:48PM -0600, Alex Williamson wrote:
> > On Tue, 17 Oct 2023 16:42:17 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:  
> > > +static int virtiovf_pci_probe(struct pci_dev *pdev,
> > > +			      const struct pci_device_id *id)
> > > +{
> > > +	const struct vfio_device_ops *ops = &virtiovf_acc_vfio_pci_ops;
> > > +	struct virtiovf_pci_core_device *virtvdev;
> > > +	int ret;
> > > +
> > > +	if (pdev->is_virtfn && virtiovf_support_legacy_access(pdev) &&
> > > +	    !virtiovf_bar0_exists(pdev) && pdev->msix_cap)
> > > +		ops = &virtiovf_acc_vfio_pci_tran_ops;  
> > 
> > This is still an issue for me, it's a very narrow use case where we
> > have a modern device and want to enable legacy support.  Implementing an
> > IO BAR and mangling the device ID seems like it should be an opt-in,
> > not standard behavior for any compatible device.  Users should
> > generally expect that the device they see in the host is the device
> > they see in the guest.  They might even rely on that principle.  
> 
> I think this should be configured when the VF is provisioned. If the
> user does not want legacy IO bar support then the VFIO VF function
> should not advertise the capability, and they won't get driver
> support.
> 
> I think that is a very reasonable way to approach this - it is how we
> approached similar problems for mlx5. The provisioning interface is
> what "profiles" the VF, regardless of if VFIO is driving it or not.

It seems like a huge assumption that every device is going to allow
this degree of specification in provisioning VFs.  mlx5 is a vendor
specific driver, it can make such assumptions in design philosophy.

> > We can't use the argument that users wanting the default device should
> > use vfio-pci rather than virtio-vfio-pci because we've already defined
> > the algorithm by which libvirt should choose a variant driver for a
> > device.  libvirt will choose this driver for all virtio-net devices.  
> 
> Well, we can if the use case is niche. I think profiling a virtio VF
> to support legacy IO bar emulation and then not wanting to use it is
> a niche case.
> 
> The same argument is going come with live migration. This same driver
> will still bind and enable live migration if the virtio function is
> profiled to support it. If you don't want that in your system then
> don't profile the VF for migration support.

What in the virtio or SR-IOV spec requires a vendor to make this
configurable?

> > This driver effectively has the option to expose two different profiles
> > for the device, native or transitional.  We've discussed profile
> > support for variant drivers previously as an equivalent functionality
> > to mdev types, but the only use case for this currently is out-of-tree.
> > I think this might be the opportunity to define how device profiles are
> > exposed and selected in a variant driver.  
> 
> Honestly, I've been trying to keep this out of VFIO...
> 
> The function is profiled when it is created, by whatever created
> it. As in the other thread we have a vast amount of variation in what
> is required to provision the function in the first place. "Legacy IO
> BAR emulation support" is just one thing. virtio-net needs to be
> hooked up to real network and get a MAC, virtio-blk needs to be hooked
> up to real storage and get a media. At a minimum. This is big and
> complicated.
> 
> It may not even be the x86 running VFIO that is doing this
> provisioning, the PCI function may come pre-provisioned from a DPU.
> 
> It feels better to keep that all in one place, in whatever external
> thing is preparing the function before giving it to VFIO. VFIO is
> concerned with operating a prepared function.
> 
> When we get to SIOV it should not be VFIO that is
> provisioning/creating functions. The owning driver should be doing
> this and routing the function to VFIO (eg with an aux device or
> otherwise)
> 
> This gets back to the qemu thread on the grace patch where we need to
> ask how does the libvirt world see this, given there is no good way to
> generically handle all scenarios without a userspace driver to operate
> elements.

So nothing here is really "all in one place", it may be in the
provisioning of the VF, outside of the scope of the host OS, it might
be a collection of scripts or operators with device or interface
specific tooling to configure the device.  Sometimes this configuration
will be before the device is probed by the vfio-pci variant driver,
sometimes in between probing and opening the device.

I don't see why it becomes out of scope if the variant driver itself
provides some means for selecting a device profile.  We have evidence
both from mdev vGPUs and here (imo) that we can expect to see that
behavior, so why wouldn't we want to attempt some basic shared
interface for variant drivers to implement for selecting such a profile
rather than add to this hodgepodge 

> > Jason had previously suggested a devlink interface for this, but I
> > understand that path had been shot down by devlink developers.    
> 
> I think we go some things support but supporting all things was shot
> down.
> 
> > Another obvious option is sysfs, where we might imagine an optional
> > "profiles" directory, perhaps under vfio-dev.  Attributes of
> > "available" and "current" could allow discovery and selection of a
> > profile similar to mdev types.  
> 
> IMHO it is a far too complex problem for sysfs.

Isn't it then just like devlink, not a silver bullet, but useful for
some configuration?  AIUI, devlink shot down a means to list available
profiles for a device and a means to select one of those profiles.
There are a variety of attributes in sysfs which perform this sort of
behavior.  Specifying a specific profile in sysfs can be difficult, and
I'm not proposing sysfs profile support as a mandatory feature, but I'm
also not a fan of the vendor specific sysfs approach that out of tree
drivers have taken.

The mdev type interface is certainly not perfect, but from it we've
been able to develop mdevctl to allow persistent and complex
configurations of mdev devices.  I'd like to see the ability to do
something like that with variant drivers that offer multiple profiles
without always depending on vendor specific interfaces.  Thanks,

Alex

