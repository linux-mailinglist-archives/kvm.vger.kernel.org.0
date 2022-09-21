Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908EF5D1C98
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 20:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiIUSHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 14:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiIUSG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 14:06:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4137754F
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 11:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663783615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I8WvJY2ZBojq4QA0ugwOQiu67YH7FFdEworZoVmg7u8=;
        b=QgT/UI3yF14MiYK+9CuQ/zJcSzFuqTfVnnA5hlHFeUmQAMmwOBk58JbVFer7WLIWY3g+zq
        UF+zhF54XhxWFW24/5Ccw1Wpo7PpILar98CGtRRoHl33K594IKY+FBg2sLNnQuaeQm++jo
        bMH/vJuZtRuVWz4jFa9oGC4UR0nlnHc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-qJNvxHQmPC6AXFOfeZUc_w-1; Wed, 21 Sep 2022 14:06:53 -0400
X-MC-Unique: qJNvxHQmPC6AXFOfeZUc_w-1
Received: by mail-io1-f72.google.com with SMTP id g12-20020a5d8c8c000000b006894fb842e3so3467137ion.21
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 11:06:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=I8WvJY2ZBojq4QA0ugwOQiu67YH7FFdEworZoVmg7u8=;
        b=qz+OvIurTjlBlM/CgRvBcdEcYLD7ytfprkgRSmTFCcQr4vOaQY7i5tvirPLUodjMco
         Wzg/R4I5RmXbVS2x6uVLMUdAHwSlepHXUmjft8pS5ysCY56oeJ/lMFRoqzOmZEQ6YgwP
         vCKEoHEMWYgGP+8uf5O+hjYoCtU6PFmgTyUYPRGy2FL7b5x/aQsY9SjwSPc397zUN6ro
         G6zFhfPrhGs12ys7TvLYdk/EQ9xdQ/kug8T9MiKcPlXC8lY2k4CvWW9tg9I6yceTureW
         6wV/kKJXY2K7vHLbPmTupNmshIdf6PvJiEiDZDJC34b/zLqXYNRnqgurpXZC5mLt31cy
         M7gg==
X-Gm-Message-State: ACrzQf1EvPLxc8TJvt0ovkleLg0SHoDc/yX/eRYF9DaZWCldnys+DjQf
        R51OHvBmRpFIlA82FnqqIawL3MWlWZ0me3/XPj4E30K26hUF/Rifbes1KJCUuD4v7zmXC0Vi0v2
        oJ/3cKeRETS++
X-Received: by 2002:a05:6638:3a7:b0:35a:7930:b717 with SMTP id z7-20020a05663803a700b0035a7930b717mr13070689jap.314.1663783612896;
        Wed, 21 Sep 2022 11:06:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6GN4sY4YRqxQ2Y2P+sl2u5wrGiL9+URKREehBKF6J3WGunlkDs/PQnOmlQ09Z5GWcGKWd0Yw==
X-Received: by 2002:a05:6638:3a7:b0:35a:7930:b717 with SMTP id z7-20020a05663803a700b0035a7930b717mr13070675jap.314.1663783612566;
        Wed, 21 Sep 2022 11:06:52 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l5-20020a023905000000b00342cb39de68sm1249582jaa.130.2022.09.21.11.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 11:06:51 -0700 (PDT)
Date:   Wed, 21 Sep 2022 12:06:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Steve Sistare <steven.sistare@oracle.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Message-ID: <20220921120649.5d2ff778.alex.williamson@redhat.com>
In-Reply-To: <Yyoa+kAJi2+/YTYn@nvidia.com>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
        <BN9PR11MB52762909D64C1194F4FCB4528C479@BN9PR11MB5276.namprd11.prod.outlook.com>
        <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
        <Yyoa+kAJi2+/YTYn@nvidia.com>
Organization: Red Hat
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

[Cc+ Steve, libvirt, Daniel, Laine]

