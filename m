Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C6D5B10D1
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 02:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiIHAPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 20:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiIHAPE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 20:15:04 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F5C58B5E
        for <kvm@vger.kernel.org>; Wed,  7 Sep 2022 17:14:58 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id 11so24039415ybu.0
        for <kvm@vger.kernel.org>; Wed, 07 Sep 2022 17:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=GUHy3tTXYEVlHWPOZt/B5s9dwh1oEap8QDDRaqRD42s=;
        b=EkFoA2DUckJoc39LOiNtYCaU9cFbXVmazyNV12a3KStazGUhhJR1U6XnXODK0TIRz4
         +N76WdVdDqe2MYv/D4T4eFF42LX7csfZYrgd36cDl4ZF2OYpoYcAFEEFgAyx8F58tbal
         P0WKobLZgcRhq24wI/kQMtsCJmAgIaCYCjQo4lYSmesUuH6LFbT1w/aGaw0ARdAlSFXd
         J2GIhzFoViVMPvlNGlBbz2nzmN6QV9n01RRBkPte6KTFKKFHwsasefqsYFjEHKOZjYhz
         aBKTtDKp2Rsg+pzX3OQRfEjjk6SnI7xmv7hIDzZp8hxzLZ5KYlmECPeru8AFaesdazSU
         faJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=GUHy3tTXYEVlHWPOZt/B5s9dwh1oEap8QDDRaqRD42s=;
        b=to2NgzmQFl44KZaimmhxWOZ5Rr+T5Q8IN/evs/Yoxfvnftifia+FqphetnE4P4EOyg
         PfaO7ZzLMUiexX/6aOzbrjzHuzRWGyQKl4hO7YnMeyBcVSLK/Wt/LQUwYogvH7Btb4jF
         ysvqOdEfZIHL0/Q2M02apLp7IxDkZvXkR/QrmgJDqnr3Np+IsSk5LHXfEz7Kw20KZBR5
         EunT7xaiayQzAfjZl7u/1BtLwWdDBau5WTvtyEJnUV4qycfRMotOM6fHzBFJyiH3v5Ze
         mV2rVNrpxpZSGygX42Y6POP2aRyLvgqj4iP5KxrgkRC+bImmikEsQLOYiD9JGLg4A7t6
         jjCg==
X-Gm-Message-State: ACgBeo1IuSXP/nxW2g8mGp2Vu7tIYlZ/E4RjJL61urp4xq12PuDVG7eD
        +TI2f7GMBZKqvmz3ITe4k8TIoBnK0KsY6gl5/oE95g==
X-Google-Smtp-Source: AA6agR7IHk6cdCdDMOwQoLbNgYeM+zGxAHtlj9Ps+Z38Lyz7NBVqyyguZjbICAsIreBFAhf/MXWHt+Mk9Zkk8gYuoS4=
X-Received: by 2002:a25:1486:0:b0:6a8:f3e1:58ba with SMTP id
 128-20020a251486000000b006a8f3e158bamr4883435ybu.80.1662596096986; Wed, 07
 Sep 2022 17:14:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220803122655.100254-1-nipun.gupta@amd.com> <20220906134801.4079497-1-nipun.gupta@amd.com>
 <20220906134801.4079497-4-nipun.gupta@amd.com> <CAGETcx_W8QVe+CdpocN2rHjp08TwsW22FaJgrYW=0JNge_N6KQ@mail.gmail.com>
 <DM6PR12MB30829DDDC62B36B17F87B204E8419@DM6PR12MB3082.namprd12.prod.outlook.com>
 <f5cf7bd7-4cd9-ef9c-7f25-f814b2f1e41f@arm.com> <CAGETcx9LE=E2focmbEsdQV3s2NR4-9H35ODkgSxZY5_7SEJ1Qw@mail.gmail.com>
 <9e537066-525f-4a8c-ffc1-926ac130c6e6@arm.com>
