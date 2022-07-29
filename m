Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF67258548B
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 19:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238194AbiG2Rdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 13:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiG2Rdn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 13:33:43 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2083.outbound.protection.outlook.com [40.107.212.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65D284ED4;
        Fri, 29 Jul 2022 10:33:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVGfVC/514T+RR27Krz2fccEn6mw50PpsX8Tzazn4kZBLYC/kShWoaiIGV7i4NndXxFQ/TA4+IV9L9A9QwGS3VJKbxJms9MLGU9o8jS4s8VOGUAJg7dV5bkU6zhTxlJujdr55N4phyUphOv83UK1zo7Fbg2jXHi3StQSuJPsIDLr1CvxHn4fs0PGjAUnaeeOSuEZnmJpALECoM+8n128mkV3Bff2ZpBZRljrMRAkJXUh0wXe9THoHJefugTwzlBO5MUUrvVcZZhjs0xA1DoUrGNhmOGOCWyIdjJLBSi53LEr3xriq6amz3KmIuX+UZ1ELIwaY7psGtzZ4MUxrm/slw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r4fSlmA3WBVdbx79+2WbE+mddgfaXaZ+H+pN6ckVPf0=;
 b=fNrGmJ/H8VgjraNdNCFYNG0vkx6Xde0BB4WVj2W86cJjFC8rXmB1maTbCHB6LEEJsBiH8s/A7bcqNSYTp8d6YxA1eCPsHJcg/qSWWVT66oM7k0XDPxOuMDYnNWFIyxjCUhJxJ0RmaMcO6F7JCO+BsBmzVMkmaPJbX13qCcLCNKhdN+hDvdXG8q6qzW33FmI5NYOFzvBbSLTHLFqAIu4nWdQW0CTWs77/qsXKUU++YgPV4UKzAfDbMvEA9lh2LpVqnOivQHSICYqbMoguHjr3171ijN/7xhiEjOZhhzIarEuMIQgvKLupduTrletDAu+lGsOS9UXngSAn9UBqv26oVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r4fSlmA3WBVdbx79+2WbE+mddgfaXaZ+H+pN6ckVPf0=;
 b=qf6OLADu6nEHKUpMrmD1UyH+3oq+vg/Amq0nNF9xTonYny0iWBjlm0H8Y6dUil0MkP4D0AC7lArFPEL9ABnIczw0XjRSIzKWVyiRWJSD8abWWudHjmr88u0zpzdOR7A98Z8ei9fsC9M+FPh6MJUMLpVBUExAj9H88G6pn2I3linbaVggcJiApgaAMgr2xW5Rr1V8Q+Ic3LldUZ2KuP/GpA+9P8+tH9TntG9goCEMdJ9VkTb87NYFxYM/QWLnwKY5pd1tRXsaN4VIS+XAGEksNAGT/PowtUtvKCeUmBDD4glZGFoIS+qidXM/7ZvCM1XuRCO4ouj1Caeh7SOJLlQKjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB6561.namprd12.prod.outlook.com (2603:10b6:510:213::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Fri, 29 Jul
 2022 17:33:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.006; Fri, 29 Jul 2022
 17:33:39 +0000
Date:   Fri, 29 Jul 2022 14:33:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     joro@8bytes.org, will@kernel.org, marcan@marcan.st,
        sven@svenpeter.dev, robin.murphy@arm.com, robdclark@gmail.com,
        baolu.lu@linux.intel.com, orsonzhai@gmail.com,
        baolin.wang7@gmail.com, zhang.lyra@gmail.com,
        jean-philippe@linaro.org, alex.williamson@redhat.com,
        kevin.tian@intel.com, suravee.suthikulpanit@amd.com,
        alyssa@rosenzweig.io, dwmw2@infradead.org, mjrosato@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, thierry.reding@gmail.com,
        vdumpa@nvidia.com, jonathanh@nvidia.com, cohuck@redhat.com,
        thunder.leizhen@huawei.com, christophe.jaillet@wanadoo.fr,
        chenxiang66@hisilicon.com, john.garry@huawei.com,
        yangyingliang@huawei.com, iommu@lists.linux-foundation.org,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 3/5] vfio/iommu_type1: Remove the domain->ops
 comparison
Message-ID: <YuQZ84dsHASENfmM@nvidia.com>
References: <20220701214455.14992-1-nicolinc@nvidia.com>
 <20220701214455.14992-4-nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701214455.14992-4-nicolinc@nvidia.com>
X-ClientProxiedBy: MN2PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:208:23a::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1733d94-0eae-4f48-2c02-08da718879b2
X-MS-TrafficTypeDiagnostic: PH7PR12MB6561:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RPqZrg79gGvYVIKRKyfCaR3JGNSgiHT1+FBg7iQWDF1qJxSDO5SdyiFG9/i387z1jD+nrsYXtEcpgxcftEsdjHBBJKTUkMldx2+pctqR1zOMJ26tY2pDapUn65OskQ15DkfoPWBenQEp200m0jnb4Q5QcuxvsVsre3096WNb0wO34qTO3mAR9MBix3N9HCglBQhDXPuGijbu3NNZhwcePgky8XQF1lrlpcCgUf/juvtj6HS9hAF9Wd1QE2j5FMLVGVxNQn3o2E+VJXLPLUEVd7MKPOOq++oNKKxj6uC0gHcW2jroOVVQMnoVLI6pMVIV5N5WXRnEVtiRUDY+BHENGYSp+U2n8jMYh18N6tq9+JZJdTWNrTFBlOT3B44DJqSWK+byGqCP/CFiHBsBOVA3wWxNRbQ2S88w6sI2zs87fxV+MKpKfEqNxrIdWwWEvVo/pZkSYUEdCrTReVtzrUJoy+0imYfge91NhqJNmnyC+hizvMaBFKjoVnkkPxvX6kuW9ZOussHkaVh21HYEZBLV30D8QY/w+ScDOE7Qk4/wQSmtnbIepaiavtE3LX+lGSMogUAcwIskNy0T80JsCwUCk3OmiTzuemghvpq5njwPt1wNcEGq9e1G4mADZNz8Wz1NoHJ7SLxCP/Jlg08JNRIWx/dRhOk5KTIyUp7E9Wx81MWxvC1n6d35rtcMna8nfO5VNT26Gf1iNxBvEuZVGuBilqSighMmfBVeMQDZMJtBMtPxjX+247utEvRIwG0B1wLpsFbCO7CfUNqxiclNgfhJxzBfzopeakiteIUFxZVnjOo7pVHQPAcMHW4t4/pCd7aMWFGwrPerZL1dIRXWX1E+hq+lw5qy4+WfkEOUsW00DB0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(38100700002)(7406005)(8936002)(966005)(6862004)(7416002)(478600001)(66556008)(41300700001)(83380400001)(8676002)(6486002)(4326008)(66476007)(316002)(5660300002)(66946007)(2616005)(186003)(37006003)(6506007)(6636002)(26005)(6512007)(2906002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SxT1ZhZZSW7bTCva6Ijg82SLU6i2PTcht0lQrugHQuIkCrZR8qRlpki8p/Ci?=
 =?us-ascii?Q?8Z4/cHkSKbzesowKdBWyGeuq3qNp40QcC4XdwPJcTZo4VTftMCA2Lndjma3j?=
 =?us-ascii?Q?UgtIByIO3X57azpsnR3Jxt5RuujTNAlZXiJf7FlN/sVL4y8nX3XZ+j0sgMU0?=
 =?us-ascii?Q?JHwqxh9PyI3VpGd3zb500mRvqilyIJ5pRjS1oevq0qjpX3TwDTDzBIy1QTjF?=
 =?us-ascii?Q?Zg8y6mlNM28MGzPCPU9dY4lw48nGcjKxhfT57hWTKaKxTGtAo0/HlQ29Cx2I?=
 =?us-ascii?Q?t62EZg7n9d/DoY2SWJyScdmGiofFFPnVEOOvNDCA1sBIfDyfcOAuH2vUvAcU?=
 =?us-ascii?Q?jzTWgZm/f7fluGqRFjELUe/KkvYJgpLwMwXkkW2Z6bynOWxKhhOJiX40vWNl?=
 =?us-ascii?Q?OKUk0NBczNylMVR8yNNH8A8ol0U2/iupCwB8msIyyGf5dY6JkxY0EOxuK5Uv?=
 =?us-ascii?Q?MkYmb/JdRlgKTZtDvuXDxXbD/YnS1cqiAppPAV1z0xluUX9oLC/tdltDbwxE?=
 =?us-ascii?Q?TIycI3JlSzMj87FJ6qhgZuqU4liF+rvie/Nxd8nWn8Fww5BYDT5p6C9oPFII?=
 =?us-ascii?Q?emWOjzCiOC9lZm/GVhLi47LVXiji/R7IqW1t8OG2KPlwb2pJw9EzlJ5+/TRj?=
 =?us-ascii?Q?pc28rCOfVJVqEw0W31wlYAYzRoi3KKOHkVNBQpNzecaZ5yDsR4v1z4Irmglk?=
 =?us-ascii?Q?JSeG0SCBAqnFUj48vj7S7Fg+aePkM2m0BRuoOeW/fjimaFjDZ7R+7rIU2wt4?=
 =?us-ascii?Q?icNXdNdJZ6TvsJADQbuJh/JEi7oy2EeDYBNi9gnkJUDJ7nSg5U6ek/NNLpec?=
 =?us-ascii?Q?piU/cOdq9BZdcFC5QodVdKS5u7kSmw0o57NK0tYaBWMkEOw5osqdP6jwbxZQ?=
 =?us-ascii?Q?ULfgsCCuQGjTqduLYWaxS1s0o/i3Iu3QS9XTjw1MpDEjpCDPbmCaudHwf9Yw?=
 =?us-ascii?Q?As7X1ll4HpT2xgG0sOlwXpVcwDlPlLvLUf0MF0j0ybgvYEvu2ReQ8wHagFXl?=
 =?us-ascii?Q?aNf39XIIGDD0RdiAJTp2atMcRU5pWqx0UxuojYfLqfflhdS2JLyvUhGX3BBW?=
 =?us-ascii?Q?SDtpsHvp3xq9S7OZS0vvc/28ig2phmd5pA58/bpnDC8QywtXDAuDnvfsPeho?=
 =?us-ascii?Q?QQlh2+RL04L0dhWK+4OwAZqcKLA1qS3pLtOk11lWG0opp6MXSdpOrUJy9ciM?=
 =?us-ascii?Q?/VuQKhnS/1K0BGTD7dgeJGdfp4YLtz8/TQ7PJ+5RqODKSyceG3ZnVCyg1Zfv?=
 =?us-ascii?Q?VqKwRNF47RlSOBLiyt0e80gzUrnPcWUmEsYet4EXn9Pr7/ca1nPk45vUEbmf?=
 =?us-ascii?Q?t0Qu/QgFEQ7Hv4++Yic8HltdcXcejV4IaJfYSF2CJwCl04Yqtm+ot5LWIzvv?=
 =?us-ascii?Q?IpCsua2TMY7EBz7kdqNWiCwyVuilke6WjyS0BRCekwuzRcBYUUXQAJ/bBcIy?=
 =?us-ascii?Q?PUt6Ul/xJxh2/VrxXCW09BdYD4F1cW+rqZAqet2f8tStEeXSvfP7RZtx8g23?=
 =?us-ascii?Q?PQKAnvUVRcNak9SBGWsnhX64mJ/ynLFaG6cSIHAODTLWSzHFlW5p1csYx3te?=
 =?us-ascii?Q?W5bqTMPnSGfXkGvmzrZgUpi0mbo9CHnHpDlCKO8l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1733d94-0eae-4f48-2c02-08da718879b2
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 17:33:39.8651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hvuk1+5hMQC6ogTl2SjShewy23YSXdvMpja/0EK44ci6Y1vwb6JvCpxoAaPVb3hY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6561
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 01, 2022 at 02:44:53PM -0700, Nicolin Chen wrote:
> The domain->ops validation was added, as a precaution, for mixed-driver
> systems.
> 
> Per Robin's remarks,
> * While bus_set_iommu() still exists, the core code prevents multiple
>   drivers from registering, so we can't really run into a situation of
>   having a mixed-driver system:
>   https://lore.kernel.org/kvm/6e1280c5-4b22-ebb3-3912-6c72bc169982@arm.com/
> 
> * And there's plenty more significant problems than this to fix; in future
>   when many can be permitted, we will rely on the IOMMU core code to check
>   the domain->ops:
>   https://lore.kernel.org/kvm/6575de6d-94ba-c427-5b1e-967750ddff23@arm.com/
> 
> So remove the check in VFIO for simplicity.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 32 +++++++++++---------------------
>  1 file changed, 11 insertions(+), 21 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
