Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A718753E7F0
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239796AbiFFOd6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 10:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239732AbiFFOd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 10:33:57 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5D0D2C13F;
        Mon,  6 Jun 2022 07:33:55 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8CACF15DB;
        Mon,  6 Jun 2022 07:33:55 -0700 (PDT)
Received: from [10.57.81.38] (unknown [10.57.81.38])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 555903F73B;
        Mon,  6 Jun 2022 07:33:48 -0700 (PDT)
Message-ID: <1e0e5403-1e65-db9a-c8e7-34e316bfda8e@arm.com>
Date:   Mon, 6 Jun 2022 15:33:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/5] iommu: Ensure device has the same iommu_ops as the
 domain
Content-Language: en-GB
To:     Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com,
        joro@8bytes.org, will@kernel.org, marcan@marcan.st,
        sven@svenpeter.dev, robdclark@gmail.com, m.szyprowski@samsung.com,
        krzysztof.kozlowski@linaro.org, baolu.lu@linux.intel.com,
        agross@kernel.org, bjorn.andersson@linaro.org,
        matthias.bgg@gmail.com, heiko@sntech.de, orsonzhai@gmail.com,
        baolin.wang7@gmail.com, zhang.lyra@gmail.com, wens@csie.org,
        jernej.skrabec@gmail.com, samuel@sholland.org,
        jean-philippe@linaro.org, alex.williamson@redhat.com
Cc:     suravee.suthikulpanit@amd.com, alyssa@rosenzweig.io,
        alim.akhtar@samsung.com, dwmw2@infradead.org, yong.wu@mediatek.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
        cohuck@redhat.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
References: <20220606061927.26049-1-nicolinc@nvidia.com>
 <20220606061927.26049-3-nicolinc@nvidia.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220606061927.26049-3-nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-06-06 07:19, Nicolin Chen wrote:
> The core code should not call an iommu driver op with a struct device
> parameter unless it knows that the dev_iommu_priv_get() for that struct
> device was setup by the same driver. Otherwise in a mixed driver system
> the iommu_priv could be casted to the wrong type.

We don't have mixed-driver systems, and there are plenty more 
significant problems than this one to solve before we can (but thanks 
for pointing it out - I hadn't got as far as auditing the public 
interfaces yet). Once domains are allocated via a particular device's 
IOMMU instance in the first place, there will be ample opportunity for 
the core to stash suitable identifying information in the domain for 
itself. TBH even the current code could do it without needing the 
weirdly invasive changes here.

> Store the iommu_ops pointer in the iommu_domain and use it as a check to
> validate that the struct device is correct before invoking any domain op
> that accepts a struct device.

In fact this even describes exactly that - "Store the iommu_ops pointer 
in the iommu_domain", vs. the "Store the iommu_ops pointer in the 
iommu_domain_ops" which the patch is actually doing :/

[...]
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 19cf28d40ebe..8a1f437a51f2 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1963,6 +1963,10 @@ static int __iommu_attach_device(struct iommu_domain *domain,
>   {
>   	int ret;
>   
> +	/* Ensure the device was probe'd onto the same driver as the domain */
> +	if (dev->bus->iommu_ops != domain->ops->iommu_ops)

Nope, dev_iommu_ops(dev) please. Furthermore I think the logical place 
to put this is in iommu_group_do_attach_device(), since that's the 
gateway for the public interfaces - we shouldn't need to second-guess 
ourselves for internal default-domain-related calls.

Thanks,
Robin.

> +		return -EMEDIUMTYPE;
> +
>   	if (unlikely(domain->ops->attach_dev == NULL))
>   		return -ENODEV;
