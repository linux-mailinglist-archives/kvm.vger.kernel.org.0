Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0BB6DBB8B
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 16:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjDHOVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 10:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjDHOVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 10:21:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A29B745
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 07:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680963623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwBQ3fcgCLoaaPNFBnbMDDhYLG0rf+SbWXB4MPe+GUw=;
        b=KnW57U7WC7OSdZEFvhttxcwMXbT62sS5ZUAj2lUmlfEzXduXgZ9lT4hwf99YgrB4KQ0lkF
        QKwKM69bxQnXPFq5MK4g6uYSV1EyKlK3kRlKl5ci/VH0vU8aOfSvN5uXq3iCc7SbySXaUC
        nXph3NtmRkQgcjoKheEzEqVplx0rKMc=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-_qzf5ht2OEKM44GecAn5Dw-1; Sat, 08 Apr 2023 10:20:22 -0400
X-MC-Unique: _qzf5ht2OEKM44GecAn5Dw-1
Received: by mail-il1-f198.google.com with SMTP id r14-20020a056e02108e00b00326334613f0so19565880ilj.20
        for <kvm@vger.kernel.org>; Sat, 08 Apr 2023 07:20:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680963621; x=1683555621;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TwBQ3fcgCLoaaPNFBnbMDDhYLG0rf+SbWXB4MPe+GUw=;
        b=qHkAcjpZqa4NyrhuEDtdBMivKgCj+tveB9b3dIBwEty1hSulwrlGFIER+Da0PFEiVb
         b651gQ1GQU+V8a1hMqdJzrmPlAxn+kD7XxcVSXt0SSRjM9uMfOiiR/zLkf7SBza+q4Qm
         jTsVR0/UxDbEZSI4bGv2/+885xsU+Yf7G/NBUlW58zJvQsVSM++k9QGhVP3AjnMlgkI0
         Am2AFD4JkUw4GVMz0d22HBYpYmhkVIQzCavixIlzCyezhvaEGj2rZCjpM9657rzqkmb+
         A8uIVhLFAGVFaU1KxlRQlMloTRpYQLGpqlKYnb1PE2oLQoSyjRc0YEzv459GXs67lGR6
         ufog==
X-Gm-Message-State: AAQBX9dLJEs5UAsZkn9U7zPKPdQTJRfahMstqiCPDTW6HCh6V/y8metQ
        MKKzwQGu6ItmxBLWkIAFlra8xF0si2TWLG6IjE55fIqNfgpTHJ0v/JgNNrU+TuAnJ0q/zjcA3Cd
        QmcYyMtaBXZf0
X-Received: by 2002:a92:c010:0:b0:328:6172:a745 with SMTP id q16-20020a92c010000000b003286172a745mr2589509ild.17.1680963621559;
        Sat, 08 Apr 2023 07:20:21 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZG06CZCHjPF9Rl3wT0GBsGjOshJkC3m5OR028WCAVRG/H9aKjSa9KSyR31V4v+hR73BIITZw==
X-Received: by 2002:a92:c010:0:b0:328:6172:a745 with SMTP id q16-20020a92c010000000b003286172a745mr2589493ild.17.1680963621212;
        Sat, 08 Apr 2023 07:20:21 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s13-20020a92ae0d000000b0030c0dce44b1sm1672815ilh.15.2023.04.08.07.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 07:20:20 -0700 (PDT)
Date:   Sat, 8 Apr 2023 08:20:18 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
Message-ID: <20230408082018.04dcd1e3.alex.williamson@redhat.com>
In-Reply-To: <SN7PR11MB75407463181A0D7A4F21D546C3979@SN7PR11MB7540.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230403090151.4cb2158c.alex.williamson@redhat.com>
        <DS0PR11MB75291E6ED702ADD03AAE023BC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407060335.7babfeb8.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407075155.3ad4c804.alex.williamson@redhat.com>
        <DS0PR11MB7529C1CA38D7D1035869F358C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407091401.1c847419.alex.williamson@redhat.com>
        <DS0PR11MB7529A9D103F88381F84CF390C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407150721.395eabc4.alex.williamson@redhat.com>
        <SN7PR11MB75407463181A0D7A4F21D546C3979@SN7PR11MB7540.namprd11.prod.outlook.com>
Organization: Red Hat
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

