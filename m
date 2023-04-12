Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDFB6DFC30
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 19:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjDLRDj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 13:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjDLRDf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 13:03:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FB19EF7
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 10:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681318911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JeneufXpiEYUuGyGZ8Q8ABZcDJsC9i3M9esfSkLThDs=;
        b=RyYzRNgHoio4/OJZNEQ3TOIeduQQj4wsN9JvMylya0QMG0EU3ijS/v+rh2v5tBxkoPtipb
        igFKHUWg3Hdt2ciCnkfZWDj40IJv1lzevVF171AgqOsQGWMiGkhQlkkmL2nQ3iW0yFyWmf
        i7y32rpielT97sznPw0uBmVb3ANBUF8=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-1c7KE2peP5aNbnDvkBszww-1; Wed, 12 Apr 2023 13:01:50 -0400
X-MC-Unique: 1c7KE2peP5aNbnDvkBszww-1
Received: by mail-io1-f69.google.com with SMTP id b190-20020a6bb2c7000000b00760a35f250aso2190342iof.4
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 10:01:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681318910; x=1683910910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JeneufXpiEYUuGyGZ8Q8ABZcDJsC9i3M9esfSkLThDs=;
        b=gU22M3ygzlyllIj/My3IoBpfcwyJZQW+532g2nSK7/xbpjDpKt1viInRVMYX5PyONS
         TWmGyaCK9RQzFzE5+Lzl3wzRH6BI345QHGme43D7qN/xDdi5d6RVW2OO0qPZiYNEqNjj
         6GRbMPelLBCHKxHtEEK/1EfLzG8KwM4p46IACyJ0KujSG3Ov4aRNqtZSbAQJgBt9CQ5S
         wJApGxBuYmL62n+9iqAheXJ+c/6VvxvC0W05M0ckb85PMmuz305faLB/IcXmkliATju0
         Qd7JOwKvnQY6YVslVP03aI02+o5Ka4qdo6YdVRkGNqcGe3I91Xy9mSQ9edcR70pFywGI
         qHkA==
X-Gm-Message-State: AAQBX9f1EsoZpGqk4Ko1ZrHQduL1ikhY9PNUqMujtPHGPyJpdUg3WncN
        bi92Er9why8o8XfOuPqAFt4HxtTLqmr8lsbFqEQM47QLhR0inm1Dnm6v9cRxyQuXsYBEhh8umDM
        /1ZN1mSQvKFez
X-Received: by 2002:a92:ce45:0:b0:317:eef2:f5cc with SMTP id a5-20020a92ce45000000b00317eef2f5ccmr1867118ilr.10.1681318909827;
        Wed, 12 Apr 2023 10:01:49 -0700 (PDT)
X-Google-Smtp-Source: AKy350bmLI/n5FzFmQ15lqziDjlrAa04nLOH96tqFhO3CiJ/t4ZshQUfj7wCR54qShlH2HyBk5wL5Q==
X-Received: by 2002:a92:ce45:0:b0:317:eef2:f5cc with SMTP id a5-20020a92ce45000000b00317eef2f5ccmr1867093ilr.10.1681318909541;
        Wed, 12 Apr 2023 10:01:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a10-20020a5d9eca000000b007587774bec7sm4503807ioe.54.2023.04.12.10.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 10:01:48 -0700 (PDT)
Date:   Wed, 12 Apr 2023 11:01:47 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <20230412110147.5883582b.alex.williamson@redhat.com>
In-Reply-To: <ZDbIzvawep4Sk+0M@nvidia.com>
References: <ZC4CwH2ouTfZ9DNN@nvidia.com>
        <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230406115347.7af28448.alex.williamson@redhat.com>
        <ZDVfqpOCnImKr//m@nvidia.com>
        <20230411095417.240bac39.alex.williamson@redhat.com>
        <20230411111117.0766ad52.alex.williamson@redhat.com>
        <ZDWph7g0hcbJHU1B@nvidia.com>
        <20230411155827.3489400a.alex.williamson@redhat.com>
        <ZDX0wtcvZuS4uxmG@nvidia.com>
        <BN9PR11MB52761A24E435E9EF910766E28C9B9@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDbIzvawep4Sk+0M@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Wed, 12 Apr 2023 12:05:50 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Apr 12, 2023 at 07:27:43AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe
> > > Sent: Wednesday, April 12, 2023 8:01 AM
> > > 
> > > I see this problem as a few basic requirements from a qemu-like
> > > application:
> > > 
> > >  1) Does the configuration I was given support reset right now?
> > >  2) Will the configuration I was given support reset for the duration
> > >     of my execution?
> > >  3) What groups of the devices I already have open does the reset
> > >     effect?
> > >  4) For debugging, report to the user the full list of devices in the
> > >     reset group, in a way that relates back to sysfs.
> > >  5) Away to trigger a reset on a group of devices
> > > 
> > > #1/#2 is the API I suggested here. Ask the kernel if the current
> > > configuration works, and ask it to keep it working.
> > > 
> > > #3 is either INFO and a CAP for BDF or INFO2 reporting dev_id
> > > 
> > > #4 is either INFO and print the BDFs or INFO2 reporting the struct
> > > vfio_device IDR # (eg /sys/class/vfio/vfioXXX/).  
> > 
> > mdev doesn't have BDF. Of course it doesn't support hot_reset either.  
> 
> It should support a reset.. Maybe idxd doesn't, but it should be part
> of the SIOV model. Our SIOV devices would need it for instance.

IIRC we require mdev devices to support VFIO_DEVICE_RESET, hot-reset is
a different beast.  I assume SIOV device support would also require
VFIO_DEVICE_RESET support and hot-reset would also be irrelevant to
them.

> > but it's presented to userspace as a pci device. Is it weird for a pci
> > device which doesn't provide a BDF cap?  
> 
> It is weird for a PCI device, but it is not weird for a VFIO
> device. Leaking the physical labels out of the uAPI is not clean,
> IMHO.
> 
> > from this point the vfio_device IDR# sounds more generic.  
> 
> Yes, I was thinking about this for the SIOV model.

Seems like we're off on a tangent, the hot-reset ioctl is not relevant
to devices simply because they expose a vfio-pci API, there is any
underlying hardware aspect that anything that is only virtualizing a
vfio-pci API shouldn't be concerned with.  Thanks,

Alex

