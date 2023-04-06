Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A7D6D9E2B
	for <lists+kvm@lfdr.de>; Thu,  6 Apr 2023 19:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239917AbjDFRI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 13:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239918AbjDFRI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 13:08:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B6D8688
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 10:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680800861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CYs/YTBPAeoCCyWf8iNbjYyQ4fg6NFRZSOGDs3dDQx0=;
        b=D84xwKyAx9EoiGU87w24Bwp3CojSfjCqWOHa1ADfjQPYszUtl/ZAVVuoMyETr/uSLCYSRL
        WrkGoymCn22Fu/1yE7mf8xIkDg0oWXl70zd5FefViPb7ef+964CCbxWu02F1yOLToF46Ao
        khrxj/+zXVk0Txyx0qq99zrvcC94pmM=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-Brmr4w8lNFSmFiIkFld_bw-1; Thu, 06 Apr 2023 13:07:40 -0400
X-MC-Unique: Brmr4w8lNFSmFiIkFld_bw-1
Received: by mail-il1-f200.google.com with SMTP id x5-20020a056e021ca500b00327f726c6c0so3055761ill.9
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 10:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680800859; x=1683392859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CYs/YTBPAeoCCyWf8iNbjYyQ4fg6NFRZSOGDs3dDQx0=;
        b=KVYVn5yfLbfGKuC6U9mWiPLuVT+5q63bWOL+l3OhWCzuU9yg7nevEPBkM4yHpHL10Z
         m80tujOl81XFMVH/tqAeJDraQ4QrR5TWmDu81EeU/vyWN6tBt76rE3IKSw/2+Vvbnu5a
         N1XkTalgBAJH0BoL0vfWMSAHdojTZllOdMUb0pSLV7lAepBge9XgFukgUSWs//Ir6DON
         s9Dvn4gmP44iRogcPaXwrqHthNGl+4VbMDBTkWgp0TJgR5wjW+bqTRFeqpHOo+Q5P4HL
         C7TlhaX9qYi+M1bzYqholl+iRMIh8a1FqYcERHu5aC/p3kPKhvbYvpYvFnPPupobtU0t
         BXPw==
X-Gm-Message-State: AAQBX9fDgXQkH2/Pb43O6AReEQUy56vZW+7CqSWXUgyJaX3empq2ppde
        9P0u+tM/RGR/OhQc1NKIWXyBIyzi1BVNm8gO/DXBNe3c5EUqkrigW9NAFevXZOgnUNJLhELMBxH
        2KcpixizCAn1/
X-Received: by 2002:a6b:dc12:0:b0:760:932:6540 with SMTP id s18-20020a6bdc12000000b0076009326540mr199355ioc.5.1680800859191;
        Thu, 06 Apr 2023 10:07:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350bgCWzDSICKLPrjf6kX9FAgkvxckObpMsDIUL+65Km3Qn1IhEw3KlB4zvoWm6GDUacxz8McNg==
X-Received: by 2002:a6b:dc12:0:b0:760:932:6540 with SMTP id s18-20020a6bdc12000000b0076009326540mr199331ioc.5.1680800858848;
        Thu, 06 Apr 2023 10:07:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p16-20020a056638191000b003b015157f47sm514912jal.9.2023.04.06.10.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 10:07:38 -0700 (PDT)
Date:   Thu, 6 Apr 2023 11:07:36 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <20230406110736.335ad2e8.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB752987A5B996D93582F8A8BCC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
        <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230405102545.41a61424.alex.williamson@redhat.com>
        <ZC2jsQuWiMYM6JZb@nvidia.com>
        <20230405105215.428fa9f5.alex.williamson@redhat.com>
        <ZC2un1LaTUR1OrrJ@nvidia.com>
        <20230405125621.4627ca19.alex.williamson@redhat.com>
        <ZC3KJUxJa0O0M+9O@nvidia.com>
        <20230405134945.29e967be.alex.williamson@redhat.com>
        <DS0PR11MB752987A5B996D93582F8A8BCC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 Apr 2023 06:34:08 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Thursday, April 6, 2023 3:50 AM
