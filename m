Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C773F6E13E4
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 20:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjDMSII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 14:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDMSIG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 14:08:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AE530DA
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681409237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IOA7GIourt4XlsCYYtkutlqTOJFvaYitvC0BAJCLNRU=;
        b=Sdk/ORLwJ+JKUP9ok4oUPwp73qLmdLaXmdRAhGLe/Kob52pKteViL1HdFEmYRkIJxXlHkD
        o9QeyvhPjwLSJO4ucWrz9t0sHkAPKxfvQUz2bcWS5PHgFULnCVGLgYF/6xqiqjG+mwmxz/
        fqxEFhOaHXU+9WTrQSEuuIwZnXcIZxs=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-yoS8VwkqO5OyACkkYfTBiA-1; Thu, 13 Apr 2023 14:07:15 -0400
X-MC-Unique: yoS8VwkqO5OyACkkYfTBiA-1
Received: by mail-il1-f200.google.com with SMTP id i25-20020a056e021d1900b00316f1737173so9819965ila.16
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 11:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681409235; x=1684001235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IOA7GIourt4XlsCYYtkutlqTOJFvaYitvC0BAJCLNRU=;
        b=B8307/PiCva8eYyaQ3OuaVcflfj0GPMPWf1gqRIjMd7fJb9Zh8Hlr2YbEEckbIwT1+
         Ug+WFCx/BaQ2c/KrxVd/MVhAfRLUvAzn6nSCopYSGyZAFyZ4ZlyrDxcgsaQ2gvUZxMbr
         K174nwLOq7n88I3II9Guk7G+xjM2LXweoN33INjOcskVOKDV9oL5hvt+qnzGdTF82cN+
         TnSiw+Y04iOuumJitcxqXvj4Gp1U218a697nLpjG8cIqaGcIwZYkcU4BhBgcVpnhB37K
         xV7PJZcx2XCbQQ6XRSej7fXrQZcDHo+1httP/FJuPvNnurAUBmoNNcKjibWmQa9740VQ
         b4yQ==
X-Gm-Message-State: AAQBX9eDuzoPk01IP1tH3aepv4XgIjKcngYtCL9Tz4KscP3dNgM9fyYJ
        hYi/HGIfHYxq+B7mllFVzDaNsE7UrMAdoN4eGlah+FiJkTcNhy8TFMymekRw32IYEATERUBODtg
        ZsXLox0iNn1N0
X-Received: by 2002:a5e:a80b:0:b0:74d:1318:618c with SMTP id c11-20020a5ea80b000000b0074d1318618cmr2016109ioa.10.1681409234949;
        Thu, 13 Apr 2023 11:07:14 -0700 (PDT)
X-Google-Smtp-Source: AKy350aNIxbTK4D/1WKJFyoeXfJddaFP2YjlcKRNN7MPTcaqR3ipJt2l6zNqwAhtPjb9PRhgDB1hHQ==
X-Received: by 2002:a5e:a80b:0:b0:74d:1318:618c with SMTP id c11-20020a5ea80b000000b0074d1318618cmr2016087ioa.10.1681409234657;
        Thu, 13 Apr 2023 11:07:14 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g7-20020a5ec747000000b00746cb6d90c0sm618854iop.14.2023.04.13.11.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 11:07:14 -0700 (PDT)
Date:   Thu, 13 Apr 2023 12:07:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
Message-ID: <20230413120712.3b9bf42d.alex.williamson@redhat.com>
In-Reply-To: <ZDfslVwqk6JtPpyD@nvidia.com>
References: <20230406115347.7af28448.alex.williamson@redhat.com>
        <ZDVfqpOCnImKr//m@nvidia.com>
        <20230411095417.240bac39.alex.williamson@redhat.com>
        <20230411111117.0766ad52.alex.williamson@redhat.com>
        <ZDWph7g0hcbJHU1B@nvidia.com>
        <20230411155827.3489400a.alex.williamson@redhat.com>
        <ZDX0wtcvZuS4uxmG@nvidia.com>
        <20230412105045.79adc83d.alex.williamson@redhat.com>
        <ZDcPTTPlni/Mi6p3@nvidia.com>
        <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Apr 2023 08:50:45 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Apr 13, 2023 at 08:25:52AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, April 13, 2023 4:07 AM
> > > 
> > >   
> > > > in which case we need c) a way to
> > > > report the overall set of affected devices regardless of ownership in
> > > > support of 4), BDF?  
> > > 
> > > Yes, continue to use INFO unmodified.
> > >   
> > > > Are we back to replacing group-ids with dev-ids in the INFO structure,
> > > > where an invalid dev-id either indicates an affected device with
> > > > implied ownership (ok) or a gap in ownership (bad) and a flag somewhere
> > > > is meant to indicate the overall disposition based on the availability
> > > > of reset?  
> > > 
> > > As you explore in the following this gets ugly. I prefer to keep INFO
> > > unchanged and add INFO2.
> > >   
> > 
> > INFO needs a change when VFIO_GROUP is disabled. Now it assumes
> > a valid iommu group always exists:
> > 
> > vfio_pci_fill_devs()
> > {
> > 	...
> > 	iommu_group = iommu_group_get(&pdev->dev);
> > 	if (!iommu_group)
> > 		return -EPERM; /* Cannot reset non-isolated devices */
> > 	...
> > }  
> 
> This can still work in a ugly way. With a INFO2 the only purpose of
> INFO would be debugging, so if someone uses no-iommu, with hotreset
> and misconfigures it then the only downside is they don't get the
> debugging print. But we know of nothing that uses this combination
> anyhow..
> 
> > with that plus BDF cap, I'm curious what is the actual purpose of
> > INFO2 or why cannot requirement#3 reuse the information collected
> > via existing INFO?  
> 
> It can - it is just more complicated for userspace to do it, it has to
> extract and match the BDFs and then run some algorithm to determine if
> the opened devices cover the right set of devices in the reset group,
> and it has to have some special code for no-iommu.
> 
> VS info2 would return the dev_id's and a single yes/no if the right
> set is present. Kernel runs the algorithm instead of userspace, it
> seems more abstract this way.
> 
> Also, if we make iommufd return a 'ioas dev_id group' as well it
> composes nicely that userspace just needs one translation from dev_id.


IIUC, the semantics we're proposing is that an INFO2 ioctl would return
success or failure indicating whether the user has sufficient ownership
of the affected devices, and in the success case returns an array of
affected dev-ids within the user's iommufd_ctx.  Unopened, affected
devices, are not reported via INFO2, and unopened, affected devices
outside the user's scope of ownership (ie. outside the owned IOMMU
group) will generate a failure condition.

As for the INFO ioctl, it's described as unchanged, which does raise
the question of what is reported for IOMMU groups and how does the
value there coherently relate to anything else in the cdev-exclusive
vfio API...

We had already iterated a proposal where the group-id is replaced with
a dev-id in the existing ioctl and a flag indicates when the return
value is a dev-id vs group-id.  This had a gap that userspace cannot
determine if a reset is available given this information since un-owned
devices report an invalid dev-id and userspace can't know if it has
implicit ownership.

It seems cleaner to me though that we would could still re-use INFO in
a similar way, simply defining a new flag bit which is valid only in
the case of returning dev-ids and indicates if the reset is available.
Therefore in one ioctl, userspace knows if hot-reset is available
(based on a kernel determination) and can pull valid dev-ids from the
array to associate affected, owned devices, and still has the
equivalent information to know that one or more of the devices listed
with an invalid dev-id are preventing the hot-reset from being
available.

Is that an option?  Thanks,

Alex

