Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D755B2358
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 18:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiIHQPG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 12:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbiIHQOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 12:14:52 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7974D249;
        Thu,  8 Sep 2022 09:14:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iRFufvCZUeUDOQJRnxng9G3ynBf9d5LmYDnyRj+4X3sbvRGlmFEA/WVx/vOEtUabvovxNpZooT57GrKK/yfD1oGI6Uhh2gSp3fvCMD+vriCHmHAPvre22nmfmFfCgH73sDw5W5ZkFgApnLFMTUgupwLbkzeinleOWsB+LBSjy1fnTNnk6p6nH7sP2XS6tWy8+8aVbPBcFU5LuMWJ54/vBx4W5lBBE/tAx0y3UURhZe08kVWrZy0aE0kaFUxNkq+64m/mBtcF9qwru7K/NtE/EYusxHzHLSRW9wiFmF7kucXrh7YTRpCRT8DKIlxiCcnS50ah1RMUyvgKHOAQLaXo3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yJF2EmhiFTi6X5MwBd2ldmxkE6wrBxgYe+fji5XwIS0=;
 b=FCgjNrN/jdCB6mexx2ALaQzVfwZoFxw0YQjIBc8fzAv0s+rRE7YvszcyQ10EfuUecMr86CWNid3v9zu9blDe8svRZoCVCF6Xy0KnD8LC69inrH7yHgV5+cY7mjPSg/mnLvaramLtTjz78nmQR5K7WWGIElmBe28KoVxB+tsG6nB0/gNu55h+KguY9gU82nx6Ji0SEZfICzifH+g+AJxRkx5jmw5D6s6V4SeF585V536uWESrmkDGGEKFA+pPDcYj9r9VmF+1YsUiZcU5oMevvbar9JT+KS5dD7/MHl+AqNQYefbVhEgmcd1FMAiufFLzBfrIwdTKhemGhtAeGiznKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJF2EmhiFTi6X5MwBd2ldmxkE6wrBxgYe+fji5XwIS0=;
 b=Ssp9+comEwxraWD6+6lCCAOeHQ/xCw+7ezoEkPVzzAEVEHeWLnv/udJ7ebeUpeAmuNeTX3LizuGXnFT8DwR700vWRfB9gxfVmTEk/dUE9ZrIMsJd9LxnD0Lfatntz4Nh8GIP95rghxw+3HRTlnUK112RQWlwXtwZqdIDUZdVz4lL1N5MH45PkrPe4J6ZqTPqY37I5M7ScdqlFl9LthVb1npZQAAUlsL0VjYJZ+cpoodoi+jywsKv8Bk+Dvwpz4vkaMqHmXC4xuoqDxtEXnKUGxd6iYgebS2nn/tBFwWhR3/wXj0W8COYFYjr3W9wVlC+sWQPf9uNhf7m5FurmyP8Nw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by LV2PR12MB5943.namprd12.prod.outlook.com (2603:10b6:408:170::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.16; Thu, 8 Sep
 2022 16:14:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5612.019; Thu, 8 Sep 2022
 16:14:43 +0000
Date:   Thu, 8 Sep 2022 13:14:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
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
Message-ID: <YxoU8lw+qIw9woRL@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com>
 <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com>
 <YxilZbRL0WBR97oi@8bytes.org>
 <YxjQiVnpU0dr7SHC@nvidia.com>
 <Yxnt9uQTmbqul5lf@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxnt9uQTmbqul5lf@8bytes.org>
X-ClientProxiedBy: MN2PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:208:d4::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|LV2PR12MB5943:EE_
X-MS-Office365-Filtering-Correlation-Id: f4d7caab-751a-4bb2-77c3-08da91b53d6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /zD05OSIEdRUR4IkCWRwkgl8BMPaJIl9ErhfUPpSjqBDvEwzhxCgdSj6f2lOwdusVXu+zoF3GjjpcqVte5jsblUzqNk0ifCKFZUdniPgbYBD2pmAn8oniGMUXdCa+cwXdzilCT9ucfBS+AZctw2Pe/cb2E1uuUuFY0ZOMY/yg9Oe/RhoTsXa1s775ha0FIW9qWAi9Cd5Vic7TENvAdCXNI6VY9NgalCDXXvAzQ2aFw7PXGAcuXqDWHPk3iRDY1W5ecfYhVtfysT5g2NbxN8QZliV/5LG9LTFqoLrydrPA2izokmM7BrrEViGK2qosQc0js47O67HDwibk6Cin2T11HmWOoj07EB6Hmj/MraDzeZeMN9bPgFfK+XsvO8rqLtDGCBs2fkKE2GcnAQyNfp5T1aGeWVUd+3gNlFjhxu1H1ivokNJLU2ekj3ZEnkvgzlfRMfhPRyiWN7SRYHFgCHB+XoKmHSOT46JWrP/oOTEGUMQCHoIfVwlmS+fOaMSE+n5TPTItqXpRgGTD6qDKQ8q3PoOXuc7Kv2x8uO2fXrfUr/A7L158cPB8yFluK2qxv5QcMB+Iwbt8W2Vq2WcTdQLs+Qkd3A6sSZuCudbwuhPO35Ti2miXMoGim/dgLgY1/TwDlexmYHMoMfu/DcQKeajQcrR/5F8T67flC8dCB03p212flUQBFM526CcmVr6QECZQipZ/RjdjjoI1Uws+Q4VZVfccD/uK18R85xoRHCLqf3OTaIlObbK4TfawWsorZDt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(86362001)(83380400001)(6506007)(6916009)(8676002)(316002)(478600001)(41300700001)(6486002)(186003)(2616005)(6512007)(26005)(7406005)(4326008)(7416002)(36756003)(5660300002)(2906002)(38100700002)(66476007)(66556008)(66946007)(8936002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rgHdQNvKytT8KAjagVLrkQzSXmc557KiaR+7oeg/yK6pqghbhQxw2c2txssU?=
 =?us-ascii?Q?3+VLiAnjLtudsMQGahypFfA2gzFqNL5wvfknWF7g+oNS5SSgOQ+oGC2b0IFp?=
 =?us-ascii?Q?JtKFhJVkDdNnlMG9ECrO036HYhtakKrHDx2Z/L86Doc8imhGv4ZXUFCZF1hd?=
 =?us-ascii?Q?oZwmuLmivheuSjx1QFW3wb03Ns0KLUmLcpAHj/UXMyGON4ZwDarBdCBQjrB4?=
 =?us-ascii?Q?OXHjbfub6x+KvTyaNymyVSU2HZF/Vw5tGV1s8s8CktIhDaufzCUl13aR9xnh?=
 =?us-ascii?Q?1rFxO8zHaPlhKf6ZslxoVUoapVV8EGJAolCTTrVL+f0xzhAzXGgloiaFLz7U?=
 =?us-ascii?Q?V+CbTfdEk3XIWecvhALALdA707ptW2aXgnJVvJZPU1dZ/JGA/QU67FhTgpY4?=
 =?us-ascii?Q?Uy35aSaCbDDhLNaVASGPWdjV1dRCEiRSkHKcpievWmisHzF05mIbrAwZ9sGm?=
 =?us-ascii?Q?bu30UTsMwdvMqFGUYO35hwPcpPRGqPRP6HUJqe6aE6gw7HQ2HhreroU49tjL?=
 =?us-ascii?Q?HEssdJzeunJXRDRkOvM7UJ86WUELcu53T6XlCKyvj3ihNpD4lhFwzVktakSv?=
 =?us-ascii?Q?i0uxjrw8nj0OAxe0bFiNDEMLEApw60FwWnXIa2of5t1gMHt1ik3uN4gJBIKj?=
 =?us-ascii?Q?4mEaQa79VTlNqtapv3zM6374VdkvwDSptlai3txGLZB17DSBOoeYMT21zHr/?=
 =?us-ascii?Q?fU/tAOLunEOzcV9crso6vbiVz/HVy5bnA7lnos15xRTqEaaXe6cMPK34vqrs?=
 =?us-ascii?Q?tqPBBrQNwhwlMcA6LrRzIL1Tzgyg5mg8FbTU7uxCi1Xsi2/QwEz8ciVln3CK?=
 =?us-ascii?Q?xwX4E1HpkovP73Wb7QqKBSC+ZVx0igzK9gkvIYI5CNy3ikt/DP5p5NTefwz9?=
 =?us-ascii?Q?LmEy7MouknWYjkZ+jJCwxvzfUxpfTmr7zZNwXoydWwiGFOtqKJVHGX88I5Az?=
 =?us-ascii?Q?VJX2Mlstn4GMALkVU7wpMwIG9CQTUc3iU0/IqN8ZCn+//Wn+OkTxgcwAzIen?=
 =?us-ascii?Q?bQ6kk7L7CG815H80d0lz3yRn124PxVaVTGF22dM1qzIikO/IqlR7amJ6tWTf?=
 =?us-ascii?Q?jahu7FKa2mJ1sULvdZHESpEvQQQcLjVwN/lI0ILfWdsagv7p79j+fzt+l6EF?=
 =?us-ascii?Q?KkjjHffys/FGPjj3VY6/ypEpKh2HyHjVKbqnXW4CIuuZIuAeLnRP4sLOHlDr?=
 =?us-ascii?Q?hUpIy/8LcFmaA4IC0kcRCu6IYBDJ0IDidtlyJMDu35dXUSdbCwdYyPbkdJ14?=
 =?us-ascii?Q?bdFkXiYIm3/AMrzkHFOLrojoPkoSa4zOKdT7qPzKmtD+QHJk5XOTHpB0XPML?=
 =?us-ascii?Q?+UHzUKhXS9bJjdusSti1GlY1JmF+S9Rg5MCDTowo6+TzQarcSmZO/+RCBadh?=
 =?us-ascii?Q?EJuMQ11InmWSvEB2QyXbee4kgKeY/PbBrIVmKNMvj4stC3eSL7RozelVJoVo?=
 =?us-ascii?Q?44XFIjdeEZnzdb09qPNGi/njjKZMs5NwMWb7/P9cYCbh5HE/YdByp81sZO4R?=
 =?us-ascii?Q?XGP/SPYdsYe0NC1ckgCqwSjODinCei388QaHjjfPvUUuCCL1mti4yw3Oyxit?=
 =?us-ascii?Q?05ioUHbQNV0+Gdtj0X7l0FouBL3t1B27UkTjPN6q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4d7caab-751a-4bb2-77c3-08da91b53d6f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:14:43.4200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hov2lXuRoI9HiQ5O5iBgBzBu+ifG5c+sRk5XINO5fJejfnzolvke5urr8RtE47as
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5943
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 03:28:22PM +0200, Joerg Roedel wrote:
> > It has been 3 months since EMEDIUMTYPE was first proposed and 6
> > iterations of the series, don't you think it is a bit late in the game
> > to try to experiment with rust error handling idioms?
> 
> If I am not mistaken, I am the person who gets blamed when crappy IOMMU
> code is sent upstream. So it is also up to me to decide in which state
> and how close to merging a given patch series is an whether it is
> already 'late in the game'.

I don't think the maintainer is the one who gets blamed. The community
is responsible as a collective group for it's decisions. The
maintainer is the leader of the community, responsible to foster it,
and contributes their guidance, but doesn't bare an unlimited
responsibility for what is merged.

In a case like this I am the advocate, Nicolin wrote the patches,
Kevin reviewed, Alex ack'd them - we as a group are ultimately
responsible to repair, defend, or whatever is needed.

> I am wondering if this can be solved by better defining what the return
> codes mean and adjust the call-back functions to match the definition.
> Something like:
> 
> 	-ENODEV : Device not mapped my an IOMMU
> 	-EBUSY  : Device attached and domain can not be changed
> 	-EINVAL : Device and domain are incompatible
> 	...

Yes, this was gone over in a side thread the pros/cons, so lets do
it. Nicolin will come with something along these lines.

Thanks,
Jason
