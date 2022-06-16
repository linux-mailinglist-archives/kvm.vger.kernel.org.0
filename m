Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD6E54D81A
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 04:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355228AbiFPCKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 22:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358443AbiFPCKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 22:10:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291035AEE0;
        Wed, 15 Jun 2022 19:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655345406; x=1686881406;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u/polTrCcfTR/bnfvj7XjWWQORpzgrJJNnRIhd6+LYo=;
  b=Qu0Y5FW9OsO/xe+YNrKgzUBvvWAG7ijn3jZtuJVzH2cpylwiwtv+ZnVk
   1dxCADEwAAzOkRiBfPi/0XDlXEs46ozk6JSWvtHlifRy0VbkWA0AqvGFc
   Eoybia42yGBAKe+tZ2ubI1FD4lY9lvvaNnKZPPGhQ7KJBOIt9+o/c0WHc
   y8Ly5SYJ1BEvXXReFGqOgTmS2bl9e9zRMgOJ1dmyn/Chxkjulhblz4yKj
   CQfWX3SOqbhNcGUdGoToD0Y75DUe0QKiI27n2pSkLUn1AeNtFZFFQ/WVl
   6udazhGJM6w92GkaYjQ13D5cwlxnHDxZBEbCSjODowSl8ouomWKN1d7yB
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="258999490"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="258999490"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 19:09:59 -0700
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="831355596"
Received: from yuefengs-mobl.ccr.corp.intel.com (HELO [10.255.30.105]) ([10.255.30.105])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 19:09:51 -0700
Message-ID: <0c0e6ec8-725d-93e8-44f1-db6c8a673a97@linux.intel.com>
Date:   Thu, 16 Jun 2022 10:09:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, suravee.suthikulpanit@amd.com,
        alyssa@rosenzweig.io, dwmw2@infradead.org, yong.wu@mediatek.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
        cohuck@redhat.com, thunder.leizhen@huawei.com, tglx@linutronix.de,
        christophe.jaillet@wanadoo.fr, john.garry@huawei.com,
        chenxiang66@hisilicon.com, saiprakash.ranjan@codeaurora.org,
        isaacm@codeaurora.org, yangyingliang@huawei.com,
        jordan@cosmicpenguin.net, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>, joro@8bytes.org,
        will@kernel.org, marcan@marcan.st, sven@svenpeter.dev,
        robin.murphy@arm.com, robdclark@gmail.com, matthias.bgg@gmail.com,
        orsonzhai@gmail.com, baolin.wang7@gmail.com, zhang.lyra@gmail.com,
        jean-philippe@linaro.org, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
References: <20220616000304.23890-1-nicolinc@nvidia.com>
 <20220616000304.23890-2-nicolinc@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220616000304.23890-2-nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/16 08:03, Nicolin Chen wrote:
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 44016594831d..0dd13330fe12 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -4323,7 +4323,7 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
>   		return -ENODEV;
>   
>   	if (dmar_domain->force_snooping && !ecap_sc_support(iommu->ecap))
> -		return -EOPNOTSUPP;
> +		return -EMEDIUMTYPE;
>   
>   	/* check if this iommu agaw is sufficient for max mapped address */
>   	addr_width = agaw_to_width(iommu->agaw);
> @@ -4331,10 +4331,10 @@ static int prepare_domain_attach_device(struct iommu_domain *domain,
>   		addr_width = cap_mgaw(iommu->cap);
>   
>   	if (dmar_domain->max_addr > (1LL << addr_width)) {
> -		dev_err(dev, "%s: iommu width (%d) is not "
> +		dev_dbg(dev, "%s: iommu width (%d) is not "
>   		        "sufficient for the mapped address (%llx)\n",
>   		        __func__, addr_width, dmar_domain->max_addr);
> -		return -EFAULT;
> +		return -EMEDIUMTYPE;
>   	}
>   	dmar_domain->gaw = addr_width;

Can we simply remove the dev_err()? As the return value has explicitly
explained the failure reason, putting a print statement won't help much.

Best regards,
baolu