On Tue, 20 Sep 2022 16:56:42 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Sep 13, 2022 at 09:28:18AM +0200, Eric Auger wrote:
> > Hi,
> > 
> > On 9/13/22 03:55, Tian, Kevin wrote:  
> > > We didn't close the open of how to get this merged in LPC due to the
> > > audio issue. Then let's use mails.
> > >
> > > Overall there are three options on the table:
> > >
> > > 1) Require vfio-compat to be 100% compatible with vfio-type1
> > >
> > >    Probably not a good choice given the amount of work to fix the remaining
> > >    gaps. And this will block support of new IOMMU features for a longer time.
> > >
> > > 2) Leave vfio-compat as what it is in this series
> > >
> > >    Treat it as a vehicle to validate the iommufd logic instead of immediately
> > >    replacing vfio-type1. Functionally most vfio applications can work w/o
> > >    change if putting aside the difference on locked mm accounting, p2p, etc.
> > >
> > >    Then work on new features and 100% vfio-type1 compat. in parallel.
> > >
> > > 3) Focus on iommufd native uAPI first
> > >
> > >    Require vfio_device cdev and adoption in Qemu. Only for new vfio app.
> > >
> > >    Then work on new features and vfio-compat in parallel.
> > >
> > > I'm fine with either 2) or 3). Per a quick chat with Alex he prefers to 3).  
> > 
> > I am also inclined to pursue 3) as this was the initial Jason's guidance
> > and pre-requisite to integrate new features. In the past we concluded
> > vfio-compat would mostly be used for testing purpose. Our QEMU
> > integration fully is based on device based API.  
> 
> There are some poor chicken and egg problems here.
> 
> I had some assumptions:
>  a - the vfio cdev model is going to be iommufd only
>  b - any uAPI we add as we go along should be generally useful going
>      forward
>  c - we should try to minimize the 'minimally viable iommufd' series
> 
> The compat as it stands now (eg #2) is threading this needle. Since it
> can exist without cdev it means (c) is made smaller, to two series.
> 
> Since we add something useful to some use cases, eg DPDK is deployable
> that way, (b) is OK.
> 
> If we focus on a strict path with 3, and avoid adding non-useful code,
> then we have to have two more (unwritten!) series beyond where we are
> now - vfio group compartmentalization, and cdev integration, and the
> initial (c) will increase.
> 
> 3 also has us merging something that currently has no usable
> userspace, which I also do dislike alot.
> 
> I still think the compat gaps are small. I've realized that
> VFIO_DMA_UNMAP_FLAG_VADDR has no implementation in qemu, and since it
> can deadlock the kernel I propose we purge it completely.

Steve won't be happy to hear that, QEMU support exists but isn't yet
merged.
 
> P2P is ongoing.
> 
> That really just leaves the accounting, and I'm still not convinced at
> this must be a critical thing. Linus's latest remarks reported in lwn
> at the maintainer summit on tracepoints/BPF as ABI seem to support
> this. Let's see an actual deployed production configuration that would
> be impacted, and we won't find that unless we move forward.

I'll try to summarize the proposed change so that we can get better
advice from libvirt folks, or potentially anyone else managing locked
memory limits for device assignment VMs.

Background: when a DMA range, ex. guest RAM, is mapped to a vfio device,
we use the system IOMMU to provide GPA to HPA translation for assigned
devices. Unlike CPU page tables, we don't generally have a means to
demand fault these translations, therefore the memory target of the
translation is pinned to prevent that it cannot be swapped or
relocated, ie. to guarantee the translation is always valid.

The issue is where we account these pinned pages, where accounting is
necessary such that a user cannot lock an arbitrary number of pages
into RAM to generate a DoS attack.  Duplicate accounting should be
resolved by iommufd, but is outside the scope of this discussion.

Currently, vfio tests against the mm_struct.locked_vm relative to
rlimit(RLIMIT_MEMLOCK), which reads task->signal->rlim[limit].rlim_cur,
where task is the current process.  This is the same limit set via the
setrlimit syscall used by prlimit(1) and reported via 'ulimit -l'.

Note that in both cases above, we're dealing with a task, or process
limit and both prlimit and ulimit man pages describe them as such.

iommufd supposes instead, and references existing kernel
implementations, that despite the descriptions above these limits are
actually meant to be user limits and therefore instead charges pinned
pages against user_struct.locked_vm and also marks them in
mm_struct.pinned_vm.

The proposed algorithm is to read the _task_ locked memory limit, then
attempt to charge the _user_ locked_vm, such that user_struct.locked_vm
cannot exceed the task locked memory limit.

This obviously has implications.  AFAICT, any management tool that
doesn't instantiate assigned device VMs under separate users are
essentially untenable.  For example, if we launch VM1 under userA and
set a locked memory limit of 4GB via prlimit to account for an assigned
device, that works fine, until we launch VM2 from userA as well.  In
that case we can't simply set a 4GB limit on the VM2 task because
there's already 4GB charged against user_struct.locked_vm for VM1.  So
we'd need to set the VM2 task limit to 8GB to be able to launch VM2.
But not only that, we'd need to go back and also set VM1's task limit
to 8GB or else it will fail if a DMA mapped memory region is transient
and needs to be re-mapped.

Effectively any task under the same user and requiring pinned memory
needs to have a locked memory limit set, and updated, to account for
all tasks using pinned memory by that user.

How does this affect known current use cases of locked memory
management for assigned device VMs?

Does qemu://system by default sandbox into per VM uids or do they all
use the qemu user by default.  I imagine qemu://session mode is pretty
screwed by this, but I also don't know who/where locked limits are
lifted for such VMs.  Boxes, who I think now supports assigned device
VMs, could also be affected. 
 
> So, I still like 2 because it yields the smallest next step before we
> can bring all the parallel work onto the list, and it makes testing
> and converting non-qemu stuff easier even going forward.

If a vfio compatible interface isn't transparently compatible, then I
have a hard time understanding its value.  Please correct my above
description and implications, but I suspect these are not just
theoretical ABI compat issues.  Thanks,

Alex

