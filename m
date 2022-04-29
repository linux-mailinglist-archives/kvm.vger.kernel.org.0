Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBA95149E6
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 14:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359529AbiD2MyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 08:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359511AbiD2Mxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 08:53:52 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2E31D30F
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 05:50:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQlBeY6oL3scVU/Lz+gKWVwihfMpfSo9NWuheFe0MH0SzyCE7kLCcV4ppMO6KoZhCLFVrTCGwZS/f2tKYy0X0Cr8yN+Qe6uo5A0o8n8W1gIOmzX0oLBmkkVBZRRRwd2Ls/T/H8mX7Be30eLFblovwuFe0XBfPSnxywkAi4yBhlFycyLOA7k30C7bPoswysu5GYzp4uuKKnTbO+kbYU25OqBOVBaZXgFkMg5AcXOr1wguAqhnZo+O/5LRzhI5muR9p40eSPHPaEWOmirXhkHYmcMlyHkRESTuQZ2K9Llu+H1oT+kZT0/uEHu8zXRReLuDMPdtEW00va3FWyOXh5zPww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJOrn8vTQr4TUV4/OtCWyUr0n7jvBUEAn2S+grr2hf4=;
 b=Y5JShLB0vdzWOZrzWyNMFllcP3xpNHES9Yi4DLbI2EnjaTMBOX9R7NES0yeKuFK/LrcTek+8eADRYEWQ+SqMAREvd2ZmBFncfIuLmj5R4bIBJn34d0Tq3WrQQ/9Ca9E+Thr0WKqRTT9PQculWPcIQ0E1Q4TvClMHl3m3uT737dsfmAHAInxddlh19r0d46eHfkDdDBS3XZUqvR3mxSme9Da5KnCeq2OwqA2lpRynphQTw4vLT/TOLCwsIZemPvpSht3Rq7WzSFjwKYCfo/pGG4vmwfpbScDoMHIu6t0tASOLvy9FcHIWUE9zzz+pwRTp4i5g3wOBdr5pzGs8/m9wDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJOrn8vTQr4TUV4/OtCWyUr0n7jvBUEAn2S+grr2hf4=;
 b=Lz26t3Sz+hyoKhDGbMANcTyBChD1d4ysDWyHdxnR3edtsQ6We8mtsP81cEW6sugqa06QAZbDPO2gfGeBKkJ5oHTSoxqvDcW/qCqRtCTb4X8fhcM6JADWNGmOTPJc6vlk3sTtThgjmuGD4cvC5+hXgOBAPj3DbWR4hSjBSUNE0S5JdmwN1YrvRJygBg99NNJDMvCkWTYWsbVbYB23M+QEmPk9KA84b9pUYRzZof4ydB9Hbwpr5Dt/hC7tWONAYhbvzrZPZroIy7D0x6+fMjn8SltCUlwswtiiQilbYWcoqK/ZIKk/O2xi9DRAFJtEh2MyuqAUlM6txOmUx0tQkliPOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB2375.namprd12.prod.outlook.com (2603:10b6:4:b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Fri, 29 Apr
 2022 12:50:31 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.026; Fri, 29 Apr 2022
 12:50:31 +0000
Date:   Fri, 29 Apr 2022 09:50:30 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <20220429125030.GX8364@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
 <YmqqXHsCTxVb2/Oa@yekko>
 <20220428151037.GK8364@nvidia.com>
 <BN9PR11MB5276C4C51B3EB6AD77DEFFCD8CFC9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YmuEQCRqyzSsH270@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmuEQCRqyzSsH270@yekko>
X-ClientProxiedBy: BLAP220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8afb959-d895-442c-25f0-08da29ded839
X-MS-TrafficTypeDiagnostic: DM5PR12MB2375:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2375A72BF4024336239E07E9C2FC9@DM5PR12MB2375.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B3t4xBCII2uyVh2c83O1//Zt4y37R1siGRlHbk2sY81hUIfmeHkxdjx5AOWHV6wm1UcW6/3tlIZBiEultlTfWYFDSFYk3QTnkY+BqIsQLcQ6KC7BsVT/AjvgxcIV1gpOKTx9eSK2NB9sV90Gg5mwquvJptq9rGLAmcdEHDUQ053N9jMxhXpfiDMSok6CywqbRoc+bPBLGHDylB5NvP4VTsk7GXrGGrtenjetm0QjjC9N7XL1V3vXQ7Lo2RfuOC/r03BwYlqGYhR1YQULmDETzU1kJFwL977YH0lHKJ4aM4/FX0KKqXBhVEr+wI4RgUxbgxBxtv6WbU+AIG933wwWIL0h4M8PouoF4XXJ/AZMQ8TQU2MYHHLClqBbykhw9d3OwgYsiXanS6NWrUWxQsTEd/phoYOxapKNzImDlL3YcA5wmMykeIyng0v83a/K6b/FOcu+S3PYgd+xl2MoPl4OF5VeKlPbKvoHtQZ3iTQJVgwNgS3VwUsDGmfZA1xUD50MkvvT9noBYTeuNLsW9WdElqYnbw+5XgZiKO1TG4dsxBJpmxSryiBlOh9btEtmQ71Y3VildcuJh6Z+eAFN3EzRLrW+R5JJzgXHWLvH09Pe4M/t6KEdKldF4Ll9orKluiW6GM6qc2xFuyiopx+vHjp9Cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(83380400001)(36756003)(7416002)(316002)(8676002)(5660300002)(4326008)(6916009)(66946007)(2906002)(66556008)(66476007)(6486002)(2616005)(6506007)(1076003)(26005)(6512007)(33656002)(508600001)(186003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gfLgpIxRGDMVUD08Al1c6QnlyX/tJrrBp43oSGPHlr52D9sx+rdCSXHS/lJP?=
 =?us-ascii?Q?6uc3Mk34wQb2tdVAwHCg/ZBXGXtPvIgl41CwFFQxificDGj6WzRyXEatlex7?=
 =?us-ascii?Q?l0ZwW2aOuCqTuFhkM9WEe6PlWurEp3HkPlKDryi2Kaki5IfvqAE5BYHrl4n6?=
 =?us-ascii?Q?hiynhaon+l0MGnhGKpQA5grEL8cEWAkWH7oem//BHYjFhG8GyYzgE3Yf9k8j?=
 =?us-ascii?Q?fTPsWOVAwXnF6hQTtw26eF/OkhRa0uV8iqng210QWe0rxj2PjzBUCiMiKU3C?=
 =?us-ascii?Q?mL3jfnwKJdic3UPjAI3V+x7Xi5A50ITC7rdLHC7KRWt8/7y7SoSfiR33OW4z?=
 =?us-ascii?Q?j8LQzkUWR6xEcOy1bawOyJqdI8mxeZ1ZkZV4uVWsnzilwmdVis2T4zjC+e+n?=
 =?us-ascii?Q?YjH2gz3al/XeDf5GeZPnTmL//dTk/5avxHYRoSV07OXt6PkwpL2gznTjrax4?=
 =?us-ascii?Q?0UZrnm8H+qeHfOp49rMJFSHCYNbEscv2KcJ95F/UhbZ7eDOlc4VY2O3xLZKH?=
 =?us-ascii?Q?wglFtgLBvc8ny24pmI4WKR+w8YdRU89GcVU6GlfgHaFYxg2UNwCVzHcxRX/C?=
 =?us-ascii?Q?SSbnfX9Jp6kWM+CuRwbKQKYyYjW0Z1ahXwI49T426UAhosvYh5VzlParBlVB?=
 =?us-ascii?Q?AU4OCbF3W22SDOkgeg6jyvqnYNf2Mgdgzk74e58bi70DsYxv7YdB2pTILPrN?=
 =?us-ascii?Q?Yh89EExKaWw95SInrP+65rzF660dur2qFxnlwr/yVoBRKNFzUfq/lEIbfAxa?=
 =?us-ascii?Q?leKOVV7Bqg9hQ0d97t8aYxRwWKlvvXvymzKBeEwZ8o86czsrOCDntWUcxrkq?=
 =?us-ascii?Q?o3E1JUOI3iarrHhtbd6tv4us12Xb673QIO9EOCN2qHMvZb6Xr5B+Qo+N35w7?=
 =?us-ascii?Q?aXppzfwWdwcK00nyJb9SuVb/psHevi6Gx31hM8ygJGu15AlpQuC3t0SThbCm?=
 =?us-ascii?Q?rXHpYIv7lJPndMiV0xz8fj/DOdF0xZsHDi/r5L1XEnCE4XLLD2s7cgSYnmSI?=
 =?us-ascii?Q?rM2Bs/BG7b9tUH4Ivp4TG8NYZe6ZhIB20yUJnLKZDCeEgyHLNdNWzgDilPHJ?=
 =?us-ascii?Q?7qdu267+71jLrC3MaDsfwszzksos4FxP8/188Ov6pudJgeGDh0VsdUiS4kRr?=
 =?us-ascii?Q?2FOljo+F4ZiJaBOeLMDZXhnaBDttCT+47WXnvCdCC06DULXAHwcIr4GasUs6?=
 =?us-ascii?Q?63Vp4VBWQeWTERMRW6XFNY4Nmjcp9T4mu/QgS0AHEHOGMUx5BA49vCv18C5e?=
 =?us-ascii?Q?45wAHp8TbI31dHPOeJDN/UK+hrOt0PCkHAe9DitnCFb85oaIY4PWowct172l?=
 =?us-ascii?Q?D4tm2XN/Vojyj5aTFTbRLcOSot4JAluBs7CdrrbXuqOqH/RA5VceSTdyahMo?=
 =?us-ascii?Q?cXO+0tfAxEcTg2skjtu4cwm2W4wY+OmuBhIksitob1Aug0kDNjbbEhbEdKf4?=
 =?us-ascii?Q?3BYnpXK6lQEYQtVgG+bZn/kV1B0ZENDmgcB4gj8B3u2MJxVMVP8k9n4XrKo7?=
 =?us-ascii?Q?8HUrFkm13ZetLNOO0ZVEqEPjTIZO7HFGttsBQfAcUJwYIA5hm0izx+p8HtNM?=
 =?us-ascii?Q?qFaRGw0xsvV6+V7IAqOVwLy6q3rOIufNuMB8+Lo9wO8nafBKWdLEOFbIyMdR?=
 =?us-ascii?Q?rSYAzRsCSe1Q6V+DdFlbwTrBDbII8vcK6H8wYjgS+bRqdhG0zijkx1twgv1Y?=
 =?us-ascii?Q?jD0U6WanIc6ZcALhSL3IQbNo+Vi8a1IU9g4QIImkZ2kMXykExnrSp9WFeiJP?=
 =?us-ascii?Q?ouHQymKilw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8afb959-d895-442c-25f0-08da29ded839
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 12:50:31.5167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lkgUnoy/ReOKPuUmOA4/mWOhDzchKQoMseREzK1XBeH1VogciYQJV1YAo4tLEnGF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2375
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 04:22:56PM +1000, David Gibson wrote:
> On Fri, Apr 29, 2022 at 01:21:30AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, April 28, 2022 11:11 PM
> > > 
> > > 
> > > > 3) "dynamic DMA windows" (DDW).  The IBM IOMMU hardware allows for
> > > 2 IOVA
> > > > windows, which aren't contiguous with each other.  The base addresses
> > > > of each of these are fixed, but the size of each window, the pagesize
> > > > (i.e. granularity) of each window and the number of levels in the
> > > > IOMMU pagetable are runtime configurable.  Because it's true in the
> > > > hardware, it's also true of the vIOMMU interface defined by the IBM
> > > > hypervisor (and adpoted by KVM as well).  So, guests can request
> > > > changes in how these windows are handled.  Typical Linux guests will
> > > > use the "low" window (IOVA 0..2GiB) dynamically, and the high window
> > > > (IOVA 1<<60..???) to map all of RAM.  However, as a hypervisor we
> > > > can't count on that; the guest can use them however it wants.
> > > 
> > > As part of nesting iommufd will have a 'create iommu_domain using
> > > iommu driver specific data' primitive.
> > > 
> > > The driver specific data for PPC can include a description of these
> > > windows so the PPC specific qemu driver can issue this new ioctl
> > > using the information provided by the guest.
> > > 
> > > The main issue is that internally to the iommu subsystem the
> > > iommu_domain aperture is assumed to be a single window. This kAPI will
> > > have to be improved to model the PPC multi-window iommu_domain.
> > > 
> > 
> > From the point of nesting probably each window can be a separate
> > domain then the existing aperture should still work?
> 
> Maybe.  There might be several different ways to represent it, but the
> vital piece is that any individual device (well, group, technically)
> must atomically join/leave both windows at once.

I'm not keen on the multi-iommu_domains because it means we have to
create the idea that a device can be attached to multiple
iommu_domains, which we don't have at all today.

Since iommu_domain allows PPC to implement its special rules, like the
atomicness above.

Jason

