Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50201558CE0
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 03:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiFXBgB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 21:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiFXBgA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 21:36:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBAC5677A;
        Thu, 23 Jun 2022 18:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656034559; x=1687570559;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gyA97i97HwL5wq54DYwFbjfmzziuSTurfIWHXSjG3gU=;
  b=nZ3EdQ4LB3Jl8N2xyPUKDufei4aMw6C99PRF+nC2WwjQrP5pByLRC0je
   fYA/u0eFTu3CHgpePAbfbBve5gzFe1LxTFrVCMiEt3j4hfk+t7BgXgFQF
   hFj/40ieBwH27qgYQjzqglnjPlCLftcPYKicrEnUbrN2M1Vm3TpqSWLJ7
   g1QAp+nsTN5ulZc0t7uTNH5N00XA17n241cRgzuWePhofC5F6GVWnEDW1
   P6s0jKs0RzgmMVvLhK9gEASowjq3zdaTAKjslI5lQ1T7HSqyZKQ4dOdF+
   r4q3NmigepAGfsKI2rW3jm7zXTuOMQpwiTTlMO94eMJViUAqPOFppP3Li
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10387"; a="367212186"
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="367212186"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 18:35:59 -0700
X-IronPort-AV: E=Sophos;i="5.92,217,1650956400"; 
   d="scan'208";a="645038369"
Received: from wenli3x-mobl.ccr.corp.intel.com (HELO [10.249.168.117]) ([10.249.168.117])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 18:35:51 -0700
Message-ID: <270eec00-8aee-2288-4069-d604e6da2925@linux.intel.com>
Date:   Fri, 24 Jun 2022 09:35:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, suravee.suthikulpanit@amd.com,
        alyssa@rosenzweig.io, dwmw2@infradead.org, yong.wu@mediatek.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
        cohuck@redhat.com, thunder.leizhen@huawei.com, tglx@linutronix.de,
        chenxiang66@hisilicon.com, christophe.jaillet@wanadoo.fr,
        john.garry@huawei.com, yangyingliang@huawei.com,
        jordan@cosmicpenguin.net, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>, joro@8bytes.org,
        will@kernel.org, marcan@marcan.st, sven@svenpeter.dev,
        robin.murphy@arm.com, robdclark@gmail.com, matthias.bgg@gmail.com,
        orsonzhai@gmail.com, baolin.wang7@gmail.com, zhang.lyra@gmail.com,
        jean-philippe@linaro.org, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
References: <20220623200029.26007-1-nicolinc@nvidia.com>
 <20220623200029.26007-2-nicolinc@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220623200029.26007-2-nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/24 04:00, Nicolin Chen wrote:
> diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
> index e1cb51b9866c..5386d889429d 100644
> --- a/drivers/iommu/mtk_iommu_v1.c
> +++ b/drivers/iommu/mtk_iommu_v1.c
> @@ -304,7 +304,7 @@ static int mtk_iommu_v1_attach_device(struct iommu_domain *domain, struct device
>   	/* Only allow the domain created internally. */
>   	mtk_mapping = data->mapping;
>   	if (mtk_mapping->domain != domain)
> -		return 0;
> +		return -EMEDIUMTYPE;
>   
>   	if (!data->m4u_dom) {
>   		data->m4u_dom = dom;

This change looks odd. It turns the return value from success to
failure. Is it a bug? If so, it should go through a separated fix patch.

Best regards,
baolu
