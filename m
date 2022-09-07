Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E755B0619
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 16:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiIGOGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 10:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiIGOGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 10:06:40 -0400
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6279E9C525;
        Wed,  7 Sep 2022 07:06:38 -0700 (PDT)
Received: from 8bytes.org (p4ff2bb62.dip0.t-ipconnect.de [79.242.187.98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 6118D2409A7;
        Wed,  7 Sep 2022 16:06:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1662559591;
        bh=sD6ntPJavoL+O3jZjBfdlyQKhK42Ee+ATtCC5qSKLek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rnWXPfkRqiJXCBikZk6JRGP2BockRbTgJPogFW6R24YrO/UYOBdbDIQPctDN3LGpI
         79/xXHT61Edm0n+vSGPYdlczsRRfdkacO6KmQgX/Kv6hNnOMuGvxYRlTiNeRqAdoGh
         5eisSJGFeEPl9sdwLcPf/+l2Yyy8DviLlelMTM4i/bTvjcSo5ebNKYoIEDQy0YTBKO
         jt0uBK0fCmoSFWyU5uIRYNcijnnozfeA7oB/uWHePVQatjmPma4sWvhtPveFHkv/Zd
         5qGfNEp1V9BqTtR+QMkc0IJeFW1j8U5UpZXX6b1OmgcnRAA8Xu95xNZgC6+l1xfUpO
         7YogNayXEccUQ==
Date:   Wed, 7 Sep 2022 16:06:29 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
        robin.murphy@arm.com, alex.williamson@redhat.com,
        suravee.suthikulpanit@amd.com, marcan@marcan.st,
        sven@svenpeter.dev, alyssa@rosenzweig.io, robdclark@gmail.com,
        dwmw2@infradead.org, baolu.lu@linux.intel.com,
        mjrosato@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        orsonzhai@gmail.com, baolin.wang@linux.alibaba.com,
        zhang.lyra@gmail.com, thierry.reding@gmail.com, vdumpa@nvidia.com,
        jonathanh@nvidia.com, jean-philippe@linaro.org, cohuck@redhat.com,
        tglx@linutronix.de, shameerali.kolothum.thodi@huawei.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        yangyingliang@huawei.com, jon@solid-run.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        kevin.tian@intel.com
Subject: Re: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <YxilZbRL0WBR97oi@8bytes.org>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
 <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxig+zfA2Pr4vk6K@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 10:47:39AM -0300, Jason Gunthorpe wrote:
> Would you be happier if we wrote it like
> 
>  #define IOMMU_EINCOMPATIBLE_DEVICE xx
> 
> Which tells "which of the function parameters is actually invalid" ?

Having done some Rust hacking in the last months, I have to say I like
to concept of error handling with Result<> there. Ideally we have a way
to emulate that in our C code without having to change all callers.

What I am proposing is a way this could be emulated here, but I am open
to other suggestions. Still better than re-using random error codes for
special purposes.

Regards,

	Joerg
