Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9416DBFFF
	for <lists+kvm@lfdr.de>; Sun,  9 Apr 2023 15:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjDINap (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Apr 2023 09:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDINan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Apr 2023 09:30:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA3A3A9A
        for <kvm@vger.kernel.org>; Sun,  9 Apr 2023 06:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681046996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Bq1nCo2uzlf7ONPT962ojuNI8nu31GYm0qBMd4gwlY=;
        b=MTDT8/9aO9R74ucKvS7ZS7XP7+GLHC9aw+3+z6lfpI+z8x33u4rJjlzvziii5N3+E48lx8
        FXDwImdFuYb94N3/sS0JtP7bLa/OAPHbsxtKhZTsC7QJmNi3VBFClw6y45E/sYFWRHOSJ1
        zobpTmx32YE/79ndS5vQNC3ELB6a9S0=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-GbL_DlyuNBaasoLAwM45ZQ-1; Sun, 09 Apr 2023 09:29:54 -0400
X-MC-Unique: GbL_DlyuNBaasoLAwM45ZQ-1
Received: by mail-il1-f197.google.com with SMTP id n14-20020a056e02140e00b003259a56715bso2346254ilo.15
        for <kvm@vger.kernel.org>; Sun, 09 Apr 2023 06:29:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681046994; x=1683638994;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Bq1nCo2uzlf7ONPT962ojuNI8nu31GYm0qBMd4gwlY=;
        b=FqKEWl8xd+qi0zX/nPnX6UGOuFPYCnAOsL5xDQ8RRNjhLDYPjPICF2yB3m/OBtSex+
         J3r/xph32E960TB1fwhWoSUWhV7zVqXhb5S5t1CrzQKaHui+c02lRmvUpek+YLsck0Bt
         oof14HWC0kaw1JqQqwyoicNT80HS1s3KFgc8k8UFdkA9Lvsd91TLzV+eDYWXRN+0sQ/i
         bck2AT1HoNXRe1/vWsXMWGbPDGFCb8/ngiyglmCFkWRur02nvueb5Q8Kb5R13NlIJUKd
         RamR5Wip0zqqMZcXqMMUkNkNEbPAG4tqBzVu0tv+uhG/nEDXrhvIe8aoYY0C/tD/FPrX
         RIjA==
X-Gm-Message-State: AAQBX9cap3CPiedaI+eyhXGu0y1R45S3KNRV2ezuntby0xiXnREPsTF6
        w0KHCai0T27APrmvWEbZHQd3QQ/cCDJALfAz5PCH7QKlZybKKdgqGsYpv3mPCR6+mxMbetsqKIu
        bkJ7TV0wwyHqZ
X-Received: by 2002:a5e:8809:0:b0:74c:8b56:42bb with SMTP id l9-20020a5e8809000000b0074c8b5642bbmr4560157ioj.8.1681046993685;
        Sun, 09 Apr 2023 06:29:53 -0700 (PDT)
X-Google-Smtp-Source: AKy350YJ0qrgM7M+MbMuHoCCOrJeRM9wUmVuPROC4iykvLcAJsJnYWn/0UyGq9/cBzihanZpy7nabQ==
X-Received: by 2002:a5e:8809:0:b0:74c:8b56:42bb with SMTP id l9-20020a5e8809000000b0074c8b5642bbmr4560143ioj.8.1681046993392;
        Sun, 09 Apr 2023 06:29:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w9-20020a6b4a09000000b007596db3874dsm2327622iob.35.2023.04.09.06.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Apr 2023 06:29:52 -0700 (PDT)
Date:   Sun, 9 Apr 2023 07:29:51 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
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
Message-ID: <20230409072951.629af3a7.alex.williamson@redhat.com>
In-Reply-To: <81a3e148-89de-e399-fefa-0785dac75f85@intel.com>
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
        <20230408082018.04dcd1e3.alex.williamson@redhat.com>
        <81a3e148-89de-e399-fefa-0785dac75f85@intel.com>
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

On Sun, 9 Apr 2023 19:58:47 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> On 2023/4/8 22:20, Alex Williamson wrote:
> > On Sat, 8 Apr 2023 05:07:16 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> >>> From: Alex Williamson <alex.williamson@redhat.com>
> >>> Sent: Saturday, April 8, 2023 5:07 AM
> >>>
> >>> On Fri, 7 Apr 2023 15:47:10 +0000
> >>> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >>>      
> >>>>> From: Alex Williamson <alex.williamson@redhat.com>
> >>>>> Sent: Friday, April 7, 2023 11:14 PM
> >>>>>
> >>>>> On Fri, 7 Apr 2023 14:04:02 +0000
> >>>>> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >>>>>     
> >>>>>>> From: Alex Williamson <alex.williamson@redhat.com>
> >>>>>>> Sent: Friday, April 7, 2023 9:52 PM
> >>>>>>>
> >>>>>>> On Fri, 7 Apr 2023 13:24:25 +0000
> >>>>>>> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >>>>>>>     
> >>>>>>>>> From: Alex Williamson <alex.williamson@redhat.com>
> >>>>>>>>> Sent: Friday, April 7, 2023 8:04 PM
> >>>>>>>>>     
> >>>>>>>>>>>>> @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct pci_dev  
> >>>>> *pdev,  
> >>>>>>> void  
> >>>>>>>>>>> *data)  
> >>>>>>>>>>>>>   	if (!iommu_group)
> >>>>>>>>>>>>>   		return -EPERM; /* Cannot reset non-isolated devices  
> >>> */  
> >>>>>>>>
> >>>>>>>> [1]
> >>>>>>>>     
> >>>>>>>>>>>>
> >>>>>>>>>>>> Hi Alex,
> >>>>>>>>>>>>
> >>>>>>>>>>>> Is disabling iommu a sane way to test vfio noiommu mode?  
> >>>>>>>>>>>
> >>>>>>>>>>> Yes
> >>>>>>>>>>>     
> >>>>>>>>>>>> I added intel_iommu=off to disable intel iommu and bind a device to  
> >>> vfio-  
> >>>>> pci.  
> >>>>>>>>>>>> I can see the /dev/vfio/noiommu-0 and /dev/vfio/devices/noiommu-  
> >>> vfio0.  
> >>>>>>> Bind  
> >>>>>>>>>>>> iommufd==-1 can succeed, but failed to get hot reset info due to the  
> >>>>> above  
> >>>>>>>>>>>> group check. Reason is that this happens to have some affected  
> >>> devices,  
> >>>>> and  
> >>>>>>>>>>>> these devices have no valid iommu_group (because they are not  
> >>> bound to  
> >>>>>>> vfio-  
> >>>>>>>>> pci  
> >>>>>>>>>>>> hence nobody allocates noiommu group for them). So when hot reset  
> >>> info  
> >>>>>>> loops  
> >>>>>>>>>>>> such devices, it failed with -EPERM. Is this expected?  
> >>>>>>>>>>>
> >>>>>>>>>>> Hmm, I didn't recall that we put in such a limitation, but given the
> >>>>>>>>>>> minimally intrusive approach to no-iommu and the fact that we never
> >>>>>>>>>>> defined an invalid group ID to return to the user, it makes sense that
> >>>>>>>>>>> we just blocked the ioctl for no-iommu use.  I guess we can do the same
> >>>>>>>>>>> for no-iommu cdev.  
> >>>>>>>>>>
> >>>>>>>>>> I just realize a further issue related to this limitation. Remember that we
> >>>>>>>>>> may finally compile out the vfio group infrastructure in the future. Say I
> >>>>>>>>>> want to test noiommu, I may boot such a kernel with iommu disabled. I  
> >>> think  
> >>>>>>>>>> the _INFO ioctl would fail as there is no iommu_group. Does it mean we  
> >>> will  
> >>>>>>>>>> not support hot reset for noiommu in future if vfio group infrastructure is
> >>>>>>>>>> compiled out?  
> >>>>>>>>>
> >>>>>>>>> We're talking about IOMMU groups, IOMMU groups are always present
> >>>>>>>>> regardless of whether we expose a vfio group interface to userspace.
> >>>>>>>>> Remember, we create IOMMU groups even in the no-iommu case.  Even  
> >>> with  
> >>>>>>>>> pure cdev, there are underlying IOMMU groups that maintain the DMA
> >>>>>>>>> ownership.  
> >>>>>>>>
> >>>>>>>> hmmm. As [1], when iommu is disabled, there will be no iommu_group for a
> >>>>>>>> given device unless it is registered to VFIO, which a fake group is created.
> >>>>>>>> That's why I hit the limitation [1]. When vfio_group is compiled out, then
> >>>>>>>> even fake group goes away.  
> >>>>>>>
> >>>>>>> In the vfio group case, [1] can be hit with no-iommu only when there
> >>>>>>> are affected devices which are not bound to vfio.  
> >>>>>>
> >>>>>> yes. because vfio would allocate fake group when device is registered to
> >>>>>> it.
> >>>>>>     
> >>>>>>> Why are we not
> >>>>>>> allocating an IOMMU group to no-iommu devices when vfio group is
> >>>>>>> disabled?  Thanks,  
> >>>>>>
> >>>>>> hmmm. when the vfio group code is configured out. The
> >>>>>> vfio_device_set_group() just returns 0 after below patch is
> >>>>>> applied and CONFIG_VFIO_GROUP=n. So when there is no
> >>>>>> vfio group, the fake group also goes away.
> >>>>>>
> >>>>>> https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel.com/  
> >>>>>
> >>>>> Is this a fundamental issue or just a problem with the current
> >>>>> implementation proposal?  It seems like the latter.  FWIW, I also don't
> >>>>> see a taint happening in the cdev path for no-iommu use.  Thanks,  
> >>>>
> >>>> yes. the latter case. The reason I raised it here is to confirm the
> >>>> policy on the new group/bdf capability in the DEVICE_GET_INFO. If
> >>>> there is no iommu group, perhaps I only need to exclude the new
> >>>> group/bdf capability from the cap chain of DEVICE_GET_INFO. is it?  
> >>>
> >>> I think we need to revisit the question of why allocating an IOMMU
> >>> group for a no-iommu device is exclusive to the vfio group support.  
> >>
> >> For no-iommu device, the iommu group is a fake group allocated by vfio.
> >> is it? And the fake group allocation is part of the vfio group code.
> >> It is the vfio_device_set_group() in group.c. If vfio group code is not
> >> compiled in, vfio does not allocate fake groups. Detail for this compiling
> >> can be found in link [1].
> >>  
> >>> We've already been down the path of trying to report a field that only
> >>> exists for devices with certain properties with dev-id.  It doesn't
> >>> work well.  I think we've said all along that while the cdev interface
> >>> is device based, there are still going to be underlying IOMMU groups
> >>> for the user to be aware of, they're just not as much a fundamental
> >>> part of the interface.  There should not be a case where a device
> >>> doesn't have a group to report.  Thanks,  
> >>
> >> As the patch in link [1] makes vfio group optional, so if compile a kernel
> >> with CONFIG_VFIO_GROUP=n, and boot it with iommu disabled, then there is no
> >> group to report. Perhaps this is not a typical usage but still a sane usage
> >> for noiommu mode as I confirmed with you in this thread. So when it comes,
> >> needs to consider what to report for the group field.
> >>
> >> Perhaps I messed up the discussion by referring to a patch that is part of
> >> another series. But I think it should be considered when talking about the
> >> group to be reported.  
> > 
> > The question is whether the split that group.c code handles both the
> > vfio group AND creation of the IOMMU group in such cases is the correct
> > split.  I'm not arguing that the way the code is currently laid out has
> > the fake IOMMU group for no-iommu devices created in vfio group
> > specific code, but we have a common interface that makes use of IOMMU
> > group information for which we don't have an equivalent alternative
> > data field to report.  
> 
> yes. It is needed to ensure _HOT_RESET_INFO workable for noiommu devices.
> 
> > We've shown that dev-id doesn't work here because dev-ids only exist
> > for devices within the user's IOMMU context.  Also reporting an invalid
> > ID of any sort fails to indicate the potential implied ownership.
> > Therefore I recognize that if this interface is to report an IOMMU
> > group, then the creation of fake IOMMU groups existing only in vfio
> > group code would need to be refactored.  Thanks,  
> 
> yeah, needs to move the iommu group creation back to vfio_main.c. This
> would be a prerequisite for [1]
> 
> [1] https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel.com/
> 
> I'll also try out your suggestion to add a capability like below and link
> it in the vfio_device_info cap chain.
> 
> #define VFIO_DEVICE_INFO_CAP_PCI_BDF          5
> 
> struct vfio_device_info_cap_pci_bdf {
>          struct vfio_info_cap_header header;
>          __u32   group_id;
>          __u16   segment;
>          __u8    bus;
>          __u8    devfn; /* Use PCI_SLOT/PCI_FUNC */
> };
> 

Group-id and bdf should be separate capabilities, all device should
report a group-id capability and only PCI devices a bdf capability.
Thanks,

Alex

