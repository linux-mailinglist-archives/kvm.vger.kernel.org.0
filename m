Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDE96DAF80
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 17:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbjDGPPJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 11:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240812AbjDGPO4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 11:14:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179FA44BC
        for <kvm@vger.kernel.org>; Fri,  7 Apr 2023 08:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680880447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iXAPNdBJMnoHbxVht9yPga+A2CeJtiyrlF4HM2aW+j0=;
        b=dDPNHZDfdeyB062/uyMr6aoaGBYNaZqftMM32GwZZzIhO0DJCsmhhoiL+Q2+dwxYjpHz71
        yTQ0qR9V0VvHr+ZckSL368//Xc/To9G07pgdSIyd9BZlM2Tqd8Qqk62QaA4fs7v8r1tw8e
        SAzxv2/Wc1Rz0ZKihpMJhDdc1St/WPQ=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-ck1PBKwgNQSXWSs2-cZfkA-1; Fri, 07 Apr 2023 11:14:06 -0400
X-MC-Unique: ck1PBKwgNQSXWSs2-cZfkA-1
Received: by mail-il1-f200.google.com with SMTP id s6-20020a056e02216600b003264c778ef1so14869846ilv.23
        for <kvm@vger.kernel.org>; Fri, 07 Apr 2023 08:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680880445; x=1683472445;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iXAPNdBJMnoHbxVht9yPga+A2CeJtiyrlF4HM2aW+j0=;
        b=lsU5404FbsnhO9BwgGY3mLtykFk05/C9GilDMf7oIEpxfjatQzGqLz4mDQeqm0sxx4
         hTBQJdXBdVdpoVWdnt1+QKM9yE3LFgllzk/udJJl5MpDOG2UCvBvmfi4/PH949lihbs9
         v8RBf5rLe9yHM6F7eKz9NuZaaC4R9X83vXpuZE0iAp3+pgP8SWXSC3wpxsGi+o76CZYc
         Q0FG/4I5itgSwmCZ2qUurY2+MCqniSUaS0FEUOfZ3KCYCjtcuQW5hDaeuy0LPGZn1kTs
         VSlUKNQdla0P31fYjYY3xVO1WxSMcDPBtCPx+9p6x6hez9Iis4Kk/7cKgLDfHPWMucnX
         RTjQ==
X-Gm-Message-State: AAQBX9fjAXcdOdOrLAqva7Jbk0ztj+wwPqP0fnM6PZqvgy8nZ11FEPf1
        PDSLtonjP59BRBkS+9WOkdkj1YTyehANStV9aAyot7P5Ff+ovHQSgiVsenRS52nxZjCqNOXktx5
        04OMlCYW2NBMG
X-Received: by 2002:a6b:e611:0:b0:74c:9235:8753 with SMTP id g17-20020a6be611000000b0074c92358753mr2519768ioh.13.1680880445446;
        Fri, 07 Apr 2023 08:14:05 -0700 (PDT)
X-Google-Smtp-Source: AKy350YEpVoORZpa6d3nNLDs1r1CtYmaffUAedkEJ1EC3FuUQNNUjaJPIAYHNqBk5PYwGJ72oUes6w==
X-Received: by 2002:a6b:e611:0:b0:74c:9235:8753 with SMTP id g17-20020a6be611000000b0074c92358753mr2519746ioh.13.1680880445186;
        Fri, 07 Apr 2023 08:14:05 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b004061ac1ddd1sm1174890jad.169.2023.04.07.08.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Apr 2023 08:14:04 -0700 (PDT)
Date:   Fri, 7 Apr 2023 09:14:01 -0600
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
Message-ID: <20230407091401.1c847419.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB7529C1CA38D7D1035869F358C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-13-yi.l.liu@intel.com>
        <DS0PR11MB752996A6E6B3263BAD01DAC2C3929@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230403090151.4cb2158c.alex.williamson@redhat.com>
        <DS0PR11MB75291E6ED702ADD03AAE023BC3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407060335.7babfeb8.alex.williamson@redhat.com>
        <DS0PR11MB7529B0A91FF97C078BEA3783C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230407075155.3ad4c804.alex.williamson@redhat.com>
        <DS0PR11MB7529C1CA38D7D1035869F358C3969@DS0PR11MB7529.namprd11.prod.outlook.com>
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

