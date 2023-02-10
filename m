Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00670692A6A
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 23:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbjBJWpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 17:45:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbjBJWpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 17:45:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD620831CA
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 14:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676069054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8VZLwEZ0VhiWmW6aalUpiTNY5oCQlCmFrf7N1T4iZuc=;
        b=cgt/nRk9la+RvyddEagInq3UKLEkDd+OYfIYKq3t8udgrm3AOreQmGe2gt9b5M0Jt4iCVd
        2opA5nGnyLw/X933I7FR9q69UV6SFvGmkfcSXed7EF3SfkhaNRCiDXwCbsm1kix5Hv9Pbg
        sF/XB9myzbDyNTOMgWGKk9vFdLHThGY=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-153-QUczH7_iOpKCPUoqJWtXcg-1; Fri, 10 Feb 2023 17:44:13 -0500
X-MC-Unique: QUczH7_iOpKCPUoqJWtXcg-1
Received: by mail-io1-f71.google.com with SMTP id f4-20020a05660215c400b0073a6a9f8f45so1066862iow.11
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 14:44:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8VZLwEZ0VhiWmW6aalUpiTNY5oCQlCmFrf7N1T4iZuc=;
        b=0gmLQD3LjxxmLunGe9/h7iRmT1XtWrzDrjJrQFTUqPczNxwfwDkOvasqInuoWCFu5y
         3FBmlerTZWzVZEPy/HkKDj+B/GGcoXxwxb2pwXAbQJtTccB+jBP56kZmRa/WSBjogTb0
         scXi6al1nGp1BKTH89UY4C5TP3P/CFHeJdphXSH8LyMQWayWS0Qet0/6PDQiMQo38sqi
         Kt8GNZUkSYVcH2D50d+o4JoTyrzZPu0qWEyctd0xbqGS+/NlP6Ev/TFqwg7QV6qWQ0Ob
         FgL0DOCoVnMZZ8zj2rY7pDtFHGJ5mQkbFA4Jq9UK7SYdjD6vqTt0l1p6mo8zgPO8v7Su
         66tw==
X-Gm-Message-State: AO0yUKUwjEuy2F8e4YgssnPirbi/Gk4s/wDP3DQzPKR6SYMCSQhlEnpQ
        UjWLDmCrf1+30cUy+B1A5sv0MsUNMt/xCNYOyzxGMh9SKuz3QJPrY0cuQoKMjeaPdmaSigcMCN4
        L4NO6xXFRpgRp
X-Received: by 2002:a05:6602:2acd:b0:722:827d:e6ac with SMTP id m13-20020a0566022acd00b00722827de6acmr17507143iov.6.1676069052818;
        Fri, 10 Feb 2023 14:44:12 -0800 (PST)
X-Google-Smtp-Source: AK7set/pYb5EOh/Drz42V1PJ5+VKWj6WP/ITUzBus6W3/LeQWRmoejvgCP3pyCdxFAjIjZZ39ARC1A==
X-Received: by 2002:a05:6602:2acd:b0:722:827d:e6ac with SMTP id m13-20020a0566022acd00b00722827de6acmr17507122iov.6.1676069052584;
        Fri, 10 Feb 2023 14:44:12 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c11-20020a02a40b000000b003bf39936d1esm1666882jal.131.2023.02.10.14.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 14:44:11 -0800 (PST)
Date:   Fri, 10 Feb 2023 15:44:10 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     joro@8bytes.org, jgg@nvidia.com, kevin.tian@intel.com,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        baolu.lu@linux.intel.com
Subject: Re: [PATCH 2/6] iommu/vt-d: Implement hw_info for iommu capability
 query
Message-ID: <20230210154410.2b3b8296.alex.williamson@redhat.com>
In-Reply-To: <20230209041642.9346-3-yi.l.liu@intel.com>
References: <20230209041642.9346-1-yi.l.liu@intel.com>
        <20230209041642.9346-3-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
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

On Wed,  8 Feb 2023 20:16:38 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> From: Lu Baolu <baolu.lu@linux.intel.com>
> 
> To support nested translation in the userspace, it should check the
> underlying hardware information for the capabilities.
> 
> Add intel_iommu_hw_info() to report cap_reg and ecap_reg information.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> ---
>  drivers/iommu/intel/iommu.c  | 19 +++++++++++++++++++
>  drivers/iommu/intel/iommu.h  |  1 +
>  include/uapi/linux/iommufd.h | 21 +++++++++++++++++++++
>  3 files changed, 41 insertions(+)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 59df7e42fd53..929f600cc350 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4760,8 +4760,26 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
>  	intel_pasid_tear_down_entry(iommu, dev, pasid, false);
>  }
>  
> +static void *intel_iommu_hw_info(struct device *dev, u32 *length)
> +{
> +	struct device_domain_info *info = dev_iommu_priv_get(dev);
> +	struct intel_iommu *iommu = info->iommu;
> +	struct iommu_device_info_vtd *vtd;
> +
> +	vtd = kzalloc(sizeof(*vtd), GFP_KERNEL);
> +	if (!vtd)
> +		return ERR_PTR(-ENOMEM);
> +
> +	vtd->cap_reg = iommu->cap;
> +	vtd->ecap_reg = iommu->ecap;

Just a friendly reminder that these registers are already exposed to
userspace under /sys/class/iommu/ and each device has an iommu link
back to their iommu device there.  This series doesn't really stand on
its own without some discussion of why that interface is not sufficient
for this use case.  Thanks,

Alex

