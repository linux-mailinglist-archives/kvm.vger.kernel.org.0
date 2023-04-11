Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FD36DE6BB
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 23:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjDKV7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 17:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKV7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 17:59:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8076C1722
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 14:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681250318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=01X3BW9dSWKkUKI3evx8TswH2vODNC63/L+kOwOV660=;
        b=GltjLlVr06D/gyHiw9qTDKZMmmDsjT+yfuhdU2Zz9oxJWcAtoIoP7MTxm9bEy94rSUli+Y
        mVnAC3jW8aSUQBGOgiWS98/cD0nr/hIAHJadrHdIUWu3PidKcB4uovohXRATkQL1f5oNw6
        EDn/HSAjjcKo17owJmIq+1qvU8AfIRw=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-9ZyCwnmPOkyKfD8OuPIGCA-1; Tue, 11 Apr 2023 17:58:31 -0400
X-MC-Unique: 9ZyCwnmPOkyKfD8OuPIGCA-1
Received: by mail-il1-f197.google.com with SMTP id d15-20020a056e020bef00b00325e125fbe5so6577751ilu.12
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 14:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681250311; x=1683842311;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=01X3BW9dSWKkUKI3evx8TswH2vODNC63/L+kOwOV660=;
        b=frrw2rPKn2Wxfnm6XXkbziCkkVZP0ge7T4AZQ+ebAsX+ONZuLNjwji2UEHlIuAVzHU
         tW6sSoDcIbx8/wV1Fwp+iChx/5c/1dVp3piP//4hmd1L1xCw6XeqHixhWDVyJEToy4GV
         D1S8/Ibz73zAuyF6XV/bToQ6UTFJWOOy0VQA7JN/sD+yQMBo7em9vBYSLbGy5DPVb0KI
         tMZnZdvfk0kam7kvPjtITmtpYCCnhTMWO5tFsphlierNU5Uob4TLOzxRaRMs5/ZmG+nd
         wVCHTfB33HDr90b99ssYVLMnfK9XuSsM9uhr1E5pcW2l0O7Kl9AbtW7sCt9NuZLbgeJ/
         Gb9A==
X-Gm-Message-State: AAQBX9fBUga0pCJCOkfOkgnzhs+IaW8KdNhTzzTxijnwO+w+TUqgR7gb
        XPagzKprt67GmZ6bzR/DXECi4sar32o2YZ3chmAsu+z0oGi0nHOJMrNuDyAmz4cJ/cZ/HtKIHfF
        BRw5EpAYba8iT
X-Received: by 2002:a92:cb48:0:b0:325:d010:4e93 with SMTP id f8-20020a92cb48000000b00325d0104e93mr2822032ilq.3.1681250310673;
        Tue, 11 Apr 2023 14:58:30 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZPt9ytggYszjYFVCea2twsohapA89hh1BsB5dfHUIIYocTkhUjNToAA92tZSJuFguO8ydorQ==
X-Received: by 2002:a92:cb48:0:b0:325:d010:4e93 with SMTP id f8-20020a92cb48000000b00325d0104e93mr2822021ilq.3.1681250310279;
        Tue, 11 Apr 2023 14:58:30 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g19-20020a925213000000b00329361e8bb2sm113487ilb.67.2023.04.11.14.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 14:58:29 -0700 (PDT)
Date:   Tue, 11 Apr 2023 15:58:27 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <20230411155827.3489400a.alex.williamson@redhat.com>
In-Reply-To: <ZDWph7g0hcbJHU1B@nvidia.com>
References: <ZC2un1LaTUR1OrrJ@nvidia.com>
        <20230405125621.4627ca19.alex.williamson@redhat.com>
        <ZC3KJUxJa0O0M+9O@nvidia.com>
        <20230405134945.29e967be.alex.williamson@redhat.com>
        <ZC4CwH2ouTfZ9DNN@nvidia.com>
        <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230406115347.7af28448.alex.williamson@redhat.com>
        <ZDVfqpOCnImKr//m@nvidia.com>
        <20230411095417.240bac39.alex.williamson@redhat.com>
        <20230411111117.0766ad52.alex.williamson@redhat.com>
        <ZDWph7g0hcbJHU1B@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Apr 2023 15:40:07 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Apr 11, 2023 at 11:11:17AM -0600, Alex Williamson wrote:
