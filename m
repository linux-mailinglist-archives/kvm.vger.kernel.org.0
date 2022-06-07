Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0CEB53F785
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 09:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbiFGHpO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 03:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237907AbiFGHo6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 03:44:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8FC32ECC;
        Tue,  7 Jun 2022 00:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654587897; x=1686123897;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OSBO16dRCwR6Wb79tDIGbzqHZ301kVBrdpEBr6LRMRc=;
  b=WhVp5S+1hW900TACvFcx0rLwHKeZbfS2Kvoil6SFq4syxzGNCha5E3Lt
   lbgEZAvxWkwKC/V/DjAl7ke5XN94VFOnpQAncBJ8PWDepGpgLoRnIrQ+y
   MZTd2G9PVaoakvHUGvNPRhKek6wm1xf1XiS02s9sFOBAdkmaX8P2K7fmc
   wS/gQf8pGhDQTO0d40OfeqqXdiPB+pGtJiBAVhyptfwnvDeP6o/IoNLre
   bSpk0vznExOnGUz7ER2qOTV58qi+HhwS9JcurQz0GK8L/cjwoEOzPq7Tt
   OE5IR7+A93wJWpDQSbyHNrtV8gqBfz53kRMjdbj9nTrJSlbmmC95b6too
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="277374445"
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="277374445"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 00:44:55 -0700
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="584086830"
Received: from zwang64-mobl1.ccr.corp.intel.com (HELO [10.249.174.202]) ([10.249.174.202])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 00:44:45 -0700
Message-ID: <d357966b-7abd-f8f3-3ca7-3c99f5e075b9@linux.intel.com>
Date:   Tue, 7 Jun 2022 15:44:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, suravee.suthikulpanit@amd.com,
        alyssa@rosenzweig.io, alim.akhtar@samsung.com, dwmw2@infradead.org,
        yong.wu@mediatek.com, mjrosato@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, thierry.reding@gmail.com,
        vdumpa@nvidia.com, jonathanh@nvidia.com, cohuck@redhat.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/5] Simplify vfio_iommu_type1 attach/detach routine
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com,
        joro@8bytes.org, will@kernel.org, marcan@marcan.st,
        sven@svenpeter.dev, robin.murphy@arm.com, robdclark@gmail.com,
        m.szyprowski@samsung.com, krzysztof.kozlowski@linaro.org,
        agross@kernel.org, bjorn.andersson@linaro.org,
        matthias.bgg@gmail.com, heiko@sntech.de, orsonzhai@gmail.com,
        baolin.wang7@gmail.com, zhang.lyra@gmail.com, wens@csie.org,
        jernej.skrabec@gmail.com, samuel@sholland.org,
        jean-philippe@linaro.org, alex.williamson@redhat.com
References: <20220606061927.26049-1-nicolinc@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220606061927.26049-1-nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/6 14:19, Nicolin Chen wrote:
> Worths mentioning the exact match for enforce_cache_coherency is removed
> with this series, since there's very less value in doing that since KVM
> won't be able to take advantage of it -- this just wastes domain memory.
> Instead, we rely on Intel IOMMU driver taking care of that internally.

After reading this series, I don't see that Intel IOMMU driver needs any
further change to support the new scheme. Did I miss anything?

Best regards,
baolu
