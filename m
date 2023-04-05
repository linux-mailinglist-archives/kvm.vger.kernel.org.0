Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A98A6D86B8
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 21:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbjDETTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 15:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233885AbjDETT2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 15:19:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24B16A47
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 12:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680722326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=27u0zO9v+ob0UQ7ffRwx7K9DmjDruN2pjLXeoypPuEc=;
        b=i7sH1mI6NoVGbGaSN0g+7g2bZ3zHJEJwyo0XZ6e7D8PiPTR1iFInVe+AoweBgtplTYd0ta
        89OskPHDGal8QaLHwmCcnrrnV4BtcOfMATdSmoZTNNg4KjbiW9aG0uCn3NyRSvLZoCgozx
        fVM0CiHum9S+VvQjVKFTyl0HYOVN74M=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-8GSrcsJnOwWmBO4VORU_eg-1; Wed, 05 Apr 2023 15:18:45 -0400
X-MC-Unique: 8GSrcsJnOwWmBO4VORU_eg-1
Received: by mail-il1-f197.google.com with SMTP id a3-20020a92c543000000b0032651795968so10271097ilj.19
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 12:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680722324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=27u0zO9v+ob0UQ7ffRwx7K9DmjDruN2pjLXeoypPuEc=;
        b=hRHG27OtYZYcnqiejHtEv6kgA5SqTVq+41LG1dN2UDzEGN18Geen+f6uf+7Na79HLe
         +f9YjDSnoBd2rrv4G7qw4VJuQdadh/4GRrBN1q8hr4fCjDsahWEzIfy7DDk74UppElPz
         xlsftfpajKHADFZMolTkEHCo/dIjmyXf3K13HQfPbbNpHUDCb6o/EHjKm1n9cTAf/QFG
         JI4zSDCLm5ShXrtP9tWni4jsglEaY4knHHkWkpv19HZlnOg1oUMF7ZrklEUJegEFYQhd
         Zezdc1NiFVgWG81HcQrxRhRSywq1j8Y4keo6MoDqLAx7BNKUeBzGgQenAGjEsz7GoMSD
         Tj8A==
X-Gm-Message-State: AAQBX9dKQJjJ5wyHI7qRF3Fpo+6shW1HEGy4P1JSWvXX+DS6yvVj0E/f
        5+13RWgk67aWhYhpkvco2pIHJmEV5p7uADouC483LljLhLjIV2PaUmeax/7KdQpVrgMZiF9ptRS
        ljfYJg5ZEWqQ+
X-Received: by 2002:a5e:c01a:0:b0:6df:fa5a:fa05 with SMTP id u26-20020a5ec01a000000b006dffa5afa05mr5158321iol.0.1680722323989;
        Wed, 05 Apr 2023 12:18:43 -0700 (PDT)
X-Google-Smtp-Source: AKy350aKp1rN/Q9seH+uDr5Kxzn5Y5DEGvl7YEySn1ATsYRV0m1WagFqXA1p2GEjk9lkOc3YbYLwjQ==
X-Received: by 2002:a5e:c01a:0:b0:6df:fa5a:fa05 with SMTP id u26-20020a5ec01a000000b006dffa5afa05mr5158303iol.0.1680722323678;
        Wed, 05 Apr 2023 12:18:43 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b4-20020a056602218400b00758917bc309sm4128612iob.31.2023.04.05.12.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 12:18:43 -0700 (PDT)
Date:   Wed, 5 Apr 2023 13:18:42 -0600
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <20230405131842.3bbc53f3.alex.williamson@redhat.com>
In-Reply-To: <20230405125621.4627ca19.alex.williamson@redhat.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <a937e622-ce32-6dda-d77c-7d8d76474ee0@redhat.com>
        <DS0PR11MB7529D4E354C3B85D7698017DC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230405102545.41a61424.alex.williamson@redhat.com>
        <ZC2jsQuWiMYM6JZb@nvidia.com>
        <20230405105215.428fa9f5.alex.williamson@redhat.com>
        <ZC2un1LaTUR1OrrJ@nvidia.com>
        <20230405125621.4627ca19.alex.williamson@redhat.com>
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

