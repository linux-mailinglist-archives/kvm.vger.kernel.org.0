Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06B16DC866
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 17:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDJPX4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 11:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjDJPXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 11:23:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD83430F4
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 08:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681140186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rCgDEUmv/CjkscGtysIfI5mrBVbUfE93OLHcbjWui/4=;
        b=AErf1BBGiJjglD+uGliPN+uWFdXK9PPKXDgmck57YNm/fRjeRj8qC4DahKMEPdzpy03Yg2
        7uaUp4PH1qfQTt4cZMtNyl1sWE7F5+GqoTlMe7IwMmzN6mvMcNDXAOjxwIu7kI+ozdIKtU
        wEGj2yQCrbOR5KgTz63fsWQMeBKtA1g=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-X5hN7pr0NKmtAI-0ah-5yg-1; Mon, 10 Apr 2023 11:23:05 -0400
X-MC-Unique: X5hN7pr0NKmtAI-0ah-5yg-1
Received: by mail-il1-f197.google.com with SMTP id d15-20020a056e020bef00b00325e125fbe5so3934880ilu.12
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 08:23:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681140184; x=1683732184;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rCgDEUmv/CjkscGtysIfI5mrBVbUfE93OLHcbjWui/4=;
        b=uvZOIwGpcPSsx2+jWEKIY7GqAban11tcZ8F8Tvf3ZuYk1a8nE3A9vEAKkGWIOdEtGB
         N4Qi8A8abUVm3uQjhKGCLESeBOSuzL+0mbZGLJiZRlH+2bHEyh5p4GgisZSKdH4RHssc
         sqqRYhf/B3hz/EO46ayc6STQ8rvDNuqC3c11/qTt3Q7bIjTiqq7gsSk1AAp+y7TgK20n
         PY4svHfIdUIUPQ35S3cVzS3eSDz6vAyg+RWxvLsfe93RBkJTIxMVaXhC0uMxlC784nzP
         2WR45j6m4LIco6HE0Efz/46SXeK0jljRa350o2zJro6l4wYwxfhPpCYiXixXQSNj2aXM
         WgdA==
X-Gm-Message-State: AAQBX9dh8GGlVPDAnKe3diQhlOj+zgl6IF+Mjth4C2Y6Hxpcei8Vt7SZ
        qlw2uVb5eLYEY2RrySspRGw2Kzjn3tscdVvm2TJSJUAKODEoI3iUBK+x/NyT41FdRxoDrQRt43x
        LF/Hf1RkuE0Eh
X-Received: by 2002:a92:d749:0:b0:328:c3ae:12be with SMTP id e9-20020a92d749000000b00328c3ae12bemr1720974ilq.13.1681140184471;
        Mon, 10 Apr 2023 08:23:04 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zd8kH3Fim2Wf3jPlRI4rz2SMT25bUANonexe5jW14MxGNkXbo/N1+NeBTSUlUqEjt1czK3RQ==
X-Received: by 2002:a92:d749:0:b0:328:c3ae:12be with SMTP id e9-20020a92d749000000b00328c3ae12bemr1720959ilq.13.1681140184200;
        Mon, 10 Apr 2023 08:23:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s13-20020a92ae0d000000b0030c0dce44b1sm2983450ilh.15.2023.04.10.08.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 08:23:03 -0700 (PDT)
Date:   Mon, 10 Apr 2023 09:23:02 -0600
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
Message-ID: <20230410092302.678d3fb1.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB752938649DE21B96577C2B1CC3959@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
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
        <20230409072951.629af3a7.alex.williamson@redhat.com>
        <DS0PR11MB7529BE00767D7ABC1136BF7CC3959@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230410084115.3c6604f1.alex.williamson@redhat.com>
        <DS0PR11MB752938649DE21B96577C2B1CC3959@DS0PR11MB7529.namprd11.prod.outlook.com>
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

On Mon, 10 Apr 2023 15:18:27 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Monday, April 10, 2023 10:41 PM
> > 
> > On Mon, 10 Apr 2023 08:48:54 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Sunday, April 9, 2023 9:30 PM  
> > > [...]  
> > > > > yeah, needs to move the iommu group creation back to vfio_main.c. This
> > > > > would be a prerequisite for [1]
> > > > >
> > > > > [1] https://lore.kernel.org/kvm/20230401151833.124749-25-yi.l.liu@intel.com/
> > > > >
> > > > > I'll also try out your suggestion to add a capability like below and link
> > > > > it in the vfio_device_info cap chain.
> > > > >
> > > > > #define VFIO_DEVICE_INFO_CAP_PCI_BDF          5
> > > > >
> > > > > struct vfio_device_info_cap_pci_bdf {
> > > > >          struct vfio_info_cap_header header;
> > > > >          __u32   group_id;
> > > > >          __u16   segment;
> > > > >          __u8    bus;
> > > > >          __u8    devfn; /* Use PCI_SLOT/PCI_FUNC */
> > > > > };
> > > > >  
> > > >
> > > > Group-id and bdf should be separate capabilities, all device should
> > > > report a group-id capability and only PCI devices a bdf capability.  
> > >
> > > ok. Since this is to support the device fd passing usage, so we need to
> > > let all the vfio device drivers report group-id capability. is it? So may
> > > have a below helper in vfio_main.c. How about the sample drivers?
> > > seems not necessary for them. right?  
> > 
> > The more common we can make it, the better, but if it ends up that the
> > individual drivers need to initialize the capability then it would
> > probably be limited to those driver with a need to expose the group.  
> 
> looks to be such a case. vfio_device_info is assembled by the individual
> drivers. If want to report group_id capability as a common behavior, needs
> to change all of them. Had a quick draft for it as below commit:
> 
> https://github.com/yiliu1765/iommufd/commit/ff4b8bee90761961041126305183a9a7e0f0542d
> 
> https://github.com/yiliu1765/iommufd/commits/report_group_id
> 
> > Sample drivers for the purpose of illustrating the interface and of
> > course anything based on vfio-pci-core which exposes hot-reset.  Thanks  
> 
> do you see any sample drivers need to report group_id cap? IMHO, seems
> no.

As in the quoted text, part of the purpose of the sample drivers is to
act both as a proof-of-concept and illustration of the API, therefore
gratuitous exposure of such capabilities should be encouraged.  They
would also provide a proof point of an mdev device, ie. emulated IOMMU
device, exposing the capability.  Thanks,

Alex

