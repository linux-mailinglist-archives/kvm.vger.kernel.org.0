Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7F66D13C3
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjC3Xwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbjC3Xwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:52:34 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DBB193;
        Thu, 30 Mar 2023 16:52:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JH1YNuUIfQ9D2frzrmn4DjJbPT7y0QskcdifNx9+q/Rw4yUP7x0/n8GLSlqlx2WH+IxxrR+KhuVJKAb8uLKqgfZf7aZbfp/qsgJIir+3QPAM2wAgFDcvDJ5o3/eP1RJNnPc3z0EKN1IFIb9csIG30OC0Pdz/5XjYLYkrhae4jmkLCAAkXtFancych9Om7uBauWPnKW1kXDWoFOCdnBZWPq6meu4WC2of1Brq9SvPNS6KlnrAd1aUEnfplQfE+BTv6BUGekYACbdNxfBcFvVV+BpqAlFlshyJoYav70D2+3vCL0g/i1bL40t/xGORPuywQTsYKfQK8kcIZSZZjDwNgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gib7n6ea4hrhto9cKRxcLUauk9vb+kF+XLzgMNO5KPo=;
 b=EDfpG0ez36l6zwTXOIFqiChioi70KwlixwOQCM2VKcW8FXjfp5a8En/sY6r+g4BdfjJYFJkLBQ/s+D+rAGHMv8OEhfuePc+Da974UnOs1rFHn8huc6n4MDB9g3LZGG99mjSnHQq2rP7feloq+8TyKdcHED//uCXYm2POXMY1mTelC0jTM9ud8tkB9GfTJ7wN8RQ/55l9ZutpfMe5gC+JcfrdWac+3HjVgPczed4gQLt1ORD4gJGyjcYivw3KcI4k946JZRqDoucov+sNuBB9W2mVM03qZDj8J5Mwpz4+vYf2PTegY6vwYrSfsqTlOd/phO8hi6EgmUVPaY4sV1m8tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gib7n6ea4hrhto9cKRxcLUauk9vb+kF+XLzgMNO5KPo=;
 b=nqsoHk7sg0CsS/6qg/3L/83DGXioUZC++rHn2yevKHh4a3o2Ubl45mZEZj6njbnJW6e5RE6T6Ym6vaJ/DU7SFRqbyNGaCJKxPQ6Sl0mWZiEQyvWhfAYHy1gGvy3Iu5lLNUQFY5HJE9fIIqKuo7w1OTpV2Op7VmtiGeUiMBb6zHXIbECXykxj6zYazEifX+s4hgJKPofNOc+Q9v8HOgN6PJBQKMpizqevYCXz8Bgh2kj10yu+ZfNTxTnGLPUDhib213RwI4VwoP0MI+I0vxJ/o/8KSJkMfXrUa+NOfb1qmMxCB696wJjGqV087qR+g5vWMATha2xcP4ZqloV+BPW4kg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5091.namprd12.prod.outlook.com (2603:10b6:610:be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 23:52:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 23:52:30 +0000
Date:   Thu, 30 Mar 2023 20:52:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v8 10/24] vfio: Make vfio_device_open() single open for
 device cdev path