On Wed, 5 Apr 2023 12:56:21 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 5 Apr 2023 14:23:43 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Apr 05, 2023 at 10:52:15AM -0600, Alex Williamson wrote:  
> > > On Wed, 5 Apr 2023 13:37:05 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >     
> > > > On Wed, Apr 05, 2023 at 10:25:45AM -0600, Alex Williamson wrote:
> > > >     
> > > > > But that kind of brings to light the question of what does the user do
> > > > > when they encounter this situation.      
> > > > 
> > > > What does it do now when it encounters a group_id it doesn't
> > > > understand? Userspace already doesn't know if the foreign group is
> > > > open or not, right?    
> > > 
> > > It's simple, there is currently no screwiness around opened devices.
> > > If the caller doesn't own all the groups mapping to the affected
> > > devices, hot-reset is not available.    
> > 
> > That still has nasty edge cases. If the reset group spans beyond a
> > single iommu group you end up with qemu being unable to operate reset
> > at all, and it is unfixable from an API perspective as we can't pass
> > in groups that VFIO isn't going to use.  
> 
> Hmm, s/nasty/niche/?  Yes, QEMU currently has no way to own a group
> without assigning a device from the group, but technically that could
> be fixed within QEMU.  If QEMU doesn't own that affected group, then it
> can't very well count on that group to not be used in some other way
> when it comes time to actually do a hot-reset.
>  
> > I think you are right, the fact we'd have to return -1 dev_ids to this
> > modified API is pretty damaging, it doesn't seem like a good
> > direction.
> >   
> > > This leads to scenarios where the info ioctl indicates a hot-reset is
> > > initially available, perhaps only because one of the affected devices
> > > was not opened at the time, and now it fails when QEMU actually tries
> > > to use it.    
> > 
> > I would like it if the APIs toward the kernel were only about the
> > kernel's security apparatus. It is makes it easier to reason about the
> > kernel side and gives nice simple well defined APIs.  
> 
> Usability needs to be a consideration as well.  An interface where the
> result is effectively arbitrary from a user perspective because the
> kernel is solely focused on whether the operation is allowed,
> evaluating constraints that the user is unaware of and cannot control,
> is unusable.
> 
> > This is a good point that qemu needs to make a policy decision if it
> > is happy about the VFIO configuration - but that is a policy decision
> > that should not become entangled with the kernel's security checks.
> > 
> > Today qemu can make this policy choice the same way it does right now
> > - call _INFO and check the group_ids. It gets the exact same outcome
> > as today. We already discussed that we need to expose the group ID
> > through an ioctl someplace.  
> 
> QEMU can make a policy decision today because the kernel provides a
> sufficiently reliable interface, ie. based on the set of owned groups, a
> hot-reset is all but guaranteed to work.  If we focus only on whether a
> given reset is allowed from a kernel perspective and ignore that
> userspace needs some predictability of the kernel behavior, then QEMU
> cannot reasonable make that policy decision.
> 
> > If this is too awkward we could add a query to the kernel if the cdev
> > is "reset exclusive" - eg the iommufd covers all the groups that span
> > the reset set.  
> 
> That's essentially what we have if there are valid dev-ids for each
> affected device in the info ioctl.  I don't think it helps the user
> experience to create loopholes where the hot-reset ioctl can still work
> in spite of those missing devices.  The group interface uses the fact
> that ownership of the group implies ownership of all devices within the
> group such that the user only needs to prove group ownership.
> 
> But we still have underlying groups even with the cdev model, with the
> same ownership principles, so don't we just need to prove group
> ownership based on a device fd rather than a group fd?
> 
> For example, we have a VFIO_DEVICE_GET_INFO ioctl that supports
> capability chains, we could add a capability that reports the group ID
> for the device.  The hot-reset info ioctl remains as it is today,
> reporting group-ids and bdfs.  The hot-reset ioctl itself is modified to
> transparently support either group fds or device fds.  The user can now
> map cdevs to group-ids and therefore follow the same rules as groups,
> providing at least one representative device fd for each group.  We've
> essentially already enabled this by allowing the limit of user provided
> fds equal to the number of affected devices.

If I'm not mistaken, I think this resolves cdev no-iommu to work
equivalently to groups as well.  Thanks,

Alex