> > 
> > On Wed, 5 Apr 2023 16:21:09 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Wed, Apr 05, 2023 at 12:56:21PM -0600, Alex Williamson wrote:  
> > > > Usability needs to be a consideration as well.  An interface where the
> > > > result is effectively arbitrary from a user perspective because the
> > > > kernel is solely focused on whether the operation is allowed,
> > > > evaluating constraints that the user is unaware of and cannot control,
> > > > is unusable.  
> > >
> > > Considering this API is only invoked by qemu we might be overdoing
> > > this usability and 'no shoot in foot' view.  
> > 
> > Ok, I'm not sure why we're diminishing the de facto vfio userspace...
> >   
> > > > > This is a good point that qemu needs to make a policy decision if it
> > > > > is happy about the VFIO configuration - but that is a policy decision
> > > > > that should not become entangled with the kernel's security checks.
> > > > >
> > > > > Today qemu can make this policy choice the same way it does right now
> > > > > - call _INFO and check the group_ids. It gets the exact same outcome
> > > > > as today. We already discussed that we need to expose the group ID
> > > > > through an ioctl someplace.  
> > > >
> > > > QEMU can make a policy decision today because the kernel provides a
> > > > sufficiently reliable interface, ie. based on the set of owned groups, a
> > > > hot-reset is all but guaranteed to work.  
> > >
> > > And we don't change that with cdev. If qemu wants to make the policy
> > > decision it keeps using the exact same _INFO interface to make that
> > > decision same it has always made.
> > >
> > > We weaken the actual reset action to only consider the security side.
> > >
> > > Applications that want this exclusive reset group policy simply must
> > > check it on their own. It is a reasonable API design.  
> > 
> > I disagree, as I've argued before, the info ioctl becomes so weak and
> > effectively arbitrary from a user perspective at being able to predict
> > whether the hot-reset ioctl works that it becomes useless, diminishing
> > the entire hot-reset info/execute API.
> >   
> > > > > If this is too awkward we could add a query to the kernel if the cdev
> > > > > is "reset exclusive" - eg the iommufd covers all the groups that span
> > > > > the reset set.  
> > > >
> > > > That's essentially what we have if there are valid dev-ids for each
> > > > affected device in the info ioctl.  
> > >
> > > If you have dev-ids for everything, yes. If you don't, then you can't
> > > make the same policy choice using a dev-id interface.  
> > 
> > Exactly, you can't make any policy choice because the success or
> > failure of the hot-reset ioctl can't be known.  
> 
> could you elaborate a bit about what the policy is here. As far as I know,
> QEMU makes use of the information reported by _INFO to check:
> - if all the affected groups are owned by the current QEMU[1]
> - if the affected devices are opened by the current QEMU, if yes, QEMU
>   needs to use vfio_pci_pre_reset() to do preparation before issuing
>   hot rest[1]
> 
> [1] vfio_pci_hot_reset() in https://github.com/qemu/qemu/blob/master/hw/vfio/pci.c

Regarding the policy decisions, look for instance at the distinction
between vfio_pci_hot_reset_one() vs vfio_pci_hot_reset_multi(), or the
way QEMU will opt for a bus reset if it believes only a PM reset is
available.

In my proposal, I did miss that if _INFO reports the group and bdf that
allows QEMU to associate fd passed devices to a group affected by the
reset, but not specifically whether the device is affected by the
reset.  I think that would be justification for capabilities on the
DEVICE_GET_INFO ioctl to report both the group and PCI address as
separate capabilities.
 
> > > > I don't think it helps the user experience to create loopholes where
> > > > the hot-reset ioctl can still work in spite of those missing
> > > > devices.  
> > >
> > > I disagree. The easy straightforward design is that the reset ioctl
> > > works if the process has security permissions. Mixing a policy check
> > > into the kernel on this path is creating complexity we don't really
> > > need.
> > >
> > > I don't view it as a loophole, it is flexability to use the API in a
> > > way that is different from what qemu wants - eg an app like dpdk may
> > > be willing to tolerate a reset group that becomes unavailable after
> > > startup. Who knows, why should we force this in the kernel?  
> > 
> > Because look at all the problems it's causing to try to introduce these
> > loopholes without also introducing subtle bugs.  There's an argument
> > that we're overly strict, which is better than the alternative, which
> > seems to be what we're dabbling with.  It is a straightforward
> > interface for the hot-reset ioctl to mirror the information provided
> > via the hot-reset info ioctl.
> >   
> > > > For example, we have a VFIO_DEVICE_GET_INFO ioctl that supports
> > > > capability chains, we could add a capability that reports the group ID
> > > > for the device.  
> > >
> > > I was going to put that in an iommufd ioctl so it works with VDPA too,
> > > but sure, lets assume we can get the group ID from a cdev fd.
> > >  
> > > > The hot-reset info ioctl remains as it is today, reporting group-ids
> > > > and bdfs.  
> > >
> > > Sure, but userspace still needs to know how to map the reset sets into
> > > dev-ids.  
> > 
> > No, it doesn't.
> >   
> > > Remember the reason we started doing this is because we don't
> > > have easy access to the BDF anymore.  
> > 
> > We don't need it, the info ioctl provides the groups, the group
> > association can be learned from the DEVICE_GET_INFO ioctl, the
> > hot-reset ioctl only requires a single representative fd per affected
> > group.  dev-ids not required.
> >   
> > > I like leaving this ioctl alone, lets go back to a dedicated ioctl to
> > > return the dev_ids.  
> > 
> > I don't see any justification for this.  We could add another PCI
> > specific DEVICE_GET_INFO capability to report the bdf if we really need
> > it, but reporting the group seems sufficient for this use case.  
> 
> IMHO, the knowledge of group may be not enough. Take QEMU as an example.
> QEMU not only needs to ensure the group is owned by it, it also needs to
> do preparation on the devices that are already in use and affected by
> the hot reset on a new opened device. If there is only group knowledge,
> QEMU may blindly prepares all the devices that are already opened and
> belong to the same iommu group. But as I got in the discussion iommu
> group is not equal to hot reset scope (a.k.a. dev_set). is it? It is
> possible that devices in an iommu_group may span into multiple hot
> reset scope. For such case, get bdf info from cdev fd is necessary.

Yes, you're correct, group and reset scope are not equivalent, so we'd
require a means to get both the group and the bdf for the device.
Knowing the bdf allows the user to know which opened devices are
directly affected by the reset, knowing the group allows the user to
know if ancillary affected devices are within the set of groups the
user owns and therefore effectively under their purview.  Thanks,

Alex

