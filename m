Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 378DC6D7042
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 00:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjDDWqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 18:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235754AbjDDWqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 18:46:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590CD2706
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 15:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680648316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vqCHmmroLr/ysooa2PnqjjEGm/oSk+1xFWZwtedU+d8=;
        b=J0BUKRIJRhyIjVicMGY4RHm3CJfhZUfblzwgOSC2YoO2zxNtHty2B5jYsjtH199wmWcakd
        zySL4cEpFSsw7WoYhCxVoBpIPovBBCmUSS7PiT2iHoCvVZpw2/RpvbYvoPPAltRHpQcgfj
        n/KB0b/2c7QXlymQ1AB11HYz/3hoU2A=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-6g0nQqbKNuyqhDgerXvDyg-1; Tue, 04 Apr 2023 18:45:15 -0400
X-MC-Unique: 6g0nQqbKNuyqhDgerXvDyg-1
Received: by mail-il1-f198.google.com with SMTP id n9-20020a056e02100900b00325c9240af7so22314464ilj.10
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 15:45:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680648315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vqCHmmroLr/ysooa2PnqjjEGm/oSk+1xFWZwtedU+d8=;
        b=tK5V4ZmOmoDCLkoZIN5A4BgyThgyV/8NY/V7B20dWVZbt0njjSn+VCA7q98VHkpHI0
         hTiuOhTfZE7djLDu1TBaj375bMZGqi5kjOVHrxRrVm3i7DojuvPJa8HuzQf7VI7b/H1N
         EVgZkjKyv/jggOUcLprIqZNop0Iua+YbvszWTGahF3KSdMkc9dkZ2YcbEkEfGufxbOQ8
         7m8xUCp1W1i0hvOdrflCgJx0sNnMwQPlN4ez6e5N+1yo8gEJxMB6oVSAYS3VQxFLplg5
         QzJ2I+1doNrbm6ycgYADdwXJmD0Cgyc98HAqHNEMdsCjpIW/TGf1EoqDAHFurwFYA+g5
         XgwQ==
X-Gm-Message-State: AAQBX9d/nqH8TcMi1DEZ2EABJpvYOg8ifeiITpVxBM/w5ZEaS764RFUm
        CT4dVf6WERVdWiykwqtlMIvKrGradIA5mvZAO+fJDPi1qNVrog61q6h0w6pgXZxGezOjTjdSvAu
        5joeXQp635/WH
X-Received: by 2002:a5d:9284:0:b0:75e:7db3:f515 with SMTP id s4-20020a5d9284000000b0075e7db3f515mr4647284iom.19.1680648314762;
        Tue, 04 Apr 2023 15:45:14 -0700 (PDT)
X-Google-Smtp-Source: AKy350btE39tUqyxr8lCIfc8BBFYrDXLBwPQ03v/gOEC6MT6SW8i/qlQoIFkp32c7zyxF7EqZWRxzA==
X-Received: by 2002:a5d:9284:0:b0:75e:7db3:f515 with SMTP id s4-20020a5d9284000000b0075e7db3f515mr4647266iom.19.1680648314517;
        Tue, 04 Apr 2023 15:45:14 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f4-20020a02a104000000b0040b4c29010fsm1367898jag.140.2023.04.04.15.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 15:45:14 -0700 (PDT)
Date:   Tue, 4 Apr 2023 16:45:12 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v9 16/25] iommufd/device: Add iommufd_access_detach()
 API
Message-ID: <20230404164512.37bca62e.alex.williamson@redhat.com>
In-Reply-To: <20230401151833.124749-17-yi.l.liu@intel.com>
References: <20230401151833.124749-1-yi.l.liu@intel.com>
        <20230401151833.124749-17-yi.l.liu@intel.com>
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

On Sat,  1 Apr 2023 08:18:24 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> From: Nicolin Chen <nicolinc@nvidia.com>
> 
> Previously, the detach routine is only done by the destroy(). And it was
> called by vfio_iommufd_emulated_unbind() when the device runs close(), so
> all the mappings in iopt were cleaned in that setup, when the call trace
> reaches this detach() routine.
> 
> Now, there's a need of a detach uAPI, meaning that it does not only need
> a new iommufd_access_detach() API, but also requires access->ops->unmap()
> call as a cleanup. So add one.
> 
> However, leaving that unprotected can introduce some potential of a race
> condition during the pin_/unpin_pages() call, where access->ioas->iopt is
> getting referenced. So, add an ioas_lock to protect the context of iopt
> referencings.
> 
> Also, to allow the iommufd_access_unpin_pages() callback to happen via
> this unmap() call, add an ioas_unpin pointer, so the unpin routine won't
> be affected by the "access->ioas = NULL" trick.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/device.c          | 76 +++++++++++++++++++++++--
>  drivers/iommu/iommufd/iommufd_private.h |  2 +
>  include/linux/iommufd.h                 |  1 +
>  3 files changed, 74 insertions(+), 5 deletions(-)

Does this need to go in via iommufd first?  There seems to be quite a
bit of churn in iommufd/device.c vs the vfio_mdev_ops branch (ie. it
doesn't apply). Thanks,

Alex