> > [Appears the list got dropped, replying to my previous message to re-add]  
> 
> Wowo this got mesed up alot, mutt drops the cc when replying for some
> reason. I think it is fixed up now
> 
> > > Our cdev model says that opening a cdev locks out other cdevs from
> > > independent use, eg because of the group sharing. Extending this to
> > > include the reset group as well seems consistent.  
> > 
> > The DMA ownership model based on the IOMMU group is consistent with
> > legacy vfio, but now you're proposing a new ownership model that
> > optionally allows a user to extend their ownership, opportunistically
> > lock out other users, and wreaking havoc for management utilities that
> > also have no insight into dev_sets or userspace driver behavior.  
> 
> I suggested below that the owership require enough open devices - so
> it doesn't "extend ownership opportunistically", and there is no
> havoc.
> 
> Management tools already need to understand dev_set if they want to
> offer reliable reset support to the VMs. Same as today.

I don't think that's true.  Our primary hot-reset use case is GPUs and
subordinate functions, where the isolation and reset scope are often
sufficiently similar to make hot-reset possible, regardless whether
all the functions are assigned to a VM.  I don't think you'll find any
management tools that takes reset scope into account otherwise.

> > > There is some security concern here, but that goes both ways, a 3rd
> > > party should not be able to break an application that needs to use
> > > this RESET and had sufficient privileges to assert an ownership.  
> > 
> > There are clearly scenarios we have now that could break.  For example,
> > today if QEMU doesn't own all the IOMMU groups for a mult-function
> > device, it can't do a reset, the remaining functions are available for
> > other users.   
> 
> Sure, and we can keep that with this approach.
> 
> > As I understand the proposal, QEMU now gets to attempt to
> > claim ownership of the dev_set, so it opportunistically extends its
> > ownership and may block other users from the affected devices.  
> 
> We can decide the policy for the kernel to accept a claim. I suggested
> below "same as today" - it must hold all the groups within the
> iommufd_ctx.

