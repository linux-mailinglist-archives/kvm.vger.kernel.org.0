Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD1B63E237
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 21:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiK3Uf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 15:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiK3Uf5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 15:35:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDBF2195
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 12:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669840500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yzSwQ2VF9Yg58ZHMWFIQ1DPJRP7ZPzwZYrK+uiP2B4w=;
        b=EdXegCDE+pLqaCZzbsOj7IruzGYku+j35XUAlPQ/G1MZcBtmliT/aOvDonMj/u7uMYqReN
        Eig5UWzcWJ+uDLf22hHz4+euLI/W04kGC93VcPRejkXoZNVXxh4ESNYFveWyJfy42hgU9u
        /rwnVuKBjFOWnO1PKl/9PBBikQK5pRs=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-Oy_3dF8RMr-IWDcL2MfrWw-1; Wed, 30 Nov 2022 15:34:59 -0500
X-MC-Unique: Oy_3dF8RMr-IWDcL2MfrWw-1
Received: by mail-io1-f70.google.com with SMTP id o15-20020a6bf80f000000b006de313e5cfeso12099637ioh.6
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 12:34:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yzSwQ2VF9Yg58ZHMWFIQ1DPJRP7ZPzwZYrK+uiP2B4w=;
        b=dx4nHFVr/YgjPV+dsdLdU2EptG1crtABWmAqxLq7wU5P31rzCVxqTEHO+50Y3Y/Jgr
         OigEbkrw+Pw//e/0KKC1sr1UIB4RjsW1QWUh22hwvcERMP+Phh0MhCpYf7/Uq3wmbd8+
         R4co6xHT5wcd9aINrlURtbroYqjPYXMuKPYDK/uvqd6GswUNQmATyeNtGAY3jm6uTXog
         rg2CojmhO9b3gaz7rR0zi+AMMCGqpo49fJH4HadWJwzLGYvXFaMqt/Y9SZA1HLAoHmUN
         tT3Com4K22trh/s7RobEKXHNk2C1uj0wnt3AN1CZuANq9JvaVODaNPLcBjnJtbdeo0lO
         lRtw==
X-Gm-Message-State: ANoB5pke8rnm3TJLUHmKyLpq/RwN7R445sWo/d1sA4oHHBOVkc6W/lAX
        hEsUhHuZVWJQkVY2XYuWQLpkQ9ckNHwkZkYZiKgOFZdbcFavrYsxf1wE4OmkXDYXP37rLIcJtP9
        As8YHzG25Zmcm
X-Received: by 2002:a05:6e02:e11:b0:302:cff7:890 with SMTP id a17-20020a056e020e1100b00302cff70890mr20669577ilk.205.1669840498460;
        Wed, 30 Nov 2022 12:34:58 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6zIRVaIxYu0jrWH1TDqGsriuSzwvLKEFFF9J3Vj8WHhEFtJCqf+j6nDPBPSv/XcsF49i5+mA==
X-Received: by 2002:a05:6e02:e11:b0:302:cff7:890 with SMTP id a17-20020a056e020e1100b00302cff70890mr20669570ilk.205.1669840498234;
        Wed, 30 Nov 2022 12:34:58 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l15-20020a02664f000000b00383c144fbd7sm911383jaf.32.2022.11.30.12.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 12:34:57 -0800 (PST)
Date:   Wed, 30 Nov 2022 13:34:55 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v4 00/10] Connect VFIO to IOMMUFD
Message-ID: <20221130133455.3f8ef495.alex.williamson@redhat.com>
In-Reply-To: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
References: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
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

On Tue, 29 Nov 2022 16:31:45 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> [ As with the iommufd series, this will be the last posting unless
> something major happens, futher fixes will be in new commits ]
> 
> This series provides an alternative container layer for VFIO implemented
> using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
> not be compiled in.
> 
> At this point iommufd can be injected by passing in a iommfd FD to
> VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
> to obtain the compat IOAS and then connect up all the VFIO drivers as
> appropriate.
> 
> This is temporary stopping point, a following series will provide a way to
> directly open a VFIO device FD and directly connect it to IOMMUFD using
> native ioctls that can expose the IOMMUFD features like hwpt, future
> vPASID and dynamic attachment.
> 
> This series, in compat mode, has passed all the qemu tests we have
> available, including the test suites for the Intel GVT mdev. Aside from
> the temporary limitation with P2P memory this is belived to be fully
> compatible with VFIO.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/vfio_iommufd
> 
> It requires the iommufd series:
> 
> https://lore.kernel.org/r/0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com
> 
> v4:
>  - Change the assertion in vfio_group_has_iommu to be clearer
>  - Use vfio_group_has_iommu()
>  - Remove allow_unsafe_interrupts stuff
>  - Update IOMMUFD_VFIO_CONTAINER kconfig description
>  - Use DEBUG_KERNEL insted of RUNTIME_TESTING_MENU for IOMMUFD_TEST kconfig

This looks ok to me and passes all my testing.  What's your merge plan?
I'm guessing you'd like to send it along with the main IOMMUFD pull
request, there are currently no conflicts with my next branch,
therefore:

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Alex Williamson <alex.williamson@redhat.com>

Otherwise, let's figure out the branch merge plan.  Thanks,

Alex

