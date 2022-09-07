Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB86C5B043F
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 14:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiIGMvA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 08:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiIGMut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 08:50:49 -0400
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFF0975CF8;
        Wed,  7 Sep 2022 05:50:46 -0700 (PDT)
Received: from 8bytes.org (p4ff2bb62.dip0.t-ipconnect.de [79.242.187.98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 6FAA4240857;
        Wed,  7 Sep 2022 14:41:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1662554516;
        bh=JzhvE6AKnt05k9hUcUfcBmLyd7x5XDIZ52BK23fxpSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=60gm7iJb3a9EHDRBPPmkRhjnPxPdo8Gl8tCIOOIov74tc9nJYqxwRN3f9BaD/uBTh
         ZoV5WBylA/H+HpQRYy6dC/0WalBc7Xg2gQ/EGr7HOKkp3DB6I7K2VtL5rWe+yHaFHo
         3GC6YDahBrvwp1lTMhPP0vwiUslxcaImFmKevknjuQ++PrHb+32Kb+SwW1OGoiSniC
         j5WIwf2zsHXP7Dwv+Ps3tJybqv0ASdmzh/SRgK2OM7/c76yEAtXi01DBWO3CrfKkfR
         V7IV9Z/HY1tQSVYITH64oKsBfN+UYoyf/xQA2uGwpPthodTETsq7ja03Rs0zm47WBI
         eNx1oHFYz53Og==
Date:   Wed, 7 Sep 2022 14:41:54 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     will@kernel.org, robin.murphy@arm.com, alex.williamson@redhat.com,
        suravee.suthikulpanit@amd.com, marcan@marcan.st,
        sven@svenpeter.dev, alyssa@rosenzweig.io, robdclark@gmail.com,
        dwmw2@infradead.org, baolu.lu@linux.intel.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        orsonzhai@gmail.com, baolin.wang@linux.alibaba.com,
        zhang.lyra@gmail.com, thierry.reding@gmail.com, vdumpa@nvidia.com,
        jonathanh@nvidia.com, jean-philippe@linaro.org, cohuck@redhat.com,
        jgg@nvidia.com, tglx@linutronix.de,
        shameerali.kolothum.thodi@huawei.com, thunder.leizhen@huawei.com,
        christophe.jaillet@wanadoo.fr, yangyingliang@huawei.com,
        jon@solid-run.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kevin.tian@intel.com
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <YxiRkm7qgQ4k+PIG@8bytes.org>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815181437.28127-2-nicolinc@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022 at 11:14:33AM -0700, Nicolin Chen wrote:
> Provide a dedicated errno from the IOMMU driver during attach that the
> reason attached failed is because of domain incompatability. EMEDIUMTYPE
> is chosen because it is never used within the iommu subsystem today and
> evokes a sense that the 'medium' aka the domain is incompatible.

I am not a fan of re-using EMEDIUMTYPE or any other special value. What
is needed here in EINVAL, but with a way to tell the caller which of the
function parameters is actually invalid.

For that I prefer adding an additional pointer parameter to the attach
functions in which the reason for the failure can be communicated up the
chain.

For the top-level iommu_attach_device() function I am okay with having a
special version which has this additional paremter.

Regards,

	Joerg