On Fri, 7 Apr 2023 14:04:02 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, April 7, 2023 9:52 PM
> > 
> > On Fri, 7 Apr 2023 13:24:25 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Friday, April 7, 2023 8:04 PM
> > > >  
> > > > > > > > @@ -791,7 +813,21 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev,  
> > void  
> > > > > > *data)  
> > > > > > > >  	if (!iommu_group)
> > > > > > > >  		return -EPERM; /* Cannot reset non-isolated devices */  
> > >
> > > [1]
> > >  
> > > > > > >
> > > > > > > Hi Alex,
> > > > > > >
> > > > > > > Is disabling iommu a sane way to test vfio noiommu mode?  
> > > > > >
> > > > > > Yes
> > > > > >  
> > > > > > > I added intel_iommu=off to disable intel iommu and bind a device to vfio-pci.
> > > > > > > I can see the /dev/vfio/noiommu-0 and /dev/vfio/devices/noiommu-vfio0.  
> > Bind  
> > > > > > > iommufd==-1 can succeed, but failed to get hot reset info due to the above
> > > > > > > group check. Reason is that this happens to have some affected devices, and
> > > > > > > these devices have no valid iommu_group (because they are not bound to  
> > vfio-  
> > > > pci  
> > > > > > > hence nobody allocates noiommu group for them). So when hot reset info  
> > loops  
> > > > > > > such devices, it failed with -EPERM. Is this expected?  
> > > > > >
> > > > > > Hmm, I didn't recall that we put in such a limitation, but given the
> > > > > > minimally intrusive approach to no-iommu and the fact that we never
> > > > > > defined an invalid group ID to return to the user, it makes sense that
> > > > > > we just blocked the ioctl for no-iommu use.  I guess we can do the same
> > > > > > for no-iommu cdev.  
> > > > >
> > > > > I just realize a further issue related to this limitation. Remember that we
> > > > > may finally compile out the vfio group infrastructure in the future. Say I
> > > > > want to test noiommu, I may boot such a kernel with iommu disabled. I think
> > > > > the _INFO ioctl would fail as there is no iommu_group. Does it mean we will
> > > > > not support hot reset for noiommu in future if vfio group infrastructure is
> > > > > compiled out?  
> > > >
> > > > We're talking about IOMMU groups, IOMMU groups are always present
> > > > regardless of whether we expose a vfio group interface to userspace.
> > > > Remember, we create IOMMU groups even in the no-iommu case.  Even with
> > > > pure cdev, there are underlying IOMMU groups that maintain the DMA
> > > > ownership.  
> > >
> > > hmmm. As [1], when iommu is disabled, there will be no iommu_group for a
> > > given device unless it is registered to VFIO, which a fake group is created.
> > > That's why I hit the limitation [1]. When vfio_group is compiled out, then
> > > even fake group goes away.  
> > 
> > In the vfio group case, [1] can be hit with no-iommu only when there
> > are affected devices which are not bound to vfio.  
> 
> yes. because vfio would allocate fake group when device is registered to
> it.
> 
> > Why are we not
> > allocating an IOMMU group to no-iommu devices when vfio group is
> > disabled?  Thanks,  
> 
> hmmm. when the vfio group code is configured out. The
> vfio_device_set_group() just returns 0 after below patch is
> applied and CONFIG_VFIO_GROUP=n. So when there is no
> vfio group, the fake group also goes away.
> 
> https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel.com/

Is this a fundamental issue or just a problem with the current
implementation proposal?  It seems like the latter.  FWIW, I also don't
see a taint happening in the cdev path for no-iommu use.  Thanks,

Alex