In-Reply-To: <9e537066-525f-4a8c-ffc1-926ac130c6e6@arm.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 7 Sep 2022 17:14:20 -0700
Message-ID: <CAGETcx8geH_DP4yHKxH=kXW=iJ3tchb5oRmqQ-Ugs6gmw1MwYg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/7] iommu/arm-smmu-v3: support ops registration
 for CDX bus
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, "jgg@nvidia.com" <jgg@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 7, 2022 at 1:40 PM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 2022-09-07 19:24, Saravana Kannan wrote:
> > On Wed, Sep 7, 2022 at 1:27 AM Robin Murphy <robin.murphy@arm.com> wrote:
> >>
> >> On 2022-09-07 04:17, Gupta, Nipun wrote:
> >>> [AMD Official Use Only - General]
> >>>
> >>>
> >>>
> >>>> -----Original Message-----
> >>>> From: Saravana Kannan <saravanak@google.com>
> >>>> Sent: Wednesday, September 7, 2022 5:41 AM
> >>>> To: Gupta, Nipun <Nipun.Gupta@amd.com>
> >>>> Cc: robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org;
> >>>> gregkh@linuxfoundation.org; rafael@kernel.org; eric.auger@redhat.com;
> >>>> alex.williamson@redhat.com; cohuck@redhat.com; Gupta, Puneet (DCG-ENG)
> >>>> <puneet.gupta@amd.com>; song.bao.hua@hisilicon.com;
> >>>> mchehab+huawei@kernel.org; maz@kernel.org; f.fainelli@gmail.com;
> >>>> jeffrey.l.hugo@gmail.com; Michael.Srba@seznam.cz; mani@kernel.org;
> >>>> yishaih@nvidia.com; jgg@ziepe.ca; jgg@nvidia.com; robin.murphy@arm.com;
> >>>> will@kernel.org; joro@8bytes.org; masahiroy@kernel.org;
> >>>> ndesaulniers@google.com; linux-arm-kernel@lists.infradead.org; linux-
> >>>> kbuild@vger.kernel.org; linux-kernel@vger.kernel.org;
> >>>> devicetree@vger.kernel.org; kvm@vger.kernel.org; okaya@kernel.org; Anand,
> >>>> Harpreet <harpreet.anand@amd.com>; Agarwal, Nikhil
> >>>> <nikhil.agarwal@amd.com>; Simek, Michal <michal.simek@amd.com>;
> >>>> Radovanovic, Aleksandar <aleksandar.radovanovic@amd.com>; git (AMD-Xilinx)
> >>>> <git@amd.com>
> >>>> Subject: Re: [RFC PATCH v3 3/7] iommu/arm-smmu-v3: support ops registration
> >>>> for CDX bus
> >>>>
> >>>> [CAUTION: External Email]
> >>>>
> >>>> On Tue, Sep 6, 2022 at 6:48 AM Nipun Gupta <nipun.gupta@amd.com> wrote:
> >>>>>
> >>>>> With new CDX bus supported for AMD FPGA devices on ARM
> >>>>> platform, the bus requires registration for the SMMU v3
> >>>>> driver.
> >>>>>
> >>>>> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> >>>>> ---
> >>>>>    drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 16 ++++++++++++++--
> >>>>>    1 file changed, 14 insertions(+), 2 deletions(-)
> >>>>>
> >>>>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> >>>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> >>>>> index d32b02336411..8ec9f2baf12d 100644
> >>>>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> >>>>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> >>>>> @@ -29,6 +29,7 @@
> >>>>>    #include <linux/platform_device.h>
> >>>>>
> >>>>>    #include <linux/amba/bus.h>
> >>>>> +#include <linux/cdx/cdx_bus.h>
> >>>>>
> >>>>>    #include "arm-smmu-v3.h"
> >>>>>    #include "../../iommu-sva-lib.h"
> >>>>> @@ -3690,16 +3691,27 @@ static int arm_smmu_set_bus_ops(struct
> >>>> iommu_ops *ops)
> >>>>>                   if (err)
> >>>>>                           goto err_reset_pci_ops;
> >>>>>           }
> >>>>> +#endif
> >>>>> +#ifdef CONFIG_CDX_BUS
> >>>>> +       if (cdx_bus_type.iommu_ops != ops) {
> >>>>> +               err = bus_set_iommu(&cdx_bus_type, ops);
> >>>>> +               if (err)
> >>>>> +                       goto err_reset_amba_ops;
> >>>>> +       }
> >>>>
> >>>> I'm not an expert on IOMMUs, so apologies if the question is stupid.
> >>>>
> >>>> Why does the CDX bus need special treatment here (like PCI) when there
> >>>> are so many other busses (eg: I2C, SPI, etc) that don't need any
> >>>> changes here?
> >>>
> >>> AFAIU, the devices on I2C/SPI does not use SMMU. Apart from PCI/AMBA,
> >>> FSL-MC is another similar bus (on SMMUv2) which uses SMMU ops.
> >>>
> >>> The devices here are behind SMMU. Robin can kindly correct or add
> >>> more here from SMMU perspective.
> >>
> >> Indeed, there is no need to describe and handle how DMA may or may not
> >> be translated for I2C/SPI/USB/etc. because they are not DMA-capable
> >> buses (in those cases the relevant bus *controller* often does DMA, but
> >> it does that for itself as the platform/PCI/etc. device it is).
> >
> > Ok this is what I was guessing was the reason, but didn't want to make
> > that assumption.
> >
> > So if there are other cases like AMBA, FSL-MC where the devices can do
> > direct DMA, why do those buses not need a #ifdef section in this
> > function like CDX? Or put another way, why does CDX need special treatment?
>
> Er, it doesn't? The only non-optional bus here is platform, since the
> others *can* be configured out and *are* #ifdefed accordingly.

Ah ok. Also I somehow missed the #ifdef AMBA there and thought there
was only #ifdef PCI and the rest of the buses somehow got it working
without having to muck around arm-smmu-v3.c.

Thanks for the explanation. I'm done here :)

-Saravana

> This
> patch is fine for the kernel it was based on, it'll just want rewriting
> now that I've cleaned all this horrible driver boilerplate up. And
> according to the thread on patch #4 there might need to be additional
> changes for CDX to express a reserved MSI region for SMMU support to
> actually work properly.
>
> Robin.
