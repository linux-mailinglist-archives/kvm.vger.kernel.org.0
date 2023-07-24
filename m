Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C42175FF9A
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 21:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjGXTKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 15:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbjGXTKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 15:10:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609621702
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 12:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690225769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WawsHdGpz2PcjK+rzMy9rXk7uFt8JlrwIupXE53S044=;
        b=OhNcLwK5ozcz3RCrdyaGaeY79Go/i9cqA8kGQSfEvTyNXjeYsGT7+2+p84vLO6aYnQBwjO
        jp5b8ARH3JBssjH84KPodnDwDlEFcPlz6b2kC5Ss+FHmXs3Y+Adn1O8GUwFY1BGrG+vRZi
        orMSkmDcsrmV8pnhW+yra6hCOLcfxMk=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-tvUyf58ROA6k0ChAcLWCGg-1; Mon, 24 Jul 2023 15:09:26 -0400
X-MC-Unique: tvUyf58ROA6k0ChAcLWCGg-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-77e3eaa1343so239969639f.2
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 12:09:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690225765; x=1690830565;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WawsHdGpz2PcjK+rzMy9rXk7uFt8JlrwIupXE53S044=;
        b=YEO+S++gJr4w65VbOT3GWfR3CkV1GK2VkHKAZab+rKgo2R3qvARmDHCyZ9xYNgA/5f
         T7L/Z0pwL6CoUAe6OTzvnEafcR0I3JCjnc4oDP2bSXxAUqg3txFQoLYjOliQ/Ki9kltE
         kq/DXcaOKFtdSTUiDZjFVwatJS5t2dqVu43YYaJrVuN0Y4r95WHLPVmfZkL7px4G2scG
         bO0i8+ZY5kjLzn4L+tt9DXkiqOp9u19w992zD+sv9M6z36yGyyRF01cOa1kwXS8eLop/
         mO9rYaKUSgMRxF7BC/zVYDNdslm3nsbTVwuVIbedW/+uygppB0WOEIo2OFLju5rXhk8H
         0fYA==
X-Gm-Message-State: ABy/qLaux+ZimozJg0x5KcrFTFhaWOnM89oBGeigG9gOg9Z4N6Bfh8tm
        XSF/rCamZJIOvpcFXE1nvCuxcMwtPMSTtbbMBpNplKxWns2BZx9MmFtf4cK00g8mH1kcQJb4Oyp
        UXxlbSz13entR
X-Received: by 2002:a5d:8856:0:b0:787:9f4:a286 with SMTP id t22-20020a5d8856000000b0078709f4a286mr830174ios.3.1690225765542;
        Mon, 24 Jul 2023 12:09:25 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGQj4iG8mT+sSEqSQYkZfuQ4Hg9spnEgepBk2H1o6jlqFqHr7tDoImTU/XT+4VwrQSYWZsnbg==
X-Received: by 2002:a5d:8856:0:b0:787:9f4:a286 with SMTP id t22-20020a5d8856000000b0078709f4a286mr830154ios.3.1690225765283;
        Mon, 24 Jul 2023 12:09:25 -0700 (PDT)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id e23-20020a056638021700b0042b4f9ddecasm3133372jaq.85.2023.07.24.12.09.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 12:09:24 -0700 (PDT)
Date:   Mon, 24 Jul 2023 13:09:22 -0600
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
Message-ID: <20230724130922.5bf567ef.alex.williamson@redhat.com>
In-Reply-To: <ZLbEigQvwSZFiCqv@nvidia.com>
References: <20230718135551.6592-1-yi.l.liu@intel.com>
        <ZLbEigQvwSZFiCqv@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Jul 2023 13:57:46 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jul 18, 2023 at 06:55:25AM -0700, Yi Liu wrote:
> > Existing VFIO provides group-centric user APIs for userspace. Userspace
> > opens the /dev/vfio/$group_id first before getting device fd and hence
> > getting access to device. This is not the desired model for iommufd. Per
> > the conclusion of community discussion[1], iommufd provides device-centric
> > kAPIs and requires its consumer (like VFIO) to be device-centric user
> > APIs. Such user APIs are used to associate device with iommufd and also
> > the I/O address spaces managed by the iommufd.
> > 
> > This series first introduces a per device file structure to be prepared
> > for further enhancement and refactors the kvm-vfio code to be prepared
> > for accepting device file from userspace. After this, adds a mechanism for
> > blocking device access before iommufd bind. Then refactors the vfio to be
> > able to handle cdev paths (e.g. iommufd binding, no-iommufd, [de]attach ioas).
> > This refactor includes making the device_open exclusive between the group
> > and the cdev path, only allow single device open in cdev path; vfio-iommufd
> > code is also refactored to support cdev. e.g. split the vfio_iommufd_bind()
> > into two steps. Eventually, adds the cdev support for vfio device and the
> > new ioctls, then makes group infrastructure optional as it is not needed
> > when vfio device cdev is compiled.
> > 
> > This series is based on some preparation works done to vfio emulated devices[2]
> > and vfio pci hot reset enhancements[3]. Per discussion[4], this series does not
> > support cdev for physical devices that do not have IOMMU. Such devices only
> > have group-centric user APIs.
> > 
> > This series is a prerequisite for iommu nesting for vfio device[5] [6].
> > 
> > The complete code can be found in below branch, simple tests done to the
> > legacy group path and the cdev path. QEMU changes are in upstreaming[7]
> > and the complete code can be found at[8]
> > 
> > https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v15
> > (config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)  
> 
> Alex, if you are still good with this lets make this into a shared
> branch, do you want to do it or would you like a PR from me?

Sorry, was out much of last week.  Yes, my intent would be to put this
both in a shared branch and my next branch for v6.6.  Given this is
mostly vfio, it seems like it'd make sense for me to provide that
branch but I may not get to it until tomorrow.  Thanks,

Alex

