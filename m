Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329F45A0542
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 02:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiHYAny (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 20:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiHYAnx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 20:43:53 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04ECA8E0C5
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 17:43:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+kp+gKYNByRelEUxn7zAD5c0PV5gyMJhyqnb5UkmBRocHzT8CK7gmf0l6xIIsC6fBagE+q+w0f/8dZRw+Z99L3FlCHW5Okvm0w4cnuGTC5mmqT66CuvCIREd1NIgHSVf2aRtDyCQThUObrvo1HA6lWLwi5DaVmjWl566NPKjLFeU++w9haUrXbMfx0Za6bKy01EJ3cgpKlxpFN1uR9CmFD6Sw4HrL3/ixVyk/awNQhu4K4YoBqkPHWK5H7H7IrYnlbDUjM2FYmxiZdet+hfmeUdn6KY0eLF75U/iPZfAe64xyof7iCypMgwO+VfEwxu+iurfhg+5Ob9gxC304oENg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/gx9g05Yv7qi9+rRbqbBt2ULHgfga4pGs9Up6n9Vm8=;
 b=Se2SLG3OeRIXYtuIkRNsVJhqzRz4vyluvkWrvSihqtYt7XJuAGJOort0AfXOhXF2FFMsziNCGf5xet3luHQEUB7pQNEUELVkwh7X2whiFXgfUPxxarfTsTWGZw2JI4jd4txChHxgNl66IdKgTsyfL/1NRe9UBTqQR10zkDBNIo2FqBPvKM0pN/vMwwgEwZKw4H8D3YfGn/0TJWXlLjH1qEo/HLoyXyamQLUKxRMSUoiK06n/end4GOB95SV156ehsIoP3LvC2NCvzgzQ/zgqnYKHV8h2pNe+iqFHfMuyii/dljTxUimkWZzKJY/zYmRsQVc3CTPdW00Ntb8cff2OdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/gx9g05Yv7qi9+rRbqbBt2ULHgfga4pGs9Up6n9Vm8=;
 b=To58ndolzzkz7bfkxN5xmQCX1/psgiK4Llcw0Ndz7qsDiPsd/JsVtzarav7JC8WiclUO89e36BKGcZ9NzK/G8MrmRlvODXVITvXuHg8Gu1RXtJpUMoX7jSrkA9HboFEw3vh1Q5F+YOM+7ENkwmiyRaMebnO8j1B8crORGqIDz/RGTT0prxvQ4YBKoLuPggjAvaaHBoXb5mjRQ7r9ZbPflh9esHWuhpzYKcLhYxnScbNsEn9igMcAyCUowlTzN9Ja076TDCy+kEHFL9JeWWeKiICHOQN5gKIuB33Cm2BkeDrcLqVYWTH+lRVUskPVjKF+dax+ciAJupvXwy6h0ylFrA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN9PR12MB5113.namprd12.prod.outlook.com (2603:10b6:408:136::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Thu, 25 Aug
 2022 00:43:49 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%8]) with mapi id 15.20.5546.025; Thu, 25 Aug 2022
 00:43:49 +0000
Date:   Wed, 24 Aug 2022 21:43:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2] vfio: Remove vfio_group dev_counter
Message-ID: <20220825004346.GB4068@nvidia.com>
References: <0-v2-d4374a7bf0c9+c4-vfio_dev_counter_jgg@nvidia.com>
 <BN9PR11MB5276281FEDA2BC42DF67885E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220822123532.49dd0e0e.alex.williamson@redhat.com>
 <BN9PR11MB5276323D5F9515E42CDBCDBD8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220824003808.GE4090@nvidia.com>
 <20220824160201.1902d6c4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824160201.1902d6c4.alex.williamson@redhat.com>
