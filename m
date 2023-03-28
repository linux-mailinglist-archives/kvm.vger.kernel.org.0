Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00996CC604
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 17:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233172AbjC1PWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 11:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbjC1PVo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 11:21:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EF911EAA
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 08:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680016688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8aHNtdN3xOBjSLsYW0pKjqjlT/tHgtXNulTCwMmSCPc=;
        b=HaPoSUUFExaQtNEKdFaE/jKiI2dgNXpEkVtXotdyBAeJJ7rRXa3OuCJqufNBvVlDv37dRR
        ShPXDspNpog3nI0gcgYm0UR1KJcFfd4tmH0eKtUrPkh9XAjVSNJrS1AEVO0b3z0CszDffM
        lxlhVhg7kYjsx+t7YyVPQJuyYbOgk1Q=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-1dEfEAVLMBu6caGCFBiDFQ-1; Tue, 28 Mar 2023 11:18:05 -0400
X-MC-Unique: 1dEfEAVLMBu6caGCFBiDFQ-1
Received: by mail-il1-f200.google.com with SMTP id i17-20020a056e020d9100b00325a80f683cso8461099ilj.22
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 08:18:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680016684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8aHNtdN3xOBjSLsYW0pKjqjlT/tHgtXNulTCwMmSCPc=;
        b=gWzPGwjQJ6VEB2P1wW1ANbi68zOEMo9stNV/TMC7VcImUrb5o9TzxXQfQJrx1llYl2
         Z7lYA8NoGg8bH54ozaDUqq4nbKnCDPWB0V/uPGL0MRp4vaYt1h2NhCxW7bzXKpWVC2MD
         HS0soPfrd61sWlG85P09PxBRVbvjQ1iZ3ecwWWmCsHHM0bgF7FIUCSIWUXkfbWjQVTU3
         zL+WzLXY8X8Q5bpYbME53k57Vl1sUszREBPMVl0jUHSLbVDeOOSJ4lSdCJVBBpS441bD
         6HLGadQDVELLh2xOrvtvC1BwxtiXdWcUcUI5bSZh4AA64CIyK/YtptZzjMiwx1Cbvca6
         lVMg==
X-Gm-Message-State: AAQBX9c/XCd7+RBSaob5Gx9VoriwaEU7YHStpCavyvfbQ0kMMwcz5oBm
        dq2VUw0WZ3HcCjYCkoTsDrSpZl64ncX4NBYc+7PP1cdJkuwpsiOSwv5g68iUop9G7ta87QD5bEw
        OrfY0OZaPt0HN
X-Received: by 2002:a6b:da05:0:b0:759:a25a:c755 with SMTP id x5-20020a6bda05000000b00759a25ac755mr8952320iob.1.1680016684115;
        Tue, 28 Mar 2023 08:18:04 -0700 (PDT)
X-Google-Smtp-Source: AKy350aN8ZM2wmhpLeVJtFeYE+wqSODaZHpb3sItJCHR/Izm2p4L8ccW4suBjQV4LD54yIjD5L2d6Q==
X-Received: by 2002:a6b:da05:0:b0:759:a25a:c755 with SMTP id x5-20020a6bda05000000b00759a25ac755mr8952301iob.1.1680016683889;
        Tue, 28 Mar 2023 08:18:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a25-20020a027359000000b0039c492ae300sm9669718jae.114.2023.03.28.08.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 08:18:03 -0700 (PDT)
Date:   Tue, 28 Mar 2023 09:18:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
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
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <20230328091801.13de042a.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
        <20230327093458.44939-11-yi.l.liu@intel.com>
        <20230327132619.5ab15440.alex.williamson@redhat.com>
        <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
        <20230328082536.5400da67.alex.williamson@redhat.com>
        <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230328084616.3361a293.alex.williamson@redhat.com>
        <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
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

On Tue, 28 Mar 2023 15:00:42 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, March 28, 2023 10:46 PM
> > 
> > On Tue, 28 Mar 2023 14:38:12 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Tuesday, March 28, 2023 10:26 PM
> > > >
> > > > On Tue, 28 Mar 2023 06:19:06 +0000
> > > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > > >  
> > > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > Sent: Tuesday, March 28, 2023 11:32 AM
> > > > > >  
> > > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > Sent: Tuesday, March 28, 2023 3:26 AM
> > > > > > >
> > > > > > > Additionally, VFIO_DEVICE_GET_PCI_HOT_RESET_INFO has a flags  
> > arg  
> > > > that  
> > > > > > > isn't used, why do we need a new ioctl vs defining
> > > > > > > VFIO_PCI_HOT_RESET_FLAG_IOMMUFD_DEV_ID.  
> > > > > >
> > > > > > Sure. I can follow this suggestion. BTW. I have a doubt here. This  
> > new  
> > > > flag  
> > > > > > is set by user. What if in the future kernel has new extensions and  
> > needs  
> > > > > > to report something new to the user and add new flags to tell user?  
> > Such  
> > > > > > flag is set by kernel. Then the flags field may have two kinds of flags  
> > > > (some  
> > > > > > set by user while some set by kernel). Will it mess up the flags space?
> > > > > >  
> > > > >
> > > > > flags in a GET_INFO ioctl is for output.
> > > > >
> > > > > if user needs to use flags as input to select different type of info then it  
> > > > should  
> > > > > be split into multiple GET_INFO cmds.  
> > > >
> > > > I don't know that that's actually a rule, however we don't currently
> > > > test flags is zero for input, so in this case I think we are stuck with
> > > > it only being for output.
> > > >
> > > > Alternatively, should VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
> > > > automatically
> > > > return the dev_id variant of the output and set a flag to indicate this
> > > > is the case when called on a device fd opened as a cdev?  Thanks,  
> > >
> > > Personally I prefer that user asks for dev_id info explicitly. The major  
> > reason  
> > > that we return dev_id is that the group/bdf info is not enough for the  
> > device  
> > > fd passing case. But if qemu opens device by itself, the group/bdf info is  
> > still  
> > > enough. So a device opened as a cdev doesn't mean it should return  
> > dev_id,  
> > > it depends on if user has the bdf knowledge.  
> > 
> > But if QEMU opens the cdev, vs getting it from the group, does it make
> > any sense to return a set of group-ids + bdf in the host-reset info?
> > I'm inclined to think the answer is no.
> > 
> > Per my previous suggestion, I think we should always return the bdf. We
> > can't know if the user is accessing through an fd they opened
> > themselves or were passed,  
> 
> Oh, yes. I'm convinced by this reason since only cdev mode supports device fd
> passing. So I'll reuse the existing _INFO and let kernel set a flag to mark the returned
> info is dev_id+bdf.
> 
> A check. If the device that the _INFIO is invoked is opened via cdev, but there
> are devices in the dev_set that are got via VFIO_GROUP_GET_DEVICE_FD, should
> I fail it or allow it?

It's a niche case, but I think it needs to be allowed.  We'd still
report the bdf for those devices, but make use of the invalid/null
dev-id.  I think this empowers userspace that they could make the same
call on a group opened fd if necessary.  An alternative would be to
redefine the returned data structure entirely with a flag per entry
describing the output, but then I think we need to invent a kernel
policy of which gets reported, which seems overly complicated if our
goal is to phase out group usage.  Make sense, or will this bite us?
Thanks,

Alex

