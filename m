Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D426B7C5A28
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 19:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbjJKRUU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 13:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjJKRUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 13:20:18 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF52398
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 10:20:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJEqvaZNhs6YV2Yw0aC2ML3zf1zyttwDpKLxB3B96rCPOGHUDrmpIRwDLPa4AovLFYcZpT6tPSL+AJtxYdPD1203YWvAFwqyjWXogxaI4EchKRYhT5OrVR1ghOtybKqGZ5oXhAGXmhvW2kV/rMS32ytibpVUvSnEX7CnZskC0SZVvppsPNeAhVfkMNrM/ypb0JtyMYrKjiON3gBWNMPj5LsbfeFCGbsthFts1QIfIHuzI7oI+bqoKLuoejU0y3W3uzujUt884l9XYxm4/2IOx2L86a1jO3D+dhn4Dwjbr3wlH90OdTzsao+ISyBPNmhL8Gb3QCBR7k75Ge26SAypiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6K7v/Ejw5blmpV+uttpQYPVnZv1JZ79516uHajBHd1Y=;
 b=Vv3dOTQlLX0nv7XZh9N5g1f/CRYvZq/Xeus+5gQipQIZF9oLD+rhxpXyBzOOjqdRJvxfGMW7uIvS32ftZWQSYQukgzdkzu9SSdNYIvL2WQ/GSsiOX+zNjF0nO5xYqCO5erZW4Dj3D9wfoZsTL0B1cX3g5t/T/HTi9saTvyxADPvUENv3V6SR3ljkp3aIBPQR7G7+17AywNUVG+POZuESAr1LUMcnfMtJbTVLG91aD7GFTEyZjYrply4Nq/R6PAONgza5KyGZtacW38YsbhTH0sWcRPlpAXS3k4pQ2zRYbF+2YHOUXA3K9LdYGcF57YWfN+MbH4k70giN9p5XDHRRLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K7v/Ejw5blmpV+uttpQYPVnZv1JZ79516uHajBHd1Y=;
 b=rha3z/w+vTBluD6Bp1jgbG/gmpKTAGKhoAvE7A2XYhBMZnICGpU9fd01aVrdlSRiWUt1TqTuA5NidgB1YJhmth02ehuZMJ0XqLVNzwUJDiCSeIij2uDfCHeK5STlaY4MnSa8oOr9Khv5nEt80JB92XokpKz3kRY2bvgXmgcRPO/vLyKCOVoipN3sP3abKwgcvguwbNbe+tuRaVGxOE1hLK+iRurxJzHu0r+PwnrRy8CX84G0El8vDzXZiu5pQS3vU74JGpQPbK7RORa20sUFMywiBMqwxJKFahqeKJTeVA48Nrqw4sgjI2TKSTMPZyPK/R8G7VfiTqj6v/SJRag1mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by CH3PR12MB9021.namprd12.prod.outlook.com (2603:10b6:610:173::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.44; Wed, 11 Oct
 2023 17:20:15 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::5bf0:45ee:4656:5975]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::5bf0:45ee:4656:5975%5]) with mapi id 15.20.6863.032; Wed, 11 Oct 2023
 17:20:15 +0000
Date:   Wed, 11 Oct 2023 14:20:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231011172014.GB3952@nvidia.com>
References: <e979dfa2-0733-7f0f-dd17-49ed89ef6c40@nvidia.com>
 <20231010111339-mutt-send-email-mst@kernel.org>
 <20231010155937.GN3952@nvidia.com>
 <ZSY9Cv5/e3nfA7ux@infradead.org>
 <20231011021454-mutt-send-email-mst@kernel.org>
 <ZSZHzs38Q3oqyn+Q@infradead.org>
 <PH0PR12MB5481336B395F38E875ED11D8DCCCA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20231011040331-mutt-send-email-mst@kernel.org>
 <20231011121849.GV3952@nvidia.com>
 <20231011130018-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011130018-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BL1PR13CA0365.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::10) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|CH3PR12MB9021:EE_
