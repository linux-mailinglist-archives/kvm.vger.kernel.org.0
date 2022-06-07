Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B7553FF2A
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 14:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244060AbiFGMmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 08:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244075AbiFGMms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 08:42:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41229248EB;
        Tue,  7 Jun 2022 05:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654605766; x=1686141766;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7CnaOaKftZFuU6zS5ejOPSw/a0TRQ7MfLEcH+ST55pI=;
  b=npA/EwVLm80RPrCVVatUyQvh9x9gm5H6ghJ6dgiol7bnt46yPC4MAeIP
   hodIq74n82eCvLkbY6D4n1U5g+cmclFLiS1lWHbglspj33Yx0VXhpW1xu
   XXW9UHZ96K+9IXY9b2Fj6DgEmQ3WeVzrXk0/t33U8iB4Eu56WDtZMlNUm
   pxMK+4gZexYxZYaxfCiELvhZ9RnU5kjk71ZGLbc98m1622I3PzO/VRn3x
   XFvHXiaR2OZx8kR0okSiNW3ZGnzZm376te9757QJrrGqkayUVpgzKPh+f
   935LMOkD4M2Ww6r8zdK9pommUkbicGZ9Jd72qeSG0NnIawB8Rb10j8+x0
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="259493235"
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="259493235"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 05:42:44 -0700
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="584184405"
Received: from zwang64-mobl1.ccr.corp.intel.com (HELO [10.249.174.202]) ([10.249.174.202])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 05:42:34 -0700
Message-ID: <3d0b2863-bb4f-31e1-d54e-09ddf4762d43@linux.intel.com>
Date:   Tue, 7 Jun 2022 20:42:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, Nicolin Chen <nicolinc@nvidia.com>,
        joro@8bytes.org, will@kernel.org, marcan@marcan.st,
        sven@svenpeter.dev, robin.murphy@arm.com, robdclark@gmail.com,
        m.szyprowski@samsung.com, krzysztof.kozlowski@linaro.org,
        agross@kernel.org, bjorn.andersson@linaro.org,
        matthias.bgg@gmail.com, heiko@sntech.de, orsonzhai@gmail.com,
        baolin.wang7@gmail.com, zhang.lyra@gmail.com, wens@csie.org,
        jernej.skrabec@gmail.com, samuel@sholland.org,
        jean-philippe@linaro.org, alex.williamson@redhat.com,
        suravee.suthikulpanit@amd.com, alyssa@rosenzweig.io,
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
Subject: Re: [PATCH 0/5] Simplify vfio_iommu_type1 attach/detach routine
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
 <d357966b-7abd-f8f3-3ca7-3c99f5e075b9@linux.intel.com>
 <20220607115820.GH1343366@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220607115820.GH1343366@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/7 19:58, Jason Gunthorpe wrote:
> On Tue, Jun 07, 2022 at 03:44:43PM +0800, Baolu Lu wrote:
>> On 2022/6/6 14:19, Nicolin Chen wrote:
>>> Worths mentioning the exact match for enforce_cache_coherency is removed
>>> with this series, since there's very less value in doing that since KVM
>>> won't be able to take advantage of it -- this just wastes domain memory.
>>> Instead, we rely on Intel IOMMU driver taking care of that internally.
>>
>> After reading this series, I don't see that Intel IOMMU driver needs any
>> further change to support the new scheme. Did I miss anything?
> 
> You already did it :)

Just as I thought. Thank you!

Best regards,
baolu

