Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B76D66468A
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 17:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbjAJQvZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 11:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238714AbjAJQvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 11:51:14 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC29DDEEB
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:51:13 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id fa5so6025551qtb.11
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 08:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nD2L+nouQmYkYUXiElXuWDWGgbRqZvOgB6YtZyQAtHQ=;
        b=AN8zcHl7ntfjRnJWS+1I6Gb2ig79s8638IrmdTtJOsAsVMB8UbvoEfyouuGxS4Ez0I
         H+sCGjun+6oIGTuzZurJUdkwXK550WAon7TZx66V8f1fkRoDQDqSrao9NJ15Ubmmwa54
         br8mBPdwhRm1n1FiUa25ctcJYzgzFsA5OMAWNmg6lSEjQmQX0xa9R94QsBNnSbR8R8uE
         ra0lhLPiYyKyuxXXn8EqhUkfIYGzdkf5ws6prCnPyt6BydG9BnuWQy6b87D1gOd2YSNB
         mdKb2MtCN47ruH5M/7TI82RPLg65wfruJPS4S8nNHOjJ612Dkkt9LmY8Pq146CtyMJrl
         UKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nD2L+nouQmYkYUXiElXuWDWGgbRqZvOgB6YtZyQAtHQ=;
        b=F4H89EX8bB6BT97jOG0V7DLXrRfWZrCRyLarXBtUUEAvoFUUDnBHQtMOPoJayAG8LO
         4/JAH0d6iw6Q6MC4x8TucF9cEzEyCmp1udwcdkz9RuB97LrbCeTlljGezyyBXbTbgKM9
         9PjkpTctKWbiBUW/NWDKb+Ui5yGY7wgGID0GcQXO6LXvCeFzl5a7kXr+IJ5zRqw6ueWO
         R6/nIlV9rVpfSeQ/bb9cFzJ/kvA2WEWSY/FUgl39l2S11aCcKn4MLEACbdkCa/xR/Woj
         XyvfTfr/dERYr+hMiDm/KDJQ0O2rsp+QB7So/Xp2ldamiDtQ31HV3X51L/iVrIDmfVu0
         VKXQ==
X-Gm-Message-State: AFqh2kpLLTMZHNX1rwL3Dz7mdVQ6m4v78TWD13vq1MJIFPB7gIeeO0yJ
        vB6HU5YNzUP/UFLh8qHZ3FJkLW1PFhOvKhwB
X-Google-Smtp-Source: AMrXdXvBzw2T1NVzHMnn9YSgyUplc8voY4BFvMnwrodQwtlWtdIt2VQe6jIFScX+wXR34rqdOr0mvg==
X-Received: by 2002:a05:622a:4d06:b0:3a9:9217:9e6c with SMTP id fd6-20020a05622a4d0600b003a992179e6cmr109805668qtb.55.1673369472890;
        Tue, 10 Jan 2023 08:51:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-50-193.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.50.193])
        by smtp.gmail.com with ESMTPSA id v24-20020ac87498000000b003abf6eb5a51sm2987520qtq.88.2023.01.10.08.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:51:12 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1pFHqB-008R3X-S0;
        Tue, 10 Jan 2023 12:51:11 -0400
Date:   Tue, 10 Jan 2023 12:51:11 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Christian =?utf-8?Q?Borntr=C3=A4ger?= <borntraeger@linux.ibm.com>
Subject: Re: [PATCH v3 1/1] vfio/type1: Respect IOMMU reserved regions in
 vfio_test_domain_fgsp()
Message-ID: <Y72Xf878jBYrigHI@ziepe.ca>
References: <20230110164427.4051938-1-schnelle@linux.ibm.com>
 <20230110164427.4051938-2-schnelle@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110164427.4051938-2-schnelle@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 05:44:27PM +0100, Niklas Schnelle wrote:
> Since commit cbf7827bc5dc ("iommu/s390: Fix potential s390_domain
> aperture shrinking") the s390 IOMMU driver uses reserved regions for the
> system provided DMA ranges of PCI devices. Previously it reduced the
> size of the IOMMU aperture and checked it on each mapping operation.
> On current machines the system denies use of DMA addresses below 2^32 for
> all PCI devices.
> 
> Usually mapping IOVAs in a reserved regions is harmless until a DMA
> actually tries to utilize the mapping. However on s390 there is
> a virtual PCI device called ISM which is implemented in firmware and
> used for cross LPAR communication. Unlike real PCI devices this device
> does not use the hardware IOMMU but inspects IOMMU translation tables
> directly on IOTLB flush (s390 RPCIT instruction). If it detects IOVA
> mappings outside the allowed ranges it goes into an error state. This
> error state then causes the device to be unavailable to the KVM guest.
> 
> Analysing this we found that vfio_test_domain_fgsp() maps 2 pages at DMA
> address 0 irrespective of the IOMMUs reserved regions. Even if usually
> harmless this seems wrong in the general case so instead go through the
> freshly updated IOVA list and try to find a range that isn't reserved,
> and fits 2 pages, is PAGE_SIZE * 2 aligned. If found use that for
> testing for fine grained super pages.
> 
> Fixes: af029169b8fd ("vfio/type1: Check reserved region conflict and update iova list")
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> ---
> v2 -> v3:
> - Don't require region->start to be aligned but instead just that we can fit an
>   aligned allocation (Alex)
> - Use Fixes tag for the introduction of reserved regions as that came
>   after the fine grained super pages test (Alex)
> v1 -> v2:
> - Reworded commit message to hopefully explain things a bit better and
>   highlight that usually just mapping but not issuing DMAs for IOVAs in
>   a resverved region is harmless but still breaks things with ISM devices.
> - Added a check for PAGE_SIZE * 2 alignment (Jason)
> 
>  drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