X-MS-Office365-Filtering-Correlation-Id: a4757025-4597-4450-c48b-08dbca7e5564
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ltL+D5BvMvO8Arz6nNYXlQCbtbtI8Yc+9BNqc5FPLF4T/TRSeByzafUEN1ma3+DszC2pTiqC+SiLiZmo1JS61Y1doF6AI7Bvdv4ZjKEhAM24ZV2w0Gb0U2px2906siYpfU9ZOmE3NlJMvwyWSv/rNrkdr4EFhygM/Q82Boq7KhkxeY6P1D54MFf+L35BdQkL1gg3m20dDKR5M4NXnhT4HL/Da9lxyrVfpaGi+XEDQKOnzNjTPj72m+U05tdLqxBh2PASpH9EURGX7VVu2OZH7Nw9w1kBXCpH2Id3qgvPd9OVyUOHveBzi62stdU8Oy5gem7EdsAq7V38mS1a7WVju46CKAmLmezaLfeNBfc9Q9cilUtHJ5Fh9vg1FT5vaW71yAtCTdqs45Y5jHTHqspR69a5wU+g+/agTiJVZVLq8siTnsXe8KNZlnmW2AqwikYM821/54QQxg3Bjmx50vuY1LY/XX51Mh5XOti8VqNlO0aNYxFVT1JnuGxgPxSn2NeyQUZNVJ2nmDZVv18ZeBiLhvvaLSYbfK/V5D8nc0kmMI5Sjv/4T5nDjn8vj1N7n8O4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(5660300002)(41300700001)(8676002)(8936002)(4326008)(33656002)(86362001)(2906002)(4744005)(107886003)(1076003)(2616005)(478600001)(6486002)(6506007)(6512007)(36756003)(26005)(316002)(6916009)(66476007)(66556008)(54906003)(38100700002)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6wSPfDFBbLsm6gNOuBK2/62DuiRTAu2m8JZX3Bjl3ciUmuHWzJtoUpfPV95y?=
 =?us-ascii?Q?Ir14zyv/qKGrlPEdRFn8HumURMsdkQnf1YRViE18zMSuvCsY4xG+1qDbcCYK?=
 =?us-ascii?Q?UD1Gbq19JRcBimhwmwwEk23SQgsKsjYzJhnVaN7q1xC7j6ni/P8HOT1zqfSa?=
 =?us-ascii?Q?TWBATQuQ5fEBAjRnbESBO6snv/U58nhui3HHzf+0SM1/fTkViOK/lL4wV8hO?=
 =?us-ascii?Q?7rypfUlC6CjoprXI+V58NGzhSnc7jmo2J45Ov5v0NstCUVQw1ZeDKydffybo?=
 =?us-ascii?Q?ZK9faHYDClmkWWU7v9ayt4dOrR3K9gLmf3MTyukfNDBRetNvhhgdCfE78Z48?=
 =?us-ascii?Q?xmZ0ZtrN4CNyR199V8qoB6hLdRttAEGcWskzoSiEqEdB9IVXS7YuSr9o3vl6?=
 =?us-ascii?Q?hoLc8sBhGwdaYbWoVfCQNLmJgtGBsNX559JmfAEv4Par9eo1YSv+caZL/XiV?=
 =?us-ascii?Q?Ga+vkjVuEj4WPuh2vAfHnIZwOMvXwtEfyIYVBFEBnn83eglJGPohhjct8vdm?=
 =?us-ascii?Q?nCkePswyuHhIaoVN3J+TCu2Fp+2m82YlmFNFPAH7l4TQXJP4r2Zc48X1Y0+x?=
 =?us-ascii?Q?43K7PqwMOeCSqUVmBzo/WV+lindA2aKkAp91R3v7BqtE/isF4bkSQ53enuAa?=
 =?us-ascii?Q?U5YDhey9K0m/NfcXZIT77M7WhZdm3u+S+zOELRmlzMTY8wIOldSZzYWlRis5?=
 =?us-ascii?Q?WHDE9rUrsVvWzsHr+yccSAoIfbVniH5n5S1kTBuBVNcZE1ozNaj2oD+UV8Yo?=
 =?us-ascii?Q?NY+mTgo1+UsdlFvp7JmOeo3vAypensnf3V7b3bms1qVos3TZAcJBggs8mksu?=
 =?us-ascii?Q?0Bp45CspGvPGwyvcrBE4J9+qEwYeJ5iwB3puxSDkiy9O2YS+XxXJ00CZpE7k?=
 =?us-ascii?Q?/RWAXP/ae2zfBxBlKS4Kdx7QdkLWZ66FRW18tQMZl1EodDbQj/bytwe3Gc8c?=
 =?us-ascii?Q?kj8WLtIJRQer0jmlg784TopyLUGYTcG9YGJqs6oqe2JZRvt8aRk6mcosZc25?=
 =?us-ascii?Q?H4nFTVkcXm6nfTjBCrrtbdGrbCLOUwUD4JX+HBz1EXhHhyBaWQOZRB97VuBI?=
 =?us-ascii?Q?avX55uBfFs/wstX32lxxfmzPlDbAALOIAUuDzALx/PEdcyNsN95VjzQgAehv?=
 =?us-ascii?Q?pUUoA2t0CHMy6XNr2e16PQh2ACDVInIg6qOLha5Ouek7P7C/Nnz61q6ahtSP?=
 =?us-ascii?Q?ORhFuEFNP1CBtqGeyD8nVbeLhPt9m1JYwXChIKkoW7jLgR76TH/syackVFLB?=
 =?us-ascii?Q?45iuvQYPRb2fXhcu+EFoqzxps1+H9CCv8e/NEvhJwzkM8uTqNvHmrYa/ZRAz?=
 =?us-ascii?Q?diG3AhhJ42oxbodmRl5PgAXOpQW9dyKib22rx1KJjHItwULOvrsUmH9DWghb?=
 =?us-ascii?Q?IFuEp6IO/4q0qJ5hSaQpGqet5Rslw/JwAyxYbW+2IkLGq+mprz+3ru5/kl6y?=
 =?us-ascii?Q?+a6GD1vHCmwrvd12Cl/KDhwwoZEUQ73jK42qL82n4p9Gs3ZLfS1BqTH9v24k?=
 =?us-ascii?Q?2+KYF2rdB3GJkYvm5z5GA+Ol/JiDycQc+0+q0yu3rLGAkmERcWeNMK2oHstM?=
 =?us-ascii?Q?lRLdk4sx+ZBYc51/qChqZN6DDebQyiSt7kHCL4e/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4757025-4597-4450-c48b-08dbca7e5564
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 17:20:15.1453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hqqbZDkoEf4sHiiHMoRFsxulnSxMtICUEJTK/zn3vCVJk8GWiOyU7TzsZ8S9XMJG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9021
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 11, 2023 at 01:03:09PM -0400, Michael S. Tsirkin wrote:
> On Wed, Oct 11, 2023 at 09:18:49AM -0300, Jason Gunthorpe wrote:
> > The simple way to be sure is to never touch the PCI function that has
> > DMA assigned to a VM from the hypervisor, except through config space.
> 
> What makes config space different that it's safe though?

Hypervisor fully mediates it and it is not accessible to P2P attacks.

> Isn't this more of a "we can't avoid touching config space" than
> that it's safe? The line doesn't look that bright to me -
> if there's e.g. a memory area designed explicitly for
> hypervisor to poke at, that seems fine.

It is not.

Jason 