Message-ID: <ZCYgvO7STvLhYVeW@nvidia.com>
References: <20230327094047.47215-1-yi.l.liu@intel.com>
 <20230327094047.47215-11-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327094047.47215-11-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0374.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5091:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b0f4269-540b-40a5-87bf-08db3179d2b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xLw8E42+k0CJRXv5eJFo7o3kAvJTxhlcq0HoOwTL9EcmA6bM2uq3oeXO3en31XizUtbFn2pTgIt27/5w1WBr0Ss8+8AD2Eu/FZr4CS/TCoeqdIzLdQrAhyxUqJ0NJHbNH3Ch7O4hm4shJ2j1dygqPPb0UUIXIW6jyVNam9sMDjHcuPdAKplV/nRJDR/MBk9K9jE0qyuiuikQGDGlbR7bAo9ybhRmRqWLgCSIZZPdtKbdzg/kYFGjA/FoMxV0/X+5zNWuCFu+2FvMUVv/0xhCoFlSLfPH+yljtE2HBTklNGS2u3Xn+wjdv078oQIlgk4LU9G2LBvMxEhJ5JLIInrt9Kya1Ze6FpYddgg8g/VocogA5radI3Uz+nNCCsRsQJLFb/EyNuTDgsVeHDxQXT62fXZcEvJsKiPtJzbQEgThv1/F0s4Z5p1mossD02HS+fbbbfccAy8bcrnyfOFNtSZYU1+WlHT6xjTR8DbiUzh6VlzY51rKxAIsleVOcoL/ACVaadAdLtsXO7KtalQqiz9v0AHNvlVXFae/lAwchLz1fOs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(451199021)(8936002)(26005)(6512007)(6506007)(41300700001)(83380400001)(66476007)(316002)(6916009)(478600001)(66946007)(4326008)(6486002)(8676002)(2616005)(7416002)(5660300002)(186003)(66556008)(86362001)(2906002)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QX22BtKZNiimRwFBDvuOBWRj1cwuw3N7ARFVD/YIPMpo0y/CmozJvi+cQSdf?=
 =?us-ascii?Q?XNxUoQ8HvZTxaMapDqk4JVKbALAa8vYAVHevIVn8KSTUzu6dQ9170OIc6Vht?=
 =?us-ascii?Q?Q2MSOwx/nLmK+ntM4QKZ2JvXNUfBo7FKc3RX8uAe2a90aoLHRYmnaYn9ZnTf?=
 =?us-ascii?Q?URj/Y3Q6VZOfXdk3QAzY9jNzDw7gqOrkMQL+PQ9BTV72OKjsZGYBPV+4eP/X?=
 =?us-ascii?Q?TNHt0G0aikTpvPQdhur4DxNPxXqkEPGgZWb8Nc5VRnXTJSVIvxgAuZuvyRf2?=
 =?us-ascii?Q?LQ6K7Ndl96U9V+r4Y9KU84T2fy4GHKfD/4xjXNmKH4i6kjZ5+Se0jvBsgaXi?=
 =?us-ascii?Q?JTaoY+6HeRVknOyv3YaNHqnxhCFYb+Uz2fseiffl8+Tdt0Uj5nVQ1wjV4sm/?=
 =?us-ascii?Q?ehJQAkXp+0RBK+ezijfMqsUM2qo0GoJWWzSDbxoFLnSPAEPENZh+RsgDeAEo?=
 =?us-ascii?Q?PhLy9m4owmkjyb1xrzm/tCFmXRDAxKGMUKz+1ntC+G8hYQ7KMd2Hz2aZaCkL?=
 =?us-ascii?Q?UNdkhCCuIXzYzWyx9Fb4iH8JCtky4Pb2HOjzrnQ+yfdZb4a6HVReNE5tWjFq?=
 =?us-ascii?Q?NCUFjPzRniI0nIhJWIDUgVcssXvqXyLT4TXB2ardS7lnYgzpMpi2Lcr/obLa?=
 =?us-ascii?Q?UHuEbRxvT8T9nDeNncqTeVzvwJRb2p818hH4yzpG9zwPw8tw6gpvl2R8MXID?=
 =?us-ascii?Q?qaJ8HoWLdT/gerASiAU9DFAzqI2D26b8TGlSJtMXHa+QvQxTq5Tp99OlaB5D?=
 =?us-ascii?Q?9Oo8Z1Z5HJkZXXQRdtKV6S77+sDX6wSqPSKfdUTiMmFgFtYfuce1VJ8lDtw/?=
 =?us-ascii?Q?T10vb/lFhpMZMufwM3ivQ9VAE6uehEd8XcrQ6orVIViSmdEXyT/g3gt7b2fY?=
 =?us-ascii?Q?Gxn/pukC2SeF6A1tf5zOglzjIPC40YQHx7bpviyRQ0jd2c6B3mY1f5KQC2pW?=
 =?us-ascii?Q?kDf1iX+jpkJoRUK7i0LLhzHut2hG31yLlDbm3O93NNlf0BGgjhbJTBG75Avr?=
 =?us-ascii?Q?xE7SBXX6xMwq6Uygo8pU4nEVh+dXQOAhVPdZUDViLX/YVl8krFZN1FtwECdL?=
 =?us-ascii?Q?lml59zcVpccaIoD2H8/Sh+0zNqAt6NP2mRu7OPuM9HlWX3ac+vyWChzoTvna?=
 =?us-ascii?Q?tfYqUoV5z4R4z5pdCwJZ44Cp1e0+7ceY0C5Nqd6ytLHZ9zzoo5Do/et6hJR9?=
 =?us-ascii?Q?bxJ4daE9omKLIZnxkDqxin5nEbIUWjrXF6CMM8vZu0BIWaGfUw57EKPIp3xd?=
 =?us-ascii?Q?2AtFbczTwkDttbmMoFmJ1X+t1Ua5E6uWn8xjdYdwHLbHUOcDDqr5GQipR1B6?=
 =?us-ascii?Q?dmi8QHcDqujbXE0GGy+om0w7A3woFecyjgG30BIsV9VWDK2EclpBiZ3I23OF?=
 =?us-ascii?Q?QDPGLFpieWZdRIfYbK2OGkPJ9L391LlWaUW0YMWNLjitgExjz/ExXYvQQyXT?=
 =?us-ascii?Q?dycrybMV6wp96N+eWzOECOpsgxpzYLY26k0hVFST8AjHPtFrMH2ki3nO7Vjc?=
 =?us-ascii?Q?V1ku+5paWp9uPRoxZSCk6YibtvhXKTl8uojvg50KJ4Kmvt0zulCU/aqTcspO?=
 =?us-ascii?Q?r+FZX5u5FHW5BO3RSRAeoYc5LbUIs6UNpCrrn++X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b0f4269-540b-40a5-87bf-08db3179d2b5
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:52:29.9909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9QRIZ/M8tFibxROftPdu+1SFe5CI/kRmiLmQdn22S4LGDST8BLyQWZlmzXbVkjUQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5091
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:40:33AM -0700, Yi Liu wrote:
> VFIO group has historically allowed multi-open of the device FD. This
> was made secure because the "open" was executed via an ioctl to the
> group FD which is itself only single open.
> 
> However, no known use of multiple device FDs today. It is kind of a
> strange thing to do because new device FDs can naturally be created
> via dup().
> 
> When we implement the new device uAPI (only used in cdev path) there is
> no natural way to allow the device itself from being multi-opened in a
> secure manner. Without the group FD we cannot prove the security context
> of the opener.
> 
> Thus, when moving to the new uAPI we block the ability of opening
> a device multiple times. Given old group path still allows it we store
> a vfio_group pointer in struct vfio_device_file to differentiate.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c     | 2 ++
>  drivers/vfio/vfio.h      | 2 ++
>  drivers/vfio/vfio_main.c | 7 +++++++
>  3 files changed, 11 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