X-ClientProxiedBy: YQBPR0101CA0060.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:1::37) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed3a5025-7ea1-4ae0-d2df-08da8632dffc
X-MS-TrafficTypeDiagnostic: BN9PR12MB5113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wpCqH5HIDGn5KYtRc4uD5I8WLZdNb6jEULtigqq03E8EKzwY0E8bupo+hBBpjgnBEgRADjmUFGRz4ax+qSJBPIOtHR8jgVjvEcDV9qxaxTeZsvVugzooJvu9dOzWQuvxAMi1TfcYYePsC8zXqo7xHs48BPxEYuQbuZXuR6TA5Zayr5YS7YSUXNPjUvQ73TopUoG8MWGeObZ2bFjLkCXhCjUt15VLp1nxbzeoXTatl31XCZYwXFLdbAG0b/MBaKcmuh7NfDXwtUiTuoRyibYpEaXgVmuyeCtC9EtvMrIvSgh1cY+55fDbkKwJEXdLWn7BZu27d5GVwX96VN/svz4UOcKee2S/hQdTxlmPkrNT8x2PqAAr6XyvWX69hGgSJKF9TWpfIpd1k5UaDGPrhqBm033n/g189veZvrGSqGTF3dpNvC/8kPds836sHbtnTpoCieL8x7e4tMio8v1eLJqkqFkuBH1RO8DThTZL1O4vQG4wDgb1C6A7Op0Dyz/YEUTY5u81BUiw4A7kMcJWd4cmwICjmjxbdAtKH6h/iRhXCSGstPu8i59FEoeqCLfNhGQUWMngKF7yGnDoDaDu66ZtwKZHsGjiIE4POMDrHdtmSb73AXinvaFJgo4R6aPnyCf3A6QvMA/beZhSlsXzqsqRSZ/TlHX1yVrjz1MvloUAgE681K/7V/kzwSQMzzNXB7GQtSYRd3C4iw45xEoWp1fX7+75jnL8rRin09WQdNzLUL2MToRyFlwk18aSgIoVjPyIBjM5Y+LpXERKvXcTy3an61gQgupB0XKlX/47JYJb8RKLU1q6/brL2v58oYsg4WqSaURagqF+9EP47V8GnJj/4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(83380400001)(1076003)(2616005)(54906003)(4326008)(6916009)(316002)(66556008)(66476007)(66946007)(8676002)(26005)(6512007)(8936002)(6506007)(41300700001)(966005)(186003)(2906002)(5660300002)(6486002)(33656002)(478600001)(38100700002)(86362001)(6666004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZFG9L1vVryM7xRn7Mg+z+khlTbipExlxlor2KCcdTz/KGurxIBB5zCGEPAT/?=
 =?us-ascii?Q?eD4PtVidUR8KlKaiP2m6QP1KaqFli/A5xq0AUSIrLhUjKYwWBcgNxJi0Lf1/?=
 =?us-ascii?Q?3eyNFhbwQX8fKlOoN91GJvMnR/poq1FgsBUQ4VS+sjX1Q0T86mv+qQTTVOcm?=
 =?us-ascii?Q?GRZIt5vkrr8U3/Nxe65YZ1fAxV8RZy85cQ0NCXp4oyUSFKXxtrwDs537y5tS?=
 =?us-ascii?Q?RjTdyX6fOWxgLrkJn2xw7h0VZR0aAefvJwWzQ1pWGlDOHpPTSpTidZJtIPsT?=
 =?us-ascii?Q?3jcoeE8+QOLlxex0Tsmtjd/T7YjhnOe/s8JBreeYwEZ3BpBstmp9DIN0nLZk?=
 =?us-ascii?Q?50qU02PmQSu14EtKKTcJFnwu/H+JffUG8LWp75mhY2r9KIna1WT8ODCqk+NU?=
 =?us-ascii?Q?w5+RDTC1VjZH1cjzBmKCkP+QLPYlq6Um7UaVnsaJ4FkYrMD/qv9hCiBtMBGI?=
 =?us-ascii?Q?2nuVfaLCTDwVy9oZ+V1msW/FWr5djSoFrcGPSxiMAWIgg8iCnEbRZTYDPHk0?=
 =?us-ascii?Q?cCxOXpQas+NgYg5HukS98o21z8PorNLopvh8S3osfuDGV0CZWOBRxI/PilOG?=
 =?us-ascii?Q?Km9ynhPJ9eCcBmgoyyB6afH3gKRW+eo3Ok68iYLmUXruwmazX5zrcin3EIRE?=
 =?us-ascii?Q?NYRZUNC6XzgduMorBQrrnfKoQtRZKW6RPmcwm7ae4j9QHn1Hpx9pZZ2YgURE?=
 =?us-ascii?Q?Awr8n86ozLTl2a94Ozd1PlKRk6bVzec9zgxRD0yKm9bUlGXtoFgY/lzIDCHs?=
 =?us-ascii?Q?H7RAlOxT/8Ca8tGTLFxMO4siyvl26cYmvVNeLoVJ8iD4Ajh3xDDw7fn/zMhr?=
 =?us-ascii?Q?9FcCjPNGleP549cJNDkNU/uxMUCGcLI5P+nayre8otBf1yTwdRy417+euKSv?=
 =?us-ascii?Q?gnQw0ibBql/+rei+VRZgkx3b6lwM/I6WLwDRrwtOsBA+ev5/S7g3T4JlEhju?=
 =?us-ascii?Q?O8sVTpyUHvfooz84xad+YXEvdJIbcsWfTNNTtCol7oKIFBx8hy2+0h0fDeHz?=
 =?us-ascii?Q?gGCrjuuAGbAImQn02Uuq7prrnJ/8za8BRF/SNyuvc3V1tvyqrCqAjJOh/yvb?=
 =?us-ascii?Q?Qi01amcyaNmd2m/P1earifvx2CBUP24xD5QXyLeetvCnL+TB4YHPoZ1ZrOf8?=
 =?us-ascii?Q?v7QNiAcVtk7vQcBb7dj5aqEhPcic37n8jEGLqqNHCgCxBfXwyRqWlFajI3H9?=
 =?us-ascii?Q?bVN87nVtQ9yc/FBlM+ZanFUnsKLPCGCSF/UXummUjW8VdtWcTm2d94JVN2VR?=
 =?us-ascii?Q?UqFQRarSqom5ZQE5ETiWWnkZNKBzEANHPDn89T9MT3BvkBB3lTVa7dgj8Yah?=
 =?us-ascii?Q?DCb1SsClf1Vk/3NpDC31MTctwlhpr/EjCzGo00Pfujh5eD6dkpVO+2gqXH/k?=
 =?us-ascii?Q?FGXy2XtC5IxzlMl+fom1IJwxQjOmbLuA0128riHUISvLzKR8zFfaP+yYTlKK?=
 =?us-ascii?Q?OomYD8ZATnHB7U4X4uZ+Emv3w92d9G31/pXULtf5U1SplMaI6J2yWYSsMOda?=
 =?us-ascii?Q?tAdg6cMN8WfXxZoeLUbJJ9DivNHfufVUEuH2TnjwcP0w+DyEtx3R5MU96OQ9?=
 =?us-ascii?Q?C4z9sOchOyTY7MTAAhcFZvLoChUJpkv91ywx0P/2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3a5025-7ea1-4ae0-d2df-08da8632dffc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 00:43:49.2596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMrx+pepjXslpCDQNxZLlY7JhXAUw6TI3x9CPP5K5FguRBL+ByL4sOM1Rwn4t1Om
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5113
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 24, 2022 at 04:02:01PM -0600, Alex Williamson wrote:
> On Tue, 23 Aug 2022 21:38:08 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> > So, I would prefer to comment it like this and if someone comes with a
> > driver that wants to use it in some other way they have to address
> > these problems so it works generally and correctly. I don't want to
> > write more code to protect against something that auditing tells us
> > doesn't happen today.
> > 
> > The whole thing should naturally become fixed fairly soon, as once we
> > have Yishai and Joao's changes there will be no use for the dirty
> > tracking code in type1 that is causing this problem.
> 
> I assume this is referring to the DMA logging interface and
> implementation for mlx5[1], but I don't see anyone else getting on board
> with that proposal (or reviewing).

We have a large group pushing in this direction together.

Yishai implemented the API in vfio for mlx5 showing how a device
centric tracker and work. In my research I found no other groups
besides NVIDIA planning to do device tracking, so it is not surprising
his series has been as well reviewed as it probably will be. The other
use cases inside NVIDIA are also happy with this design.

Joao implemented the similar API in iommufd for the system iommu, and
did this with hisilicon's support because they need it for their
merged hisilicon's vfio driver.

https://github.com/jpemartins/linux/commit/7baa3d51417419690aa8b57f6cc58be7ab3a40a9

I understand Intel to use this with IDXD as well..

So, basically everyone who is working in the migratable VFIO device
space is on board with, and contributing to, this plan right now.

> IOMMU DMA logging, so the above seems a bit of a bold claim.  Do we
> expect system IOMMU logging flowing through this device feature or will
> there be an interface at the shared IOMMU context level? 

Joao's draft series shows the basic idea:

https://github.com/jpemartins/linux/commit/fada208468303a3a6df340ac20cda8fc1b869e7a#diff-4318a59849ffa0d4aa992221863be15cde4c01e1f82d2f6d06337cfe6dd316afR228

We are working this all through in pieces as they become
ready.

> Do we expect mdev drivers supporting migration to track their dirty
> iovas locally and implement this feature?

Assuming we ever get a SW only device that can do migration..

I would expect there to be a library to manage the dirty bitmap
datastructure and the instance of that datastructure to be linked to
the IOAS the device is attached to. Ie one IOAS one datastructure.

The additional code in the mdev driver would be a handful of lines.

If we want it to report out through the vfio or through a iommufd API
is an interesting question I don't have a solid answer to right
now. Either will work - iommufd has a nice hole to put a "sw page
table" object parallel to the "hw page table" object that the draft
series put the API on. The appeal is it makes the sharing of the
datastructure clearer to userpsace.

The trouble with mlx5 is there isn't a nice iommufd spot to put a
device tracker. The closest is on the device id, but using the device
id in APIs intended for "page table" id's is wonky. And there is no
datatructure sharing here, obviously. Not such a nice fit.

Jason