It must hold all the groups [that the user doesn't know about because
it's not a formal part of the cdev API] within the iommufd_ctx?
 
> The main point is to make this claiming operation qemu needs to do
> clearer and more explicit. I view this as better than trying to guess
> if it successfully made the claim by inspecting the _INFO output.

There is no guessing in the current API.  Guessing is what happens
when hot-reset magically works because one of the devices wasn't opened
at the time, or the iommufd_ctx happens to hold all the affected groups
that the user doesn't have an API to understand.  The current API has a
very concise requirement, the user must own all of the groups affected
by the hot-reset in order to effect a hot-reset.

> > > I'd say anyone should be able to assert RESET ownership if, like
> > > today, the iommufd_ctx has all the groups of the dev_set inside
> > > it. Once asserted it becomes safe against all forms of hotplug, and
> > > continues to be safe even if some of the devices are closed. eg hot
> > > unplugging from the VM doesn't change the availability of RESET.
> > > 
> > > This comes from your ask that qemu know clearly if RESET works, and it
> > > doesn't change while qemu is running. This seems stronger and clearer
> > > than the current implicit scheme. It also doesn't require usespace to
> > > do any calculations with groups or BDFs to figure out of RESET is
> > > available, kernel confirms it directly.  
> > 
> > As above, clarity and predictability seem lacking in this proposal.
> > With the current scheme, the ownership of the affected devices is
> > implied if they exist within an owned group, but the strength of that
> > ownership is clear.    
> 
> Same logic holds here
> 
> Ownership is claimed same as today by having all groups representated
> in the iommufd_ctx. This seems just as clear as today.

I don't know if anyone else is having this trouble, but I'm seeing
conflicting requirements.  The cdev API is not to expose groups unless
a requirement is found to need them, of which this is apparently not
one, but all the groups need to be represented in the iommufd_ctx in
order to make use of this interface.  How is that clear?

> > > > seems this proposal essentially extends the ownership model to the
> > > > greater of the dev_set or iommu group, apparently neither of which
> > > > are explicitly exposed to the user in the cdev API.    
> > > 
> > > IIRC the group id can be learned from sysfs before opening the cdev
> > > file. Something like /sys/class/vfio/XX/../../iommu_group  
> > 
> > And in the passed cdev fd model... ?  
> 
> IMHO we should try to avoid needing to expose group_id specifically to
> userspace. We are missing a way to learn the "same ioas" restriction
> in iommufd, and it should provide that directly based on dev_ids.

Is this yet another "we need to expose groups to understand the ioas
restriction but we're not going to because reasons" argument?

> Otherwise if we really really need group_id then iommufd should
> provide an ioctl to get it. Let's find a good reason first

If needing to have all of the groups represented in an iommufd_ctx in
order to effect a reset without allowing the user to know the set of
affected groups and device to group relationship isn't a reason... well
I'm just lost.

> > > We should also have an iommufd ioctl to report the "same ioas"
> > > groupings of dev_ids to make it easy on userspace. I haven't checked
> > > to see what the current qemu patches are doing with this..  
> > 
> > Seems we're ignoring that no-iommu doesn't have a valid iommufd.  
> 
> no-iommu doesn't and shouldn't have iommu_groups either. It also
> doesn't have an IOAS so querying for same-IOAS is not necessary.
> 
> The simplest option for no-iommu is to require it to pass in every
> device fd to the reset ioctl.

Which ironically is exactly how it ends up working today, each no-iommu
device has a fake IOMMU group, so every affected device (group) needs
to be provided.

> > > > How does a user determine when devices cannot be used independently
> > > > in the cdev API?     
> > > 
> > > We have this problem right now. The only way to learn the reset group
> > > is to call the _INFO ioctl. We could add a sysfs "pci_reset_group"
> > > under /sys/class/vfio/XX/ if something needs it earlier.  
> > 
> > For all the complaints about complexity, now we're asking management
> > tools to not only take into account IOMMU groups, but also reset
> > groups, and some inferred knowledge about the application and devices
> > to speculate whether reset group ownership is taken by a given
> > userspace??  
> 
> No, we are trying to keep things pretty much the same as today without
> resorting to exposing a lot of group related concepts.
> 
> The reset group is a clear concept that already exists and isn't
> exposed. If we really need to know about it then it should be exposed
> on its own, as a seperate discussion from this cdev stuff.

"[A]nd isn't exposed"... what exactly is the hot-reset INFO ioctl
exposing if not that?

> I want to re-focus on the basics of what cdev is supposed to be doing,
> because several of the idea you suggested seem against this direction:
> 
>  - cdev does not have, and cannot rely on vfio_groups. We enforce this
>    by compiling all the vfio_group infrastructure out. iommu_groups
>    continue to exist.
>    
>    So converting a cdev to a vfio_group is not an allowed operation.

My only statements in this respect were towards the notion that IOMMU
groups continue to exist.  I'm well aware of the desire to deprecate
and remove vfio groups.
 
>  - no-iommu should not have iommu_groups. We enforce this by compiling
>    out all the no-iommu vfio_group infrastructure.

This is not logically inferred from the above if IOMMU groups continue
to exist and continue to be a basis for describing DMA ownership as
well as "reset groups" 

>  - cdev APIs should ideally not require the user to know the group_id,
>    we should try hard to design APIs to avoid this.

This is a nuance, group_id vs group, where it's been previously
discussed that users will need to continue to know the boundaries of a
group for the purpose of DMA isolation and potentially IOAS
independence should cdev/iommufd choose to tackle those topics.
 
> We have solved every other problem but reset like this, I would like
> to get past reset without compromising the above.

"These aren't the droids we're looking for."

What is the actual proposal here?  You've said that hot-reset works if
the iommufd_ctx has representation from each affected group, the INFO
ioctl remains as it is, which suggests that it's reporting group ID and
BDF, yet only sysfs tells the user the relation between a vfio cdev and
a group and we're trying to enable a pass-by-fd model for cdev where
the user has no reference to a sysfs node for the device.  Show me how
these pieces fit together.

OTOH, if we say IOMMU groups continue to exist [agreed], every vfio
device has an IOMMU group, and there's an API to learn the group ID, the
solution becomes much more clear and no-iommu devices require no
special cases or restrictions.  Not only does the INFO ioctl remain the
same, but the hot-reset ioctl itself remains effectively the same
accepting either vfio cdevs or groups.  Thanks,

Alex

