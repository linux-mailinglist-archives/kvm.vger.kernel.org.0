Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918B855A0BD
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 20:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiFXSTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 14:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFXSTu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 14:19:50 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 071EE517FD;
        Fri, 24 Jun 2022 11:19:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GRAhNLug7T+/YW/+hosgjl1YfkLUg6AxXpt1BP3EmArvfvHxkaCOH1ZBomlsaW6+X2DkUdJZuXc6bfSEZT0wcpBluYwypPvtT7MRIUt9duY+KzvTohvg/h2dfn11o0U0ztcfCscSIjomq7VBvOlOOLwJC1/ttrXLVJd1SJa1qOOScCoU1vJeaN56nWyrnyhMZ9Wfa8GIr2DuQW/pVWVJg+L4Bwv8HaTbOHm3zKiE11QL+cHFlB/mBDFKt/Ybd9432k1jAWlJ0pjuwQvvFJZxlzzqMZ1P3XsSlgc2stgwqJPwpVU68s4UlymZtQoOEexbKZRj1FOyRNSa25jtDd9nyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UIH6qDZwRQxl+EX85gcxPoH5qPsK4raH09bpZkupQg=;
 b=E89EdXUFu7HU4wz7y9AZ0fReX0W/EDtROKv087a1AaRx8/jm0XkiiC8ADxAsCWHsB2y55nKUMUf5qucdqkUuVWj97AVo7lopDsIUqqRB9m8A3h7foz4XTP/k+4kYY2SfsY6KREcTBRGifwYnHdq79Aq1h733O5Rh6HoQ56l7FHmgC2GA8Yb1adfQYzXVxUtORKZdboScFs30aOd3m6eMlfxwCOmUsLFyVRGdhWT7GAcILRKUlPcMxgpd64adin++qrOeJbE4pVFMIY3KefwIrEMUl8zXwhjRZqQVM+0uGfNA5fQar6KEgF9mGEqn9rrDzql7k7w0iTarB6I9qlmthw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7UIH6qDZwRQxl+EX85gcxPoH5qPsK4raH09bpZkupQg=;
 b=ckWz4Ggse4TgieXoe5uLznT8sOy7iwbzBOxLGoCxXqCSniyo2T3fECjrgvmry3QAx668vQjzcmuOQV2lRnCvUva6XPj2rShCDTfJmMkw/2TI42FStlRxzp+zulDdKR/ccVgt1VdH1ujOczanWnq39OK+8VWKF0NW/aSV3Sf4USZlHDekeU1rTGD9J082CMo4boiNPHRhw1af6XgTdKOA5i0zSP8cM5jI0W/VHsyvHzQtQur1n+agQBCLguNe0JQ4mSS/mlf6bHeipvAenO/oRN7ij/jdZ27jTPzZZ4Q2Tyzt/2T523IkI9PuV0Ng8k6has6oDTIjQoql8oipHKLL2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB3226.namprd12.prod.outlook.com (2603:10b6:5:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 18:19:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 18:19:45 +0000
Date:   Fri, 24 Jun 2022 15:19:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yong Wu <yong.wu@mediatek.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Baolu Lu <baolu.lu@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jordan@cosmicpenguin.net" <jordan@cosmicpenguin.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "will@kernel.org" <will@kernel.org>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [PATCH v3 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Message-ID: <20220624181943.GV4147@nvidia.com>
References: <20220623200029.26007-1-nicolinc@nvidia.com>
 <20220623200029.26007-2-nicolinc@nvidia.com>
 <270eec00-8aee-2288-4069-d604e6da2925@linux.intel.com>
 <YrUk8IINqDEZLfIa@Asurada-Nvidia>
 <8a5e9c81ab1487154828af3ca21e62e39bcce18c.camel@mediatek.com>
 <BN9PR11MB527629DEF740C909A7B7BEB38CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
 <19cfb1b85a347c70c6b0937bbbca4a176a724454.camel@mediatek.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19cfb1b85a347c70c6b0937bbbca4a176a724454.camel@mediatek.com>
X-ClientProxiedBy: BL0PR02CA0140.namprd02.prod.outlook.com
 (2603:10b6:208:35::45) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 679366d3-9649-4951-b1fb-08da560e1dd2
X-MS-TrafficTypeDiagnostic: DM6PR12MB3226:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6DZCAPP3pUMHZd/Tge1xp1t1I2CxVviKlunL8W9ODliLVTvCz6s4qESoA+ifzcFKFZn/V7hY3JQyYy1t72SWtRWPNzZr7A7nHPW7NM/obkqQbOzMRyc6eBirzq5mK3oT3tDVe2nzWmcc5xXNxKd+b7kDzjLvc9dRFaTxCDP2rRzw1C/bZQSXgsaRDszIumvchJ2pulxg4dbbPQznvt7Lh9sIA5RcBTdqYTaMraY4eoicwdG57m6r7urJstWRMIOxiSVlnlKz/r84qj0RRYes0m3VyYbwv/36X835X4Oul1GKY42ACbcSoDyHp6jRgQtkywMd8/K//qdt+uumKM/iqoP/YfiYCObm86IJl4pjDkf9cYx2op3lHD72jO18Hm5xUJkULZvXLdFQc0mQIsAQra9tG6tE+EOQtkKsTBluE2JgrUtqBJHFz6oM5Kll7zrng4oaSEIo7dTDWwstszM8KCRpTZL9DpAtQ+ALUxVmzXX7XZ/9S7JRyPgFqjS5WLk5sNgI6IqKPRo/QhKVn2s6BRSu5haMcc7fQj/gz2rFtxje0xtBbJusLDK2CF5ulygPaTQSKVbqAU6sZMGD98VGBjlCTINKtZ4QYbKaLHdsmAW3oBthHK3G7obfwngbkUxMSN0gKl8cUJe+q8o+k15SDMMRGAKxi73E4RqWnzvA4XnmsHoxMx30cww77Mc7lks6WaEvaI6KoTYAs6Yji22UE90FbXhtObLucCIj4GnnidLOZHHvwsF06t+JVsOJMg8b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(478600001)(7416002)(26005)(33656002)(6916009)(316002)(6512007)(8676002)(38100700002)(6486002)(4326008)(36756003)(66946007)(4744005)(54906003)(41300700001)(66476007)(8936002)(5660300002)(1076003)(66556008)(86362001)(6506007)(186003)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?44jEtv6BKOPtY2NCOAGioq98wrfvnPGPIKmJIEreCBRoSQzjo2sDDxm4mGU0?=
 =?us-ascii?Q?OWwlJXkrRSbg/cyUYvrStiYDRTR7WznhgOvO0yQl1NblweSW0+HptcKpi0hP?=
 =?us-ascii?Q?Zco+nW2OzNMy8qsX2l9x46+SS1pZ8UjdnBoNQx0xOfpOAonM+xh+4YrL5exG?=
 =?us-ascii?Q?PBmdoIDYkL3/ONiU0ywM6afUpno8qM+AE0SjjRrY4e9CUqHd9I/orKBLPUYE?=
 =?us-ascii?Q?UwHwY6aY8VkhGjam3qGC63LwKKLGcWpWHnZxdSxsbnqsbcGP6ROg5/Lc7ygQ?=
 =?us-ascii?Q?927S4OwKRthhZdEDEVFelETja+6MoKtuJ7/V7oNv9k/S8oanQRLal9q9R0IR?=
 =?us-ascii?Q?jPBmMCc5SKzWTuXUk58Q4ittLwvHXsgLLuHxAhMowRUu2Yixrep3homC4sFl?=
 =?us-ascii?Q?fttl/dY6EezqZfAj0hVDTMbW36xlhwPyv1/NAix6cZmea1X1xMKEuUzxT2A1?=
 =?us-ascii?Q?5V18/wO/AWp/9VCaJ4NUsoCQkA2PzyeuHnGdY5Eynd56GwYymURMt8LV/CMJ?=
 =?us-ascii?Q?npOHAANM1jTjumeIqL18ElMRhXR83+ojsAtPqMczKf/bDLMMMFhJOtdVzGqT?=
 =?us-ascii?Q?SOzbtzfYxCW9qyU8+OLWSMuBjNxmBpc1dlvLoZy8iQBywCy/0C0/RtezDMK7?=
 =?us-ascii?Q?nwpwVX/lKdRPEGITGo3MUk8MYtsAfqVs+oZRcUI1KNPgICQIb8v/KL442HBj?=
 =?us-ascii?Q?i6uZfAKWzE3juDxwRUx/O+xQHtEJJOEWeiMtEhIC3y0TXiXNWtfbxMuEFpiV?=
 =?us-ascii?Q?oWD3vTWcFpZECcXvU+T7EUxGp5Vs1+9+P9mQM6cGm6TslX4/egoE2WoiE9xk?=
 =?us-ascii?Q?GY0n2tTFDFwdfChWy6DZ+aYgbDzqIuGdI5JozPqzI3Wl2twBgu7rMmYwcS8k?=
 =?us-ascii?Q?fTAwwSaaD9vxj8+dSkjlYJs8Axmm8sJHG6IMeLc+XChaRK5QxEZFMElKhKWH?=
 =?us-ascii?Q?4PV0Tbm91S5xQQj0NtZuCn9szYsschmmhPdn7gzDbRL+4v/EllZc4QP0q7Nw?=
 =?us-ascii?Q?Dbj9Vgnfusb0zsXfSQE7DSTgIPS0iRTvor3tIXOCif7ooZgXhSJrwUyCijAS?=
 =?us-ascii?Q?jAkqibbP8sSG2CcAj4Q82xEGDUfq8KAuyAFBkD0gYhXFRjxEQOWlcCSpxndv?=
 =?us-ascii?Q?r3ni+u/romRAy1MsnKPlVqEvZ6Dv7nE4csh1UhgGlUS79g1a1tvV3cNeas45?=
 =?us-ascii?Q?U1lVTuRVSOwt+idN9BLY6D++hqw1VTscQjkVxXKwMJ4pG+SYWULNcu26fzEE?=
 =?us-ascii?Q?Z9b9w46psDeNS4r3SlTNemFYWBmBIwTdOb83+DB6UCB31Qi1xNnUymt2UOZm?=
 =?us-ascii?Q?WmY555doUvPhRmm9HvgGLdFegwvYy5scG3cjiqQxYOXGYgpIRoE+SlKsm1SQ?=
 =?us-ascii?Q?mwxal6REIOttD4Qj86ULxZqz95PtN2GB4LSwsWSS3vF16az6dZeqrZQUcr2z?=
 =?us-ascii?Q?kxB2QDCEiIN8MdSUqukM/hF2EzRwRwlBQCoA3DXf1JvSLgUnJMnztNiCxEN3?=
 =?us-ascii?Q?XENkke49PjQWbm9ktZxdSOk/eVAOLYjV3H6pl0lXcfAvXVaL3XmCXXY9VqrT?=
 =?us-ascii?Q?XSLYpxYF26Y/Fz0IYoVo+UomXgkgNvaJwRUmxnz1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 679366d3-9649-4951-b1fb-08da560e1dd2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 18:19:45.8568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYKKJhaW9IK8t57BrbT9PNo8zU/WE4ASoebWR8ow4F0GWGMKXPrDe6jGwLysmqLt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3226
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 06:35:49PM +0800, Yong Wu wrote:

> > > It's not used in VFIO context. "return 0" just satisfy the iommu
> > > framework to go ahead. and yes, here we only allow the shared
> > > "mapping-domain" (All the devices share a domain created
> > > internally).

What part of the iommu framework is trying to attach a domain and
wants to see success when the domain was not actually attached ?

> > What prevent this driver from being used in VFIO context?
> 
> Nothing prevent this. Just I didn't test.

This is why it is wrong to return success here.

Jason