On Sat, 8 Apr 2023 05:07:16 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Saturday, April 8, 2023 5:07 AM
> > 
> > On Fri, 7 Apr 2023 15:47:10 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Friday, April 7, 2023 11:14 PM
> > > >
> > > > On Fri, 7 Apr 2023 14:04:02 +0000
> > > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > > >  
> > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > Sent: Friday, April 7, 2023 9:52 PM
> > > > > >
> > > > > > On Fri, 7 Apr 2023 13:24:25 +0000
> > > > > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > > > > >  
> > > > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > > Sent: Friday, April 7, 2023 8:04 PM
> > > > > > > >  
> > > > > > > > > > > > @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct pci_dev  
> > > > *pdev,  
> > > > > > void  
> > > > > > > > > > *data)  
> > > > > > > > > > > >  	if (!iommu_group)
> > > > > > > > > > > >  		return -EPERM; /* Cannot reset non-isolated devices  
> > */  
> > > > > > >
> > > > > > > [1]
> > > > > > >  
> > > > > > > > > > >
> > > > > > > > > > > Hi Alex,
> > > > > > > > > > >
> > > > > > > > > > > Is disabling iommu a sane way to test vfio noiommu mode?  
> > > > > > > > > >
> > > > > > > > > > Yes
> > > > > > > > > >  
> > > > > > > > > > > I added intel_iommu=off to disable intel iommu and bind a device to  
> > vfio-  
> > > > pci.  
> > > > > > > > > > > I can see the /dev/vfio/noiommu-0 and /dev/vfio/devices/noiommu-  
> > vfio0.  
> > > > > > Bind  
> > > > > > > > > > > iommufd==-1 can succeed, but failed to get hot reset info due to the  
> > > > above  
> > > > > > > > > > > group check. Reason is that this happens to have some affected  
> > devices,  
> > > > and  
> > > > > > > > > > > these devices have no valid iommu_group (because they are not  
> > bound to  
> > > > > > vfio-  
> > > > > > > > pci  
> > > > > > > > > > > hence nobody allocates noiommu group for them). So when hot reset  
> > info  
> > > > > > loops  
> > > > > > > > > > > such devices, it failed with -EPERM. Is this expected?  
> > > > > > > > > >
> > > > > > > > > > Hmm, I didn't recall that we put in such a limitation, but given the
> > > > > > > > > > minimally intrusive approach to no-iommu and the fact that we never
> > > > > > > > > > defined an invalid group ID to return to the user, it makes sense that
> > > > > > > > > > we just blocked the ioctl for no-iommu use.  I guess we can do the same
> > > > > > > > > > for no-iommu cdev.  
> > > > > > > > >
> > > > > > > > > I just realize a further issue related to this limitation. Remember that we
> > > > > > > > > may finally compile out the vfio group infrastructure in the future. Say I
> > > > > > > > > want to test noiommu, I may boot such a kernel with iommu disabled. I  
> > think  
> > > > > > > > > the _INFO ioctl would fail as there is no iommu_group. Does it mean we  
> > will  
> > > > > > > > > not support hot reset for noiommu in future if vfio group infrastructure is
> > > > > > > > > compiled out?  
> > > > > > > >
> > > > > > > > We're talking about IOMMU groups, IOMMU groups are always present
> > > > > > > > regardless of whether we expose a vfio group interface to userspace.
> > > > > > > > Remember, we create IOMMU groups even in the no-iommu case.  Even  
> > with  
> > > > > > > > pure cdev, there are underlying IOMMU groups that maintain the DMA
> > > > > > > > ownership.  
> > > > > > >
> > > > > > > hmmm. As [1], when iommu is disabled, there will be no iommu_group for a
> > > > > > > given device unless it is registered to VFIO, which a fake group is created.
> > > > > > > That's why I hit the limitation [1]. When vfio_group is compiled out, then
> > > > > > > even fake group goes away.  
> > > > > >
> > > > > > In the vfio group case, [1] can be hit with no-iommu only when there
> > > > > > are affected devices which are not bound to vfio.  
> > > > >
> > > > > yes. because vfio would allocate fake group when device is registered to
> > > > > it.
> > > > >  
> > > > > > Why are we not
> > > > > > allocating an IOMMU group to no-iommu devices when vfio group is
> > > > > > disabled?  Thanks,  
> > > > >
> > > > > hmmm. when the vfio group code is configured out. The
> > > > > vfio_device_set_group() just returns 0 after below patch is
> > > > > applied and CONFIG_VFIO_GROUP=n. So when there is no
> > > > > vfio group, the fake group also goes away.
> > > > >
> > > > > https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel.com/  
> > > >
> > > > Is this a fundamental issue or just a problem with the current
> > > > implementation proposal?  It seems like the latter.  FWIW, I also don't
> > > > see a taint happening in the cdev path for no-iommu use.  Thanks,  
> > >
> > > yes. the latter case. The reason I raised it here is to confirm the
> > > policy on the new group/bdf capability in the DEVICE_GET_INFO. If
> > > there is no iommu group, perhaps I only need to exclude the new
> > > group/bdf capability from the cap chain of DEVICE_GET_INFO. is it?  
> > 
> > I think we need to revisit the question of why allocating an IOMMU
> > group for a no-iommu device is exclusive to the vfio group support.  
> 
> For no-iommu device, the iommu group is a fake group allocated by vfio.
> is it? And the fake group allocation is part of the vfio group code.
> It is the vfio_device_set_group() in group.c. If vfio group code is not
> compiled in, vfio does not allocate fake groups. Detail for this compiling
> can be found in link [1].
> 
> > We've already been down the path of trying to report a field that only
> > exists for devices with certain properties with dev-id.  It doesn't
> > work well.  I think we've said all along that while the cdev interface
> > is device based, there are still going to be underlying IOMMU groups
> > for the user to be aware of, they're just not as much a fundamental
> > part of the interface.  There should not be a case where a device
> > doesn't have a group to report.  Thanks,  
> 
> As the patch in link [1] makes vfio group optional, so if compile a kernel
> with CONFIG_VFIO_GROUP=n, and boot it with iommu disabled, then there is no
> group to report. Perhaps this is not a typical usage but still a sane usage
> for noiommu mode as I confirmed with you in this thread. So when it comes,
> needs to consider what to report for the group field.
> 
> Perhaps I messed up the discussion by referring to a patch that is part of
> another series. But I think it should be considered when talking about the
> group to be reported.

The question is whether the split that group.c code handles both the
vfio group AND creation of the IOMMU group in such cases is the correct
split.  I'm not arguing that the way the code is currently laid out has
the fake IOMMU group for no-iommu devices created in vfio group
specific code, but we have a common interface that makes use of IOMMU
group information for which we don't have an equivalent alternative
data field to report.

We've shown that dev-id doesn't work here because dev-ids only exist
for devices within the user's IOMMU context.  Also reporting an invalid
ID of any sort fails to indicate the potential implied ownership.
Therefore I recognize that if this interface is to report an IOMMU
group, then the creation of fake IOMMU groups existing only in vfio
group code would need to be refactored.  Thanks,

Alex

