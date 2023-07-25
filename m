Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB5A7620CE
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 20:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbjGYSBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 14:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjGYSBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 14:01:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943A91BE
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 11:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690308015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xe7YC8PFiFz0x9zHH/WNZAVHTrl6dN5xMKZiMTBXnw4=;
        b=jNf2IrBFblPV09EyBv1wb5OBFkqa0BRYRG2TB1oojO0bNtz5eA04DaykusqznxKG1Na95B
        9h3X5D4xbjDcE5YwhUY0y4It816+gSqvxef100iaCRRAuoKcpx6pzVcMklWyVTaqVibY+C
        JOUPPwqDZAlmqrpTlce0IxgE7qKMpzY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-F6pUP6_QPIeG5DachHZZ8g-1; Tue, 25 Jul 2023 14:00:13 -0400
X-MC-Unique: F6pUP6_QPIeG5DachHZZ8g-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7873f24e7edso396372439f.3
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 11:00:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690308012; x=1690912812;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xe7YC8PFiFz0x9zHH/WNZAVHTrl6dN5xMKZiMTBXnw4=;
        b=jHwlwUzKojgbCxFWShH+wraAQgHmmX1ao+1YZAiyUSap4qv0d4ZV3414NG7iTG8ueK
         +T+72n+cwwF8lSVLIh1KiOBMu5eFElRm+8HIef/rKjw0e9Sp2txhpRsFTkc92eQ3TFq1
         ZF1kVUUPLaLJD9QE8HN2z3DYS3d5TWol8s5JEnkSyiQtwvLTX7/ElAtCRApYFULnjGsz
         fOMWvqckILiXbbCSbIdREtoKY6nmqzZ8KF5DDnlhF2ZkgYFYPtzUM+DN6d5NRxb6xcRX
         ALzVO7Db1WOgKDxngNSDA+sbeEM43Q5j0ljuRD1TistYrn5gKb2UzOHmSUeH95jwwscI
         EH4g==
X-Gm-Message-State: ABy/qLbB0Icr6DQfSKzPxA9AjsX8AX7W/wc41zOJOpdp9U5YKz22BJRo
        VKk5ePfIdqKUVpkavxKDSmWbO4hiFFWp6DTbV2e25Git3JQnKwxCKsB4Mpa2FfaW3zaN/TgI1jv
        bW4met7nDnMG2
X-Received: by 2002:a05:6602:2152:b0:783:39e9:e05c with SMTP id y18-20020a056602215200b0078339e9e05cmr4017863ioy.19.1690308012385;
        Tue, 25 Jul 2023 11:00:12 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEswRuWsSRte35iym9JYqbkB3ZMjf8sbcpiuOxEhMW7ciOh8iPue7ZHMMRIzwaONt5+B6ZTvQ==
X-Received: by 2002:a05:6602:2152:b0:783:39e9:e05c with SMTP id y18-20020a056602215200b0078339e9e05cmr4017834ioy.19.1690308012106;
        Tue, 25 Jul 2023 11:00:12 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id j13-20020a5e9e4d000000b0078bb0ff8a33sm2828643ioq.44.2023.07.25.11.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 11:00:11 -0700 (PDT)
Date:   Tue, 25 Jul 2023 12:00:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yi Liu <yi.l.liu@intel.com>, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v15 00/26] Add vfio_device cdev for iommufd support
Message-ID: <20230725120009.2ff17e77.alex.williamson@redhat.com>
In-Reply-To: <20230724130922.5bf567ef.alex.williamson@redhat.com>
References: <20230718135551.6592-1-yi.l.liu@intel.com>
        <ZLbEigQvwSZFiCqv@nvidia.com>
        <20230724130922.5bf567ef.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jul 2023 13:09:22 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 18 Jul 2023 13:57:46 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Jul 18, 2023 at 06:55:25AM -0700, Yi Liu wrote:  
> > > Existing VFIO provides group-centric user APIs for userspace. Userspace
> > > opens the /dev/vfio/$group_id first before getting device fd and hence
> > > getting access to device. This is not the desired model for iommufd. Per
> > > the conclusion of community discussion[1], iommufd provides device-centric
> > > kAPIs and requires its consumer (like VFIO) to be device-centric user
> > > APIs. Such user APIs are used to associate device with iommufd and also
> > > the I/O address spaces managed by the iommufd.
> > > 
> > > This series first introduces a per device file structure to be prepared
> > > for further enhancement and refactors the kvm-vfio code to be prepared
> > > for accepting device file from userspace. After this, adds a mechanism for
> > > blocking device access before iommufd bind. Then refactors the vfio to be
> > > able to handle cdev paths (e.g. iommufd binding, no-iommufd, [de]attach ioas).
> > > This refactor includes making the device_open exclusive between the group
> > > and the cdev path, only allow single device open in cdev path; vfio-iommufd
> > > code is also refactored to support cdev. e.g. split the vfio_iommufd_bind()
> > > into two steps. Eventually, adds the cdev support for vfio device and the
> > > new ioctls, then makes group infrastructure optional as it is not needed
> > > when vfio device cdev is compiled.
> > > 
> > > This series is based on some preparation works done to vfio emulated devices[2]
> > > and vfio pci hot reset enhancements[3]. Per discussion[4], this series does not
> > > support cdev for physical devices that do not have IOMMU. Such devices only
> > > have group-centric user APIs.
> > > 
> > > This series is a prerequisite for iommu nesting for vfio device[5] [6].
> > > 
> > > The complete code can be found in below branch, simple tests done to the
> > > legacy group path and the cdev path. QEMU changes are in upstreaming[7]
> > > and the complete code can be found at[8]
> > > 
> > > https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v15
> > > (config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)    
> > 
> > Alex, if you are still good with this lets make this into a shared
> > branch, do you want to do it or would you like a PR from me?  
> 
> Sorry, was out much of last week.  Yes, my intent would be to put this
> both in a shared branch and my next branch for v6.6.  Given this is
> mostly vfio, it seems like it'd make sense for me to provide that
> branch but I may not get to it until tomorrow.  Thanks,

Both series are applied to my next branch for v6.6 and I've also
published them to the v6.6/vfio/cdev branch[1].  Thanks for all the
work and collaboration on this effort!

Alex

[1]https://github.com/awilliam/linux-vfio/tree/v6.6/vfio/cdev

